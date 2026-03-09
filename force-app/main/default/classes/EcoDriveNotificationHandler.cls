public class EcoDriveNotificationHandler {
    
    public static void handleAfterInsert(List<EcoDrive__c> newDrives){
        
        List<Id> driveIds = new List<Id>();
        
        for(EcoDrive__c drive : newDrives){
            if(drive.Status__c == 'Open'){
                driveIds.add(drive.Id);
            }
        }
        
        if(!driveIds.isEmpty()){
            System.enqueueJob(new SendDriveEmailsQueueable(driveIds));
        }
    }
}