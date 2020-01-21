SELECT 
	oh.ord_number AS [KAG Order Number], 
	rn.ref_number AS [DOW Reference Number],
	lh.lgh_number AS [Leg Number], 
	s.stp_number AS [Stop Number], 
	CASE WHEN s.stp_type = 'PUP' THEN 'Pickup' WHEN s.stp_type = 'DRP' THEN 'Dropoff' END AS [Stop Type], 
	s.stp_arrivaldate AS [Arrival Date], 
	s.stp_departuredate AS [Departure Date]
FROM 
	OrderHeader oh
	INNER JOIN LegHeader lh
		ON oh.ord_hdrnumber = lh.ord_hdrnumber
	INNER JOIN stops s
		ON s.lgh_number = lh.lgh_number
	INNER JOIN ReferenceNumber rn
		ON rn.ord_hdrnumber = oh.ord_hdrnumber AND rn.ref_type = 'SID'
WHERE 
	(s.stp_type = 'PUP' OR s.stp_type = 'DRP')
	AND oh.ord_hdrnumber IN 
	('83049636',
	'83060084',
	'83063790',
	'83065365',
	'83065392',
	'83072958',
	'83074002',
	'83081819',
	'83082104',
	'83082219',
	'83083928',
	'83083949',
	'83083951',
	'83083952',
	'83084394',
	'83084426',
	'83085144',
	'83085197',
	'83085201',
	'83087824',
	'83087825',
	'83087827',
	'83087840',
	'83089227',
	'83089432',
	'83089808',
	'83090227',
	'83090995',
	'83091357',
	'83091385',
	'83091386',
	'83091388',
	'83091393',
	'83092270',
	'83092371',
	'83092489',
	'83092492',
	'83092493',
	'83092496',
	'83092559',
	'83092948',
	'83092949',
	'83093562',
	'83094712',
	'83094725',
	'83094727',
	'83094900',
	'83099034',
	'83100662')