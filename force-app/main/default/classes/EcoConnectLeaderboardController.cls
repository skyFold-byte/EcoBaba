public without sharing class EcoConnectLeaderboardController {
 
    @AuraEnabled(cacheable=true)
    public static List<Volunteer__c> getTopVolunteers(Integer limitSize) {
 
        if(limitSize == null || limitSize <= 0){
            limitSize = 5;
        }
 
        return [
            SELECT Id, Name, Points__c, City__c, State__c
            FROM Volunteer__c
            WHERE Points__c != null
            ORDER BY Points__c DESC
            LIMIT :limitSize
        ];
    }
}