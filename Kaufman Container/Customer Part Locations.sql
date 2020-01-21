/*Select
	cust.
From
	dbo.Customer cust
	
	left outer join dbo.CustXPrt cxp
	on cxp.CustNum = cust.CustNum
	
	left outer join dbo.Part part
	on cxp.PartNum = part.PartNum
Where
*/


select 
  [Part].[PartNum] as [KCC Part Number],
  [CustXPrt].[XPartNum] as [Customer Part Number],
  [Part].[PartDescription] as [Part Description],
  cast(coalesce([SubQuery2].[Quantity On Hand], 0) as int) as [Quantity On Hand],
  cast(coalesce([Part].[Pack_c], 0) as int) as [Pieces Per Carton],
  cast(coalesce([Part].[PcsPerPallet_c], 0) as int) as [Pieces Per Pallet]

from dbo.CustXPrt as CustXPrt

inner join dbo.Part as Part on 
  CustXPrt.Company = Part.Company
  and CustXPrt.PartNum = Part.PartNum

left outer join  (select 
  [PartBin].[PartNum] as [PartBin_PartNum],
  (sum( PartBin.OnhandQty )) as [Quantity On Hand]
from Erp.PartBin as PartBin
group by [PartBin].[PartNum])  as SubQuery2 on 
  CustXPrt.PartNum = SubQuery2.PartBin_PartNum
inner join dbo.Customer as Customer on 
  CustXPrt.Company = Customer.Company
  and CustXPrt.CustNum = Customer.CustNum
  and ( Customer.CustID = '1240031'  )

where (CustXPrt.Exclude_c = 0)
