public with sharing class NewsArticleRepository {
    public static List<News_Article__c> getNewsArticleIdByLeadId(String leadId) {
        return [SELECT Id
        FROM News_Article__c
        WHERE Lead__c = :leadId];
    }
}