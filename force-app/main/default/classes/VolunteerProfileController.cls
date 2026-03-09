public with sharing class VolunteerProfileController {
 
    @AuraEnabled(cacheable=true)
    public static VolunteerWrapper getVolunteerProfile() {
 
        Id contactId = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()].ContactId;
 
        Volunteer__c vol = [
            SELECT Id,
                   Name,
                   Email__c,
                   Phone__c,
                   City__c,
                   State__c,
                   Points__c,
                   Total_Hours_Contributed__c,
                   Badge__c,
                   Certificate_Issued__c
            FROM Volunteer__c
            WHERE Contact__c = :contactId
            LIMIT 1
        ];
 
        Integer drives = [
            SELECT COUNT()
            FROM Drive_Participation__c
            WHERE Volunteer__c = :vol.Id
            AND Attendance_Status__c = 'Attended'
        ];
 
        VolunteerWrapper wrap = new VolunteerWrapper();
 
        wrap.name = vol.Name;
        wrap.email = vol.Email__c;
        wrap.phone = vol.Phone__c;
        wrap.city = vol.City__c;
        wrap.state = vol.State__c;
        wrap.points = vol.Points__c;
        wrap.hours = vol.Total_Hours_Contributed__c;
        wrap.badge = vol.Badge__c;
        wrap.certificate = vol.Certificate_Issued__c;
        wrap.drives = drives;
        wrap.volunteerId = vol.Id;
 
        return wrap;
    }
 
    public class VolunteerWrapper {
 
        @AuraEnabled public String name;
        @AuraEnabled public String email;
        @AuraEnabled public String phone;
        @AuraEnabled public String city;
        @AuraEnabled public String state;
        @AuraEnabled public Decimal points;
        @AuraEnabled public Decimal hours;
        @AuraEnabled public String badge;
        @AuraEnabled public Boolean certificate;
        @AuraEnabled public Integer drives;
        @AuraEnabled public Id volunteerId;
 
    }
}