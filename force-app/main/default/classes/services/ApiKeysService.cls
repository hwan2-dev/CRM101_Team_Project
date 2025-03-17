public with sharing class ApiKeysService {
    public static String getApiKey(String serviceName) {
        List<API_Keys__mdt> keys = ApiKeysRepository.getApiKey(serviceName);
        return (keys.isEmpty()) ? null : keys[0].API_Key__c;
    }
}