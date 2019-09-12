/**
 * Created by ronanwilliams on 2019-08-30.
 */

public class PreSalesRequestTriggerHandler {

    public static Integer errorCount;
    public static String errors;

    public static void beforeInsert(List<Pre_Sales_Request__c> newRecords) {

    }

    public static void afterInsert(Map<Id, Pre_Sales_Request__c> newRecordMap) {
        handlePost(newRecordMap.keySet());
    }

    public static void beforeUpdate(Map<Id, Pre_Sales_Request__c> newRecordMap, Map<Id, Pre_Sales_Request__c> oldRecordMap) {

    }

    public static void afterUpdate(Map<Id, Pre_Sales_Request__c> newRecordMap, Map<Id, Pre_Sales_Request__c> oldRecordMap) {

    }

    @Future(Callout=true)
    public static void handlePost(Set<Id> recordIds){

        // delcare error handling variables
        errorCount  = 0;
        errors      = '';

        // declare map of all opportunities in trigger
        Map<String,Pre_Sales_Request__c> preSalesRequestMap = new Map<String,Pre_Sales_Request__c>();

        // construct map from database values
        for (Pre_Sales_Request__c psr : [SELECT Id, Name, Opportunity__r.Account.Name, Opportunity__r.Job_Number__c,
                                                MavenlinkId__c, AsanaId__c, Date_Needed__c, Areas__c, Technical_Help_Needed__c
                                        FROM Pre_Sales_Request__c WHERE Id IN :recordIds]){
            preSalesRequestMap.put(psr.Opportunity__r.Job_Number__c + ' - ' + psr.Name, psr);
        }

        // POST RECORD AS WORKSPACE TO MAVENLINK
        HttpRequest mavenlinkRequest = generateMavenLinkRequest(preSalesRequestMap);

        if (mavenlinkRequest != null){
            Http mavenlinkCallout           = new Http();
            HttpResponse mavenlinkResponse  = mavenlinkCallout.send(mavenlinkRequest);

            // now process the body and update the map values
            if (mavenlinkResponse.getStatusCode() == 200) {

                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(mavenlinkResponse.getBody());
                Map<String, Object> resultsMap  = (Map<String, Object>) responseMap.get('tasks');

                for (Object mavelinkProject : resultsMap.values()) {
                    Map<String, Object> recordDetails = (Map<String, Object>) mavelinkProject;
                    if (preSalesRequestMap.containsKey((String)recordDetails.get('title'))) {
                        preSalesRequestMap.get((String)recordDetails.get('title')).MavenlinkId__c = (String)recordDetails.get('id');
                    }  else {
                        errorCount += 1;
                        errors += 'Mavenlink response could not locate ' + (String)recordDetails.get('name') + ' in record map.\n';
                    }
                }
            } else {
                errorCount  += 1;
                errors      += 'PreSalesRequestTriggerHandler: Did not get 200 response for Mavenlink, received ' + mavenlinkResponse.getStatusCode() + '\n';
            }
        }

        // POST RECORD TO PROJECT ASANA
        HttpRequest asanaRequest = generateAsanaRequest(preSalesRequestMap);

        if (asanaRequest != null){
            Http asanaCallout           = new Http();
            HttpResponse asanaResponse  = asanaCallout.send(asanaRequest);

            // now process the body and update the map values
            if (asanaResponse.getStatusCode() == 200) {
                Map<String,Object> responseMap  = (Map<String,Object>) JSON.deserializeUntyped(asanaResponse.getBody());
                List<Object> data               = (List<Object>)responseMap.get('data');

                for (Object dataObj : data) {

                    Map<String,Object> bodyMap          = (Map<String,Object>)dataObj;
                    Map<String,Object> record           = (Map<String,Object>)bodyMap.get('body');
                    Map<String, Object> recordDetails   = (Map<String, Object>) record.get('data');

                    if (recordDetails != null && recordDetails.containsKey('name') && preSalesRequestMap.containsKey((String)recordDetails.get('name'))) {
                        preSalesRequestMap.get((String)recordDetails.get('name')).AsanaId__c = (String)recordDetails.get('gid');
                    } else {
                        errorCount += 1;
                        errors += 'Asana response could not locate ' + (String)recordDetails.get('name') + ' in record map.\n';
                    }
                }
            } else {
                errorCount  += 1;
                errors      += 'PreSalesRequestTriggerHandler: Did not get 200 response for Asana, ' +
                               'received ' + asanaResponse.getStatusCode() + '.\n';
            }
        }

        if (errorCount > 0) IntegrationErrorHandler.sendErrorEmail('PreSalesRequestTriggerHandler', errors, errorCount);

    }

    public static HttpRequest generateMavenLinkRequest(Map<String,Pre_Sales_Request__c> preSalesRequestMap) {

        if (Label.MavenlinkPresalesId != null){

            String preSalesId           = Label.MavenlinkPresalesId;
            List<String> psrJsonStrings = new List<String>();

            for (Pre_Sales_Request__c psr : preSalesRequestMap.values()){
                if (psr.MavenlinkId__c == null){
                    psrJsonStrings.add(
                            '  {'+
                                    '       "title" : "' + psr.Opportunity__r.Job_Number__c + ' - ' + psr.Name + '",' +
                                    '       "workspace_id" : "' + preSalesId + '", ' +
                                    '       "story_type" : "task", ' +
                                    '       "start_date" : "' + String.valueOf(psr.Date_Needed__c) + '",'+
                                    '       "description" : "Support for ' + psr.Areas__c + ', using ' + psr.Technical_Help_Needed__c + '"'+
                                    '  }');
                }
            }

            HttpRequest req = new HttpRequest();

            if (!psrJsonStrings.isEmpty()){
                String workSpaces = '{ ' +
                        '"stories" : ' +
                        '  [' +
                        String.join(psrJsonStrings,',') +
                        '   ]' +
                        '}';

                // construct the Mavenlink request
                req.setEndpoint('https://api.mavenlink.com/api/v1/stories');
                req.setHeader('Accept', 'application/json');
                req.setHeader('Content-type', 'application/json');
                req.setHeader('Authorization', 'Bearer 6830b41a8a0257513aaf4cd0dd99190812b72c4ee8078439f3309faa2868db05');
                req.setMethod('POST');
                req.setBody(workSpaces);

                return req;
            } else {
                return null;
            }
        } else {
            errorCount  += 1;
            errors      += 'Mavenlink Presales Id could not be located in custom settings.<br/>';
            return null;
        }
    }

    public static HttpRequest generateAsanaRequest(Map<String,Pre_Sales_Request__c> preSalesRequestMap){

        if (Label.MavenlinkPresalesId != null) {

            String teamId = Label.AsanaTeamId;

            List<String> psrJsonStrings = new List<String>();

            for (Pre_Sales_Request__c psr : preSalesRequestMap.values()) {
                if (psr.AsanaId__c == null) {
                    psrJsonStrings.add(
                            '{' +
                                    '   "method": "post",' +
                                    '   "relative_path": "/projects",' +
                                    '   "data" : {' +
                                    '       "name" : "' + psr.Opportunity__r.Job_Number__c + ' - ' + psr.Name + '",' +
                                    '       "team" : "' + teamId + '"' +
                                    '   }' +
                                    '}');
                }
            }

            HttpRequest req = new HttpRequest();

            if (!psrJsonStrings.isEmpty()) {
                String batchRequestBody = '{ ' +
                        '   "data": {' +
                        '       "actions": [' +
                        String.join(psrJsonStrings, ',') +
                        '           ]' +
                        '   }' +
                        '}';

                // construct the Asana request
                req.setEndpoint('https://app.asana.com/api/1.0/batch');
                req.setHeader('Accept', 'application/json');
                req.setHeader('Content-type', 'application/json');
                req.setHeader('Authorization', 'Bearer 0/8e1a1ec8f09bb7c93e80376c50f7bcaf');
                req.setMethod('POST');
                req.setBody(batchRequestBody);

                return req;
            } else {
                return null;
            }
        } else {
            errorCount  += 1;
            errors      += 'Asana Tesm Id could not be located in custom settings.<br/>';
            return null;
        }
    }
}