BEGIN
		DECLARE @ordHdrNumber int
		SET @ordHdrNumber = '32649097'--'26231431'--'24101730'

		SELECT ord_hdrnumber,ivh_invoicenumber,* FROM invoiceheader where ord_hdrnumber = @ordHdrNumber

		UPDATE invoiceheader
		SET ord_hdrnumber = ord_hdrnumber * -1
		WHERE CAST(ord_hdrnumber AS VARCHAR(20)) = @ordHdrNumber

		SELECT ord_hdrnumber,ivh_invoicenumber,* FROM invoiceheader where CAST(ord_hdrnumber AS VARCHAR(20)) = @ordHdrNumber * -1
		

END
GO