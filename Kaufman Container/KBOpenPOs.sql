select 
	[POHeader].[BuyerID] as [POHeader_BuyerID],
	[POHeader].[OrderDate] as [POHeader_OrderDate],
	[Vendor].[VendorID] as [Vendor_VendorID],
	[Vendor].[Name] as [Vendor_Name],
	[POHeader].[PONum] as [POHeader_PONum],
	[PODetail].[POLine] as [PODetail_POLine],
	[PODetail].[PartNum] as [PODetail_PartNum],
	[PODetail].[LineDesc] as [PODetail_LineDesc],
	[PORel].[XRelQty] as [PORel_XRelQty],
	[PODetail].[DocUnitCost] as [PODetail_DocUnitCost],
	[PORel].[DueDate] as [PORel_DueDate],
	[PORel_UD].[ShipDate_c] as [PORel_ShipDate_c],
	[PORel_UD].[OrigAckDate_c] as [PORel_OrigAckDate_c],
	((PORel.XRelQty - PORel.ReceivedQty) * PODetail.DocUnitCost) as [Calculated_ExtCost],
	[PORel].[ReceivedQty] as [PORel_ReceivedQty],
	[POHeader].[Confirmed] as [POHeader_Confirmed],
	[Vendor_UD].[Foreign_c] as [Vendor_Foreign_c]
from Erp.POHeader as POHeader
inner join Erp.Vendor as Vendor on 
	POHeader.Company = Vendor.Company
And
	POHeader.VendorNum = Vendor.VendorNum

inner join Erp.PODetail as PODetail on 
	POHeader.Company = PODetail.Company
And
	POHeader.PONum = PODetail.PONUM
 and ( PODetail.OpenLine = 'true'  )

inner join Erp.PORel as PORel on 
	PODetail.Company = PORel.Company
And
	PODetail.PONUM = PORel.PONum
And
	PODetail.POLine = PORel.POLine
 and ( PORel.OpenRelease = 'true'  )

inner join Erp.PORel_UD as PORel_UD on
	PORel.SysRowID = PORel_UD.ForeignSysRowID

inner join [Erp].[Vendor_UD] as Vendor_UD on
	Vendor_UD.ForeignSysRowID = Vendor.SysRowID

 where (POHeader.OpenOrder = 'true')