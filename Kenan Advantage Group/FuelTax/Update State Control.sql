----Kirk's Query Template 1/23/2018----

---------------------------------- ALTER THESE VARIABLES! ----------------------------------

----Set Template variables----
DECLARE 
	@Update BIT = 1,
	@RequireExpectation BIT = 1,
	@ExpectedAffectedRows INT = 1;
----End Set Template variables----

----Set Updating Column----
DECLARE 
	@UpdatingColumnName VARCHAR(40) = 'DateSubmitted',
	@UpdatingColumnType VARCHAR(40) = 'varchar',
	@UpdatingColumnValue VARCHAR(40) = null
----End Set Updating Column----
	
----Set File Log Data----
DECLARE
	@Company varchar(25) = 'AVTK',
	@Period varchar(25) = '20181201',
	@State varchar(25) = 'OH',
	@ID varchar(25) = '%',	
	@ConfirmationNumber varchar(25) = '%',
	@ConfirmedBy varchar(20) = '%',
	@DateConfirmed varchar(25) = '%',	
	@DateSubmitted varchar(25) = '%',	
	@DueDate varchar(25) = '%',			
	@Seq varchar(25) = '%',	
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
	@UpdatingColumnValue2 VARCHAR(40) = ISNULL(@UpdatingColumnValue, 'NULL');
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
	(CAST(ID AS VARCHAR) = @ID OR @ID='%' OR (@UpdatingColumnName = 'ID' AND CAST(ID AS VARCHAR) = @UpdatingColumnValue))
	AND (State = @State OR @State='%' OR (@UpdatingColumnName = 'State' AND CAST(State AS VARCHAR) = @UpdatingColumnValue))
	AND (Company = @Company OR @Company='%' OR (@UpdatingColumnName = 'Company' AND CAST(Company AS VARCHAR) = @UpdatingColumnValue))
	AND (CAST(ConfirmationNumber AS VARCHAR) = @ConfirmationNumber OR @ConfirmationNumber='%' OR (@UpdatingColumnName = 'ConfirmationNumber' AND CAST(ConfirmationNumber AS VARCHAR) = @UpdatingColumnValue))
	AND (CONVERT(VARCHAR, Period, 112) = @Period OR @Period = '%' OR (@UpdatingColumnName = 'Period' AND CAST(Period AS VARCHAR) = @UpdatingColumnValue))
	AND (CAST(ConfirmedBy AS VARCHAR) = @ConfirmedBy OR @ConfirmedBy='%' OR (@UpdatingColumnName = 'ConfirmedBy' AND CAST(ConfirmedBy AS VARCHAR) = @UpdatingColumnValue))
	AND (CAST(DateConfirmed AS VARCHAR) = @DateConfirmed OR @DateConfirmed='%' OR (@UpdatingColumnName = 'DateConfirmed' AND CAST(DateConfirmed AS VARCHAR) = @UpdatingColumnValue))
	AND (CAST(DateSubmitted AS VARCHAR) = @DateSubmitted OR @DateSubmitted='%' OR (@UpdatingColumnName = 'DateSubmitted' AND CAST(DateSubmitted AS VARCHAR) = @UpdatingColumnValue))
	AND (CAST(DueDate AS VARCHAR) = @DueDate OR @DueDate='%' OR (@UpdatingColumnName = 'DueDate' AND CAST(DueDate AS VARCHAR) = @UpdatingColumnValue))
	AND (CAST(Seq AS VARCHAR) = @Seq OR @Seq='%' OR (@UpdatingColumnName = 'Seq' AND CAST(Seq AS VARCHAR) = @UpdatingColumnValue))
	AND (SubmittedBy = @SubmittedBy OR @SubmittedBy='%' OR (@UpdatingColumnName = 'SubmittedBy' AND CAST(SubmittedBy AS VARCHAR) = @UpdatingColumnValue))
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
	


----Update Query. Put UPDATE Code Under Here!----
EXEC('UPDATE dbo.FilingLog
SET ' + @UpdatingColumnName + ' = CAST(NULLIF(''' + @UpdatingColumnValue2 + ''', ''NULL'') AS '  + @UpdatingColumnType + ')
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



----Set Affected Rows----
SET @AffectedRows = @@Rowcount
PrINT ''
PrINT CAST(@AffectedRows AS VARCHAR) + ' rows affected by the Update.';
----End Set Affected Rows----



----Select After Update. Put SELECT Code Under Here----
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
	(CAST(ID AS VARCHAR) = @ID OR @ID='%' OR (@UpdatingColumnName = 'ID' AND CAST(ID AS VARCHAR) = @UpdatingColumnValue))
	AND (State = @State OR @State='%' OR (@UpdatingColumnName = 'State' AND CAST(State AS VARCHAR) = @UpdatingColumnValue))
	AND (Company = @Company OR @Company='%' OR (@UpdatingColumnName = 'Company' AND CAST(Company AS VARCHAR) = @UpdatingColumnValue))
	AND (CAST(ConfirmationNumber AS VARCHAR) = @ConfirmationNumber OR @ConfirmationNumber='%' OR (@UpdatingColumnName = 'ConfirmationNumber' AND CAST(ConfirmationNumber AS VARCHAR) = @UpdatingColumnValue))
	AND (CONVERT(VARCHAR, Period, 112) = @Period OR @Period = '%' OR (@UpdatingColumnName = 'Period' AND CAST(Period AS VARCHAR) = @UpdatingColumnValue))
	AND (CAST(ConfirmedBy AS VARCHAR) = @ConfirmedBy OR @ConfirmedBy='%' OR (@UpdatingColumnName = 'ConfirmedBy' AND CAST(ConfirmedBy AS VARCHAR) = @UpdatingColumnValue))
	AND (CAST(DateConfirmed AS VARCHAR) = @DateConfirmed OR @DateConfirmed='%' OR (@UpdatingColumnName = 'DateConfirmed' AND CAST(DateConfirmed AS VARCHAR) = @UpdatingColumnValue))
	AND (CAST(DateSubmitted AS VARCHAR) = @DateSubmitted OR @DateSubmitted='%' OR (@UpdatingColumnName = 'DateSubmitted' AND CAST(DateSubmitted AS VARCHAR) = @UpdatingColumnValue))
	AND (CAST(DueDate AS VARCHAR) = @DueDate OR @DueDate='%' OR (@UpdatingColumnName = 'DueDate' AND CAST(DueDate AS VARCHAR) = @UpdatingColumnValue))
	AND (CAST(Seq AS VARCHAR) = @Seq OR @Seq='%' OR (@UpdatingColumnName = 'Seq' AND CAST(Seq AS VARCHAR) = @UpdatingColumnValue))
	AND (SubmittedBy = @SubmittedBy OR @SubmittedBy='%' OR (@UpdatingColumnName = 'SubmittedBy' AND CAST(SubmittedBy AS VARCHAR) = @UpdatingColumnValue))
----End Select After Update----



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