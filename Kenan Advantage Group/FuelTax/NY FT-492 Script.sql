SELECT 
	'FT-942' AS Schedule, --A--
	CASE 
		WHEN ConsigneeState = [State] THEN '1'
		WHEN ShipperState = [State] THEN '2' END AS Part, --B--
	Convert(Varchar, ShipDate, 101) AS [Date Shipped], --C--
	IRSTerminalCode AS [Origin TCN], --D--
	REPLACE(ShipperName, ',', '') AS [Origin Name], --E--
	ShipperCity AS [Origin City], --F--
	ShipperState AS [Origin State], --G--
	ShipperZip AS [Origin Zip], --H--
	'USA' AS [Origin Country], --I--
	SupplierFEIN AS [EIN of the Exporter], --J--
	SupplierName AS [Name of exporter], --K--
	'' AS [Destination TCN], --L--
	ConsigneeFEIN AS [Destination EIN], --M--
	CASE WHEN CHARINDEX('(', ConsigneeName) > 0
		THEN REPLACE(Substring(ConsigneeName,1,CHARIndex('(', ConsigneeName)-1),',','')
		ELSE REPLACE(ConsigneeName, ',','')
		END AS [Destination Name], --N--
	ConsigneeCity AS [Destination City], --O--
	ConsigneeState AS [Destination State], --P--
	ConsigneeZip AS [Destination Zip], --Q--
	'USA' AS [Destination Country], --R--
	'T' AS [Mode of Delivery], --S--
	ord_hdrnumber AS [Manifest Number], --T--
	NetGallons AS Gallons, --U--
	PIDX AS [Product Code] --V--

FROM KAG_FUEL_TAX.dbo.vw_ShipmentDataForReturn sd

WHERE 
	State = 'NY'
	AND Period = '20190101'
	AND Company = 'AVTK'
	AND Exclude = 0
	AND ShipperState <> ConsigneeState