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

drop view if exists Sales;
create view Sales as
select ID as OrderInfoID, UserID, OrderDate, Total
from Orders o
where status = 'paid';

