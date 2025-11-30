public with sharing class LeadTriggerHandler extends TriggerHandler {
    public override void onAfterInsert(Map<Id, SObject> leadsToId) {
        LEadService service = new LeadService();
        service.sendHighValueLeadsToOrgB(leadsToId.values());
    }
}