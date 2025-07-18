USE [ETAManager_DEV]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_VerifyOrder]    Script Date: 9/23/2019 10:05:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Zach Nelson
-- Create date: 2018-01-01
-- Description:	Determines why an order did not show up in staging
-- =============================================
ALTER FUNCTION [dbo].[fn_VerifyOrder]
(
	@orderNumber VARCHAR(12),
	@instance VARCHAR(6)
)
RETURNS VARCHAR(30)
AS
BEGIN
	
	DECLARE @returnVal VARCHAR(30)

	IF @instance = 'FDG'
	--	SELECT @returnVal = ord_status FROM [TMW_FUEL_PROD.DB.THEKAG.COM].[TMW_FUEL_DEV].[dbo].orderheader WHERE ord_hdrnumber = @orderNumber -- prod
		SELECT @returnVal = ord_status FROM [KAGDC2SQL03.THEKAG.COM\KAGDC2SQL03_DEV].[TMW_FUEL_DEV].[dbo].orderheader WHERE ord_hdrnumber = @orderNumber -- dev

	IF @instance = 'SPG'
	--	SELECT @returnVal = ord_status FROM [TMW_SPG_PROD.DB.THEKAG.COM].[TMW_SPG_PROD].dbo.orderheader WHERE ord_hdrnumber = @orderNumber -- prod
		SELECT @returnVal = ord_status FROM [KAGDC2SQL04.THEKAG.COM\KAGDC2SQL04_DEV].[TMW_SPG_DEV].[dbo].orderheader WHERE ord_hdrnumber = @orderNumber -- dev

	RETURN  @returnVal
END

