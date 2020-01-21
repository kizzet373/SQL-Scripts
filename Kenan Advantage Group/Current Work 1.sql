BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

begin tran
BEGIN TRY
     
DECLARE @MESSAGE VARCHAR(100), @ordercount int, @theDiff int;

--MAKE SURE OLD CMP_ID EXISTS
IF NOT EXISTS(SELECT 1 FROM COMPANY WHERE CMP_ACTIVE = 'Y' AND CMP_CONSINGEE = 'Y' AND CMP_ID = @OLDCMP_ID)
BEGIN
	ROLLBACK
	RETURN -2
END

--MAKE SURE NEW CMP_ID DOES NOT ALREADY EXIST
IF EXISTS(SELECT 1 FROM COMPANY WHERE CMP_ID = @NEWCMP_ID)
BEGIN
	ROLLBACK
	RETURN - 3
END

--MAKE SURE OLD COMPANY IS NOT A BILL TO
IF EXISTS(SELECT 1 FROM COMPANY WHERE CMP_ID = @OLDCMP_ID AND cmp_billto = 'Y')
BEGIN
	ROLLBACK
	RETURN -4
END

--INSERT RECORD FOR NEW CMP_ID
INSERT INTO COMPANY
			([CMP_ID]
           ,[CMP_NAME]
           ,[CMP_ADDRESS1]
           ,[CMP_ADDRESS2]
           ,[CMP_CITY]
           ,[CMP_ZIP]
           ,[CMP_PRIMARYPHONE]
           ,[CMP_SECONDARYPHONE]
           ,[CMP_FAXPHONE]
           ,[CMP_SHIPPER]
           ,[CMP_CONSINGEE]
           ,[CMP_BILLTO]
           ,[CMP_OTHERTYPE1]
           ,[CMP_OTHERTYPE2]
           ,[CMP_ARTYPE]
           ,[CMP_INVOICETYPE]
           ,[CMP_REVTYPE1]
           ,[CMP_REVTYPE2]
           ,[CMP_REVTYPE3]
           ,[CMP_REVTYPE4]
           ,[CMP_CURRENCY]
           ,[CMP_ACTIVE]
           ,[CMP_OPENS_MO]
           ,[CMP_CLOSES_MO]
           ,[CMP_CREDITLIMIT]
           ,[CMP_CREDITAVAIL]
           ,[CMP_MILEAGETABLE]
           ,[CMP_MASTERCOMPANY]
           ,[CMP_TERMS]
           ,[CMP_DEFAULTBILLTO]
           ,[CMP_EDI214]
           ,[CMP_EDI210]
           ,[CMP_EDI204]
           ,[CMP_STATE]
           ,[CMP_REGION1]
           ,[CMP_REGION2]
           ,[CMP_REGION3]
           ,[CMP_REGION4]
           ,[CMP_ADDNEWSHIPPER]
           ,[CMP_OPENSUN]
           ,[CMP_OPENMON]
           ,[CMP_OPENTUE]
           ,[CMP_OPENWED]
           ,[CMP_OPENTHU]
           ,[CMP_OPENFRI]
           ,[CMP_OPENSAT]
           ,[CMP_PAYFROM]
           ,[CMP_MAPFILE]
           ,[CMP_CONTACT]
           ,[CMP_DIRECTIONS]
           ,[CTY_NMSTCT]
           ,[CMP_MISC1]
           ,[CMP_MISC2]
           ,[CMP_MISC3]
           ,[CMP_MISC4]
           ,[CMP_MBDAYS]
           ,[CMP_LASTMB]
           ,[CMP_INVCOPIES]
           ,[CMP_TRANSFERTYPE]
           ,[CMP_ALTID]
           ,[CMP_UPDATEDBY]
           ,[CMP_UPDATEDDATE]
           ,[CMP_DEFAULTPRIORITY]
           ,[CMP_INVOICETO]
           ,[CMP_INVFORMAT]
           ,[CMP_INVPRINTTO]
           ,[CMP_CREDITAVAIL_UPDATE]
           ,[CMD_CODE]
           ,[JUNKNOTINUSE]
           ,[CMP_AGEDINVFLAG]
           ,[CMP_MAX_DUNNAGE]
           ,[CMP_ACC_BALANCE]
           ,[CMP_ACC_DT]
           ,[CMP_OPENS_TU]
           ,[CMP_CLOSES_TU]
           ,[CMP_OPENS_WE]
           ,[CMP_CLOSES_WE]
           ,[CMP_OPENS_TH]
           ,[CMP_CLOSES_TH]
           ,[CMP_OPENS_FR]
           ,[CMP_CLOSES_FR]
           ,[CMP_OPENS_SA]
           ,[CMP_CLOSES_SA]
           ,[CMP_OPENS_SU]
           ,[CMP_CLOSES_SU]
           ,[CMP_SUBCOMPANY]
           ,[CMP_CREATEDATE]
           ,[CMP_TAXTABLE1]
           ,[CMP_TAXTABLE2]
           ,[CMP_TAXTABLE3]
           ,[CMP_TAXTABLE4]
           ,[CMP_QUICKENTRY]
           ,[CMP_SLACK_TIME]
           ,[CMP_MAILTO_NAME]
           ,[CMP_MAILTO_ADDRESS1]
           ,[CMP_MAILTO_ADDRESS2]
           ,[CMP_MAILTO_CITY]
           ,[CMP_MAILTO_STATE]
           ,[CMP_MAILTO_ZIP]
           ,[MAILTO_CTY_NMSTCT]
           ,[CMP_LATSECONDS]
           ,[CMP_LONGSECONDS]
           ,[CMP_MAILTO_CRTERM1]
           ,[CMP_MAILTO_CRTERM2]
           ,[CMP_MAILTO_CRTERM3]
           ,[CMP_MBFORMAT]
           ,[CMP_MBGROUP]
           ,[CMP_CENTROIDCITY]
           ,[CMP_CENTROIDCTYNMSTCT]
           ,[CMP_CENTROIDZIP]
           ,[CMP_OOA_MILEAGE]
           ,[CMP_OOA_MILEAGE_STOPS]
           ,[CMP_MAPADDRESS]
           ,[CMP_USESTREETADDR]
           ,[CMP_PRIMARYPHONEEXT]
           ,[CMP_SECONDARYPHONEEXT]
           ,[CMP_PALLETCOUNT]
           ,[CMP_FUELTABLEID]
           ,[GRP_ID]
           ,[CMP_PARENT]
           ,[CMP_COUNTRY]
           ,[CMP_ADDRESS3]
           ,[CMP_SLACKTIME_LATE]
           ,[CMP_GEOLOC]
           ,[CMP_GEOLOC_FORSEARCH]
           ,[CMP_MIN_CHARGE]
           ,[CMP_SERVICE_LOCATION]
           ,[CMP_PSOVERRIDE]
           ,[CMP_MAILTTOFORLINEHAULFLAG]
           ,[CMP_MAILTOTERMSMATCHFLAG]
           ,[CMP_MAX_WEIGHT]
           ,[CMP_MAX_WEIGHTUNITS]
           ,[CMP_IVFORMAT]
           ,[CMP_IVGROUP]
           ,[CMP_TAXID]
           ,[CMP_GP_CLASS]
           ,[DOC_LANGUAGE]
           ,[CMP_IMAGE_ROUTING1]
           ,[CMP_IMAGE_ROUTING2]
           ,[CMP_IMAGE_ROUTING3]
           ,[CMP_PORT]
           ,[CMP_DEPOT]
           ,[CMP_ADDCURRENCYSURCHARGE]
           ,[LTSL_AUTO_ADD_PUL_FLAG]
           ,[LTSL_DEFAULT_PICKUP_EVENT]
           ,[LTSL_DEFAULT_DELIVERY_EVENT]
           ,[CMP_PUPTIMEALLOWANCE]
           ,[CMP_DRPTIMEALLOWANCE]
           ,[CMP_MAXDETMINS]
           ,[CMP_DETCONTACTS]
           ,[CMP_ALLOWDETCHARGES]
           ,[CMP_LATLONGVERIFICATIONS]
           ,[CMP_MAPTUIT_CUSTOMNOTE]
           ,[EXTERNAL_ID]
           ,[EXTERNAL_TYPE]
           ,[CMP_CURRENCYSURCHARGEBASE]
           ,[CMP_TRLCONFIGURATION]
           ,[CMP_SERVICE_LOCATION_QUAL]
           ,[CMP_SERVICE_LOCATION_OWN]
           ,[CMP_SERVICE_LOCATION_RATING]
           ,[CMP_MILESEARCHLEVEL]
           ,[CMP_DET_START]
           ,[CMP_DET_APPLY_IF_LATE]
           ,[CMP_REFTYPE_UNIQUE]
           ,[CMP_PUPALERT]
           ,[CMP_DRPALERT]
           ,[CMP_DET_APPLY_IF_EARLY]
           ,[CMP_SENDDETALERT]
           ,[CMP_LEADTIME]
           ,[CMP_RAILRAMP]
           ,[CMP_ATHOME_LOCATION]
           ,[CMP_THIRDPARTYTYPE1]
           ,[CMP_THIRDPARTYTYPE2]
           ,[CMP_ACEIDTYPE]
           ,[CMP_ACEID]
           ,[CMP_TMLATSECONDS]
           ,[CMP_TMLONGSECONDS]
           ,[CMP_TMDISTANCETOLATLONG]
           ,[CMP_TMLATLONGDATE]
           ,[CMP_DIMOVERRIDE]
           ,[CMP_RBD_FLATRATEOPTION]
           ,[CMP_MINLHADJ]
           ,[CMP_RATEBY]
           ,[CMP_SUPPLIER]
           ,[CMP_RBD_HIGHRATEOPTION]
           ,[CMP_BOOKINGTERMINAL]
           ,[CMP_AVGSTOPMINUTES]
           ,[CMP_ACCOUNTOF]
           ,[CMP_HOUSE_NUMBER]
           ,[CMP_STREET_NAME]
           ,[CMP_MAILTO_COUNTRY]
           ,[CMP_REFNUM]
           ,[CMP_BILLTO_ELIGIBLE_FLAG])
SELECT 
			@NEWCMP_ID
           ,[CMP_NAME]
           ,[CMP_ADDRESS1]
           ,[CMP_ADDRESS2]
           ,[CMP_CITY]
           ,[CMP_ZIP]
           ,[CMP_PRIMARYPHONE]
           ,[CMP_SECONDARYPHONE]
           ,[CMP_FAXPHONE]
           ,[CMP_SHIPPER]
           ,[CMP_CONSINGEE]
           ,[CMP_BILLTO]
           ,[CMP_OTHERTYPE1]
           ,[CMP_OTHERTYPE2]
           ,[CMP_ARTYPE]
           ,[CMP_INVOICETYPE]
           ,[CMP_REVTYPE1]
           ,[CMP_REVTYPE2]
           ,[CMP_REVTYPE3]
           ,[CMP_REVTYPE4]
           ,[CMP_CURRENCY]
           ,[CMP_ACTIVE]
           ,[CMP_OPENS_MO]
           ,[CMP_CLOSES_MO]
           ,[CMP_CREDITLIMIT]
           ,[CMP_CREDITAVAIL]
           ,[CMP_MILEAGETABLE]
           ,[CMP_MASTERCOMPANY]
           ,[CMP_TERMS]
           ,[CMP_DEFAULTBILLTO]
           ,[CMP_EDI214]
           ,[CMP_EDI210]
           ,[CMP_EDI204]
           ,[CMP_STATE]
           ,[CMP_REGION1]
           ,[CMP_REGION2]
           ,[CMP_REGION3]
           ,[CMP_REGION4]
           ,[CMP_ADDNEWSHIPPER]
           ,[CMP_OPENSUN]
           ,[CMP_OPENMON]
           ,[CMP_OPENTUE]
           ,[CMP_OPENWED]
           ,[CMP_OPENTHU]
           ,[CMP_OPENFRI]
           ,[CMP_OPENSAT]
           ,[CMP_PAYFROM]
           ,[CMP_MAPFILE]
           ,[CMP_CONTACT]
           ,[CMP_DIRECTIONS]
           ,[CTY_NMSTCT]
           ,[CMP_MISC1]
           ,[CMP_MISC2]
           ,[CMP_MISC3]
           ,[CMP_MISC4]
           ,[CMP_MBDAYS]
           ,[CMP_LASTMB]
           ,[CMP_INVCOPIES]
           ,[CMP_TRANSFERTYPE]
           ,[CMP_ALTID]
           ,@USER
           ,GETDATE()
           ,[CMP_DEFAULTPRIORITY]
           ,[CMP_INVOICETO]
           ,[CMP_INVFORMAT]
           ,[CMP_INVPRINTTO]
           ,[CMP_CREDITAVAIL_UPDATE]
           ,[CMD_CODE]
           ,[JUNKNOTINUSE]
           ,[CMP_AGEDINVFLAG]
           ,[CMP_MAX_DUNNAGE]
           ,[CMP_ACC_BALANCE]
           ,[CMP_ACC_DT]
           ,[CMP_OPENS_TU]
           ,[CMP_CLOSES_TU]
           ,[CMP_OPENS_WE]
           ,[CMP_CLOSES_WE]
           ,[CMP_OPENS_TH]
           ,[CMP_CLOSES_TH]
           ,[CMP_OPENS_FR]
           ,[CMP_CLOSES_FR]
           ,[CMP_OPENS_SA]
           ,[CMP_CLOSES_SA]
           ,[CMP_OPENS_SU]
           ,[CMP_CLOSES_SU]
           ,[CMP_SUBCOMPANY]
           ,[CMP_CREATEDATE]
           ,[CMP_TAXTABLE1]
           ,[CMP_TAXTABLE2]
           ,[CMP_TAXTABLE3]
           ,[CMP_TAXTABLE4]
           ,[CMP_QUICKENTRY]
           ,[CMP_SLACK_TIME]
           ,[CMP_MAILTO_NAME]
           ,[CMP_MAILTO_ADDRESS1]
           ,[CMP_MAILTO_ADDRESS2]
           ,[CMP_MAILTO_CITY]
           ,[CMP_MAILTO_STATE]
           ,[CMP_MAILTO_ZIP]
           ,[MAILTO_CTY_NMSTCT]
           ,[CMP_LATSECONDS]
           ,[CMP_LONGSECONDS]
           ,[CMP_MAILTO_CRTERM1]
           ,[CMP_MAILTO_CRTERM2]
           ,[CMP_MAILTO_CRTERM3]
           ,[CMP_MBFORMAT]
           ,[CMP_MBGROUP]
           ,[CMP_CENTROIDCITY]
           ,[CMP_CENTROIDCTYNMSTCT]
           ,[CMP_CENTROIDZIP]
           ,[CMP_OOA_MILEAGE]
           ,[CMP_OOA_MILEAGE_STOPS]
           ,[CMP_MAPADDRESS]
           ,[CMP_USESTREETADDR]
           ,[CMP_PRIMARYPHONEEXT]
           ,[CMP_SECONDARYPHONEEXT]
           ,[CMP_PALLETCOUNT]
           ,[CMP_FUELTABLEID]
           ,[GRP_ID]
           ,[CMP_PARENT]
           ,[CMP_COUNTRY]
           ,[CMP_ADDRESS3]
           ,[CMP_SLACKTIME_LATE]
           ,[CMP_GEOLOC]
           ,[CMP_GEOLOC_FORSEARCH]
           ,[CMP_MIN_CHARGE]
           ,[CMP_SERVICE_LOCATION]
           ,[CMP_PSOVERRIDE]
           ,[CMP_MAILTTOFORLINEHAULFLAG]
           ,[CMP_MAILTOTERMSMATCHFLAG]
           ,[CMP_MAX_WEIGHT]
           ,[CMP_MAX_WEIGHTUNITS]
           ,[CMP_IVFORMAT]
           ,[CMP_IVGROUP]
           ,[CMP_TAXID]
           ,[CMP_GP_CLASS]
           ,[DOC_LANGUAGE]
           ,[CMP_IMAGE_ROUTING1]
           ,[CMP_IMAGE_ROUTING2]
           ,[CMP_IMAGE_ROUTING3]
           ,[CMP_PORT]
           ,[CMP_DEPOT]
           ,[CMP_ADDCURRENCYSURCHARGE]
           ,[LTSL_AUTO_ADD_PUL_FLAG]
           ,[LTSL_DEFAULT_PICKUP_EVENT]
           ,[LTSL_DEFAULT_DELIVERY_EVENT]
           ,[CMP_PUPTIMEALLOWANCE]
           ,[CMP_DRPTIMEALLOWANCE]
           ,[CMP_MAXDETMINS]
           ,[CMP_DETCONTACTS]
           ,[CMP_ALLOWDETCHARGES]
           ,[CMP_LATLONGVERIFICATIONS]
           ,[CMP_MAPTUIT_CUSTOMNOTE]
           ,[EXTERNAL_ID]
           ,[EXTERNAL_TYPE]
           ,[CMP_CURRENCYSURCHARGEBASE]
           ,[CMP_TRLCONFIGURATION]
           ,[CMP_SERVICE_LOCATION_QUAL]
           ,[CMP_SERVICE_LOCATION_OWN]
           ,[CMP_SERVICE_LOCATION_RATING]
           ,[CMP_MILESEARCHLEVEL]
           ,[CMP_DET_START]
           ,[CMP_DET_APPLY_IF_LATE]
           ,[CMP_REFTYPE_UNIQUE]
           ,[CMP_PUPALERT]
           ,[CMP_DRPALERT]
           ,[CMP_DET_APPLY_IF_EARLY]
           ,[CMP_SENDDETALERT]
           ,[CMP_LEADTIME]
           ,[CMP_RAILRAMP]
           ,[CMP_ATHOME_LOCATION]
           ,[CMP_THIRDPARTYTYPE1]
           ,[CMP_THIRDPARTYTYPE2]
           ,[CMP_ACEIDTYPE]
           ,[CMP_ACEID]
           ,[CMP_TMLATSECONDS]
           ,[CMP_TMLONGSECONDS]
           ,[CMP_TMDISTANCETOLATLONG]
           ,[CMP_TMLATLONGDATE]
           ,[CMP_DIMOVERRIDE]
           ,[CMP_RBD_FLATRATEOPTION]
           ,[CMP_MINLHADJ]
           ,[CMP_RATEBY]
           ,[CMP_SUPPLIER]
           ,[CMP_RBD_HIGHRATEOPTION]
           ,[CMP_BOOKINGTERMINAL]
           ,[CMP_AVGSTOPMINUTES]
           ,[CMP_ACCOUNTOF]
           ,[CMP_HOUSE_NUMBER]
           ,[CMP_STREET_NAME]
           ,[CMP_MAILTO_COUNTRY]
           ,[CMP_REFNUM]
           ,[CMP_BILLTO_ELIGIBLE_FLAG]
FROM COMPANY
WHERE CMP_ID = @OLDCMP_ID

--UPDATE OLD CMP_ID AFTER NEW ONE IS CREATED
UPDATE COMPANY SET CMP_ACTIVE = 'N', CMP_UPDATEDBY = @USER, CMP_UPDATEDDATE = GETDATE()
WHERE CMP_ID = @OLDCMP_ID

--INSERT NEW RECORD INTO COMPANY_TANKDETAIL
INSERT INTO COMPANY_TANKDETAIL
           ([CMP_ID]
           ,[CMP_TANK_ID]
           ,[CMD_CODE]
           ,[TANKSIZE]
           ,[ULLAGE]
           ,[SHUTDOWNGALLONS]
           ,[PMDELIVERYPERCENTAGE]
           ,[DAILYAVERAGEWEEKSBACK]
           ,[COMPANYTYPE]
           ,[CMD_CLASS]
           ,[FORECAST_BUCKET]
           ,[DIAMETER]
           ,[TANK_CHART])
SELECT 
           @NEWCMP_ID
           ,[CMP_TANK_ID]
           ,[CMD_CODE]
           ,[TANKSIZE]
           ,[ULLAGE]
           ,[SHUTDOWNGALLONS]
           ,[PMDELIVERYPERCENTAGE]
           ,[DAILYAVERAGEWEEKSBACK]
           ,[COMPANYTYPE]
           ,[CMD_CLASS]
           ,[FORECAST_BUCKET]
           ,[DIAMETER]
           ,[TANK_CHART]
FROM COMPANY_TANKDETAIL
WHERE CMP_ID = @OLDCMP_ID

--INSERT NEW RECORD INTO COMPANY_LOCATIONMAP
INSERT INTO COMPANY_LOCATIONMAP
           ([CMP_ID]
           ,[LOCATION_MAP])
SELECT 
			@NEWCMP_ID
           ,[LOCATION_MAP]
FROM COMPANY_LOCATIONMAP
WHERE CMP_ID = @OLDCMP_ID

--INSERT NEW RECORD INTO NOTES WHERE NTB_TABLE = COMPANY

select @ordercount = count(*) from NOTES WHERE NRE_TABLEKEY = @OLDCMP_ID AND NTB_TABLE ='COMPANY'

insert into ident_notes(suser,sdate)
select TOP (@ORDERCOUNT) 'ConsChange', getDate()  FROM NOTES

select @theDiff = (SELECT MAX(notes) FROM IDENT_notes WHERE SUSER = 'ConsChange')-@ORDERCOUNT

INSERT INTO NOTES
           ([NOT_NUMBER]
           ,[NOT_TEXT]
           ,[NOT_TYPE]
           ,[NOT_URGENT]
           ,[NOT_SENTON]
           ,[NOT_SENTBY]
           ,[NOT_EXPIRES]
           ,[NOT_FORWARDEDFROM]
           ,[NTB_TABLE]
           ,[NRE_TABLEKEY]
           ,[NOT_SEQUENCE]
           ,[LAST_UPDATEDBY]
           ,[LAST_UPDATEDATETIME]
           ,[AUTONOTE]
           ,[NOT_TEXT_LARGE]
           ,[NOT_VIEWLEVEL]
           ,[NTB_TABLE_COPIED_FROM]
           ,[NRE_TABLEKEY_COPIED_FROM]
           ,[NOT_NUMBER_COPIED_FROM]
           ,[NOT_TMSEND])
SELECT
			(ROW_NUMBER() OVER (order by NOT_NUMBER)) + @theDiff
           ,[NOT_TEXT]
           ,[NOT_TYPE]
           ,[NOT_URGENT]
           ,[NOT_SENTON]
           ,[NOT_SENTBY]
           ,[NOT_EXPIRES]
           ,[NOT_FORWARDEDFROM]
           ,[NTB_TABLE]
           ,@NEWCMP_ID
           ,[NOT_SEQUENCE]
           ,[LAST_UPDATEDBY]
           ,[LAST_UPDATEDATETIME]
           ,[AUTONOTE]
           ,[NOT_TEXT_LARGE]
           ,[NOT_VIEWLEVEL]
           ,[NTB_TABLE_COPIED_FROM]
           ,[NRE_TABLEKEY_COPIED_FROM]
           ,[NOT_NUMBER_COPIED_FROM]
           ,[NOT_TMSEND]
FROM NOTES
WHERE NTB_TABLE = 'COMPANY' AND NRE_TABLEKEY = @OLDCMP_ID



--UPDATE FUELRELAIONS DELIVERY
UPDATE FUELRELATIONS SET DELIVERY = @NEWCMP_ID
WHERE DELIVERY = @OLDCMP_ID

--TAR_NUMBER
--SELECT TH.TAR_NUMBER, @OLDCMP_ID
--FROM TARIFFROWCOLUMN TRC INNER JOIN TARIFFHEADER TH
--ON TRC.TAR_NUMBER = TH.TAR_NUMBER
--WHERE TRC_ROWCOLUMN = 'R'
--AND TH.TAR_ROWBASIS = 'DCM'
--AND TRC.TRC_MATCHVALUE = @OLDCMP_ID
--UNION
--SELECT DISTINCT TH.TAR_NUMBER, @OLDCMP_ID
--FROM TARIFFROWCOLUMN TRC INNER JOIN TARIFFHEADER TH
--ON TRC.TAR_NUMBER = TH.TAR_NUMBER
--WHERE TRC_ROWCOLUMN = 'R'
--AND TH.TAR_ROWBASIS = 'ROUTE' 
--AND TRC.TRC_MATCHVALUE IN (
--SELECT RTH_ID
--FROM ROUTEDETAIL
--WHERE CMP_ID = @OLDCMP_ID
--)

----ROUTEDETAIL
--SELECT RTH_NAME, @OLDCMP_ID 
--FROM ROUTEDETAIL RD INNER JOIN ROUTEHEADER RH
--ON RH.RTH_ID = RD.RTH_ID
--WHERE RD.CMP_ID = @OLDCMP_ID

--INSERT NEW RECORD INTO LOADREQDEFAULT
INSERT INTO LOADREQDEFAULT
           ([DEF_ID]
           ,[DEF_ID_TYPE]
           ,[DEF_TYPE]
           ,[DEF_NOT]
           ,[DEF_MANDITORY]
           ,[DEF_QUANTITY]
           ,[DEF_EQUIP_TYPE]
           ,[DEF_CMD_ID]
           ,[DEF_REQUIRED]
           ,[DEF_EXPIRE_DATE])
SELECT
           @NEWCMP_ID
           ,[DEF_ID_TYPE]
           ,[DEF_TYPE]
           ,[DEF_NOT]
           ,[DEF_MANDITORY]
           ,[DEF_QUANTITY]
           ,[DEF_EQUIP_TYPE]
           ,[DEF_CMD_ID]
           ,[DEF_REQUIRED]
           ,[DEF_EXPIRE_DATE]
FROM LOADREQDEFAULT
WHERE DEF_ID = @OLDCMP_ID

commit

END TRY
BEGIN CATCH
    rollback
	return -5
END CATCH


--20120307 -copy expirations outside of transaction so that native TMW triggers can run
EXEC kag_expirations_copy @OLDCMP_ID, @NEWCMP_ID

--20090421
INSERT INTO KAG_ConsigneeChangeLog (oldConsigneeCode,newConsigneeID)
VALUES (@OLDCMP_ID,@NEWCMP_ID)

--select @message = 'The consignee ' + @OLDCMP_ID + ' has been changed to ' + @NEWCMP_ID + ' please check Tariffs and Routes'
--THE TO FIELD IN SENDMAIL IS LIMITED TO 100 CHARACTERS
--exec kag_sendmail @from = 'ConsigneeUpdate@thekag.com', @to = 'consigneeChange@thekag.com', @subject = 'Consignee Update', @Body = @message

return 0

END


