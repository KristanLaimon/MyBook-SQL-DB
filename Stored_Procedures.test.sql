

use MYBOOK;
--                                                  NOTE All must work at the first time!

-- This can throw error if executed 2 times
exec Suscriptions_Insert @ID = 'HO', @Name = 'Very Plus', @Description = 'This is a new subscription', @PriceUSD = 23.250

-- This can throw error if executed 2 times
exec Book_User_Reviews_Insert 10, 2, 3, 'A solid read with engaging characters.'
exec Book_User_Reviews_Insert 3, 2, 5, 'Absolutely brilliant and inspiring.'
exec Book_User_Reviews_Insert 3, 3, 4, 'Very enjoyable, though a bit slow in parts.'

-- Safe
exec Roles_Insert 'TT', 'Tester', 100;
exec Roles_Insert 'TT', 'Tester', 100;
exec Roles_Insert 'TT', 'Tester', 100;

-- Safe
exec Languages_Insert 'ZH', 'Chinese';
exec Languages_Insert 'AR', 'Arabic';
exec Languages_Insert 'HI', 'Hindi';

-- throes if twice
declare @PasswordHash char(64) = replicate('z', 64);
declare @PasswordHash2 char(64) = replicate('x', 64);
exec Users_Insert 'Test2', @PasswordHash, 'test2@example.com', 0, 'SU', 'TP', '2025-04-10 11:00:00';
exec Users_Insert 'Test3', @PasswordHash2, 'test3@example.com', 0, 'SU', 'TP', '2025-04-10 11:00:00';

-- throes if twice
exec Genres_Insert 'TA', 'Tester5';
exec Genres_Insert 'TV', 'Tester2';
exec Genres_Insert 'TX', 'Tester3';

go
-- throes if twice
declare @ActualDate datetime2 = GETDATE();
declare @InTwoDaysDate datetime2 = DATEADD(day, 2, @ActualDate);
declare @InThreeDaysDate datetime2 = DATEADD(day, 3, @Actualdate);
exec Books_Insert 1, 'Book one', 'This is the first book', '9781234567890', 1, 1, @ActualDate, @ActualDate, 'EN', 'FA', 1, 10;
exec Books_Insert 2, 'Book two', 'This is the second book', '9781234567891', 2, 0, @ActualDate, @InTwoDaysDate, 'ES', 'SF', 2, 20
exec Books_Insert 3, 'Book three', 'This is the third book', '9781234567892', 3, 1, @InTwoDaysDate, @InThreeDaysDate, 'FR', 'MY', 3, 30;
go

declare @ActualDate datetime2 = getdate();
exec User_User_Suscribe_Insert 1, 2, @ActualDate;
exec User_User_Suscribe_Insert 3, 4, @ActualDate;
exec User_User_Suscribe_Insert 5, 6, @ActualDate;
go

declare @Date datetime2 = getdate();
exec Books_Insert 1, 'Test Book One', 'Description for Test Book One', '9781111111111', 1, 1, @Date, @Date, 'EN', 'FA', 1;
exec Books_Insert 2, 'Test Book Two', 'Description for Test Book Two', '9782222222222', 1, 0, @Date, @Date, 'ES', 'SF', 2;
exec Books_Insert 3, 'Test Book Three', 'Description for Test Book Three', '9783333333333', 1, 1, @Date, @Date, 'FR', 'MY', 3;

declare @ActualDate datetime2 = GETDATE();
exec Book_User_Shelve_Insert 1, 2, 1, @ActualDate;
exec Book_User_Shelve_Insert 3, 4, 0, @ActualDate;
exec Book_User_Shelve_Insert 5, 6, 1, @ActualDate;

declare @d datetime2 = getdate();
exec Posts_Insert @d, 1, 1, 'Content 1', 'Title 1';
exec Posts_Insert @d, 2, 2, 'Content 2', 'Title 2';
exec Posts_Insert @d, 3, 3, 'Content 3', 'Title 3';

exec Book_User_Reads_Insert 1, 2, 500, '2021-01-01 12:00:00';
exec Book_User_Reads_Insert 3, 4, 800, '2021-01-02 12:00:00';
exec Book_User_Reads_Insert 5, 6, 1000, '2021-01-03 12:00:00';

exec Comment_Insert 1, 'This is a comment', 1, null;
exec Comment_Insert 2, 'This is another comment', null, 1;
exec Comment_Insert 3, 'This is a reply to the previous comment', null, 1;

declare @ThisDate datetime2 = getdate();
exec User_Community_Follow_Insert 1, 2, @ThisDate;
exec User_Community_Follow_Insert 2, 3, @ThisDate;
exec User_Community_Follow_Insert 3, 4, @ThisDate;
