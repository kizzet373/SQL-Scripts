USE TMW_PROD

DECLARE
@TransactionType VARCHAR(20) = 'Select',
@Type VARCHAR(15) = 'FTPIDXState', --FTPIDX or FTPIDXState
@State VARCHAR(100) = 'NC',
@Cmd_Code VARCHAR(100) = 'AUTOB5',
@OldPIDX VARCHAR(100) = '%',
@NewPIDX VARCHAR(100) = '%'

SELECT * FROM dbo.XrefRecords WHERE ((@Type = 'FTPIDXState' AND (Val1 = @State OR @State='%') AND (Val2 = @Cmd_Code OR @Cmd_Code='%')) OR (@Type = 'FTPIDX' AND Val1 = @Cmd_Code)) AND Type = @Type AND ((XVal1 = @OldPIDX OR @OldPIDX = '%') OR (XVal1 = @NewPIDX OR @NewPIDX = '%'))

IF @TransactionType = 'Insert'
BEGIN
	INSERT INTO xrefrecords(Type, Val1,Val2,Val3,XVal1,XVal2,XVal3,DateInserted,CreatedBy,SubType)
	Values (@Type,
	CASE WHEN @Type = 'FTPIDX' THEN @Cmd_Code WHEN @Type = 'FTPIDXState' THEN @State END, 
	CASE WHEN @Type = 'FTPIDX' THEN NULL WHEN @Type = 'FTPIDXState' THEN @Cmd_Code END,
	NULL,
	@NewPIDX,
	NULL,
	NULL,
	GETDATE(),
	'Kibrown',
	NULL)
END
ELSE IF @TransactionType = 'Update'
BEGIN
	UPDATE xrefrecords
	SET XVal1 = @NewPIDX
	WHERE ((@Type = 'FTPIDXState' AND (Val1 = @State OR @State='%') AND (Val2 = @Cmd_Code OR @Cmd_Code='%')) OR (@Type = 'FTPIDX' AND Val1 = @Cmd_Code)) AND Type = @Type AND ((XVal1 = @OldPIDX OR @OldPIDX = '%') OR (XVal1 = @NewPIDX OR @NewPIDX = '%'))
END
ELSE IF @TransactionType = 'Delete'
BEGIN
	DELETE FROM xrefrecords
	WHERE ((@Type = 'FTPIDXState' AND (Val1 = @State OR @State='%') AND (Val2 = @Cmd_Code OR @Cmd_Code='%')) OR (@Type = 'FTPIDX' AND Val1 = @Cmd_Code)) AND Type = @Type AND ((XVal1 = @OldPIDX OR @OldPIDX = '%') OR (XVal1 = @NewPIDX OR @NewPIDX = '%'))
END



SELECT * FROM dbo.XrefRecords WHERE ((@Type = 'FTPIDXState' AND (Val1 = @State OR @State='%') AND (Val2 = @Cmd_Code OR @Cmd_Code='%')) OR (@Type = 'FTPIDX' AND Val1 = @Cmd_Code)) AND Type = @Type AND ((XVal1 = @OldPIDX OR @OldPIDX = '%') OR (XVal1 = @NewPIDX OR @NewPIDX = '%'))
