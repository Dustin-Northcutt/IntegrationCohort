@IsTest
private class TriggerHandler_Test {
  private class TestTriggerHandler extends TriggerHandler {
    public TriggerOperation Method { get; private set;}

    @TestVisible
    public override void onBeforeInsert(List<SObject> newRecords) {
      this.Method = TriggerOperation.BEFORE_INSERT;
    }
    @TestVisible
    public override void onBeforeUpdate(Map<Id, SObject> updatedRecordsMap, Map<Id, SObject> oldRecordsMap) {
      this.Method = TriggerOperation.BEFORE_UPDATE;
    }
    @TestVisible
    public override void onBeforeDelete(Map<Id, SObject> deletedRecordsMap) {
      this.Method = TriggerOperation.BEFORE_DELETE;
    }
    @TestVisible
    public override void onAfterInsert(Map<Id, SObject> newRecordsMap) {
      this.Method = TriggerOperation.AFTER_INSERT;
    }
    @TestVisible
    public override void onAfterUpdate(Map<Id, SObject> updatedRecordsMap, Map<Id, SObject> oldRecordsMap) {
      this.Method = TriggerOperation.AFTER_UPDATE;
    }
    @TestVisible
    public override void onAfterDelete(Map<Id, SObject> deletedRecordsMap) {
      this.Method = TriggerOperation.AFTER_DELETE;
    }
    @TestVisible
    public override void onAfterUndelete(Map<Id, SObject> undeletedRecordsMap) {
      this.Method = TriggerOperation.AFTER_UNDELETE;
    }
  }

  @IsTest
  static void it_should_perform_before_insert() {
    TestTriggerHandler testHandler = new TestTriggerHandler();
    TriggerHandler.triggerContext = TriggerOperation.BEFORE_INSERT;

    testHandler.execute();

    System.assertEquals(TriggerOperation.BEFORE_INSERT, testHandler.Method);
  }

  @IsTest
  static void it_should_perform_before_update() {
    TestTriggerHandler testHandler = new TestTriggerHandler();
    TriggerHandler.triggerContext = TriggerOperation.BEFORE_UPDATE;

    testHandler.execute();

    System.assertEquals(TriggerOperation.BEFORE_UPDATE, testHandler.Method);
  }

  @IsTest
  static void it_should_perform_before_delete() {
    TestTriggerHandler testHandler = new TestTriggerHandler();
    TriggerHandler.triggerContext = TriggerOperation.BEFORE_DELETE;

    testHandler.execute();

    System.assertEquals(TriggerOperation.BEFORE_DELETE, testHandler.Method);
  }

  @IsTest
  static void it_should_perform_after_insert() {
    TestTriggerHandler testHandler = new TestTriggerHandler();
    TriggerHandler.triggerContext = TriggerOperation.AFTER_INSERT;

    testHandler.execute();

    System.assertEquals(TriggerOperation.AFTER_INSERT, testHandler.Method);
  }

  @IsTest
  static void it_should_perform_after_update() {
    TestTriggerHandler testHandler = new TestTriggerHandler();
    TriggerHandler.triggerContext = TriggerOperation.AFTER_UPDATE;

    testHandler.execute();

    System.assertEquals(TriggerOperation.AFTER_UPDATE, testHandler.Method);
  }

  @IsTest
  static void it_should_perform_after_delete() {
    TestTriggerHandler testHandler = new TestTriggerHandler();
    TriggerHandler.triggerContext = TriggerOperation.AFTER_DELETE;

    testHandler.execute();

    System.assertEquals(TriggerOperation.AFTER_DELETE, testHandler.Method);
  }

  @IsTest
  static void it_should_perform_after_undelete() {
    TestTriggerHandler testHandler = new TestTriggerHandler();
    TriggerHandler.triggerContext = TriggerOperation.AFTER_UNDELETE;

    testHandler.execute();

    System.assertEquals(TriggerOperation.AFTER_UNDELETE, testHandler.Method);
  }
}