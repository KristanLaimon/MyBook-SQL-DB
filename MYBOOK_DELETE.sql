

use master;
if exists (select * from sys.databases where name='MYBOOK')
begin
    alter database MYBOOK set SINGLE_USER with rollback immediate;
    drop database MYBOOK;
end
use master;

