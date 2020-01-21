----Kirk's Query Template 1/23/2018----

---------------------------------- ALTER THESE VARIABLES! ----------------------------------

----Set Template variables----
DECLARE 
	@Update BIT = 1,
	@RequireExpectation BIT = 1,
	@ExpectedAffectedRows INT = 557,
	@PrintExecString BIT = 1,
	@UnknownDestination BIT = 0;
----End Set Template variables----

----Set Updating Column----
DECLARE 
	@UpdatingColumnName VARCHAR(40) = 'Exclude',
	@UpdatingColumnType VARCHAR(40) = 'BIT',
	@UpdatingColumnValue VARCHAR(40) = '1'
----End Set Updating Column----
	
----Set Fuel Tax Data----
DECLARE
	@State CHAR(3) ='FL',
	@Company CHAR(4)='KNTC',
	@Period VARCHAR(8)='20190101',
	@BillOfLading VARCHAR(30)='%',
	@PIDX VARCHAR(10)='%',
	@ConsigneeName VARCHAR(40)='%',
	@ConsigneeAddress VARCHAR(20)='%',
	@ConsigneeCity VARCHAR(20)='%',
	@ConsigneeState VARCHAR(20)='%',
	@ConsigneeZip VARCHAR(20)='%',
	@ConsigneeFEIN VARCHAR(20)='%',
	@Exclude VARCHAR(20)='0'
----End Set Fuel Tax Data----

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

----Set Database Name----
Use KAG_Fuel_Tax;
----End Set Database Name----

----Select Statement Before Update. Put SELECT Code Under Here!----
WITH FLDestinationCTE AS (SELECT 
	SD.State
	,SD.Company
	,SD.Period
	,SD.BillOfLading
	,SD.ConsigneeAcct
	,dbo.KAG_fnFloridaDOR(REPLACE(SD.ConsigneeAcct,'.','')) AS FLDestination
	,SD.PIDX
	,SD.fgt_description
	,SD.ConsigneeName
	,SD.ConsigneeAddress
	,SD.ConsigneeCity
	,SD.ConsigneeState
	,SD.ConsigneeZip
	,SD.ConsigneeFEIN
	,SD.ShipperFEIN
	,SD.ShipDate
	,SD.Exclude
FROM vw_ShipmentDataForReturn SD
WHERE 
	(SD.State = @State OR (@UpdatingColumnName = 'State' AND SD.State = @UpdatingColumnValue) OR @State='%')
	AND (Company = @Company OR (@UpdatingColumnName = 'Company' AND Company = @UpdatingColumnValue) OR @Company='%')
	AND (CONVERT(VARCHAR, Period, 112) = @Period OR (@UpdatingColumnName = 'Period' AND Period = Try_Cast(@UpdatingColumnValue AS SMALLDATETIME)) OR @Period = '%')
)

SELECT 
	FL.State
	,FL.Company
	,FL.Period
	,FL.ConsigneeAcct
	,FL.FLDestination
	,FL.BillOfLading
	,FL.PIDX
	,FL.fgt_description
	,FL.ConsigneeName
	,FL.ConsigneeAddress
	,FL.ConsigneeCity
	,FL.ConsigneeState
	,FL.ConsigneeZip
	,FL.ConsigneeFEIN
	,FL.ShipperFEIN
	,FL.ShipDate
	,FL.Exclude
From FLDestinationCTE FL
Where ((@UnknownDestination = 1 AND FLDestination LIKE '%UNKNOWN' AND FLDestination NOT LIKE 'XX%') OR (@UpdatingColumnName = 'FLDestination' AND FLDestination = @UpdatingColumnValue))
AND (PIDX = @PIDX OR (@UpdatingColumnName = 'PIDX' AND PIDX = @UpdatingColumnValue) OR @PIDX='%')
AND (BillOfLading = @BillOfLading OR (@UpdatingColumnName = 'BillOfLading' AND BillOfLading = @UpdatingColumnValue) OR @BillOfLading='%')
AND (ConsigneeAddress = @ConsigneeAddress OR (@UpdatingColumnName = 'ConsigneeAddress' AND ConsigneeAddress = @UpdatingColumnValue) OR @ConsigneeAddress='%')
AND (ConsigneeCity = @ConsigneeCity OR (@UpdatingColumnName = 'ConsigneeCity' AND ConsigneeCity = @UpdatingColumnValue) OR @ConsigneeCity='%')
AND (ConsigneeState = @ConsigneeState OR (@UpdatingColumnName = 'ConsigneeState' AND ConsigneeState = @UpdatingColumnValue) OR @ConsigneeState='%')
AND (ConsigneeZip = @ConsigneeZip OR (@UpdatingColumnName = 'ConsigneeZip' AND ConsigneeZip = @UpdatingColumnValue) OR @ConsigneeZip='%')
AND (ConsigneeFEIN = @ConsigneeFEIN OR (@UpdatingColumnName = 'ConsigneeFEIN' AND ConsigneeFEIN = @UpdatingColumnValue) OR @ConsigneeFEIN='%')
AND (ConsigneeName = @ConsigneeName OR (@UpdatingColumnName = 'ConsigneeName' AND ConsigneeName = @UpdatingColumnValue) OR @ConsigneeName='%')
AND (CAST(Exclude AS VARCHAR) = @Exclude OR (@UpdatingColumnName = 'Exclude' AND CAST(Exclude AS VARCHAR) = @UpdatingColumnValue) OR @Exclude='%')
----End Select Statement Before Update----



----PrINT number of rows selected----
SET @FirstSelectRows = @@Rowcount
PRINT ''
PRINT 'First Select''s Rows: ' + CAST(@FirstSelectRows as nVARCHAR)
----End PrINT----



----Begin Update Transaction----
BEGIN TRAN Transaction1
PRINT '';
PRINT ('Began Transaction1' + CHAR(13));
----End Begin Update Transaction----
	


----Write Update Query String. Put UPDATE Code Under Here!----
Set @ExecString = ('UPDATE vw_ShipmentDataForReturn
SET ' + @UpdatingColumnName + ' = CAST(''' + @UpdatingColumnValue + ''' AS ' + @UpdatingColumnType + ')
WHERE 
	(' + CAST(@UnknownDestination AS nvarchar(1)) + ' = 1 AND dbo.KAG_fnFloridaDOR(REPLACE(ConsigneeAcct,''.'','''')) LIKE ''%UNKNOWN'' AND dbo.KAG_fnFloridaDOR(REPLACE(ConsigneeAcct,''.'','''')) NOT LIKE ''XX%'')
	AND (State = ''' + @State + ''' OR ''' + @State + ''' =''%'') 
	AND (Company = ''' + @Company + ''' OR ''' + @Company + ''' =''%'') 
	AND (CONVERT(VARCHAR, Period, 112) = ''' + @Period + ''' OR ''' + @Period + ''' = ''%'')
	AND (PIDX = ''' + @PIDX + ''' OR ''' + @PIDX + ''' =''%'')
	AND (BillOfLading = ''' + @BillOfLading + ''' OR ''' + @BillOfLading + ''' =''%'')
	AND (ConsigneeAddress = ''' + @ConsigneeAddress + ''' OR ''' + @ConsigneeAddress  + ''' =''%'')
	AND (ConsigneeCity = ''' + @ConsigneeCity + ''' OR ''' + @ConsigneeCity  + ''' =''%'')
	AND (ConsigneeState = ''' + @ConsigneeState + ''' OR ''' + @ConsigneeState  + ''' =''%'')
	AND (ConsigneeZip = ''' + @ConsigneeZip + ''' OR ''' + @ConsigneeZip  + ''' =''%'')
	AND (ConsigneeFEIN = ''' + @ConsigneeFEIN + ''' OR ''' + @ConsigneeFEIN  + ''' =''%'')
	AND (ConsigneeName = ''' + @ConsigneeName + ''' OR ''' + @ConsigneeName  + ''' =''%'')
	AND (CAST(Exclude AS VARCHAR) = ''' + @Exclude + ''' OR ''' + @Exclude  + ''' =''%'')');
----End Write Update Query String----

----Execute Update Query String----
IF (@PrintExecString = 1)
BEGIN
	Print('------------------Execution String------------------' + CHAR(13) + @ExecString + CHAR(13) + '-----------------------------------------------------')
END

Exec(@ExecString);
----End Execute Update Query String----



----Set Affected Rows----
SET @AffectedRows = @@Rowcount
PRINT ''
PRINT CAST(@AffectedRows AS VARCHAR) + ' rows affected by the Update.';
----End Set Affected Rows----



----Select After Update. Put SELECT Code Under Here----
WITH FLDestinationCTE AS (SELECT 
	SD.State
	,SD.Company
	,SD.Period
	,SD.BillOfLading
	,SD.ConsigneeAcct
	,dbo.KAG_fnFloridaDOR(REPLACE(SD.ConsigneeAcct,'.','')) AS FLDestination
	,SD.PIDX
	,SD.fgt_description
	,SD.ConsigneeName
	,SD.ConsigneeAddress
	,SD.ConsigneeCity
	,SD.ConsigneeState
	,SD.ConsigneeZip
	,SD.ConsigneeFEIN
	,SD.ShipperFEIN
	,SD.ShipDate
	,SD.Exclude
FROM vw_ShipmentDataForReturn SD
WHERE 
	(SD.State = @State OR (@UpdatingColumnName = 'State' AND SD.State = @UpdatingColumnValue) OR @State='%')
	AND (Company = @Company OR (@UpdatingColumnName = 'Company' AND Company = @UpdatingColumnValue) OR @Company='%')
	AND (CONVERT(VARCHAR, Period, 112) = @Period OR (@UpdatingColumnName = 'Period' AND Period = Try_Cast(@UpdatingColumnValue AS SMALLDATETIME)) OR @Period = '%')
)

SELECT 
	FL.State
	,FL.Company
	,FL.Period
	,FL.ConsigneeAcct
	,FL.FLDestination
	,FL.BillOfLading
	,FL.PIDX
	,FL.fgt_description
	,FL.ConsigneeName
	,FL.ConsigneeAddress
	,FL.ConsigneeCity
	,FL.ConsigneeState
	,FL.ConsigneeZip
	,FL.ConsigneeFEIN
	,FL.ShipperFEIN
	,FL.ShipDate
	,FL.Exclude
From FLDestinationCTE FL
Where ((@UnknownDestination = 1 AND FLDestination LIKE '%UNKNOWN' AND FLDestination NOT LIKE 'XX%') OR (@UpdatingColumnName = 'FLDestination' AND FLDestination = @UpdatingColumnValue))
AND (PIDX = @PIDX OR (@UpdatingColumnName = 'PIDX' AND PIDX = @UpdatingColumnValue) OR @PIDX='%')
AND (BillOfLading = @BillOfLading OR (@UpdatingColumnName = 'BillOfLading' AND BillOfLading = @UpdatingColumnValue) OR @BillOfLading='%')
AND (ConsigneeAddress = @ConsigneeAddress OR (@UpdatingColumnName = 'ConsigneeAddress' AND ConsigneeAddress = @UpdatingColumnValue) OR @ConsigneeAddress='%')
AND (ConsigneeCity = @ConsigneeCity OR (@UpdatingColumnName = 'ConsigneeCity' AND ConsigneeCity = @UpdatingColumnValue) OR @ConsigneeCity='%')
AND (ConsigneeState = @ConsigneeState OR (@UpdatingColumnName = 'ConsigneeState' AND ConsigneeState = @UpdatingColumnValue) OR @ConsigneeState='%')
AND (ConsigneeZip = @ConsigneeZip OR (@UpdatingColumnName = 'ConsigneeZip' AND ConsigneeZip = @UpdatingColumnValue) OR @ConsigneeZip='%')
AND (ConsigneeFEIN = @ConsigneeFEIN OR (@UpdatingColumnName = 'ConsigneeFEIN' AND ConsigneeFEIN = @UpdatingColumnValue) OR @ConsigneeFEIN='%')
AND (ConsigneeName = @ConsigneeName OR (@UpdatingColumnName = 'ConsigneeName' AND ConsigneeName = @UpdatingColumnValue) OR @ConsigneeName='%')
AND (CAST(Exclude AS VARCHAR) = @Exclude OR (@UpdatingColumnName = 'Exclude' AND CAST(Exclude AS VARCHAR) = @UpdatingColumnValue) OR @Exclude='%')
----End Select Statement After Update----



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
				COMMIT TRAN Transaction1;
				PRINT '';
				PRINT 'Commited Transaction1!';
				
			END
		ELSE
			BEGIN
				ROLLBACK TRAN Transaction1;
				PRINT ''
				PRINT 'Rolled Back Transaction1! You have Update = 0!'
			END
	END
ELSE
	BEGIN
		ROLLBACK TRAN Transaction1;
		PRINT '';
		PRINT 'Rolled Back Transaction1! Affected ' + CAST(@AffectedRows as NVARCHAR(10)) + ' rows. Expected ' + Cast(@ExpectedAffectedRows as NVARCHAR(10)) + ' rows to be affected.';
	END
----End Validation----

----Time Elapsed----
SET @t2 = GETDATE();
PRINT ''
PRINT 'TIME ELAPSED: ' + CAST(DATEDIFF(millisecond,@t1,@t2) AS VARCHAR) + ' Milliseconds'
----End Time Elapsed----