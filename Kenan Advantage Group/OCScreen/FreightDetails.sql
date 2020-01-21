select f.fgt_number, f.cmd_code, f.fgt_description, f.stp_number, f.fgt_consignee, f.fgt_parentcmd_number, f.fgt_parentcmd_number 
from freightdetail AS F WITH(NOLOCK) 
INNER JOIN stops AS S WITH(NOLOCK)
ON f.stp_number = s.stp_number
where s.ord_hdrnumber =29770656

select f.fgt_number, f.cmd_code, f.fgt_description, f.stp_number, f.fgt_consignee, f.fgt_parentcmd_number, f.fgt_parentcmd_number 
from freightdetail AS F WITH(NOLOCK) 
INNER JOIN stops AS S WITH(NOLOCK)
ON f.stp_number = s.stp_number
where s.ord_hdrnumber =29770660