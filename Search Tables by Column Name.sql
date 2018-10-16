Use [Production]

Declare @ColumnName nvarchar(30) = '%%', @TableName nvarchar(30) = '%%', @SchemaName nvarchar(30) = '%erp%'

SELECT      
			s.name AS 'Schema Name'		
            ,t.name AS 'Table Name'
			,c.name  AS 'Column Name'
FROM        sys.columns c
JOIN        sys.tables  t   ON c.object_id = t.object_id
JOIN		sys.schemas s	ON s.schema_id = t.schema_id
WHERE       c.name LIKE @ColumnName and t.name LIKE @TableName and s.name LIKE @SchemaName
ORDER BY    s.name
            ,t.name
			,c.name