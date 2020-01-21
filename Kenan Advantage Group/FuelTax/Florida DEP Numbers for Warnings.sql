DECLARE @lastMonth datetime = DATEADD(mm, DATEDIFF(mm,0,GETDATE())-1, 0)

SELECT DISTINCT 
	ConsigneeAcct AS 'Consignee Code'
,	ConsigneeName AS 'Consignee Name'
,	ConsigneeAddress AS 'Consignee Address'
,	ConsigneeCity + ', ' + ConsigneeState AS 'City, State'
,	ConsigneeZip AS 'Consignee Zip'
FROM ShipmentData
WHERE period = @lastMonth
AND ConsigneeState = 'FL'
AND dbo.KAG_fnFloridaDOR(ConsigneeAcct) LIKE '%UNKNOWN'
ORDER BY ConsigneeAcct