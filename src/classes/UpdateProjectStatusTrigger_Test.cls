@IsTest
public class UpdateProjectStatusTrigger_Test 
{
    static testmethod void updateprojectstatus()
    {
        Account accObj=new Account(name='TestAccount',Type='Customer',Website='testweb',Evolution_3_Day_Rate_ex_VAT__c=900,industry='Agriculture',Contact_s_for_documentation__c='Testcontacts',URL_For_doc_Images__c='testurl');
        insert accObj;
        
        contact conObj=new contact(lastname='Testcon',accountid=accObj.id,phone='111111');
        insert conObj;
        
        
        // Changed ForecastCategoryName to Ommitted from Identified
        Opportunity oppObj=new Opportunity(name='testopp',StageName='Closed Won',Contact_for_Invoice__c=conObj.id,Opportunity_Description_for_opp_name__c='testdesc',Accountid=accObj.id,Competitive__c='Yes',New_Existing__c='New Customer',type='Sales Cloud',LeadSource='Web',CloseDate=System.today(),Rating__c='Hot - Certain to Close',Pre_Sales_Amount__c=0,NextStep='teststep',ForecastCategoryName='Omitted',Executive_Summary__c='Test Summary',Payment_Terms__c='100% upon engagement');
        insert oppObj;
        
        /*Project_Line__c projlineObj=new Project_Line__c(name='TestPrj',Account__c=accObj.id,Related_Opportunity__c=oppObj.id,Status__c='Project complete',Client_Project_Lead__c=conObj.id);
        insert projlineObj;
       
        Project_Line__c projlineObj1=new Project_Line__c(name='TestPrj',Account__c=accObj.id,Related_Opportunity__c=oppObj.id,Status__c='Project',Client_Project_Lead__c=conObj.id);
        insert projlineObj1; 
        
        projlineObj1.Status__c='Project complete';
        update projlineObj1;*/
                
    }
}