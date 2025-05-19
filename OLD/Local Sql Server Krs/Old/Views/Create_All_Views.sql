CREATE VIEW Users_AllUsers
AS select ID, Name from Users;

CREATE VIEW Books_GoodAverageBooks
AS
    SELECT
            G.Name AS Genero,
    AVG(R.Rating) AS PromedioCalificacion,
    COUNT(R.UserID) AS NumeroResenas
    FROM Genres G
    INNER JOIN Books B ON B.GenreID = G.ID
    INNER JOIN Book_User_Reviews R ON R.BookID = B.ID
    GROUP BY G.Name
    HAVING AVG(R.Rating) > (
        SELECT AVG(R2.Rating)
        FROM Book_User_Reviews R2
    );
GO

CREATE VIEW Books_FavoriteBooks
AS
SELECT
    B.Name AS Libro,
    (SELECT COUNT(*)
     FROM Book_User_Shelve BS
     WHERE BS.BookID = B.ID AND BS.IsFavorite = 1) AS NumeroFavoritos
FROM Books B
WHERE (SELECT COUNT(*)
       FROM Book_User_Shelve BS
       WHERE BS.BookID = B.ID AND BS.IsFavorite = 1) > 0;
GO

CREATE VIEW Users_MostReadingTime
AS
SELECT
    U.Name AS Usuario,
    SUM(R.ReadTimeMiliseconds) AS TotalTiempoLectura,
    COUNT(*) AS LibrosLeidos
FROM Users AS U
         INNER JOIN Book_User_Reads AS R
                    ON U.ID = R.UserID
WHERE R.ReadTimeMiliseconds > 0
GROUP BY U.Name
HAVING SUM(R.ReadTimeMiliseconds) > 0


CREATE VIEW Users_UsersWithNoSubscribers
as
SELECT U.Name, COUNT(*) as 'No. Followers'
FROM User_User_Suscribe UUS
         JOIN Users U ON U.ID = UUS.SuscribedToID
GROUP BY UUS.SuscribedToID, U.Name
HAVING COUNT(*) = 0;

