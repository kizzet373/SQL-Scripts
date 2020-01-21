SELECT ord_hdrnumber, d.DeleteDateTime, d.DeleteUser, *
FROM dbo.KAG_legheader_delete_audit2 d 
WHERE d.lgh_outstatus = 'cmp' AND DeleteUser != 'KAG_Housekeeper' and ord_hdrnumber = 29698109
ORDER BY d.DeleteDateTime DESC


select * from legheader AS l WITH(NOLOCK)  where l.ord_hdrnumber = 29698109

select * from [event] NOLOCK where ord_hdrnumber = 29698109
select * from stops nolock where stp_number in (110551301,110551302,110843048)

select * from referencenumber NOLOCK where ord_hdrnumber = 29698109 or ref_number = '29698109'

select * from freightdetail nolock where fgt_number = 220842012

select * from stops nolock where mov_number = 28767665