/**
 * Created by ronanwilliams on 2019-09-05.
 */

public class MockHandler {


    public static HttpResponse mavenklinkUserMock(){

        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{' +
            '"count":1,' +
            '"results": [{"key":"users","id":"10426325"}],' +
            '"users":{' +
            '   "10426325": {' +
            '       "full_name":"Test Employee",'+
            '       "photo_path":"testpath",' +
            '       "email_address":"testuser@ceterna.com",' +
            '       "disabled":false' +
            '   }' +
            '}');
        return mockResponse;
    }

    public static HttpResponse asanaUserMock(){

        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"data":' +
            '   [' +
            '       {"id":1134872484799893,' +
            '       "gid":"1134872484799893",' +
            '       "email":"testuser@ceterna.com",' +
            '       "name":"Test Employee"}' +
            '   ]}');
        return mockResponse;
    }

    public static HttpResponse freshdeskUserMock(){

        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('[{"available":false,' +
            '   "id":8015345986,' +
            '   "contact":{' +
            '       "email":"testuser@ceterna.com"' +
            '   }' +
            '}]');
        return mockResponse;
    }

}