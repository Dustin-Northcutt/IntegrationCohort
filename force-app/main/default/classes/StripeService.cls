public with sharing class StripeService {

    public class StripeException extends Exception{}

    public static string postCustomerFromContact(Contact contact) {
        String customerId;
        Map<String,Object> addressMap = new Map<String, Object>();
        Map<String, Object> customerMap = setCustomerMapFromContact(contact);
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Stripe/v1/customers');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        string customerPayload = Utility.xWWWFormURLEncode(customerMap);
        request.setBody(customerPayload);

        Http http = new Http();
        HttpResponse response = http.send(request);
        if (response.getStatus() == 'OK') {
            Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            customerId = (String)responseMap.get('id');
        } else {
            Logger.error('Error: ' + response.getStatus() + ' ' + response.getStatusCode());
            Logger.saveLog();
            Throw new StripeException('Error Creating Customer: ' + response.getStatus() + ' ' + response.getStatusCode());
        }
        return customerId;
    }

    public static string searchCustomerByEmail(string email) {
        if (String.isBlank(email)) {
            throw new StripeException('Email is require to search for Stripe Customers');
        }
        string customerId;
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Stripe/v1/customers/search');
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        Map<String, Object> queryMap = new Map<String, Object>();
        String queryString = 'email:"' + email + '"';
        queryMap.put('query', queryString);
        queryMap.put('limit', 1);
        request.setBody(Utility.xWWWFormURLEncode(queryMap));

        Http http = new Http();
        HttpResponse response = http.send(request);
        if (response.getStatus() == 'OK') {
            Map<String, Object> searchResponse = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            List<Object> customers = (List<Object>)searchResponse.get('data');
            if (!customers.isEmpty()) {
                Map<String, Object> customer = (Map<String, Object>)customers[0];
                customerId = (String)customer.get('id');
            }
        } else {
            Logger.error('Error: ' + response.getStatus() + ' ' + response.getStatusCode());
            Logger.saveLog();
            Throw new StripeException('Error Searching Customer: ' + response.getStatus() + ' ' + response.getStatusCode());

        }
        return customerId;
    }

    private static Map<String, Object> setCustomerMapFromContact(Contact contact) {
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
} 

