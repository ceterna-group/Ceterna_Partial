/**
 * Created by ronanwilliams on 2019-08-13.
 */

public class OpportunityTriggerHandler {



    public static void beforeInsert(List<Opportunity> newRecords) {

    }

    public static void afterInsert(Map<Id, Opportunity> newRecordMap) {
        generateInvoices(newRecordMap, new Map<Id, Opportunity>());
        handleNewWins(newRecordMap, new Map<Id, Opportunity>());
    }

    public static void beforeUpdate(Map<Id, Opportunity> newRecordMap, Map<Id, Opportunity> oldRecordMap) {

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

        if (!postOpportunityIds.isEmpty()){
            postOpportunities(postOpportunityIds);
        }
    }

    public static void generateInvoices(Map<Id, Opportunity> newRecordMap, Map<Id, Opportunity> oldRecordMap){

        List<Invoice__c> newInvoices = new List<Invoice__c>();

        for (Opportunity opp : newRecordMap.values()){
            if (opp.StageName == 'Closed Won' && (!oldRecordMap.containsKey(opp.Id) || oldRecordMap.get(opp.Id).StageName != 'Closed Won')){

            }
        }
    }

    @Future(Callout=true)
    public static void postOpportunities(Set<Id> opportunityIds){

        // declare map of all opportunities in trigger
        Map<String,Opportunity> opportunityMap = new Map<String,Opportunity>();

        // construct map from database values
        for (Opportunity opp : [SELECT Id, Name, Job_Number__c, Amount, Description,
                                        AccountId, Account.Name, Account.XeroContactId__c, Account.Website,
                                        Account.BillingStreet, Account.BillingPostalCode, Account.BillingCountry,
                                        Account.BillingState, Account.BillingCity, Account.Registered_Company_Number__c,
                                        Account.Phone,
                                        MavenlinkId__c, AsanaId__c, XeroId__c, FreshdeskId__c, Delivery_support__c
                                FROM Opportunity WHERE Id IN :opportunityIds]){
            opportunityMap.put(opp.Job_Number__c + ' - ' + opp.Name,opp);
        }

        // POST RECORD AS WORKSPACE TO MAVENLINK
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

        // POST RECORD TO PROJECT ASANA
        HttpRequest asanaRequest = generateAsanaRequest(opportunityMap);

        if (asanaRequest != null){
            Http asanaCallout           = new Http();
            HttpResponse asanaResponse  = asanaCallout.send(asanaRequest);

            System.debug('asana res code ' + asanaResponse.getStatusCode());
            System.debug('asana res code ' + asanaResponse.getBody());


            // now process the body and update the map values
            if (asanaResponse.getStatusCode() == 200) {
                Map<String,Object> responseMap  = (Map<String,Object>) JSON.deserializeUntyped(asanaResponse.getBody());
                List<Object> data               = (List<Object>)responseMap.get('data');

                for (Object dataObj : data) {

                    Map<String,Object> bodyMap          = (Map<String,Object>)dataObj;
                    Map<String,Object> record           = (Map<String,Object>)bodyMap.get('body');
                    Map<String, Object> recordDetails   = (Map<String, Object>) record.get('data');

                    if (recordDetails != null && recordDetails.containsKey('name') && opportunityMap.containsKey((String)recordDetails.get('name'))) {
                        opportunityMap.get((String)recordDetails.get('name')).AsanaId__c = (String)recordDetails.get('gid');
                    }
                }
            }
        }

        // POST RECORD AS PROJECT TO XERO
        Map<Id,Account> newCustomers = new Map<Id,Account>();

        for (Opportunity opp : opportunityMap.values()){
            // if the opportunity Account does not exist in Xero, add a new customer
            if (!newCustomers.containsKey(opp.AccountId) && (opp.Account.XeroContactId__c == null || opp.Account.XeroContactId__c == 'RETRY')){
                // post opp account

                String accountJson = '{ ' +
                        '   "Name" : "' + opp.Account.Name + '",' +
                        '   "ContactStatus" : "ACTIVE",' +
                        '   "Phones" : [{' +
                        '       "PhoneType" : "DEFAULT", ' +
                        '       "PhoneNumber" : "' + (opp.Account.Phone == null ? '' : opp.Account.Phone) + '" ' +
                        '   }],' +
                        '   "Addresses" : [{' +
                        '       "AddressType" : "POBOX",' +
                        '       "AddressLine 1" : "' + (opp.Account.BillingStreet == null ? '' : opp.Account.BillingStreet) + '",' +
                        '       "City" : "' + (opp.Account.BillingCity == null ? '' : opp.Account.BillingCity) + '",' +
                        '       "Region" : "' + (opp.Account.BillingState == null ? '' : opp.Account.BillingState) + '",' +
                        '       "Country" : "' + (opp.Account.BillingCountry == null ? '' : opp.Account.BillingCountry) + '",' +
                        '       "PostalCode" : "' + (opp.Account.BillingPostalCode == null ? '' : opp.Account.BillingPostalCode) + '"' +
                        '   }]' +
                        '}';
                HttpResponse xeroContactResponse = XeroCalloutUtility.executeCallout('POST', 'api','Contacts', accountJson);

                System.debug('xero contact response is ' + xeroContactResponse.getStatusCode());


                if (xeroContactResponse != null && xeroContactResponse.getStatusCode() == 200){
                    Map<String,Object> valueMap = (Map<String,Object>) JSON.deserializeUntyped(xeroContactResponse.getBody());

                    system.debug('valueMap is '+ valueMap.keySet());

                    opp.Account.XeroContactId__c = valueMap.containsKey('Id') ? (String)valueMap.get('Id') : 'RETRY';
                    newCustomers.put(opp.AccountId, new Account(Id = opp.AccountId, XeroContactId__c = opp.Account.XeroContactId__c));
                    System.debug('first opp acc id is ' + opp.Account.XeroContactId__c + ' n contains key ' + valueMap.containsKey('Id'));

                }
            }

            System.debug('then opp acc id is ' + opp.Account.XeroContactId__c);

            if ((opp.XeroId__c == null || opp.XeroId__c == 'RETRY') &&
                    (opp.Account.XeroContactId__c != null && opp.Account.XeroContactId__c != 'RETRY')){

//                String projectJson = '  { "contactId" : "' + opp.Account.XeroContactId__c + '",' +
                String projectJson = '  { "contactId" : "1b3eebf9-995a-4fb1-bdaf-71fd6f33e088",' +
                                     '    "name" : "' + opp.Job_Number__c + ' - ' + opp.Name + '"}';
                HttpResponse xeroProjectResponse = XeroCalloutUtility.executeCallout('POST', 'projects','Projects', projectJson);

                system.debug(xeroProjectResponse.getStatusCode());
                system.debug(xeroProjectResponse.getBody());

                if (xeroProjectResponse != null && xeroProjectResponse.getStatusCode() == 201){
                    Map<String,Object> valueMap = (Map<String,Object>) JSON.deserializeUntyped(xeroProjectResponse.getBody());
                    opp.XeroId__c = valueMap.containsKey('projectId') ? (String)valueMap.get('projectId') : 'RETRY';

                }
            }
        }

        update newCustomers.values();


        // GENERATE REQUEST FOR ANY RECORDS MISSING CUSTOMER ID


        // UPDATE THE OPP VALUES
        update opportunityMap.values();

        System.debug([SELECT Id, AsanaId__c, MavenlinkId__c, XeroId__c, Account.XeroContactId__c FROM Opportunity WHERE Id = '0062f000002f4JOAAY']);
        System.debug([SELECT Id, AsanaId__c, MavenlinkId__c, XeroId__c, Account.XeroContactId__c FROM Opportunity WHERE Id = '0062f000003HQ80AAG']);

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

    public static HttpRequest generateAsanaRequest(Map<String,Opportunity> opportunityMap){

        String teamId = Label.AsanaTeamId;

        List<String> oppJsonStrings     = new List<String>();

        for (Opportunity opp : opportunityMap.values()){
            if (opp.AsanaId__c == null){
                oppJsonStrings.add(
                        '{'+
                        '   "method": "post",'+
                        '   "relative_path": "/projects",' +
                        '   "data" : {' +
                        '       "name" : "' + opp.Job_Number__c + ' - ' + opp.Name + '",' +
                        '       "team" : "' + teamId + '"' +
                        '   }'+
                        '}');
            }
        }

        HttpRequest req = new HttpRequest();

        if (!oppJsonStrings.isEmpty()){
            String batchRequestBody = '{ ' +
                    '   "data": {'+
                    '       "actions": ['+
                                String.join(oppJsonStrings,',') +
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

    }
}