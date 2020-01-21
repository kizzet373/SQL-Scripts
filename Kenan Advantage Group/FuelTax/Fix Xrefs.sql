select * from ShipmentData where state='MO' and company ='KLEQ' and period='20191101' and pidx =''

update shipmentdata
set pidx = ISNULL((select top 1 xref.XVal1 from [TMW_FUEL_PROD.DB.THEKAG.COM].[TMW_PROD].[dbo].[KAG_vwKAGQueue_xrefrecords] xref where xref.Type='FTPIDXState' and xref.Val1 = 'MO' AND xref.Val2=sd.cmd_code),'')
from shipmentdata sd
where state='MO' and company ='KLEQ' and period='20191101' and pidx =''

update shipmentdata
set pidx = ISNULL((select top 1 xref.XVal1 from [TMW_FUEL_PROD.DB.THEKAG.COM].[TMW_PROD].[dbo].[KAG_vwKAGQueue_xrefrecords] xref where xref.Type='FTPIDX' and xref.Val1=sd.cmd_code),'')
from shipmentdata sd
where state='MO' and company ='KLEQ' and period='20191101' and pidx =''

select * from ShipmentData where state='MO' and company ='KLEQ' and period='20191101' and pidx =''

select top 1 xref.XVal1 from [TMW_FUEL_PROD.DB.THEKAG.COM].[TMW_PROD].[dbo].[KAG_vwKAGQueue_xrefrecords] xref where xref.Type='FTPIDX' and xref.Val1='B5D'