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
        
        string expectedCustomerId = 'cus_1234567890';
        HttpResponse successResponse = new HttpResponse();
        successResponse.setHeader('Content-Type', 'application/json');
        successResponse.setBody('{"id":"' + expectedCustomerId + '"}');
        successResponse.setStatus('OK');
        successResponse.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, new MockStripeResponse_Test(successResponse));
        
        Test.startTest();
            string customerId = StripeService.postCustomerFromContact(contact);
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

        string expectedCustomerId = 'cus_1234567890';
        HttpResponse errorResponse = new HttpResponse();
        errorResponse.setHeader('Content-Type', 'application/json');
        errorResponse.setBody('{"id":"' + expectedCustomerId + '"}');
        errorResponse.setStatus('ERROR');
        errorResponse.setStatusCode(400);
        Test.setMock(HttpCalloutMock.class, new MockStripeResponse_Test(errorResponse));
        
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            StripeService.postCustomerFromContact(contact);            
        } catch (StripeService.StripeException ex) {
            exceptionThrown = true;
        }
        Test.stopTest();

        Assert.isTrue(exceptionThrown);
    }

    @isTest
    static void itSearchesCustomerSuccesfully(){
        string email = 'test@test.com';
        
        string expectedCustomerId = 'cus_1234567890';
        HttpResponse successResponse = new HttpResponse();
        successResponse.setHeader('Content-Type', 'application/json');
        successResponse.setStatus('OK');
        successResponse.setBody('{"data": [{"id":"'+ expectedCustomerId + '"}]}');
        successResponse.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, new MockStripeResponse_Test(successResponse));
        Test.startTest();
            string customerId = StripeService.searchCustomerByEmail(email);
        Test.stopTest();

        Assert.areEqual(expectedCustomerId, customerId);
    }

    
    @isTest
    static void itThrowsExceptionForCustomerSearchError(){
        string email = 'test@test.com';
        
        HttpResponse successResponse = new HttpResponse();
        successResponse.setStatus('Error');
        successResponse.setStatusCode(500);
        Test.setMock(HttpCalloutMock.class, new MockStripeResponse_Test(successResponse));

        Boolean exceptionThrown = false;
        Test.startTest();
            try {
                string customerId = StripeService.searchCustomerByEmail(email);
            } catch (StripeService.StripeException ex) {
                exceptionThrown = true;
            }
        Test.stopTest();

        Assert.isTrue(exceptionThrown);
    }


}