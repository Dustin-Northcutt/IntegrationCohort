public with sharing class ContactTriggerHandler extends TriggerHandler {
    public override void onAfterInsert(Map<Id, SObject> contactsToId) {
        ContactService service = new ContactService();
        service.createStripeCustomerFromContacts((List<Contact>)contactsToId.values());
    }
}