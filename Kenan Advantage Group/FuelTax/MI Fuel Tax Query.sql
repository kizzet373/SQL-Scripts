DECLARE @State		VARCHAR(3) = 'MI'
	,	@Company	VARCHAR(4) = 'NOCP'
	,	@Period		SMALLDATETIME = '20191201' --Quarterly file

IF OBJECT_ID('tempdb..#results') IS NOT NULL DROP TABLE #results
SELECT 
	a.PIDX AS ProductCode
,	a.BilltoName AS BuyerName
,	a.BilltoFEIN AS BuyerFEIN
,	'Advantage Tank Lines LLC' AS CarrierName
,	'341688614' AS CarrierFEIN
,	a.BillOfLading 
,	CONVERT(VARCHAR, a.ShipDate, 101) AS DateDelivered
,	'J' AS TransportationMode 
,	a.IRSTerminalCode AS OriginTerminalCode
,	a.ShipperAddress AS OriginalAddress
,	a.ShipperCity AS OriginalCity
,	a.ShipperState AS OriginalState
,	a.ShipperZip AS OriginalZip
,	'USA' AS OriginCountryCode
,	'' AS DestinationTerminalCode
,	a.ConsigneeAddress AS DestinationAddress
,	a.ConsigneeCity AS DestinationCity
,	a.ConsigneeState AS DestinationState
,	a.ConsigneeZip AS DestinationZip
,	CASE WHEN a.ConsigneeAcct IN ('AIRBMIS','CHARBRE','DBAMTOR') THEN 'CAN' ELSE 'USA' END AS DestinationCountryCode
,	a.NetGallons
,	a.GrossGallons
,	a.GrossGallons AS BilledGallons
,	a.ScheduleCode
INTO #results
FROM (
	SELECT 
		CASE WHEN sd.ShipperState = sd.[State] AND sd.ConsigneeState <> sd.[State] THEN '14A'
			 WHEN sd.ShipperState <> sd.[State] AND sd.ConsigneeState = sd.[State] THEN '14B'
			 ELSE '14C' END AS ScheduleCode
	,	*
	FROM ShipmentData sd WITH(NOLOCK)
	WHERE sd.State = @State
	AND sd.Company = @Company
	AND sd.Period = @Period
) a
WHERE a.ScheduleCode != '14C'
AND Exclude = 0

--Results for 14A section of MI .xls template
SELECT 
	ProductCode
,	BuyerName
,	BuyerFEIN
,	CarrierName
,	CarrierFEIN
,	BillOfLading
,	DateDelivered
,	TransportationMode
,	OriginTerminalCode
,	OriginalAddress
,	OriginalCity
,	OriginalState
,	OriginalZip
,	OriginCountryCode
,	DestinationTerminalCode
,	DestinationAddress
,	DestinationCity
,	DestinationState
,	DestinationZip
,	DestinationCountryCode
,	NetGallons
,	GrossGallons
,	BilledGallons
FROM #results
WHERE ScheduleCode = '14A'
order by BuyerName

--Results for 14B section of MI .xls template
SELECT 
	ProductCode
,	BuyerName
,	BuyerFEIN
,	CarrierName
,	CarrierFEIN
,	BillOfLading
,	DateDelivered
,	TransportationMode
,	OriginTerminalCode
,	OriginalAddress
,	OriginalCity
,	OriginalState
,	OriginalZip
,	OriginCountryCode
,	DestinationTerminalCode
,	DestinationAddress
,	DestinationCity
,	DestinationState
,	DestinationZip
,	DestinationCountryCode
,	NetGallons
,	GrossGallons
,	BilledGallons
FROM #results
WHERE ScheduleCode = '14B'
ORDER BY BuyerName




