/*
* @author Alan Abishev - Ceterna LTD
* @createddate 17/07/2017
* @edited 24/07/2017
*/

/*=============================================================================
//
//    HttpClass to Receive HTTP Post callouts(utilizes @RestResource)
//    and create a 2017 Questionnaire from Google Forms
//    Google form URL: https://docs.google.com/a/ceterna.com/forms/d/1tA0ZkN6BGBM8EI0JWILIN7RzwmmG6_bqlWSunKK_H00/edit
//    
//*=============================================================================*/

@RestResource(urlMapping='/GoogleForm/*')
global with sharing class HttpClass {
    
    
    @HttpPost
    global static String updateCustomObject() {
        //Fetching request
        
        RestRequest  req     = RestContext.request;   
        //Getting JSON String from request body
        String jsonInput  = req.requestBody.toString();
        JSONParser parser = JSON.createParser(jsonInput);
        
        System.debug('Parser:' + jsonInput);
        
        //jsonInput = jsonInput.replace(' ','');
        
        Object jsonUnpacked =  json.deserializeUntyped(jsonInput);
        System.debug(jsonUnpacked);
        
        User gUser = (User)JSON.deserialize(jsonInput, User.class);
        
        system.debug('user ' + gUser);
        
        
        X2017_questionnaire__c quest = new X2017_questionnaire__c(Email_address__c = gUser.email,Pain_Factor_1__c = gUser.pain1,
                                                                  Pain_Factor_2__c = gUser.pain2,Pain_Factor_3__c = gUser.pain3,
                                                                  Pain_Factor_4__c = gUser.pain4,Pain_Factor_5__c = gUser.pain5,
                                                                  Project_Objective_1__c = gUser.obj1,Project_Objective_2__c = gUser.obj2,
                                                                  Project_Objective_3__c = gUser.obj3,Project_Objective_4__c = gUser.obj4,
                                                                  Project_Objective_5__c = gUser.obj5,KPI_1__c =gUser.kpi1,KPI_2__c =gUser.kpi2,
                                                                  KPI_3__c =gUser.kpi3,KPI_4__c =gUser.kpi4,KPI_5__c =gUser.kpi5,Key_Terminology__c = gUser.keyTerminology,
                                                                  Data_Sources__c = gUser.dataSources,Data_to_load__c = gUser.dataToLoad,Data_responsible__c = gUser.dataResponsible,
                                                                  Project_Team_people_not_part__c = gUser.projectNotPart,Project_Team_people_zero_salesforce__c = gUser.projectZeroSalesforce,
                                                                  Project_Manager__c = gUser.projectManager, Sponsor__c = gUser.sponsor, Business_Users__c = gUser.businessUsers,
                                                                  In_charge_of_Testing__c = gUser.inChargeOfTesting, Data_Manager__c = gUser.dataManager,Training__c = gUser.training,
                                                                  Users_on_Holiday__c = gUser.usersOnHoliday,Additional_Information__c = gUser.additionalInfo);
        
        insert quest;
        
        List<X2017_questionnaire__c> lstOfQuest = [SELECT name,Email_address__c FROM X2017_questionnaire__c WHERE Email_address__c =:gUser.email];
        if (!lstOfQuest.isEmpty()){
            return 'Created Succesfully';
        }else {
            return 'Error';
        }
        
        
    }
    
    public class User {
        
        public String email;
        public String pain1;
        public String pain2;
        public String pain3;
        public String pain4;
        public String pain5;
        public String obj1;
        public String obj2;
        public String obj3;
        public String obj4;
        public String obj5;
        public String kpi1;
        public String kpi2;
        public String kpi3;
        public String kpi4;
        public String kpi5;
        public String keyTerminology;
        public String dataSources;
        public String dataToLoad;
        public String dataResponsible;
        public String projectNotPart;
        public String projectZeroSalesforce;
        public String projectManager;
        public String sponsor;
        public String businessUsers;
        public String inChargeOfTesting;
        public String dataManager;
        public String training;
        public String usersOnHoliday;
        public String additionalInfo;
        
    }
    
}