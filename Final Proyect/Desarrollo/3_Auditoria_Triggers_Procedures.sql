

USE MYBOOK;
GO

-- Drop and recreate Audit_Events table
IF OBJECT_ID('dbo.Audit_Events', 'U') IS NOT NULL
    DROP TABLE dbo.Audit_Events;
GO

CREATE TABLE dbo.Audit_Events (
      AuditID INT IDENTITY(1,1) PRIMARY KEY,
      EventTime DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
      EventType NVARCHAR(128),
      LoginName NVARCHAR(128),
      ObjectName NVARCHAR(128),
      Statement NVARCHAR(MAX),
      DatabaseName NVARCHAR(128),
      SchemaName NVARCHAR(128),
      SessionID INT,
      Success BIT,
      ErrorMessage NVARCHAR(4000)
);
GO

-- Trigger for Users table
IF OBJECT_ID('TR_Users_Audit', 'TR') IS NOT NULL
    DROP TRIGGER TR_Users_Audit;
GO

CREATE TRIGGER TR_Users_Audit
    ON dbo.Users
    AFTER INSERT, UPDATE, DELETE
    AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EventType NVARCHAR(128);
    DECLARE @Statement NVARCHAR(MAX);

    SET @EventType =
            CASE
                WHEN EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) THEN 'UPDATE'
                WHEN EXISTS (SELECT * FROM inserted) THEN 'INSERT'
                WHEN EXISTS (SELECT * FROM deleted) THEN 'DELETE'
                END;

    SELECT @Statement = event_info
    FROM sys.dm_exec_input_buffer(@@SPID, NULL);

    INSERT INTO dbo.Audit_Events (
        EventType,
        LoginName,
        ObjectName,
        Statement,
        DatabaseName,
        SchemaName,
        SessionID,
        Success
    )
    VALUES (
               @EventType,
               ORIGINAL_LOGIN(),
               'Users',
               @Statement,
               DB_NAME(),
               SCHEMA_NAME(),
               @@SPID,
               1
           );
END;
GO

-- Trigger for Books table
IF OBJECT_ID('TR_Books_Audit', 'TR') IS NOT NULL
    DROP TRIGGER TR_Books_Audit;
GO

CREATE TRIGGER TR_Books_Audit
    ON dbo.Books
    AFTER INSERT, UPDATE, DELETE
    AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EventType NVARCHAR(128);
    DECLARE @Statement NVARCHAR(MAX);

    SET @EventType =
            CASE
                WHEN EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) THEN 'UPDATE'
                WHEN EXISTS (SELECT * FROM inserted) THEN 'INSERT'
                WHEN EXISTS (SELECT * FROM deleted) THEN 'DELETE'
                END;

    SELECT @Statement = event_info
    FROM sys.dm_exec_input_buffer(@@SPID, NULL);

    INSERT INTO dbo.Audit_Events (
        EventType,
        LoginName,
        ObjectName,
        Statement,
        DatabaseName,
        SchemaName,
        SessionID,
        Success
    )
    VALUES (
               @EventType,
               ORIGINAL_LOGIN(),
               'Books',
               @Statement,
               DB_NAME(),
               SCHEMA_NAME(),
               @@SPID,
               1
           );
END;
GO

-- Stored Procedure: sp_GetRecentAuditEvents
IF OBJECT_ID('sp_GetRecentAuditEvents', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetRecentAuditEvents;
GO

CREATE PROCEDURE sp_GetRecentAuditEvents
    @DaysBack INT = 7,
    @EventType NVARCHAR(128) = NULL
AS
BEGIN
    SELECT
        AuditID,
        EventTime,
        EventType,
        LoginName,
        ObjectName,
        Statement,
        DatabaseName,
        SchemaName,
        SessionID,
        Success,
        ErrorMessage
    FROM dbo.Audit_Events
    WHERE EventTime >= DATEADD(DAY, -@DaysBack, SYSDATETIME())
      AND (@EventType IS NULL OR EventType = @EventType)
    ORDER BY EventTime DESC;
END;
GO

-- Stored Procedure: sp_AuditEventSummary
IF OBJECT_ID('sp_AuditEventSummary', 'P') IS NOT NULL
    DROP PROCEDURE sp_AuditEventSummary;
GO

CREATE PROCEDURE sp_AuditEventSummary
    @StartDate DATETIME2 = NULL,
    @EndDate DATETIME2 = NULL
AS
BEGIN
    SET @StartDate = COALESCE(@StartDate, DATEADD(DAY, -30, SYSDATETIME()));
    SET @EndDate = COALESCE(@EndDate, SYSDATETIME());

    SELECT
        EventType,
        LoginName,
        COUNT(*) AS EventCount,
        MIN(EventTime) AS FirstEvent,
        MAX(EventTime) AS LastEvent
    FROM dbo.Audit_Events
    WHERE EventTime BETWEEN @StartDate AND @EndDate
    GROUP BY EventType, LoginName
    ORDER BY EventCount DESC;
END;
GO

-- Stored Procedure: sp_GetFailedAuditEvents
IF OBJECT_ID('sp_GetFailedAuditEvents', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetFailedAuditEvents;
GO

CREATE PROCEDURE sp_GetFailedAuditEvents
@DaysBack INT = 7
AS
BEGIN
    SELECT
        AuditID,
        EventTime,
        EventType,
        LoginName,
        ObjectName,
        Statement,
        ErrorMessage
    FROM dbo.Audit_Events
    WHERE Success = 0
      AND EventTime >= DATEADD(DAY, -@DaysBack, SYSDATETIME())
    ORDER BY EventTime DESC;
END;
GO

-- View: vw_AuditOverview
IF OBJECT_ID('vw_AuditOverview', 'V') IS NOT NULL
    DROP VIEW vw_AuditOverview;
GO

CREATE VIEW vw_AuditOverview
AS
SELECT
    EventType,
    COUNT(*) AS TotalEvents,
    COUNT(DISTINCT LoginName) AS UniqueUsers,
    MAX(EventTime) AS LastEvent
FROM dbo.Audit_Events
GROUP BY EventType;
GO
