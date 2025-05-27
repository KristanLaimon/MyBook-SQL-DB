USE MYBOOK;
GO

-- Drop all UNIQUE constraints (they create indexes internally)
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += '
ALTER TABLE ' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) + 
' DROP CONSTRAINT ' + QUOTENAME(i.name) + ';'
FROM sys.key_constraints i
JOIN sys.tables t ON t.object_id = i.parent_object_id
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE i.type = 'UQ';  -- Unique constraints

EXEC sp_executesql @sql;

-- Drop all non-primary indexes
SET @sql = N'';
SELECT @sql += '
DROP INDEX ' + QUOTENAME(i.name) + 
' ON ' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) + ';'
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE i.type_desc IN ('NONCLUSTERED', 'CLUSTERED', 'COLUMNSTORE')
  AND i.is_primary_key = 0
  AND i.is_unique_constraint = 0
  AND i.name IS NOT NULL;

EXEC sp_executesql @sql;

















USE MYBOOK;
GO

-- === Restore indexes ===
CREATE NONCLUSTERED INDEX NON_IDX_Roles_Name ON Roles(Name);
CREATE NONCLUSTERED INDEX NON_IDX_Suscriptions_Name ON Suscriptions(Name);
--CREATE NONCLUSTERED COLUMNSTORE INDEX NON_CLU_Suscriptions_PriceUSD ON Suscriptions(PriceUSD);
CREATE NONCLUSTERED INDEX NON_IDX_Users_Name ON Users(Name);
CREATE NONCLUSTERED INDEX NON_IDX_Genres_Name ON Genres(Name);
CREATE NONCLUSTERED INDEX NON_IDX_Languages_Name ON Languages(Name);
CREATE NONCLUSTERED INDEX NON_IDX_Books_Name ON Books(Name);
CREATE NONCLUSTERED INDEX NON_IDX_Books_PublishedUploadDate ON Books(PublishedUploadDate);
CREATE NONCLUSTERED INDEX NON_IDX_Books_PublishedBookDate ON Books(PublishedBookDate);
CREATE NONCLUSTERED INDEX NON_IDX_Communities_UserAuthorID ON Communities(UserAuthorID);
CREATE NONCLUSTERED INDEX NON_IDX_Communities_Title ON Communities(Title);
CREATE NONCLUSTERED INDEX NON_IDX_Posts_DatePosted ON Posts(DatePosted);
CREATE NONCLUSTERED INDEX NON_IDX_Comment_UserID ON Comment(UserID);
CREATE NONCLUSTERED INDEX NON_IDX_BookUserShelve_BookID ON Book_User_Shelve(BookID);
CREATE NONCLUSTERED INDEX NON_IDX_BookUserShelve_UserID ON Book_User_Shelve(UserID);
CREATE NONCLUSTERED INDEX NON_IDX_BookUserReads_ReadDate ON Book_User_Reads(ReadDate);
CREATE NONCLUSTERED INDEX NON_IDX_BookUserReviews_Rating ON Book_User_Reviews(Rating);
