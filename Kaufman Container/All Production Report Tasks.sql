/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	query1.ReportID AS 'Report ID'
	,query1.TaskDescription AS 'Report Description'
	,max(query1.LastActivityOn) AS 'Last Activity On'
	,query1.Path AS 'Path'
	,query1.StyleDescription AS 'Style Description'

FROM
(
	SELECT
		Report.[ReportID]
		,Report.[AutoProgram]
		,SysTask.[SysTaskNum]
		,SysTask.[TaskDescription]
		,SysTask.[TaskType]
		,SysTask.[StartedOn]
		,SysTask.[EndedOn]
		,SysTask.[SubmitUser]
		,SysTask.[TaskStatus]
		,SysTask.[RunProcedure]
		,SysTask.[LastActivityOn]
		,Catalog.Path COLLATE SQL_Latin1_General_CP1_CI_AS AS Path 
		,ReportStyle.StyleDescription
	FROM [Production].[Ice].[SysTask] SysTask

	Left Join [Production].[Ice].[Report] As Report
	On Report.RptDescription = SysTask.TaskDescription

	Left Join [Production].[Ice].[SysRptLst] AS SysRptLst
	ON SysRptLst.RptDescription = SysTask.TaskDescription

	Left Join [ReportServer].[dbo].[Catalog] As Catalog
	On Report.ReportID = Catalog.Name COLLATE SQL_Latin1_General_CP1_CI_AS
	OR SysRptLst.PrintProgram = Catalog.Path COLLATE SQL_Latin1_General_CP1_CI_AS

	left Join [Production].[Ice].[ReportStyle] AS ReportStyle
	ON Catalog.Name COLLATE SQL_Latin1_General_CP1_CI_AS = ReportStyle.ReportID

	
		
 ) query1

 Group By query1.TaskDescription, query1.StyleDescription, query1.ReportID, query1.Path

 ORDER BY query1.TaskDescription