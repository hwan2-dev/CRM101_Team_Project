public with sharing class NaverNewsApiController {
    @AuraEnabled(cacheable=false)
    public static List<Map<String, String>> getNaverNewsList(List<String> paramList, String searchFilter) {
        return NaverNewsApiService.getNaverNewsList(paramList, 5, searchFilter);
    }

    @future(callout=true)   // 비동기 Callout 실행
    public static void createNewsRecordsForLead(Id leadId, String companyName) {
        NaverNewsApiService.createNewsRecordsForLead(leadId, companyName);
    }
}