--Run on KAGDC1SQL02


SELECT * FROM DBA_EventManagement.dbo.DatabaseInfo WHERE DatabaseName LIKE '%Logging%'




SELECT DISTINCT ServerName, DatabaseName 
FROM DBA_EventManagement.dbo.DatabaseInfo 
WHERE DatabaseStatus = 'ONLINE'
ORDER BY ServerName, DatabaseName 