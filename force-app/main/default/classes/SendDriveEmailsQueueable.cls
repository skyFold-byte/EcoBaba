public class SendDriveEmailsQueueable implements Queueable {
 
    private List<Id> driveIds;
 
    public SendDriveEmailsQueueable(List<Id> driveIds){
        this.driveIds = driveIds;
    }
 
    public void execute(QueueableContext context){
 
        // Step 1: Get Drive
        List<EcoDrive__c> drives = [
            SELECT Id, Name, Start_Date__c, City__c
            FROM EcoDrive__c
            WHERE Id IN :driveIds
        ];
        if(!drives.isEmpty()){
            EcoDrive__c drive = drives[0];
        }
 
        // Step 2: Get Citizen Account
        List<Account> accounts = [
            SELECT Id
            FROM Account
            WHERE Name = 'Citizen'
            LIMIT 1
        ];
        if(accounts.isEmpty()){
            return; //Exit safely if account not found
        }
        Account citizenAccount = accounts[0];
 
        // Step 3: Get Only Contacts Under Citizen Account
        List<Contact> contacts = [
            SELECT Id, Email, FirstName
            FROM Contact
            WHERE AccountId = :citizenAccount.Id
            AND Email != null
        ];
 
        List<Messaging.SingleEmailMessage> emailBatch = new List<Messaging.SingleEmailMessage>();
 
        for(EcoDrive__c drive : drives){
 
            for(Contact c : contacts){
 
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(c.Id);
                mail.setWhatId(drive.Id);
                mail.setSaveAsActivity(false);
                mail.setSubject('New Eco Drive Launched!');
                mail.setPlainTextBody(
                    'Hello ' + c.FirstName + ',\n\n' +
                    'A new Eco Drive has been launched:\n' +
                    'Drive Name: ' + drive.Name + '\n' +
                    'Date: ' + drive.Start_Date__c + '\n' +
                    'Location: ' + drive.City__c + '\n\n' +
                    'Please login and register.'
                );
 
                emailBatch.add(mail);
 
                if(emailBatch.size() == 100){
                    Messaging.sendEmail(emailBatch);
                    emailBatch.clear();
                }
            }
        }
 
        if(!emailBatch.isEmpty()){
            Messaging.sendEmail(emailBatch);
        }
    }
}