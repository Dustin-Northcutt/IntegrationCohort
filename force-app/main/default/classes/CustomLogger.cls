public with sharing class CustomLogger {

    public static void saveLog(String message) {
        Custom_Log__c log = new Custom_Log__c();
        log.Message__c = message;
        insert log;
    }

    public static void saveLog(String message, SObject sObj) {
        Custom_Log__c log = new Custom_Log__c();
        log.Message__c = message;
        log.Record_Id__c = (String)sObj.get('id');
        insert log;
    }
}