@isTest
private class BatchForFreshdeskTicketsTest 
{
    static testmethod void testRetrieveTicketsFromFreshdesk()
    {
    	//create account with support name
    	Account acc = new Account(name='test '+system.now(), Support_Name__c = '8000114142');
    	insert acc;
    	
    	Test.startTest();
    	    Test.setMock(HttpCalloutMock.class, new MockCalloutForBatch());
    		Database.executeBatch(new BatchForFreshdeskTickets(), 200);
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
    		BatchForFreshdeskTicketsScheduler.ticketScheduler();
    	Test.stopTest();
    	
    }
    
    static testmethod void testGetExistingFreshdeskTickets()
    {
    	//create account with support name
    	Account acc = new Account(name='test '+system.now(), Support_Name__c = '8000114142');
    	insert acc;
    	
    	Freshdesk_Ticket__c ft = new Freshdesk_Ticket__c(Account__c = acc.Id, Description__c = 'test data', display_id__c = '157', Freshdesk_ID__c = '157', Subject__c = 'test data');
    	insert ft;
    	
    	Test.startTest();
    	BatchForFreshdeskTickets batch = new BatchForFreshdeskTickets();
    	Map<String, Freshdesk_Ticket__c> existingTickets = batch.getExistingFreshdeskTickets(new List<String>{ft.Freshdesk_ID__c});
    	Test.stopTest();
    	
    	System.assert(existingTickets.containsKey(ft.Freshdesk_ID__c));
    }
    
    static testMethod void testBuildUpsertList()
    {
    	//create account with support name
    	Account acc = new Account(name='test '+system.now(), Support_Name__c = '8000114142');
    	insert acc;
    	
    	Freshdesk_Ticket__c ft = new Freshdesk_Ticket__c(Account__c = acc.Id, Description__c = 'test data', display_id__c = '157', Freshdesk_ID__c = '157', Subject__c = 'test data');
    	insert ft;
    	
    	FreshdeskTicketsClass ftc = new FreshdeskTicketsClass();
    	ftc.subject = ft.Subject__c;
    	ftc.description = ft.Description__c;
    	ftc.id = Integer.valueOf(ft.Freshdesk_ID__c);
    	ftc.company_id = long.valueOf('8000114142');
    	
    	Map<String, Freshdesk_Ticket__c> existingTicketMap = new Map<String, Freshdesk_Ticket__c>{ft.Freshdesk_ID__c => ft};
    	
    	Map<String, Id> accountIdSupportNameMap = new Map<String, Id>{acc.Support_Name__c => acc.Id};
    	
    	Test.startTest();
    	BatchForFreshdeskTickets batch = new BatchForFreshdeskTickets();    	
    	BatchForFreshdeskTickets.FreshdeskTicketDetails upsertTicket = batch.buildUpsertList(ftc, new Map<String, Freshdesk_Ticket__c>(), accountIdSupportNameMap);    	
    	System.assertEquals(ftc.description, upsertTicket.ticket.Description__c);
    	System.assertEquals(ftc.subject, upsertTicket.ticket.Subject__c);
    	System.assertEquals(acc.Id, upsertTicket.ticket.Account__c);
    	System.assertEquals(ftc.id, Integer.valueOf(upsertTicket.ticket.Freshdesk_ID__c));
    	
    	BatchForFreshdeskTickets.FreshdeskTicketDetails upsertTicket1 = batch.buildUpsertList(ftc, existingTicketMap, accountIdSupportNameMap);
    	System.assertEquals(ftc.description, upsertTicket1.ticket.Description__c);
    	System.assertEquals(ftc.subject, upsertTicket1.ticket.Subject__c);
    	System.assertEquals(acc.Id, upsertTicket1.ticket.Account__c);
    	System.assertEquals(ftc.id, Integer.valueOf(upsertTicket1.ticket.Freshdesk_ID__c));
    	
    	Test.stopTest();
    }
    
    static testMethod void testBuildUpsertListDescription()
    {
    	//create account with support name
    	Account acc = new Account(name='test '+system.now(), Support_Name__c = '8000114142');
    	insert acc;
    	
    	Freshdesk_Ticket__c ft = new Freshdesk_Ticket__c(Account__c = acc.Id, Description__c = 'test data', display_id__c = '157', Freshdesk_ID__c = '157', Subject__c = 'test data');
    	insert ft;
    	
    	String descp = '<div class="WordSection1"> <div class="MsoNormal"><span style=font-size:10.5pt;font-family:"Overpass",sans-serif;color:#505961;mso-fareast-language:EN-US>Hi Laurence<div></div></span></div><div class="MsoNormal"><span style=font-size:10.5pt;font-family:"Overpass",sans-serif;color:#505961;mso-fareast-language:EN-US><div> </div></span></div>';
    	
    	FreshdeskTicketsClass ftc = new FreshdeskTicketsClass();
    	ftc.subject = ft.Subject__c;
    	ftc.description = descp;
    	ftc.id = Integer.valueOf(ft.Freshdesk_ID__c);
    	ftc.company_id = long.valueOf('8000114142');
    	
    	Map<String, Freshdesk_Ticket__c> existingTicketMap = new Map<String, Freshdesk_Ticket__c>{ft.Freshdesk_ID__c => ft};
    	
    	Map<String, Id> accountIdSupportNameMap = new Map<String, Id>{acc.Support_Name__c => acc.Id};
    	
    	Test.startTest();
    	BatchForFreshdeskTickets batch = new BatchForFreshdeskTickets();    	
    	BatchForFreshdeskTickets.FreshdeskTicketDetails upsertTicket = batch.buildUpsertList(ftc, new Map<String, Freshdesk_Ticket__c>(), accountIdSupportNameMap);    	
    	System.assertEquals(ftc.description.substring(0, 49), upsertTicket.ticket.Description__c);
    	System.assertEquals(ftc.subject, upsertTicket.ticket.Subject__c);
    	System.assertEquals(acc.Id, upsertTicket.ticket.Account__c);
    	System.assertEquals(ftc.id, Integer.valueOf(upsertTicket.ticket.Freshdesk_ID__c));
    	
    	BatchForFreshdeskTickets.FreshdeskTicketDetails upsertTicket1 = batch.buildUpsertList(ftc, existingTicketMap, accountIdSupportNameMap);
    	System.assertEquals(ftc.description.substring(0, 49), upsertTicket1.ticket.Description__c);
    	System.assertEquals(ftc.subject, upsertTicket1.ticket.Subject__c);
    	System.assertEquals(acc.Id, upsertTicket1.ticket.Account__c);
    	System.assertEquals(ftc.id, Integer.valueOf(upsertTicket1.ticket.Freshdesk_ID__c));
    	
    	Test.stopTest();
    }
}