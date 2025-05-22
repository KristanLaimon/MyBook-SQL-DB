
USE MYBOOK;

-- Consulta 1: Ventas totales por mes para productos específicos (Libros)
-- Utiliza el índice columnstore NON_CLU_Orders_Total para agregaciones y el índice no agrupado NON_IDX_Orders_OrderDate para filtrado de fechas
SELECT
    DATEPART(YEAR, o.OrderDate) AS AñoVenta,
    DATEPART(MONTH, o.OrderDate) AS MesVenta,
    b.Name AS NombreLibro,
    SUM(o.Total) AS TotalVentas
FROM Orders o
         INNER JOIN Orders_Book_Have obh ON o.ID = obh.OrderID
         INNER JOIN Books b ON obh.BookID = b.ID
WHERE o.Status = 'paid'
GROUP BY DATEPART(YEAR, o.OrderDate), DATEPART(MONTH, o.OrderDate), b.Name
ORDER BY AñoVenta, MesVenta, NombreLibro;

-- Consulta 2: Clientes que han pedido productos de una categoría específica (Género) en un año determinado
-- Utiliza el índice no agrupado NON_IDX_Orders_OrderDate y NON_IDX_OrdersBookHave_BookID para uniones eficientes
DECLARE @Year INT = 2025;
DECLARE @GenreID CHAR(2) = 'FA'; -- Ejemplo: Género Fantasía
SELECT DISTINCT
    u.Name AS NombreUsuario,
    u.Email AS Correo,
    g.Name AS Género
FROM Users u
         INNER JOIN Orders o ON u.ID = o.UserID
         INNER JOIN Orders_Book_Have obh ON o.ID = obh.OrderID
         INNER JOIN Books b ON obh.BookID = b.ID
         INNER JOIN Genres g ON b.GenreID = g.ID
WHERE o.Status = 'paid'
  AND DATEPART(YEAR, o.OrderDate) = @Year
  AND g.ID = @GenreID
ORDER BY u.Name;

-- Consulta 3: Clientes con pedidos realizados en un rango de fechas específico
-- Utiliza el índice no agrupado NON_IDX_Orders_OrderDate para filtrado de rango de fechas
DECLARE @StartDate DATETIME2 = '2025-01-01';
DECLARE @EndDate DATETIME2 = '2025-12-31';
SELECT DISTINCT
    u.Name AS NombreUsuario,
    u.Email AS Correo,
    COUNT(o.ID) AS CantidadPedidos
FROM Users u
         INNER JOIN Orders o ON u.ID = o.UserID
WHERE o.OrderDate BETWEEN @StartDate AND @EndDate
  AND o.Status = 'paid'
GROUP BY u.Name, u.Email
ORDER BY u.Name;

-- Consulta 4: Productos que no han sido pedidos en un rango de fechas específico
-- Utiliza los índices no agrupados NON_IDX_OrdersBookHave_BookID y NON_IDX_Orders_OrderDate
SELECT
    b.Name AS NombreLibro,
    b.ISBN
FROM Books b
WHERE b.ID NOT IN (
    SELECT DISTINCT obh.BookID
    FROM Orders_Book_Have obh
             INNER JOIN Orders o ON obh.OrderID = o.ID
    WHERE o.OrderDate BETWEEN @StartDate AND @EndDate
      AND o.Status = 'paid'
)
ORDER BY b.Name;

-- Consulta 5: Productos vendidos en cantidades mínimas y máximas
-- Utiliza el índice columnstore NON_CLU_OrdersBookHave_Quantity para agregaciones
SELECT
    b.Name AS NombreLibro,
    b.ISBN,
    MIN(obh.Quantity) AS CantidadMínima,
    MAX(obh.Quantity) AS CantidadMáxima,
    SUM(obh.Quantity) AS CantidadTotal
FROM Orders_Book_Have obh
         INNER JOIN Books b ON obh.BookID = b.ID
         INNER JOIN Orders o ON obh.OrderID = o.ID
WHERE o.Status = 'paid'
GROUP BY b.Name, b.ISBN
ORDER BY CantidadTotal DESC;

-- Consulta 6: Los 5 usuarios con mayor valor total de pedidos (específica del proyecto)
-- Utiliza el índice columnstore NON_CLU_Orders_Total para agregaciones
SELECT TOP 5
    u.Name AS NombreUsuario,
    u.Email AS Correo,
    SUM(o.Total) AS TotalGastado
FROM Orders o
         INNER JOIN Users u ON o.UserID = u.ID
WHERE o.Status = 'paid'
GROUP BY u.Name, u.Email
ORDER BY TotalGastado DESC;

-- Consulta 7: Géneros más populares por cantidad de pedidos (específica del proyecto)
-- Utiliza índices no agrupados en Orders_Book_Have y Books para uniones eficientes
SELECT
    g.Name AS Género,
    COUNT(obh.OrderID) AS CantidadPedidos
FROM Orders_Book_Have obh
         INNER JOIN Books b ON obh.BookID = b.ID
         INNER JOIN Genres g ON b.GenreID = g.ID
         INNER JOIN Orders o ON obh.OrderID = o.ID
WHERE o.Status = 'paid'
GROUP BY g.Name
ORDER BY CantidadPedidos DESC;

-- Consulta 8: Libros con las calificaciones promedio más altas (específica del proyecto)
-- Utiliza el índice no agrupado NON_IDX_BookUserReviews_Rating para agregaciones
SELECT
    b.Name AS NombreLibro,
    b.ISBN,
    AVG(CAST(bur.Rating AS DECIMAL(3,1))) AS CalificaciónPromedio
FROM Book_User_Reviews bur
         INNER JOIN Books b ON bur.BookID = b.ID
GROUP BY b.Name, b.ISBN
HAVING COUNT(bur.Rating) > 0
ORDER BY CalificaciónPromedio DESC;

-- Consulta 9: Comunidades activas con más publicaciones (específica del proyecto)
-- Utiliza el índice no agrupado NON_IDX_Posts_DatePosted para filtrado de fechas
SELECT
    c.Title AS TítuloComunidad,
    b.Name AS NombreLibro,
    COUNT(p.ID) AS CantidadPublicaciones
FROM Communities c
         INNER JOIN Books b ON c.BookID = b.ID
         INNER JOIN Posts p ON c.BookID = p.CommunityID
WHERE p.DatePosted >= DATEADD(MONTH, -12, GETDATE())
GROUP BY c.Title, b.Name
ORDER BY CantidadPublicaciones DESC;