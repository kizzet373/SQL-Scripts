SELECT name
FROM   sys.procedures
WHERE  Object_definition(object_id) LIKE '%%'