public with sharing class QueueableUtility {

    public static Id enqueueJob(Queueable job) {
        String jobId;
        QueueableSettings__c queSettings = QueueableSettings__c.getInstance();
        if (!queSettings.Kill_Queuables__c) {
            jobId = System.enqueueJob(job);
        }
        return jobId;
    }
}