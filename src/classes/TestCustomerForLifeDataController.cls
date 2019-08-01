@isTest
private class TestCustomerForLifeDataController 
{
	static testMethod void testCustomerForLifeDataController() 
    {
       /* Account acc = new Account(Name='test account');
        insert acc;
 
 		Project_Line__c pl = new Project_Line__c(Account__c=acc.Id,Name='test',Status__c='Pending',Percentage_Complete__c=10,Start_Date__c=Date.today(),End_Date__c=Date.today());
 		insert pl; 
		
		List<Task> lstTasks = new List<Task>();
		lstTasks.add(new Task(WhatId=acc.Id,Subject='SFDC Upsell',Status='completed',ActivityDate=Date.today()));
		lstTasks.add(new Task(WhatId=acc.Id,Subject='SFDC New Licenses',Status='declined',ActivityDate=Date.today()));
		lstTasks.add(new Task(WhatId=acc.Id,Subject='Review Call',Status='pending',ActivityDate=Date.today()));
		lstTasks.add(new Task(WhatId=acc.Id,Subject='Review Call',Status='in progress',ActivityDate=Date.today()));
		insert lstTasks;

		List<Event> lstEvents = new List<Event>();
		lstEvents.add(new Event(WhatId=acc.Id,Subject='in progress',ActivityDate=Date.today(),DurationInMinutes=100,ActivityDateTime=Datetime.now()));
		insert lstEvents;
					
		Opportunity opp = new Opportunity(AccountId=acc.Id,Name='test opp',CloseDate=Date.today(),StageName='pending');
		insert opp;  
		
        Test.setCurrentPage(Page.InternalRoadMapXMLData);
        
        //CustomerForLifeDataController ctrl = new CustomerForLifeDataController( new ApexPages.StandardController(acc) );
        //ctrl.getXMLData();	*/	
    }
}