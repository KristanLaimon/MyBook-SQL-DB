

USE master;
GO

-- Configurar el modelo de recuperación de la base de datos MYBOOK a FULL
ALTER DATABASE MYBOOK SET RECOVERY FULL;
GO

-- Crear directorio de respaldos (asegúrate de que exista en el servidor)
-- Ejemplo: C:\Backups\MYBOOK\
-- Nota: El directorio debe crearse manualmente con permisos adecuados

-- Procedimiento para Respaldo Completo
drop procedure if exists sp_Backup_Full; go
CREATE PROCEDURE sp_Backup_Full
AS
BEGIN
    -- Notas con respecto a los formatos:
    -- 120 format produces: YYYY-MM-DD HH:MM:SS
    -- 112 format produces: YYYY-MM-DD
    -- 108 format produces: HH:MM:SS

    DECLARE @BackupPath NVARCHAR(256);
    DECLARE @BackupName NVARCHAR(256);
    DECLARE @ErrorMsg NVARCHAR(4000);

    -- Example: C:\Backups\MYBOOK\MYBOOK_Full_20220121_143000.bak
    SET @BackupPath = N'C:\Backups\MYBOOK\MYBOOK_Full_' +
                      CONVERT(NVARCHAR(20), GETDATE(), 112) + '_' +
                      REPLACE(CONVERT(NVARCHAR(20), GETDATE(), 108), ':', '') + '.bak';

    -- Example: MYBOOK Full Backup - 2022-01-21 14:30:00
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
drop procedure if exists sp_Backup_Differential; go
CREATE PROCEDURE sp_Backup_Differential
AS
BEGIN
    DECLARE @BackupPath NVARCHAR(256);
    DECLARE @BackupName NVARCHAR(256);
    DECLARE @ErrorMsg NVARCHAR(4000);

    SET @BackupPath = N'C:\Backups\MYBOOK\MYBOOK_Diff_' +
                      CONVERT(NVARCHAR(20), GETDATE(), 112) + '_' + -- Full date without time format: From 2022-01-01 to 20220101 !
                      REPLACE(CONVERT(NVARCHAR(20), GETDATE(), 108), ':', '') + '.bak'; -- Time in 24 hours format: From 14:00 to 1400 !
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
drop procedure if exists sp_Backup_Log; go
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
drop procedure if exists sp_Cleanup_Backups; go
CREATE PROCEDURE sp_Cleanup_Backups
AS
BEGIN
    DECLARE @DeleteDate NVARCHAR(20);
    DECLARE @Command NVARCHAR(4000);
    DECLARE @ErrorMsg NVARCHAR(4000);

    -- Eliminar respaldos completos mayores a 4 semanas
    SET @DeleteDate = CONVERT(NVARCHAR(20), DATEADD(WEEK, -4, GETDATE()), 112);
    SET @Command = 'EXEC xp_cmdshell ''del C:\Backups\MYBOOK\MYBOOK_Full_' + @DeleteDate + '*.bak''';
    -- Ejemplo: EXEC xp_cmdshell 'del C:\Backups\MYBOOK\MYBOOK_Full_20250423*.bak'

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
drop procedure if exists sp_Restore_MYBOOK; go;
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