Select * FROM KAG_LockTokenLog WHERE KeyValue = '36375470' ORDER BY DateReleased DESC

DELETE KAG_LockTokenLog WHERE DateReleased = '2049-12-31 11:59:00.000' AND KeyValue=''