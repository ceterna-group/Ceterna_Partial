/**
 * Created by ronanwilliams on 2019-08-13.
 */

public class OpportunityTriggerHandler {



    public static void beforeInsert(List<Opportunity> newLeads) {

    }

    public static void afterInsert(Map<Id, Opportunity> newRecordMap) {
        generateInvoices(newRecordMap, new Map<Id, Opportunity>());
        handleNewWins(newRecordMap, new Map<Id, Opportunity>());
    }

    public static void beforeUpdate(Map<Id, Opportunity> oldLeadMap, Map<Id, Opportunity> newLeadMap) {

    }

    public static void afterUpdate(Map<Id, Opportunity> newRecordMap, Map<Id, Opportunity> oldRecordMap) {
        generateInvoices(newRecordMap, oldRecordMap);
        handleNewWins(newRecordMap, oldRecordMap);
    }

    public static void handleNewWins(Map<Id, Opportunity> newRecordMap, Map<Id, Opportunity> oldRecordMap){

        Set<Id> postOpportunityIds = new Set<Id>();

        for (Opportunity opp : newRecordMap.values()){
            if (opp.StageName == 'Closed Won' && (!oldRecordMap.containsKey(opp.Id) || oldRecordMap.get(opp.Id).StageName != 'Closed Won')){
                postOpportunityIds.add(opp.Id);
            }
        }

        // todo: add project to Xero



//        if (!RegressionHandler.isAPIUpdate){
//            postRecordToMavenlink(opportunityIds);
//            postProjectToXero(opportunityIds);
//            postRecordToAsana(opportunityIds);
//        }

        if (!postOpportunityIds.isEmpty()){
            postOpportunities(postOpportunityIds);
        }

        // todo: post to Freshdesk if the project is a support client
    }

    public static void generateInvoices(Map<Id, Opportunity> newRecordMap, Map<Id, Opportunity> oldRecordMap){

        List<Invoice__c> newInvoices = new List<Invoice__c>();

        for (Opportunity opp : newRecordMap.values()){
            if (opp.StageName == 'Closed Won' && (!oldRecordMap.containsKey(opp.Id) || oldRecordMap.get(opp.Id).StageName != 'Closed Won')){

            }
        }
    }

    @Future
    public static void postOpportunities(Set<Id> opportunityIds){

        // DECLARE CALLOUT BODIES

        // XERO CUSTOMER BODY

        // XERO PROJECT BODY

        // ASANA PROJECT BODY

        // FRESHDESK CUSTOMER BODY

        // MAVENLINK PROJECT BODY


        // declare map of all opportunities in trigger
        Map<String,Opportunity> opportunityMap = new Map<String,Opportunity>();

        // construct map from database values
        for (Opportunity opp : [SELECT Id, Name, Job_Number__c, Amount, Description, AccountId, Account.XeroContactId__c,
                                        MavenlinkId__c, AsanaId__c, XeroId__c, FreshdeskId__c, Delivery_support__c
                                FROM Opportunity WHERE Id IN :opportunityIds]){
            opportunityMap.put(opp.Job_Number__c + ' - ' + opp.Name,opp);
        }


        // todo: CHECK IF PARENT IS CUSTOMER IN XERO

        // todo: CHECK IF PARENT IS CUSTOMER IN FRESHDESK


        // todo: in each iteration, only add the opp to the callout list if it is missing the required attributes
        // (i.e. it may already have an asana id for example)


        // todo: set Asana team id in custom label so can switch from test to real in prod


        // MAVENLINK

        // call the mavenlink endpoint
        HttpRequest mavenlinkRequest = generateMavenLinkRequest(opportunityMap);

        if (mavenlinkRequest != null){
            Http mavenlinkCallout           = new Http();
            HttpResponse mavenlinkResponse  = mavenlinkCallout.send(mavenlinkRequest);

            // now process the body and update the map values
            if (mavenlinkResponse.getStatusCode() == 200) {

                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(mavenlinkResponse.getBody());
                Map<String, Object> resultsMap  = (Map<String, Object>) responseMap.get('workspaces');

                    for (Object mavelinkProject : resultsMap.values()) {

                    Map<String, Object> recordDetails = (Map<String, Object>) mavelinkProject;
                    if (opportunityMap.containsKey((String)recordDetails.get('title'))) {
                        opportunityMap.get((String)recordDetails.get('title')).MavenlinkId__c = (String)recordDetails.get('id');
                    }
                }
            }
        }

        /// END MAVENLINK


        // POST RECORD TO ASANA


        // UPDATE THE OPP VALUES

    }


    public static HttpRequest generateMavenLinkRequest(Map<String,Opportunity> opportunityMap) {

        List<String> oppJsonStrings     = new List<String>();

        for (Opportunity opp : opportunityMap.values()){
            if (opp.MavenlinkId__c == null){
                oppJsonStrings.add(
                        '  {'+
                        '       "title" : "' + opp.Job_Number__c + ' - ' + opp.Name + '",' +
                        '       "creator_role" : "maven", ' +
                        '       "budgeted" : true, ' +
                        '       "price" : ' + opp.Amount + ','+
                        '       "start_date" : "' + String.valueOf(Date.today()) + '",'+
                        '       "description" : "' + opp.Description + '"'+
                        '  }');
            }
        }

        HttpRequest req = new HttpRequest();

        if (!oppJsonStrings.isEmpty()){
            String workSpaces = '{ ' +
                    '"workspaces" : ' +
                    '  [' +
                    String.join(oppJsonStrings,',') +
                    '   ]' +
                    '}';

            // construct the Mavenlink request
            req.setEndpoint('https://api.mavenlink.com/api/v1/workspaces');
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-type', 'application/json');
            req.setHeader('Authorization', 'Bearer 6830b41a8a0257513aaf4cd0dd99190812b72c4ee8078439f3309faa2868db05');
            req.setMethod('POST');
            req.setBody(workSpaces);

            return req;
        } else {
            return null;
        }
    }


    @Future(Callout=true)
    public static void postProjectToXero(Set<Id> opportunityIds) {

        Map<String,Opportunity> opportunityMap = new Map<String,Opportunity>();

        for (Opportunity opp : [SELECT Id, Name, Job_Number__c, Amount, Description, AccountId, Account.XeroContactId__c
                                FROM Opportunity WHERE Id IN :opportunityIds]){
            opportunityMap.put(opp.Job_Number__c + ' - ' + opp.Name,opp);
        }

        List<String> oppJsonStrings     = new List<String>();

        for (Opportunity opp : opportunityMap.values()){

            oppJsonStrings.add(
                    '  {'+
                    '       "contactId" : "ba8c9d7d-ce04-456b-94dd-4bcb44e4b3ab",' +
                    '       "name" : "' + opp.Job_Number__c + ' - ' + opp.Name + '"' +
                    '  }');
        }

        String projects = '' +
                String.join(oppJsonStrings,',') +
                '';

        // call the Xero endpoint

        HttpResponse response = XeroCalloutUtility.executeCallout('POST', 'projects','Projects', projects);

        system.debug(response.getStatusCode() + ' ' + response.getBody());


        if (response.getStatusCode() == 200) {

//            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
//            Map<String, Object> resultsMap  = (Map<String, Object>) responseMap.get('workspaces');
//
//            for (Object mavelinkProject : resultsMap.values()) {
//
//                Map<String, Object> recordDetails = (Map<String, Object>) mavelinkProject;
//
//                if (opportunityMap.containsKey((String) recordDetails.get('title'))) {
//                    opportunityMap.get((String) recordDetails.get('title')).MavenlinkId__c =
//                            (String) recordDetails.get('id');
//                }
//            }
//
//            RegressionHandler.isAPIUpdate = true;
//            update opportunityMap.values();
        }


    }

    @Future(Callout=true)
    public static void postRecordToMavenlink(Set<Id> opportunityIds) {

        Map<String,Opportunity> opportunityMap = new Map<String,Opportunity>();

        for (Opportunity opp : [SELECT Id, Name, Job_Number__c, Amount, Description
                                FROM Opportunity WHERE Id IN :opportunityIds]){
            opportunityMap.put(opp.Job_Number__c + ' - ' + opp.Name,opp);
        }

        List<String> oppJsonStrings     = new List<String>();

        for (Opportunity opp : opportunityMap.values()){

            oppJsonStrings.add(
                '  {'+
                '       "title" : "' + opp.Job_Number__c + ' - ' + opp.Name + '",' +
                '       "creator_role" : "maven", ' +
                '       "budgeted" : true, ' +
                '       "price" : ' + opp.Amount + ','+
                '       "start_date" : "' + String.valueOf(Date.today()) + '",'+
                '       "description" : "' + opp.Description + '"'+
                '  }');
        }

        String workSpaces = '{ ' +
                '"workspaces" : ' +
                '  [' +
                        String.join(oppJsonStrings,',') +
                '   ]' +
                '}';

        // call the mavenlink endpoint
        Http mavenlinkCallout = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.mavenlink.com/api/v1/workspaces');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-type', 'application/json');
        req.setHeader('Authorization', 'Bearer 6830b41a8a0257513aaf4cd0dd99190812b72c4ee8078439f3309faa2868db05');
        req.setMethod('POST');
        req.setBody(workSpaces);

        HttpResponse res = mavenlinkCallout.send(req);

        system.debug('res is ' + res.getStatusCode() + '  ' + res.getBody());

        if (res.getStatusCode() == 200) {

            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            Map<String, Object> resultsMap  = (Map<String, Object>) responseMap.get('workspaces');

            for (Object mavelinkProject : resultsMap.values()) {

                Map<String, Object> recordDetails = (Map<String, Object>) mavelinkProject;

                if (opportunityMap.containsKey((String) recordDetails.get('title'))) {
                    opportunityMap.get((String) recordDetails.get('title')).MavenlinkId__c =
                            (String) recordDetails.get('id');
                }
            }

            RegressionHandler.isAPIUpdate = true;
            update opportunityMap.values();
        }
    }

    @Future(Callout=true)
    public static void postRecordToAsana(Set<Id> opportunityIds) {

        Map<String,Opportunity> opportunityMap = new Map<String,Opportunity>();

        for (Opportunity opp : [SELECT Id, Name, Job_Number__c, Amount, Description
                                FROM Opportunity WHERE Id IN :opportunityIds]){
            opportunityMap.put(opp.Job_Number__c + ' - ' + opp.Name,opp);
        }

        List<String> oppJsonStrings     = new List<String>();

        for (Opportunity opp : opportunityMap.values()){

            oppJsonStrings.add(
                    '  {'+
                            '       "name" : "' + opp.Job_Number__c + ' - ' + opp.Name + '",' +
                            '       "notes" : "' + opp.Description + '"'+
                            '  }');
        }

        String workSpaces = '{ ' +
                '"workspaces" : ' +
                '  [' +
                String.join(oppJsonStrings,',') +
                '   ]' +
                '}';

        // call the mavenlink endpoint
        Http mavenlinkCallout = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://app.asana.com/api/1.0/projects');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-type', 'application/json');
        req.setHeader('Authorization', 'Bearer 0/8e1a1ec8f09bb7c93e80376c50f7bcaf');
        req.setMethod('POST');
        req.setBody('notes=These are things we want to purchase.&name=Things to Buy&workspace=14916');

        HttpResponse res = mavenlinkCallout.send(req);

        system.debug('res is ' + res.getStatusCode() + '  ' + res.getBody());

        if (res.getStatusCode() == 200) {

            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            Map<String, Object> resultsMap  = (Map<String, Object>) responseMap.get('workspaces');

            for (Object mavelinkProject : resultsMap.values()) {

                Map<String, Object> recordDetails = (Map<String, Object>) mavelinkProject;

                if (opportunityMap.containsKey((String) recordDetails.get('title'))) {
                    opportunityMap.get((String) recordDetails.get('title')).MavenlinkId__c =
                            (String) recordDetails.get('id');
                }
            }

            RegressionHandler.isAPIUpdate = true;
            update opportunityMap.values();
        }

        String teamId = Label.AsanaTeamId;

//
//        // call the mavenlink endpoint
//        Http mavenlinkCallout = new Http();
//        HttpRequest req = new HttpRequest();
////req.setEndpoint('https://app.asana.com/api/1.0/projects');
//        req.setEndpoint('https://app.asana.com/api/1.0/batch');
//        req.setHeader('Accept', 'application/json');
//        req.setHeader('Content-type', 'application/json');
//        req.setHeader('Authorization', 'Bearer 0/8e1a1ec8f09bb7c93e80376c50f7bcaf');
//        req.setMethod('POST');
////req.setBody('notes=These are things we want to purchase.&name=Things to Buy&workspace=14916,notes=These are things we want to purchase.&name=Things to Buy&workspace=14916');
//
//        String body = '{'+
//        '"data": {'+
//        '"actions": ['+
//        '{'+
//        '    "method": "post",'+
//        '    "relative_path": "/projects",' +
//        '"data" : {' +
//        '"name" : "yyy",' +
//        '"team" : 1134872979756503' +
//        '}'+
//        '},' +
//        '{'+
//        '    "method": "post",'+
//        '    "relative_path": "/projects",' +
//        '"data" : {' +
//        '"name" : "xxx",' +
//        '"team" : 1134872979756503' +
//        '}'+
//        '}' +
//        ']' +
//        '}' +
//        '}';
//
//        req.setBody(body);
//
//        HttpResponse res = mavenlinkCallout.send(req);
//
//        system.debug('res is ' + res.getStatusCode() + '  ' + res.getBody());


    }


}