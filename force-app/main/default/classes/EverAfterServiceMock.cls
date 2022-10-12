@isTest
global with sharing class EverAfterServiceMock implements HttpCalloutMock {

    class everAfterWrapper {  
        List<EverAfterResult> results;
    }

    class EverAfterResult {
        String eventId;
        String type;
        String endUser;
        String description;
        String createdAt;
    }

    global HTTPResponse respond(HTTPRequest request) {
    
        everAfterWrapper wrapper = new everAfterWrapper();
        List<EverAfterResult> results = new List<EverAfterResult>();
        EverAfterResult result = new EverAfterResult();
        result.eventId = '12345';
        result.type = 'EMBEDDED_PAGE_VIEW';
        result.endUser = 'testUser@gmai.com';
        result.description = 'test';
        result.createdAt = '2022-07-12T07:59:22.524Z';
        results.add(result);
        wrapper.results = results;
        String responseBody = JSON.serialize(wrapper);
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(responseBody);
        response.setStatusCode(200);
        return response; 
    }
}