public without sharing class EcoProgramController {
    @AuraEnabled(cacheable=true)
    public static List<EcoProgram__c> getPrograms(String status) {
        // Now running in System Mode; bypassing all sharing and FLS checks
        return [SELECT Id, Name, Status__c, Program_Image_URL__c 
                FROM EcoProgram__c 
                WHERE Status__c = :status 
                ORDER BY Name ASC];
    }
}