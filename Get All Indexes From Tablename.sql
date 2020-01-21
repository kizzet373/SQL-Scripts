select * from sys.indexes
where object_id = (select object_id from sys.objects where name = 'TABLENAME')