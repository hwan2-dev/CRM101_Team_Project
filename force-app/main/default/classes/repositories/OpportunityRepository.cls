public with sharing class OpportunityRepository {
    // 창환
    public static List<Opportunity> getOpportunitiesByStatus(String status) {
        return [SELECT Account.Name FROM Opportunity 
                WHERE Enter_Or_Not__c = :status
                AND OwnerId = :UserInfo.getUserId()];
    }
}