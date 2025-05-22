use MYBOOK;

DROP TRIGGER IF EXISTS trg_UpdateStock_OnPaid
go
CREATE TRIGGER trg_UpdateStock_OnPaid
ON Orders
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OrderID INT;
    DECLARE @NewStatus VARCHAR(20);

    SELECT 
        @OrderID = ID,
        @NewStatus = Status
    FROM Inserted;

    IF @NewStatus = 'paid'
    BEGIN
        UPDATE B
        SET B.Stock = B.Stock - OBH.Quantity
		select * 
        FROM Books B
        INNER JOIN Orders_Book_Have OBH ON OBH.BookID = B.ID
        WHERE OBH.OrderID = @OrderID;
    END
END
GO

