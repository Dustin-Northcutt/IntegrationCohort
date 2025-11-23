public with sharing class CreateStripeCustomerQue  implements Queueable, Database.AllowsCallouts {
    public CreateStripeCustomerQue(Set<Id> contactIds) {
        this.contactIds = contactIds;
    }

    private Set<Id> contactIds;
    
    public void execute(QueueableContext context) {
        StripeService service = new StripeService();
        Set<Id> remainingContactIds = new Set<Id>(); 
        remainingContactIds.addAll(contactIds);       
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Contact contact : ContactQuery.queryContactsByIdForStripeCustomer(this.contactIds)) {
            String customerId = service.createCustomerFromContact(contact);
            Contact contactToUpdate = new Contact();
            contactToUpdate.Id = contact.Id;
            contactToUpdate.Stripe_Customer_Id__c = customerId;
            contactsToUpdate.add(contactToUpdate);
            remainingContactIds.remove(contact.id);

            if (willExceedLimits()) break;
        }

        update contactsToUpdate;

        if (!remainingContactIds.isEmpty()) {
            QueueableUtility.enqueueJob(new CreateStripCustomerQue(remainingContactIds));
        }
    }

    private Boolean willExceedLimits() {
        return (
            Limits.getCallouts() == Limits.getLimitCallouts() ||
            Limits.getCpuTime() >= Limits.getLimitCpuTime() * 0.9
            );
    }
}