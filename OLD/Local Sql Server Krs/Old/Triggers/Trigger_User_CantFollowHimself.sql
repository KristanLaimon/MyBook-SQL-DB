create trigger User_CantSubscribeHimself
    on User_User_Suscribe
    instead of insert
    as
        begin
            declare @Subscriber int;
            declare @Subscribed int;
            select
                @Subscriber = SuscriberID,
                @Subscribed = SuscribedToID
            from inserted

            if (@Subscriber = @Subscribed)
            begin
                throw 50001, 'User_CantSubscribeHimself', 1
            end

            insert into User_User_Suscribe (SuscriberID, SuscribedToID, SuscriptionDate)
            select SuscriberID, SuscribedToID, SuscriptionDate from inserted
        end
go
