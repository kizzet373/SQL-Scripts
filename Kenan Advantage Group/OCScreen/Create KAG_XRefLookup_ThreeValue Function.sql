IF object_id('dbo.KAG_XRefLookup_ThreeValue') is not NULL
   DROP FUNCTION dbo.KAG_XRefLookup_ThreeValue

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.KAG_XRefLookup_ThreeValue
(	
	@FirstType  varchar(15),    
	@SecondType varchar(15),    
	@ThirdType  varchar(15),
	@FourthType varchar(15),    
	@SecondVal1 varchar(50),    
	@ThirdVal1  varchar(50),
	@FourthVal1 varchar(50)
)
RETURNS @xref TABLE 
(
	FirstXVal1      VARCHAR(50),  
    SecondXVal1     VARCHAR(50),  
    ThirdXVal1      VARCHAR(50),  
    FirstVal1       VARCHAR(50),  
    SecondVal1      VARCHAR(50),  
    ThirdVal1       VARCHAR(50)
)
AS
-- ===========================================================================  
-- Author:      Kirkland Brown    
-- Create date: 06/3/19    
-- Description: Rewrite of KAG_XRefLookup_TwoValue for OCScreen
-- =========================================================================== 

BEGIN 
	--Special condition for branded and unbranded products  
	IF @FirstType = 'SEProductID' AND @SecondType = 'SEProdLegNum' AND @ThirdType = 'SESuppliers' AND @FourthType = 'SEConsignee'
	BEGIN
		INSERT INTO @xref
		SELECT 
			Product.XVal1       AS FirstXVal1,  
            ProdLegacy.XVal1      AS SecondXVal1,  
            Supplier.XVal1       AS ThirdXVal1,  
            Product.Val1        AS FirstVal1,  
            ProdLegacy.Val1       AS SecondVal1,  
            Supplier.Val1        AS ThirdVal1
		FROM xrefrecords AS Product WITH (NOLOCK)  
			INNER JOIN xrefrecords AS ProdLegacy WITH (NOLOCK)  
				ON Product.Val2 = ProdLegacy.XVal1  
			INNER JOIN xrefrecords AS Supplier WITH (NOLOCK)  
				ON Product.Val1 = Supplier.XVal1 
				--If Val3 on the Product and XVal2 on the Supplier is the branded flag.  
                --If the Supplier's branded flag is set, then the Product's branded flag must match  
                --If the Supplier's branded flag is not set, then the Product's branded flag does not matter.
				AND 
					( (Product.Val3 = 'Y' AND Supplier.XVal2 = 'Y')  
					OR (Product.Val3 = 'N' AND Supplier.XVal2 = 'N')  
					OR (Supplier.XVal2 = '' OR Supplier.XVal2 IS NULL) ) 
			INNER JOIN xrefrecords AS Consignee WITH (NOLOCK)
				ON Product.XVal2 = Consignee.Val1
		WHERE Product.Type = @FirstType  
			AND ProdLegacy.Type = @SecondType  
			AND Supplier.Type = @ThirdType  
			AND ProdLegacy.Val1 = @SecondVal1  
			AND Supplier.Val1 = @ThirdVal1
			AND Consignee.Val1 = @FourthVal1
		
		--Return the generic product if there is no consignee dependent product
		IF NOT EXISTS(Select 1 FROM @xref) 
		BEGIN
			INSERT INTO @xref
			SELECT 
				Product.XVal1       AS FirstXVal1,  
				ProdLegacy.XVal1      AS SecondXVal1,  
				Supplier.XVal1       AS ThirdXVal1,  
				Product.Val1        AS FirstVal1,  
				ProdLegacy.Val1       AS SecondVal1,  
				Supplier.Val1        AS ThirdVal1
			FROM xrefrecords AS Product WITH (NOLOCK)  
				INNER JOIN xrefrecords AS ProdLegacy WITH (NOLOCK)  
					ON Product.Val2 = ProdLegacy.XVal1  
				INNER JOIN xrefrecords AS Supplier WITH (NOLOCK)  
					ON Product.Val1 = Supplier.XVal1 
					AND 
						( (Product.Val3 = 'Y' AND Supplier.XVal2 = 'Y')  
						OR (Product.Val3 = 'N' AND Supplier.XVal2 = 'N')  
						OR (Supplier.XVal2 = '' OR Supplier.XVal2 IS NULL) ) 
			WHERE Product.Type = @FirstType  
				AND ProdLegacy.Type = @SecondType  
				AND Supplier.Type = @ThirdType  
				AND ProdLegacy.Val1 = @SecondVal1  
				AND Supplier.Val1 = @ThirdVal1
				AND Product.xVal2 IS NULL
		END
	END
	ELSE
	--Do a normal 2 value lookup by default  
	BEGIN   
		INSERT INTO @xref  
		SELECT  [First].XVal1       AS FirstXVal1,  
				[Second].XVal1      AS SecondXVal1,  
				[Third].XVal1       AS ThirdXVal1,  
				[First].Val1        AS FirstVal1,  
				[Second].Val1       AS SecondVal1,  
				[Third].Val1        AS ThirdVal1
		FROM xrefrecords [First] WITH (NOLOCK)  
			INNER JOIN xrefrecords [Second] WITH (NOLOCK)  
				ON [First].Val2 = [Second].XVal1  
			INNER JOIN xrefrecords [Third] WITH (NOLOCK)  
				ON [Third].XVal1 = [First].Val1
		WHERE [First].Type = @FirstType  
			AND [Second].TYPE = @SecondType  
			AND [Third].TYPE = @ThirdType  
			AND [Second].VAL1 = @SecondVal1  
			AND [Third].VAL1 = @ThirdVal1
	END

    RETURN
END