public with sharing class NaverNewsApiRest {
    public static List<Object> callNaverNewsApi(String keyword, Integer newsLimit, String searchFilter) {
        String clientId = ApiKeysService.getApiKey('NaverNewsAPI_Client_ID');
        if (clientId == null) {
            System.debug('[error] NaverNewsAPI_Client_ID 가 존재하지 않습니다.');
            return null;
        }
        String clientSecret = ApiKeysService.getApiKey('NaverNewsAPI_Client_Secret');
        if (clientId == null) {
            System.debug('[error] NaverNewsAPI_Client_Secret 가 존재하지 않습니다.');
            return null;
        }
        
        // url에 사용하기 위해서 keyword를 UTF-8로 인코딩
        String encodedQuery = EncodingUtil.urlEncode(keyword, 'UTF-8');
        // url 생성
        String url = 'https://openapi.naver.com/v1/search/news.json?query=' + encodedQuery + '&display=' + newsLimit + '&sort=' + searchFilter;
        // query : 키워드 | display : 몇 개 보여줄지 | sort : {sim : 정확도 순, date : 날짜순}
        
        // HTTP 요청 객체 생성
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        
        // 네이버 API 인증 헤더 추가
        req.setHeader('X-Naver-Client-Id', clientId);
        req.setHeader('X-Naver-Client-Secret', clientSecret);
        
        // HTTP 요청 실행
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {   // 요청 성공
            
            // JSON 타입인 결괏값 res를 Map<String, Object> 타입으로 변환
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            
            // responseMap의 'items' 키의 값(=뉴스 데이터)을 가져와서 저장
            List<Object> items = (List<Object>) responseMap.get('items');
            
            return items;
        } else {    // 요청 실패
            return null;
        }
    }
}