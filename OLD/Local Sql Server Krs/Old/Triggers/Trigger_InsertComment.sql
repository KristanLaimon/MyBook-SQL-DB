CREATE TRIGGER Comment_InsteadOf_Insert
    ON Comment
    INSTEAD OF INSERT
    AS
BEGIN
    DECLARE @insertedpostid INT;
    DECLARE @insertedparentcommentid INT;

    SELECT
        @insertedpostid = PostID,
        @insertedparentcommentid = ParentCommentID
    FROM inserted;

    IF (@insertedpostid IS NULL AND @insertedparentcommentid IS NULL)
        BEGIN
            THROW 50000, 'You cannot insert a new comment without PostID or ParentCommentID!', 1;
        END

    IF (@insertedpostid IS NOT NULL AND @insertedparentcommentid IS NOT NULL)
        BEGIN
            THROW 50001, 'You cannot insert a comment with both PostID and ParentCommentID at the same time!', 1;
        END

    -- Insert valid rows
    INSERT INTO Comment (UserID, Content, PostID, ParentCommentID)
    SELECT UserID, Content, PostID, ParentCommentID FROM inserted;
END;
GO


