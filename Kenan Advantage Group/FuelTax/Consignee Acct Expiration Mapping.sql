DECLARE @State		VARCHAR(3) = 'FL'
	,	@Company	VARCHAR(4) = 'KNTC'
	,	@Period		VARCHAR(10) = '20191101'
	,   @UpdateFilingLog BIT = 0;

WITH FuelTaxCTE AS (SELECT 
	SD.ID
	,SD.State
	,SD.Company
	,SD.Period
	,CASE WHEN 
		sd.ConsigneeState = 'FL ' 
		AND dbo.KAG_fnFloridaDOR(REPLACE(SD.ConsigneeAcct,'.','')) LIKE 'XX%' 
	THEN 'FL' 
	WHEN 
		sd.ConsigneeState = 'FL ' 
		AND dbo.KAG_fnFloridaDOR(REPLACE(SD.ConsigneeAcct,'.','')) NOT LIKE 'XX%' 
	THEN dbo.KAG_fnFloridaDOR(REPLACE(SD.ConsigneeAcct,'.','')) 
	ELSE SD.consigneeState 
	END AS dest
	,SD.BillOfLading
	,SD.PIDX
	,SD.ConsigneeAddress
	,SD.ConsigneeCity
	,SD.ConsigneeState
	,SD.ConsigneeZip
	,SD.ShipperFEIN
	,SD.ShipDate
	,SD.ConsigneeAcct
FROM ShipmentData SD
WHERE 
	(@State='%' OR SD.State = @State)
	AND (@Company='%' OR Company = @Company)
	AND (CONVERT(VARCHAR, @Period, 112) = '%' OR Period = @Period)
	AND (Exclude = 0) 
)

select Distinct FuelTaxCTE.ConsigneeAcct,FuelTaxCTE.dest FROM FuelTaxCTE where FuelTaxCTE.dest LIKE '%UNKNOWN%' OR FuelTaxCTE.dest IN
('03Facility ID 9812045',
'299816839',
'13850943',
'299102577',
'588502986',
'299814903',
'299815898',
'299815553',
'358515892',
'16Facility ID 8507183',
'499816125',
'359815763',
'138512654',
'05Facility ID 9046578',
'50AST',
'139103508',
'48this is a loading rack.'
)