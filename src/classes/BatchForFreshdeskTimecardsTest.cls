@isTest
private class BatchForFreshdeskTimecardsTest 
{
    static testmethod void testRetrieveTimecardsFromFreshdesk()
    {
    	//create account with support name
    	Account acc = new Account(name='test '+system.now(), Support_Name__c = '8000114142');
    	insert acc;
    	
    	Freshdesk_Ticket__c ft = new Freshdesk_Ticket__c(Account__c = acc.Id, Description__c = 'test data', display_id__c = '157', Freshdesk_ID__c = '157', Subject__c = 'test data');
    	insert ft;
    	
    	Test.startTest();
    	    Test.setMock(HttpCalloutMock.class, new MockCalloutForBatch());
    		Database.executeBatch(new BatchForFreshdeskTimecards(), 200);
    	Test.stopTest();
    }
    
    static testmethod void testScheduler()
    {
    	//create account with support name
    	Account acc = new Account(name='test '+system.now(), Support_Name__c = '8000114142');
    	insert acc;
    	
    	Freshdesk_Ticket__c ft = new Freshdesk_Ticket__c(Account__c = acc.Id, Description__c = 'test data', display_id__c = '157', Freshdesk_ID__c = '157', Subject__c = 'test data');
    	insert ft;
    	
    	Test.startTest();
    	    Test.setMock(HttpCalloutMock.class, new MockCalloutForBatch());
    		BatchForFreshdeskTimecardsScheduler.timecardScheduler();
    	Test.stopTest();
    	
    }
    
    static testmethod void testGetExistingFreshdeskTimeCards()
    {
    	Datetime currentdatetime = system.now();
    	//create account with support name
    	Account acc = new Account(name='test '+system.now(), Support_Name__c = '8000114142');
    	insert acc;
    	
    	Freshdesk_Ticket__c ft = new Freshdesk_Ticket__c(Account__c = acc.Id, Description__c = 'test data', display_id__c = '157', Freshdesk_ID__c = '157', Subject__c = 'test data');
    	insert ft;
    	
    	Freshdesk_Timecard__c ftc = new Freshdesk_Timecard__c(Freshdesk_ID__c = '8000091682', Freshdesk_Ticket__c = ft.id, time_spent__c = '00:30', Note__c = 'test data', created_at__c = currentdatetime);
    	insert ftc;
    	
    	Test.startTest();
    	BatchForFreshdeskTimecards batch = new BatchForFreshdeskTimecards();
    	Map<String, Freshdesk_Timecard__c> existingTimecards = batch.getExistingFreshdeskTimeCards(new List<String>{ftc.Freshdesk_ID__c});
    	Test.stopTest();
    	
    	System.assert(existingTimecards.containsKey(ftc.Freshdesk_ID__c));
    }
    
    static testMethod void testBuildUpsertList()
    {
    	Datetime currentdatetime = system.now();
    	//create account with support name
    	Account acc = new Account(name='test '+system.now(), Support_Name__c = '8000114142');
    	insert acc;
    	
    	Freshdesk_Ticket__c ft = new Freshdesk_Ticket__c(Account__c = acc.Id, Description__c = 'test data', display_id__c = '157', Freshdesk_ID__c = '157', Subject__c = 'test data');
    	insert ft;
    	
    	Freshdesk_Timecard__c ftc = new Freshdesk_Timecard__c(Freshdesk_ID__c = '8000091682', Freshdesk_Ticket__c = ft.id, time_spent__c = '00:30', Note__c = 'test data', created_at__c = currentdatetime);
    	insert ftc;
    	
    	FreshdeskTimecardsClass ftcc = new FreshdeskTimecardsClass();
    	ftcc.note = ftc.Note__c;
    	ftcc.ticket_id = Integer.valueOf(ft.Freshdesk_ID__c);
    	ftcc.time_spent = ftc.time_spent__c;
    	ftcc.created_at = currentdatetime;
    	ftcc.id = long.valueOf('8000091682');
    	
    	Map<String, Freshdesk_Timecard__c> existingTimecardMap = new Map<String, Freshdesk_Timecard__c>{ftc.Freshdesk_ID__c => ftc};
    	
    	Map<String, Id> fdIdFreshdeskMap = new Map<String, Id>{ft.Freshdesk_ID__c => ft.Id};
    	
    	Test.startTest();
    	BatchForFreshdeskTimecards batch = new BatchForFreshdeskTimecards();    	
    	Freshdesk_Timecard__c upsertTimecard = batch.buildUpsertList(ftcc, new Map<String, Freshdesk_Timecard__c>(), fdIdFreshdeskMap);    	
    	System.assertEquals(ftcc.note, upsertTimecard.Note__c);
    	System.assertEquals(ftcc.time_spent, upsertTimecard.time_spent__c);
    	System.assertEquals(ft.Id, upsertTimecard.Freshdesk_Ticket__c);
    	System.assertEquals(ftcc.id, long.valueOf(String.valueOf(upsertTimecard.Freshdesk_ID__c)));
    	
    	Freshdesk_Timecard__c upsertList1 = batch.buildUpsertList(ftcc, existingTimecardMap, fdIdFreshdeskMap);
    	System.assertEquals(ftcc.note, upsertList1.Note__c);
    	System.assertEquals(ftcc.time_spent, upsertList1.time_spent__c);
    	System.assertEquals(ft.Id, upsertList1.Freshdesk_Ticket__c);
    	System.assertEquals(ftcc.id, long.valueOf(String.valueOf(upsertList1.Freshdesk_ID__c)));
    	
    	Test.stopTest();
    }
}