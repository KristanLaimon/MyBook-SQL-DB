
-- ============================= Pruebas: 2_Respaldo_STORED_PROCEDURES ===============================
use MYBOOK;

-- nota: se tiene que crear la carpeta C:\Backups\MYBOOK

-- 1. CREAR UN RESPALDO COMPLETO (con fecha actual)
exec sp_Backup_Full

-- 2. CREAR UN RESPALDO DEL LOG DE TRANSACCIONES (con fecha actual)
exec sp_Backup_Log

-- 3. CREAR UN RESPALDO DIFERENCIAL (con fecha actual)
exec sp_Backup_Differential

-- 4. Restaurar utilizando los respaldos más recientes a una hora especifica (gracias a los LOGS)
use master;
    exec sp_restore_mybook @point_in_time = '2025-05-21 15:30:00';
use mybook;

-- Prueba: Borrado y restauración
use mybook;
    select count(*) from  Orders_Book_Have;
    delete from Orders_Book_Have;
    select count(*) from  Orders_Book_Have;
use master;
    exec sp_restore_mybook @point_in_time = '2025-05-21 15:30:00';
use mybook;
    select count(*) from  Orders_Book_Have;

-- Extra: Descomentar esto para limpiar backups viejos
-- exec  sp_Cleanup_Backups;

-- Extra: Descomentar esto para borrar todos los backups física y lógicamente en la db
-- use master;
--     exec sp_delete_all_backups @database_name = 'mybook'
-- use mybook;

-- Extra: Descomentar esto y usar un log especifico para ver su información
-- restore headeronly
-- from disk = 'C:\Backups\MYBOOK\MYBOOK_Log_20250521_145722.trn';


-- ============================= Pruebas: 2_Respaldo_Automatización ===============================
use mybook;
-- Para checar  si está activo el server agente (el que ejecuta los jobs con sus schedules)
EXEC xp_servicecontrol 'QUERYSTATE', 'SQLServerAgent';
-- Enable SQL Server Agent to activate jobs on the server

-- Con esto se inicia un job (testeo)
EXEC msdb.dbo.sp_start_job @job_name = N'Backup_Differential';
EXEC msdb.dbo.sp_start_job @job_name = N'Backup_Logs';
EXEC msdb.dbo.sp_start_job @job_name = N'Backup_Full_Weekly';

-- Stop all current jobs
EXEC msdb.dbo.sp_stop_job @job_name = N'Backup_Differential';
EXEC msdb.dbo.sp_stop_job @job_name = N'Backup_Logs';
EXEC msdb.dbo.sp_stop_job @job_name = N'Backup_Full_Weekly';


-- Get latest 10 job runs (customize as needed)
SELECT TOP 10
    j.name AS JobName,
    h.run_date,
    h.run_time,
    h.run_duration,
    h.message
FROM msdb.dbo.sysjobs j
         JOIN msdb.dbo.sysjobhistory h ON j.job_id = h.job_id
WHERE j.name = 'Backup_Full_Weekly'
ORDER BY h.run_date DESC, h.run_time DESC;

