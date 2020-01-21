DECLARE @State VARCHAR(3) = 'MS'
	,	@Company VARCHAR(4) = 'KNTC'
	,	@Period SMALLDATETIME = '20180701'
	,	@OldPIDX VARCHAR(10) = '167'
	,	@NewPIDX VARCHAR(10) = '160'
 
BEGIN TRAN
	UPDATE sd 
	SET sd.PIDX = @NewPIDX
	--SELECT sd.PIDX, fgt_description, *
	FROM dbo.ShipmentData sd WITH(NOLOCK)
	WHERE sd.State = @State
	AND sd.Company = @Company
	AND sd.Period = @Period
	AND sd.PIDX = @OldPIDX
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
