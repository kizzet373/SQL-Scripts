DECLARE
@Billto VARCHAR(MAX) = 'COSTCO,KAGLOGCO,KAGLOGCD,COSTDED,COSTCCAN,COSTEMSV,KAGLOGP,PENSKE,7-11DEAL',
@ExternalCarrier VARCHAR(MAX) = 'CSCQ,DUPR,CHFW,FDYS,NQPS,PKIN,UNPO,SOAQ,CWCL,ALQI,PFDA,BRDW,EAGN,EETF,HWOC,RGNO,SFMK,TPHV,UOGA,OLWT,MGLK,BALQ,MEEV,MILE,ATJK,TAYR,MHXQ,WBUL,CLTT,PHLD,RDKR,WMTL,PGSS,VPPS,RNRP,FSOR,TRJQ,THJL,WDJM,RASK,PWKC,ISTC,TPNG,MCMT,FLRT,QWDS,BPLS,ALTK,CFAC,BKDK,CRWP,FTYK,GRPV,LIFT,RNHO,SOHC,VETA,WLCQ,TJFT,WYTQ,ASPC,BAYY,CNOV,CPLD,DPUS,FICK,FYST,PTMN,GNGR,GNNI,HUJC,LCSR,LIQD,MVCV,ODLO,PTVO,RFRV,RVBQ,SQOL,TPTR,XPER,GRTT,COCY,PTAL,VJTS,MYPJ',
@HoursBehind INT = -9000,
@HoursAhead INT = 24

SET NOCOUNT ON;

DECLARE @ord_dest_lastestdateStart DATETIME = DATEADD(HOUR,@HoursBehind,GETDATE())
DECLARE @ord_dest_lastestdateEnd DATETIME = DATEADD(HOUR,@HoursAhead,GETDATE()) 

IF OBJECT_ID('tempdb..#OrderData') IS NOT NULL DROP TABLE #OrderData
IF OBJECT_ID('tempdb..#StopData') IS NOT NULL DROP TABLE #StopData
IF OBJECT_ID('tempdb..#CallDisStuff') IS NOT NULL DROP TABLE #CallDisStuff
IF OBJECT_ID('tempdb..#AllowableBillto') IS NOT NULL DROP TABLE #AllowableBillto
IF OBJECT_ID('tempdb..#AllowableCarrier') IS NOT NULL DROP TABLE #AllowableCarrier

/* Testing Variables
DECLARE @Billto VARCHAR(MAX);
DECLARE @ExternalCarrier VARCHAR(MAX);

SET @Billto = '7-ELEVE,KAGLOGCO,KAGLOGCO,MACSCON,MACSCON,KAGLOGCD';
SET @ExternalCarrier = 'CSCQ,DUPR,CHFW,CWCL';

IF OBJECT_ID('tempdb..#OrderData') IS NOT NULL DROP TABLE #OrderData
IF OBJECT_ID('tempdb..#StopData') IS NOT NULL DROP TABLE #StopData
IF OBJECT_ID('tempdb..#CallDisStuff') IS NOT NULL DROP TABLE #CallDisStuff
IF OBJECT_ID('tempdb..#AllowableBillto') IS NOT NULL DROP TABLE #AllowableBillto
IF OBJECT_ID('tempdb..#AllowableCarrier') IS NOT NULL DROP TABLE #AllowableCarrier
--IF OBJECT_ID('tempdb..#refnumberunfiltered') IS NOT NULL DROP TABLE #refnumberunfiltered
--EXEC [KAG_ETA_GetOrderData_BETA] @Billto = 'KAGLOG7S,KAGLOG7D,7-11DEAL,7-11DLNE,COSTCO,KAGLOGCO,KAGLOGCD,PENSKE,PENSKEGE,PNSK055,COSTDED',  @ExternalCarrier ='', @HoursBehind = -12, @HoursAhead = 24
--*/


CREATE TABLE #AllowableBillto (Billto VARCHAR(8))
DECLARE @BillToXML XML;
SELECT @BillToXML = CAST('<d>' + REPLACE(@Billto, ',', '</d><d>') + '</d>' AS XML);
INSERT INTO #AllowableBillto(Billto)
SELECT DISTINCT T.split.value('.', 'VARCHAR(8)') AS Data
FROM @BillToXML.nodes('/d') T (split)

CREATE TABLE #AllowableCarrier (Scac VARCHAR(8))
DECLARE @ScacXML XML;
SELECT @ScacXML = CAST('<d>' + REPLACE(@ExternalCarrier, ',', '</d><d>') + '</d>' AS XML);
INSERT INTO #AllowableCarrier(Scac)
SELECT DISTINCT T.split.value('.', 'VARCHAR(8)') AS Data
FROM @ScacXML.nodes('/d') T (split)
UNION ALL SELECT 'UNKNOWN' AS Data

SELECT    
			oh.ord_carrier,
			oh.ord_status,
			oh.ord_startdate,
			oh.ord_dest_earliestdate,
			oh.ord_dest_latestdate,
			 oh.ord_completiondate,			
              oh.ord_hdrnumber AS OrderNumber,
              'FDG' AS Instance,
              ISNULL(NULLIF(oh.ord_carrier, 'UNKNOWN'), oh.ord_revtype1) AS Carrier,
              oh.ord_billto AS BillTo,
              oh.ord_consignee AS Consignee, 
              CASE WHEN oh.ord_startdate >= oh.ord_dest_earliestdate THEN oh.ord_startdate ELSE oh.ord_dest_earliestdate END  AS EarliestAppointmentTime,
		CASE WHEN oh.ord_completiondate >= oh.ord_dest_latestdate THEN oh.ord_completiondate ELSE oh.ord_dest_latestdate END AS LatestAppointmentTime,	
              NULLIF(oh.ord_tractor, 'UNKNOWN') AS TractorNumber,           
              NULLIF(oh.ord_trailer, 'UNKNOWN') AS TrailerNumber,
              oh.ord_revtype2 RevType2,
              CASE WHEN oh.ord_carrier <> 'UNKNOWN' THEN 0 ELSE NULL END AS SendLocationUpdates --default all external to false, and we will update the internal in a further statement
       INTO #OrderData
       FROM [TMW_FUEL_PROD.DB.THEKAG.COM].TMW_Prod.dbo.orderheader oh WITH (NOLOCK) 
       JOIN #AllowableBillto abt ON abt.Billto = oh.ord_billto       
       LEFT JOIN #AllowableCarrier aec ON aec.Scac = oh.ord_carrier       
    WHERE (oh.ord_dest_latestdate BETWEEN @ord_dest_lastestdateStart AND @ord_dest_lastestdateEnd -- ZJN 20190612 Added variables
	  OR oh.ord_completiondate BETWEEN @ord_dest_lastestdateStart AND @ord_dest_lastestdateEnd
	  OR oh.ord_startdate BETWEEN @ord_dest_lastestdateStart AND @ord_dest_lastestdateEnd
	  )
       AND
       (
              (ISNULL(oh.ord_carrier,'UNKNOWN') = 'UNKNOWN' AND oh.ord_status IN ('AVL','PLN','DSP','STD','CAN','CMP')) -- ZJN 20190612 Added ISNULL and left join
              OR
              (oh.ord_carrier <> 'UNKNOWN' AND oh.ord_status IN ('AVL','PLN','DSP','STD','CAN','CMP')) 
       )      
	  AND oh.ord_hdrnumber in ('37678753')


-- determine if order should be tracking + update tractor 
-- basically for this, we will just check:
-- is there an active leg (lgh_outstatus = STD) on the order?
-- for fdg, we also only want N+F legs so preloads don't start tracking and "cause a lot of noise"
UPDATE #OrderData 
SET TractorNumber = al.tractor,
SendLocationUpdates = 1
FROM 
(
SELECT NULLIF(l.lgh_tractor,'UNKNOWN') tractor, l.ord_hdrnumber ordernum
FROM [TMW_FUEL_PROD.DB.THEKAG.COM].TMW_PROD.dbo.legheader l WITH (NOLOCK)
WHERE l.lgh_outstatus = 'STD'
AND l.lgh_split_flag IN ('N', 'F')
AND l.ord_hdrnumber <> 0
AND EXISTS --need to ensure that a pickup stop has been arrived at
(
    SELECT TOP (1)
           1
    FROM [TMW_FUEL_PROD.DB.THEKAG.COM].TMW_PROD.dbo.stops istp WITH (NOLOCK)
    WHERE istp.mov_number = l.mov_number --join on move so we can use the pickup arrival from the preload leg
          AND
          (
              (
                  istp.stp_type IN ( 'PUP' ) --pickup stop
                  AND istp.stp_status = 'DNE' --has been "arrived" at
              )
             
          )
)
) al
WHERE OrderNumber = al.ordernum AND SendLocationUpdates IS NULL


-- select order information
SELECT DISTINCT
OrderNumber
,ord_status
,Instance 
,Carrier 
,BillTo
,Consignee
,EarliestAppointmentTime
,ord_startdate
,LatestAppointmentTime 
,ord_dest_latestdate
,ord_completiondate
,TractorNumber
,TrailerNumber 
,CAST(ISNULL(SendLocationUpdates,0) AS BIT) SendLocationUpdates
FROM #OrderData
order by ord_status


---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
------------------------------------IMPORT STAGING-------------------------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------



IF OBJECT_ID('tempdb..#MpCarriers') IS NOT NULL
		DROP TABLE #MpCarriers

	IF OBJECT_ID('tempdb..#MpCustomers') IS NOT NULL
		DROP TABLE #MpCustomers

	IF OBJECT_ID('tempdb..#MissingOrders') IS NOT NULL
		DROP TABLE #MissingOrders

CREATE TABLE #MpCarriers (
		ProfileId INT
		,CarrierId INT
		,Name VARCHAR(50)
		,SCAC VARCHAR(8)
		,EffectiveDate DATETIME
		,ProfileActive BIT
		,CarrierActive BIT
		)

	CREATE TABLE #MpCustomers (
		ProfileId INT
		,IntegrationType VARCHAR(8)
		,MasterCustomer INT
		,MasterName VARCHAR(50)
		,CustomerMpId INT
		,Billto VARCHAR(8)
		,CustomerEmail VARCHAR(MAX)
		,BilltoEmail VARCHAR(MAX)
		,Email VARCHAR(MAX)
		,Instance VARCHAR(3)
		,EffectiveDate DATETIME
		)

	INSERT INTO #MpCarriers (
		ProfileId
		,CarrierId
		,Name
		,SCAC
		,EffectiveDate
		,ProfileActive
		,CarrierActive
		)
	SELECT pm.Id
		,cm.Id
		,cm.Name
		,cm.Scac
		,cm.EffectiveDate
		,pm.Active AS ProfileActive
		,cm.Active AS CarrierActive
	FROM mp.ProfileMaster pm
	INNER JOIN mp.ProfileCarriers pc
		ON pc.ProfileId = pm.Id
	INNER JOIN mp.CarrierMaster cm
		ON pc.CarrierId = cm.Id

	INSERT INTO #MpCustomers (
		ProfileId
		,IntegrationType
		,MasterCustomer
		,MasterName
		,CustomerMpId
		,Billto
		,CustomerEmail
		,BilltoEmail
		,Email
		,Instance
		,EffectiveDate
		)
	SELECT pm.Id ProfileId
		,pm.IntegrationType
		,cm.Id MasterCustomer
		,cm.Name
		,cm.MpId
		,btc.BillTo
		,STUFF((
				SELECT DISTINCT ',' + NULLIF(c.Email, '')
				FROM mp.CustomerMaster c
				WHERE c.Id = cm.Id
				FOR XML PATH('')
				), 1, 1, '') AS CustomerEmail
		,STUFF((
				SELECT DISTINCT ',' + NULLIF(b.Email, '')
				FROM mp.BilltoConfigurations b
				WHERE btc.Id = b.Id
				FOR XML PATH('')
				), 1, 1, '') AS BilltoEmail
		,NULL
		,btc.Instance AS Instance
		,cm.EffectiveDate AS EffectiveDate
	FROM mp.ProfileMaster pm
	LEFT JOIN mp.CustomerMaster cm
		ON pm.Id = cm.ProfileId
	LEFT JOIN mp.BilltoConfigurations btc
		ON btc.CustomerId = cm.Id
	WHERE pm.Active = 1
		AND cm.Active = 1
		AND btc.Active = 1

	UPDATE #MpCustomers
	SET Email = CASE 
			WHEN CustomerEmail IS NULL
				THEN BilltoEmail
			WHEN CustomerEmail IS NOT NULL
				AND BilltoEmail IS NOT NULL
				THEN CONCAT (
						CustomerEmail
						,','
						,BilltoEmail
						)
			WHEN CustomerEmail IS NOT NULL
				AND BilltoEmail IS NULL
				THEN CustomerEmail
			END


SELECT	os.OrderNumber
		,cus.ProfileId AS CustomerProfId
		,car.ProfileId AS CarrierProfId
		,cus.IntegrationType
		,car.CarrierId
		,os.Carrier AS StagingCarrier
		,cus.MasterCustomer
		,'?' AS STATUS		
		,NULL AS MacroPointId
		,NULL AS TrackingRequest
		,car.SCAC Carrier
		,car.Name
		,cus.MasterName
		,cus.CustomerMpId
		,cus.BillTo AS CustomerBillTo
		,os.BillTo AS StagingBillTo
		,os.Consignee
		,os.EarliestAppointmentTime
		,os.LatestAppointmentTime
		,car.EffectiveDate AS CarrierEffective
		,cus.EffectiveDate AS CustomerEffective
		,os.Instance
		,os.TractorNumber
		,os.TrailerNumber
		,cus.Email
		,os.SendLocationUpdates
		,NULL LastLat
		,NULL LastLong
		,NULL LastEventUtc
		,NULL DateLastSent
	INTO #MissingOrders
	FROM #OrderData os
	Left JOIN #MpCarriers car
		ON car.SCAC = os.Carrier AND car.ProfileId <> 2
	Left JOIN #MpCustomers cus
		ON cus.Billto = os.BillTo
			AND cus.Instance = os.Instance
	--WHERE car.ProfileId = cus.ProfileId
		--AND os.LatestAppointmentTime > car.EffectiveDate
		--AND os.LatestAppointmentTime > cus.EffectiveDate
order by stagingCarrier

SELECT 
	mo.OrderNumber,
	mo.StagingCarrier AS OrderCarrier,
	mo.CarrierId AS OrderCarrierId,
	mp.CarrierId AS ProfileCarrierId,
	mp.ProfileId AS ProfileMasterId,
	mp.ProfileActive,
	mp.CarrierActive,
	mp.EffectiveDate,
	mo.CustomerProfId
FROM #MissingOrders mo
LEFT JOIN #MpCarriers mp
ON mo.CarrierId = mp.CarrierId AND mp.ProfileId <> 2
ORDER BY CarrierActive, EffectiveDate DESC, StagingCarrier

DROP TABLE #OrderData
DROP TABLE #AllowableBillto
DROP TABLE #AllowableCarrier
DROP TABLE #MissingOrders
DROP TABLE #MpCarriers
DROP TABLE #MpCustomers

