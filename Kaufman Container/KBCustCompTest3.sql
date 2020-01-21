--DECLARE @Year int = '2017', @Month int = '1', @SalesRep nvarchar(20) = '';--

WITH Sales_CTE
AS
-- Define the CTE query.
(
	
    SELECT 
	Customer.SalesRepCode AS Customer_SalesRepCode,
	SalesRep.Name AS SalesRep_Name,
	Customer.CustID AS Customer_CustID,
	Customer.Name AS Customer_Name,
	(DENSE_RANK() OVER(ORDER BY Calculated_Sales DESC)) AS Calculated_RankNumber,
	Customer.Industry_c AS Customer_Industry,
	Cast(SubQuery3.Calculated_DollMonth AS DECIMAL(12,2)) AS Calculated_DollMonth,
	CAST(SubQuery3.Calculated_NewCostMonth AS DECIMAL(12,2)) AS Calculated_NewCostMonth,
	CAST(SubQuery4.Calculated_FrtMth AS DECIMAL(12,2)) AS Calculated_FrtMth,
	((CASE WHEN SubQuery4.Calculated_FrtMth <> 0  THEN CAST(SubQuery3.Calculated_DollMonth - SubQuery3.Calculated_NewCostMonth - SubQuery4.Calculated_FrtMth AS DECIMAL(12,2)) ELSE CAST(SubQuery3.Calculated_DollMonth - SubQuery3.Calculated_NewCostMonth AS DECIMAL(12,2)) END))
	AS Calculated_MonthGPDoll,
	(CAST(CAST((CASE WHEN SubQuery4.Calculated_FrtMth <> 0 THEN (CASE WHEN SubQuery3.Calculated_DollMonth = 0 THEN 0 ELSE  ( SubQuery3.Calculated_DollMonth - SubQuery3.Calculated_NewCostMonth - SubQuery4.Calculated_FrtMth )  / SubQuery3.Calculated_DollMonth  * 100   END) ELSE (CASE WHEN SubQuery3.Calculated_DollMonth = 0 THEN 0 ELSE  ( SubQuery3.Calculated_DollMonth - SubQuery3.Calculated_NewCostMonth  )  / SubQuery3.Calculated_DollMonth  * 100   END) END)as DECIMAL(18,1)) AS NVARCHAR(20)) + '%')
	AS Calculated_MTDGPPer,
	CAST(SubQuery2.Calculated_NewCost AS DECIMAL(12,2)) AS Calculated_NewCost,
	SubQuery5.Calculated_TotalFreight AS Calculated_TotalFreight,
	CAST(((CASE WHEN SubQuery5.Calculated_TotalFreight <> 0  THEN SubQuery2.Calculated_Sales - SubQuery2.Calculated_NewCost - SubQuery5.Calculated_TotalFreight ELSE SubQuery2.Calculated_Sales - SubQuery2.Calculated_NewCost END)) AS DECIMAL(12,2))
	AS Calculated_TotGPDoll,
	(CAST(CAST(CASE 
 	WHEN SubQuery5.Calculated_TotalFreight <> 0 THEN(
 		CASE
 			WHEN SubQuery2.Calculated_Sales = 0 THEN 0 
 			ELSE  ( SubQuery2.Calculated_Sales - SubQuery2.Calculated_NewCost - SubQuery5.Calculated_TotalFreight )  / SubQuery2.Calculated_Sales  * 100   
 		END) 
 	ELSE(
 		CASE 
 			WHEN SubQuery2.Calculated_Sales = 0 THEN 0 
 			ELSE  ( SubQuery2.Calculated_Sales - SubQuery2.Calculated_NewCost  )  / SubQuery2.Calculated_Sales  * 100   END) 
		END AS DECIMAL(18,1)) AS NVARCHAR(20)) + '%') AS Calculated_TotGPPer,
	CAST(SubQuery6.Calculated_PrevCost AS DECIMAL(12,2)) AS Calculated_PrevCost,
	CAST(SubQuery7.Calculated_PrevFreight AS DECIMAL(12,2)) AS Calculated_PrevFreight,
	(CASE  
		WHEN Calculated_PrevCost = 0 or Calculated_PrevCost = null THEN null
		WHEN Calculated_PrevSales = 0 or Calculated_PrevSales = null THEN null 
		ELSE (CAST(CAST((Calculated_PrevCost / Calculated_PrevSales * 100.0) AS DECIMAL(18,1)) AS NVARCHAR(20)) + '%')
	 END) AS Calculated_PrevGPPer,
	CAST(Calculated_PrevSales - Calculated_PrevCost AS DECIMAL(12,2)) AS Calculated_PrevGPDoll,
	CAST(Calculated_Sales - Calculated_PrevSales AS DECIMAL(12,2)) AS Calculated_YTDDifference,
	(CASE  
		WHEN Calculated_PrevSales = 0 or Calculated_PrevSales = null THEN null
		WHEN (Calculated_Sales - Calculated_PrevSales) = 0 or (Calculated_Sales - Calculated_PrevSales) = null THEN null
		ELSE CAST(CAST(((Calculated_Sales - Calculated_PrevSales) / Calculated_PrevSales * 100) AS DECIMAL(18,1)) AS NVARCHAR(20))+ '%'
	 END) AS Calculated_YTDDifferencePer,
	CAST(SubQuery6.Calculated_PrevSales AS DECIMAL(12,2)) AS Calculated_PrevSales,
	CAST(SubQuery2.Calculated_Sales AS DECIMAL(12,2)) AS Calculated_Sales
FROM Customer AS Customer
LEFT OUTER JOIN  (

--Query2--
SELECT 
	InvcHead.CustNum AS InvcHead_CustNum,
	(SUM((InvcDtl.MtlUnitCost + InvcDtl.LbrUnitCost + InvcDtl.BurUnitCost + InvcDtl.SubUnitCost + InvcDtl.MtlBurUnitCost) * InvcDtl.OurShipQty)) AS Calculated_Cost,
	(SUM(  (CASE WHEN InvcDtl.AdjustCost_c !> 0 THEN ((InvcDtl.MtlUnitCost + InvcDtl.LbrUnitCost + InvcDtl.BurUnitCost + InvcDtl.SubUnitCost + InvcDtl.MtlBurUnitCost) * InvcDtl.OurShipQty) ELSE InvcDtl.AdjustCost_c END) )) AS Calculated_NewCost,
	(SUM( InvcDtl.OurShipQty )) AS Calculated_Units,
	(SUM(InvcDtl.ExtPrice)) AS Calculated_Sales
FROM InvcHead AS InvcHead
INNER JOIN InvcDtl AS InvcDtl ON 
	InvcHead.Company = InvcDtl.Company
AND
	InvcHead.InvoiceNum = InvcDtl.InvoiceNum
 AND ( not InvcDtl.PartNum = '1007180'  AND not InvcDtl.PartNum = '1007184'  AND not InvcDtl.LineDesc like 'Unapp'  )



INNER JOIN Part AS Part ON 
	InvcDtl.Company = Part.Company
AND
	InvcDtl.PartNum = Part.PartNum

 WHERE (InvcHead.InvoiceDate >=  CONVERT(DATE, CONVERT(VARCHAR, @Year) + '0101', 112)  AND InvcHead.InvoiceDate <=  EOMONTH(CONVERT(DATE, CONVERT(VARCHAR, @Year) + Right('00' + CONVERT(VARCHAR, @Month),2) + '01', 112))  AND InvcHead.InvoiceNum <> 325013  AND InvcHead.InvoiceNum <> 325014  AND InvcHead.InvoiceNum <> 325015  AND InvcHead.InvoiceNum <> 325016)
GROUP BY InvcHead.CustNum

--End Query2--

)  AS SubQuery2 on 
	Customer.CustNum = SubQuery2.InvcHead_CustNum
	

LEFT OUTER JOIN  (

--Query3--

SELECT 
	InvcHead1.CustNum AS InvcHead1_CustNum,
	(SUM(InvcDtl1.ExtPrice)) AS Calculated_DollMonth,
	(SUM((InvcDtl1.MtlUnitCost + InvcDtl1.LbrUnitCost + InvcDtl1.BurUnitCost + InvcDtl1.SubUnitCost + InvcDtl1.MtlBurUnitCost) * InvcDtl1.OurShipQty)) AS Calculated_CostMonth,
	(SUM(  (CASE WHEN InvcDtl1.AdjustCost_c = 0 THEN ((InvcDtl1.MtlUnitCost + InvcDtl1.LbrUnitCost + InvcDtl1.BurUnitCost + InvcDtl1.SubUnitCost + InvcDtl1.MtlBurUnitCost) * InvcDtl1.OurShipQty)  ELSE InvcDtl1.AdjustCost_c END) )) AS Calculated_NewCostMonth
FROM InvcHead AS InvcHead1
INNER JOIN InvcDtl AS InvcDtl1 ON 
	InvcHead1.Company = InvcDtl1.Company
AND
	InvcHead1.InvoiceNum = InvcDtl1.InvoiceNum
 AND ( not InvcDtl1.PartNum = '1007180'  AND not InvcDtl1.PartNum = '1007184'  AND not InvcDtl1.LineDesc like 'Unapp'  )

INNER JOIN Part AS Part1 ON 
	InvcDtl1.Company = Part1.Company
AND
	InvcDtl1.PartNum = Part1.PartNum

 WHERE (InvcHead1.InvoiceDate >=  CONVERT(DATE, CONVERT(VARCHAR, @Year) + Right('00' + CONVERT(VARCHAR, @Month),2) + '01', 112)  AND InvcHead1.InvoiceDate <=  EOMONTH(CONVERT(DATE, CONVERT(VARCHAR, @Year) + Right('00' + CONVERT(VARCHAR, @Month),2) + '01', 112))  AND InvcHead1.InvoiceNum <> 325013  AND InvcHead1.InvoiceNum <> 325014  AND InvcHead1.InvoiceNum <> 325015  AND InvcHead1.InvoiceNum <> 325016)
GROUP BY InvcHead1.CustNum

--End Query3--

)  AS SubQuery3 ON 
	Customer.CustNum = SubQuery3.InvcHead1_CustNum

LEFT OUTER JOIN  (

--Query4--

SELECT 
	UD07.Key1 AS UD07_Key1,
	(SUM( UD07.Number01 )) AS Calculated_FrtMth
FROM Ice.UD07 AS UD07
 WHERE (UD07.Key2 = CONVERT(VARCHAR, @Year)  AND UD07.Key3 = CONVERT(VARCHAR, @Month))
GROUP BY UD07.Key1

--End Query4--

)  AS SubQuery4 ON 
	Customer.CustID = SubQuery4.UD07_Key1

LEFT OUTER JOIN  (

--Query5--

SELECT 
	UD071.Key1 AS UD071_Key1,
	(SUM( UD071.Number01 )) AS Calculated_TotalFreight
FROM Ice.UD07 AS UD071
WHERE ((UD071.Key2 = CONVERT(VARCHAR, @Year) ) AND (UD071.Key3 <= CONVERT(VARCHAR, @Month) ))
GROUP BY UD071.Key1

--End Query5--

)  AS SubQuery5 ON 
	Customer.CustID = SubQuery5.UD071_Key1

LEFT OUTER JOIN  (

--Query6--

SELECT 
	InvcHead2.CustNum AS InvcHead2_CustNum,
	(SUM(  (CASE WHEN InvcDtl2.AdjustCost_c = 0 THEN ((InvcDtl2.MtlUnitCost + InvcDtl2.LbrUnitCost + InvcDtl2.BurUnitCost + InvcDtl2.SubUnitCost + InvcDtl2.MtlBurUnitCost) * InvcDtl2.OurShipQty) ELSE InvcDtl2.AdjustCost_c END) )) AS Calculated_PrevCost,
	(SUM(InvcDtl2.ExtPrice)) AS Calculated_PrevSales
FROM InvcHead AS InvcHead2
INNER JOIN InvcDtl AS InvcDtl2 ON 
	InvcHead2.Company = InvcDtl2.Company
AND
	InvcHead2.InvoiceNum = InvcDtl2.InvoiceNum
 AND ( InvcDtl2.PartNum <> '1007180'  AND InvcDtl2.PartNum <> '1007184'  AND not InvcDtl2.LineDesc like 'Unapp'  )

WHERE (InvcHead2.InvoiceDate >= CONVERT(DATE, CONVERT(VARCHAR, @Year-1)+'0101', 112)  AND InvcHead2.InvoiceDate <= EOMONTH(CONVERT(DATE, CONVERT(VARCHAR, @Year-1)+Right('00' + CONVERT(VARCHAR, @Month),2) + '01', 112)))
GROUP BY InvcHead2.CustNum

--End Query6--

)  AS SubQuery6 ON 
	Customer.CustNum = SubQuery6.InvcHead2_CustNum

LEFT OUTER JOIN  (

--Query7--

SELECT 
	UD072.Key1 AS UD072_Key1,
	(SUM( UD072.Number01 )) AS Calculated_PrevFreight
FROM Ice.UD07 AS UD072
WHERE ((UD072.Key2 = CONVERT(VARCHAR, @Year-1) ) AND (UD072.Key3 <= CONVERT(VARCHAR, @Month) ))
GROUP BY UD072.Key1

--End Query7--

)  AS SubQuery7 ON 
	Customer.CustID = SubQuery7.UD072_Key1

INNER JOIN Erp.Terms AS Terms ON 
	Customer.Company = Terms.Company
AND
	Customer.TermsCode = Terms.TermsCode

INNER JOIN Erp.SalesRep AS SalesRep ON 
	Customer.Company = SalesRep.Company
AND
	Customer.SalesRepCode = SalesRep.SalesRepCode

 WHERE (Customer.CustomerType like 'C%')
 AND SubQuery2.Calculated_Sales <> 0  AND SubQuery6.Calculated_PrevSales <> 0  AND (@SalesRep = '' OR (SalesRep.Name like ('%' + @SalesRep + '%')))
)

SELECT 
	Customer_SalesRepCode,
	SalesRep_Name,
	Customer_CustID,
	Customer_Name,
	Calculated_RankNumber,
	Customer_Industry,
	Calculated_DollMonth,
	Calculated_MonthGPDoll,
	Calculated_MTDGPPer,
	Calculated_Sales,
	Calculated_TotGPDoll,
	Calculated_TotGPPer,
	Calculated_PrevSales,
	Calculated_PrevGPDoll,
	Calculated_PrevGPPer,
	Calculated_YTDDifference,
	Calculated_YTDDifferencePer
FROM Sales_CTE
ORDER BY SalesRep_Name, Calculated_Sales DESC