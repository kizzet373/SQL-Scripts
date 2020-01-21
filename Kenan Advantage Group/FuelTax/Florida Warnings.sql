/*-------------------------------------------------------------------------------------
Warnings to exclude from ShipmentData table:
-------------------------------------------------------------------------------------*/
USE KAG_Fuel_Tax

DECLARE @State		VARCHAR(3) = 'FL'
	,	@Company	VARCHAR(4) = 'KNTC'
	,	@Period		VARCHAR(10) = '20191201'
	,   @UpdateFilingLog BIT = 1;


--Temp table of warning records
IF OBJECT_ID('tempdb..#results') IS NOT NULL DROP TABLE #results;
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
SELECT * 
INTO #results
FROM FuelTaxCTE sd WITH(NOLOCK)
WHERE dest LIKE '%UNKNOWN%' OR dest IN (
'03Facility ID 9812045',
'05Facility ID 9046578',
'13Facility# 8506530',
'16Facility ID 8507183',
'26Facility# 8521268',
'46Facility ID 9601460',
'59Facility ID 9814193',
'46Steve Schwinden said th',
'16More than 10 pickups in',
'29More than 10 pickups in',
'48this is a loading rack.',
'56FL',
'42AST',
'43AST',
'50AST',
'01AST',
'13850943',
'138512654',
'138512791',
'139103508',
'139600947',
'139700773',
'139801609',
'139804885',
'139814954',
'179809002',
'289805269',
'299102577',
'299814903',
'299815229',
'299815553',
'299815898',
'299816839',
'358515892',
'359815763',
'499816125',
'588502986',
'588631201',
'589808652',
'599801611'
)


--Exclude the warning records
BEGIN TRAN
	UPDATE sd 
	SET sd.Exclude = 1
	--SELECT * 
	FROM dbo.ShipmentData sd WITH(NOLOCK)
	JOIN #results r ON sd.ID = r.ID
COMMIT TRAN
--View the excluded results
SELECT sd.Exclude,dest, sd.* 
FROM dbo.ShipmentData sd WITH(NOLOCK)
JOIN #results r ON sd.ID = r.ID


----Update Filing Log----
IF(@UpdateFilingLog = 1)
BEGIN
	UPDATE dbo.FilingLog
	SET 
		DateSubmitted = null,
		SubmittedBy = null,
		DateConfirmed = null,
		ConfirmedBy = null
	WHERE 
		(State = @State AND @State <> '%') 
		AND (Company = @Company AND @Company <> '%') 
		AND (CONVERT(VARCHAR, Period, 112) = @Period AND @Period <> '%');

Select 
	DateSubmitted, 
	SubmittedBy, 
	DateConfirmed,
	ConfirmedBy,
	State, 
	Company, 
	Period
FROM dbo.FilingLog
WHERE
	(State = @State AND @State <> '%') 
	AND (Company = @Company AND @Company <> '%') 
	AND (CONVERT(VARCHAR, Period, 112) = @Period AND @Period <> '%');
END
----End Update Filing Log----