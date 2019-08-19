global class BatchForFreshdeskTimecards implements Database.Batchable<sObject>, Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext BC) {
 		String query = 'Select Id, Freshdesk_ID__c from Freshdesk_Ticket__c where Freshdesk_ID__c != null';
 		return Database.getQueryLocator(query);
 	}
 	
 	global void execute(Database.BatchableContext BC, List<SObject> scope) {
 		List<FreshdeskTimecardsClass> timecardsClassList = new List<FreshdeskTimecardsClass>();
 		List<String> timecardIds 					= new List<String>();
 		List<Freshdesk_Timecard__c> timecardList 	= new List<Freshdesk_Timecard__c>();
 		
 		Map<String, Id> fdIdActualFDMap = new Map<String, Id>();
 		for(SObject sobj : scope) {
 			Freshdesk_Ticket__c ticket = (Freshdesk_Ticket__c) sobj;
 			fdIdActualFDMap.put(ticket.Freshdesk_ID__c, ticket.Id); 			
 		}
 		
 		if(!fdIdActualFDMap.isEmpty()) {
	    	String endPointURL = Label.freshdeskTimecardsEndPointURL;
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
		
		    try {
		        res = http.send(req);		       
		    } 
		    catch(System.CalloutException e) {
		        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		    	String[] toAddresses = new String[] {Label.freshdeskSupportUsername};
		    	mail.setToAddresses(toAddresses);
		    	mail.setSenderDisplayName('Apex Code Callout');
		    	mail.setSubject('Error');
		    	mail.setPlainTextBody('Callout error:   '+e);
		    	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		    }
		    
		    if(res.getBody() != null && res.getBody() != '') {

	        	JSONParser parser = JSON.createParser(res.getBody());
		        while (parser.nextToken() != null) {
		        	 if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
		        	 	 while (parser.nextToken() != null) 
		        	 	 {	
		        	       	if (parser.getCurrentToken() == JSONToken.START_OBJECT) 
		        	       	{	
		        	       		FreshdeskTimecardsClass timecards = (FreshdeskTimecardsClass)parser.readValueAs(FreshdeskTimecardsClass.class);
		        	       		timecardsClassList.add(timecards);
		        	       		if(timecards != null)
		        	       		{
		        	       			timecardIds.add(String.valueOf(String.valueOf(timecards.id)));
		        	       		}        	
		        	       	}
		        	 	 }
		        	 }	        	
		        }
	        }
	        
	        Map<String, Freshdesk_Timecard__c> existingTimecardMap = getExistingFreshdeskTimeCards(timecardIds);
	        
	        if(!timecardsClassList.isEmpty())
	        {
	        	for(FreshdeskTimecardsClass ftcc : timecardsClassList)
		        {
		        	Freshdesk_Timecard__c timecard = buildUpsertList(ftcc, existingTimecardMap, fdIdActualFDMap);	
		        	if(timecard != null)   timecardList.add(timecard);	        	
		        }	        	
	        }
	        
	        if(!timecardList.isEmpty())	upsert timecardList; 	    
	    }
 	}
 	
 	global void finish(Database.BatchableContext BC)
   	{      
   	}
   	
   	public Freshdesk_Timecard__c  buildUpsertList(FreshdeskTimecardsClass ftcc, Map<String, Freshdesk_Timecard__c> existingTimecardMap, Map<String, Id> fdIdActualFDMap)
   	{
   		Freshdesk_Timecard__c timecard = null;
   		if(ftcc != null && !fdIdActualFDMap.isEmpty())
   		{
	   		String ticketId = String.valueOf(ftcc.ticket_id);
	    	if(existingTimecardMap.containsKey(String.valueOf(ftcc.id)))
	    	{
	    		timecard = existingTimecardMap.get(String.valueOf(ftcc.id));
	    		if(timecard.time_spent__c != ftcc.time_spent)  timecard.time_spent__c = ftcc.time_spent;
	    		if(timecard.Note__c != ftcc.note)  timecard.Note__c = ftcc.note;
	    		if(timecard.created_at__c != ftcc.created_at)  timecard.created_at__c = ftcc.created_at;
	    		if(fdIdActualFDMap.containsKey(ticketId) && (timecard.Freshdesk_Ticket__c != fdIdActualFDMap.get(ticketId))) timecard.Freshdesk_Ticket__c = fdIdActualFDMap.get(ticketId);
	    	}
	    	else
	    	{
	    		if(fdIdActualFDMap.containsKey(ticketId))
	       		{		        	       			       		
	    			timecard = new Freshdesk_Timecard__c();
	    			timecard.time_spent__c = ftcc.time_spent;
	    			timecard.Freshdesk_ID__c = String.valueOf(ftcc.id);
	    			timecard.Note__c = ftcc.note;
	    			timecard.created_at__c = ftcc.created_at;
	    			timecard.Freshdesk_Ticket__c = fdIdActualFDMap.get(ticketId);
	       		}		        		
	    	}
   		}
   		return timecard;
   	}
   	
   	public Map<String, Freshdesk_Timecard__c> getExistingFreshdeskTimeCards(List<String> timecardIds)
   	{
   		Map<String, Freshdesk_Timecard__c> existingTimecardMap = new Map<String, Freshdesk_Timecard__c>();
        if(!timecardIds.isEmpty())
        {
        	//assuming less than 100 records	        	
	        List<Freshdesk_Timecard__c> existingFreshdeskTimecardsList = [Select id, created_at__c, Note__c, Freshdesk_ID__c, time_spent__c, Freshdesk_Ticket__c from Freshdesk_Timecard__c where Freshdesk_ID__c In :timecardIds];
	        if(!existingFreshdeskTimecardsList.isEmpty())
	        {
	        	for(Freshdesk_Timecard__c ft : existingFreshdeskTimecardsList)
	        	{
	        		existingTimecardMap.put(ft.Freshdesk_ID__c, ft);
	        	}
	        }       
        }
        return existingTimecardMap;
   	}
}