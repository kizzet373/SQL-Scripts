DECLARE @TMWUserName VARCHAR(32) = 'Kibrown'

SELECT o.ord_hdrnumber AS OrderNumber, o.ord_revtype2 AS OrderTerminal, o.ord_revtype3 AS OrderFleet, usr.TMWUserName AS UserName, CASE WHEN frt.RelId IS NULL THEN 'N' ELSE 'Y' END AS HasTerminalAcess, CASE WHEN frf.RelId IS NULL THEN 'N' ELSE 'Y' END AS HasFleetAcess, usr.DateCreated
FROM dbo.orderheader o WITH(NOLOCK)
     JOIN(SELECT DISTINCT TMWUserName, KeyValue, DateCreated
          FROM dbo.KAG_LockTokenLog WITH(NOLOCK)
          WHERE KeyTable='orderheader' AND DateCreated BETWEEN DATEADD(DAY, -7, GETDATE())AND GETDATE()) AS usr ON usr.KeyValue=o.ord_number
     LEFT JOIN dbo.FuelRelations frt WITH(NOLOCK) ON frt.Terminal=o.ord_revtype2 AND frt.RelType='USRTERM' AND usr.TMWUserName=LTRIM(RTRIM(frt.StringValue))
     LEFT JOIN dbo.FuelRelations frf WITH(NOLOCK) ON frf.Terminal=o.ord_revtype3 AND frf.RelType='USRFLEET' AND usr.TMWUserName=LTRIM(RTRIM(frf.StringValue))
WHERE usr.TMWUserName = @TMWUserName
ORDER BY DateCreated DESC

SELECT grp_id, usr_userid
FROM ttsgroupasgn
WHERE usr_userid = @TMWUserName