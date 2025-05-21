
-- NOTA: SQL SERVER EXPRESS NO TIENE SQL AGENT, por lo que no se puede correr los jobs aquí...
-- Source: https://learn.microsoft.com/en-us/answers/questions/890726/sql-server-agent-not-appearing-in-management-studi
-- Talvez en el developer edition?...


--- Nota: Habilitar SQL Server Agent (debe estar corriendo en el servicio de SQL Server)

-- Tabla de valores posibles para @freq_type en sp_add_schedule

-- @freq_type valores:
-- 1 = Una sola vez (Se ejecuta una vez)
-- 4 = Diario (Se ejecuta todos los días)
-- 8 = Semanal (Se ejecuta semanalmente)
-- 16 = Mensual (Se ejecuta en un día específico de cada mes)
-- 32 = Mensual relativo (Ejemplo: tercer lunes del mes)
-- 64 = Al iniciar el agente de SQL Server
-- 128 = Cuando la computadora está inactiva
use mybook;

-- =============  1. JOB DIARIO: Crear backup DIFERENCIAL Y DE LOGS/TRANSACCIONES diario una vez a las 02:00 AM  ========================
IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE name = N'Backup_Differential_And_Log_Daily')
    EXEC msdb.dbo.sp_delete_job @job_name = N'Backup_Differential_And_Log_Daily';

EXEC msdb.dbo.sp_add_job
     @job_name = N'Backup_Differential_And_Log_Daily';

EXEC msdb.dbo.sp_add_jobstep
     @job_name = N'Backup_Differential_And_Log_Daily',
     @step_name = N'Backup Differential',
     @subsystem = N'TSQL',
     @command = N'EXEC sp_Backup_Differential;',
     @retry_attempts = 3,
     @retry_interval = 5;

EXEC msdb.dbo.sp_add_jobstep
     @job_name = N'Backup_Differential_And_Log_Daily',
     @step_name = N'Backup de logs',
     @subsystem = N'TSQL',
     @command = N'EXEC sp_Backup_Log;',
     @retry_attempts = 3,
     @retry_interval = 5;

EXEC msdb.dbo.sp_add_schedule
     @schedule_name = N'Diario a las 2 AM',
     @freq_type = 4,            -- Diario
     @freq_interval = 1,        -- Cada 1 día
     @active_start_time = 020000; -- 02:00 AM

EXEC msdb.dbo.sp_attach_schedule
     @job_name = N'Backup_Differential_And_Log_Daily',
     @schedule_name = N'Diario a las 2 AM';


-- ============= 1. JOB SEMANAL: Crear backup FULL semanal los domingos a las 3 AM ========================
IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE name = N'Backup_Full_Weekly')
    EXEC msdb.dbo.sp_delete_job @job_name = N'Backup_Full_Weekly';

-- Crear el job
EXEC msdb.dbo.sp_add_job
     @job_name = N'Backup_Full_Weekly';

-- Agregar paso para backup full
EXEC msdb.dbo.sp_add_jobstep
     @job_name = N'Backup_Full_Weekly',
     @step_name = N'Backup Full',
     @subsystem = N'TSQL',
     @command = N'EXEC sp_Backup_Full;',
     @retry_attempts = 3,
     @retry_interval = 5;

EXEC msdb.dbo.sp_add_jobstep
     @job_name = N'Backup_Full_Weekly',
     @step_name = N'Cleanup Backups',
     @subsystem = N'TSQL',
     @command = N'EXEC sp_Cleanup_Backups;',
     @retry_attempts = 3,
     @retry_interval = 5;

-- Crear horario semanal, ejecución domingo a las 3 AM
EXEC msdb.dbo.sp_add_schedule
     @schedule_name = N'Semanal Domingo 03:00 AM',
     @freq_type = 8,          -- 8 = semanal
     @freq_interval = 1,      -- 1 = domingo (bitmap)
     @freq_recurrence_factor = 1, -- Cada 1 semana (obligatorio)
     @active_start_time = 030000;  -- 03:00 AM

-- Adjuntar horario al job
EXEC msdb.dbo.sp_attach_schedule
     @job_name = N'Backup_Full_Weekly',
     @schedule_name = N'Semanal Domingo 03:00 AM';



