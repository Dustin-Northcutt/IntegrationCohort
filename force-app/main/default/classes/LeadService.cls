public with sharing class LeadService {
    public Id sendHighValueLeadsToOrgB(List<Lead> leads) {
        Threshold__mdt highValueLeadThreshold = Threshold__mdt.getInstance('High_Value_Lead_Annual_Revenue');        

        Set<Id> highValueLeadIds = new Set<Id>();
        for (Lead lead : leads) {
            if (lead.AnnualRevenue > highValueLeadThreshold.Upper_Bound__c) {
                highValueLeadIds.add(lead.id);
            }
        }

        SendLeadToOrgBQue sender = new SendLeadToOrgBQue(highValueLeadIds);
        return QueueableUtility.enqueueJob(sender);
    } 
}