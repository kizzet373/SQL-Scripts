----Kirk's Query Template 1/23/2018----

---------------------------------- ALTER THESE VARIABLES! ----------------------------------

----Set Template variables----
DECLARE 
	@Update BIT = 0,
	@FirstSelectRows INT,
	@SecondSelectRows INT,
	@AffectedRows INT,
	@RequireExpectation BIT = 1,
	@ExpectedAffectedRows INT = 0;
----End Set Template variables----
	
----Set Parameters----
----End Set Parameters----

---------------------------------------------------------------------------------------------



----Declare Other variables----
DECLARE 
	@t1 DATETIME = GETDATE(),
	@t2 DATETIME
----End Declare Other variables----



----Set NOCOUNT----
SET NOCOUNT ON;
----End Set NOCOUNT----



------------------Select Statement Before Update. Put SELECT Code Under Here!-------------------

-------------------------------End Select Statement Before Update-------------------------------



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
	


----------------------------Update Query. Put UPDATE Code Under Here!----------------------------

-----------------------------------------End Update Query----------------------------------------



----Set Affected Rows----
SET @AffectedRows = @@Rowcount
PrINT ''
PrINT CAST(@AffectedRows AS VARCHAR) + ' rows affected by the Update.';
----End Set Affected Rows----



------------------Select Statement Before Update. Put SELECT Code Under Here!-------------------

-------------------------------End Select Statement Before Update-------------------------------



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