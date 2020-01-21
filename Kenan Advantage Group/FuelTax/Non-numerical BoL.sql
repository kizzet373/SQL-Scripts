Select BillOfLading, Exclude From ShipmentData Where 
		State = 'MI '
		AND Company = 'KLEQ'
		AND CONVERT(VARCHAR, Period, 112) = '20181201'
		AND ISNUMERIC(BillOfLading) = 0;

WITH FuelTaxCTE AS (
	SELECT 
		'' AS FLDestination
		,*
	FROM ShipmentData SD
	WHERE 
		(SD.State = 'MI ')
		AND (Company = 'KLEQ')
		AND (CONVERT(VARCHAR, Period, 112) = '20181201')
)
UPDATE FuelTaxCTE
SET Exclude = 1
WHERE
	(ISNUMERIC(BillOfLading) = 0);


Select BillOfLading, Exclude From ShipmentData Where 
	State = 'MI '
	AND Company = 'KLEQ'
	AND CONVERT(VARCHAR, Period, 112) = '20181201'
	AND ISNUMERIC(BillOfLading) = 0;