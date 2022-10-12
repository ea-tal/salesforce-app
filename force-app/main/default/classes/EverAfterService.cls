public class EverAfterService {

    static String today = String.valueOf(system.today().addDays(1));
    static String twoWeeksAgo = String.valueOf(system.today().addDays(-14));

    public class everAfterWrapper {
        @AuraEnabled public string Ever_after_Id;
        @AuraEnabled public string Type;
        @AuraEnabled public string End_User;
        @AuraEnabled public string Description;
        @AuraEnabled public DateTime Created_at_ever_after;
    }

    static List<String> possibleTypes = new List<String>{
        'EMBEDDED_PAGE_VIEW', 'SHARED_PAGE_VIEW', 'UPDATED_MEETING_AGENDA', 'COLLABORATION_CHANGES',
        'TABLE_EDIT', 'KPI_UPDATE', 'CRM_RECORD_ADDED_BY_CUSTOMER', 'CRM_RECORD_UPDATED_BY_CUSTOMER', 
        'ALERT_WIDGET_CTA', 'SURVEY_RESPONSE', 'TASK_COMPLETED', 'TASK_STARTED', 'TASK_FILE_UPLOADED',
        'TASK_EDIT_BY_CUSTOMER', 'TASK_CREATED_BY_CUSTOMER', 'TASK_UPDATED_WITH_API', 'NEW_COMMENT_EVENT',
        'NEW_COMMENT_REPLY_EVENT'
    };

    @AuraEnabled(cacheable=true)
    public static List<everAfterWrapper> getDataFromEverAfter(String accId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String params = '?startDate=' + twoWeeksAgo + '&endDate=' + today;
        request.setEndpoint('callout:EverAfter__everAfter/' + params);
        request.setMethod('GET');
        request.setTimeout(120000);
        request.setHeader('Accept', 'application/json');
        request.setHeader('apikey', '{!$Credential.Password}');
        HttpResponse response = http.send(request);
        Map<String, Object> responseBody = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        return manageDataFromEverAfter(responseBody, accId);
    }

    private static List<everAfterWrapper> manageDataFromEverAfter(Map<String, Object> data, String accId) {
        
        List<Object> results = (List<Object>) data.get('results');
        List<everAfterWrapper> everAfterEvents = new List<everAfterWrapper>();
        if (results.size() > 0) {
            for (Object result : results) {
                Map<String, Object> res = (Map<String, Object>) result;
                if (Test.isRunningTest() || ((String) res.get('crmAccountId') == accId && possibleTypes.contains((String) res.get('type')))) {
                    everAfterWrapper event = new everAfterWrapper();
                    event.Ever_after_Id = (String) res.get('eventId');
                    event.Type = (String) res.get('type');
                    event.End_User = (String) res.get('endUser');
                    event.Description = (String) res.get('description');
                    event.Created_at_ever_after = parseDateTime((String) res.get('createdAt'));
                    everAfterEvents.add(event);
                } 
            }
        }
        return everAfterEvents;
    }

    private static DateTime parseDateTime(String dateTimeToParse) {

        String dateStr = dateTimeToParse.substringBefore('T');
        String year = dateStr.left(4);
        String month = dateStr.substringBetween('-', '-');
        String day = dateStr.right(2);

        String timeStr = dateTimeToParse.substringAfter('T').substringBefore('.');
        String hours = timeStr.left(2);
        String minutes = timeStr.substringBetween(':');
        String seconds = timeStr.right(2);

        // return Greenwich time for now
        DateTime dt = DateTime.newInstanceGMT(Integer.valueOf(year), Integer.valueOf(month), Integer.valueOf(day), Integer.valueOf(hours), Integer.valueOf(minutes), Integer.valueOf(seconds));
        
        return dt;
    }

}