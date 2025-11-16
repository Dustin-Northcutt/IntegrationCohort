public with sharing class StripeService {

    public class StripeException extends Exception{}

    public class SearchResponse {
        public List<Customer> data;
    }
    public class Customer {
        public string id;
        public string name;
        public string email;
    }

    public void upsertCustomersFromContactOnEmail(List<Contact> contacts) {
        if  (contacts.isEmpty()) {
            throw new IllegalArgumentException('Contacts argument is empty');
        }
        Map<String, Contact> emailContactMap = new Map<String, Contact>();
        for (Contact contact : contacts) {
            if (String.isBlank(contact.email)) {
                Logger.warn('Contact has no email address when attempted upsert to Stripe', contact);
                Logger.saveLog();
                continue;
            }
            emailContactMap.put(contact.email, contact);
        }
        
        String query = '-email:null';
        List<StripeService.Customer> customers = searchCustomers(query);

        if (!customers.isEmpty()) {
            for (StripeService.Customer customer : customers) {
                if (emailContactMap.containsKey(customer.email)) {
                    updateCustomerFromContact(customer.id, emailContactMap.get(customer.email));
                    emailContactMap.remove(customer.email);
                }
            }
        }

        for (Contact contact : emailContactMap.values()) {
            createCustomerFromContact(contact);
            //TODO Store Stripe Customer Id on Contact
        }
    }
    
    public List<StripeService.Customer> searchCustomers(string query) {
        if (String.isBlank(query)) {
            throw new StripeException('Query is required to search for Stripe Customers');
        }
        List<StripeService.Customer> customers = new List<StripeService.Customer>();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Stripe/v1/customers/search');
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        Map<String, Object> queryMap = new Map<String, Object>();
        queryMap.put('query', query);
        request.setBody(Utility.xWWWFormURLEncode(queryMap));

        Http http = new Http();
        HttpResponse response = sendRequest(request);
        StripeService.SearchResponse searchResponse = (StripeService.SearchResponse)JSON.deserialize(response.getBody(), StripeService.SearchResponse.class);
        customers = searchResponse.data;
        return customers;
    }

    public string createCustomerFromContact(Contact contact) {
        String customerId;
        Map<String, Object> customerMap = setCustomerMapFromContact(contact);
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Stripe/v1/customers');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        string customerPayload = Utility.xWWWFormURLEncode(customerMap);
        request.setBody(customerPayload);

        Http http = new Http();
        HttpResponse response = sendRequest(request);
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        customerId = (String)responseMap.get('id');
        return customerId;
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

        return customerMap;
    }

    private HttpResponse sendRequest(HttpRequest request) { 
        Http http = new Http();
        HttpResponse response = http.send(request);
        if (response.getStatus() != 'OK') {
            Logger.error('Error performing query: ' + response.getStatus() + ' ' + response.getStatusCode());
            Logger.saveLog();
            Throw new StripeException('Stripe Callout Error: ' + response.getStatus() + ' ' + response.getStatusCode());
        }
        return response;
    }
}