declare @sql as varchar(max)
declare @GUID as varchar(50)
set @GUID = '7530738d20b34dec8ff135fd4cdb2b55'
set @sql = replace('SELECT T1.DateQuoted,T1.ExpirationDate,replace(T1.QuoteComment,char(13), char(10)+char(13)) as QuoteComment,T1.QuoteNum,T1.Reference,T1.Calc_CompanyAddr,T1.Calc_CompFax,T1.Calc_CompPhone,T1.Calc_CurSymbol,T1.Calc_CustContact,T1.Calc_CustFax,T1.Calc_CustPartOpts,T1.Calc_CustPhone,T1.Calc_EMail,T1.Calc_Message1,T1.Calc_Message2,T1.Calc_QuoteAddr,T1.Currency_CurrDesc,T1.Customer_Name, T3.DisplayCost_c, T1.Calc_CustID, T1.Calc_HasHeadMisc, T1.Calc_SalesPerson, T1.Customer_SalesRepCode, T1.Calc_TermsDesc, T1.ShipVia_ServiceCode_c, T1.ShipVia_Description, T1.Calc_Fob, T1.Calc_FOBDesc, T1.Contact_c, T2.Company,T2.DiscountPercent,T2.DisplaySeq,T2.DrawNum,T2.KitParentLine,T2.KitFlag,T2.KitPricing,T2.KitPrintCompsInv,T2.KitShipComplete,T2.LeadTime,T2.Location_c,T2.PcsPerPallet_c,T2.Pack_c, T2.CartonPallet_c,T2.PartNum,
			replace(T2.QuoteComment,char(13), char(10)+char(13)) as QuoteDtl_QuoteComment,T2.QuoteLine,T2.QuoteNum as QuoteDtl_QuoteNum,T2.RevisionNum,T2.XPartNum,T2.XRevisionNum,replace(T2.Calc_LineDesc,char(13), char(10)+char(13)) as Calc_LineDesc,T2.Calc_HasMisc, T2.PrintLine_c,T2.LineDesc,T3.DocUnitPrice,T3.PricePerCode,T3.QtyNum,T3.SalesUM,T3.SellingQuantity,T3.UnitPrice,T3.Calc_NetPrice,T3.Calc_UMDescription
          FROM QuoteHed_" + Parameters!TableGuid.Value + " T1
          LEFT OUTER JOIN QuoteDtl_" + Parameters!TableGuid.Value + " T2
          ON T1.Company = T2.Company AND T1.QuoteNum = T2.QuoteNum
          LEFT OUTER JOIN QuoteQty_" + Parameters!TableGuid.Value + " T3
          ON T2.Company = T3.Company AND T2.QuoteNum = T3.QuoteNum AND T2.QuoteLine = T3.QuoteLine', '" + Parameters!TableGuid.Value + "', @GUID)
		  
Print @SQL
Execute (@sql)