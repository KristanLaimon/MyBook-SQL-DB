

use MYBOOK;

create table Orders(
    ID int identity (1,1) not null ,
    UserID int not null,
    OrderDate datetime2 default getdate(), --Optional
    Status varchar(20) not null default 'pending',
    Total decimal (10,2) not null

    constraint PK_Orders primary key (ID),-- CREATE CLUSTERED INDEX IDX_Orders_OrderDate ON Orders(OrderDate);
    constraint FK_Orders_Users foreign key (UserID) references Users(ID),
    constraint Check_Orders_Status_MustBeInEnum check(Status in ('pending', 'paid', 'cancelled'))
); go
create nonclustered index NON_IDX_Orders_OrderDate on Orders(OrderDate);
create nonclustered columnstore index NON_CLU_Orders_Total on Orders(Total);

drop procedure if exists Orders_Insert; go
create procedure Orders_Insert(
    @UserID int,
    @OrderDate datetime2,
    @Status varchar(20),
    @Total decimal (10,2)
) as
begin
    begin try
        insert into Orders (UserID, OrderDate, Status, Total) values (@UserID, @OrderDate, @Status, @Total);
    end try
    begin catch
        declare @ErrorMsg nvarchar(4000);
        select @ErrorMsg = error_message();
        print 'Orders_Insert | ERROR | MSG: ' + @ErrorMsg + ' | Values: '
            + cast(@UserID as varchar(10)) + ', '
            + cast(@OrderDate as varchar(10)) + ', '
            + @Status + ', '
            + cast(@Total as varchar(10));
    end catch
end go;

create table Orders_Book_Have(
    OrderID int not null,
    BookID int not null,
    Quantity int not null,

    constraint PK_OrdersBookHave primary key (OrderID, BookID), -- create clustered index IDX_OrdersBookHave on Orders_Books_Have(OrderID,BookID)
    constraint Check_OrdersBookHave_Quantity_MustBeGreaterThanZero check (Quantity > 0),
    constraint FK_OrdersBookHave_Orders foreign key (OrderID) references Orders(ID),
    constraint FK_OrdersBookHave_Books foreign key (BookID) references Books(ID)
); go
create nonclustered index NON_IDX_OrdersBookHave_OrderID on Orders_Book_Have(OrderID);
create nonclustered index NON_IDX_OrdersBookHave_BookID on Orders_Book_Have(BookID);
create nonclustered columnstore index NON_CLU_OrdersBookHave_Quantity on Orders_Book_Have(Quantity);

drop procedure if exists Orders_Book_Have_Insert; go
create procedure Orders_Book_Have_Insert(
    @OrderID int,
    @BookID int,
    @Quantity int
) as
begin
    begin try
        insert into Orders_Book_Have (OrderID, BookID, Quantity) values (@OrderID, @BookID, @Quantity);
    end try
    begin catch
        declare @ErrorMsg nvarchar(4000);
        select @ErrorMsg = error_message();
        print 'Orders_Book_Have_Insert | ERROR | MSG: ' + @ErrorMsg + ' | Values: '
            + cast(@OrderID as varchar(10)) + ', '
            + cast(@BookID as varchar(10)) + ', '
            + cast(@Quantity as varchar(10));
    end catch
end go;

drop view if exists Sales; go
create view Sales as
select ID as OrderInfoID, UserID, OrderDate, Total
from Orders o
where status = 'paid';
