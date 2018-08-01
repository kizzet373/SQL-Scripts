--Kirk's Query Template 1/23/2018--

	--Set Variables--
		DECLARE @Production bit = 0,
		@InitialRows int,
		@AffectedRows int,
		@ExpectedAffectedRows int = 0
	--End Set Variables--



	--Select Before Update. Put SELECT Code Under Here!--
	




	--End Select Before Update--



	--Print number of rows selected--
	SET @InitialRows = @@Rowcount
	PRINT 'Initial Rows: ' + CAST(@InitialRows as nvarchar)
	--End Print--
	--Begin Update Transaction--
	BEGIN TRAN Trans1
	PRINT 'Began Trans1'
	--End Begin Update Transaction--
	


	--Update Query. Put UPDATE Code Under Here!--

	



	--End Update Query--
	



	--Set Affected Rows--
	Set @AffectedRows = @@Rowcount
	--End Set Affected Rows--

--Validation--	
IF @ExpectedAffectedRows = @AffectedRows
	BEGIN
		IF @Production = 1
			BEGIN
				COMMIT TRAN Trans1;
				PRINT 'Commited Trans1!'
			END
			ELSE
				BEGIN
					ROLLBACK TRAN Trans1;
					PRINT 'Rolled Back! Not in Production!'
				END
	END
ELSE
	BEGIN
		ROLLBACK TRAN Trans1;
		PRINT 'Rolled Back! Affected ' + CAST(@AffectedRows as nvarchar(10)) + ' rows. Expected ' + Cast(@ExpectedAffectedRows as nvarchar(10)) + ' rows to be affected.'
	END
--End Validation--