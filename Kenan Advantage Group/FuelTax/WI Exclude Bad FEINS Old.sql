/*-------------------------------------------------------------------------------------
Errors to exclude from ShipmentData table:
-------------------------------------------------------------------------------------*/
DECLARE @State VARCHAR(3) = 'WI'
	,	@Company VARCHAR(4) = 'KLEQ'
	,	@Period SMALLDATETIME = '20180801'
 
BEGIN TRAN
UPDATE sd 
SET sd.Exclude = 1
--SELECT *
FROM dbo.ShipmentData sd WITH(NOLOCK)
WHERE sd.State = @State
AND sd.Company = @Company
AND sd.Period = @Period
AND sd.[InsertFuelTaxField] IN (
'113828503'
)
COMMIT TRAN
 
BEGIN TRAN
	UPDATE fl 
	SET fl.DateSubmitted = NULL
	,	fl.SubmittedBy = NULL
	--SELECT * 
	FROM dbo.FilingLog fl WITH(NOLOCK)
	WHERE fl.State = @State
	AND fl.Company = @Company
	AND fl.Period = @Period
COMMIT TRAN
