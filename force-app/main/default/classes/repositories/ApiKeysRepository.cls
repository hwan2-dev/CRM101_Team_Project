public with sharing class ApiKeysRepository {
    public static List<API_Keys__mdt> getApiKey(String serviceName) {
        return [SELECT API_Key__c FROM API_Keys__mdt WHERE Service_Name__c = :serviceName LIMIT 1];
    }
}