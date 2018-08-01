select
orel.Company 
,orel.ordernum
,orel.OrderLine
,orel.OrderRelNum
,orel.OurReqQty
,orel.shiptonum
,orel.ShipViaCode
,sv.Description ShipVia
,orel.FirmRelease
,orel.WarehouseCode
,orel.OurJobQty
,orel.OurJobShippedQty
,orel.OurStockQty
,orel.OurStockShippedQty
,orel.PartNum
,p.PartDescription
,orel.SalesUM
,orel.ReqDate
,oh.CustNum
,c.Name CustomerName
,jp.JobNum
,jp.ProdQty
,st.Name ShipToName
,id.OurOrderQty
,id.OurShipQty
,(SELECT SUM(pw.OnHandQty) FROM ERP.PartWhse pw WHERE pw.Company = orel.Company AND pw.PartNum = Orel.PartNum) OnHandQty
from erp.OrderRel orel
left outer join erp.ShipVia sv on orel.company = sv.company and orel.ShipViaCode = sv.ShipViaCode
left outer join erp.Orderhed oh on orel.company = oh.company and orel.OrderNum = oh.OrderNum
left outer join erp.customer c on oh.company = c.company and oh.CustNum = c.CustNum
left outer join erp.Part p on orel.Company = p.company and orel.partnum = p.PartNum
left outer join erp.jobprod jp on orel.company = jp.company and orel.ordernum = jp.OrderNum and orel.orderline = jp.orderline and orel.OrderRelNum = jp.OrderRelNum
left outer join erp.shipto st on orel.company = st.company and orel.ShipToCustNum = st.CustNum and orel.ShipToNum = st.ShipToNum
left outer join erp.InvcDtl id on orel.company = id.company and orel.ordernum = id.OrderNum and orel.OrderLine = id.OrderLine and orel.OrderRelNum = id.OrderRelNum and orel.partnum = id.PartNum
WHERE
(oh.OpenOrder = 1 OR @ClosedOrders = 1)

AND (orel.Make = @ShowDirects OR orel.Make = 0)

AND ((@ShowOnlyOnHand = 1 AND (SELECT SUM(pw.OnHandQty) FROM ERP.PartWhse pw WHERE pw.Company = orel.Company AND pw.PartNum = Orel.PartNum) > 0) 
OR (@ShowOnlyOnHand = 0 AND (SELECT SUM(pw.OnHandQty) FROM ERP.PartWhse pw WHERE pw.Company = orel.Company AND pw.PartNum = Orel.PartNum) IS NOT NULL))

AND ((@StartDueDate = '' AND (orel.ReqDate IS NULL OR orel.ReqDate >= @StartDueDate))
OR (orel.ReqDate >= @StartDueDate))

AND ((@EndDueDate = '' AND (orel.ReqDate IS NULL OR orel.ReqDate <= @EndDueDate))
OR orel.ReqDate <= @EndDueDate)

AND orel.WarehouseCode LIKE '%' + @WhCode + '%'