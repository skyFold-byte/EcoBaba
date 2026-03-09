public with sharing class EcoDriveController {
 
    @AuraEnabled(cacheable=true)
    public static List<DriveWrapper> getOpenDrives(){
 
        List<DriveWrapper> drives = new List<DriveWrapper>();
 
        List<EcoDrive__c> driveList = [
            SELECT Id,
                   Name,
                   City__c,
                   State__c,
                   Start_Date__c,
                   Start_Time__c,
                   Total_Participants__c,
                   Remaining_Slots__c,
                   Drive_Image_URL__c
            FROM EcoDrive__c
            WHERE Start_Date__c >= TODAY AND Status__c = 'Open'
            ORDER BY Start_Date__c ASC
        ];
 
        for(EcoDrive__c d : driveList){
 
            DriveWrapper wrap = new DriveWrapper();
 
            wrap.id = d.Id;
            wrap.name = d.Name;
 
            wrap.venue =
                (d.City__c != null ? d.City__c : '') +
                (d.State__c != null ? ', ' + d.State__c : '');
 
            wrap.driveDate =
                d.Start_Date__c != null ?
                d.Start_Date__c.format() :
                '';
 
            wrap.driveTime =
                d.Start_Time__c != null ?
                formatTime(d.Start_Time__c) :
                '';
 
            wrap.joined =
                d.Total_Participants__c != null ?
                Integer.valueOf(d.Total_Participants__c) : 0;
 
            wrap.spotsLeft =
                d.Remaining_Slots__c != null ?
                Integer.valueOf(d.Remaining_Slots__c) : 0;
 
            wrap.imageUrl = d.Drive_Image_URL__c;
 
            drives.add(wrap);
        }
 
        return drives;
    }
 
 
    public static String formatTime(Time t){
 
        Integer hour = t.hour();
        Integer minute = t.minute();
 
        String period = hour >= 12 ? 'PM' : 'AM';
 
        if(hour > 12){
            hour -= 12;
        }
 
        if(hour == 0){
            hour = 12;
        }
 
        String min = minute < 10 ? '0' + minute : String.valueOf(minute);
 
        return hour + ':' + min + ' ' + period;
    }
 
 
    public class DriveWrapper{
 
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String venue;
        @AuraEnabled public String driveDate;
        @AuraEnabled public String driveTime;
        @AuraEnabled public Integer joined;
        @AuraEnabled public Integer spotsLeft;
        @AuraEnabled public String imageUrl;
 
    }

    @AuraEnabled(cacheable=true)
    public static List<EcoDrive__c> getDrives(String programId, String name, String city, String state) {
        // Base query filtering by the Master Program
        String query = 'SELECT Id, Name, City__c, State__c FROM EcoDrive__c WHERE EcoProgram__c = :programId';
        
        // Dynamic Filter Logic
        if (String.isNotBlank(name)) {
            String nameLike = '%' + name + '%';
            query += ' AND Name LIKE :nameLike';
        }
        if (String.isNotBlank(city)) {
            query += ' AND City__c = :city';
        }
        if (String.isNotBlank(state)) {
            query += ' AND State__c = :state';
        }
        
        query += ' ORDER BY Name LIMIT 50';
        
        return Database.query(query);
    }

    @AuraEnabled(cacheable=true)
	public static List<EcoProgram__c> getPrograms() {
    return [SELECT Id, Name, Status__c, Launch_Date__c FROM EcoProgram__c ORDER BY CreatedDate DESC LIMIT 10];
	}
	
	@AuraEnabled(cacheable=true)
    public static List<EcoDrive__c> getDrivesByProgram(Id programId) {
        return [
            SELECT Id, Name, 	Drive_Date__c, City__c, State__c, Description__c 
            FROM EcoDrive__c 
            WHERE EcoProgram__c = :programId 
            ORDER BY Drive_Date__c DESC
        ];
    }
 
}