/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 
Created By : Ankush Rao.
Date       : 26-dec-2013.
Purpose    :Test class for both UpdatingSmartsheetKeyToAccount Trigger and smartsheetProjPlanCon Class.

 */
@isTest
private class Test_UpdatingSmartsheetKeyToAccount {

   static testMethod void myUnitTest() {
        Account acc = new Account();
            acc.Name ='test acc';
            acc.Type ='test';
            acc.Industry ='test';
            acc.Website ='www.test.com';
            acc.Phone ='123546';
            acc.URL_For_doc_Images__c ='test url';
            acc.Contact_s_for_documentation__c ='test doc';
        insert acc;
        
        Contact con = new Contact();
            con.FirstName ='fname';
            con.LastName ='lname';
            con.Phone ='45645145';
            con.AccountId = acc.id;
        insert con;
        /*
        opportunity opp = new opportunity();
            opp.Name ='test opp';
            opp.Type ='test';
            opp.CloseDate = system.today();
            opp.LeadSource ='test';
            opp.New_Existing__c ='test';
            opp.Competitive__c ='test';
            opp.Rating__c ='hot';
            opp.NextStep ='test';
            opp.Executive_Summary__c ='test summary';
            opp.StageName ='test';
        insert opp;         
      
        Project_Line__c projLine = new Project_Line__c();
            projLine.Account__c =acc.id;
            projLine.Client_Project_Lead__c =con.id;
            projLine.Related_Opportunity__c = opp.id;
            projLine.Name ='test proj line';
        insert projLine;                
        
        com_smartsheet__Smartsheet__c smsheetObj= new com_smartsheet__Smartsheet__c();
            smsheetObj.Use_This_For_Community_Project_Plan__c = true;
            smsheetObj.Name ='test sheet';
            smsheetObj.com_smartsheet__Account__c =acc.id;
            smsheetObj.com_smartsheet__SmartsheetKey__c ='dfsfssfs4fsf';
            smsheetObj.Use_This_For_Community_Issue_Log__c = true;
            smsheetObj.Project_Line__c = projLine.id;
            
            test.startTest();
                insert smsheetObj;
             smartsheetProjPlanCon amartobj = new smartsheetProjPlanCon();
             SmartsheetIssueLogCon obj = new SmartsheetIssueLogCon();
             
            test.stopTest();   */
    }
}