public with sharing class DriveParticipationController {

    // Define a wrapper to hold the record and the formatted string
    public class ParticipationWrapper {
        @AuraEnabled public Drive_Participation__c participation;
        @AuraEnabled public String formattedStartTime;

        public ParticipationWrapper(Drive_Participation__c p, String fTime) {
            this.participation = p;
            this.formattedStartTime = fTime;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<ParticipationWrapper> getMyParticipations() {
        Id contactId = [
            SELECT ContactId
            FROM User
            WHERE Id = :UserInfo.getUserId()
            LIMIT 1
        ].ContactId;

        List<Drive_Participation__c> records = [
            SELECT
                Id,
                Name,
                Attendance_Status__c,
                Hours_Contributed__c,
                EcoDrive__c,
                EcoDrive__r.Name,
                EcoDrive__r.Start_Date__c,
                EcoDrive__r.Start_Time__c,
                EcoDrive__r.City__c,
                EcoDrive__r.State__c
            FROM Drive_Participation__c
            WHERE Contact__c = :contactId
            ORDER BY CreatedDate DESC
        ];

        List<ParticipationWrapper> wrappedResults = new List<ParticipationWrapper>();

        for (Drive_Participation__c dp : records) {
            String formattedTime = '';
            
            // Apply the utility class logic
            if (dp.EcoDrive__r.Start_Time__c != null) {
                formattedTime = DateTimeUtils.formatTime(dp.EcoDrive__r.Start_Time__c);
            }

            wrappedResults.add(new ParticipationWrapper(dp, formattedTime));
        }

        return wrappedResults;
    }
}