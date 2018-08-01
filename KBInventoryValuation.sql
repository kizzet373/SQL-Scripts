WITH CTE AS
(select 
	[PartBin].[PartNum] as [PartBin_PartNum],
	[PartPlant_UD].[XPartNum_c] as [PartPlant_UD_XPartNum_c],
	[Part].[PartDescription] as [Part_PartDescription],
	[Part].[ClassID] as [Part_ClassID],
	[Part].[CostMethod] as [Part_CostMethod],
	[Part].[TrackLots] as [Part_TrackLots],
	[PartBin].[WarehouseCode] as [PartBin_WarehouseCode],
	[PartBin].[BinNum] as [PartBin_BinNum],
	[PartBin].[LotNum] as [PartBin_LotNum],
	[Part].[RefCategory] as [Part_RefCategory],
	[PartBin].[OnhandQty] as [PartBin_OnhandQty],
	(case  
     when Part.CostMethod = 'A' then  PartCost.AvgMaterialCost  + PartCost.AvgLaborCost + PartCost.AvgBurdenCost + PartCost.AvgSubContCost + PartCost.AvgMtlBurCost
     when Part.CostMethod = 'T' then  PartLot.LotMaterialCost  + PartLot.LotLaborCost + PartLot.LotBurdenCost + PartLot.LotSubContCost + PartLot.LotMtlBurCost
     else PartCost.StdMaterialCost  + PartCost.StdLaborCost + PartCost.StdBurdenCost + PartCost.StdSubContCost + PartCost.StdMtlBurCost
 end) as [Calculated_UnitCost],
	((case  
		 when Part.CostMethod = 'A' then  PartCost.AvgMaterialCost  + PartCost.AvgLaborCost + PartCost.AvgBurdenCost + PartCost.AvgSubContCost + PartCost.AvgMtlBurCost
		 when Part.CostMethod = 'T' then  PartLot.LotMaterialCost  + PartLot.LotLaborCost + PartLot.LotBurdenCost + PartLot.LotSubContCost + PartLot.LotMtlBurCost
		 else PartCost.StdMaterialCost  + PartCost.StdLaborCost + PartCost.StdBurdenCost + PartCost.StdSubContCost + PartCost.StdMtlBurCost
	end) * PartBin.OnhandQty) as [Calculated_ExtCost],
	[PartLot].[FirstRefDate] as [PartLot_FirstRefDate],
	[Customer].[CustID] as [Customer_CustID],
	[Customer].[Name] as [Customer_Name],
	(DATEDIFF(day, PartLot.FirstRefDate, GETDATE())) as [Calculated_Days],
	[PartPlant_UD].[CustID_c] as [PartPlant_UD_CustID_c],
	[Part_UD].[PcsPerPallet_c] as [Part_UD_PcsPerPallet_c],
	((case when Part_UD.PcsPerPallet_c <>0 then round((PartBin.OnhandQty / Part_UD.PcsPerPallet_c) + .5,0) else 0  end)) as [Calculated_NumPallets],
	[Part_UD].[Pack_c] as [Part_UD_Pack_c],
	((case when Part_UD.Pack_c <>0 then round((PartBin.OnhandQty / Part_UD.Pack_c) + .5,0) else 0  end)) as [Calculated_NumCartons],
	[Part_UD].[Excess_c] as [Part_UD_Excess_c],
	[Part].[NonStock] as [Part_NonStock],
	[PartPlant_UD].[Lifo_c] as [PartPlant_UD_Lifo_c],
	[Part].[ProdCode] as [Part_ProdCode]
from [Erp].[PartBin]
inner join [Erp].[PartLot] on 
	PartBin.Company = PartLot.Company
And
	PartBin.PartNum = PartLot.PartNum
And
	PartBin.LotNum = PartLot.LotNum

inner join Erp.PartCost on 
	PartBin.Company = PartCost.Company
And
	PartBin.PartNum = PartCost.PartNum

inner join Erp.Part as Part on 
	PartLot.Company = Part.Company
And
	PartLot.PartNum = Part.PartNum

inner join Erp.Part_UD on
Part.SysRowID = Part_UD.ForeignSysRowID

inner join Erp.PartPlant on 
	Part.Company = PartPlant.Company
And
	Part.PartNum = PartPlant.PartNum

inner join Erp.PartPlant_UD on
	PartPlant_UD.ForeignSysRowID = PartPlant.SysRowID

left outer join Erp.Customer as Customer on 
	PartPlant.Company = Customer.Company
And
	PartPlant_UD.CustID_c = Customer.CustID

 where (PartBin.OnhandQty <> 0))
 
 SELECT 
 PartBin_WarehouseCode,
 PartBin_BinNum,
 PartBin_PartNum,
 PartPlant_UD_XPartNum_c,
 PartBin_LotNum,
 Part_PartDescription,
 Part_ClassID,
 Part_CostMethod,
 Part_TrackLots,
 Part_RefCategory,
 PartBin_OnhandQty,
 Calculated_UnitCost,
 Calculated_ExtCost,
 PartLot_FirstRefDate,
 Customer_CustID,
 Customer_Name,
 Calculated_Days,
 PartPlant_UD_CustID_c,
 Part_UD_PcsPerPallet_c,
 Calculated_NumPallets,
 Part_UD_Pack_c,
 Calculated_NumCartons,
 Part_UD_Excess_c,
 Part_NonStock

 FROM CTE