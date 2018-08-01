use [Test4]

DECLARE 
	@Results TABLE(SchemaName nvarchar(100), TableName nvarchar(300), ColumnName nvarchar(370), ColumnValue nvarchar(3630))

SET NOCOUNT ON

DECLARE @SearchValue nvarchar(100), @SearchTable nvarchar(40), @SearchColumn nvarchar(40), @SearchSchema nvarchar(20), @TableName nvarchar(256), @ColumnName nvarchar(128), @SearchValue2 nvarchar(110)
SET @SearchValue = '%%'
SET @SearchTable = '%xxxdef%'
SET @SearchColumn = '%%'
SET @SearchSchema = '%ice%'
SET @SearchValue2 = QUOTENAME(@SearchValue,'''')
SET @TableName = ''

WHILE @TableName IS NOT NULL
BEGIN
    SET @ColumnName = ''
    SET @TableName = 
    (
        SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
        FROM    INFORMATION_SCHEMA.TABLES
        WHERE   TABLE_TYPE = 'BASE TABLE'
            AND QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
            AND OBJECTPROPERTY(
                    OBJECT_ID(
                        QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
                         ), 'IsMSShipped'
                           ) = 0
			And TABLE_SCHEMA LIKE @SearchSchema
			AND TABLE_NAME LIKE @SearchTable
    )

    WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)
    BEGIN
		Print 'Searching ' + @TableName
        SET @ColumnName =
        (
            SELECT MIN(QUOTENAME(COLUMN_NAME))
            FROM    INFORMATION_SCHEMA.COLUMNS
            WHERE       TABLE_SCHEMA    = PARSENAME(@TableName, 2)
                AND TABLE_NAME  = PARSENAME(@TableName, 1)
                AND DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar')
                AND QUOTENAME(COLUMN_NAME) > @ColumnName
				AND COLUMN_NAME LIKE @SearchColumn
        )

        IF @ColumnName IS NOT NULL
        BEGIN
			Declare @Result nvarchar(100)
            Declare @Query nvarchar(1000) =
            (
			    'SELECT SUBSTRING(''' + @TableName + ''', 1,Charindex(''.'', ''' + @TableName + ''')-1), SUBSTRING(''' + @TableName + ''', Charindex(''.'', ''' + @TableName + ''')+1,LEN(''' + @TableName + ''')),''' + @ColumnName + ''', LEFT(' + @ColumnName + ', 3630) 
                FROM ' + @TableName + ' (NOLOCK) ' +
                ' WHERE ' + @ColumnName + ' LIKE ' + @SearchValue2
            )
			INSERT INTO @Results Exec(@Query)
        END
    END 
END

SELECT SchemaName, TableName, ColumnName, ColumnValue FROM @Results order by columnName