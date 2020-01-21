--KAGDC1SQL02 .... 


SELECT * FROM DBA_EventManagement.dbo.DatabaseInfo WHERE DatabaseName LIKE '%decision%'




SELECT DISTINCT ServerName, DatabaseName 
FROM DBA_EventManagement.dbo.DatabaseInfo 
WHERE DatabaseStatus = 'ONLINE'
ORDER BY ServerName, DatabaseName 