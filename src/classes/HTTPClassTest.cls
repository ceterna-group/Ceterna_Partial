/*
* @author Alan Abishev - Ceterna LTD
* @createddate 17/07/2017
* @edited 24/07/2017
*/

/*=============================================================================
//
//    HttpClassTest for HttpClass
//*=============================================================================*/


@isTest
public class HTTPClassTest{
    
    @isTest
    static void testHttpPost() {
        
        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/GoogleForm'; //Request URL
        req.httpMethod = 'POST';
        Map<String,String> mpNew = new Map<String,String>{'email'=> 'alan@ceterna.com',
            'pain1'=> 'pain1',
            'pain2'=> 'pain2',
            'pain3'=> 'pain3',
            'pain4'=> 'pain4',
            'pain5'=> 'pain5',
            'obj1'=> 'obj1',
            'obj2'=> 'obj2',
            'obj3'=> 'obj3',
            'obj4'=> 'obj4',
            'obj5'=> 'obj5',
            'kpi1'=>'kpi1',
            'kpi2'=>'kpi2',
            'kpi3'=>'kpi3',
            'kpi4'=>'kpi4',
            'kpi5'=>'kpi5',
            'keyTerminology'=>'keyTerminology',
            'dataSources'=>'dataSources',
            'dataToLoad'=> 'dataToLoad',
            'dataResponsible'=>'dataResponsible',
            'projectNotPart'=>'projectNotPart',
            'projectZeroSalesforce'=>'projectZeroSalesforce',
            'projectManager'=>'projectManager',
            'sponsor'=>'sponsor',
            'businessUsers'=>'businessUsers',
            'inChargeOfTesting'=>'inChargeOfTesting',
            'dataManager'=>'dataManager',
            'training'=>'training',
            'usersOnHoliday'=>'usersOnHoliday',
            'additionalInfo'=>'additionalInfo'};
                
                
                RestContext.request = req;
        RestContext.response= res;
        
        req.requestBody =  Blob.valueOf(json.serialize(mpNew));
        
        Http h = new Http();
        
        Test.startTest();
        
        HttpClass.updateCustomObject();
        Test.stopTest();
        
        
        String questAllFields = String.join(new List<String>(X2017_questionnaire__c.sObjectType.getDescribe().fields.getMap().keySet()), ',');
        String queryQuest;
        
        queryQuest = 'SELECT ' + questAllFields + ' FROM X2017_questionnaire__c';
        List<X2017_questionnaire__c> lstOfQuest = Database.query(queryQuest);
        
        //List<X2017_questionnaire__c> lstOfQuest = [SELECT name,Email_address__c,Pain_Factor_1__c,Pain_Factor_2__c,Pain_Factor_3__c,Pain_Factor_4__c,Pain_Factor_5__c FROM X2017_questionnaire__c];
        System.assertEquals(1, lstOfQuest.size(), 'There should be 1 questionnaire inserted');
        System.assertEquals('pain1', lstOfQuest[0].Pain_Factor_1__c, 'Pain1 field should be filled in');
        System.assertEquals('pain2', lstOfQuest[0].Pain_Factor_2__c, 'Pain2 field should be filled in');
        System.assertEquals('pain3', lstOfQuest[0].Pain_Factor_3__c, 'Pain3 field should be filled in');
        System.assertEquals('pain4', lstOfQuest[0].Pain_Factor_4__c, 'Pain4 field should be filled in');
        System.assertEquals('pain5', lstOfQuest[0].Pain_Factor_5__c, 'Pain5 field should be filled in');
        System.assertEquals('alan@ceterna.com', lstOfQuest[0].Email_address__c, 'Email field should be filled in');
        System.assertEquals('obj1', lstOfQuest[0].Project_Objective_1__c, 'Project objective 1 field should be filled in');
        System.assertEquals('obj2', lstOfQuest[0].Project_Objective_2__c, 'Project objective 2 field should be filled in');
        System.assertEquals('obj3', lstOfQuest[0].Project_Objective_3__c, 'Project objective 3 field should be filled in');
        System.assertEquals('obj4', lstOfQuest[0].Project_Objective_4__c, 'Project objective 4 field should be filled in');
        System.assertEquals('obj5', lstOfQuest[0].Project_Objective_5__c, 'Project objective 5 field should be filled in');
        System.assertEquals('kpi1', lstOfQuest[0].KPI_1__c, 'KPI 1 field should be filled in');
        System.assertEquals('kpi2', lstOfQuest[0].KPI_2__c, 'KPI 2 field should be filled in');
        System.assertEquals('kpi3', lstOfQuest[0].KPI_3__c, 'KPI 3 field should be filled in');
        System.assertEquals('kpi4', lstOfQuest[0].KPI_4__c, 'KPI 4 field should be filled in');
        System.assertEquals('kpi5', lstOfQuest[0].KPI_5__c, 'KPI 5 field should be filled in');
        System.assertEquals('keyTerminology', lstOfQuest[0].Key_Terminology__c, 'Key Terminology field should be filled in');
        System.assertEquals('dataSources', lstOfQuest[0].Data_Sources__c, 'Data sources field should be filled in');
        System.assertEquals('dataToLoad', lstOfQuest[0].Data_to_load__c, 'Data to load field should be filled in');
        System.assertEquals('dataResponsible', lstOfQuest[0].Data_responsible__c, 'Data responsible load field should be filled in');
        System.assertEquals('projectNotPart', lstOfQuest[0].Project_Team_people_not_part__c, 'ProjectNotPart field should be filled in');
        System.assertEquals('projectZeroSalesforce', lstOfQuest[0].Project_Team_people_zero_salesforce__c, 'Project Team people zero field should be filled in');
        System.assertEquals('projectManager', lstOfQuest[0].Project_Manager__c, 'Project manager field should be filled in');
        System.assertEquals('sponsor', lstOfQuest[0].Sponsor__c, 'Sponsor field should be filled in');
        System.assertEquals('businessUsers', lstOfQuest[0].Business_Users__c, 'Business users field should be filled in');
        System.assertEquals('inChargeOfTesting', lstOfQuest[0].In_charge_of_Testing__c, 'In Charge of testing field should be filled in');
        System.assertEquals('dataManager', lstOfQuest[0].Data_Manager__c, 'Data Manager field should be filled in');
        System.assertEquals('training', lstOfQuest[0].Training__c, 'Training field should be filled in');
        System.assertEquals('usersOnHoliday', lstOfQuest[0].Users_on_Holiday__c, 'Users On Holiday field should be filled in');
        System.assertEquals('additionalInfo', lstOfQuest[0].Additional_Information__c, 'Additional Information field should be filled in');
        
        
        
    }
    
    
}