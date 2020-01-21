DECLARE @State VARCHAR(3) = 'IA'
	,	@Company VARCHAR(4) = 'KLEQ'
	,	@Period SMALLDATETIME = '20191101'
	,	@DeletingSubstring VARCHAR(25) = '9010'
	,	@GetAllLengthyBOLs BIT = 1
	,   @UpdateBOLs BIT = 1;

IF(@GetAllLengthyBOLs = 1)
BEGIN
--Check all BillofLadings for length of greater than 8
	SELECT *
	FROM dbo.ShipmentData
	WHERE State = @State
	AND Period = @Period
	AND Company = @Company
	AND LEN(BillOfLading) > 8
END

--SCRIPT A	
SELECT *
FROM dbo.ShipmentData WITH (NOLOCK)
WHERE State = @State
AND Period = @Period
AND Company = @Company
AND BillOfLading LIKE (@DeletingSubstring + '%')
AND LEN(BillOfLading) > 8

--SCRIPT B
IF(@UpdateBOLs = 1)
BEGIN
	BEGIN TRAN
	UPDATE dbo.ShipmentData
	SET BillOfLading = REPLACE(BillOfLading, @DeletingSubstring, '')
	WHERE State = @State
	AND Period = @Period
	AND BillOfLading LIKE (@DeletingSubstring + '%')
	AND LEN(BillOfLading) > 8
	COMMIT TRAN

	--SCRIPT C	
	SELECT *
	FROM dbo.ShipmentData WITH (NOLOCK)
	WHERE State = @State
	AND Period = @Period
	AND Company = @Company
	AND BillOfLading LIKE (@DeletingSubstring + '%')
	AND LEN(BillOfLading) > 8

	--SCRIPT D
	BEGIN TRAN
		UPDATE fl 
		SET fl.DateSubmitted = NULL
		,	fl.SubmittedBy = NULL
		,	fl.ConfirmedBy = NULL
		,	fl.DateConfirmed = NULL
		--SELECT * 
		FROM dbo.FilingLog fl WITH(NOLOCK)
		WHERE fl.State = @State
		AND fl.Company = @Company
		AND fl.Period = @Period
	COMMIT TRAN
END