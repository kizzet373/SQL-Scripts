BEGIN TRAN
IF (SELECT FilingMethodID FROM StateControl WHERE State = 'MO') = 5
BEGIN
	UPDATE sc 
	SET FilingMethodID = 4 --Print
	,	sc.ReturnFormatID = 4
	,	FileStoredProcedure = 'up_rtnGenericPDFFile'
	,	HeaderStoredProcedure = ''
	,	DetailStoredProcedure = 'up_rtnGenericPDFDetails'
	,	OutputFileName = 'MO_<<scac>>_<<groupName>>_<<date>>.pdf'
	--SELECT *
	FROM StateControl sc WITH(NOLOCK)
	WHERE sc.State = 'MO'

	INSERT INTO dbo.DataRelations(State, ColumnName, RelationLevel)
	SELECT 'MO',dr.ColumnName, dr.RelationLevel
	FROM DataRelations dr WITH(NOLOCK)
	WHERE dr.State = 'TX'
	AND dr.RelationLevel = 0

	DELETE
	--SELECT *
    FROM dbo.DataRelations
	WHERE State = 'MO'
	AND RelationLevel != 0
END	
ELSE 
BEGIN
	UPDATE sc 
	SET FilingMethodID = 5 --Web
	,	ReturnFormatID = 1
	,	FileStoredProcedure = 'up_rtnMissouriFile'
	,	HeaderStoredProcedure = 'up_rtnMissouriHeader'
	,	DetailStoredProcedure = 'up_rtnMissouriDetails'
	,	OutputFileName = 'MO_<<scac>>_<<date>>.edi'
	--SELECT *
	FROM StateControl sc WITH(NOLOCK)
	WHERE sc.State = 'MO'

	INSERT INTO dbo.DataRelations(State, ColumnName, RelationLevel)
	SELECT 'MO',dr.ColumnName, dr.RelationLevel
	FROM DataRelations dr WITH(NOLOCK)
	WHERE dr.State = 'NC'
	AND dr.RelationLevel != 0

	DELETE
	--SELECT *
    FROM dbo.DataRelations
	WHERE State = 'MO'
	AND RelationLevel = 0
END	
COMMIT TRAN

Select sc.FilingMethodID
FROM StateControl sc
WHERE sc.State = 'MO'

