/**
 * Created by ronanwilliams on 2019-08-01.
 */

public class EmployeeBinder {


    public static void bind(){

        // retrieve map of all employees by email
        Map<String,Employee__c> employeeMap = getAllEmployees();

        // iterate over Mavenlink data
        employeeMap = bindMavenlinkData(employeeMap);

        // iterate over cezanne data



        // iterate over user data and align the Employee__c records with the appropriate Salesforce users
        for (User user : [SELECT Id, Email FROM User]){

            String userEmail = user.Email.replaceAll('.invalid','').toUpperCase();

            if (employeeMap.containsKey(userEmail) &&
                    employeeMap.get(userEmail).User__c != user.Id){
                employeeMap.get(userEmail).User__c = user.Id;
            }
        }

        // upsert Employee__c data
        upsert employeeMap.values();

    }




    /*
     *  @method - getAllEmployees()
     *  @desc - Used to generate an email to employee map which external integrations can reference
     *  @return {Map<String,Employee__c>} - returns a map of all Employee__c records the Email__c as the key
     */
    @TestVisible
    private static Map<String,Employee__c> getAllEmployees(){

        // declare a map of all employees
        Map<String,Employee__c> employeeMap = new Map<String,Employee__c>();

        // query all employees and add them to the map with the email as the key. this will be used by Cezanne and Mavenlink
        // as the unique identifier for each employee
        for (Employee__c employee : [SELECT Id, FirstName__c, LastName__c, Email__c,MavenlinkId__c, MavenlinkActive__c,
                                            MavenlinkPhoto__c, CezanneId__c, ImageLink__c, Position__c, Department__c,
                                            User__c
                                        FROM Employee__c]){
            employeeMap.put(employee.Email__c.toUpperCase(), employee);
        }

        return employeeMap;
    }

    /*
     *  @method - bindMavenlinkData()
     *  @desc - Used to update Employee__c records with the latest Mavenlink User information
     *  @param {Map<String,Employee__c>} employeeMap - a map of all Employee__c records with Email__c as the key
     *  @return {Map<String,Employee__c>} - returns a map of all Employee__c records the Email__c as the key
     */
    @TestVisible
    private static Map<String,Employee__c> bindMavenlinkData(Map<String,Employee__c> employeeMap){

        // call the mavenlink endpoint
        Http mavenlinkCallout = new Http();
        HttpResponse mavenlinkResponse = mavenlinkCallout.send(responseBuilder(
                'https://api.mavenlink.com/api/v1/users.json',
                'GET',
                '6830b41a8a0257513aaf4cd0dd99190812b72c4ee8078439f3309faa2868db05'
        ));


        if (mavenlinkResponse.getStatusCode() == 200){

            // deserialise the response as a generic object. The structure of the JSON response is not usable
            // with any type of Json Parser apex class
            Map<String,Object> responseMap = (Map<String,Object>)JSON.deserializeUntyped(mavenlinkResponse.getBody());
            if (responseMap.containsKey('users')){
                Map<String,Object> userObjects = (Map<String,Object>)responseMap.get('users');

                for (Object userObject : userObjects.values()){
                    Map<String,Object> userValues = (Map<String,Object>)userObject;

                    if (userValues.containsKey('email_address')){
                        String emailString  = (String)userValues.get('email_address');
                        emailString         = emailString.toUpperCase();

                        // if the Emlpoyee__c already exists, update the information
                        if (employeeMap.containsKey(emailString)){
                            employeeMap.get(emailString).MavenlinkId__c     = (String)userValues.get('id');
                            employeeMap.get(emailString).MavenlinkPhoto__c  = (String)userValues.get('photo_path');
                            employeeMap.get(emailString).MavenlinkActive__c = !(Boolean)userValues.get('disabled');
                        } else {
                            // if the Emlpoyee__c does not already exist, create a new one and add it to the map
                            String employeeName         = (String)userValues.get('full_name');
                            Employee__c employee        = new Employee__c(
                                    FirstName__c        = employeeName.split(' ')[0],
                                    LastName__c         = employeeName.split(' ')[1],
                                    MavenlinkId__c      = (String)userValues.get('id'),
                                    MavenlinkPhoto__c   = (String)userValues.get('photo_path'),
                                    MavenlinkActive__c  = !(Boolean)userValues.get('disabled'),
                                    Email__c            = (String)userValues.get('email_address')
                            );

                            employeeMap.put(emailString,employee);
                        }
                    }
                }
            }
        }

        return employeeMap;
    }

    @TestVisible
    private static Map<String,Employee__c> bindCezanneDaya(Map<String,Employee__c> employeeMap){

        HttpRequest authRequest    = new HttpRequest();
        authRequest.setEndpoint('https://w3.cezanneondemand.com/CezanneOnDemand/OAuth/Token');
        authRequest.setMethod('POST');
        authRequest.setHeader('Authorization', 'Basic ');
        authRequest.setHeader('scope', 'http://www.cezannehr.com/auth-scope/APIRead');
        authRequest.setHeader('grant_type', 'client_credentials');




//        authRequest.setHeader('Authorization', 'Bearer ' + bearer);



        return employeeMap;
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