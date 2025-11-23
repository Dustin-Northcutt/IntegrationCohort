trigger ContactTrigger on Contact (after insert) {
    ContactTriggerHandler handler = new ContactTriggerHandler();
    handler.execute();
}