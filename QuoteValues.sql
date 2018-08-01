Declare @PartNum nvarchar(15) = '1003992', @QuoteNum nvarchar(15) = '11470'; 

select CartonPallet_c, PcsPerPallet_c, Pack_c, Erp.QuoteDtl.XPartNum from ERP.QuoteDtl
inner join ERP.QuoteDtl_UD on QuoteDtl_UD.ForeignSysRowID = QuoteDtl.SysRowID
Where QuoteNum = @QuoteNum
Order By QuoteLine Asc

select * from Erp.PartDtl
Where PartNum = @PartNum