


-- Cambiar al contexto de la base de datos master
USE master;
GO

-- Verificar si existe y está habilitado el servidor de auditoría
IF EXISTS (SELECT 1 FROM sys.server_audits WHERE name = 'MYBOOK_Audit')
    BEGIN
        IF EXISTS (
            SELECT 1 FROM sys.server_audits
            WHERE name = 'MYBOOK_Audit' AND is_state_enabled = 1
        )
            PRINT N'Auditoría del servidor habilitada.';
        ELSE
            PRINT N'Auditoría del servidor encontrada pero deshabilitada.';
    END
ELSE
    PRINT N'No se encontró la auditoría del servidor.';
GO

-- Verificar si existe y está habilitada la especificación de auditoría de base de datos
IF EXISTS (SELECT 1 FROM sys.database_audit_specifications WHERE name = 'MYBOOK_Database_Audit')
    BEGIN
        IF EXISTS (
            SELECT 1 FROM sys.database_audit_specifications
            WHERE name = 'MYBOOK_Database_Audit' AND is_state_enabled = 1
        )
            PRINT N'Especificación de auditoría de base de datos habilitada.';
        ELSE
            PRINT N'Especificación de auditoría encontrada pero deshabilitada.';
    END
ELSE
    PRINT N'No se encontró la especificación de auditoría.';
GO

-- Cambiar al contexto de la base de datos MYBOOK
USE MYBOOK;
GO

-- Verificar si existe la tabla de auditoría
IF OBJECT_ID('dbo.Audit_Events', 'U') IS NOT NULL
    PRINT 'La tabla Audit_Events existe.';
ELSE
    PRINT N'No se encontró la tabla Audit_Events.';
GO

-- Insertar datos de prueba para activar las auditorías (triggers)
BEGIN TRY
    DECLARE @pwd CHAR(64) = REPLICATE('x', 64);
    DECLARE @fecha DATETIME = SYSDATETIME();

    EXEC dbo.Users_Insert
         'UsuarioAuditoria', @pwd, 'auditoria@ejemplo.com', 0, 'VW', 'TP', '2025-12-01';

    EXEC dbo.Books_Insert
         N'Libro Auditoría', N'Prueba auditoría', '9781234567899', 1, 0, @fecha, '2025-05-21', 'EN', 'FA', 1;

    PRINT 'Inserciones de prueba completadas.';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH
GO

-- Consultar entradas recientes en la tabla de auditoría
SELECT TOP 20
    EventTime, EventType, ObjectName, Statement, LoginName
FROM dbo.Audit_Events
WHERE EventTime >= DATEADD(MINUTE, -10, SYSDATETIME())
ORDER BY EventTime DESC;
GO

-- Consultar entradas recientes del archivo de auditoría del sistema (si está habilitado)
SELECT TOP 20
    event_time, action_id, database_name, object_name, statement
FROM sys.fn_get_audit_file('C:\SQLAuditLogs\*', NULL, NULL)
WHERE event_time >= DATEADD(MINUTE, -10, GETDATE())
ORDER BY event_time DESC;
GO

-- Mostrar eventos fallidos de auditoría
EXEC dbo.sp_GetFailedAuditEvents @DaysBack = 1;
GO

-- Eliminar los registros de prueba creados
DELETE FROM dbo.Users WHERE Name = 'UsuarioAuditoria';
DELETE FROM dbo.Books WHERE Name = N'Libro Auditoría';
GO

-- Ver auditorías configuradas
SELECT * FROM vw_AuditOverview;

SELECT * FROM sys.server_audits;

SELECT * FROM sys.database_audit_specifications;
