


use MYBOOK;

drop procedure if exists Suscriptions_Insert; 
go

create procedure Suscriptions_Insert(
    @ID char(2),
    @Name varchar(30),
    @Description varchar(250),
    @PriceUSD decimal(5,2)
)as
begin
    begin try
        insert into Suscriptions (ID, Name, Description, PriceUSD) 
		values (@ID, @Name, @Description, @PriceUSD);
    end try
    begin catch
        print 'Subscriptions_Insert | ERROR | MSG: ' + error_message() + ' | Values: ' + @ID + ',' + @Name + ',' + @Description + ',' + convert(varchar(10), @PriceUSD);
    end catch
end 
go

drop procedure if exists Book_user_Reviews_Insert; 
go
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
end
go

drop procedure if exists Roles_Insert; 
go
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
go

drop procedure if exists Languages_Insert; 
go
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

end 
go

drop procedure if exists Users_Insert; 
go
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

end 
go

drop procedure if exists Genres_Insert;
go
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
end 
go


drop procedure if exists Books_Insert; 
go
create procedure Books_Insert(
    @Name varchar(30),
    @Description varchar(400),
    @ISBN char(13),
    @Edition tinyint,
    @IsVerified bit,
    @PublishedUploadDate datetime2,
    @PublishedBookDate datetime2,
    @LanguageID char(2),
    @GenreID char(2),
    @UserUploaderID int,
	@Stock int
)as
begin
    begin try
        insert into Books (Name, Description, ISBN, Edition, IsVerified, PublishedUploadDate, PublishedBookDate, LanguageID, GenreID, UserUploaderID, Stock)
        values (@Name, @Description, @ISBN, @Edition, @IsVerified, @PublishedUploadDate, @PublishedBookDate, @LanguageID, @GenreID, @UserUploaderID, @Stock);
    end try
    begin catch
        print 'Books_Insert | ERROR | MSG: ' + error_message() + ' | Values: ' + @Name + ',' + @Description + ',' + @ISBN + ',' + convert(varchar(10), @Edition) + ',' + convert(varchar(10), @IsVerified) + ',' + convert(varchar(30), @PublishedUploadDate, 120) + ',' + convert(varchar(30), @PublishedBookDate, 120) + ',' + @LanguageID + ',' + @GenreID + ',' + convert(varchar(10), @UserUploaderID);
    end catch
end 
go

drop procedure if exists User_User_Suscribe_Insert; 
go
create procedure User_User_Suscribe_Insert(
    @SuscriberID int,
    @SuscribedToID int,
    @SuscriptionDate datetime2
)as
begin
    begin try
        insert into User_User_Suscribe (SuscriberID, SuscribedToID, SuscriptionDate)
        values (@SuscribedToID, @SuscriberID, @SuscriptionDate);
    end try
    begin catch
        print 'User_User_Suscribe_Insert | ERROR | MSG: ' + error_message() + ' | Values: ' + convert(varchar(10), @SuscriberID) + ',' + convert(varchar(10), @SuscribedToID) + ',' + convert(varchar(30), @SuscriptionDate, 120);
    end catch
end 
go


drop procedure if exists Communities_Insert; 
go
create procedure Communities_Insert(
    @BookID int,
    @UserAuthorID int,
    @Title varchar(30),
    @Description varchar(250)
)as
begin
    begin try
        insert into Communities (BookID, UserAuthorID, Title, Description)
        values (@BookID, @UserAuthorID, @Title, @Description)
    end try
    begin catch
        print 'Communities_Insert | ERROR | MSG: ' + error_message() + ' | Values: ' + convert(varchar(10), @BookID) + ',' + convert(varchar(10), @UserAuthorID) + ',' + @Title + ',' + @Description;
    end catch
end
go

drop procedure if exists Book_User_Shelve_Insert; 
go
create procedure  Book_User_Shelve_Insert(
    @BookID int,
    @UserID int,
    @IsFavorite bit,
    @ShelvedDate datetime2
) as
begin
    begin try
        insert into Book_User_Shelve (BookID, UserID, IsFavorite, ShelvedDate)
        values (@BookID, @UserID, @IsFavorite, @ShelvedDate);
    end try
    begin catch
        print 'Book_User_Shelve_Insert | ERROR | MSG: ' + error_message() + ' | Values: ' + convert(varchar(10), @BookID) + ',' + convert(varchar(10), @UserID) + ',' + convert(varchar(10), @IsFavorite) + ',' + convert(varchar(30), @ShelvedDate, 120);
    end catch
end 
go

drop procedure if exists Posts_Insert;
go
create procedure  Posts_Insert(
--     @ID int,
    @DatePosted datetime2,
    @UserPosterID int,
    @CommunityID int,
    @Content varchar(255),
    @Title varchar(30)
) as
begin
    begin try
--         Note: ID is IDENTITY (autoincrement)
        insert into Posts (DatePosted, UserPosterID, CommunityID, Content, Title)
        values (@DatePosted, @UserPosterID, @CommunityID, @Content, @Title);
    end try
    begin catch
        print 'Posts_Insert | ERROR | MSG: ' + error_message() + ' | Values: ' + convert(varchar(30), @DatePosted, 120) + ',' + convert(varchar(10), @UserPosterID) + ',' + convert(varchar(10), @CommunityID) + ',' + @Content + ',' + @Title;
    end catch
end 
go



drop procedure if exists Book_User_Reads_Insert; 
go
create procedure Book_User_Reads_Insert(
    @BookID int,
    @UserID int,
    @ReadTimeMiliseconds bigint,
    @ReadDate datetime2
) as
begin
    begin try
        insert into Book_User_Reads (BookID, UserID, ReadTimeMiliseconds, ReadDate)
        values (@BookID, @UserID, @ReadTimeMiliseconds, @ReadDate)
    end try
    begin catch
        print 'Book_User_Reads_Insert | ERROR | MSG: ' + error_message() + ' | Values: ' + convert(varchar(10), @BookID) + ',' + convert(varchar(10), @UserID) + ',' + convert(varchar(20), @ReadTimeMiliseconds) + ',' + convert(varchar(30), @ReadDate, 120);
    end catch
end 
go

drop procedure if exists Comment_Insert; 
go
create procedure  Comment_Insert(
--     @ID int (is autoincremental by default
    @UserID int,
    @Content varchar(400),
    @PostID int,
    @ParentCommentID int
) as
begin
    begin try
        insert into Comment (UserID, PostID, Content, ParentCommentID)
        values (@UserID, @PostID, @Content, @ParentCommentID);
    end try
    begin catch
        print 'Comment_Insert | ERROR | MSG: ' + error_message() + ' | Values: ' + convert(varchar(10), @UserID) + ',' + convert(varchar(10), @PostID) + ',' + @Content + ',' + convert(varchar(10), @ParentCommentID);
    end catch
end
go

drop procedure if exists User_Community_Follow_Insert; 
go
create procedure User_Community_Follow_Insert(
    @UserID int,
    @CommunityID int,
    @FollowedDate datetime2
) as
begin
    begin try
        insert into User_Community_Follow (UserID, CommunityID, FollowedDate)
        values (@UserID, @CommunityID, @FollowedDate);
    end try
    begin catch
        print 'User_Community_Follow_Insert | ERROR | MSG: ' + error_message() + ' | Values: ' + convert(varchar(10), @UserID) + ',' + convert(varchar(10), @CommunityID) + ',' + convert(varchar(30), @FollowedDate, 120);
    end catch
end
go

select * from sys.procedures;