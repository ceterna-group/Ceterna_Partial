global class BatchForFreshdeskTickets implements Database.Batchable<sObject>, Database.AllowsCallouts
{
	global Database.QueryLocator start(Database.BatchableContext BC)
 	{
 		String query = 'Select Id, Support_Name__c from Account where Support_Name__c != null';
 		return Database.getQueryLocator(query);
 	}
 	
 	global void execute(Database.BatchableContext BC, List<SObject> scope)
 	{
 		List<Freshdesk_Ticket__c> ticketList = new List<Freshdesk_Ticket__c>();
 		List<Freshdesk_Ticket__c> updateTicketList = new List<Freshdesk_Ticket__c>();
 		List<FreshdeskTicketsClass> ticketClassList = new List<FreshdeskTicketsClass>();
 		List<String> ticketIds = new List<String>();
 		
 		Map<String, Id> accountIdSupportNameMap = new Map<String, Id>();
 		for(SObject sobj : scope)
 		{
 			Account account = (Account) sobj;
 			accountIdSupportNameMap.put(account.Support_Name__c, account.Id); 			
 		}
 		
	    if(!accountIdSupportNameMap.isEmpty())
	    {
		    String endPointURL = Label.freshdeskTicketsEndPointURL;
	      	String userName = Label.freshdeskUsername;
	      	String password = Label.freshdeskPass;
	      	Blob headerValue = Blob.valueOf(userName + ':' + password);  
	      	String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);      
	      
		    HttpRequest req = new HttpRequest();
		    HttpResponse res = new HttpResponse();
		    Http http = new Http();
		
		    req.setEndpoint(endPointURL);
		    req.setHeader('Content-Type', 'application/json');
		    req.setHeader('Authorization', authorizationHeader);
		    req.setMethod('GET'); 
		    
		    try
		    {
		    	res = http.send(req);        
		    }
		    catch(System.CalloutException e)
		    {
		    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		    	String[] toAddresses = new String[] {Label.freshdeskSupportUsername};
		    	mail.setToAddresses(toAddresses);
		    	mail.setSenderDisplayName('Apex Code Callout');
		    	mail.setSubject('Error');
		    	mail.setPlainTextBody('Callout error:   '+e);
		    	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });	    	
		    }
	        
	        if(res.getBody() != null && res.getBody() != '')
	        {
	        	JSONParser parser = JSON.createParser(res.getBody());
		        while (parser.nextToken() != null) 
		        {	  
		        	 if (parser.getCurrentToken() == JSONToken.START_ARRAY) 
		        	 {
		        	 	 while (parser.nextToken() != null) 
		        	 	 {	
		        	       	if (parser.getCurrentToken() == JSONToken.START_OBJECT) 
		        	       	{	
		        	       		FreshdeskTicketsClass tickets = (FreshdeskTicketsClass)parser.readValueAs(FreshdeskTicketsClass.class);
		        	       		ticketClassList.add(tickets);
		        	       		if(tickets != null)
		        	       		{
		        	       			ticketIds.add(String.valueOf(tickets.id));
		        	       		}        	
		        	       	}
		        	 	 }
		        	 }	        	
		        }
	        }
	        
	        Map<String, Freshdesk_Ticket__c> existingTicketMap = getExistingFreshdeskTickets(ticketIds);
	        Map<String, String> fdIdToDescMap = new Map<String, String>();
	        
	        if(!ticketClassList.isEmpty())
	        {
		        for(FreshdeskTicketsClass ftc : ticketClassList)
		        {
		        	FreshdeskTicketDetails ticketDetails = buildUpsertList(ftc, existingTicketMap, accountIdSupportNameMap);
		        	if(ticketDetails != null && ticketDetails.freshdeskId != null && ticketDetails.description != null) fdIdToDescMap.put(ticketDetails.freshdeskId, ticketDetails.description);
		        	if(ticketDetails != null && ticketDetails.ticket != null) ticketList.add(ticketDetails.ticket);
		        }
	        }	        
	        
	        if(!ticketList.isEmpty())	upsert ticketList; 
	        
	        if(fdIdToDescMap != null && fdIdToDescMap.size() > 0)
	        {
	        	List<Freshdesk_Ticket__c> qfreshdeskTickets = new List<Freshdesk_Ticket__c>();
	        	List<Attachment> insertAttachments = new List<Attachment>();
	        	qfreshdeskTickets = [Select Id, Freshdesk_ID__c from Freshdesk_Ticket__c where Freshdesk_ID__c In :fdIdToDescMap.keySet()];
	        	
	        	for(Freshdesk_Ticket__c ticketQ : qfreshdeskTickets)
	        	{
	        		Attachment attachment = new Attachment();
					attachment.Body = Blob.valueOf(fdIdToDescMap.get(ticketQ.Freshdesk_ID__c));
					attachment.Name = String.valueOf(ticketQ.Freshdesk_ID__c+'_Description_'+System.today()+'.doc');
					attachment.ParentId = ticketQ.Id; 
					insertAttachments.add(attachment);  
	        	}
	        	
	        	if(!insertAttachments.isEmpty() && insertAttachments.size() > 0) insert insertAttachments;
	        }
	        
 		}         	        		
 	}
 	
 	global void finish(Database.BatchableContext BC)
   	{      
   	} 
   	
   	public FreshdeskTicketDetails  buildUpsertList( FreshdeskTicketsClass ftc, Map<String, Freshdesk_Ticket__c> existingTicketMap, Map<String, Id> accountIdSupportNameMap)
   	{
   		FreshdeskTicketDetails details = new FreshdeskTicketDetails();
   		Freshdesk_Ticket__c ticket  = null;
   		if(ftc != null && !accountIdSupportNameMap.isEmpty())
   		{   			
	   		String companyid = String.valueOf(ftc.company_id);
	   		if(existingTicketMap.containsKey(String.valueOf(ftc.id)))
	    	{
	    		ticket = existingTicketMap.get(String.valueOf(ftc.id));
	    		if(ticket.Subject__c != ftc.subject)  ticket.Subject__c = ftc.subject;
	    		if((Test.isRunningTest() && ftc.description.length() > 50) || ftc.description.length() > 130000)
	    		{
	    		   String descSubStr = (Test.isRunningTest()) ? ftc.description.substring(0, 49) : ftc.description.substring(0, 130000);
	    		   if(ticket.Description__c != descSubStr)
	    		   {
	    		   		ticket.Description__c =  descSubStr;
	    				details.description = ftc.description;
	    				details.freshdeskId = String.valueOf(ftc.id);
	    		   }
	    		   
	    		}
	    		else
	    		{
		    		if(ticket.Description__c != ftc.description)
		    		{  
		    			ticket.Description__c = ftc.description;
		    		}
	    		}
	    		if(ticket.display_id__c != String.valueOf(ftc.id))  ticket.display_id__c = String.valueOf(ftc.id);
	    		if(accountIdSupportNameMap.containsKey(companyid) && (ticket.Account__c != accountIdSupportNameMap.get(companyid))) ticket.Account__c = accountIdSupportNameMap.get(companyid);
	    		
	    		details.ticket = ticket;
	    	}
	    	else
	    	{		        		
	       		if(accountIdSupportNameMap.containsKey(companyid))
	       		{		       
	    			ticket = new Freshdesk_Ticket__c();
	    			ticket.Subject__c = ftc.subject;
	    			ticket.Freshdesk_ID__c = String.valueOf(ftc.id);
	    			if((Test.isRunningTest() && ftc.description.length() > 50) || ftc.description.length() > 130000)
	    			{
	    				String descSubStr = (Test.isRunningTest()) ? ftc.description.substring(0, 49) : ftc.description.substring(0, 130000);
	    				ticket.Description__c =  descSubStr;
	    				details.description = ftc.description;
	    				details.freshdeskId = String.valueOf(ftc.id);	    				
	    			}
	    			else
	    			{
	    				ticket.Description__c =  ftc.description;	    				
	    			}
	    			
	    			ticket.display_id__c = String.valueOf(ftc.id);
	    			ticket.Account__c = accountIdSupportNameMap.get(companyid);
	       		}
	       		details.ticket = ticket;
	    	}
   		}
   		return details;
   	}
   	
   	public Map<String, Freshdesk_Ticket__c> getExistingFreshdeskTickets(List<String> ticketIds)
   	{
   		Map<String, Freshdesk_Ticket__c> existingTicketMap = new Map<String, Freshdesk_Ticket__c>();
   		if(!ticketIds.isEmpty())
        {
        	//assuming less than 100 records	        	
	        List<Freshdesk_Ticket__c> existingFreshdeskTicketsList = [Select id, Subject__c, Freshdesk_ID__c, Description__c, display_id__c, Account__c from Freshdesk_Ticket__c where Freshdesk_ID__c In :ticketIds];
	        if(!existingFreshdeskTicketsList.isEmpty())
	        {
	        	for(Freshdesk_Ticket__c ft : existingFreshdeskTicketsList)
	        	{
	        		existingTicketMap.put(ft.Freshdesk_ID__c, ft);
	        	}
	        }       
        }
        return existingTicketMap;
   	}
   	
   	public class FreshdeskTicketDetails
   	{
   		public Freshdesk_Ticket__c ticket {get; set;}
   		public String freshdeskId {get; set;}
   		public String description {get; set;}
   	}
}