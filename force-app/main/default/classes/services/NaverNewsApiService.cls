public with sharing class NaverNewsApiService {
    
    public static List<Map<String, String>> getNaverNewsList(List<String> paramList, Integer newsLimit, String searchFilter) {
        
        if (!paramList.isEmpty()) {
            List<Map<String, String>> articles = new List<Map<String, String>>();
            
            for (String param : paramList) {
                List<Object> resultList = NaverNewsApiRest.callNaverNewsApi(param, newsLimit, searchFilter);
                
                for (Object result : resultList) {
                    Map<String, String> news = new Map<String, String> ();
                    
                    Map<String, Object> resultMap = (Map<String, Object>) result;
                    
                    String title = NaverNewsApiService.decodeHtmlEntities((String) resultMap.get('title'));
                    String description = NaverNewsApiService.decodeHtmlEntities((String) resultMap.get('description'));
                    String link = (String) resultMap.get('link');
                    
                    news.put('title', title);
                    news.put('description', description);
                    news.put('link', link);
                    
                    articles.add(news);
                }
            }
            return articles;
        }
        else {
            // 선택된 매장이 없을 경우 null 반환
            return null;
        }
    }
    
    
    public static DateTime parseDate(String pubDate) {
        
        String[] dateParts = pubDate.split(' ');
        
        String month = convertMonth(dateParts[2]);
        
        String formattedDate = dateParts[3] + '-' + month + '-' + dateParts[1] + ' ' + dateParts[4];
        
        
        try {
            DateTime parsedDate = DateTime.valueOfGmt(formattedDate);
            return parsedDate;
        } catch (Exception e) {
            System.debug('[error] DateTime 변환 오류 발생: ' + e.getMessage());
            return null;
        }
    }
    
    public static String convertMonth(String month) {
        Map<String, String> monthMap = new Map<String, String>{
            'Jan' => '01', 'Feb' => '02', 'Mar' => '03', 'Apr' => '04',
            'May' => '05', 'Jun' => '06', 'Jul' => '07', 'Aug' => '08',
            'Sep' => '09', 'Oct' => '10', 'Nov' => '11', 'Dec' => '12'
        };
        return monthMap.containsKey(month) ? monthMap.get(month) : '01';
    }
    
    public static String decodeHtmlEntities(String input) {
        if (input == null) {
            return '';
        }
        return input.replace('<b>', '')
            .replace('</b>', '')
            .replace('&quot;', '"')
            .replace('&amp;', '&')
            .replace('&lt;', '<')
            .replace('&gt;', '>')
            .replace('&apos;', '\'');
    }
    
    public static void createNewsRecordsForLead(Id leadId, String companyName) {
        // 네이버 뉴스 API 조회(키워드, 가져올 기사 개수, 최신순)
        List<Object> items = NaverNewsApiRest.callNaverNewsApi(companyName, 5, 'sim');
        
        if(items != null && !items.isEmpty()) {
            
            List<News_Article__c> newsList = new List<News_Article__c>();
            
            for (Object obj : items) {
                
                Map<String, Object> item = (Map<String, Object>) obj;
                
                // 뉴스 커스텀 오브젝트 객체 생성
                News_Article__c news = new News_Article__c();
                
                // 룩업 필드에 Lead Id 입력
                news.Lead__c = leadId;
                news.Name = decodeHtmlEntities((String) item.get('title'));
                news.Description__c =  decodeHtmlEntities((String) item.get('description'));
                news.URL__c = (String) item.get('link');
                
                String pubDateStr = (String) item.get('pubDate');
                try {
                    // DateTime으로 형변환
                    DateTime publishedDate = parseDate(pubDateStr);
                    news.Published_Date__c = publishedDate;
                } catch (Exception e) {
                    System.debug('[error] DateTime 변환 오류 발생: ' + e.getMessage());
                }
                newsList.add(news);
            }
            // 뉴스 커스텀 오브젝트에 insert
            insert newsList;
        }
    }
    
}