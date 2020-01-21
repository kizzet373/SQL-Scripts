DECLARE @orderNumber int = '35943976'
DECLARE @TMWUserName VARCHAR(20) = 'kibrown'

SELECT o.ord_hdrnumber AS OrderNumber, o.ord_revtype2 AS OrderTerminal, o.ord_revtype3 AS OrderFleet, @TMWUserName AS UserName, CASE WHEN frt.RelId IS NULL THEN 'N' ELSE 'Y' END AS HasTerminalAcess, CASE WHEN frf.RelId IS NULL THEN 'N' ELSE 'Y' END AS HasFleetAcess
FROM dbo.orderheader o WITH(NOLOCK)
    LEFT JOIN dbo.FuelRelations frt WITH(NOLOCK) ON frt.Terminal=o.ord_revtype2 AND frt.RelType='USRTERM' AND @TMWUserName=LTRIM(RTRIM(frt.StringValue))
    LEFT JOIN dbo.FuelRelations frf WITH(NOLOCK) ON frf.Terminal=o.ord_revtype3 AND frf.RelType='USRFLEET' AND @TMWUserName=LTRIM(RTRIM(frf.StringValue))
WHERE o.ord_hdrnumber=@orderNumber