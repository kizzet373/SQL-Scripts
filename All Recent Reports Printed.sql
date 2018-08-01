SELECT Distinct
	Catalog.Name
	,SysRptLst.[RptDescription]
	,Catalog.Path
	,Max(SysRptLst.[LastActionOn]) as 'LastActionOn'
	,Max(Datasource.Name) AS 'Datasource Name'

	FROM [ReportServer].[dbo].[Catalog]

	left join [ReportServer].[dbo].[DataSource] AS Datasource
	on Datasource.ItemID = Catalog.ItemID

	inner join [Production].[Ice].[SysRptLst] as SysRptLst
	On Catalog.Path COLLATE SQL_Latin1_General_CP1_CI_AS = '/Production/' + SysRptLst.PrintProgram

	where Catalog.Path Like '%/Production/%'
	group by Catalog.Path, Catalog.Name, SysRptLst.[RptDescription], SysRptLst.[PrintProgram]
	Order By Catalog.Name