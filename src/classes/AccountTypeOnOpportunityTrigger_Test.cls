/**
* Test class for the AccountTypeOnOpportunityTrigger trigger on Opportunity
* @author Constance Rouge - Ceterna Ltd
* @createddate 06/03/2017
*/

@isTest 
public class AccountTypeOnOpportunityTrigger_Test {

    //We verify that if we insert an open opportunity, its account's type will be "Open Opportunity"
/*    static testMethod void insertOpenOpp(){
		Account acc=new Account(Name='TestAccount', Type='Customer',
                                Website='testweb', Evolution_3_Day_Rate_ex_VAT__c=900, 
                                Industry='Agriculture', Contact_s_for_documentation__c='Testcontacts',
                                URL_For_doc_Images__c='testurl');
		insert acc;
		
		contact con=new contact(LastName='Testcon', AccountId=acc.id, Phone='111111');
		insert con;
		
		Opportunity opp=new Opportunity(Name='testopp', StageName='Opportunity Identified',
                                        Contact_for_Invoice__c=con.id, Opportunity_Description_for_opp_name__c='testdesc',
                                        AccountId=acc.id, Competitive__c='Yes',
                                        New_Existing__c='New Customer', Type='Sales Cloud',
                                        LeadSource='Web', CloseDate=System.today(),
                                        Rating__c='Hot - Certain to Close', Pre_Sales_Amount__c=0,
                                        NextStep='teststep', Executive_Summary__c='Test Summary',
                                        Payment_Terms__c='100% upon engagement');
        insert opp;
		
		acc=[SELECT Type FROM Account WHERE Id=:acc.Id];
        System.assertEquals('Open Opportunity', acc.Type);
	}
    
    //We verify that if we insert a closed won opportunity, its account's type will be "Customer"
    static testMethod void testInsertWon() {
		Account acc=new Account(Name='TestAccount', Type='Customer',
                                Website='testweb', Evolution_3_Day_Rate_ex_VAT__c=900, 
                                Industry='Agriculture', Contact_s_for_documentation__c='Testcontacts',
                                URL_For_doc_Images__c='testurl');
		insert acc;
		
		contact con=new contact(LastName='Testcon', AccountId=acc.id, Phone='111111');
		insert con;
		
		Opportunity opp=new Opportunity(Name='testopp', StageName='Closed Won',
                                        Contact_for_Invoice__c=con.id, Opportunity_Description_for_opp_name__c='testdesc',
                                        AccountId=acc.id, Competitive__c='Yes',
                                        New_Existing__c='New Customer', Type='Sales Cloud',
                                        LeadSource='Web', CloseDate=System.today(),
                                        Rating__c='Hot - Certain to Close', Pre_Sales_Amount__c=0,
                                        NextStep='teststep', Executive_Summary__c='Test Summary',
                                        Payment_Terms__c='100% upon engagement');
        insert opp;
        
        acc=[SELECT Type FROM Account WHERE Id=:acc.Id];
        System.assertEquals('Customer', acc.Type);
	}
    
    //We verify that if we insert a closed lost opportunity, its account's type will be "Lost Opportunity" when there isn't any old won opportunities
    static testMethod void testInsertLost() {
		Account acc=new Account(Name='TestAccount', Type='Customer',
                                Website='testweb', Evolution_3_Day_Rate_ex_VAT__c=900, 
                                Industry='Agriculture', Contact_s_for_documentation__c='Testcontacts',
                                URL_For_doc_Images__c='testurl');
		insert acc;
		
		contact con=new contact(LastName='Testcon', AccountId=acc.id, Phone='111111');
		insert con;
		
		Opportunity opp=new Opportunity(Name='testopp', StageName='Closed Lost',
                                        Contact_for_Invoice__c=con.id, Opportunity_Description_for_opp_name__c='testdesc',
                                        AccountId=acc.id, Competitive__c='Yes',
                                        New_Existing__c='New Customer', Type='Sales Cloud',
                                        LeadSource='Web', CloseDate=System.today(),
                                        Rating__c='Hot - Certain to Close', Pre_Sales_Amount__c=0,
                                        NextStep='teststep', Executive_Summary__c='Test Summary',
                                        Payment_Terms__c='100% upon engagement');
        insert opp;
        
        acc=[SELECT Type FROM Account WHERE Id=:acc.Id];
        System.assertEquals('Lost Opportunity', acc.Type);
	}
    
    //We verify that if we update an opportunity to become closed won, its account's type will be "Customer"
    static testMethod void updateWonOpp(){
		Account acc=new Account(Name='TestAccount', Type='Customer',
                                Website='testweb', Evolution_3_Day_Rate_ex_VAT__c=900, 
                                Industry='Agriculture', Contact_s_for_documentation__c='Testcontacts',
                                URL_For_doc_Images__c='testurl');
		insert acc;
		
		contact con=new contact(LastName='Testcon', AccountId=acc.id, Phone='111111');
		insert con;
		
		Opportunity opp=new Opportunity(Name='testopp', StageName='Opportunity Identified',
                                        Contact_for_Invoice__c=con.id, Opportunity_Description_for_opp_name__c='testdesc',
                                        AccountId=acc.id, Competitive__c='Yes',
                                        New_Existing__c='New Customer', Type='Sales Cloud',
                                        LeadSource='Web', CloseDate=System.today(),
                                        Rating__c='Hot - Certain to Close', Pre_Sales_Amount__c=0,
                                        NextStep='teststep', Executive_Summary__c='Test Summary',
                                        Payment_Terms__c='100% upon engagement');
        insert opp;
		
        opp.StageName='Closed Won';
        update opp;
        
		acc=[SELECT Type FROM Account WHERE Id=:acc.Id];
        System.assertEquals('Customer', acc.Type);
	}
    
    //We verify that if we update an opportunity to become closed lost, its account's type will be "Lost Opportunity" when there isn't any old won opportunities
    static testMethod void updateLostOpp(){
		Account acc=new Account(Name='TestAccount', Type='Customer',
                                Website='testweb', Evolution_3_Day_Rate_ex_VAT__c=900, 
                                Industry='Agriculture', Contact_s_for_documentation__c='Testcontacts',
                                URL_For_doc_Images__c='testurl');
		insert acc;
		
		contact con=new contact(LastName='Testcon', AccountId=acc.id, Phone='111111');
		insert con;
		
		Opportunity opp=new Opportunity(Name='testopp', StageName='Opportunity Identified',
                                        Contact_for_Invoice__c=con.id, Opportunity_Description_for_opp_name__c='testdesc',
                                        AccountId=acc.id, Competitive__c='Yes',
                                        New_Existing__c='New Customer', Type='Sales Cloud',
                                        LeadSource='Web', CloseDate=System.today(),
                                        Rating__c='Hot - Certain to Close', Pre_Sales_Amount__c=0,
                                        NextStep='teststep', Executive_Summary__c='Test Summary',
                                        Payment_Terms__c='100% upon engagement');
        insert opp;
		
        opp.StageName='Closed Lost';
        update opp;
        
		acc=[SELECT Type FROM Account WHERE Id=:acc.Id];
        System.assertEquals('Lost Opportunity', acc.Type);
	}
    
    //We verify that if we insert a closed lost opportunity, its account's type will be "Customer" when there is an old won opportunity
    static testMethod void testInsertLostOldWon() {
		Account acc=new Account(Name='TestAccount', Type='Customer',
                                Website='testweb', Evolution_3_Day_Rate_ex_VAT__c=900, 
                                Industry='Agriculture', Contact_s_for_documentation__c='Testcontacts',
                                URL_For_doc_Images__c='testurl');
		insert acc;
		
		contact con=new contact(LastName='Testcon', AccountId=acc.id, Phone='111111');
		insert con;
		
		Opportunity opp1=new Opportunity(Name='testopp', StageName='Closed Won',
                                        Contact_for_Invoice__c=con.id, Opportunity_Description_for_opp_name__c='testdesc',
                                        AccountId=acc.id, Competitive__c='Yes',
                                        New_Existing__c='New Customer', Type='Sales Cloud',
                                        LeadSource='Web', CloseDate=System.today(),
                                        Rating__c='Hot - Certain to Close', Pre_Sales_Amount__c=0,
                                        NextStep='teststep', Executive_Summary__c='Test Summary',
                                        Payment_Terms__c='100% upon engagement');
        insert opp1;
        
        acc=[SELECT Type FROM Account WHERE Id=:acc.Id];
        System.assertEquals('Customer', acc.Type);
        
        Opportunity opp2=new Opportunity(Name='testopp', StageName='Closed Lost',
                                        Contact_for_Invoice__c=con.id, Opportunity_Description_for_opp_name__c='testdesc',
                                        AccountId=acc.id, Competitive__c='Yes',
                                        New_Existing__c='New Customer', Type='Sales Cloud',
                                        LeadSource='Web', CloseDate=System.today(),
                                        Rating__c='Hot - Certain to Close', Pre_Sales_Amount__c=0,
                                        NextStep='teststep', Executive_Summary__c='Test Summary',
                                        Payment_Terms__c='100% upon engagement');
        insert opp2;
        
        acc=[SELECT Type FROM Account WHERE Id=:acc.Id];
        System.assertEquals('Customer', acc.Type);
	}
    
    //We verify that if we update an opportunity to become closed lost, its account's type will be "Customer" when there is an old won opportunity
    static testMethod void testUpdateLostOldWon() {
		Account acc=new Account(Name='TestAccount', Type='Customer',
                                Website='testweb', Evolution_3_Day_Rate_ex_VAT__c=900, 
                                Industry='Agriculture', Contact_s_for_documentation__c='Testcontacts',
                                URL_For_doc_Images__c='testurl');
		insert acc;
		
		contact con=new contact(LastName='Testcon', AccountId=acc.id, Phone='111111');
		insert con;
		
		Opportunity opp1=new Opportunity(Name='testopp', StageName='Closed Won',
                                        Contact_for_Invoice__c=con.id, Opportunity_Description_for_opp_name__c='testdesc',
                                        AccountId=acc.id, Competitive__c='Yes',
                                        New_Existing__c='New Customer', Type='Sales Cloud',
                                        LeadSource='Web', CloseDate=System.today(),
                                        Rating__c='Hot - Certain to Close', Pre_Sales_Amount__c=0,
                                        NextStep='teststep', Executive_Summary__c='Test Summary',
                                        Payment_Terms__c='100% upon engagement');
        insert opp1;
        
        acc=[SELECT Type FROM Account WHERE Id=:acc.Id];
        System.assertEquals('Customer', acc.Type);
        
        Opportunity opp2=new Opportunity(Name='testopp', StageName='Opportunity Identified',
                                        Contact_for_Invoice__c=con.id, Opportunity_Description_for_opp_name__c='testdesc',
                                        AccountId=acc.id, Competitive__c='Yes',
                                        New_Existing__c='New Customer', Type='Sales Cloud',
                                        LeadSource='Web', CloseDate=System.today(),
                                        Rating__c='Hot - Certain to Close', Pre_Sales_Amount__c=0,
                                        NextStep='teststep', Executive_Summary__c='Test Summary',
                                        Payment_Terms__c='100% upon engagement');
        insert opp2;
        
        acc=[SELECT Type FROM Account WHERE Id=:acc.Id];
        System.assertEquals('Open Opportunity', acc.Type);
        
        opp2.StageName='Closed Lost';
        update opp2;
        
        acc=[SELECT Type FROM Account WHERE Id=:acc.Id];
        System.assertEquals('Customer', acc.Type);
	}

    */ 
}