

use MYBOOK;

INSERT INTO Roles (ID, Name, Priority) VALUES ('AD', 'Administrator', 1);
INSERT INTO Roles (ID, Name, Priority) VALUES ('MG', 'Manager', 2);
INSERT INTO Roles (ID, Name, Priority) VALUES ('ED', 'Editor', 3);
INSERT INTO Roles (ID, Name, Priority) VALUES ('VW', 'Viewer', 4);
INSERT INTO Roles (ID, Name, Priority) VALUES ('GT', 'Guest', 5);
INSERT INTO Roles (ID, Name, Priority) VALUES ('MD', 'Moderator', 6);
INSERT INTO Roles (ID, Name, Priority) VALUES ('SU', 'SuperUser', 7);
INSERT INTO Roles (ID, Name, Priority) VALUES ('DV', 'Developer', 8);

INSERT INTO Suscriptions (ID, Name, Description, PriceUSD) VALUES ('BP', 'Basic Plan', 'Limited access to basic content', 8.99);
INSERT INTO Suscriptions (ID, Name, Description, PriceUSD) VALUES ('PP', 'Premium Plan', 'Full access to all content and features', 18.99);
INSERT INTO Suscriptions (ID, Name, Description, PriceUSD) VALUES ('FP', 'Family Plan', 'Plan for 3 members with full access', 29.99);
INSERT INTO Suscriptions (ID, Name, Description, PriceUSD) VALUES ('SP', 'Student Plan', 'Discounted plan for students', 3.99);
INSERT INTO Suscriptions (ID, Name, Description, PriceUSD) VALUES ('EP', 'Enterprise Plan', 'Plan for businesses with multiple users', 48.99);
INSERT INTO Suscriptions (ID, Name, Description, PriceUSD) VALUES ('PR', 'Pro Plan', 'Professional access with advanced tools', 13.99);
INSERT INTO Suscriptions (ID, Name, Description, PriceUSD) VALUES ('TP', 'Trial Plan', '6-day free trial', 0.00);
INSERT INTO Suscriptions (ID, Name, Description, PriceUSD) VALUES ('OP', 'One-Time Purchase', 'One-time payment for full access', 98.99);

INSERT INTO Users (Name, PasswordHash, Email, IsVerified, RoleID, SubscriptionID, RenewSuscriptionDate) VALUES ('Alice', 'a' + REPLICATE('a', 63), 'alice@example.com', 1, 'AD', 'BP', '2025-02-10 10:00:00');
INSERT INTO Users (Name, PasswordHash, Email, IsVerified, RoleID, SubscriptionID, RenewSuscriptionDate) VALUES ('Bob', 'b' + REPLICATE('b', 63), 'bob@example.com', 1, 'MG', 'PP', '2025-03-01 12:00:00');
INSERT INTO Users (Name, PasswordHash, Email, IsVerified, RoleID, SubscriptionID, RenewSuscriptionDate) VALUES ('Charlie', 'c' + REPLICATE('c', 63), 'charlie@example.com', 0, 'ED', 'FP', '2025-05-01 12:00:00');
INSERT INTO Users (Name, PasswordHash, Email, IsVerified, RoleID, SubscriptionID, RenewSuscriptionDate) VALUES ('David', 'd' + REPLICATE('d', 63), 'david@example.com', 0, 'VW', 'SP', '2025-07-01 08:00:00');
INSERT INTO Users (Name, PasswordHash, Email, IsVerified, RoleID, SubscriptionID, RenewSuscriptionDate) VALUES ('Eve', 'e' + REPLICATE('e', 63), 'eve@example.com', 1, 'GT', 'EP', '2025-09-01 10:00:00');
INSERT INTO Users (Name, PasswordHash, Email, IsVerified, RoleID, SubscriptionID, RenewSuscriptionDate) VALUES ('Frank', 'f' + REPLICATE('f', 63), 'frank@example.com', 1, 'MD', 'PR', '2025-12-15 09:00:00');
INSERT INTO Users (Name, PasswordHash, Email, IsVerified, RoleID, SubscriptionID, RenewSuscriptionDate) VALUES ('Grace', 'g' + REPLICATE('g', 63), 'grace@example.com', 0, 'SU', 'TP', '2025-04-10 11:00:00');
INSERT INTO Users (Name, PasswordHash, Email, IsVerified, RoleID, SubscriptionID, RenewSuscriptionDate) VALUES ('Hank', 'h' + REPLICATE('h', 63), 'hank@example.com', 1, 'DV', 'OP', '2025-06-01 08:00:00');


INSERT INTO User_User_Suscribe (SuscriberID, SuscribedToID) VALUES (1, 2);
INSERT INTO User_User_Suscribe (SuscriberID, SuscribedToID) VALUES (3, 4);
INSERT INTO User_User_Suscribe (SuscriberID, SuscribedToID) VALUES (5, 6);
INSERT INTO User_User_Suscribe (SuscriberID, SuscribedToID) VALUES (6, 7);
INSERT INTO User_User_Suscribe (SuscriberID, SuscribedToID) VALUES (7, 8);
INSERT INTO User_User_Suscribe (SuscriberID, SuscribedToID) VALUES (2, 1);
INSERT INTO User_User_Suscribe (SuscriberID, SuscribedToID) VALUES (4, 5);
INSERT INTO User_User_Suscribe (SuscriberID, SuscribedToID) VALUES (8, 3);


INSERT INTO Genres (ID, Name) VALUES ('FA', 'Fantasy');
INSERT INTO Genres (ID, Name) VALUES ('SF', 'Science Fiction');
INSERT INTO Genres (ID, Name) VALUES ('MY', 'Mystery');
INSERT INTO Genres (ID, Name) VALUES ('RO', 'Romance');
INSERT INTO Genres (ID, Name) VALUES ('TH', 'Thriller');
INSERT INTO Genres (ID, Name) VALUES ('HF', 'Historical Fiction');
INSERT INTO Genres (ID, Name) VALUES ('HO', 'Horror');
INSERT INTO Genres (ID, Name) VALUES ('AD', 'Adventure');


INSERT INTO Languages (ID, Name) VALUES ('EN', 'English');
INSERT INTO Languages (ID, Name) VALUES ('ES', 'Spanish');
INSERT INTO Languages (ID, Name) VALUES ('FR', 'French');
INSERT INTO Languages (ID, Name) VALUES ('DE', 'German');
INSERT INTO Languages (ID, Name) VALUES ('IT', 'Italian');
INSERT INTO Languages (ID, Name) VALUES ('PT', 'Portuguese');
INSERT INTO Languages (ID, Name) VALUES ('RU', 'Russian');
INSERT INTO Languages (ID, Name) VALUES ('JP', 'Japanese');



insert into Books (Name, Description, ISBN, Edition, IsVerified, PublishedUploadDate, PublishedBookDate, LanguageID, GenreID, UserUploaderID, Stock) VALUES ('Book 1', 'This is a description of the book.', '9781234567890', 1, 1, '2025-02-09 10:00:00', '2025-02-09 10:00:00', 'EN', 'FA', 1, 10);
insert into Books (Name, Description, ISBN, Edition, IsVerified, PublishedUploadDate, PublishedBookDate, LanguageID, GenreID, UserUploaderID, Stock) VALUES ('Book 2', 'This is a description of the book.', '9781234567891', 1, 1, '2005-06-15 09:00:00', '2025-02-09 10:00:00', 'ES', 'SF', 2, 12);
insert into Books (Name, Description, ISBN, Edition, IsVerified, PublishedUploadDate, PublishedBookDate, LanguageID, GenreID, UserUploaderID, Stock) VALUES ('Book 3', 'This is a description of the book.', '9781234567892', 1, 1, '2010-11-22 10:00:00', '2025-02-09 10:00:00', 'FR', 'MY', 3, 14);
insert into Books (Name, Description, ISBN, Edition, IsVerified, PublishedUploadDate, PublishedBookDate, LanguageID, GenreID, UserUploaderID, Stock) VALUES ('Book 4', 'This is a description of the book.', '9781234567893', 1, 1, '2018-01-01 08:00:00', '2025-02-09 10:00:00', 'DE', 'RO', 4, 16);
insert into Books (Name, Description, ISBN, Edition, IsVerified, PublishedUploadDate, PublishedBookDate, LanguageID, GenreID, UserUploaderID, Stock) VALUES ('Book 5', 'This is a description of the book.', '9781234567894', 1, 1, '2015-03-10 11:00:00', '2025-02-09 10:00:00', 'IT', 'TH', 5, 18);
insert into Books (Name, Description, ISBN, Edition, IsVerified, PublishedUploadDate, PublishedBookDate, LanguageID, GenreID, UserUploaderID, Stock) VALUES ('Book 6', 'This is a description of the book.', '9781234567895', 1, 1, '2015-03-10 11:00:00', '2025-02-09 10:00:00', 'PT', 'HO', 6, 20);
insert into Books (Name, Description, ISBN, Edition, IsVerified, PublishedUploadDate, PublishedBookDate, LanguageID, GenreID, UserUploaderID, Stock) VALUES ('Book 7', 'This is a description of the book.', '9781234567896', 1, 1, '2015-03-10 11:00:00', '2025-02-09 10:00:00', 'RU', 'AD', 7, 22);
insert into Books (Name, Description, ISBN, Edition, IsVerified, PublishedUploadDate, PublishedBookDate, LanguageID, GenreID, UserUploaderID, Stock) VALUES ('Book 8', 'This is a description of the book.', '9781234567897', 1, 1, '2015-03-10 11:00:00', '2025-02-09 10:00:00', 'JP', 'HF', 8, 24);

INSERT INTO Communities (BookID, UserAuthorID, Title, Description)
VALUES
    (1, 1, 'First Community Ever Created', 'Hi!, this is the first community created in this app for the book "Hello World"...'),
    (2, 2, 'Fantasy Readers', 'A space to discuss epic fantasy novels and world-building.'),
    (3, 3, 'Science Explorers', 'Dive into hard science fiction and futuristic technologies.'),
    (4, 4, 'Thriller Lovers', 'Unravel mysteries and psychological thrillers together.'),
    (5, 5, 'Romance Enthusiasts', 'Share heartfelt stories and character-driven romances.'),
    (6, 1, 'Tech & Innovation', 'Explore books about cutting-edge technology and startups.'),
    (7, 2, 'Historical Deep Dives', 'Analyze historical accuracy in historical fiction.'),
    (8, 3, 'Non-Fiction Critics', 'Debate the best non-fiction works of the decade.');


INSERT INTO Posts (UserPosterID, CommunityID, Content, Title)
VALUES
    (1, 1, 'Welcome to the community! Enjoy your stay.', 'Welcome'),
    (2, 2, 'Understanding the basics of SQL Server can improve your skills.', 'SQL Basics'),
    (3, 1, 'Let''s discuss the latest trends in web development and design.', 'Web Dev Trends'),
    (4, 3, 'Here are some tips and tricks for optimizing database performance.', 'DB Performance'),
    (5, 2, 'Share your experiences with migrating systems to the cloud.', 'Cloud Migration'),
    (6, 3, 'A beginner''s guide to writing and using stored procedures.', 'Stored Procedures'),
    (7, 1, 'Discussing the pros and cons of various NoSQL databases.', 'NoSQL Debate'),
    (8, 2, 'Check out the upcoming tech conferences that you shouldnt miss.', 'Tech Conferences');


INSERT INTO Comment (UserID, Content, PostID, ParentCommentID)
VALUES
    (1, 'This is a comment directly on the post.', 1, NULL),
    (2, 'I found this post very informative.', 2, NULL),
    (3, 'Great insights provided here!', 3, NULL),
    (4, 'I have some reservations about the post.',4, NULL),
    (5, 'I agree with your point!', NULL, 1),
    (6, 'Could you explain further?', NULL, 2),
    (7, 'Interesting perspective thanks for sharing!', NULL, 1),
    (8, 'I have a follow-up question regarding your reply.', NULL, 5);


INSERT INTO Book_User_Shelve (BookID, UserID, IsFavorite)
VALUES
    (1, 1, 0),
    (2, 2, 1),
    (3, 3, 1),
    (4, 4, 0),
    (5, 5, 1),
    (6, 6, 1),
    (7, 7, 0),
    (8, 8, 1);



INSERT INTO Book_User_Reads (BookID, UserID, ReadTimeMiliseconds)
VALUES
    (1, 1, 5000),
    (2, 2, 10000),
    (3, 3, 15000),
    (4, 4, 20000),
    (5, 5, 25000),
    (6, 6, 30000),
    (7, 7, 35000),
    (8, 8, 40000);


INSERT INTO Book_User_Reviews (BookID, UserID, Rating, Comment)
VALUES
    (1, 1, 3, 'A solid read with engaging characters.'),
    (3, 2, 5, 'Absolutely brilliant and inspiring.'),
    (3, 3, 4, 'Very enjoyable, though a bit slow in parts.'),
    (4, 4, 2, 'Not as expected, lacking depth.'),
    (5, 5, 0, 'Did not live up to the hype.'),
    (6, 6, 1, 'Poor execution and a dull narrative.'),
    (7, 7, 4, 'Well-written with an interesting plot.'),
    (8, 8, 3, 'Good book overall, but could be better.');


INSERT INTO User_Community_Follow (UserID, CommunityID, FollowedDate)
VALUES
    (1, 1, DATEADD(YEAR, 10, GETDATE())),
    (2, 2, DATEADD(YEAR, 10, GETDATE())),
    (3, 3, DATEADD(YEAR, 10, GETDATE())),
    (4, 4, DATEADD(YEAR, 10, GETDATE())),
    (5, 5, DATEADD(YEAR, 10, GETDATE())),
    (6, 6, DATEADD(YEAR, 10, GETDATE())),
    (7, 7, DATEADD(YEAR, 10, GETDATE())),
    (8, 8, DATEADD(YEAR, 10, GETDATE()));
