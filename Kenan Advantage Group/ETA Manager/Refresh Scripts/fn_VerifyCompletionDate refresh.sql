USE [ETAManager_DEV]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_VerifyCompletionDate]    Script Date: 9/23/2019 10:05:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fn_VerifyCompletionDate]
(
	@orderNumber VARCHAR(12),
	@instance VARCHAR(6)
)
RETURNS DATETIME
AS
BEGIN
	
	DECLARE @returnVal DATETIME

	IF @instance = 'FDG'
	--	SELECT   @returnVal = ord_completiondate FROM [TMW_FUEL_PROD.DB.THEKAG.COM].[TMW_PROD].[dbo].orderheader WHERE ord_hdrnumber = @orderNumber -- prod + beta
		SELECT @returnVal = ord_completiondate FROM [KAGDC2SQL03.THEKAG.COM\KAGDC2SQL03_DEV].[TMW_FUEL_DEV].[dbo].orderheader WHERE ord_hdrnumber = @orderNumber -- dev + qa
	
	IF @instance = 'SPG'
	--	SELECT @returnVal = ord_completiondate FROM [TMW_SPG_PROD.DB.THEKAG.COM].[TMW_SPG_PROD].dbo.orderheader WHERE ord_hdrnumber = @orderNumber -- prod + beta
		SELECT @returnVal = ord_completiondate FROM [KAGDC2SQL04.THEKAG.COM\KAGDC2SQL04_DEV].[TMW_SPG_DEV].[dbo].orderheader WHERE ord_hdrnumber = @orderNumber -- dev + qa
	 
	RETURN  @returnVal
END
