@isTest
public with sharing class StripeService_Test {
    @isTest
    static void itCreatesCustomerSuccessfully() {
        Contact contact = new Contact(
            firstname = 'Test',
            lastname = 'Test',
            email = 'test@test.com',
            phone = '5555555555',
            mailingStreet = '123 Sesame St',
            mailingCity = 'New York',
            mailingState = 'NY',
            mailingPostalCode = '10001',
            mailingCountry = 'US'
        );
        
        String expectedCustomerId = 'cus_1234567890';
        HttpResponse successResponse = new HttpResponse();
        successResponse.setHeader('Content-Type', 'application/json');
        successResponse.setBody('{"id":"' + expectedCustomerId + '"}');
        successResponse.setStatus('OK');
        successResponse.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, new MockStripeResponse_Test(successResponse));
        
        StripeService service = new StripeService();
        Test.startTest();
            String customerId = service.createCustomerFromContact(contact);
        Test.stopTest();

        Assert.areEqual(expectedCustomerId, customerId);
    }  

    @isTest
    static void itThrowsExceptionForCreationError() {
        Contact contact = new Contact(
            firstname = 'Test',
            lastname = 'Test',
            email = 'test@test.com',
            phone = '5555555555',
            mailingStreet = '123 Sesame St',
            mailingCity = 'New York',
            mailingState = 'NY',
            mailingPostalCode = '10001',
            mailingCountry = 'US'
        );

        String expectedCustomerId = 'cus_1234567890';
        HttpResponse errorResponse = new HttpResponse();
        errorResponse.setHeader('Content-Type', 'application/json');
        errorResponse.setBody('{"id":"' + expectedCustomerId + '"}');
        errorResponse.setStatus('ERROR');
        errorResponse.setStatusCode(400);
        Test.setMock(HttpCalloutMock.class, new MockStripeResponse_Test(errorResponse));
        

        StripeService service = new StripeService();

        Test.startTest();
        try {
            service.createCustomerFromContact(contact);
            Assert.fail();            
        } catch (StripeService.StripeException ex) {
            Assert.istrue(true);
        }
        Test.stopTest();
    }

    @isTest
    static void itSearchesCustomerSuccesfully(){
       
        String expectedCustomerId = 'cus_1234567890';
        HttpResponse successResponse = new HttpResponse();
        successResponse.setHeader('Content-Type', 'application/json');
        successResponse.setStatus('OK');
        successResponse.setBody('{"data": [{"id":"'+ expectedCustomerId + '"}]}');
        successResponse.setStatusCode(200);

        String query = 'email:"test@test.com"';
        Test.setMock(HttpCalloutMock.class, new MockStripeResponse_Test(successResponse));

        StripeService service = new StripeService();
        Test.startTest();
            List<StripeCustomer> customers = service.searchCustomers(query);
        Test.stopTest();

        Assert.areEqual(expectedCustomerId, customers[0].Id);
    }

    @isTest
    static void itThrowsExceptionForMissingQuery(){
        String query = '';
        
        Boolean exceptionThrown = false;
        
        StripeService service = new StripeService();
        Test.startTest();
            try {
                List<StripeCustomer> customers = service.searchCustomers(query);
            } catch (StripeService.StripeException ex) {
                exceptionThrown = true;
            }
        Test.stopTest();

        Assert.isTrue(exceptionThrown);
    }

    @isTest
    static void itUpdatesCustomerSuccessfully() {
        Contact contact = new Contact(
            firstname = 'Test',
            lastname = 'Test',
            email = 'test@test.com',
            phone = '5555555555',
            mailingStreet = '123 Sesame St',
            mailingCity = 'New York',
            mailingState = 'NY',
            mailingPostalCode = '10001',
            mailingCountry = 'US'
        );
        
        String expectedCustomerId = 'cus_1234567890';
        HttpResponse successResponse = new HttpResponse();
        successResponse.setHeader('Content-Type', 'application/json');
        successResponse.setBody('{"id":"' + expectedCustomerId + '"}');
        successResponse.setStatus('OK');
        successResponse.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, new MockStripeResponse_Test(successResponse));
        
        StripeService service = new StripeService();
        Test.startTest();
            String customerId = service.updateCustomerFromContact(expectedCustomerId, contact);
        Test.stopTest();

        Assert.areEqual(expectedCustomerId, customerId);
    }

    @isTest
    static void itUpsertsExistingContactsToStripe(){
        Contact contact = new Contact(
            firstname = 'Test',
            lastname = 'Test',
            email = 'test@test.com',
            phone = '5555555555',
            mailingStreet = '123 Sesame St',
            mailingCity = 'New York',
            mailingState = 'NY',
            mailingPostalCode = '10001',
            mailingCountry = 'US'
        );
        
        String expectedCustomerId = 'cus_1234567890';
        HttpResponse successResponse = new HttpResponse();
        successResponse.setHeader('Content-Type', 'application/json');
        successResponse.setBody('{"object":"search_result","data": [{"id": "cus_TR3xPUV83xuTuA","email": "test@test.com","name": "Test Test"}],"id": "cus_TR3xPUV83xuTuA"}');
        successResponse.setStatus('OK');
        successResponse.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, new MockStripeResponse_Test(successResponse));
        
        StripeService service = new StripeService();
        Test.startTest();
            service.upsertCustomersFromContactOnEmail(new List<Contact>{contact});
        Test.stopTest();
    }

    @isTest
    static void itUpsertsNewContactsToStripe(){
        Contact contact = new Contact(
            firstname = 'Test',
            lastname = 'Test',
            email = 'test@test.com',
            phone = '5555555555',
            mailingStreet = '123 Sesame St',
            mailingCity = 'New York',
            mailingState = 'NY',
            mailingPostalCode = '10001',
            mailingCountry = 'US'
        );
        
        String expectedCustomerId = 'cus_1234567890';
        HttpResponse successResponse = new HttpResponse();
        successResponse.setHeader('Content-Type', 'application/json');
        successResponse.setBody('{"object":"search_result","data": [],"id": "cus_TR3xPUV83xuTuA"}');
        successResponse.setStatus('OK');
        successResponse.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, new MockStripeResponse_Test(successResponse));
        
        StripeService service = new StripeService();
        Test.startTest();
            service.upsertCustomersFromContactOnEmail(new List<Contact>{contact});
        Test.stopTest();
    }

        @isTest
    static void itWarnsMissingEmailOnUpsert(){
        Contact contact = new Contact(
            firstname = 'Test',
            lastname = 'Test',
            email = null,
            phone = '5555555555',
            mailingStreet = '123 Sesame St',
            mailingCity = 'New York',
            mailingState = 'NY',
            mailingPostalCode = '10001',
            mailingCountry = 'US'
        );
        
        String expectedCustomerId = 'cus_1234567890';
        HttpResponse successResponse = new HttpResponse();
        successResponse.setHeader('Content-Type', 'application/json');
        successResponse.setBody('{"object":"search_result","data": [{"id": "cus_TR3xPUV83xuTuA","email": "test@test.com","name": "Test Test"}],"id": "cus_TR3xPUV83xuTuA"}');
        successResponse.setStatus('OK');
        successResponse.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, new MockStripeResponse_Test(successResponse));
        
        StripeService service = new StripeService();
        Test.startTest();
            service.upsertCustomersFromContactOnEmail(new List<Contact>{contact});
        Test.stopTest();

        List<LogEntry__c> warnEntries = [SELECT id FROM LogEntry__c WHERE LoggingLevel__c = 'WARN'];
        Assert.areEqual(1, warnEntries.size());
   }
   
    @isTest
    static void upsertThrowsMissingArgException(){
        Boolean exceptionThrown = false;
        StripeService service = new StripeService();
        try {
            service.upsertCustomersFromContactOnEmail(new List<Contact>());
        } catch (IllegalArgumentException ex) {
            exceptionThrown = true;
        }

        Assert.isTrue(exceptionThrown);
    }
}