--                               KRISTAN RU�Z LIM�N
-- ========================== Recuperaci�n sencilla SQL ================================

-- Query 1 (1): Todos los libros que sean oficialmente registrados del g�nero de fantas�a
SELECT * FROM Books B WHERE B.ISBN IS NOT NULL AND B.GenreID = 'FA';

-- Query 2 (2): Todos los libros que sean de edici�n 1..3
SELECT * FROM Books B WHERE B.Edition BETWEEN 1 AND 3;

-- Query 3 (3): Reviews con calificaciones buenas (de 0 a 5, pero que sea mayor a 4)
SELECT * FROM Book_User_Reviews BUR WHERE BUR.Rating >= 4;

-- Query 4 (4): Roles
SELECT * FROM Roles;

-- Query 5 (5): Todos los libros que hayan sido publicados (no en la  plataforma MyBook) antes del 2010
SELECT * FROM Books B WHERE YEAR(B.PublishedBookDate) < 2010;

-- Query 6 (6): Todos los nuevos seguidores que ocurrieron ayer
SELECT * FROM User_User_Suscribe UUS WHERE UUS.SuscriptionDate < (GETDATE() - 1);

-- Query 7 (7): Veces que se han leido los libros
SELECT BUR.BookID, COUNT(*) as 'Times Read' FROM Book_User_Reads BUR GROUP BY BUR.BookID;

-- Query 8 (8): Todas las suscripciones que valgan 20 o m�s d�lares
SELECT * FROM Suscriptions S WHERE S.PriceUSD >= 20;

-- Query 9 (9): Roles que su nombre empiecen con a
SELECT * FROM Roles R WHERE R.Name LIKE 'a%';

-- Query 10 (10): Libros que su nombre est� en el rango de B..F
SELECT * FROM Books B WHERE B.Name LIKE '[B-F]%';


 --========================== Recuperaci�n de m�s de una tabla SQL ==========================

-- Query 1 (11): Todas las comunidades en las que ha posteado usuarios con username que empiecen con 'A' (Insensitive)
SELECT C.Title, U.Name, COUNT(*) as 'No. Posts'
FROM Posts P
JOIN Communities C ON P.CommunityID = C.BookID
JOIN Users U ON P.UserPosterID = U.ID
WHERE U.Name LIKE 'A%'
GROUP BY C.Title, U.Name;

-- Query 2 (12): Todos los usuarios que no tengan seguidores
SELECT U.Name, COUNT(*) as 'No. Followers'
FROM User_User_Suscribe UUS
JOIN Users U ON U.ID = UUS.SuscribedToID
GROUP BY UUS.SuscribedToID, U.Name
HAVING COUNT(*) = 0;

-- Query 3 (13): Libros favoritos 
SELECT B.Name, 
	CASE
		WHEN BUS.IsFavorite = 1 THEN 'Favorito'
		WHEN bus.IsFavorite = 0 THEN 'No favorito'
		ELSE 'Error Raro: No tiene valor booleano'
	END AS IsPreferredSpanish
FROM Book_User_Shelve BUS
JOIN Books B ON B.ID = BUS.BookID;

-- Query 4 (14): Nombre de usuarios y libros le�dos por m�s de 12 minutos
SELECT U.Name, B.Name, CONCAT(SUM(BUR.ReadTimeMiliseconds)/ 1000, ' Minutes') AS MinutesRead
FROM Book_User_Reads BUR
JOIN Users U ON U.ID = BUR.UserID
JOIN Books B ON U.ID = BUR.BookID
GROUP BY  U.Name, B.Name
HAVING SUM(BUR.ReadTimeMiliseconds) > 12000
ORDER BY MinutesRead DESC ;

-- Query 5 (15): Dame informaci�n de libros que hayan sido reseniados as� como el nombre de quien los reseni�
SELECT B.Name, U.Name
FROM Book_User_Reads BUR
JOIN Books B ON BUR.BookID = B.ID
JOIN Users U ON BUR.UserID = U.ID;

-- Query 6 (16): Dame las 3 comunidades com mayores seguidores/suscriptores ordenados de m�s seguidores a menos
SELECT TOP 3 C.Title, COUNT(*) 'Followers'
FROM User_Community_Follow UCF
JOIN Communities C ON C.BookID = UCF.CommunityID
GROUP BY C.BookID, C.Title
ORDER BY COUNT(*) DESC;

-- Query 7 (17): Dame todos los usuarios que lean libros en espanol
SELECT U.Name, B.Name, B.LanguageID
FROM Book_User_Reads BUR
JOIN Books B ON BUR.BookID = B.ID
JOIN Users U ON BUR.UserID = U.ID
WHERE B.LanguageID = 'ES';

-- Query 8 (18): Top Usuarios Activos por Tiempo de Lectura
-- Esta consulta muestra, para cada usuario, el total de tiempo de lectura (en milisegundos) y la cantidad de libros leídos. Identifica a los usuarios más activos en la plataforma.
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
ORDER BY TotalTiempoLectura DESC;

-- Query 9 (19): Promedio de Calificaciones por Género de Libros
-- Esta consulta une las tablas de Books, Book_User_Reviews y Genres para mostrar, por cada género, el número total de reseñas y la calificación promedio. 
-- Se filtran aquellos géneros que tengan al menos 2 reseñas y una calificación promedio igual o superior a 3. 
-- Es muy útil para identificar qué géneros tienen mejores opiniones de los usuarios.
SELECT 
    G.Name AS Genero, 
    COUNT(R.UserID) AS NumeroResenas, 
    AVG(R.Rating) AS CalificacionPromedio
FROM Books AS B
INNER JOIN Book_User_Reviews AS R
    ON B.ID = R.BookID
INNER JOIN Genres AS G
    ON B.GenreID = G.ID
GROUP BY G.Name
HAVING COUNT(R.UserID) >= 2 AND AVG(R.Rating) >= 3
ORDER BY CalificacionPromedio DESC;

-- Query 10 (20): Número de Suscriptores por Usuario
-- Identifica a los usuarios con mayor influencia o popularidad en la plataforma
SELECT 
    U.Name AS Usuario, 
    COUNT(US.SuscriberID) AS NumeroSuscriptores
FROM Users AS U
INNER JOIN User_User_Suscribe AS US
    ON U.ID = US.SuscribedToID
GROUP BY U.Name
HAVING COUNT(US.SuscriberID) >= 1
ORDER BY NumeroSuscriptores DESC;


-- ========================== Recuperaci�n de m�s de una tabla SQL ==========================

-- Query 1 (21): Informaci�n del rol con m�s prioridad
SELECT * FROM Roles WHERE Roles.Priority = (SELECT MAX(R.Priority) FROM Roles R)

-- Query 2 (22): Dame todos los usuarios con suscripci�n gratuita que han posteado � comentado al menos una vez en las comunidades
--Te dice de qu� comunidad, el nombre, sus suscripci�n y cu�ntos public�
SELECT C.Title, U.Name, S.ID, S.Name, S.Description, (SELECT COUNT(*) FROM Posts P1 WHERE P1.UserPosterID = U.ID) AS 'No. Posts Posted'
FROM Users U
JOIN Suscriptions S ON U.SubscriptionID  = S.ID
JOIN User_Community_Follow UCF ON UCF.UserID = U.ID
JOIN Communities C ON C.BookID = UCF.CommunityID
WHERE S.ID = 'TP'
AND U.ID IN (SELECT P2.UserPosterID FROM Posts P2)

-- Query 3 (23): Dame todos los usuarios que sigan la comunidad de los libros que est�n leyendo por m�s de 30 minutos
select bur.UserID, bur.BookID, concat(sum(bur.ReadTimeMiliseconds / 1000), ' minutes') as Reading_Time
from Book_User_Reads bur
where bur.UserID in (
		select ucf.UserID 
		from User_Community_Follow ucf 
		join Communities c on c.BookID = ucf.CommunityID 
		where c.BookID = bur.BookID)
group by bur.UserID, bur.BookID
having sum(bur.ReadTimeMiliseconds) > 30000

-- Query 4 (24): Top 5 usuarios por tiempo total de lectura
-- Utiliza una subconsulta (tabla derivada) para calcular, por usuario, el total de tiempo invertido en lectura y luego selecciona los 5 usuarios con mayor actividad.
SELECT TOP 5 Sub.Usuario, Sub.TotalLectura
FROM (
    SELECT 
        U.ID,
        U.Name AS Usuario,
        SUM(R.ReadTimeMiliseconds) AS TotalLectura
    FROM Users U
    INNER JOIN Book_User_Reads R ON U.ID = R.UserID
    GROUP BY U.ID, U.Name
    HAVING SUM(R.ReadTimeMiliseconds) > 0
) AS Sub
ORDER BY Sub.TotalLectura DESC;

-- Query 5 (25): Comunidades con más de 1 post
-- Para cada comunidad se cuenta el número de posts mediante una subconsulta tanto en el SELECT como en el WHERE para filtrar aquellas que tengan más de 1 post.
SELECT 
    C.Title AS Comunidad,
    (SELECT COUNT(*) 
     FROM Posts P 
     WHERE P.CommunityID = C.BookID) AS NumeroPosts
FROM Communities C
WHERE (SELECT COUNT(*) 
       FROM Posts P 
       WHERE P.CommunityID = C.BookID) > 1;


-- Query 6 (26): Usuarios con más de 1 seguidor
-- Muestra a los usuarios que cuentan con más de un seguidor, contando la cantidad de seguidores con una subconsulta.
SELECT 
    U.Name AS Usuario,
    (SELECT COUNT(*) 
     FROM User_User_Suscribe S 
     WHERE S.SuscribedToID = U.ID) AS NumeroSeguidores
FROM Users U
WHERE (SELECT COUNT(*) 
       FROM User_User_Suscribe S 
       WHERE S.SuscribedToID = U.ID) > 1;

-- Query 7 (27): Planes de suscripción con usuarios verificados
-- Para cada plan de suscripción, se cuenta cuántos usuarios verificados lo tienen, 
-- utilizando subconsultas en el SELECT y WHERE para filtrar aquellos planes con al menos un usuario verificado.
SELECT 
    S.Name AS SubscriptionName,
    (SELECT COUNT(*) 
     FROM Users U 
     WHERE U.SubscriptionID = S.ID AND U.IsVerified = 1) AS UsuariosVerificados
FROM Suscriptions S
WHERE (SELECT COUNT(*) 
       FROM Users U 
       WHERE U.SubscriptionID = S.ID AND U.IsVerified = 1) > 0;

-- Query 8 (28): Géneros con promedio de calificación superior al promedio general
-- Agrupa las reseñas por género y filtra solo aquellos géneros cuya calificación promedio
-- es mayor que el promedio general (calculado mediante una subconsulta en HAVING).
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

-- Query 9 (29): Posts recientes de comunidades activas
-- Esta consulta muestra posts (ordenados por fecha descendente) de aquellas comunidades que tienen más de 2 posts.
-- Se utiliza una subconsulta para identificar las comunidades activas.
SELECT 
    P.Title AS PostTitulo,
    P.Content,
    P.DatePosted,
    C.Title AS Comunidad
FROM Posts P
INNER JOIN Communities C ON C.BookID = P.CommunityID
WHERE P.CommunityID IN (
    SELECT CommunityID 
    FROM (
         SELECT CommunityID, COUNT(*) AS NumPosts
         FROM Posts
         GROUP BY CommunityID
         HAVING COUNT(*) > 2
    ) AS Activas
)
ORDER BY P.DatePosted DESC;


-- Query 10 (30): Libros marcados como favoritos
-- Muestra los libros que han sido marcados como favoritos, incluyendo
-- la cantidad de veces que han sido agregados como favorito mediante subconsultas en el SELECT y WHERE.
SELECT 
    B.Name AS Libro,
    (SELECT COUNT(*) 
     FROM Book_User_Shelve BS 
     WHERE BS.BookID = B.ID AND BS.IsFavorite = 1) AS NumeroFavoritos
FROM Books B
WHERE (SELECT COUNT(*) 
       FROM Book_User_Shelve BS 
       WHERE BS.BookID = B.ID AND BS.IsFavorite = 1) > 0
ORDER BY NumeroFavoritos DESC;





