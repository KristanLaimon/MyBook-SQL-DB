
use MYBOOK;

-- 1. CREAR UN RESPALDO COMPLETO (con fecha actual)
exec sp_Backup_Full

-- 2. CREAR UN RESPALDO DEL LOG DE TRANSACCIONES (con fecha actual)
exec sp_Backup_Log

-- 3. CREAR UN RESPALDO DIFERENCIAL (con fecha actual)
exec sp_Backup_Differential

-- 4. Restaurar utilizando los respaldos más recientes a una hora especifica (gracias a los LOGS)
use master;
    exec sp_restore_mybook @point_in_time = '2025-05-21 13:40:00';
use mybook;

exec  sp_Cleanup_Backups;

-- Extra: Descomentar esto y usar un log especifico para ver su información
    -- restore headeronly
    -- from disk = 'C:\Backups\MYBOOK\MYBOOK_Log_20250521_145722.trn';

