@isTest
private class CreateFreshdeskCompanyContactTest 
{
    static testMethod void createFreshdeskCompanyWithSingleDomain() 
    {
    	Id recordTypeId = [Select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Ceterna_Customer_Prospect'].Id;
        Account account = new Account (	Name = 'test company1', 
        								Freshdesk_Support_Email_Address__c = 'abc@abc.com', 	
        								Freshdesk_Domain_Names__c = 'mycompany.com', 
        								Website = 'www.google.com',
        								Description = 'test description',
        								RecordTypeId = recordTypeId,
        								Type = 'Open Opportunity',
        								Industry = 'Agriculture',
        								Contact_s_for_documentation__c = 'Test');
       Test.startTest();
       insert account;
       
       account.Freshdesk_Support_Client__c = true;
       update account;
       Test.stopTest();
       
       List<Account> accountList = [Select id, Name, Support_Name__c from Account];
       System.assertEquals(1, accountList.size());
       System.assertEquals('14000099596', accountList[0].Support_Name__c);
    }
    
    static testMethod void createFreshdeskCompanyWithMultipleDomain() 
    {
    	Id recordTypeId = [Select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Ceterna_Customer_Prospect'].Id;
        Account account = new Account (	Name = 'test company1', 
        								Freshdesk_Support_Email_Address__c = 'abc@abc.com', 	
        								Freshdesk_Domain_Names__c = 'mycompany.com, mycompany1.com, mycompany2.com', 
        								Website = 'www.google.com',
        								Description = 'test description',
        								RecordTypeId = recordTypeId,
        								Type = 'Open Opportunity',
        								Industry = 'Agriculture',
        								Contact_s_for_documentation__c = 'Test');
       Test.startTest();
       insert account;
       
       account.Freshdesk_Support_Client__c = true;
       update account;
       Test.stopTest();
       
       List<Account> accountList = [Select id, Name, Support_Name__c from Account];
       System.assertEquals(1, accountList.size());
       System.assertEquals('14000099596', accountList[0].Support_Name__c);
    }
    
    static testMethod void testParseErrorJSON()
    {
    	String errorJSON = '{"description":"Validation failed","errors":[{"field":"company_id","message":"There is no company matching the given company_id","code":"invalid_value"}]}';
    	String parsedString = 'company_id : There is no company matching the given company_id';
    	
    	String result = CreateFreshdeskCompanyContact.parseErrorJSON(errorJSON);
    	System.assertEquals(parsedString, result);
    }
    
    //for code coverage
    static testMethod void testSendErrorEmail()
    {
    	String errorMessage = 'test email';
    	CreateFreshdeskCompanyContact.sendErrorEmail(errorMessage);
    }
    
    static testMethod void testCreateFreshdeskContact()
    {
    	Id recordTypeId = [Select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Ceterna_Customer_Prospect'].Id;
    	Id contactRecordTypeId = [Select Id from RecordType where SObjectType = 'Contact' and DeveloperName = 'Regular_Contact'].Id;
        Account account = new Account (	Name = 'test company1', 
        								Freshdesk_Support_Email_Address__c = 'abc@abc.com', 	
        								Freshdesk_Domain_Names__c = 'mycompany.com',
        								Support_Name__c = '14000099596',
        								Website = 'www.google.com',
        								Description = 'test description',
        								RecordTypeId = recordTypeId,
        								Type = 'Open Opportunity',
        								Industry = 'Agriculture',
        								Contact_s_for_documentation__c = 'Test');
       insert account;
       
       Contact con = new Contact( LastName = 'test contact',
       							  AccountId = account.Id,
       							  MobilePhone = '07897623235',
       							  Phone = '01494 333333',
       							  Title = 'Marketing Executive',
       							  Email = 'rrr@rr.com');
       Test.startTest();
       insert con;
       
       con.Freshdesk_Support_Client__c = true;
       update con;
       
       Test.stopTest();
       
       List<Contact> contactList = [Select Freshdesk_Id__c from Contact];     
       System.assertEquals(1, contactList.size());
       System.assertEquals('14001381241', contactList[0].Freshdesk_Id__c);        
    }
}