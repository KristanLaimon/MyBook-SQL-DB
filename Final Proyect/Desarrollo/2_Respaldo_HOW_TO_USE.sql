
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
