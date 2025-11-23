public with sharing class ContactService {
    public void createStripeCustomerFromContacts(List<Contact> contacts) {
        Set<Id> contactIds = new Map<Id, Contact>(contacts).keySet();
        CreateStripeCustomerQue createStripeCustomerJob = new CreateStripeCustomerQue(contactIds);
        QueueableUtility.enqueueJob(createStripeCustomerJob);
    }
}