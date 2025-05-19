-- insert dbo.Comment (userid, content, postid, parentcommentid) values (111, "contenido del comentario", )

--1.1 PROCEDURE: Create
if (object_id('Insert_Book_User_Reads') is not null)
    exec('drop procedure Insert_Book_User_Reads;');
GO
create procedure Insert_Book_User_Reads
    @BookID int,
    @UserID int,
    @ReadTimeMiliseconds bigint,
    @ReadDate datetime2
as
begin
    set nocount on;
insert into Book_User_Reads (BookID, UserID, ReadTimeMiliseconds, ReadDate)
values (@BookID, @UserID, @ReadTimeMiliseconds, @ReadDate);
end
go

--1.2 PROCEDURE: Using it
declare @RandomUserID int = floor(rand() * 2000) + 50;
declare @RandomTime int = floor(rand() * 20000);
declare @actualDate datetime2 = sysdatetime();

EXEC Insert_Book_User_Reads 4, @RandomUserID, @RandomTime, '2024-01-01';
EXEC Insert_Book_User_Reads @BookID = 2, @UserID = @RandomUserID, @ReadTimeMiliseconds = @RandomTime, @ReadDate = @actualDate;
go

if object_id('BookUserReads') is not null
drop view BookUserReads;
go

-- 1.3 VIEW: Create a frontend view for Book_User_Reads
create view BookUserReads
as
select u.Name 'UserName', b.ID as 'BookID', bur.ReadDate, (bur.ReadTimeMiliseconds / 1000) as 'Minutes'
from Book_User_Reads bur
         join Users u on bur.UserID = u.ID
         join Books b on bur.BookID = b.ID;
go

if object_id('ViewInsertBookUserReads') is not null
drop procedure ViewInsertBookUserReads;
go

create procedure ViewInsertBookUserReads
    @User_Name varchar(30),
    @BookName varchar(30),
	@ReadDate datetime2,
	@MinutesRead int
as
begin
--  ===== 1. Check if user exists =====
    declare @userIdFound int;
    declare @userNameDebug varchar(20);
select
    @userIdFound = u.ID,
    @userNameDebug = u.Name
from Users u
where u.Name = @User_Name;
print CAST(@userIdFound as varchar(15))

    if @userIdFound is null
begin
            declare @errorMsg varchar(100) = concat('ViewInsertBookUserReads error: User with name ', @user_Name ,' not found');
            throw 50001, @errorMsg, 1;
end

-- ==== 2. Check if that book exists ====
    declare @bookIDFound int;
    declare @bookNameDebug varchar(30);
select
    @bookIDFound = b.ID,
    @bookNameDebug = b.Name
from Books b
where b.Name = @Bookname;
print CAST(@bookIDFound as varchar(15))

    if @bookIDFound is null
begin
            declare @errorMsg2 varchar(100) = concat('ViewInsertBookUserReads error: Book with name ',@BookName,' was not found');
            throw 50002, @errorMsg2, 1
end

--  ===== 3. Check if that pair information exists already before =====
    declare @alreadyExists bit = 0;
select @alreadyExists = count(*)
from Book_User_Reads bur
where bur.UserID = @userIdFound
  and bur.BookID = @bookIDFound
    if @alreadyExists = 1
begin
            declare @errorMsg3 varchar(100) = concat('ViewInsertBookUserReads error: Book with name "', @BookName, '" is already associated to user "', @User_Name, '"');
            throw 50003, @errorMsg3, 1
end

-- ===== 4. Begin and start the transaction my bro ======
    set nocount on
begin try
begin transaction;
insert into Book_User_Reads (BookID, UserID, ReadTimeMiliseconds, ReadDate)
values (@bookIDFound, @userIdFound, @MinutesRead * 1000, @ReadDate);
commit transaction;
end try
begin catch
if @@TRANCOUNT > 0
            rollback transaction;
            throw;
end catch
end
go
exec ViewInsertBookUserReads @User_Name = 'Kristan', @BookName = 'Book 1', @ReadDate = '2025-01-01', @MinutesRead = 30;

select *
from Users;