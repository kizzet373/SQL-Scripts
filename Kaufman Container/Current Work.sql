/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	Ordh.CustNum
	,Cust.Name
	,Count(OrdH.OrderNum) AS OrderCount
	,AVG(a.lines) AS AvgLines
	,AVG(a.AvgLineQty) AS AvgOrderQty
	,(Count(OrdH.OrderNum) * AVG(a.lines) * AVG(a.AvgLineQty)) as HiddenValue

FROM [Production].[Erp].[OrderHed] OrdH

join Production.Erp.Customer Cust
on Cust.CustNum = OrdH.CustNum

inner join (SELECT OrderNum, Count(OrderLine) lines, Avg(OrderQty) AvgLineQty from Production.Erp.OrderDtl group by OrderNum) a
on a.OrderNum = OrdH.OrderNum

where OrdH.OrderDate >= '1/1/2017'

Group by OrdH.CustNum, Cust.Name
