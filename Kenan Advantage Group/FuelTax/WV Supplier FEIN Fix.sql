USE KAG_Fuel_Tax;

----Set Fuel Tax Data----
DECLARE
	@State CHAR(3) ='WV',
	@Company CHAR(4)='AVTK',
	@Period VARCHAR(8)='20191101'

---------------------------------------------------------------------------------------------

UPDATE ShipmentData
SET Exclude = 1
WHERE State=@State
AND Company = @Company
AND Period = @Period
AND SupplierFEIN in 
('311551430',
'201266997',
'522074528',
'391922316',
'811141412',
'274430481',
'560686306',
'943660355',
'311537655',
'362440313',
'841438366',
'592112332')


----Update Filing Log----
UPDATE dbo.FilingLog
SET 
	DateConfirmed = null,
	ConfirmedBy = null,
	DateSubmitted = null,
	SubmittedBy = null
WHERE 
	State = @State 
	AND Company = @Company
	AND CONVERT(VARCHAR, Period, 112) = @Period