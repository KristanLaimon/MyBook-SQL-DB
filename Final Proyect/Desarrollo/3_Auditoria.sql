USE master;
GO

-- Crear directorio para los registros de auditoría (asegúrate de que exista en el servidor)
-- Ejemplo: C:\AuditLogs\MYBOOK\
-- Nota: El directorio debe crearse manualmente con permisos adecuados para la cuenta del servicio de SQL Server

-- Crear Auditoría a Nivel de Servidor
IF EXISTS (SELECT * FROM sys.server_audits WHERE name = 'MYBOOK_Server_Audit')
ALTER SERVER AUDIT MYBOOK_Server_Audit WITH (STATE = OFF);
DROP SERVER AUDIT MYBOOK_Server_Audit;
GO
CREATE SERVER AUDIT MYBOOK_Server_Audit
    TO FILE (
    FILEPATH = N'C:\AuditLogs\MYBOOK\',
    MAXSIZE = 100 MB,
    MAX_ROLLOVER_FILES = 10,
    RESERVE_DISK_SPACE = OFF
    )
    WITH (
    QUEUE_DELAY = 1000, -- Retraso de 1 segundo para escritura asíncrona
    ON_FAILURE = CONTINUE, -- Continuar si hay errores de escritura
    AUDIT_GUID = 'c2a3b4c5-d6e7-4f8a-9b0c-d1e2f3a4b5c6'
    );
GO
-- Habilitar la auditoría del servidor
ALTER SERVER AUDIT MYBOOK_Server_Audit WITH (STATE = ON);
GO

-- Crear Especificación de Auditoría del Servidor
IF EXISTS (SELECT * FROM sys.server_audit_specifications WHERE name = 'MYBOOK_Server_Audit_Spec')
ALTER SERVER AUDIT SPECIFICATION MYBOOK_Server_Audit_Spec WITH (STATE = OFF);
DROP SERVER AUDIT SPECIFICATION MYBOOK_Server_Audit_Spec;
GO
CREATE SERVER AUDIT SPECIFICATION MYBOOK_Server_Audit_Spec
    FOR SERVER AUDIT MYBOOK_Server_Audit
    ADD (SUCCESSFUL_LOGIN_GROUP),
    ADD (FAILED_LOGIN_GROUP),
    ADD (SERVER_ROLE_MEMBER_CHANGE_GROUP),
    ADD (DATABASE_ROLE_MEMBER_CHANGE_GROUP)
    WITH (STATE = ON);
GO

-- Cambiar a la base de datos MYBOOK
USE MYBOOK;
GO

-- Crear Especificación de Auditoría de la Base de Datos
IF EXISTS (SELECT * FROM sys.database_audit_specifications WHERE name = 'MYBOOK_Database_Audit_Spec')
ALTER DATABASE AUDIT SPECIFICATION MYBOOK_Database_Audit_Spec WITH (STATE = OFF);
DROP DATABASE AUDIT SPECIFICATION MYBOOK_Database_Audit_Spec;
GO
CREATE DATABASE AUDIT SPECIFICATION MYBOOK_Database_Audit_Spec
    FOR SERVER AUDIT MYBOOK_Server_Audit
    ADD (SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo BY PUBLIC), -- Auditar DML en todas las tablas
ADD (SCHEMA_OBJECT_CHANGE_GROUP) -- Auditar cambios DDL
WITH (STATE = ON);
GO

-- Procedimiento para Consultar Registros de Auditoría
IF OBJECT_ID('sp_Audit_Review', 'P') IS NOT NULL
    DROP PROCEDURE sp_Audit_Review;
GO
CREATE PROCEDURE sp_Audit_Review
    @StartDate DATETIME2 = NULL,
    @EndDate DATETIME2 = NULL,
    @EventType NVARCHAR(100) = NULL
AS
BEGIN
    DECLARE @ErrorMsg NVARCHAR(4000);

    BEGIN TRY
        -- Establecer valores predeterminados
        SET @StartDate = COALESCE(@StartDate, DATEADD(DAY, -7, GETDATE()));
        SET @EndDate = COALESCE(@EndDate, GETDATE());

        -- Consultar registros de auditoría
        SELECT
            event_time AS FechaEvento,
            action_id AS IDAccion,
            statement AS DeclaracionSQL,
            server_principal_name AS NombreUsuario,
            database_name AS NombreBaseDatos,
            object_name AS NombreObjeto,
            additional_information AS InformacionAdicional
        FROM sys.fn_get_audit_file('C:\AuditLogs\MYBOOK\*.sqlaudit', NULL, NULL)
        WHERE event_time BETWEEN @StartDate AND @EndDate
          AND (@EventType IS NULL OR action_id = @EventType)
        ORDER BY event_time DESC;

        PRINT 'Consulta de registros de auditoría completada.';
    END TRY
    BEGIN CATCH
        SELECT @ErrorMsg = ERROR_MESSAGE();
        PRINT 'Error en sp_Audit_Review: ' + @ErrorMsg;
        THROW;
    END CATCH
END;
GO

-- Crear Vista para Revisión Simplificada de Registros de Auditoría
IF OBJECT_ID('vw_Audit_Recent_Events', 'V') IS NOT NULL
    DROP VIEW vw_Audit_Recent_Events;
GO
CREATE VIEW vw_Audit_Recent_Events
AS
SELECT TOP 1000
    event_time AS FechaEvento,
    action_id AS TipoEvento,
    statement AS ConsultaSQL,
    server_principal_name AS Usuario,
    database_name AS BaseDatos,
    object_name AS Objeto,
    additional_information AS Detalles
FROM sys.fn_get_audit_file('C:\AuditLogs\MYBOOK\*.sqlaudit', NULL, NULL)
WHERE event_time >= DATEADD(DAY, -30, GETDATE())
ORDER BY event_time DESC;
GO

-- Trabajo de SQL Server Agent para Alertas de Auditoría Crítica
USE msdb;
GO
IF EXISTS (SELECT * FROM dbo.sysjobs WHERE name = N'MYBOOK_Audit_Critical_Alerts')
    EXEC dbo.sp_delete_job @job_name = N'MYBOOK_Audit_Critical_Alerts';
GO
EXEC dbo.sp_add_job
     @job_name = N'MYBOOK_Audit_Critical_Alerts';
GO
EXEC dbo.sp_add_jobstep
     @job_name = N'MYBOOK_Audit_Critical_Alerts',
     @step_name = N'Check Critical Audit Events',
     @subsystem = N'TSQL',
     @command = N'
        DECLARE @EventCount INT;
        SELECT @EventCount = COUNT(*)
        FROM sys.fn_get_audit_file(''C:\AuditLogs\MYBOOK\*.sqlaudit'', NULL, NULL)
        WHERE event_time >= DATEADD(HOUR, -1, GETDATE())
            AND action_id IN (''LGIF'', ''DR'', ''AL'') -- Failed Logins, DROP, ALTER
        IF @EventCount > 0
        BEGIN
            EXEC msdb.dbo.sp_send_dbmail
                @profile_name = ''SQLServerMailProfile'', -- Configurar previamente
                @recipients = ''admin@example.com'',
                @subject = ''Alerta: Eventos Críticos de Auditoría en MYBOOK'',
                @body = ''Se detectaron eventos críticos en la auditoría de MYBOOK. Revisar inmediatamente.'';
        END',
     @database_name = N'master';
GO
EXEC dbo.sp_add_jobschedule
     @job_name = N'MYBOOK_Audit_Critical_Alerts',
     @name = N'Hourly_Critical_Check',
     @freq_type = 4, -- Diario
     @freq_subday_type = 8, -- Cada hora
     @freq_subday_interval = 1, -- Cada 1 hora
     @active_start_time = 0; -- Desde medianoche
GO
EXEC dbo.sp_add_jobserver
     @job_name = N'MYBOOK_Audit_Critical_Alerts';
GO