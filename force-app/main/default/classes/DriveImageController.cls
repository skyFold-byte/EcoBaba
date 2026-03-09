public without sharing class DriveImageController {
    
    @AuraEnabled
    public static String generatePublicImageUrl(Id driveId, Id documentId) {
        // 1. Delete old images/distributions linked to this record
        List<ContentDocumentLink> oldLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :driveId AND ContentDocumentId != :documentId];
        if(!oldLinks.isEmpty()) {
            Set<Id> docIds = new Set<Id>();
            for(ContentDocumentLink l : oldLinks) docIds.add(l.ContentDocumentId);
            delete [SELECT Id FROM ContentDocument WHERE Id IN :docIds];
        }

        // 2. Get the Version ID for the new document
        ContentVersion cv = [SELECT Id, Title FROM ContentVersion WHERE ContentDocumentId = :documentId AND IsLatest = true LIMIT 1];

        // 3. Create Public Distribution
        ContentDistribution dist = new ContentDistribution(
            Name = cv.Title,
            ContentVersionId = cv.Id,
            PreferencesAllowViewInBrowser = true,
            PreferencesNotifyOnVisit = false
        );
        insert dist;

        // 4. Get Download URL and update EcoDrive
        dist = [SELECT ContentDownloadUrl FROM ContentDistribution WHERE Id = :dist.Id];
        String imageUrl = dist.ContentDownloadUrl.substring(dist.ContentDownloadUrl.indexOf('/sfc'));

        update new EcoDrive__c(Id = driveId, Drive_Image_URL__c = imageUrl);
        return imageUrl;
    }

    @AuraEnabled(cacheable=true)
    public static String getDriveImage(Id recordId) {
        return [SELECT Drive_Image_URL__c FROM EcoDrive__c WHERE Id = :recordId LIMIT 1].Drive_Image_URL__c;
    }
}