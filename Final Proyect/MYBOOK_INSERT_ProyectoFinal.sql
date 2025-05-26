

USE MYBOOK;
INSERT INTO Orders (UserID, OrderDate, Status, Total) VALUES
                  (1, '2025-01-15 10:30:00', 'paid', 45.98),
                  (2, '2025-01-20 14:20:00', 'pending', 29.99),
                  (3, '2025-02-01 09:15:00', 'cancelled', 19.50),
                  (4, '2025-02-10 16:45:00', 'paid', 60.75),
                  (5, '2025-02-15 11:00:00', 'pending', 34.25),
                  (6, '2025-03-01 13:30:00', 'paid', 78.90),
                  (7, '2025-03-05 08:50:00', 'cancelled', 25.00),
                  (8, '2025-03-10 17:10:00', 'paid', 53.45),
                  (8, '2025-03-15 12:25:00', 'pending', 41.30),
                  (8, '2025-03-20 15:40:00', 'paid', 67.80),
                  (1, '2025-04-01 09:00:00', 'paid', 38.20),
                  (2, '2025-04-05 14:55:00', 'pending', 22.10),
                  (3, '2025-04-10 10:20:00', 'cancelled', 15.75),
                  (4, '2025-04-15 16:30:00', 'paid', 49.99),
                  (5, '2025-04-20 11:45:00', 'pending', 33.60),
                  (6, '2025-05-01 13:15:00', 'paid', 72.40),
                  (7, '2025-05-05 09:25:00', 'cancelled', 27.80),
                  (8, '2025-05-10 17:50:00', 'paid', 55.20),
                  (8, '2025-05-15 12:10:00', 'pending', 39.95),
                  (7, '2025-05-20 15:00:00', 'paid', 64.70),
                  (1, '2025-06-01 08:40:00', 'paid', 47.30),
                  (2, '2025-06-05 14:15:00', 'pending', 31.25),
                  (3, '2025-06-10 10:50:00', 'cancelled', 18.90),
                  (4, '2025-06-15 16:00:00', 'paid', 58.60),
                  (5, '2025-06-20 11:30:00', 'pending', 36.45),
                  (6, '2025-07-01 13:00:00', 'paid', 69.85),
                  (7, '2025-07-05 09:10:00', 'cancelled', 24.60),
                  (7, '2025-07-10 17:20:00', 'paid', 51.35),
                  (7, '2025-07-15 12:40:00', 'pending', 42.70),
                  (8, '2025-07-20 15:55:00', 'paid', 66.20),
                  (1, '2025-08-01 08:30:00', 'paid', 44.10),
                  (2, '2025-08-05 14:25:00', 'pending', 28.50),
                  (3, '2025-08-10 10:15:00', 'cancelled', 20.25),
                  (4, '2025-08-15 16:35:00', 'paid', 61.80),
                  (5, '2025-08-20 11:50:00', 'pending', 35.90),
                  (6, '2025-09-01 13:20:00', 'paid', 73.15),
                  (7, '2025-09-05 09:30:00', 'cancelled', 26.40),
                  (8, '2025-09-10 17:40:00', 'paid', 54.65),
                  (8, '2025-09-15 12:00:00', 'pending', 40.30),
                  (1, '2025-09-20 15:10:00', 'paid', 68.50);


-- Insert valid Orders_Book_Have entries with available BookID 1-8, 12-14
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (1, 1, 2);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (1, 2, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (2, 3, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (3, 4, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (4, 5, 2);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (4, 6, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (5, 7, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (5, 8, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (7, 1, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (8, 2, 2);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (8, 3, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (9, 4, 2);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (10, 5, 2);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (10, 6, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (13, 7, 1); -- Originally BookID 10
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (14, 1, 2);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (14, 2, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (15, 3, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (15, 4, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (16, 5, 3);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (16, 6, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (17, 7, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (18, 8, 2);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (18, 6, 1); -- Originally BookID 9
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (19, 3, 2); -- Originally BookID 10
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (20, 1, 2);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (20, 2, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (21, 3, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (21, 4, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (22, 5, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (23, 6, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (24, 7, 2);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (24, 8, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (25, 7, 1); -- Originally BookID 9
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (25, 6, 1); -- Originally BookID 10
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (26, 3, 3);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (26, 5, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (27, 8, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (28, 2, 2);
-- INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (28, 2, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (30, 3, 2);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (30, 5, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (31, 7, 1); -- Originally BookID 9
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (31, 5, 1); -- Originally BookID 10
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (32, 1, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (33, 2, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (34, 3, 2);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (34, 4, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (35, 5, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (35, 6, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (36, 7, 3);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (36, 8, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (37, 8, 1); -- Originally BookID 9
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (38, 7, 2); -- Originally BookID 10
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (38, 1, 1);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (39, 2, 2);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (40, 3, 2);
INSERT INTO Orders_Book_Have (OrderID, BookID, Quantity) VALUES (40, 4, 1);


-- ORDERS
DECLARE @i INT = 1;
DECLARE @uid INT;
DECLARE @status VARCHAR(20);
DECLARE @date DATETIME2;
DECLARE @rand DECIMAL(10,2);

WHILE @i <= 10000
BEGIN
    SET @uid = ((@i - 1) % 10000) + 1;
    SET @status = CHOOSE((@i % 3) + 1, 'pending', 'paid', 'cancelled');
    SET @date = DATEADD(DAY, @i % 365, '2024-01-01');
    SET @rand = ROUND((RAND(CHECKSUM(NEWID())) * 100) + 10, 2);  -- Generate a pseudo-random total between 10 and 110

    EXEC Orders_Insert 
        @UserID = @uid, 
        @OrderDate = @date, 
        @Status = @status, 
        @Total = @rand;

    SET @i += 1;
END;
go

-- ORDERS_BOOK_HAVE
DECLARE @j INT = 1;
DECLARE @order INT;
DECLARE @book INT;
DECLARE @qty INT;

WHILE @j <= 10000
BEGIN
    SET @order = ((@j - 1) % 10000) + 1;
    SET @book = ((@j - 1) % 1000) + 1; -- Assuming you have at least 1000 books
    SET @qty = (ABS(CHECKSUM(NEWID())) % 5) + 1; -- 1 to 5 copies

    EXEC Orders_Book_Have_Insert @OrderID = @order, @BookID = @book, @Quantity = @qty;

    SET @j += 1;
END;
go

