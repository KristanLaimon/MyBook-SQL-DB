-- create table UserHistoricRegistry(
--     DateJoined datetime2,
--     UserID int NOT NULL
-- );

create trigger User_AfterInsert_InsertIntoUserRegistry
    ON Users
    after insert
    as
        begin
            insert into UserHistoricRegistry (DateJoined, UserID)
            select sysdatetime(), ID from inserted
        end