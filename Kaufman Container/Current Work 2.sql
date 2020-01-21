select 
	[Customer].[CustID] as [Customer_CustID],
	[Customer].[Name] as [Customer_Name],
	(DENSE_RANK() OVER(ORDER BY Calculated_Sales DESC)) as [Calculated_RankNumber],
	[SubQuery3].[Calculated_DollMonth] as [Calculated_DollMonth],
	[SubQuery3].[Calculated_NewCostMonth] as [Calculated_NewCostMonth],
	[SubQuery4].[Calculated_FrtMth] as [Calculated_FrtMth],
	((case when SubQuery4.Calculated_FrtMth <> 0  then SubQuery3.Calculated_DollMonth - SubQuery3.Calculated_NewCostMonth - SubQuery4.Calculated_FrtMth else SubQuery3.Calculated_DollMonth - SubQuery3.Calculated_NewCostMonth end)) as [Calculated_MonthGPDoll],
	(Cast(Cast((case when SubQuery4.Calculated_FrtMth <> 0 then (case when SubQuery3.Calculated_DollMonth = 0 then 0 else  ( SubQuery3.Calculated_DollMonth - SubQuery3.Calculated_NewCostMonth - SubQuery4.Calculated_FrtMth )  / SubQuery3.Calculated_DollMonth  * 100   end) else (case when SubQuery3.Calculated_DollMonth = 0 then 0 else  ( SubQuery3.Calculated_DollMonth - SubQuery3.Calculated_NewCostMonth  )  / SubQuery3.Calculated_DollMonth  * 100   end) end)as decimal(18,1)) as nvarchar(20)) + '%') as [Calculated_MTDGPPer],
	[SubQuery2].[Calculated_NewCost] as [Calculated_NewCost],
	[SubQuery5].[Calculated_TotalFreight] as [Calculated_TotalFreight],
	((case when SubQuery5.Calculated_TotalFreight <> 0  then SubQuery2.Calculated_Sales - SubQuery2.Calculated_NewCost - SubQuery5.Calculated_TotalFreight else SubQuery2.Calculated_Sales - SubQuery2.Calculated_NewCost end)) as [Calculated_TotGPDoll],
	(Cast(Cast(case  		when SubQuery5.Calculated_TotalFreight <> 0 then( 			case  				when SubQuery2.Calculated_Sales = 0 then 0  				else  ( SubQuery2.Calculated_Sales - SubQuery2.Calculated_NewCost - SubQuery5.Calculated_TotalFreight )  / SubQuery2.Calculated_Sales  * 100    			end)  		else( 			case  				when SubQuery2.Calculated_Sales = 0 then 0  				else  ( SubQuery2.Calculated_Sales - SubQuery2.Calculated_NewCost  )  / SubQuery2.Calculated_Sales  * 100   end) 	end as decimal(18,1)) as nvarchar(20)) + '%') as [Calculated_TotGPPer],
	[SubQuery6].[Calculated_PrevCost] as [Calculated_PrevCost],
	[SubQuery7].[Calculated_PrevFreight] as [Calculated_PrevFreight],
	(case  		when Calculated_PrevCost = 0 or Calculated_PrevCost = null then null		when Calculated_PrevSales = 0 or Calculated_PrevSales = null then null 		else (Cast(Cast((Calculated_PrevCost / Calculated_PrevSales * 100.0) as decimal(18,1)) as nvarchar(20)) + '%')	end) as [Calculated_PrevGPPer],
	Calculated_Sales - Calculated_PrevSales as [Calculated_YTDDifference],
	(case  		when Calculated_PrevSales = 0 or Calculated_PrevSales = null then null 		when (Calculated_Sales - Calculated_PrevSales) = 0 or (Calculated_Sales - Calculated_PrevSales) = null then null		else Cast(Cast(((Calculated_Sales - Calculated_PrevSales) / Calculated_PrevSales * 100) as decimal(18,1)) as nvarchar(20))+ '%'	end) as [Calculated_YTDDifferencePer],
	[SubQuery6].[Calculated_PrevSales] as [Calculated_PrevSales],
	[SubQuery2].[Calculated_Sales] as [Calculated_Sales]
from Erp.Customer as Customer
left outer join  (select 
	[InvcHead].[CustNum] as [InvcHead_CustNum],
	(sum((InvcDtl.MtlUnitCost + InvcDtl.LbrUnitCost + InvcDtl.BurUnitCost + InvcDtl.SubUnitCost + InvcDtl.MtlBurUnitCost) * InvcDtl.OurShipQty)) as [Calculated_Cost],
	(sum(  (case when InvcDtl_UD.AdjustCost_c !> 0 then ((InvcDtl.MtlUnitCost + InvcDtl.LbrUnitCost + InvcDtl.BurUnitCost + InvcDtl.SubUnitCost + InvcDtl.MtlBurUnitCost) * InvcDtl.OurShipQty) else InvcDtl_UD.AdjustCost_c end) )) as [Calculated_NewCost],
	(sum( InvcDtl.OurShipQty )) as [Calculated_Units],
	(sum(InvcDtl.ExtPrice)) as [Calculated_Sales]
from Erp.InvcHead as InvcHead
inner join Erp.InvcDtl as InvcDtl on 
	InvcHead.Company = InvcDtl.Company
And
	InvcHead.InvoiceNum = InvcDtl.InvoiceNum
 and ( not InvcDtl.PartNum = '1007180'  and not InvcDtl.PartNum = '1007184'  and not InvcDtl.LineDesc like 'Unapp'  )

inner join Erp.Part as Part on 
	InvcDtl.Company = Part.Company
And
	InvcDtl.PartNum = Part.PartNum
inner join Erp.InvcDtl_UD as InvcDtl_UD on
	InvcDtl.SysRowID = InvcDtl_UD.ForeignSysRowID

 where (InvcHead.InvoiceDate >= '1/1/2017'  and InvcHead.InvoiceDate <= '12/31/2017'  and InvcHead.InvoiceNum <> 325013  and InvcHead.InvoiceNum <> 325014  and InvcHead.InvoiceNum <> 325015  and InvcHead.InvoiceNum <> 325016)
group by [InvcHead].[CustNum])  as SubQuery2 on 
	Customer.CustNum = SubQuery2.InvcHead_CustNum

left outer join  (select 
	[InvcHead1].[CustNum] as [InvcHead1_CustNum],
	(sum(InvcDtl1.ExtPrice)) as [Calculated_DollMonth],
	(sum((InvcDtl1.MtlUnitCost + InvcDtl1.LbrUnitCost + InvcDtl1.BurUnitCost + InvcDtl1.SubUnitCost + InvcDtl1.MtlBurUnitCost) * InvcDtl1.OurShipQty)) as [Calculated_CostMonth],
	(sum(  (case when InvcDtl1_UD.AdjustCost_c = 0 then ((InvcDtl1.MtlUnitCost + InvcDtl1.LbrUnitCost + InvcDtl1.BurUnitCost + InvcDtl1.SubUnitCost + InvcDtl1.MtlBurUnitCost) * InvcDtl1.OurShipQty)  else InvcDtl1_UD.AdjustCost_c end) )) as [Calculated_NewCostMonth]
from Erp.InvcHead as InvcHead1
inner join Erp.InvcDtl as InvcDtl1 on 
	InvcHead1.Company = InvcDtl1.Company
And
	InvcHead1.InvoiceNum = InvcDtl1.InvoiceNum
 and ( not InvcDtl1.PartNum = '1007180'  and not InvcDtl1.PartNum = '1007184'  and not InvcDtl1.LineDesc like 'Unapp'  )

inner join Erp.Part as Part1 on 
	InvcDtl1.Company = Part1.Company
And
	InvcDtl1.PartNum = Part1.PartNum
inner join Erp.InvcDtl_UD as InvcDtl1_UD on
	InvcDtl1.SysRowID = InvcDtl1_UD.ForeignSysRowID

 where (InvcHead1.InvoiceDate >= '1/1/2017'  and InvcHead1.InvoiceDate <= '12/31/2017'  and InvcHead1.InvoiceNum <> 325013  and InvcHead1.InvoiceNum <> 325014  and InvcHead1.InvoiceNum <> 325015  and InvcHead1.InvoiceNum <> 325016)
group by [InvcHead1].[CustNum])  as SubQuery3 on 
	Customer.CustNum = SubQuery3.InvcHead1_CustNum

left outer join  (select 
	[UD07].[Key1] as [UD07_Key1],
	(sum( UD07.Number01 )) as [Calculated_FrtMth]
from Ice.UD07 as UD07
 where (UD07.Key2 = '2017'  and UD07.Key3 = '12')
group by [UD07].[Key1])  as SubQuery4 on 
	Customer.CustID = SubQuery4.UD07_Key1

left outer join  (select 
	[UD071].[Key1] as [UD071_Key1],
	(sum( UD071.Number01 )) as [Calculated_TotalFreight]
from Ice.UD07 as UD071
group by [UD071].[Key1])  as SubQuery5 on 
	Customer.CustID = SubQuery5.UD071_Key1

left outer join  (select 
	[InvcHead2].[CustNum] as [InvcHead2_CustNum],
	(sum(  (case when InvcDtl2_UD.AdjustCost_c = 0 then ((InvcDtl2.MtlUnitCost + InvcDtl2.LbrUnitCost + InvcDtl2.BurUnitCost + InvcDtl2.SubUnitCost + InvcDtl2.MtlBurUnitCost) * InvcDtl2.OurShipQty) else InvcDtl2_UD.AdjustCost_c end) )) as [Calculated_PrevCost],
	(sum(InvcDtl2.ExtPrice)) as [Calculated_PrevSales]
from Erp.InvcHead as InvcHead2
inner join Erp.InvcDtl as InvcDtl2 on 
	InvcHead2.Company = InvcDtl2.Company
And
	InvcHead2.InvoiceNum = InvcDtl2.InvoiceNum
 and ( InvcDtl2.PartNum <> '1007180'  and InvcDtl2.PartNum <> '1007184'  and not InvcDtl2.LineDesc like 'Unapp'  )
inner join Erp.InvcDtl_UD as InvcDtl2_UD on
	InvcDtl2.SysRowID = InvcDtl2_UD.ForeignSysRowID

 where (InvcHead2.InvoiceDate >= DATEADD(year, -1, '1/1/2017')  and InvcHead2.InvoiceDate <= DATEADD(year, -1, '12/31/2017'))
group by [InvcHead2].[CustNum])  as SubQuery6 on 
	Customer.CustNum = SubQuery6.InvcHead2_CustNum

left outer join  (select 
	[UD072].[Key1] as [UD072_Key1],
	(sum( UD072.Number01 )) as [Calculated_PrevFreight],
	(Cast(Key2 as Integer)) as [Calculated_IntFreightYear],
	(Cast(Key3 as Integer)) as [Calculated_IntFreightMonth],
	[UD072].[Key3] as [UD072_Key3],
	[UD072].[Key2] as [UD072_Key2]
from Ice.UD07 as UD072
 where ((UD072.Key2 >= Year('1/1/2017') ) and (UD072.Key2 <= Year('12/31/2017') ) and (UD072.Key3 >= Month('1/1/2017') ) and (UD072.Key3 <= Month('12/31/2017') ))
group by [UD072].[Key1],
	(Cast(Key2 as Integer)),
	(Cast(Key3 as Integer)),
	[UD072].[Key3],
	[UD072].[Key2])  as SubQuery7 on 
	Customer.CustID = SubQuery7.UD072_Key1

inner join Erp.Terms as Terms on 
	Customer.Company = Terms.Company
And
	Customer.TermsCode = Terms.TermsCode

inner join Erp.SalesRep as SalesRep on 
	Customer.Company = SalesRep.Company
And
	Customer.SalesRepCode = SalesRep.SalesRepCode

 where 
	Customer.CustomerType like '%C%'
	and SubQuery2.Calculated_Sales <> 0  
	and SubQuery6.Calculated_PrevSales <> 0  
	and (SalesRep.SalesRepCode = 9  or SalesRep.Name like ('%' + '9' + '%') )
	order by  Customer.SalesRepCode ,  SubQuery2.Calculated_Sales