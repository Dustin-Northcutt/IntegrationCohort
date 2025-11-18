@isTest
public with sharing class Utility_Test {

    @isTest
    static void itReturnsNullForEmptyMap(){
        Map<String, Object> emptyMap = new Map<String,Object>();
        string payload = Utility.xWWWFormURLEncode(emptyMap);
        Assert.isNull(payload, 'Empty Map should return null');
    }

    @isTest
    static void itRetursFormatedPayload(){
        Map<String, Object> payLoadMap = new Map<String,Object>();
        string stringValue = 'HelloWorld';
        integer integerValue = 12345;
        payLoadMap.put('StringValue', stringValue);
        payLoadMap.put('IntegerValue', integerValue);
        string expectedFormattedPayload = 'StringValue=' + EncodingUtil.urlEncode(stringValue, 'UTF-8') 
                                        + '&IntegerValue=' + EncodingUtil.urlEncode(integerValue.toString(), 'UTF-8');
        string formattedPayload = Utility.xWWWFormURLEncode(payLoadMap);
        Assert.areEqual(expectedFormattedPayload, formattedPayload, 'Payload should be application/x-www-form-urlencoded Encoded');
    }

    @isTest
    static void itHandlesTwoLevels(){
        Map<String,Object> customerMap = new Map<String,OBject>();
        Map<String,Object> addressMap = new Map<String,OBject>();
        string firstName = 'Sarah';
        string lastName = 'Smith';
        string street = '123 Sesame St';
        string city = 'New York';

        customerMap.put('firstName', firstName);
        customerMap.put('lastName', lastName);
        addressMap.put('street', street);
        addressMap.put('city', city);
        customerMap.put('address', addressMap);
        string expectedFormattedPayload = 'firstName=' + EncodingUtil.urlEncode(firstName, 'UTF-8')
                                        + '&lastName=' + EncodingUtil.urlEncode(lastName, 'UTF-8')
                                        + '&address[street]=' + EncodingUtil.urlEncode(street, 'UTF-8')
                                        + '&address[city]=' + EncodingUtil.urlEncode(city, 'UTF-8');
        Assert.areEqual(expectedFormattedPayload, Utility.xWWWFormURLEncode(customerMap));
    }
}