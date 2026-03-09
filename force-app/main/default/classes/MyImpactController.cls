public with sharing class MyImpactController {
 
    @AuraEnabled(cacheable=true)
    public static ImpactWrapper getMyImpact() {
 
        Id userId = UserInfo.getUserId();
 
        User u = [
            SELECT Id, ContactId
            FROM User
            WHERE Id = :userId
            LIMIT 1
        ];
 
        if(u.ContactId == null){
            return new ImpactWrapper();
        }
 
        Volunteer__c vol = [
            SELECT Id,
                   Total_Hours_Contributed__c,
                   Points__c,
                   Badge__c,
                   Certificate_Issued__c
            FROM Volunteer__c
            WHERE Contact__c = :u.ContactId
            LIMIT 1
        ];
 
        ImpactWrapper wrap = new ImpactWrapper();
        wrap.volunteerId = vol.Id;
        wrap.totalHours = vol.Total_Hours_Contributed__c;
        wrap.totalPoints = vol.Points__c;
        wrap.badge = vol.Badge__c;
        wrap.badgeImage = getBadgeImage(vol.Badge__c);
        wrap.progressPercent = calculateProgress(vol.Points__c);
        wrap.certificateAvailable = vol.Certificate_Issued__c;
 
        return wrap;
    }
 
    private static Decimal calculateProgress(Decimal points){
 
        if(points == null) return 0;
 
        Decimal nextLevel;
 
        if(points >= 100) return 100;
        if(points >= 50) nextLevel = 100;
        else if(points >= 20) nextLevel = 50;
        else nextLevel = 20;
 
        return (points / nextLevel) * 100;
    }
 
    private static String getBadgeImage(String badge){
 
        if(badge == 'Platinum Champion')
            return '/resource/platinum_badge';
 
        if(badge == 'Gold Warrior')
            return '/resource/gold_badge';
 
        if(badge == 'Silver Hero')
            return '/resource/silver_badge';
 
        return '/resource/bronze_badge';
    }
 
    public class ImpactWrapper {
        @AuraEnabled public Id volunteerId;
        @AuraEnabled public Decimal totalHours;
        @AuraEnabled public Decimal totalPoints;
        @AuraEnabled public String badge;
        @AuraEnabled public String badgeImage;
        @AuraEnabled public Decimal progressPercent;
        @AuraEnabled public Boolean certificateAvailable;
    }
}