public without sharing class EcoDashboardController {
 
    @AuraEnabled(cacheable=true)
    public static EcoStats getDashboardStats() {
 
        EcoStats stats = new EcoStats();
 
        stats.totalDrives = [SELECT COUNT() FROM EcoDrive__c];
        stats.activeDrives = [SELECT COUNT() FROM EcoDrive__c WHERE Status__c = 'Open'];
        stats.totalVolunteers = [SELECT COUNT() FROM Volunteer__c];
        stats.totalParticipations = [SELECT COUNT() FROM Drive_Participation__c];
 
        return stats;
    }
 
    public class EcoStats {
        @AuraEnabled public Integer totalDrives;
        @AuraEnabled public Integer activeDrives;
        @AuraEnabled public Integer totalVolunteers;
        @AuraEnabled public Integer totalParticipations;
    }
}