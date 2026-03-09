//class code
//EcoConnectController
 
public with sharing class EcoConnectController {
 
    // Paginated fetch of programmes
    @AuraEnabled(cacheable=true)
    public static List<EcoProgram__c> getProgrammes(Integer pageSize, Integer pageNumber) {
        if (pageSize == null || pageSize <= 0) {
            pageSize = 10; // default page size
        }
        if (pageNumber == null || pageNumber <= 0) {
            pageNumber = 1; // default to first page
        }
 
        Integer offsetSize = (pageNumber - 1) * pageSize;
 
        return [
            SELECT Id, Name, Description__c,Launch_Date__c,
                   City__c, State__c, Status__c
            FROM EcoProgram__c
            ORDER BY Launch_Date__c DESC
            LIMIT :pageSize OFFSET :offsetSize
        ];
    }
 
    @AuraEnabled(cacheable=true)
    public static EcoProgram__c getProgrammeDetails(Id programmeId) {
        return [
            SELECT Id, Name,Description__c,Launch_Date__c,
                    City__c, State__c, Status__c
            FROM EcoProgram__c
            WHERE Id = :programmeId
            LIMIT 1
        ];
    }
 
    // Fetch Action Drives linked to a Programme
    @AuraEnabled(cacheable=true)
    public static List<EcoDrive__c> getActionDrives(Id programmeId) {
        return [
            SELECT Id, Name, Status__c, Start_Date__c,
                   City__c, State__c
            FROM EcoDrive__c
            WHERE EcoProgram__c = :programmeId
            ORDER BY Start_Date__c DESC
        ];
    }
 
    // Optional: Count total programmes for pagination UI
    @AuraEnabled(cacheable=true)
    public static Integer getProgrammeCount() {
        return [SELECT COUNT() FROM EcoProgram__c];
    }
}