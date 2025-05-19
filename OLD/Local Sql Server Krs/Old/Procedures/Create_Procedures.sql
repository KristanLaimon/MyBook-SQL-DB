set ANSI_NULLS on
go
set quoted_identifier on
go

-- 1
create procedure Book_User_Reads_Insert(
    @BookID int,
    @UserID int,
    @ReadTimeMiliseconds bigint,
    @ReadDate datetime2
)
as
    begin
        begin try
            INSERT INTO Book_User_Reads (BookID, UserID, ReadTimeMiliseconds, ReadDate)
            values (@BookId, @Userid, @ReadTimeMiliseconds, @ReadDate)
        end try
        begin catch
            select error_number(), error_message();
        end catch
    end
go

-- 2
create procedure Book_User_Reviews_Insert(
    @BookID int,
    @UserID int,
    @Rating tinyint,
    @Comment varchar(400)
)
as
    begin
        begin try
            INSERT INTO Book_User_Reviews (BookID, UserID, Rating, Comment)
            values (@BookId, @Userid, @Rating, @Comment)
        end try
        begin catch
            select error_number(), error_message();
        end catch
    end
go

-- 3
create procedure Book_User_Shelve_Insert(
    @BookID int,
    @UserID int,
    @isFavorite bit = 0,
    @ShelvedDate datetime2
) as
    begin
        begin try
            INSERT INTO Book_User_Shelve (BookID, UserID, IsFavorite, ShelvedDate)
            VALUES (@BookID, @UserID, @isFavorite, @ShelvedDate)
        end try
        begin catch
            select error_number(), error_message();
        end catch
    end
go

-- 4
create procedure Books_Insert(
    @Name varchar(30),
    @Description varchar(400),
    @ISBN char(13),
    @Edition tinyint = 1,
    @isVerified bit = 0,
    @PublishedUploadDate datetime2,
    @PublishedBookDate datetime2,
    @LanguageID char(2),
    @GenreID char(2),
    @UserUploaderID int
) as
    begin
        begin try
            insert into Books (
                               Name, Description, ISBN, Edition,
                               IsVerified, PublishedUploadDate, PublishedBookDate,
                               LanguageID, GenreID, UserUploaderID
            )
            VALUES (@Name, @Description, @ISBN,
                    @Edition, @isVerified, @PublishedUploadDate,
                    @PublishedBookDate, @LanguageID, @GenreID,
                    @UserUploaderID)
        end try
        begin catch
            select error_number(), error_message();
        end catch
    end
go

-- 5
create procedure Comment_Insert(
    @UserID int,
    @Content varchar(400),
    @PostID int,
    @ParentCommentID int
) as
    begin
        begin try
            INSERT INTO Comment(UserID, Content, PostID, ParentCommentID)
            VALUES (@UserID, @Content, @PostID, @ParentCommentID);
        end try
        begin catch
            select error_number(), error_message();
        end catch
    end
    go

-- 6
create procedure Communities_Insert(
    @BookID int,
    @UserAuthorID int,
    @Title varchar(30),
    @Description varchar(250)
)as
    begin
        begin try
            insert into Communities(BookID, UserAuthorID, Title, Description)
            values (@BookID, @UserAuthorID, @Title, @Description);
        end try
        begin catch
            select error_number(), error_message();
        end catch
    end
    go

-- 7
create procedure Genres_Insert(
    @ID char(2),
    @Name varchar(20)
)as
    begin
        begin try
            insert into Genres (ID, Name)
            values (@ID, @Name);
        end try
        begin catch
            select error_number(), error_message();
        end catch
    end
    go

-- 8
create procedure Languages_Insert(
    @ID char(2),
    @Name varchar(30)
)as
    begin
        begin try
            insert into Languages (ID, Name)
            values (@ID, @Name);
        end try
        begin catch
            select error_number(), error_message();
        end catch
    end
    go



select *
from Book_User_Shelve BUS
join Books ON BUS.BookID = Books.ID
join Users U ON Books.UserUploaderID = U.ID
