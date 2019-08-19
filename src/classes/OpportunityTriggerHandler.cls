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

        Set<Id> opportunityIds = new Set<Id>();

        for (Opportunity opp : newRecordMap.values()){
            if (opp.StageName == 'Closed Won' && (!oldRecordMap.containsKey(opp.Id) || oldRecordMap.get(opp.Id).StageName != 'Closed Won')){
                opportunityIds.add(opp.Id);
            }
        }

        // todo: add project to Xero



//        if (!RegressionHandler.isAPIUpdate){
            postRecordToMavenlink(opportunityIds);
            postProjectToXero(opportunityIds);
            postRecordToAsana(opportunityIds);
//        }
    }

    public static void generateInvoices(Map<Id, Opportunity> newRecordMap, Map<Id, Opportunity> oldRecordMap){

        List<Invoice__c> newInvoices = new List<Invoice__c>();

        for (Opportunity opp : newRecordMap.values()){
            if (opp.StageName == 'Closed Won' && (!oldRecordMap.containsKey(opp.Id) || oldRecordMap.get(opp.Id).StageName != 'Closed Won')){

                // create entries based on invoice schedule type

            }
        }




//        Invoice__c invoice


    }


    @Future(Callout=true)
    public static void postProjectToXero(Set<Id> opportunityIds) {

        Map<String,Opportunity> opportunityMap = new Map<String,Opportunity>();

        for (Opportunity opp : [SELECT Id, Name, JobNumber__c, Amount, Description, AccountId, Account.XeroContactId__c
                                FROM Opportunity WHERE Id IN :opportunityIds]){



            opportunityMap.put(opp.JobNumber__c + ' - ' + opp.Name,opp);
        }




        List<String> oppJsonStrings     = new List<String>();

        for (Opportunity opp : opportunityMap.values()){

            oppJsonStrings.add(
                    '  {'+
                    '       "contactId" : "ba8c9d7d-ce04-456b-94dd-4bcb44e4b3ab",' +
                    '       "name" : "' + opp.JobNumber__c + ' - ' + opp.Name + '"' +
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

        for (Opportunity opp : [SELECT Id, Name, JobNumber__c, Amount, Description
                                FROM Opportunity WHERE Id IN :opportunityIds]){
            opportunityMap.put(opp.JobNumber__c + ' - ' + opp.Name,opp);
        }

        List<String> oppJsonStrings     = new List<String>();

        for (Opportunity opp : opportunityMap.values()){

            oppJsonStrings.add(
                '  {'+
                '       "title" : "' + opp.JobNumber__c + ' - ' + opp.Name + '",' +
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

        for (Opportunity opp : [SELECT Id, Name, JobNumber__c, Amount, Description
        FROM Opportunity WHERE Id IN :opportunityIds]){
            opportunityMap.put(opp.JobNumber__c + ' - ' + opp.Name,opp);
        }

        List<String> oppJsonStrings     = new List<String>();

        for (Opportunity opp : opportunityMap.values()){

            oppJsonStrings.add(
                    '  {'+
                            '       "title" : "' + opp.JobNumber__c + ' - ' + opp.Name + '",' +
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
    }


}