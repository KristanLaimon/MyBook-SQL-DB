

USE master;
GO

-- Configurar el modelo de recuperación de la base de datos MYBOOK a FULL
ALTER DATABASE MYBOOK SET RECOVERY FULL;
GO

-- Crear directorio de respaldos (asegurarse de que exista en el servidor)
-- Ejemplo: C:\Backups\MYBOOK\
-- Nota: El directorio debe crearse manualmente con los permisos adecuados (te estoy observando linux ehh!)

-- 1. Procedimiento para Respaldo Completo
drop procedure if exists sp_Backup_Full; go
CREATE PROCEDURE sp_Backup_Full
AS
BEGIN
    -- Notas con respecto a los formatos:
    -- 120 format produces: YYYY-MM-DD HH:MM:SS
    -- 112 format produces: YYYYMMDD
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
--             COMPRESSION, Esto no se puede realizar en la versión EXPRESS
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
--             COMPRESSION, Esto no se puede en la versión EXPRESS...
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
--             COMPRESSION, Esto no se puede en la versión EXPRESS...
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

-- Habilita el permiso para ejecutar comandos SQL y borrado de archivos.
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;

-- Procedimiento para Limpieza de Respaldos Antiguos
-- 1. Borrar respaldos completos mayores a 4 semanas
-- 2. Borrar respaldos diferenciales mayor a 1 semana
-- 3. borrar respaldos de log mayor a 1 día
drop procedure if exists sp_Cleanup_Backups; go
CREATE PROCEDURE sp_Cleanup_Backups
AS
BEGIN
    -- Notas con respecto a los formatos:
    -- 120 format produces: YYYY-MM-DD HH:MM:SS
    -- 112 format produces: YYYYMMDD
    -- 108 format produces: HH:MM:SS

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


drop procedure if exists sp_restore_mybook;
go
create procedure sp_restore_mybook
@point_in_time datetime2
as
begin
    set nocount on;

    -- variables locales
    declare @error_msg nvarchar(4000);
    declare @full_backup_path nvarchar(256);
    declare @diff_backup_path nvarchar(256);
    declare @log_backup_path nvarchar(256);
    declare @backup_set_id int;

    begin try
        -- 1. RESPALDO COMPLETO: Encontrar el respaldo completo más reciente
        select top 1
            @full_backup_path = bmf.physical_device_name,
            @backup_set_id = bs.backup_set_id
        from msdb.dbo.backupset bs
                 join msdb.dbo.backupmediafamily bmf on bs.media_set_id = bmf.media_set_id
        where bs.database_name = 'mybook'
          -- Opciones disponibles:
              -- 'D' = Full (Database)
              -- 'I' = Differential
              -- 'L' = Transaction Log
        and bs.type = 'D' -- full backup
        order by bs.backup_finish_date desc;

        if @full_backup_path is null
            throw 50000, N'no se encontró respaldo completo para mybook.', 1;

        -- 2. RESPALDO DIFERENCIAL: Encontrar el respaldo diferencial más reciente *después* del respaldo completo
        select top 1
            @diff_backup_path = bmf.physical_device_name
        from msdb.dbo.backupset bs
                 join msdb.dbo.backupmediafamily bmf on bs.media_set_id = bmf.media_set_id
        where bs.database_name = 'mybook'
          and bs.type = 'I' -- diff backup
          -- Solo busca los que se hicieron después del backup completo que se encontró un poco más arriba
          and bs.backup_start_date > (
            select backup_finish_date
            from msdb.dbo.backupset
            where backup_set_id = @backup_set_id
        )
        order by bs.backup_finish_date desc;

        -- 3. RESPALDO DE TRANSACCIONES: encontrar el registro de log ms reciente que incluye el punto en el tiempo
        select top 1
            @log_backup_path = bmf.physical_device_name
        from msdb.dbo.backupset bs
                 join msdb.dbo.backupmediafamily bmf on bs.media_set_id = bmf.media_set_id
        where bs.database_name = 'mybook'
          and bs.type = 'L' -- log backup
          -- Buscar los logs que se encuentren dentro del rango de la fecha que recibe este procedimiento como parámetro
          and @point_in_time between bs.backup_start_date and bs.backup_finish_date
        order by bs.backup_finish_date desc;

        -- poner la base de datos en modo de un solo usuario
        alter database mybook set single_user with rollback immediate;

        -- restaurar el respaldo completo
        restore database mybook
            from disk = @full_backup_path
            with norecovery, replace;

        -- restaurar el respaldo diferencial si existe
        if @diff_backup_path is not null
            begin
                restore database mybook
                    from disk = @diff_backup_path
                    with norecovery, replace;
            end

        -- restaurar el registro de log si es aplicable
        if @log_backup_path is not null
            begin
                restore log mybook
                    from disk = @log_backup_path
                    with stopat = @point_in_time, norecovery;
            end

        -- terminar
        restore database mybook with recovery;
        alter database mybook set multi_user;

        print N'Base de datos MYBOOK restaurada con éxito al punto: ' + convert(nvarchar(20), @point_in_time, 120);
    end try
    begin catch
        select @error_msg = error_message();
        print 'Error en sp_restore_mybook: ' + @error_msg;
        alter database mybook set multi_user;
        throw;
    end catch
end;
go


drop procedure if exists sp_delete_all_backups;
go
create procedure sp_delete_all_backups
@database_name sysname
as
begin
    set nocount on;

    declare @backup_file nvarchar(4000);
    declare @cmd nvarchar(4000);

    -- cursor to loop through all backup files for the database
    declare backup_cursor cursor for
        select bmf.physical_device_name
        from msdb.dbo.backupset bs
                 join msdb.dbo.backupmediafamily bmf on bs.media_set_id = bmf.media_set_id
        where bs.database_name = @database_name;

    open backup_cursor;
    fetch next from backup_cursor into @backup_file;

    while @@fetch_status = 0
        begin
            -- delete the physical file
            set @cmd = 'del "' + @backup_file + '"';
            exec xp_cmdshell @cmd, no_output;

            fetch next from backup_cursor into @backup_file;
        end

    close backup_cursor;
    deallocate backup_cursor;

    -- delete backup history from msdb
    exec msdb.dbo.sp_delete_database_backuphistory @database_name;

    print 'All backup files and history for database "' + @database_name + '" have been deleted.';
end;
go


