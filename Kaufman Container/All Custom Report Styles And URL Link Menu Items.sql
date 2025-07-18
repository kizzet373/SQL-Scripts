/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
FROM(
	SELECT
		ReportStyle.[ReportID] AS 'Report ID'
		,ReportStyle.[StyleDescription] AS 'Style Description'
		,ReportStyle.[PrintProgram] AS 'Path'
		,ReportStyle.[RptDefID] AS 'Report Definition ID'
	FROM [Ice].[ReportStyle] AS ReportStyle

	left join [dbo].[Seed_ReportStyle] AS Seed_ReportStyle
	on Seed_ReportStyle.StyleDescription = ReportStyle.StyleDescription

	where Seed_ReportStyle.StyleDescription IS NULL
	Order by [Report ID] OFFSET 0 ROWS
) Query1

union all

SELECT *
FROM(
	SELECT
		'MenuID: ' + Ice.Menu.MenuID AS 'Report ID'
		,'Menu Desc: ' + Ice.Menu.MenuDesc AS 'Style Description'
		,Ice.Menu.Program AS 'Path'
		,NULL AS 'Report Definition ID'
	FROM [Production].Ice.Menu
	left join Seed_Menu AS Seed_Menu
	on Menu.MenuID = Seed_Menu.MenuID

	WHERE Seed_Menu.MenuID IS NULL AND Menu.OptionType = 'U'
) Query2

