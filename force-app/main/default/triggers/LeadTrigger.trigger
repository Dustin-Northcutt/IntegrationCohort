trigger LeadTrigger on Lead (after insert) {
    LeadTriggerHandler handler = new LeadTriggerHandler();
    handler.execute();
}