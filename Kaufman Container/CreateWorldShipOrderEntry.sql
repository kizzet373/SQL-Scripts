USE Test2

Declare @modifyView bit = 0

IF OBJECT_ID ('dbo.V_WorldShipOrderEntry', 'V') IS NOT NULL AND @modifyView = 1
	BEGIN
		DROP VIEW dbo.V_WorldShipOrderEntry;
	END
	
GO

CREATE VIEW V_WorldShipOrderEntry
AS (SELECT
	oh.OrderNum AS [OrderNum]
	,ISNULL(cust.CustID,'') AS [CustomerID]
	,ISNULL(cust.Name,'') AS [Company]
	,ISNULL(cc.Name,'') AS [Attention]
	,ISNULL(cust.Address1,'') AS [Address1]
	,ISNULL(cust.Address2,'') AS [Address2]
	,ISNULL(cust.Address3,'') AS [Address3]
	,ISNULL(cust.Country,'') AS [Country]
	,ISNULL(cust.Zip,'') AS [PostalCode]
	,ISNULL(cust.City,'') AS [City]
	,ISNULL(cust.State,'') AS [State]
	,ISNULL(cust.PhoneNum,'') AS [Telephone]
	,ISNULL(cust.EMailAddress,'') AS [EmailAddress]
	,ISNULL(oh.ShipComment,'') AS [ShipComment]
	,ISNULL(comp.Name,'') AS [WHCompany]
	,'SHIPPING' AS [WHAttention]
	,ISNULL(wh.Address1,'') AS [WHAddress1]
	,ISNULL(wh.Address2,'') AS [WHAddress2]
	,ISNULL(wh.Address3,'') AS [WHAddress3]
	,ISNULL(wh.Country,'') AS [WHCountry]
	,ISNULL(wh.Zip,'') AS [WHPostalCode]
	,ISNULL(wh.City,'') AS [WHCity]
	,ISNULL(wh.State,'') AS [WHState]
	,ISNULL(wh.PhoneNum,'') AS [WHTelephone]

FROM 
	dbo.OrderRel AS orel

	LEFT JOIN dbo.OrderDtl AS od
	ON od.OrderNum = orel.OrderNum

	LEFT JOIN dbo.OrderHed AS oh
	ON oh.OrderNum = od.OrderNum

	LEFT JOIN erp.Warehse wh
	ON orel.WarehouseCode = wh.WarehouseCode

	LEFT JOIN dbo.Customer AS cust
	ON cust.CustNum = oh.CustNum

	LEFT JOIN erp.Company AS comp
	ON comp.Company = orel.Company

	LEFT JOIN erp.CustCnt AS cc
	ON oh.CustNum = cc.CustNum
	AND oh.PrcConNum = cc.ConNum
	)

GO