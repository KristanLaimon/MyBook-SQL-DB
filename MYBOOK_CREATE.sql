

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'MYBOOK')
  BEGIN
      CREATE DATABASE MYBOOK;
	  PRINT '=== Creando base de datos MYBOOK ===';
  END
ELSE
BEGIN
  PRINT '=== La base de datos MYBOOK ya existe. ===';
 END
GO

USE MYBOOK;

-------------------------------------------------------
-- Users table and related tables --
-------------------------------------------------------
CREATE TABLE Roles( -- =======================================================
    ID CHAR(2) PRIMARY KEY, -- create clustered index IDX_Roles_ID on Roles(ID);
    Name VARCHAR(20) UNIQUE NOT NULL,
    Priority TINYINT UNIQUE NOT NULL,

    constraint CK_userRoles_ID check(LEN(ID) = 2),
    constraint CK_userRoles_name check(LEN(Name) > 0),
    constraint CK_userRoles_priority check(Priority > 0)
);
create nonclustered index NON_IDX_Roles_Name on Roles(Name);
-- Not creating any column stores here

CREATE TABLE Suscriptions( -- =======================================================
    ID CHAR(2) PRIMARY KEY, -- create clustered index IDX_Suscriptions_ID on Suscriptions(ID);
    Name VARCHAR(30) UNIQUE,
    Description VARCHAR(250),
    PriceUSD DECIMAL(5,2),

    constraint ck_suscriptions_ID check(LEN(ID) = 2),
    constraint ck_suscriptions_name check(LEN(Name) > 0),
    constraint ck_suscriptions_description check(LEN(Description) > 0),
    constraint ck_suscriptions_price check(PriceUSD >= 0),
);
create nonclustered index NON_IDX_Suscriptions_Name on Suscriptions (Name);
create nonclustered columnstore index NON_CLU_Suscriptions_PriceUSD on Suscriptions (PriceUSD);

CREATE TABLE Users( -- =======================================================
    ID INT PRIMARY KEY IDENTITY(1,1), -- create clustered index IDX_Users_ID on Users(ID);
    Name VARCHAR(20) UNIQUE NOT NULL,
    PasswordHash CHAR(64) NOT NULL,
    Email VARCHAR(30) UNIQUE NOT NULL,
    IsVerified BIT DEFAULT 0 NOT NULL, -- Default 0 (false)
    RoleID CHAR(2) NOT NULL,
    SubscriptionID CHAR(2) NOT NULL,
    RenewSuscriptionDate DATETIME2 NOT NULL

    CONSTRAINT FK_User_Role FOREIGN KEY (RoleID) REFERENCES Roles(ID),
    CONSTRAINT FK_User_Suscription FOREIGN KEY (SubscriptionID) REFERENCES Suscriptions(ID),
    CONSTRAINT CK_Users_Name CHECK (LEN(Name) > 0),
    CONSTRAINT CK_Users_Password CHECK (LEN(PasswordHash) = 64),
    CONSTRAINT CK_Users_Email CHECK (LEN(Email) > 0)
);
create nonclustered index NON_IDX_Users_Name on Users(Name);
-- not creating any column stores here

------------------------------------
-- Books table and related tables --
------------------------------------
CREATE TABLE Genres( -- =======================================================
    ID CHAR(2) PRIMARY KEY, -- create clustered index IDX_Genres_ID on Genres(ID);
    Name VARCHAR(20) UNIQUE NOT NULL,

    CONSTRAINT CK_Genres_Name CHECK (LEN(Name) > 0),
    CONSTRAINT CK_Genres_ID CHECK (LEN(ID) = 2)
);
create nonclustered index NON_IDX_Genres_Name on Genres(Name);
-- not creating any column stores here


CREATE TABLE Languages( -- =======================================================
    ID CHAR(2) PRIMARY KEY, -- create clustered index IDX_Languages_ID on Languages(ID);
    Name VARCHAR(30) UNIQUE NOT NULL,

    CONSTRAINT CK_Languages_Name CHECK (LEN(Name) > 0),
    CONSTRAINT CK_Languages_ID CHECK (LEN(ID) = 2)
);
create nonclustered index NON_IDX_Languages_Name on Languages(Name);
-- not creating any column stores here

CREATE TABLE Books ( -- =======================================================
    ID INT PRIMARY KEY IDENTITY(1,1), -- create clustered index IDX_Books_ID on Books(ID)
    Name VARCHAR(30) NOT NULL,
    Description VARCHAR(400) NOT NULL,
    ISBN CHAR(13) UNIQUE NOT NULL,
    Edition TINYINT DEFAULT 1 NOT NULL, -- Default 1st Edition
    IsVerified BIT DEFAULT 0 NOT NULL, -- Default 0 (false)
    PublishedUploadDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    PublishedBookDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    LanguageID CHAR(2) NOT NULL,
    GenreID CHAR(2) NOT NULL,
    UserUploaderID INT NOT NULL,

    CONSTRAINT CK_Book_Name CHECK (LEN(Name) > 0),
    CONSTRAINT CK_Book_Description CHECK (LEN(Description) > 0),
    CONSTRAINT CK_Book_ISBN CHECK (LEN(ISBN) = 13),
    CONSTRAINT CK_Book_PublishedBookDate CHECK(PublishedBookDate > CAST('1900-01-01 01:00:00' AS datetime2)),

    CONSTRAINT FK_Book_Language FOREIGN KEY (LanguageID) REFERENCES Languages(ID),
    CONSTRAINT FK_Book_Genre FOREIGN KEY (GenreID) REFERENCES Genres(ID),
    CONSTRAINT FK_Book_User FOREIGN KEY (UserUploaderID) REFERENCES Users(ID)
);
create nonclustered index NON_IDX_Books_Name on Books(Name);
create nonclustered index NON_IDX_Books_PublishedUploadDate on Books(PublishedUploadDate);
create nonclustered index NON_IDX_Books_PublishedBookDate on Books(PublishedBookDate);
-- not creating any column stores here

---------------------------------------
-- Comunity table and related tables --
---------------------------------------
CREATE TABLE Communities( -- =======================================================
    BookID INT PRIMARY KEY NOT NULL, -- create clustered index IDX_Communities_BookID on Communities(BookID)
    UserAuthorID INT NOT NULL,
    Title varchar(30) NOT NULL,
    Description varchar(250) NOT NULL,

    CONSTRAINT FK_Book_Community FOREIGN KEY (BookID) REFERENCES Books(ID),
    CONSTRAINT FK_Owner_Community FOREIGN KEY (UserAuthorID) REFERENCES Users(ID),
    CONSTRAINT CK_Communities_Title CHECK (LEN(Title) > 0),
    CONSTRAINT CK_Communities_Description CHECK (LEN(Description) > 0)
);
create nonclustered index NON_IDX_Communities_UserAuthorID on Communities(UserAuthorID);
create nonclustered index NON_IDX_Communities_Title on Communities(Title);
-- not creating any column stores here

CREATE TABLE Posts( -- =======================================================
    ID INT PRIMARY KEY IDENTITY (1, 1), -- create clustered index IDX_Posts_ID on Posts(ID);
    DatePosted DATETIME2 NOT NULL DEFAULT GETDATE(),
    UserPosterID INT NOT NULL,
    CommunityID INT NOT NULL,
    Content VARCHAR(255) NOT NULL,
    Title VARCHAR(30) NOT NULL,

    CONSTRAINT FK_Community_Post FOREIGN KEY (CommunityID) REFERENCES Communities(BookID),
    CONSTRAINT FK_Owner_Post FOREIGN KEY (UserPosterID) REFERENCES Users(ID),
    CONSTRAINT CK_Post_Title CHECK (LEN(Title) > 0),
    CONSTRAINT CK_Post_Content CHECK (LEN(Content) > 0)
);
create nonclustered index NON_IDX_Posts_DatePosted on Posts(DatePosted);
-- not creating any column stores here

CREATE TABLE Comment( -- =======================================================
    ID INT PRIMARY KEY NOT NULL IDENTITY(1,1), -- create clustered index IDX_Comment_ID on Comment(ID);
    UserID INT NOT NULL,
    Content VARCHAR(400) NOT NULL,
    PostID INT NULL,
    ParentCommentID INT NULL,

    CONSTRAINT FK_Owner_Comment FOREIGN KEY (UserID) REFERENCES Users(ID),
    CONSTRAINT FK_Post_Comment FOREIGN KEY (PostID) REFERENCES Posts(ID),
    CONSTRAINT FK_Parent_Comment FOREIGN KEY (ParentCommentID) REFERENCES Comment(ID),
    CONSTRAINT CHK_References_Comment CHECK (
    (PostID IS NOT NULL OR ParentCommentID IS NOT NULL)
    AND
    (PostID IS NULL OR ParentCommentID IS NULL)
    )
);
create nonclustered index NON_IDX_Comment_UserID on Comment(UserID);
-- not creating any column stores here

--#region Many to many tables
-----------------------------------------------------------
                -- Many to Many tables --
-----------------------------------------------------------
CREATE TABLE Book_User_Shelve( -- =======================================================
    BookID INT NOT NULL,
    UserID INT NOT NULL,
    IsFavorite BIT DEFAULT 0, -- False
    ShelvedDate DATETIME2 NOT NULL DEFAULT GETDATE()

    PRIMARY KEY (BookID, UserID), -- create clustered index IDX_BookUserShelve on Book_User_Shelve(BookID, UserID)
    CONSTRAINT FK_User_Shelve FOREIGN KEY (UserID) REFERENCES Users(ID),
    CONSTRAINT FK_Book_Shelve FOREIGN KEY (BookID) REFERENCES Books(ID)
);
create nonclustered index NON_IDX_BookUserShelve_BookID on Book_User_Shelve(BookID);
create nonclustered index NON_IDX_BookUserShelve_UserID on Book_User_Shelve(UserID);
-- not creating any column stores here


CREATE TABLE Book_User_Reads( -- =======================================================
    BookID INT NOT NULL,
    UserID INT NOT NULL,
    ReadTimeMiliseconds BIGINT NOT NULL,
    ReadDate DATETIME2 NOT NULL DEFAULT GETDATE(),

    constraint PK_BookUserReads primary key (BookID, UserID), -- create clustered index IDX_Book_User_Reads on Book_User_Reads(BookID, UserID);
    CONSTRAINT FK_User_Reads FOREIGN KEY (UserID) REFERENCES Users(ID),
    CONSTRAINT FK_Book_Reads FOREIGN KEY (BookID) REFERENCES Books(ID),
    CONSTRAINT CK_ReadTime CHECK(ReadTimeMiliseconds > 0)
);
create nonclustered index NON_IDX_BookUserReads_ReadDate on Book_User_Reads(ReadDate);
-- not creating any column stores here


CREATE TABLE Book_User_Reviews( -- =======================================================
    BookID INT NOT NULL,
    UserID INT NOT NULL,
    Rating TINYINT NOT NULL,
    Comment varchar(400) NOT NULL

    PRIMARY KEY (BookID, UserID), -- create clustered index IDX_BookUserReviews on Book_User_Reviews(BookID, UserID)
    CONSTRAINT FK_User_Reviews FOREIGN KEY (UserID) REFERENCES Users(ID),
    CONSTRAINT FK_Book_Reviews FOREIGN KEY (BookID) REFERENCES Books(ID),
    CONSTRAINT CK_Rating CHECK(Rating >= 0 AND Rating <= 5),
    CONSTRAINT CK_Book_User_Comment CHECK(LEN(Comment) >= 0)
);
create nonclustered index NON_IDX_BookUserReviews_Rating on Book_User_Reviews (Rating);
-- not creating any column stores here


CREATE TABLE User_Community_Follow( -- =======================================================
    UserID INT NOT NULL,
    CommunityID INT NOT NULL,
    FollowedDate DATETIME2 NOT NULL DEFAULT GETDATE(),

    PRIMARY KEY (UserID, CommunityID), -- create clustered index IDX_UserCommunityFollow on User_Community_Follow(UserID,CommunityID);
    CONSTRAINT FK_User_Follow FOREIGN KEY (UserID) REFERENCES Users(ID),
    CONSTRAINT FK_Community_Follow FOREIGN KEY (CommunityID) REFERENCES Communities(BookID)
);
create nonclustered index NON_IDX_UserCommunityFollow_FollowedDate on User_Community_Follow (FollowedDate);
-- not creating any column stores here



CREATE TABLE User_User_Suscribe( -- =======================================================
    SuscriberID INT NOT NULL,
    SuscribedToID INT NOT NULL,
    SuscriptionDate DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_User_Suscriber PRIMARY KEY (SuscriberID, SuscribedToID), -- create clustered index IDX_UserUserSuscribe on User_User_Suscribe(SuscriberID,SuscribedToID);
    CONSTRAINT FK_Suscriber FOREIGN KEY (SuscriberID) REFERENCES Users(ID),
    CONSTRAINT FK_SuscribedTo FOREIGN KEY (SuscribedToID) REFERENCES Users(ID),
    CONSTRAINT CK_User_Follows_Themself CHECK (SuscriberID <> SuscribedToID)
);
create nonclustered index NON_IDX_UserUserSuscribe_SuscriptionDate on User_User_Suscribe (SuscriptionDate);
--#endregion