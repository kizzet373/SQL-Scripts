----Kirk's Query Template 1/23/2018----

---------------------------------- ALTER THESE VARIABLES! ----------------------------------

----Set Template variables----
DECLARE 
	@Update BIT = 0,
	@RequireExpectation BIT = 1,
	@ExpectedAffectedRows INT = 1,
	@ClearSubmission BIT = 1,
	@PrintExecString BIT = 1;
----End Set Template variables----

----Set Updating Column----
DECLARE 
	@UpdatingColumnName VARCHAR(40) = 'PIDX',
	@UpdatingColumnType VARCHAR(40) = 'VARCHAR',
	@UpdatingColumnValue VARCHAR(40) = '170';
----End Set Updating Column----
	
----Set File Log Data----
DECLARE
	@ID varchar(25) = '%',
	@Company varchar(25) = 'POCN',
	@ConfirmationNumber varchar(25) = '%',
	@ConfirmedBy varchar(20) = '%',
	@DateConfirmed varchar(25) = '%',	
	@DateSubmitted varchar(25) = '%',	
	@DueDate varchar(25) = '%',	
	@Period varchar(25) = '20181201',	
	@Seq varchar(25) = '%',
	@State varchar(25) = 'IN',
	@SubmittedBy varchar(25) = '%';
----End File Log Data----

---------------------------------------------------------------------------------------------



----Declare Other variables----
DECLARE 
	@t1 DATETIME = GETDATE(),
	@t2 DATETIME,
	@FirstSelectRows INT,
	@SecondSelectRows INT,
	@AffectedRows INT,
	@ExecString VARCHAR(3000)
----End Declare Other variables----



----Set NOCOUNT----
SET NOCOUNT ON;
----End Set NOCOUNT----



----Select Statement Before Update. Put SELECT Code Under Here!----
SELECT 
	ID,
	Company,
	ConfirmationNumber,
	ConfirmedBy,
	DateConfirmed,	
	DateSubmitted,	
	DueDate,	
	Period,	
	Seq,
	State,
	SubmittedBy
FROM FilingLog
WHERE
	(CAST(ID AS VARCHAR) = @ID OR @ID='%')
	AND (State = @State OR @State='%')
	AND (Company = @Company OR @Company='%')
	AND (CAST(ConfirmationNumber AS VARCHAR) = @ConfirmationNumber OR @ConfirmationNumber='%')
	AND (CONVERT(VARCHAR, Period, 112) = @Period OR @Period = '%')
	AND (CAST(ConfirmedBy AS VARCHAR) = @ConfirmedBy OR @ConfirmedBy='%')
	AND (CAST(DateConfirmed AS VARCHAR) = @DateConfirmed OR @DateConfirmed='%')
	AND (CAST(DateSubmitted AS VARCHAR) = @DateSubmitted OR @DateSubmitted='%')
	AND (CAST(DueDate AS VARCHAR) = @DueDate OR @DueDate='%')
	AND (CAST(Seq AS VARCHAR) = @Seq OR @Seq='%')
	AND (SubmittedBy = @SubmittedBy OR @SubmittedBy='%')
----End Select Statement Before Update----



----PrINT number of rows selected----
SET @FirstSelectRows = @@Rowcount
PRINT ''
PRINT 'First Select''s Rows: ' + CAST(@FirstSelectRows as nVARCHAR)
----End PrINT----



----Begin Update Transaction----
BEGIN TRAN Trans1
PRINT '';
PRINT 'Began Trans1'
----End Begin Update Transaction----
	


----Write Update Query String. Put UPDATE Code Under Here!----
Set @ExecString = ('UPDATE dbo.FilingLog
SET ' + 
CASE
	WHEN (@ClearSubmission = 0) 
	THEN (@UpdatingColumnName + ' = CAST(''' + @UpdatingColumnValue + ''' AS ' + @UpdatingColumnType + ')') 
	ELSE ('SubmittedBy = CAST(NULL AS NVARCHAR), DateSubmitted = CAST(NULL AS NVARCHAR)')
	END+'
WHERE 
	(State = ''' + @State + ''' OR ''' + @State + ''' =''%'') 
	AND (Company = ''' + @Company + ''' OR ''' + @Company + ''' =''%'') 
	AND (CONVERT(VARCHAR, Period, 112) = ''' + @Period + ''' OR ''' + @Period + ''' = ''%'')
	AND (ConfirmationNumber = ''' + @ConfirmationNumber + ''' OR ''' + @ConfirmationNumber + ''' =''%'')
	AND (ConfirmedBy = ''' + @ConfirmedBy + ''' OR ''' + @ConfirmedBy + ''' =''%'')
	AND (DateConfirmed = ''' + @DateConfirmed + ''' OR ''' + @DateConfirmed + ''' =''%'')
	AND (DateSubmitted = ''' + @DateSubmitted + ''' OR ''' + @DateSubmitted + ''' =''%'')
	AND (DueDate = ''' + @DueDate + ''' OR ''' + @DueDate + ''' =''%'')
	AND (ID = ''' + @ID + ''' OR ''' + @ID + ''' =''%'')
	AND (Seq = ''' + @Seq + ''' OR ''' + @Seq + ''' =''%'')
	AND (SubmittedBy = ''' + @SubmittedBy + ''' OR ''' + @SubmittedBy + ''' =''%'')');
----End Update Query----



----Execute Update Query String----
IF(@PrintExecString = 1)
BEGIN
	Print('------------------Execution String------------------' + CHAR(13) + @ExecString + CHAR(13) + '-----------------------------------------------------')
END

Exec(@ExecString);
----End Execute Update Query String----



----Set Affected Rows----
SET @AffectedRows = @@Rowcount
PrINT ''
PrINT CAST(@AffectedRows AS VARCHAR) + ' rows affected by the Delete.';
----End Set Affected Rows----



----Select Statement Before Update. Put SELECT Code Under Here!----
SELECT 
	ID,
	Company,
	ConfirmationNumber,
	ConfirmedBy,
	DateConfirmed,	
	DateSubmitted,	
	DueDate,	
	Period,	
	Seq,
	State,
	SubmittedBy
FROM FilingLog
WHERE
	(CAST(ID AS VARCHAR) = @ID OR @ID='%')
	AND (State = @State OR @State='%')
	AND (Company = @Company OR @Company='%')
	AND (CAST(ConfirmationNumber AS VARCHAR) = @ConfirmationNumber OR @ConfirmationNumber='%')
	AND (CONVERT(VARCHAR, Period, 112) = @Period OR @Period = '%')
	AND (CAST(ConfirmedBy AS VARCHAR) = @ConfirmedBy OR @ConfirmedBy='%')
	AND (CAST(DateConfirmed AS VARCHAR) = @DateConfirmed OR @DateConfirmed='%')
	AND (CAST(DateSubmitted AS VARCHAR) = @DateSubmitted OR @DateSubmitted='%')
	AND (CAST(DueDate AS VARCHAR) = @DueDate OR @DueDate='%')
	AND (CAST(Seq AS VARCHAR) = @Seq OR @Seq='%')
	AND (SubmittedBy = @SubmittedBy OR @SubmittedBy='%')
----End Select Statement Before Update----



----PrINT number of rows selected----
SET @SecondSelectRows = @@Rowcount
PRINT ''
PRINT 'Second Select''s Rows: ' + CAST(@SecondSelectRows AS NVARCHAR)
----End PrINT----



----Validation----	
IF @ExpectedAffectedRows = @AffectedRows OR @RequireExpectation = 0
	BEGIN
		IF @RequireExpectation = 0
			BEGIN
				PRINT ''
				PRINT'WARNING: You have no expectations required for the affected rows.'
			END
		IF @Update = 1
			BEGIN
				COMMIT TRAN Trans1;
				PRINT '';
				PRINT 'Commited Trans1!';
				
			END
		ELSE
			BEGIN
				ROLLBACK TRAN Trans1;
				PRINT ''
				PRINT 'Rolled Back! You have Update = 0!'
			END
	END
ELSE
	BEGIN
		ROLLBACK TRAN Trans1;
		PRINT '';
		PRINT 'Rolled Back Trans1! Affected ' + CAST(@AffectedRows as NVARCHAR(10)) + ' rows. Expected ' + Cast(@ExpectedAffectedRows as NVARCHAR(10)) + ' rows to be affected.';
	END
----End Validation----

----Time Elapsed----
SET @t2 = GETDATE();
PRINT ''
PRINT 'TIME ELAPSED: ' + CAST(DATEDIFF(millisecond,@t1,@t2) AS VARCHAR) + ' Milliseconds'
----End Time Elapsed----