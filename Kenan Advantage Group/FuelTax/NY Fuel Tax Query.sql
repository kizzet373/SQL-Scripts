USE KAG_Fuel_Tax

DECLARE @State		VARCHAR(3) = 'NY'
	,	@Company	VARCHAR(4) = 'AVTK' --'NOCP' 'KNTC' 'POCN'
	,	@Period		SMALLDATETIME = '20191101'

IF OBJECT_ID('tempdb..#results') IS NOT NULL DROP TABLE #results
SELECT 
	'FT-942' AS Schedule
,	a.Part
,	CAST(a.ShipDate AS DATE) AS DateDelivered
,	a.IRSTerminalCode AS OriginTCN
,	a.ShipperName AS OriginName
,	a.ShipperCity AS OriginCity
,	a.ShipperState AS OriginState
,	a.ShipperZip AS OriginZip
,	'' AS OriginCountry
,	CASE WHEN @Company = 'NOCP' THEN '341317334'
		 WHEN @Company = 'AVTK' THEN '341688614'
		 WHEN @Company = 'POCN' THEN '741356755'
		 WHEN @Company = 'KNTC' THEN '560516485'
		 ELSE '' END AS EINOfImporter
,	CASE WHEN @Company = 'NOCP' THEN 'North Canton Transfer LLC'
		 WHEN @Company = 'AVTK' THEN 'Advantage Tank Lines LLC'
		 WHEN @Company = 'POCN' THEN 'Petro Chemical Transport LLC'
		 WHEN @Company = 'KNTC' THEN 'Kenan Transport LLC'
		 ELSE '' END AS NameOfImporter
,	'' AS DestinationTCN
,	a.ConsigneeFEIN AS DestinationEIN
,	REPLACE(CASE WHEN (Select LEN(a.ConsigneeName)) > 35 AND (SELECT COUNT(VALUE) FROM STRING_SPLIT(a.ConsigneeName,'(')) > 1 THEN (SELECT TOP 1 VALUE FROM STRING_SPLIT(a.ConsigneeName, '(')) ELSE a.ConsigneeName END, ',','') AS DestinationName
,	a.ConsigneeCity AS DestinationCity
,	a.ConsigneeState AS DestinationState
,	a.ConsigneeZip AS DestinationZip
,	'' AS DestinationCountry
,	'T' AS ModeOfDelivery
,	a.BillOfLading AS ManifestNumber
,	a.GrossGallons AS Gallons
,	a.PIDX AS ProductCode
INTO #results
FROM (
	SELECT 
		CASE WHEN sd.ShipperState <> sd.[State] THEN '1'
			 WHEN sd.ShipperState = sd.[State] AND sd.ConsigneeState <> sd.[State] THEN '2'
			 ELSE '3' END AS Part
	, *
	FROM ShipmentData sd WITH(NOLOCK)
	WHERE sd.State = @State
	AND sd.Company = @Company
	AND sd.Period = @Period
	AND sd.Exclude <> 1
	AND sd.ConsigneeFEIN <> ''
) a

SELECT 
	Schedule
,	Part
,	Convert(VARCHAR(10),DateDelivered,101)
,	OriginTCN
,	OriginName
,	OriginCity
,	OriginState
,	OriginZip
,	OriginCountry
,	EINOfImporter
,	NameOfImporter
,	DestinationTCN
,	DestinationEIN
,	DestinationName
,	DestinationCity
,	DestinationState
,	DestinationZip
,	DestinationCountry
,	ModeOfDelivery
,	ManifestNumber
,	Gallons
,	ProductCode
FROM #results
WHERE Part <> '3'
