use MYBOOK;

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

-- throes if twice
declare @ActualDate datetime2 = GETDATE();
declare @InTwoDaysDate datetime2 = DATEADD(day, 2, @ActualDate);
declare @InThreeDaysDate datetime2 = DATEADD(day, 3, @Actualdate);
exec Books_Insert 1, 'Book one', 'This is the first book', '9781234567890', 1, 1, @ActualDate, @ActualDate, 'EN', 'FA', 1;
exec Books_Insert 2, 'Book two', 'This is the second book', '9781234567891', 2, 0, @ActualDate, @InTwoDaysDate, 'ES', 'SF', 2;
exec Books_Insert 3, 'Book three', 'This is the third book', '9781234567892', 3, 1, @InTwoDaysDate, @InThreeDaysDate, 'FR', 'MY', 3;
