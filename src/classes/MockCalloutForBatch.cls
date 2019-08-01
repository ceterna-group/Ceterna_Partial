@isTest
global class MockCalloutForBatch implements HttpCalloutMock
{
    global HTTPResponse respond(HTTPRequest req) 
    {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"success":true}]');
        res.setStatusCode(200);
        return res;
    }
}