/**
 * Created by ronanwilliams on 2019-08-21.
 */

public with sharing class OpportunityBinder {

    public static void bind(){

        // retrieve map of all Opportunities by name
        Map<String,Opportunity> opportunityMap = getAllOpportunities();

        // bind mavenlink data
        bindMavenlinkData(opportunityMap);





    }


    @TestVisible
//    private static Map<String,Employee__c> bindMavenlinkData(Map<String,Employee__c> employeeMap){
    private static void bindMavenlinkData(Map<String,Opportunity> opportunityMap){


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

    /*
     *  @method - getAllOpportunities()
     *  @desc - Used to generate an email to employee map which external integrations can reference
     *  @return {Map<String,Employee__c>} - returns a map of all Employee__c records the Email__c as the key
     */
    @TestVisible
    private static Map<String,Opportunity> getAllOpportunities(){

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


    @TestVisible
    public static HttpRequest responseBuilder(String endpoint, String method, String bearer){

        HttpRequest request    = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(method.toUpperCase());
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + bearer);

        return request;
    }


}