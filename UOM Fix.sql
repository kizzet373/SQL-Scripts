select 
       
       [RcvDtl].[WeightUOM] as [RcvDtl_WeightUOM],
       [RcvDtl].[GrossWeightUOM] as [RcvDtl_GrossWeightUOM]
       
from Erp.RcvDtl as RcvDtl
where (RcvDtl.PackSlip like '%%')

update ERP.rcvdtl
SET WeightUOM = 'LB', GrossWeightUOM = 'LB'
WHERE (RcvDtl.PackSlip like '%%')


select 
       
       [RcvDtl].[WeightUOM] as [RcvDtl_WeightUOM],
       [RcvDtl].[GrossWeightUOM] as [RcvDtl_GrossWeightUOM]
       
from Erp.RcvDtl as RcvDtl
where (RcvDtl.PackSlip like '%%')
