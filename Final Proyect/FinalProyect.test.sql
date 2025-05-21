

use MYBOOK;


-- Good query
select * from Orders_Book_Have obh
      join Sales s on obh.OrderID = s.OrderInfoID
where s.OrderInfoID = 15;

select * from Sales;



select distinct ID from Books order by ID;
select distinct ID from Users;

