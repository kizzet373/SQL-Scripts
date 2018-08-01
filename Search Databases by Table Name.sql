DECLARE @SQL NVARCHAR(max)
 
SET @SQL = stuff((
            SELECT '
UNION
SELECT ' + quotename(NAME, '''') + ' as Db_Name, Name collate SQL_Latin1_General_CP1_CI_AS as Table_Name
FROM ' + quotename(NAME) + '.sys.tables WHERE NAME LIKE ''%'' + @TableName + ''%'''
            FROM sys.databases
            ORDER BY NAME
            FOR XML PATH('')
                ,type
            ).value('.', 'nvarchar(max)'), 1, 8, '')
 
--PRINT @SQL;
 
EXECUTE sp_executeSQL @SQL
    ,N'@TableName varchar(30)'
    ,@TableName = '79D4D12256AE42589CFA1ADD31E3326B'