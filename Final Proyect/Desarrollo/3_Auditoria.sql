-- Ensure the audit folder exists: C:\SQLAuditLogs\
-- Note: This must be created manually on the server with appropriate permissions for SQL Server.

USE master;
GO

-- Drop existing server audit if it exists
IF EXISTS (SELECT * FROM sys.server_audits WHERE name = 'MYBOOK_Audit')
    BEGIN
        ALTER SERVER AUDIT MYBOOK_Audit WITH (STATE = OFF);
        DROP SERVER AUDIT MYBOOK_Audit;
    END;
GO

-- Create Server Audit
CREATE SERVER AUDIT MYBOOK_Audit
    TO FILE (
    FILEPATH = 'C:\SQLAuditLogs\',
    MAXSIZE = 50 MB,
    MAX_ROLLOVER_FILES = 10,
    RESERVE_DISK_SPACE = OFF
    )
    WITH (
    QUEUE_DELAY = 1000,
    ON_FAILURE = CONTINUE
    );
GO

-- Enable Server Audit
ALTER SERVER AUDIT MYBOOK_Audit WITH (STATE = ON);
GO

USE MYBOOK;
GO

-- Drop existing database audit specification if it exists
IF EXISTS (SELECT * FROM sys.database_audit_specifications WHERE name = 'MYBOOK_Database_Audit')
    BEGIN
        ALTER DATABASE AUDIT SPECIFICATION MYBOOK_Database_Audit WITH (STATE = OFF);
        DROP DATABASE AUDIT SPECIFICATION MYBOOK_Database_Audit;
    END;
GO

-- Create Database Audit Specification
CREATE DATABASE AUDIT SPECIFICATION MYBOOK_Database_Audit
    FOR SERVER AUDIT MYBOOK_Audit
    ADD (SELECT, INSERT, UPDATE, DELETE ON DATABASE::MYBOOK BY PUBLIC),
ADD (SCHEMA_OBJECT_CHANGE_GROUP),
ADD (DATABASE_OBJECT_CHANGE_GROUP),
ADD (AUDIT_CHANGE_GROUP)
WITH (STATE = ON);
GO
