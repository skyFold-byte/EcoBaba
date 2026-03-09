public with sharing class VolunteerWelcomeController {
 
    @AuraEnabled(cacheable=true)
    public static String getVolunteerName() {
 
        User u = [
            SELECT FirstName
            FROM User
            WHERE Id = :UserInfo.getUserId()
        ];
 
        return u.FirstName;
 
    }
}