IF OBJECT_ID('sp_KeywordSearch', 'P') IS NOT NULL
    DROP PROC sp_KeywordSearch
GO

CREATE PROCEDURE sp_KeywordSearch @KeyWord NVARCHAR(100)
AS
BEGIN
    DECLARE @Result TABLE
        (TableName NVARCHAR(300),
         ColumnName NVARCHAR(MAX))

    DECLARE @Sql NVARCHAR(MAX),
        @TableName NVARCHAR(300),
        @ColumnName NVARCHAR(300),
        @Count INT

    DECLARE @tableCursor CURSOR

    SET @tableCursor = CURSOR LOCAL SCROLL FOR
    SELECT  N'SELECT @Count = COUNT(1) FROM [dbo].[' + T.TABLE_NAME + '] WITH (NOLOCK) WHERE CAST([' + C.COLUMN_NAME +
            '] AS NVARCHAR(MAX)) LIKE ''%' + @KeyWord + N'%''',
            T.TABLE_NAME,
            C.COLUMN_NAME
    FROM    INFORMATION_SCHEMA.TABLES AS T WITH (NOLOCK)
    INNER JOIN INFORMATION_SCHEMA.COLUMNS AS C WITH (NOLOCK)
    ON      T.TABLE_SCHEMA = C.TABLE_SCHEMA AND
            T.TABLE_NAME = C.TABLE_NAME
    WHERE   T.TABLE_TYPE = 'BASE TABLE' AND
            C.TABLE_SCHEMA = 'dbo' AND
            C.DATA_TYPE NOT IN ('image', 'timestamp')

    OPEN @tableCursor
    FETCH NEXT FROM @tableCursor INTO @Sql, @TableName, @ColumnName

    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        SET @Count = 0

        EXEC sys.sp_executesql
            @Sql,
            N'@Count INT OUTPUT',
            @Count OUTPUT

        IF @Count > 0
        BEGIN
            INSERT  INTO @Result
                    (TableName, ColumnName)
            VALUES  (@TableName, @ColumnName)
        END

        FETCH NEXT FROM @tableCursor INTO @Sql, @TableName, @ColumnName
    END

    CLOSE @tableCursor
    DEALLOCATE @tableCursor

    SET @tableCursor = CURSOR LOCAL SCROLL FOR
    SELECT  SUBSTRING(TB.Sql, 1, LEN(TB.Sql) - 3) AS Sql, TB.TableName, SUBSTRING(TB.Columns, 1, LEN(TB.Columns) - 1) AS Columns
    FROM    (SELECT R.TableName, (SELECT R2.ColumnName + ', ' FROM @Result AS R2 WHERE R.TableName = R2.TableName FOR XML PATH('')) AS Columns,
                    'SELECT * FROM ' + R.TableName + ' WITH (NOLOCK) WHERE ' +
                    (SELECT 'CAST(' + R2.ColumnName + ' AS NVARCHAR(MAX)) LIKE ''%' + @KeyWord + '%'' OR '
                     FROM   @Result AS R2
                     WHERE  R.TableName = R2.TableName
                    FOR
                     XML PATH('')) AS Sql
             FROM   @Result AS R
             GROUP BY R.TableName) TB
    ORDER BY TB.Sql

    OPEN @tableCursor
    FETCH NEXT FROM @tableCursor INTO @Sql, @TableName, @ColumnName

    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        PRINT @Sql
        SELECT  @TableName AS [Table],
                @ColumnName AS Columns
        EXEC(@Sql)

        FETCH NEXT FROM @tableCursor INTO @Sql, @TableName, @ColumnName
    END

    CLOSE @tableCursor
    DEALLOCATE @tableCursor

END