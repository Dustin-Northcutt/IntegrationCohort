public with sharing class ContactQuery {

    public static List<Contact> queryContactsByIdForStripeCustomer(Set<Id> contactIds) {
        return [SELECT Id, FirstName, LastName, Email, Phone, 
                    mailingStreet, mailingCity, mailingState, mailingPostalCode, mailingCountry
                FROM Contact
                WHERE id IN :contactIds];
    }
}