use master;
alter database MYBOOK set SINGLE_USER with rollback immediate;
drop database MYBOOK;
