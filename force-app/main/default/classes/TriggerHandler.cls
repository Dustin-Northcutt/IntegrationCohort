public virtual class TriggerHandler {
    public TriggerHandler() {
        if (!Trigger.isExecuting && !Test.isRunningTest()) {
            throw new TriggerHandlerException('Contact Trigger Handler called outside of Trigger');
        }
    }

    @TestVisible
    private static TriggerOperation triggerContext;

    public class TriggerHandlerException extends Exception{}

    public void execute() {
        if (triggerContext == null) triggerContext = Trigger.operationType;

        switch on triggerContext {
            when BEFORE_INSERT {
                onBeforeInsert(Trigger.new);
            }
            when BEFORE_UPDATE {
                onBeforeUpdate(Trigger.oldMap, Trigger.newMap);
            }
            when BEFORE_DELETE {
                onBeforeDelete(Trigger.oldMap);
            }
            when AFTER_INSERT {
                onAfterInsert(Trigger.newMap);
            }
            when AFTER_UPDATE {
                onAfterUpdate(Trigger.oldMap, Trigger.newMap);
            }
            when AFTER_DELETE {
                onAfterDelete(Trigger.oldMap);
            }
            when AFTER_UNDELETE {
                onAfterUndelete(Trigger.newMap);
            }
        }
    }
    public virtual void onBeforeInsert(List<SObject> insertedRecords) {}
    public virtual void onBeforeUpdate(Map<Id, SObject> oldRecordsToId, Map<Id, SObject> updatedRecordsMap) {}
    public virtual void onBeforeDelete(Map<Id, SObject> deletedRecords) {}
    public virtual void onAfterInsert(Map<Id, SObject> insertedRecords) {}
    public virtual void onAfterUpdate(Map<Id, SObject> oldRecordsToId, Map<Id, SObject> updatedRecordsMap) {}
    public virtual void onAfterDelete(Map<Id, SObject> deletedRecords) {}
    public virtual void onAfterUndelete(Map<Id, SObject> undeletedRecords) {}
}