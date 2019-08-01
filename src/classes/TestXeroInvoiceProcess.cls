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
private class TestXeroInvoiceProcess {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
   /*      List<RecordType> recordTypes = [SELECT id FROM RecordType WHERE Name = 'Ceterna Customer/Prospect' AND SobjectType = 'Account' limit 1 ];
        String ids=(String)recordTypes[0].Id;
        RecordType objRecordType= new RecordType();
        objRecordType.Name='Ceterna Customer/Prospect test';
        objRecordType.DeveloperName='Ceterna_Customer_Prospect test';
        objRecordType.SobjectType='Account';
     //   insert objRecordType; */
     Account objAccount= new Account();
     objAccount.Name='TestAccount';
     objAccount.BillingStreet='TestStreet';
     objAccount.BillingCity='TestCity';
     objAccount.BillingCountry='TestCountry';
     objAccount.BillingPostalCode='1234';
     objAccount.BillingState='TestState';
	insert objAccount;
	System.debug('objAccount.id--->'+objAccount.id);
	
	Contact objcontact = new Contact();
	objcontact.FirstName='Test';
	objcontact.LastName='LastName';
	objcontact.Email='Test@test.com';
	objcontact.AccountId=objAccount.Id;
	insert objcontact;
System.debug('objcontact.id--->'+objcontact.id);

	Opportunity objOpportunity = new Opportunity();
	objOpportunity.AccountId=objAccount.Id;
	objOpportunity.Contact_for_Invoice__c=objcontact.Id;
//	Contact_for_Invoice__c
	objOpportunity.CloseDate=system.today()+8;
	objOpportunity.Name='SampleAcc - test';
	objOpportunity.StageName='Opportunity Identified';
	insert objOpportunity;
	System.debug('objOpportunity.id--->'+objOpportunity.id);
	
	Invoice__c objInvoice = new Invoice__c();
	objInvoice.Invoice_Date__c=system.today();
	objInvoice.Due_Date__c=system.today()+3;
	objInvoice.Opportunity__c=objOpportunity.Id;
	objInvoice.Account__c=objAccount.Id;
	objInvoice.Reference__c='testref';
objInvoice.Amounts_Are__c='Tax Exclusive';
objInvoice.Description__c='Test Desc';
objInvoice.Quantity__c=1;
objInvoice.Unit_Price__c=25;
//objInvoice.VAT_Amount__c=5;
objInvoice.Tax_Rate__c='20% (VAT on Income)';
objInvoice.Xero_Account__c='214 - Service/Fee Income';
objInvoice.Item__c='25% POC';
objInvoice.Xero_ID__c='6ab73a27-75e3-4538-ba20-7dc6418ab3e3';

insert objInvoice;
List<Invoice__c> colinvo=[select id,name from Invoice__c where id=:objInvoice.id];
XeroInvoiceProcess.handleInvoice(colinvo[0].Name);

String xeroContName='Test';

System.Httpresponse responseObj = new System.Httpresponse();
responseObj.setStatusCode(500);
responseObj.setStatus('TestServerStatus');

String str=XeroInvoiceProcess.ExceptionStatus(responseObj,xeroContName,'Contacts');

Httpresponse responseObj1 = new Httpresponse();
responseObj1.setStatusCode(500);
responseObj1.setStatus('TestServerStatus');
XeroInvoiceProcess.ExceptionStatus(responseObj1,xeroContName,'Invoices');

SchedulableContext SC;
XeroInvoiceScheduleJob oTemp = new XeroInvoiceScheduleJob();
oTemp.execute(sc);
//XeroInvoiceUpdation.updateInvoiceAmount();
     
    }
}