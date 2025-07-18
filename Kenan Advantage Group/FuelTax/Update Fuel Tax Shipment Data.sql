----Kirk's Query Template 1/23/2018----

USE KAG_Fuel_Tax;
SET NOCOUNT ON;

---------------------------------- ALTER THESE VARIABLES! ----------------------------------

----Set Execution variables----
DECLARE 
	@CommitUpdate BIT = 1,
	@RequireExpectation BIT = 0,
	@ExpectedAffectedRows INT = 7,
	@PrintExecStrings BIT = 1,
	@UpdateFilingLog BIT = 1;

----Set Updating Column----
DECLARE 
	@UpdatingColumnName VARCHAR(40) = 'PIDX',
	@UpdatingColumnType VARCHAR(40) = 'VARCHAR',
	@UpdatingColumnValue VARCHAR(40) = '145';
	
----Set Fuel Tax Data----
DECLARE
	@State CHAR(3) ='IN',
	@Company CHAR(4)='POCN',
	@Period VARCHAR(8)='20191201',
	@Exclude VARCHAR(20)='0',
	@Ord_hdrnumber VARCHAR(20) = '%',
	@BillOfLading VARCHAR(30)='%',
	@PIDX VARCHAR(10)='142',
	@BilltoName VARCHAR(40)='%',
	@BilltoFEIN VARCHAR(20)='%',
	@IRSTerminalCode VARCHAR(20)='%',
	@ConsigneeName VARCHAR(100)='%',
	@ConsigneeAddress VARCHAR(100)='%',
	@ConsigneeCity VARCHAR(20)='%',
	@ConsigneeState VARCHAR(20)='%',
	@ConsigneeZip VARCHAR(20)='%',
	@ConsigneeFEIN VARCHAR(20)='%',
	@ConsigneeAcct VARCHAR(20)='%',
	@ShipperFEIN VARCHAR(20)='%',
	@SupplierFEIN VARCHAR(20) = '%',
	@FLDestination VARCHAR(20)='%',
	@fgt_description VARCHAR(60)='%',
	@GrossGallons VARCHAR(20)='%';

---------------------------------------------------------------------------------------------



----Declare Other variables----
DECLARE 
	@t1 DATETIME = GETDATE(),
	@t2 DATETIME,
	@FirstSelectRows INT,
	@SecondSelectRows INT,
	@AffectedRows INT,
	@UpdateString VARCHAR(3000) = '',
	@StatusString VARCHAR(1000) = '',
	@SelectString VARCHAR(3000) = '';

----Select Statement Before Update. Put SELECT Code Under Here!----
SET @SelectString +=
'SELECT 
	State
	,Company
	,Period
	,Exclude
	,BillOfLading
	,PIDX
	,BilltoName
	,BilltoFEIN
	,IRSTerminalCode
	,ConsigneeAcct
	'+CASE WHEN @State='FL' THEN ',FLDestination' ELSE '--FLDestination' END +'
	,fgt_description
	,ConsigneeName
	,ConsigneeAddress
	,ConsigneeCity
	,ConsigneeState
	,ConsigneeZip
	,ConsigneeFEIN
	,SupplierFEIN
	,ShipperFEIN
	,ShipDate
	,GrossGallons
FROM ( SELECT'

IF(@State='FL') BEGIN SET @SelectString+=' 
	CASE WHEN('''+@State+'''=''FL'') 
	THEN dbo.KAG_fnFloridaDOR(REPLACE(SD.PIDX,''.'','''')) 
	ELSE '''' END AS FLDestination,' END
SET @SelectString+=' 
	* FROM ShipmentData SD WHERE'
IF(@State<>'%') BEGIN SET @SelectString += ' 
	(SD.State = '''+@State+''' OR ('''+@UpdatingColumnName+''' = ''State'' AND SD.State = '''+@UpdatingColumnValue+''')) AND' END
IF(@Company<>'%') BEGIN SET @SelectString += ' 
	(Company = '''+@Company+''' OR ('''+@UpdatingColumnName+''' = ''Company'' AND Company = '''+@UpdatingColumnValue+''')) AND' END
IF(@Period<>'%') BEGIN SET @SelectString +=' 
	(CONVERT(VARCHAR, Period, 112) = '''+@Period+''' OR ('''+@UpdatingColumnName+''' = ''Period'' AND Period = Try_Cast('''+@UpdatingColumnValue+''' AS SMALLDATETIME)))' END
	
IF (RIGHT(@SelectString,5) = 'WHERE')
	SET @SelectString = LEFT(@SelectString,LEN(@SelectString)-5)
ELSE IF (RIGHT(@SelectString,3) = 'AND')
	SET @SelectString = LEFT(@SelectString,LEN(@SelectString)-3)

SET @SelectString += ' 
	) SD WHERE'
IF(@FLDestination <> '%') BEGIN SET @SelectString += '
	(('''+@FLDestination+''' = ''%'') OR (FLDestination LIKE '''+@FLDestination+'''))) AND' END
IF(@PIDX <> '%') BEGIN SET @SelectString += '
	(PIDX = '''+@PIDX+''') AND' END
IF(@Ord_hdrnumber <> '%') BEGIN SET @SelectString += '
	(Ord_hdrnumber = '''+@Ord_hdrnumber+''') AND' END
IF(@BillOfLading <> '%') BEGIN SET @SelectString += '
	(BillOfLading = '''+@BillOfLading+''') AND' END
IF(@BilltoName <> '%') BEGIN SET @SelectString += '
	(BilltoName = '''+@BilltoName+''') AND' END
IF(@BilltoFEIN <> '%') BEGIN SET @SelectString += '
	(BilltoFEIN = '''+@BilltoFEIN+''') AND' END
IF(@IRSTerminalCode <> '%') BEGIN SET @SelectString += '
	(IRSTerminalCode = '''+@IRSTerminalCode+''') AND' END
IF(@ConsigneeAddress <> '%') BEGIN SET @SelectString += '
	(ConsigneeAddress = '''+@ConsigneeAddress+''') AND' END
IF(@ConsigneeAcct <> '%') BEGIN SET @SelectString += '
	(ConsigneeAcct = '''+@ConsigneeAcct+''') AND' END
IF(@ConsigneeCity <> '%') BEGIN SET @SelectString += '
	(ConsigneeCity = '''+@ConsigneeCity+''') AND' END
IF(@ConsigneeState <> '%') BEGIN SET @SelectString += '
	(ConsigneeState = '''+@ConsigneeState+''') AND' END
IF(@ConsigneeZip <> '%') BEGIN SET @SelectString += '
	(ConsigneeZip = '''+@ConsigneeZip+''') AND' END
IF(@ConsigneeFEIN <> '%') BEGIN SET @SelectString += '
	(ConsigneeFEIN = '''+@ConsigneeFEIN+''') AND' END
IF(@ConsigneeName <> '%') BEGIN SET @SelectString += '
	(ConsigneeName = '''+@ConsigneeName+''') AND' END
IF(@ShipperFEIN <> '%') BEGIN SET @SelectString += '
	(ShipperFEIN = '''+@ShipperFEIN+''') AND' END
IF(@SupplierFEIN <> '%') BEGIN SET @SelectString += '
	(SupplierFEIN = '''+@SupplierFEIN+''') AND' END
IF(@GrossGallons <> '%') BEGIN SET @SelectString += '
	(GrossGallons = '''+@GrossGallons+''') AND' END
IF(@fgt_description <> '%') BEGIN SET @SelectString += '
	(fgt_description = '''+@fgt_description+''') AND' END
IF(@Exclude <> '%') BEGIN SET @SelectString += '
	(CAST(Exclude AS CHAR) = '''+@Exclude+''') AND' END

--Remove Trailing 'AND' or 'WHERE' And Add Updating Values to Select
IF (RIGHT(@SelectString,5) = 'WHERE')
	SET @SelectString = LEFT(@SelectString,LEN(@SelectString)-5)
ELSE IF (RIGHT(@SelectString,3) = 'AND')
BEGIN
	SET @SelectString = LEFT(@SelectString,LEN(@SelectString)-3)
	SET @SelectString += 'OR '+@UpdatingColumnName+' = CAST('''+@UpdatingColumnValue+''' AS '+@UpdatingColumnType+')'
END

SET @SelectString += ' Order By ConsigneeAddress'

----Print Update Query String----
IF (@PrintExecStrings = 1)
BEGIN
	Print('------------------Select String------------------' + CHAR(13) + @SelectString + CHAR(13) + '-----------------------------------------------------')
END

----Executing Select String
EXEC(@SelectString)

----Print number of rows selected----
SET @FirstSelectRows = @@Rowcount
PRINT ''
PRINT 'First Select''s Rows: ' + CAST(@FirstSelectRows as nVARCHAR)

----Begin Update Transaction----
BEGIN TRAN Transaction1
PRINT '';
PRINT ('Began Transaction1' + CHAR(13));
	
----Write Update Query String. Put UPDATE Code Under Here!----
Set @UpdateString = '
UPDATE ShipmentData
SET ' + @UpdatingColumnName + ' = CAST(''' + @UpdatingColumnValue + ''' AS ' + @UpdatingColumnType + ')
FROM ShipmentData SD WHERE'
IF(@State<>'%') BEGIN SET @UpdateString += ' 
	(SD.State = '''+@State+''') AND' END
IF(@Company<>'%') BEGIN SET @UpdateString += ' 
	(SD.Company = '''+@Company+''') AND' END
IF(@Period<>'%') BEGIN SET @UpdateString +=' 
	(CONVERT(VARCHAR, SD.Period, 112) = '''+@Period+''') AND' END
IF(@FLDestination <> '%') BEGIN SET @UpdateString += '
	('''+@FLDestination+''' = ''%'') AND' END
IF(@PIDX <> '%') BEGIN SET @UpdateString += '
	(SD.PIDX = '''+@PIDX+''') AND' END
IF(@Ord_hdrnumber <> '%') BEGIN SET @UpdateString += '
	(SD.Ord_hdrnumber = '''+@Ord_hdrnumber+''') AND' END
IF(@BillOfLading <> '%') BEGIN SET @UpdateString += '
	(SD.BillOfLading = '''+@BillOfLading+''') AND' END
IF(@BilltoName <> '%') BEGIN SET @UpdateString += '
	(SD.BilltoName = '''+@BilltoName+''') AND' END
IF(@BilltoFEIN <> '%') BEGIN SET @UpdateString += '
	(SD.BilltoFEIN = '''+@BilltoFEIN+''') AND' END
IF(@IRSTerminalCode <> '%') BEGIN SET @UpdateString += '
	(SD.IRSTerminalCode = '''+@IRSTerminalCode+''') AND' END
IF(@ConsigneeAddress <> '%') BEGIN SET @UpdateString += '
	(SD.ConsigneeAddress = '''+@ConsigneeAddress+''') AND' END
IF(@ConsigneeAcct <> '%') BEGIN SET @UpdateString += '
	(SD.ConsigneeAcct = '''+@ConsigneeAcct+''') AND' END
IF(@ConsigneeCity <> '%') BEGIN SET @UpdateString += '
	(SD.ConsigneeCity = '''+@ConsigneeCity+''') AND' END
IF(@ConsigneeState <> '%') BEGIN SET @UpdateString += '
	(SD.ConsigneeState = '''+@ConsigneeState+''') AND' END
IF(@ConsigneeZip <> '%') BEGIN SET @UpdateString += '
	(SD.ConsigneeZip = '''+@ConsigneeZip+''') AND' END
IF(@ConsigneeFEIN <> '%') BEGIN SET @UpdateString += '
	(SD.ConsigneeFEIN = '''+@ConsigneeFEIN+''') AND' END
IF(@ConsigneeName <> '%') BEGIN SET @UpdateString += '
	(SD.ConsigneeName = '''+@ConsigneeName+''') AND' END
IF(@SupplierFEIN <> '%') BEGIN SET @UpdateString += '
	(SD.SupplierFEIN = '''+@SupplierFEIN+''') AND' END
IF(@ShipperFEIN <> '%') BEGIN SET @UpdateString += '
	(SD.ShipperFEIN = '''+@ShipperFEIN+''') AND' END
IF(@GrossGallons <> '%') BEGIN SET @UpdateString += '
	(SD.GrossGallons = '''+@GrossGallons+''') AND' END
IF(@fgt_description <> '%') BEGIN SET @UpdateString += '
	(SD.fgt_description = '''+@fgt_description+''') AND' END
IF(@Exclude <> '%') BEGIN SET @UpdateString += '
	(CAST(SD.Exclude AS CHAR) = '''+@Exclude+''')' END

--Remove Trailing 'AND' or 'WHERE'
IF (RIGHT(@UpdateString,5) = 'WHERE')
	SET @UpdateString = LEFT(@UpdateString,LEN(@UpdateString)-5)
ELSE IF (RIGHT(@UpdateString,3) = 'AND')
	SET @UpdateString = LEFT(@UpdateString,LEN(@UpdateString)-3)

----Print Update Query String----
IF (@PrintExecStrings = 1)
BEGIN
	Print('------------------Update String------------------' + CHAR(13) + @UpdateString + CHAR(13) + '-----------------------------------------------------')
END

----Execute Update Query String----
Exec(@UpdateString);

----Set Affected Rows----
SET @AffectedRows = @@Rowcount
PRINT ''
PRINT CAST(@AffectedRows AS VARCHAR) + ' rows affected by the Update.';



----Select Statement After Update----
EXEC(@SelectString)

----Print number of rows selected----
SET @SecondSelectRows = @@Rowcount
PRINT ''
PRINT 'Second Select''s Rows: ' + CAST(@SecondSelectRows AS NVARCHAR)



----Update Filing Log----
IF(@UpdateFilingLog = 1)
BEGIN
	UPDATE dbo.FilingLog
	SET 
		DateConfirmed = null,
		ConfirmedBy = null,
		DateSubmitted = null,
		SubmittedBy = null
	WHERE 
		(State = @State AND @State <> '%') 
		AND (Company = @Company AND @Company <> '%') 
		AND (CONVERT(VARCHAR, Period, 112) = @Period AND @Period <> '%');

Select 
	DateConfirmed, 
	ConfirmedBy,
	DateSubmitted,
	SubmittedBy,
	State, 
	Company, 
	Period
FROM dbo.FilingLog
WHERE
	(State = @State AND @State <> '%') 
	AND (Company = @Company AND @Company <> '%') 
	AND (CONVERT(VARCHAR, Period, 112) = @Period AND @Period <> '%');
END



----Validation----	
IF (@ExpectedAffectedRows = @AffectedRows OR @RequireExpectation = 0)
	BEGIN
		----Expectation Warning----
		IF @RequireExpectation = 0
			BEGIN				
				PRINT 'WARNING: You have no expectations required for the affected rows.'
			END
		----End Expectation Warning----

		IF @UpdatingColumnName = 'FLDestination'
			BEGIN
				ROLLBACK TRAN Transaction1
				SET @StatusString = 'Rolled Back Transaction1! Can''t update ''FLDestination'', because it is a calculated field'
			END
		ELSE IF @CommitUpdate = 0
			BEGIN
				ROLLBACK TRAN Transaction1
				SET @StatusString = 'Rolled Back Transaction1! You have Update = 0!'
			END
		ELSE IF @CommitUpdate = 1
			BEGIN		
				COMMIT TRAN Transaction1
				SET @StatusString = 'Commited Transaction1!'
			END
	END
ELSE
	BEGIN
		ROLLBACK TRAN Transaction1
		SET @StatusString = 'Rolled Back Transaction1! Affected ' + CAST(@AffectedRows as NVARCHAR(10)) + ' rows. Expected ' + Cast(@ExpectedAffectedRows as NVARCHAR(10)) + ' rows to be affected.'
	END

PRINT ''
PRINT @StatusString

----Time Elapsed----
SET @t2 = GETDATE();
PRINT ''
PRINT 'TIME ELAPSED: ' + CAST(DATEDIFF(millisecond,@t1,@t2) AS VARCHAR) + ' Milliseconds'