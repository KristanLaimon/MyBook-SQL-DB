USE master;
GO

-- Configurar el modelo de recuperación de la base de datos MYBOOK a FULL
ALTER DATABASE MYBOOK SET RECOVERY FULL;
GO

-- Crear directorio de respaldos (asegúrate de que exista en el servidor)
-- Ejemplo: C:\Backups\MYBOOK\
-- Nota: El directorio debe crearse manualmente con permisos adecuados

-- Procedimiento para Respaldo Completo
IF OBJECT_ID('sp_Backup_Full', 'P') IS NOT NULL
    DROP PROCEDURE sp_Backup_Full;
GO
CREATE PROCEDURE sp_Backup_Full
AS
BEGIN
    DECLARE @BackupPath NVARCHAR(256);
    DECLARE @BackupName NVARCHAR(256);
    DECLARE @ErrorMsg NVARCHAR(4000);

    SET @BackupPath = N'C:\Backups\MYBOOK\MYBOOK_Full_' +
                      CONVERT(NVARCHAR(20), GETDATE(), 112) + '_' +
                      REPLACE(CONVERT(NVARCHAR(20), GETDATE(), 108), ':', '') + '.bak';
    SET @BackupName = N'MYBOOK Full Backup - ' + CONVERT(NVARCHAR(20), GETDATE(), 120);

    BEGIN TRY
        -- Realizar respaldo completo con compresión
        BACKUP DATABASE MYBOOK
            TO DISK = @BackupPath
            WITH INIT,
            COMPRESSION,
            NAME = @BackupName,
            STATS = 10;

        -- Verificar integridad del respaldo
        RESTORE VERIFYONLY FROM DISK = @BackupPath;
        PRINT 'Respaldo completo creado exitosamente: ' + @BackupPath;
    END TRY
    BEGIN CATCH
        SELECT @ErrorMsg = ERROR_MESSAGE();
        PRINT 'Error en sp_Backup_Full: ' + @ErrorMsg;
        THROW;
    END CATCH
END;
GO

-- Procedimiento para Respaldo Diferencial
IF OBJECT_ID('sp_Backup_Differential', 'P') IS NOT NULL
    DROP PROCEDURE sp_Backup_Differential;
GO
CREATE PROCEDURE sp_Backup_Differential
AS
BEGIN
    DECLARE @BackupPath NVARCHAR(256);
    DECLARE @BackupName NVARCHAR(256);
    DECLARE @ErrorMsg NVARCHAR(4000);

    SET @BackupPath = N'C:\Backups\MYBOOK\MYBOOK_Diff_' +
                      CONVERT(NVARCHAR(20), GETDATE(), 112) + '_' +
                      REPLACE(CONVERT(NVARCHAR(20), GETDATE(), 108), ':', '') + '.bak';
    SET @BackupName = N'MYBOOK Differential Backup - ' + CONVERT(NVARCHAR(20), GETDATE(), 120);

    BEGIN TRY
        -- Realizar respaldo diferencial
        BACKUP DATABASE MYBOOK
            TO DISK = @BackupPath
            WITH DIFFERENTIAL,
            INIT,
            COMPRESSION,
            NAME = @BackupName,
            STATS = 10;

        -- Verificar integridad del respaldo
        RESTORE VERIFYONLY FROM DISK = @BackupPath;
        PRINT 'Respaldo diferencial creado exitosamente: ' + @BackupPath;
    END TRY
    BEGIN CATCH
        SELECT @ErrorMsg = ERROR_MESSAGE();
        PRINT 'Error en sp_Backup_Differential: ' + @ErrorMsg;
        THROW;
    END CATCH
END;
GO

-- Procedimiento para Respaldo del Log de Transacciones
IF OBJECT_ID('sp_Backup_Log', 'P') IS NOT NULL
    DROP PROCEDURE sp_Backup_Log;
GO
CREATE PROCEDURE sp_Backup_Log
AS
BEGIN
    DECLARE @BackupPath NVARCHAR(256);
    DECLARE @BackupName NVARCHAR(256);
    DECLARE @ErrorMsg NVARCHAR(4000);

    SET @BackupPath = N'C:\Backups\MYBOOK\MYBOOK_Log_' +
                      CONVERT(NVARCHAR(20), GETDATE(), 112) + '_' +
                      REPLACE(CONVERT(NVARCHAR(20), GETDATE(), 108), ':', '') + '.trn';
    SET @BackupName = N'MYBOOK Transaction Log Backup - ' + CONVERT(NVARCHAR(20), GETDATE(), 120);

    BEGIN TRY
        -- Realizar respaldo del log de transacciones
        BACKUP LOG MYBOOK
            TO DISK = @BackupPath
            WITH INIT,
            COMPRESSION,
            NAME = @BackupName,
            STATS = 10;

        -- Verificar integridad del respaldo
        RESTORE VERIFYONLY FROM DISK = @BackupPath;
        PRINT 'Respaldo del log creado exitosamente: ' + @BackupPath;
    END TRY
    BEGIN CATCH
        SELECT @ErrorMsg = ERROR_MESSAGE();
        PRINT 'Error en sp_Backup_Log: ' + @ErrorMsg;
        THROW;
    END CATCH
END;
GO

-- Procedimiento para Limpieza de Respaldos Antiguos
IF OBJECT_ID('sp_Cleanup_Backups', 'P') IS NOT NULL
    DROP PROCEDURE sp_Cleanup_Backups;
GO
CREATE PROCEDURE sp_Cleanup_Backups
AS
BEGIN
    DECLARE @DeleteDate NVARCHAR(20);
    DECLARE @Command NVARCHAR(4000);
    DECLARE @ErrorMsg NVARCHAR(4000);

    -- Eliminar respaldos completos mayores a 4 semanas
    SET @DeleteDate = CONVERT(NVARCHAR(20), DATEADD(WEEK, -4, GETDATE()), 112);
    SET @Command = 'EXEC xp_cmdshell ''del C:\Backups\MYBOOK\MYBOOK_Full_' + @DeleteDate + '*.bak''';

    BEGIN TRY
        EXEC sp_executesql @Command;
        PRINT 'Respaldos completos antiguos eliminados.';
    END TRY
    BEGIN CATCH
        SELECT @ErrorMsg = ERROR_MESSAGE();
        PRINT 'Error al eliminar respaldos completos: ' + @ErrorMsg;
    END CATCH

    -- Eliminar respaldos diferenciales mayores a 1 semana
    SET @DeleteDate = CONVERT(NVARCHAR(20), DATEADD(WEEK, -1, GETDATE()), 112);
    SET @Command = 'EXEC xp_cmdshell ''del C:\Backups\MYBOOK\MYBOOK_Diff_' + @DeleteDate + '*.bak''';

    BEGIN TRY
        EXEC sp_executesql @Command;
        PRINT 'Respaldos diferenciales antiguos eliminados.';
    END TRY
    BEGIN CATCH
        SELECT @ErrorMsg = ERROR_MESSAGE();
        PRINT 'Error al eliminar respaldos diferenciales: ' + @ErrorMsg;
    END CATCH

    -- Eliminar respaldos de log mayores a 1 día
    SET @DeleteDate = CONVERT(NVARCHAR(20), DATEADD(DAY, -1, GETDATE()), 112);
    SET @Command = 'EXEC xp_cmdshell ''del C:\Backups\MYBOOK\MYBOOK_Log_' + @DeleteDate + '*.trn''';

    BEGIN TRY
        EXEC sp_executesql @Command;
        PRINT 'Respaldos de log antiguos eliminados.';
    END TRY
    BEGIN CATCH
        SELECT @ErrorMsg = ERROR_MESSAGE();
        PRINT 'Error al eliminar respaldos de log: ' + @ErrorMsg;
    END CATCH
END;
GO

-- Procedimiento de Ejemplo para Restauración a un Punto en el Tiempo
IF OBJECT_ID('sp_Restore_MYBOOK', 'P') IS NOT NULL
    DROP PROCEDURE sp_Restore_MYBOOK;
GO
CREATE PROCEDURE sp_Restore_MYBOOK
    @PointInTime DATETIME2,
    @FullBackupPath NVARCHAR(256),
    @DiffBackupPath NVARCHAR(256) = NULL,
    @LogBackupPath NVARCHAR(256) = NULL
AS
BEGIN
    DECLARE @ErrorMsg NVARCHAR(4000);

    BEGIN TRY
        -- Poner la base de datos en modo RESTORE
        ALTER DATABASE MYBOOK SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

        -- Restaurar respaldo completo
        RESTORE DATABASE MYBOOK
            FROM DISK = @FullBackupPath
            WITH NORECOVERY;

        -- Restaurar respaldo diferencial (si se proporciona)
        IF @DiffBackupPath IS NOT NULL
            BEGIN
                RESTORE DATABASE MYBOOK
                    FROM DISK = @DiffBackupPath
                    WITH NORECOVERY;
            END

        -- Restaurar logs de transacciones hasta el punto en el tiempo (si se proporciona)
        IF @LogBackupPath IS NOT NULL
            BEGIN
                RESTORE LOG MYBOOK
                    FROM DISK = @LogBackupPath
                    WITH STOPAT = @PointInTime, NORECOVERY;
            END

        -- Finalizar restauración
        RESTORE DATABASE MYBOOK WITH RECOVERY;
        ALTER DATABASE MYBOOK SET MULTI_USER;

        PRINT 'Base de datos MYBOOK restaurada exitosamente al punto: ' + CONVERT(NVARCHAR(20), @PointInTime, 120);
    END TRY
    BEGIN CATCH
        SELECT @ErrorMsg = ERROR_MESSAGE();
        PRINT 'Error en sp_Restore_MYBOOK: ' + @ErrorMsg;
        -- Revertir al modo multiusuario en caso de error
        ALTER DATABASE MYBOOK SET MULTI_USER;
        THROW;
    END CATCH
END;
GO

-- Ejemplo de Programación de Respaldos con SQL Server Agent
-- Nota: Estos comandos deben ejecutarse en SQL Server Management Studio o similar
-- para configurar los trabajos en SQL Server Agent.

-- Job 1: Respaldo Completo (Domingos a las 2:00 AM)
USE msdb;
GO
EXEC dbo.sp_add_job
     @job_name = N'MYBOOK_Full_Backup_Weekly';
GO
EXEC dbo.sp_add_jobstep
     @job_name = N'MYBOOK_Full_Backup_Weekly',
     @step_name = N'Execute Full Backup',
     @subsystem = N'TSQL',
     @command = N'EXEC sp_Backup_Full',
     @database_name = N'master';
GO
EXEC dbo.sp_add_jobschedule
     @job_name = N'MYBOOK_Full_Backup_Weekly',
     @name = N'Weekly_Sunday_2AM',
     @freq_type = 8, -- Semanal
     @freq_interval = 1, -- Domingo
     @active_start_time = 20000; -- 2:00 AM
GO
EXEC dbo.sp_add_jobserver
     @job_name = N'MYBOOK_Full_Backup_Weekly';
GO

-- Job 2: Respaldo Diferencial (Diario, excepto domingos, a las 10:00 PM)
EXEC dbo.sp_add_job
     @job_name = N'MYBOOK_Differential_Backup_Daily';
GO
EXEC dbo.sp_add_jobstep
     @job_name = N'MYBOOK_Differential_Backup_Daily',
     @step_name = N'Execute Differential Backup',
     @subsystem = N'TSQL',
     @command = N'EXEC sp_Backup_Differential',
     @database_name = N'master';
GO
EXEC dbo.sp_add_jobschedule
     @job_name = N'MYBOOK_Differential_Backup_Daily',
     @name = N'Daily_Except_Sunday_10PM',
     @freq_type = 8, -- Semanal
     @freq_interval = 62, -- Lunes a Sábado (2+4+8+16+32)
     @active_start_time = 220000; -- 10:00 PM
GO
EXEC dbo.sp_add_jobserver
     @job_name = N'MYBOOK_Differential_Backup_Daily';
GO

-- Job 3: Respaldo del Log de Transacciones (Cada hora)
EXEC dbo.sp_add_job
     @job_name = N'MYBOOK_Log_Backup_Hourly';
GO
EXEC dbo.sp_add_jobstep
     @job_name = N'MYBOOK_Log_Backup_Hourly',
     @step_name = N'Execute Log Backup',
     @subsystem = N'TSQL',
     @command = N'EXEC sp_Backup_Log',
     @database_name = N'master';
GO
EXEC dbo.sp_add_jobschedule
     @job_name = N'MYBOOK_Log_Backup_Hourly',
     @name = N'Hourly_Every_60_Minutes',
     @freq_type = 4, -- Diario
     @freq_subday_type = 8, -- Cada hora
     @freq_subday_interval = 1, -- Cada 1 hora
     @active_start_time = 0; -- Desde medianoche
GO
EXEC dbo.sp_add_jobserver
     @job_name = N'MYBOOK_Log_Backup_Hourly';
GO

-- Job 4: Limpieza de Respaldos Antiguos (Diaria a las 3:00 AM)
EXEC dbo.sp_add_job
     @job_name = N'MYBOOK_Cleanup_Backups_Daily';
GO
EXEC dbo.sp_add_jobstep
     @job_name = N'MYBOOK_Cleanup_Backups_Daily',
     @step_name = N'Execute Cleanup Backups',
     @subsystem = N'TSQL',
     @command = N'EXEC sp_Cleanup_Backups',
     @database_name = N'master';
GO
EXEC dbo.sp_add_jobschedule
     @job_name = N'MYBOOK_Cleanup_Backups_Daily',
     @name = N'Daily_3AM',
     @freq_type = 4, -- Diario
     @active_start_time = 30000; -- 3:00 AM
GO
EXEC dbo.sp_add_jobserver
     @job_name = N'MYBOOK_Cleanup_Backups_Daily';
GO