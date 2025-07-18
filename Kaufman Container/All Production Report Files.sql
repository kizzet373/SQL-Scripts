SELECT
	Catalog.Path
	,Catalog.Name
	,Report.RptDescription
	,MIN(Datasource.Name) AS 'Datasource Name'
	,Catalog.ItemID

	FROM [ReportServer].[dbo].[Catalog]

	left join [ReportServer].[dbo].[DataSource] AS Datasource
	on Datasource.ItemID = Catalog.ItemID

	left join [Production].[Ice].[Report] AS Report
	on Catalog.Name COLLATE SQL_Latin1_General_CP1_CI_AS = Report.ReportID

	where Catalog.Path Like '%/Production/%'
	group by Catalog.Path, Catalog.Name, Catalog.ItemID, Report.RptDescription
	Order By Catalog.Path
