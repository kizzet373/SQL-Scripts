USE Production

Declare @modifyView bit = 0

IF OBJECT_ID ('dbo.V_WarehouseShipmentInfo', 'V') IS NOT NULL AND @modifyView = 1
	BEGIN
		DROP VIEW dbo.V_WarehouseShipmentInfo;
	END
	
GO

CREATE VIEW V_WarehouseShipmentInfo
AS (SELECT
	oh.OrderNum AS [OrderNum]
	,ISNULL(cust.CustID,'') AS [CustomerID]
	,ISNULL(comp.Name,'') AS [Company]
	,'SHIPPING' AS [Attention]
	,ISNULL(wh.Address1,'') AS [Address1]
	,ISNULL(wh.Address2,'') AS [Address2]
	,ISNULL(wh.Address3,'') AS [Address3]
	,ISNULL(wh.Country,'') AS [Country]
	,ISNULL(wh.Zip,'') AS [PostalCode]
	,ISNULL(wh.City,'') AS [City]
	,ISNULL(wh.State,'') AS [State]
	,ISNULL(wh.PhoneNum,'') AS [Telephone]

FROM 
	dbo.OrderHed AS oh

	LEFT JOIN (SELECT DISTINCT WarehouseCode, OrderNum FROM erp.OrderRel) AS orel
	ON orel.OrderNum = oh.OrderNum

	LEFT JOIN erp.Warehse wh
	ON orel.WarehouseCode = wh.WarehouseCode

	LEFT JOIN dbo.Customer AS cust
	ON cust.CustNum = oh.CustNum

	LEFT JOIN erp.Company AS comp
	ON comp.Company = oh.Company

	LEFT JOIN erp.CustCnt AS cc
	ON oh.CustNum = cc.CustNum
	AND oh.PrcConNum = cc.ConNum
	)

GO