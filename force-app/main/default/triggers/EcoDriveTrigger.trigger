trigger EcoDriveTrigger on EcoDrive__c (after insert) {
	if(Trigger.isAfter && Trigger.isInsert){
        EcoDriveNotificationHandler.handleAfterInsert(Trigger.new);
    }
}