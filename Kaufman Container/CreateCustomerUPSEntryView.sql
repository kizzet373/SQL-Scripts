USE Production

Declare @modifyView bit = 1

IF OBJECT_ID ('dbo.V_CustomerShipmentInfo', 'V') IS NOT NULL AND @modifyView = 1
	BEGIN
		DROP VIEW dbo.V_CustomerShipmentInfo;
	END
	
GO

CREATE VIEW V_CustomerShipmentInfo
AS (SELECT
	oh.OrderNum AS [OrderNum]
	,ISNULL(cust.CustID,'') AS [CustomerID]
	,ISNULL(st.Name,'') AS [Company]
	,MAX(ISNULL(cc.Name,'')) AS [Attention]
	,ISNULL(st.Address1,'') AS [Address1]
	,ISNULL(st.Address2,'') AS [Address2]
	,ISNULL(st.Address3,'') AS [Address3]
	,ISNULL(st.Country,'') AS [Country]
	,ISNULL(st.Zip,'') AS [PostalCode]
	,ISNULL(st.City,'') AS [City]
	,ISNULL(st.State,'') AS [State]
	,ISNULL(st.PhoneNum,'') AS [Telephone]
	,ISNULL(st.EMailAddress,'') AS [EmailAddress]
	,ISNULL(oh.ShipComment,'') AS [ShipComment]
	,ISNULL(oh.PONum,'') AS [PurchaseOrderNum]

FROM 
	dbo.OrderHed AS oh
	
	LEFT JOIN dbo.Customer AS cust
	ON cust.CustNum = oh.CustNum

	LEFT JOIN erp.CustCnt AS cc
	ON oh.CustNum = cc.CustNum
	AND oh.PrcConNum = cc.ConNum

	LEFT JOIN erp.ShipTo AS st
	ON cust.CustNum = st.CustNum
	AND OH.ShipToNum = st.ShipToNum

	GROUP BY oh.OrderNum, cust.CustID, st.Name, st.Address1, st.Address2, st.Address3, st.Country, st.Zip, st.City, st.State, st.PhoneNum, st.EMailAddress, oh.ShipComment, oh.PONum
	)

GO