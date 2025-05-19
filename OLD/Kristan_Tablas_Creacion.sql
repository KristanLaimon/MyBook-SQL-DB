
-- drop table Person_Food_Buys;
-- drop table Person;
-- drop table Food;
-- drop table FoodType;
--
-- drop procedure GetAllFoodByType;
-- drop procedure GetFoodTypeWithMoreItems;
-- drop procedure GetUserFoodPurchases;
--
-- drop trigger Trigger_DoNotDeletePeopleWithBuyingHistory;
-- drop trigger Trigger_DoNotDeleteFoodWithPeopleBoughtItFirst;
-- drop trigger Trigger_DoNotDeleteFoodWithOtherFoodRelationed;


create table FoodType(
                         ID char(2) primary key,
                         Name varchar(20) NOT NULL,
                         Description VARCHAR(200) NOT NULL,
                         AverageCost float NOT NULL
);

INSERT INTO FoodType (ID, Name, Description, AverageCost) VALUES
                                                              ('FT', 'Fast Food', 'Quick and convenient meals', 5.99),
                                                              ('IT', 'Italian', 'Pasta, pizza, and more', 12.50),
                                                              ('MX', 'Mexican', 'Tacos, burritos, and enchiladas', 9.99),
                                                              ('JP', 'Japanese', 'Sushi, ramen, and tempura', 15.00),
                                                              ('CN', 'Chinese', 'Noodles, dumplings, and stir-fry', 8.50),
                                                              ('IN', 'Indian', 'Curries and spices', 10.00),
                                                              ('FR', 'French', 'Elegant and sophisticated dishes', 20.00),
                                                              ('TH', 'Thai', 'Spicy and flavorful food', 11.50),
                                                              ('GR', 'Greek', 'Mediterranean flavors', 10.50),
                                                              ('SP', 'Spanish', 'Tapas and paella', 13.00);

create table Food(
                     ID int primary key identity(1,1),
                     FoodType_ID char(2) NOT NULL,
                     Name varchar(50) NOT NULL,
                     Description varchar(200) NOT NULL,
                     Price float NOT NULL

                         FOREIGN KEY (FoodType_ID) REFERENCES FoodType(ID)
);

INSERT INTO Food (FoodType_ID, Name, Description, Price) VALUES
                                                             ('FT', 'McDonalds Burger', 'A classic burger from McDonalds', 3.99),
                                                             ('IT', 'Spaghetti Bolognese', 'Classic Italian pasta dish', 12.99),
                                                             ('MX', 'Carne Asada Tacos', 'Grilled steak served with fresh tortillas', 10.99),
                                                             ('JP', 'Sushi Combo', 'A selection of sushi rolls', 15.99),
                                                             ('CN', 'Kung Pao Chicken', 'Stir-fried chicken with peanuts and vegetables', 11.99),
                                                             ('IN', 'Chicken Tikka Masala', 'Indian-style chicken curry', 12.99),
                                                             ('FR', 'Escargots', 'Snails cooked in garlic butter', 17.99),
                                                             ('TH', 'Tom Yum Soup', 'Spicy and sour soup with shrimp', 10.99),
                                                             ('GR', 'Greek Salad', 'Tomatoes, cucumbers, feta cheese, and olives', 9.99),
                                                             ('SP', 'Paella Valenciana', 'Saffron-infused rice with chicken, seafood, and vegetables', 22.99),
                                                             ('SP', N'Valencianista Nicoline', 'More food omg', 22.99);

create table Person(
                       ID int primary key identity(1,1),
                       Name VARCHAR(20) not null,
                       Age smallint not null
);

INSERT INTO Person (Name, Age) VALUES
                                   ('Ana', 25),
                                   ('Pedro', 18),
                                   ('Sofia', 30),
                                   ('Juan', 22),
                                   ('Lucia', 28),
                                   ('Miguel', 35),
                                   ('Elena', 20),
                                   ('Rafael', 32),
                                   ('Isabel', 29),
                                   ('Gabriel', 26);

create table Person_Food_Buys(
                                 Person_ID int NOT NULL,
                                 Food_ID int NOT NULL,
                                 FOREIGN KEY (Person_ID) REFERENCES Person(ID),
                                 FOREIGN KEY (Food_ID) REFERENCES Food(ID)
);

INSERT INTO Person_Food_Buys (Person_ID, Food_ID) VALUES
                                                      (1, 2),
                                                      (2, 1),
                                                      (3, 3),
                                                      (4, 4),
                                                      (5, 5),
                                                      (6, 6),
                                                      (7, 7),
                                                      (8, 8),
                                                      (9, 9),
                                                      (9, 8),
                                                      (9, 2),
                                                      (9, 1),
                                                      (10, 10)
    GO

-- Procedures
CREATE PROCEDURE GetAllFoodByType
    @TypeToSearch VARCHAR(50)
AS
BEGIN
--     SELECT c.Name AS Comida, t.nombre AS Tipo
--     FROM Food c
--              JOIN FoodType t ON c.id_tipo = t.id_tipo
--     WHERE t.nombre = @Tipo;
SELECT f.Name as 'Food', FT.Name as 'FoodType'
from Food f
         join FoodType FT on f.FoodType_ID = FT.ID
where FT.ID = @TypeToSearch
END;
GO

CREATE PROCEDURE GetFoodTypeWithMoreItems
    as
begin
select top 3 ft2.Name, ft2.ID, count(ft2.Name) as 'FoodStored'
from Food f
         join FoodType ft2 on f.FoodType_ID = ft2.ID
group by ft2.Name, ft2.ID
order by count(ft2.Name) desc
end

CREATE PROCEDURE GetUserFoodPurchases
    @UserID INT
AS
BEGIN
SELECT p.Name AS PersonName, f.Name AS FoodName
FROM Person_Food_Buys pf
         JOIN Person p ON pf.Person_ID = p.ID
         JOIN Food f ON pf.Food_ID = f.ID
WHERE p.ID = @UserID;
END;
GO

-- 1. Trigger: No se puede eliminar un tipo de comida si tiene al menos una comida relacionada
CREATE TRIGGER Trigger_DoNotDeleteFoodWithOtherFoodRelationed
    ON FoodType
    INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1
               FROM Food f
               WHERE f.FoodType_ID IN (SELECT ID
                                       FROM deleted))
BEGIN
            RAISERROR ('No se puede eliminar el tipo de comida porque tiene al menos una comida relacionada', -- Message text.
                       16, -- Severity.
                       1 -- State.
                       );
ROLLBACK TRANSACTION;
END
ELSE
BEGIN
DELETE FROM FoodType
WHERE ID IN (SELECT ID
             FROM deleted);
END
END;
GO

-- 2. Trigger: No se puede eliminar una persona si tiene al menos una compra relacionada
-- CREATE TRIGGER trg_no_borrar_persona_con_compra
CREATE TRIGGER Trigger_DoNotDeletePeopleWithBuyingHistory
    ON Person
    INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1
               FROM Person_Food_Buys pf
               WHERE pf.Person_ID IN (SELECT ID
                                       FROM deleted))
BEGIN
            RAISERROR ('No se puede eliminar la persona porque tiene al menos una compra relacionada', -- Message text.
                       16, -- Severity.
                       1 -- State.
                       );
ROLLBACK TRANSACTION;
END
ELSE
BEGIN
DELETE FROM Person
WHERE ID IN (SELECT ID
             FROM deleted);
END
END;
GO

-- Trigger: No se puede eliminar una comida si tiene al menos una compra relacionada
-- CREATE TRIGGER trg_no_borrar_comida_con_compra
CREATE TRIGGER Trigger_DoNotDeleteFoodWithPeopleBoughtItFirst
    ON Food
    INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1
               FROM Person_Food_Buys pf
               WHERE pf.Food_ID IN (SELECT ID
                                    FROM deleted))
BEGIN
            RAISERROR ('No se puede eliminar la comida porque tiene al menos una compra relacionada', -- Message text.
                       16, -- Severity.
                       1 -- State.
                       );
ROLLBACK TRANSACTION;
END
ELSE
BEGIN
DELETE FROM Food
WHERE ID IN (SELECT ID
             FROM deleted);
END
END;
GO

select name
from sys.triggers;

-- select count(*)
-- from sys.procedures p
-- where p.name = 'GetUserFoodPurchases';

-- exec GetUserFoodPurchases 9


--     CREATE TRIGGER prevenir_duplicados
--         ON Comida
--         INSTEAD OF INSERT
--         AS
--     BEGIN
--         IF EXISTS (SELECT 1 FROM Comida WHERE nombre IN (SELECT nombre FROM inserted))
--             BEGIN
--                 RAISERROR ('Error: La comida ya existe.', 16, 1);
--                 ROLLBACK TRANSACTION;
--             END
--         ELSE
--             BEGIN
--                 INSERT INTO Comida (nombre, id_tipo)
--                 SELECT nombre, id_tipo FROM inserted;
--             END
--     END;




-- create table TipoComida


-- Un procedimiento
-- Un trigger
-- Una vista