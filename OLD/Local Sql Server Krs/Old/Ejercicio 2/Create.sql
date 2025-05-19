
-- =========================================================
create table NewProducts(
                            ProductID int not null,
                            name nvarchar(20) default 'Generic Product',
                            Discontinued bit not null default 0,
                            CategoryID int not null,
);
insert into NewProducts(name, CategoryID, ProductID)
values
    ('Product 1', 1, 1), ('Product 2', 2,2), ('Product 3', 3, 3),
    ('Product 4', 4,4), ('Product 5', 5, 5), ('Product 6', 6, 6),
    ('Product 7', 7, 7), ('Product 8', 8, 8), ('Product 9', 9, 9),
    ('Product 10', 10, 10), ('Product 11', 11, 11), ('Product 12', 12, 12)

-- =========================================================
create table NewCategories(
                              CategoryID int not  null,
                              name nvarchar(20) default 'Generic Category'
);
insert into NewCategories (name, CategoryID)
values
    ('Category 1', 1), ('Categorie 2', 2), ('Categorie 3', 3),
    ('Category 4', 4), ('Categorie 5', 5), ('Categorie 6', 6),
    ('Categorie 7', 7), ('Categorie 8', 8), ('Categorie 9', 9),
    ('Categorie 10', 10), ('Categorie 11', 11), ('Categorie 12', 12)
GO

-- =========================================================

create trigger Category_Delete
    on NewCategories
    for delete
    as
    update NewProducts
    set Discontinued = 1
    where NewProducts.CategoryID = (select CategoryID from NewCategories)
GO

SELECT ProductID, CategoryID, Discontinued
FROM NewProducts
WHERE CategoryID = 7



SELECT ProductID, CategoryID, Discontinued
FROM NewProducts
WHERE CategoryID = 7


delete from NewCategories
where CategoryID = 7;


select * from NewCategories;

