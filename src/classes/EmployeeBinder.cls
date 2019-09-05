/**
 * Created by ronanwilliams on 2019-08-01.
 */

public class EmployeeBinder {


    public static void bind(){

        // retrieve map of all employees by email
        Map<String,Employee__c> employeeMap = getAllEmployees();

        // iterate over Mavenlink data
        employeeMap = bindMavenlinkData(employeeMap);

        // iterate over Cezanne data
        employeeMap = bindCezanneData(employeeMap);

        // iterate over Asana data
        employeeMap = bindAsanaData(employeeMap);

        // iterate over Freshdesk data
        employeeMap = bindFreshdeskData(employeeMap);

        // iterate over Salesforce User data
        employeeMap = bindUserData(employeeMap);

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
        HttpResponse mavenlinkResponse = Test.isRunningTest() ?
                MockHandler.mavenklinkUserMock() :
                mavenlinkCallout.send(responseBuilder(
                'https://api.mavenlink.com/api/v1/users.json?per_page=200',
                'GET',
                'Bearer 6830b41a8a0257513aaf4cd0dd99190812b72c4ee8078439f3309faa2868db05'
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
    private static Map<String,Employee__c> bindAsanaData(Map<String,Employee__c> employeeMap){

        // because asana does not provide the employee email, create a map of name to email
        Map<String,String> nameEmailMap = new Map<String,String>();

        for (Employee__c employee : employeeMap.values()){
            if (employee.FirstName__c != null && employee.LastName__c != null){
                nameEmailMap.put(employee.FirstName__c.toUpperCase() + ' ' + employee.LastName__c.toUpperCase(),employee.Email__c.toUpperCase());
            }
        }

        // call the Asana endpoint
        Http asanaCallout = new Http();
        HttpResponse asanaResponse = Test.isRunningTest() ?
                MockHandler.asanaUserMock() :
                asanaCallout.send(responseBuilder(
                'https://app.asana.com/api/1.0/users?opt_fields=name,email',
                'GET',
                'Bearer 0/8e1a1ec8f09bb7c93e80376c50f7bcaf'
        ));

        if (asanaResponse.getStatusCode() == 200){

            system.debug(asanaResponse.getBody());

            // deserialise the response as a generic object
            Map<String,Object> responseMap = (Map<String,Object>)JSON.deserializeUntyped(asanaResponse.getBody());
            if (responseMap.containsKey('data')){
                List<Object> userObjects = (List<Object>)responseMap.get('data');

                for (Object userObject : userObjects){
                    Map<String,Object> userValues = (Map<String,Object>)userObject;

                    if (userValues.containsKey('name')){
                        String nameString  = (String)userValues.get('name');
                        nameString         = nameString.toUpperCase();

                        // if the Emlpoyee__c already exists, update the information
                        if (employeeMap.containsKey(nameString)){
                            employeeMap.get(nameString).AsanaId__c = (String)userValues.get('gid');
                        } else if (nameEmailMap.containsKey(nameString)){
                            employeeMap.get(nameEmailMap.get(nameString)).AsanaId__c = (String)userValues.get('gid');
                        }
                    }
                }
            }
        }

        return employeeMap;
    }

    @TestVisible
    private static Map<String,Employee__c> bindFreshdeskData(Map<String,Employee__c> employeeMap){

        // call the Freshdesk endpoint
        Http freshdeskCallout = new Http();
        HttpResponse freshdeskResponse = Test.isRunningTest() ?
                MockHandler.freshdeskUserMock() :
                freshdeskCallout.send(responseBuilder(
                'https://ceterna.freshdesk.com/api/v2/agents',
                'GET',
                'Basic Y2hhcmxpZUBjZXRlcm5hLmNvbTpDRVRFUk5BNC4x'
        ));

        if (freshdeskResponse.getStatusCode() == 200){

            system.debug(freshdeskResponse.getBody());


            // deserialise the response as a generic object
            List<Object> agentObjects = (List<Object>)JSON.deserializeUntyped(freshdeskResponse.getBody());

            for (Object agentObject : agentObjects){

                Map<String,Object> valueMap = (Map<String,Object>)agentObject;
                String fershdeskId = valueMap.containsKey('id') ? String.valueOf((Long)valueMap.get('id')) : null;

                if (fershdeskId != null && valueMap.containsKey('contact')){
                    Map<String,Object> contactMap = (Map<String,Object>)valueMap.get('contact');
                    String email = (String)contactMap.get('email');
                    if (employeeMap.containsKey(email.toUpperCase())){
                        employeeMap.get(email.toUpperCase()).FreshdeskId__c = fershdeskId;
                    }
                }
            }
        }

        return employeeMap;
    }

    @TestVisible
    private static Map<String,Employee__c> bindCezanneData(Map<String,Employee__c> employeeMap){

        Http http = new Http();
        HttpRequest authRequest    = new HttpRequest();
        authRequest.setEndpoint('https://w3.cezanneondemand.com/CezanneOnDemand/OAuth/Token');
        authRequest.setMethod('POST');
        authRequest.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(
                                                    'e9a752d80cee4c7eaee19bc022c17390.app.cezannehr.com' + ':' +
                                                            'QOMCGiVlYsS98GBobENxdNy90zY2Xz0BPLa2')));
        authRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        authRequest.setHeader('Host', 'w3.cezanneondemand.com');
        authRequest.setBody('grant_type=client_credentials&scope=http://www.cezannehr.com/auth-scope/APIRead');

        HttpResponse response = http.send(authRequest);

        Map<String,Object> tokenMap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());

        String accessToken = '';

        if (response.getStatusCode() == 200 && tokenMap.containsKey('access_token')){
            accessToken = (String)tokenMap.get('access_token');

            // call the Cezanne endpoint
            Http cezanneCallout = new Http();
            HttpResponse cezanneResponse = cezanneCallout.send(responseBuilder(
                    'https://w3.cezanneondemand.com/cezanneondemand/v4/dataservice.svc/People?$filter=ActiveEmployee%20eq%201',
                    'GET',
                    'Bearer ' + accessToken
            ));

            if (cezanneResponse.getStatusCode() == 200) {

                // because Cezanne does not provide the employee email, create a map of name to email
                Map<String,String> nameEmailMap = new Map<String,String>();

                for (Employee__c employee : employeeMap.values()){
                    if (employee.FirstName__c != null && employee.LastName__c != null){
                        nameEmailMap.put(employee.FirstName__c.toUpperCase() + ' ' + employee.LastName__c.toUpperCase(),employee.Email__c.toUpperCase());
                    }
                }

                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(cezanneResponse.getBody());

                if (responseMap.containsKey('value')){

                    List<Object> employeeObjects = (List<Object>)responseMap.get('value');

                    for (Object employeeObject : employeeObjects){

                        Map<String,Object> userValues = (Map<String,Object>)employeeObject;

                        if (userValues.containsKey('FullName')){
                            String nameString  = (String)userValues.get('FullName');
                            nameString         = nameString.toUpperCase();

                            // if the Employee__c already exists, update the information
                            if (employeeMap.containsKey(nameString)){
                                employeeMap.get(nameString).CezanneId__c = (String)userValues.get('PersonGUID');
                            } else if (nameEmailMap.containsKey(nameString)){
                                employeeMap.get(nameEmailMap.get(nameString)).CezanneId__c = (String)userValues.get('PersonGUID');
                            }
                        }
                    }
                }
            }
        }

        return employeeMap;
    }

    @TestVisible
    private static Map<String,Employee__c> bindUserData(Map<String,Employee__c> employeeMap){

        for (User user : [SELECT Id, Email, FirstName, LastName, Title FROM User]){

            String userEmail    = user.Email.replaceAll('.invalid','').replaceAll('.partial','').toUpperCase();

            if(Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', userEmail)){
                if (employeeMap.containsKey(userEmail)){
                    if (employeeMap.get(userEmail).User__c != user.Id){
                        employeeMap.get(userEmail).User__c = user.Id;
                        employeeMap.get(userEmail).Position__c = user.Title;
                    }
                } else {
                    Employee__c employee        = new Employee__c(
                            FirstName__c        = user.FirstName,
                            LastName__c         = user.LastName,
                            Position__c         = user.Title,
                            Email__c            = user.Email.replaceAll('.invalid','').replaceAll('.partial','')
                    );

                    employeeMap.put(userEmail,employee);
                }
            }
        }

        return employeeMap;
    }


    @TestVisible
    public static HttpRequest responseBuilder(String endpoint, String method, String bearer){

        HttpRequest request    = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(method.toUpperCase());
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', bearer);

        return request;
    }



}