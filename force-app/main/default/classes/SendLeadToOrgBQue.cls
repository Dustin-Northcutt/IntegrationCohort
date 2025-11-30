public with sharing class SendLeadToOrgBQue implements Queueable, Database.AllowsCallouts {
    public SendLeadToOrgBQue(Set<Id> leadIds) {
        this.leadIds = leadIds;
    } 

    private Set<Id> leadIds;

    public void execute(QueueableContext qc) {
        Set<Id> remainingLeadIds = new Set<Id>();
        remainingLeadIds.addAll(leadIds);
       
        OrgBService service = new OrgBService();
        List<Lead> payloadLeads = new List<Lead>();
        
        for (Lead lead : LeadQuery.queryLeadsForOrgByById(this.leadIds)) {
            payloadLeads.add(lead);
            remainingLeadIds.remove(lead.id);
        }

        LeadPayload payload = service.setLeadPayloadFromLeadd(payloadLeads);
        service.sendLeadsToOrgB(payload);

        if (!remainingLeadIds.isEmpty()) {
            QueueableUtility.enqueueJob(new SendLeadToOrgBQue(remainingLeadIds));
        }
    }

}