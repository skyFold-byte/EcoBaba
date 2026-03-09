public with sharing class EcoKnowledgeController {
    @AuraEnabled(cacheable=true)
    public static List<Knowledge__kav> getPublishedArticles() {
        // Query articles that are published and in English
        return [SELECT Id, Title, Summary, UrlName 
                FROM Knowledge__kav 
                WHERE PublishStatus = 'Online' 
                AND Language = 'en_US' 
                LIMIT 3];
    }
}