public with sharing class StripeService {
    
    //TODO Store Stripe Customer Id on Contact
    public class StripeException extends Exception{}

    public void upsertCustomersFromContactOnEmail(List<Contact> contacts) {
        if  (contacts.isEmpty()) {
            throw new IllegalArgumentException('Contacts argument is empty');
        }
        
        String query = '-email:null';
        List<StripeCustomer> customers = searchCustomers(query);
        Map<String, StripeCustomer> emailToCustomer = new Map<String, StripeCustomer>();
        for (StripeCustomer customer : searchCustomers(query)) {
            emailToCustomer.put(customer.email, customer);
        }

        for (Contact contact : contacts) {
            if (String.isBlank(contact.email)) {
                Logger.warn('Contact has no email address when attempted upsert to Stripe', contact);
                Logger.saveLog();
                continue;
            }
            if (emailToCustomer.containsKey(contact.email)) {
                StripeCustomer customer = emailToCustomer.get(contact.email);
                updateCustomerFromContact(customer.id, contact);
            } else {
             createCustomerFromContact(contact);
               
            }
        }


    }
    
    public List<StripeCustomer> searchCustomers(string query) {
        if (String.isBlank(query)) {
            throw new StripeException('Query is required to search for Stripe Customers');
        }
        List<StripeCustomer> customers = new List<StripeCustomer>();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Stripe/v1/customers/search');
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        Map<String, Object> queryMap = new Map<String, Object>();
        queryMap.put('query', query);
        request.setBody(Utility.xWWWFormURLEncode(queryMap));

        Http http = new Http();
        HttpResponse response = sendRequest(request);
        StripeCustomer.SearchResponse searchResponse = (StripeCustomer.SearchResponse)JSON.deserialize(response.getBody(), StripeCustomer.SearchResponse.class);
        return searchResponse.data;
    }

    public string createCustomerFromContact(Contact contact) {
        Map<String, Object> customerMap = setCustomerMapFromContact(contact);
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Stripe/v1/customers');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String customerPayload = Utility.xWWWFormURLEncode(customerMap);
        request.setBody(customerPayload);

        Http http = new Http();
        HttpResponse response = sendRequest(request);
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        return (String)responseMap.get('id');
    }

    public string updateCustomerFromContact(string customerId, Contact contact) {
        Map<String, Object> customerMap = setCustomerMapFromContact(contact);
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Stripe/v1/customers' + '/' + customerId);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        string customerPayload = Utility.xWWWFormURLEncode(customerMap);
        request.setBody(customerPayload);

        Http http = new Http();
        HttpResponse response =sendRequest(request);
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        customerId = (String)responseMap.get('id');
        return customerId;
    }

    private Map<String, Object> setCustomerMapFromContact(Contact contact) {
        Map<String,Object> addressMap = new Map<String, Object>();
        addressMap.put('line1', contact.mailingStreet);
        addressMap.put('city', contact.mailingCity);
        addressMap.put('state', contact.mailingState);
        addressMap.put('postal_code', contact.mailingPostalCode);
        addressMap.put('country', contact.mailingCountry);
        
        Map<String, Object> customerMap = new Map<String, Object>();
        customerMap.put('name', contact.firstname + ' ' + contact.lastname);
        customerMap.put('email', contact.email);
        customerMap.put('phone', contact.phone);
        customerMap.put('address', addressMap);
        System.debug('customerMap: ' + customerMap);
        return customerMap;
    }

    private HttpResponse sendRequest(HttpRequest request) { 
        Http http = new Http();
        HttpResponse response = http.send(request);
        if (response.getStatus() != 'OK') {
            Logger.error('Error performing query: ' + response.getStatus() + ' ' + response.getStatusCode());
            Logger.saveLog();
            throw new StripeException('Stripe Callout Error: ' + response.getStatus() + ' ' + response.getStatusCode());
        }
        return response;
    }
}