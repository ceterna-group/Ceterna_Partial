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
 */
@isTest
private class TestAcceptCaseController {

    static testMethod void myUnitTest() {
        
        Account ObjAccount = new Account();
        ObjAccount.Name = 'Test Account';
        insert ObjAccount;
        
        Contact ObjContact = New Contact();
        ObjContact.LastName = 'Test Contact';
        ObjContact.AccountId = ObjAccount.id;
        insert ObjContact;
        
        Case objcase = new Case();
        objcase.AccountId = ObjAccount.id;
        objCase.ContactId = ObjContact.id;
        insert objcase;
        
        ApexPages.CurrentPage().GetParameters().put('ID',objcase.id);
        
        AcceptCaseController AC = new AcceptCaseController();
        
        Case objcase1 = new Case();
        objcase1.Client_Acknowledgement_Message__c = 'Test Message';
        objcase1.Initial_Respone_Date_Time__c = system.now();
        objcase1.OwnerId = userinfo.getUserId();
        objcase1.id=objcase.id;
        Ac.sClientAckMessage = 'TEst DAta';
        AC.Save();
        
    }
}