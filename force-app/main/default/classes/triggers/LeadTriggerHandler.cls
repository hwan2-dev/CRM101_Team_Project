public with sharing class LeadTriggerHandler {
    
    public static void afterInsert(List<Lead> newLeads) {
        for (Lead lead : newLeads) {
            if (lead.Company != null) {
                NaverNewsApiController.createNewsRecordsForLead(lead.Id, lead.Company);
            }
        }
    }
    
    public static void beforeDelete(List<Lead> oldLeads) {
        List<News_Article__c> articlesToDelete = new List<News_Article__c>();
        
        for (Lead oldLead : oldLeads) {

            articlesToDelete = NewsArticleDAO.getNewsArticleIdByLeadId(oldLead.Id);
            
            if (!articlesToDelete.isEmpty()) {
                delete articlesToDelete;
            }
        }
    }
    
    public static void afterUpdate(List<Lead> newLeads, Map<Id, Lead> oldLeadMap) {
        for (Lead newLead : newLeads) {

            Lead oldLead = oldLeadMap.get(newLead.Id);

            if (newLead.IsConverted == true && oldLead.IsConverted == false) {

                List<News_Article__c> articlesToDelete = new List<News_Article__c>();

                articlesToDelete = NewsArticleDAO.getNewsArticleIdByLeadId(newLead.Id);

                if (!articlesToDelete.isEmpty()) {
                    delete articlesToDelete;
                }
            }
        }
    }
    
}