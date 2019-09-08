/**
 * Created by ronanwilliams on 2019-08-21.
 */

public with sharing class OpportunityBinder {

    public static void bind(){

        // retrieve map of all Opportunities by name
        Map<String,Opportunity> opportunityMap = getAllOpportunities();

        // bind mavenlink data
        bindMavenlinkData(opportunityMap);


        // todo: report mavenlink names



        // ----- BINDINGS --------

        // ACCOUNTS
        // todo: bind freshdesk data to Accounts by name
        // todo: bind xero company names to Account by name



        // ----- DATA POSTING -------

        // Fresdesk
        // todo: post any accounts flagged as support client which do not have an id

        // xero - account
        // todo:  - for the parent
        //  of any job from start of 2019 onwards, if it is not in xero then post

        // xero - opportunity
        // todo: post any won opps from 2019 to xero as projects

        // adana - opportunity
        // todo: post any won opps from 2019 to asana as projects


        // ---- FRESHDESK BINDINGS ------
        // todo: update existing freshdesk tickets with their company id
        // todo: pair the tickets with their account if not already parented using the lookup

        // todo: post any tickets to asana if assigned to employee__c with asana id

        // HOW TO PAIR TICKET WITH PROJECT?






    }


//    private static Map<String,Employee__c> bindMavenlinkData(Map<String,Employee__c> employeeMap){
    public static void bindMavenlinkData(Map<String,Opportunity> opportunityMap){


        // call the mavenlink endpoint
        Http mavenlinkCallout = new Http();
        HttpResponse mavenlinkResponse = mavenlinkCallout.send(responseBuilder(
                'https://api.mavenlink.com/api/v1/workspaces.json?per_page=200',
                'GET',
                '6830b41a8a0257513aaf4cd0dd99190812b72c4ee8078439f3309faa2868db05'
        ));


        if (mavenlinkResponse.getStatusCode() == 200){

            // deserialise the response as a generic object. The structure of the JSON response is not usable
            // with any type of Json Parser apex class
            Map<String,Object> responseMap = (Map<String,Object>)JSON.deserializeUntyped(mavenlinkResponse.getBody());


            Integer totalFalse = 0;
            Integer totalTrue = 0;

            system.debug('mav res map ' + responseMap);

            if (responseMap.containsKey('workspaces')){
                Map<String,Object> projectObjects = (Map<String,Object>)responseMap.get('workspaces');

//                Object obj =
//                Map<String,Object> objMap = (Map<String,Object>)projectObjects[0];
//
//                for (String key : obj.keySet()){
//                    system.debug(key + ' : ' + obj.get(key));
//                }

                for (Object projectObject : projectObjects.values()){


//                    System.debug(projectObject);

                    Map<String,Object> projectValues = (Map<String,Object>)projectObject;

//                    system.debug(opportunityMap.containsKey((String)projectValues.get('title')) + ' : ' + projectValues.get('title'));

                    if (opportunityMap.containsKey((String)projectValues.get('title'))){
                        totalTrue += 1;
                    } else {
                        totalFalse += 1;
                        system.debug((String)projectValues.get('title'));
                    }

                }
            }

//            system.debug('totalTrue ' + totalTrue);
//            system.debug('totalFalse ' + totalFalse);
        }


    }

    public static void bindFreshdeskCompaniesToAccounts(){


        Map<String,Account> accountMap = new Map<String,Account>();

        for (Account acc : [SELECT Name, Support_Name__c FROM Account
                            WHERE Support_Name__c = NULL]){
            accountMap.put(acc.Name.toUpperCase(), acc);
        }

        // call the mavenlink endpoint
        Http freshdeskCallout = new Http();
        HttpResponse freshdeskResponse = freshdeskCallout.send(responseBuilder(
                'https://ceterna.freshdesk.com/api/v2/companies',
                'GET',
                'Basic Y2hhcmxpZUBjZXRlcm5hLmNvbTpDRVRFUk5BNC4x'
        ));

        system.debug(freshdeskResponse.getStatusCode());
        system.debug(freshdeskResponse.getBody());


        if (freshdeskResponse.getStatusCode() == 200) {

            // bind ids to names
            List<Object> companyObjects = (List<Object>)JSON.deserializeUntyped(freshdeskResponse.getBody());

            for (Object companyObject : companyObjects){

                system.debug('obj : ' + companyObject);

                Map<String,Object> objValues = (Map<String,Object>)companyObject;
                String name = (String)objValues.get('name');
                if (accountMap.containsKey(name.toUpperCase())){
                    accountMap.get(name.toUpperCase()).Support_Name__c = (String)objValues.get('id');
                }
            }

        }

        update accountMap.values();

    }



    /*
     *  @method - getAllOpportunities()
     *  @desc - Used to generate an email to employee map which external integrations can reference
     *  @return {Map<String,Employee__c>} - returns a map of all Employee__c records the Email__c as the key
     */
    public static Map<String,Opportunity> getAllOpportunities(){

        // declare a map of all employees
        Map<String,Opportunity> opportunityMap = new Map<String,Opportunity>();

        // query all employees and add them to the map with the email as the key. this will be used by Cezanne and Mavenlink
        // as the unique identifier for each employee
        for (Opportunity opp : [SELECT Id, Job_Number__c, MavenlinkId__c, Name
                                    FROM Opportunity]){
            opportunityMap.put(opp.Name, opp);
        }

        return opportunityMap;
    }


    public static HttpRequest responseBuilder(String endpoint, String method, String bearer){

        HttpRequest request    = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(method.toUpperCase());
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + bearer);

        return request;
    }


}