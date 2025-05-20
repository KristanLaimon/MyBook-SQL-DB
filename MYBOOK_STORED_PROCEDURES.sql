use MYBOOK;

drop procedure if exists Suscriptions_Insert; go
create procedure Suscriptions_Insert(
    @ID char(2),
    @Name varchar(30),
    @Description varchar(250),
    @PriceUSD decimal(5,2)
)as
begin
    begin try
        insert into Suscriptions (ID, Name, Description, PriceUSD) values (@ID, @Name, @Description, @PriceUSD);
    end try
    begin catch
        print 'Subscriptions_Insert | ERROR | MSG: ' + error_message() + ' | Values: ' + @ID + ',' + @Name + ',' + @Description + ',' + convert(varchar(10), @PriceUSD);
    end catch
end go;

drop procedure if exists Book_user_Reviews_Insert; go
create procedure Book_User_Reviews_Insert(
    @BookID int,
    @UserID int,
    @Rating tinyint,
    @Comment varchar(400)
) as
begin
    begin try
        insert into Book_User_Reviews (BookID, UserID, Rating, Comment) values (@BookID, @UserID, @Rating, @Comment);
    end try
    begin catch
        print 'Book_User_Reviews_Insert | ERROR | MSG: ' + error_message() + ' | Values: ' + convert(varchar(10), @BookID) + ',' + convert(varchar(10), @UserID) + ',' + convert(varchar(10), @Rating) + ',' + @Comment;
    end catch
end go;

drop procedure if exists Roles_Insert; go
create procedure Roles_Insert(
    @ID char(2),
    @Name varchar(20),
    @Priority tinyint
) as
begin
    begin try
        insert into Roles (ID, Name, Priority) values (@ID, @Name, @Priority)
    end try
    begin catch
        print 'Roles_Insert | ERROR | MSG: ' + error_message() + ' | Values: ' + @ID + ',' + @Name + ',' + convert(varchar(10), @Priority);
    end catch
end

drop procedure if exists Languages_Insert; go
create procedure Languages_Insert(
    @ID char(2),
    @Name varchar(30)
) as
begin
    begin try
        insert into Languages (ID, Name) values (@ID, @Name);
    end try
    begin catch
        print 'Languages_Insert | ERROR | MSG: ' + error_message() + ' | Values: ' + @ID + ',' + @Name;
    end catch

end go;

drop procedure if exists Users_Insert;
create procedure Users_Insert(
    @Name varchar(20),
    @PasswordHash char(64),
    @Email varchar(30),
    @IsVerified bit,
    @RoleID char(2),
    @SubscriptionID char(2),
    @RenewSuscriptionDate datetime2
)as
begin
    begin try
--         Note: ID is not inserted. It's already IDENTITY(1,1)
        insert into Users (Name, PasswordHash, Email, IsVerified, RoleID, SubscriptionID, RenewSuscriptionDate)
        values (@Name, @PasswordHash, @Email, @IsVerified, @RoleID, @SubscriptionID, @RenewSuscriptionDate);
    end try
    begin catch
        print 'Users_Insert | ERROR | MSG: ' + error_message() + ' | Values: ' + @Name + ',' + @PasswordHash + ',' + @Email + ',' + convert(varchar(1), @IsVerified) + ',' + @RoleID + ',' + @SubscriptionID + ',' + convert(varchar(30), @RenewSuscriptionDate);
    end catch

end go;

drop procedure if exists Genres_Insert; go
create procedure Genres_Insert(
    @ID char(2),
    @Name varchar(20)
)as
begin
    begin try
        insert into Genres (ID, Name) values (@ID, @Name);
    end try
    begin catch
        print 'Genres_Insert | ERROR | MSG: ' + error_message() + ' | Values: ' + @ID + ',' + @Name;
    end catch
end go


drop procedure if exists Books_Insert; go
create procedure Books_Insert(
    @ID int,
    @Name varchar(30),
    @Description varchar(400),
    @ISBN char(13),
    @Edition tinyint,
    @IsVerified bit,
    @PublishedUploadDate datetime2,
    @PublishedBookDate datetime2,
    @LanguageID char(2),
    @GenreID char(2),
    @UserUploaderID int
)as
begin
    begin try
        insert into Books (Name, Description, ISBN, Edition, IsVerified, PublishedUploadDate, PublishedBookDate, LanguageID, GenreID, UserUploaderID)
        values (@Name, @Description, @ISBN, @Edition, @IsVerified, @PublishedUploadDate, @PublishedBookDate, @LanguageID, @GenreID, @UserUploaderID);
    end try
    begin catch
        print 'Books_Insert | ERROR | MSG: ' + error_message() + ' | Values: ' + @Name + ',' + @Description + ',' + @ISBN + ',' + convert(varchar(10), @Edition) + ',' + convert(varchar(10), @IsVerified) + ',' + convert(varchar(30), @PublishedUploadDate, 120) + ',' + convert(varchar(30), @PublishedBookDate, 120) + ',' + @LanguageID + ',' + @GenreID + ',' + convert(varchar(10), @UserUploaderID);
    end catch
end go

