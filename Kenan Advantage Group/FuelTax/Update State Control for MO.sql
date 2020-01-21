UPDATE StateControl
SET FileStoredProcedure = 'up_rtnGenericPDFFile', OutputFileName = 'MO_<<scac>>_<<groupName>>_<<date>>.pdf', HeaderStoredProcedure = ''
WHERE State = 'MO'

select * from StateControl