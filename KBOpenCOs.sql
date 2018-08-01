select 
	[Customer].[SalesRepCode] as [Customer_SalesRepCode],
	[Customer].[CustID] as [Customer_CustID],
	[Customer].[Name] as [Customer_Name],
	[OrderHed].[OrderNum] as [OrderHed_OrderNum],
	[OrderHed].[PONum] as [OrderHed_PONum],
	[OrderHed].[OrderDate] as [OrderHed_OrderDate],
	[OrderRel].[OrderLine] as [OrderRel_OrderLine],
	[OrderRel].[OrderRelNum] as [OrderRel_OrderRelNum],
	[OrderDtl_UD].[OnHold_c] as [OrderDtl_OnHold_c],
	[OrderDtl].[PartNum] as [OrderDtl_PartNum],
	[OrderDtl].[XPartNum] as [OrderDtl_XPartNum],
	[OrderDtl].[LineDesc] as [OrderDtl_LineDesc],
	[OrderRel].[OurReqQty] as [OrderRel_OurReqQty],
	(OrderRel.OurStockShippedQty + OrderRel.OurJobShippedQty) as [Calculated_Shipped],
	(OrderRel.OurReqQty - OrderRel.OurStockShippedQty - OrderRel.OurJobShippedQty) as [Calculated_Balance],
	[OrderDtl].[DocUnitPrice] as [OrderDtl_DocUnitPrice],
	(OrderDtl.DocUnitPrice * (OrderRel.OurReqQty - OrderRel.OurStockShippedQty - OrderRel.OurJobShippedQty)) as [Calculated_ExtPrice],
	[OrderRel].[NeedByDate] as [OrderRel_NeedByDate],
	[OrderRel].[ReqDate] as [OrderRel_ReqDate],
	[Customer_UD].[SCRep_c] as [Customer_SCRep_c]
from Erp.OrderHed as OrderHed
inner join Erp.Customer as Customer on 
	OrderHed.Company = Customer.Company
And
	OrderHed.BTCustNum = Customer.CustNum

right outer join Erp.OrderDtl as OrderDtl on 
	OrderHed.Company = OrderDtl.Company
And
	OrderHed.OrderNum = OrderDtl.OrderNum
 and ( OrderDtl.OpenLine = 'true'  )

right outer join Erp.OrderRel as OrderRel on 
	OrderDtl.Company = OrderRel.Company
And
	OrderDtl.OrderNum = OrderRel.OrderNum
And
	OrderDtl.OrderLine = OrderRel.OrderLine
 and ( OrderRel.OpenRelease = 'true'  and OrderRel.OurReqQty > OrderRel.OurStockShippedQty + OrderRel.OurJobShippedQty  )

inner join Erp.Customer_UD as Customer_UD on
	Customer.SysRowID = Customer_UD.ForeignSysRowID

inner join Erp.OrderDtl_UD as OrderDtl_UD on
	OrderDtl.SysRowID = OrderDtl_UD.ForeignSysRowID

 where (OrderHed.OpenOrder = 'true')