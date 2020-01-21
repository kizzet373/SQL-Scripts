----Kirk's Query Template 1/23/2018----

USE KAG_Fuel_Tax;

---------------------------------- ALTER THESE VARIABLES! ----------------------------------

----Set Execution variables----
DECLARE 
	@CommitUpdate BIT = 1,
	@RequireExpectation BIT = 0,
	@ExpectedAffectedRows INT = 7,
	@PrintExecString BIT = 1,
	@UpdateFilingLog BIT = 1,
	@Update BIT =  1;
----End Execution Template variables----
	
----Set Fuel Tax Data----
DECLARE
	@Company CHAR(4)='KLEQ',
	@Period VARCHAR(8)='20191101',
	@ConsigneeFEINList VARCHAR(1000)=
	'113828503,
	113828503,
	201246997,
	202993657,
	205009944,
	205521964,
	237451981,
	263594207,
	361246841,
	362884570,
	364035719,
	396075902,
	371207239,
	382965343,
	389980149,
	390992285,
	391061429,
	391179060,
	391419495,
	391509993,
	391866055,
	392018537,
	392042136,
	393429638,
	461678509,
	471583780,
	475628099,
	501665516,
	571245910,
	581550633,
	731605730,
	392667470,
	969325212,
	822541941,
	814489622,
	969325212', --BuyerFEIN--
	@ShipperFEINList VARCHAR(1000)=
	'200387389,
	760380015', --ConsignorFEIN--
	@SupplierFEINList VARCHAR(1000) = 
	'200387389,
	264521178,
	570483314,
	811141412', --PositionHolderFEIN--
	@TerminalCodeList VARCHAR(1000) =
	'202759136'

----Declare Other variables----
DECLARE 
	@t1 DATETIME = GETDATE(),
	@t2 DATETIME,
	@FirstSelectRows INT,
	@SecondSelectRows INT,
	@AffectedRows INT,
	@StatusString VARCHAR(1000);

SET NOCOUNT ON;
Use KAG_Fuel_Tax;

----Set List Variables----
DECLARE @ConsigneeFEINList2 VARCHAR(1000) = CONCAT('(''',REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@ConsigneeFEINList,',',''','''),CHAR(9),''),CHAR(13),''),CHAR(10),''),',',(','+CHAR(13))),''')'),
	@ShipperFEINList2 VARCHAR(1000) = CONCAT('(''',REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@ShipperFEINList,',',''','''),CHAR(9),''),CHAR(13),''),CHAR(10),''),',',(','+CHAR(13))),''')'),
	@SupplierFEINList2 VARCHAR(1000) = CONCAT('(''',REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@SupplierFEINList,',',''','''),CHAR(9),''),CHAR(13),''),CHAR(10),''),',',(','+CHAR(13))),''')'),
	@TerminalCodeList2 VARCHAR(1000) = CONCAT('(''',REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@TerminalCodeList,',',''','''),CHAR(9),''),CHAR(13),''),CHAR(10),''),',',(','+CHAR(13))),''')')
----End Set List Variables----


Declare @SelectStatement varchar(3000)=
'SELECT 
	State
	,Company
	,Period
	,BillOfLading
	,PIDX
	,SupplierFEIN
	,ConsigneeName
	,ConsigneeFEIN
	,ShipperFEIN
	,IRSTerminalCode
	,Exclude
FROM (
	SELECT *
	FROM ShipmentData SD
	WHERE 
	State = ''WI''
	AND (Company = ''' + @Company + ''' OR '''+@Company+'''=''%'')
	AND (Period = ''' + @Period + ''' OR ''' + @Period + ''' = ''%'')
) SD2
WHERE
	(ConsigneeFEIN IN '+ @ConsigneeFEINList2 + ')
	OR (ShipperFEIN IN '+ @ShipperFEINList2 +')
	OR (SupplierFEIN IN '+ @SupplierFEINList2 +')
	OR (IRSTerminalCode IN '+@TerminalCodeList2+')'


EXEC(@SelectStatement)

IF(@Update = 1)
BEGIN
	BEGIN TRAN Transaction1
	
	----Write Update Query String. Put UPDATE Code Under Here!----
	DECLARE @UpdateString VARCHAR(3000) = ('
	UPDATE 
		ShipmentData
	SET EXCLUDE = 1
	WHERE 
		State = ''WI''
		AND (Company = ''' + @Company + ''' OR '''+@Company+'''=''%'')
		AND (Period = ''' + @Period + ''' OR ''' + @Period + ''' = ''%'')
		AND (
			(ConsigneeFEIN IN '+@ConsigneeFEINList2+')
			OR (ShipperFein IN '+@ShipperFEINList2+')
			OR (SupplierFEIN IN '+@SupplierFEINList2+')
			OR (IRSTerminalCode IN '+@TerminalCodeList2+')
		)')

	EXEC(@UpdateString)

	EXEC(@SelectStatement)

	COMMIT TRAN

	----Update Filing Log----
	IF(@UpdateFilingLog = 1)
	BEGIN
		UPDATE dbo.FilingLog
		SET 
			DateSubmitted = null,
			SubmittedBy = null,
			DateConfirmed = null,
			ConfirmedBy = null
		WHERE 
			(State = 'WI') 
			AND (Company = @Company AND @Company <> '%') 
			AND (CONVERT(VARCHAR, Period, 112) = @Period AND @Period <> '%');

		Select 
			DateSubmitted, 
			SubmittedBy,
			DateConfirmed, 
			ConfirmedBy,
			State, 
			Company, 
			Period
		FROM dbo.FilingLog
		WHERE
			(State = 'WI')
			AND (Company = @Company AND @Company <> '%') 
			AND (CONVERT(VARCHAR, Period, 112) = @Period AND @Period <> '%');
	END
END