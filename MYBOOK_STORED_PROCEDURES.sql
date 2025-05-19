drop procedure if exists Suscriptions_Insert; go
select * from Suscriptions;
create procedure Suscriptions_Insert(
    @ID char(2),
    @Name varchar(30),
    @Description varchar(250),
    @PriceUSD decimal(5,2)
)as
begin
    begin try
        insert into Suscriptions (ID, Name, Description, PriceUSD) values (@ID, @Name, @Description, @PriceUSD);
    end try
    begin catch
        print 'Ocurred an error trying to: ' + error_message()
    end catch
end