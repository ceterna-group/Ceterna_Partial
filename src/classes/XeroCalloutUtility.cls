/**
* @author       Ben Edwards (ben@benedwards.co.nz)
* @description  Handles the physical callout to the Xero API
**/
public with sharing class XeroCalloutUtility {

    /**
    * 	@author Ben Edwards (ben@benedwards.co.nz)
    *	@description Execute the physical callout and return the response
    * 	@return Returns the HttpResponse from the Xero API
    **/
    public static HttpResponse executeCallout (String method, String api, String resourceName, String requestBody) {

        // Instantiate a new request
        HttpRequest request = new HttpRequest();

        // Set request parameters
        request.setMethod(method);
        request.setEndpoint('https://api.xero.com/' + api + '.xro/2.0/' + resourceName);

        // accoutning api: api.xro/2.0/
        // project api: projects.xro/2.0/

        // Accept a JSON response from the call
        request.setHeader('Accept', 'application/json');

        // If the callout includes a body (POST and PUT requests)
        if (String.isNotBlank(requestBody)) {

            // Set the body to the callout
            request.setBody(requestBody);

            // Set the content to XML
//            request.setHeader('Content-Type', 'text/xml');
            request.setHeader('Content-Type', 'text/xml');
        }

        // Sign the request based on OAuth 1.0a
        request = XeroOAuthUtility.signRequest(request, 'KSQGIEYT2ALT3Y2RXBUUF198M9EHFB');

        // Execute callout and return
        return new Http().send(request);
    }

}