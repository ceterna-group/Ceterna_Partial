/*
*  This code is written assuming that it will executed one account record at a time.
*  If more than 1 (like in bulk) accounts are updated, then it might run into hitting API limits.
*  The code is written to loop accounts and for each account, SF connects to Freshdesk and pushes the account data as a company. Same logic for creating contacts
*  Freshdesk v2 has a limitation as to we cannot create multiple companies/contacts at the same time, hence the loop.
*/

global class CreateFreshdeskCompanyContact {

	@Future(Callout=true)
	public static void createFreshdeskCompany(List<String> accountIds) {
		if(!accountIds.isEmpty() && accountIds.size() >= 1) {
			Map<String, String> salesforceIdToFreshdeskId = new Map<String, String>();
			
			//query the account records.
			Map<Id, Account> accountRecords = new Map<Id, Account>(
								[SELECT Id, Name, Description, Freshdesk_Support_Email_Address__c,
										Freshdesk_Domain_Names__c, Support_Name__c
								FROM Account
								WHERE Id IN :accountIds]);
			for(Account account : accountRecords.values()) {
				String responseBody = '';				
									
				//build the json string for the request body
				String bodyContent = buildBodyContent(account);
				
				//connect to freshdesk
				if(bodyContent != '') {
					Http http = new Http();
					HttpRequest req = buildWebServiceRequest(bodyContent, 'Account');
					HttpResponse res = invokeWebService(http, req, account.Id, 'Account');	
					responseBody = 	res.getBody();

					System.debug('create header is ' + res.getStatusCode());
					System.debug('create body is ' + res.getBody());

				}		
				
				//check if the response is successfull or has any validation error.
				if(responseBody != null && responseBody != '') {
		        	//will send a email if response has some validation error
		        	if(responseBody.contains('Validation failed')) {
		        		String errorMessage = parseErrorJSON(responseBody);
	        			sendErrorEmail('Company cannot be created on Freshdesk.\n\n Freshdesk validation errors while creating company.\n'+errorMessage+ '. \n\nSF Account Name: '+Account.Name);
		        	} else {
			        	//parser the response JSON and get the freshdesk id for created company 
			        	salesforceIdToFreshdeskId = getFreshdeskIdfromResponse('salesforce_account_id', responseBody); 
			        }       				        		
		        }	
			}
			
			//Update the account with the freshdesk id of created company
			List<Account> updateAccounts = new List<Account>();
			if(!salesforceIdToFreshdeskId.isEmpty()) {
				for(String accountId : salesforceIdToFreshdeskId.KeySet()) {
					Account acc = accountRecords.get(accountId);
					acc.Support_Name__c = salesforceIdToFreshdeskId.get(accountId);
					updateAccounts.add(acc);
				}
			}
			
			if(!updateAccounts.isEmpty()) update updateAccounts;							 
		} 
	}
	
	@future(callout=true)
	public static void createFreshdeskContact(List<String> contactIds)
	{
		if(!contactIds.isEmpty() && contactIds.size() >= 1)
		{
			Map<String, String> salesforceIdToFreshdeskId = new Map<String, String>();
			
			//query for contact records
			Map<Id, Contact> contactRecords = new Map<Id, Contact>(
								[SELECT Id, Name,  Email, Title, Phone, MobilePhone, AccountId,
										Freshdesk_Id__c, Account.Support_Name__c, Account.Name
								FROM Contact WHERE Id IN :contactIds]);

			for(Contact contact : contactRecords.values()) {
				String responseBody = '';				
									
				//build JSON string for request
				String bodyContent = buildBodyContentforContact(contact);
				
				//connect to freshdesk
				if(bodyContent != '') {
					Http http = new Http();
					HttpRequest req = buildWebServiceRequest(bodyContent, 'Contact');
					HttpResponse res = invokeWebService(http, req, contact.Id, 'Contact');	
					responseBody = 	res.getBody();			
				}		
				
				//parse the response JSON string for validation error or freshdesk id
				if(responseBody != null && responseBody != '') {
		        	//If the response has errors, then email will be sent with errors.
		        	if(responseBody.contains('Validation failed')) {
		        		String errorMessage = parseErrorJSON(responseBody);
	        			sendErrorEmail('Contact cannot be created on Freshdesk.\n\n Freshdesk validation errors while creating contact.\n'+errorMessage+ '. \n\nSF Contact Name"'+contact.Name+'" . \n SF Related Account Name: '+contact.Account.Name);
		        	} else {
		        		//parser the response JSON and get the freshdesk id for created contact 
		        		salesforceIdToFreshdeskId = getFreshdeskIdfromResponse('salesforce_contact_id', responseBody);      				        		
			        }
		        }
		        
		        //Update Sf contact with freshdesk id of newly created freshdesk contact.
		        List<Contact> updateContacts = new List<Contact>();
				if(!salesforceIdToFreshdeskId.isEmpty()) {

					for(String contactId : salesforceIdToFreshdeskId.KeySet()) {
						Contact con = contactRecords.get(contactId);
						con.Freshdesk_Id__c = salesforceIdToFreshdeskId.get(contactId);
						updateContacts.add(con);
					}
				}
				
				if(!updateContacts.isEmpty()) update updateContacts;					
			}
		}
	}
	
	//Parse json response
	public static Map<String, String> getFreshdeskIdfromResponse(String sfFieldName, String responseBody) {

		Map<String, String> salesforceIdToFreshdeskId = new Map<String, String>();
		Long freshdeskId = 0;
    	String sobjId = '';
    	
    	JSONParser jsonParser = JSON.createParser(responseBody);
    	while(jsonParser.nextToken() != null) {
    		if(jsonParser.getCurrentToken() == JSONToken.FIELD_NAME ) {
			 	String fieldName = jsonParser.getText();
			 	jsonParser.nextToken();
			 	if (fieldName == 'id') {
			 		freshdeskId = jsonParser.getLongValue();
			 	}
			 	if (fieldName == sfFieldName) {
			 		sobjId = jsonParser.getText();
			 	}
			}
		}
		salesforceIdToFreshdeskId.put(sobjId, String.valueOf(freshdeskId));  
		return salesforceIdToFreshdeskId;		
	}
	
	//Parse json for validation errors
	public static String parseErrorJSON(String response) {
		JSONParser errorParser = JSON.createParser(response);
		String freshdeskField = '';
		String errorMessage = '';
		while(errorParser.nextToken() != null) {
    		if(errorParser.getCurrentToken() == JSONToken.FIELD_NAME ) {
			 	String fieldName = errorParser.getText();
			 	errorParser.nextToken();
			 	if (fieldName == 'field') {
			 		freshdeskField = errorParser.getText();
			 	}
			 	if (fieldName == 'message') {
			 		errorMessage = errorParser.getText();
			 	}
			}
		}
		if(freshdeskField != '' && errorMessage != '')
			return freshdeskField + ' : ' + errorMessage;
		else 
			return '';
	}
	
	//Send an email listing the validation errors.
	public static void sendErrorEmail(String errorMessage) {

		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    	String[] toAddresses = new String[] {Label.freshdeskSupportUsername};    
    	mail.setToAddresses(toAddresses);
    	mail.setSenderDisplayName('Freshdesk : Apex Code Callout');
    	mail.setSubject('Freshdesk validation errors');
    	mail.setPlainTextBody(errorMessage);
    	
    	if(!Test.isRunningTest())
    		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
	
	//build json string for account
	public static String buildBodyContent(Account account) {

		String bodyContent = '';
		if((account.Freshdesk_Domain_Names__c != null) && (account.Freshdesk_Domain_Names__c != '')) {

				String domainName = '';
				String[] domains = new String[]{};	
						
				if(account.Freshdesk_Domain_Names__c.containsAny(','))	
					domains = account.Freshdesk_Domain_Names__c.split(',');					
				else if(account.Freshdesk_Domain_Names__c.containsWhitespace())
					domains = account.Freshdesk_Domain_Names__c.split(' ');
				else
					domainName = '"'+account.Freshdesk_Domain_Names__c+'"';

				for(Integer k = 0; k < domains.size(); k++)
				{
					if(k !=0  && k != domains.size())
						domainName += ' , ';
						
					domainName += '"'+domains[k]+'"';
				}	
				bodyContent +=
						' { "name":"'+account.Name+'", ' +
						'"description":"'+String.valueOf(account.Description)+'", ' +
						'"domains":['+domainName+'], ' +
						'"custom_fields":{"salesforce_account_id":"'+account.Id+'", ' +
						'"support_email_address":"'+account.Freshdesk_Support_Email_Address__c+'"}' +
						'}';
		} else
				bodyContent += ' { "name":"'+account.Name+'", ' +
						'"description":"'+String.valueOf(account.Description)+'", ' +
						'"custom_fields":{"salesforce_account_id":"'+account.Id+'", ' +
						'"support_email_address":"'+account.Freshdesk_Support_Email_Address__c+'"}}';
		return 	bodyContent;
	}
	
	//build json string for contact.
	public static String buildBodyContentforContact(Contact contact) {

		String bodyContent = ' { "name":"'+contact.Name+'", ' +
				'"email":"'+String.valueOf(contact.Email)+'", ' +
				'"job_title":"'+contact.Title+'", ' +
				'"phone":"'+contact.Phone+'", ' +
				'"mobile":"'+contact.MobilePhone+'", ' +
				'"company_id":'+contact.Account.Support_Name__c+', ' +
				'"custom_fields":{"salesforce_contact_id":"'+contact.Id+'"}}';

		return 	bodyContent;
	}  
	
	//establish connection to freshdesk and return response
	public static HttpRequest buildWebServiceRequest(String bodyContent, String sobjTypeString) {

		String responseBody = '';
		
		String endPointURL = '';
		if(sobjTypeString == 'Account')
			endPointURL = Label.freshdeskCompaniesEndPointURL;
      	else if(sobjTypeString == 'Contact')
      		endPointURL = Label.freshdeskContactsEndPointURL;
      	String userName = Label.freshdeskUsername; 
      	String password = Label.freshdeskPass; 
      	Blob headerValue = Blob.valueOf(userName + ':' + password);  
      	String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);      	
      	
		HttpRequest req = new HttpRequest();		    
		req.setEndpoint(endPointURL);     	
		req.setHeader('Content-Type', 'application/json');
		req.setHeader('Authorization', authorizationHeader);	
		req.setMethod('POST'); 
		req.setBody(bodyContent);
		return req;
	}
	
	//send the request
	public static HttpResponse invokeWebService(Http http, HttpRequest req, Id dummyIdForTesting, String typeObj) {

		HttpResponse res = new HttpResponse();

		try {
			if(Test.isRunningTest()) {
				if(typeObj == 'Account')
					res.setBody('{ \"id\": 14000099596, \"name\": \"test company1\", \"description\": \"test description\", ' +
							'\"note\": \"\", \"domains\": [ \"mycompany.com\" ], ' +
							'\"custom_fields\": ' +
							'{\"support_email_address\": \"abc@abc.com\", \"salesforce_account_id\": "'+dummyIdForTesting+'"}, ' +
							'\"created_at\": \"2016-04-18T08:30:59Z\", \"updated_at\": \"2016-04-18T08:30:59Z\"}');
				else if(typeObj == 'Contact')
					res.setBody('{\"active\":false,\"address\":null,\"company_id\":14000099596,\"deleted\":false,' +
							'\"description\":null,\"email\":\"rrr@rr.com\",\"id\":14001381241,' +
							'\"job_title\":\"Marketing Executive\",\"language\":\"en\",\"mobile\":\"07897623235\",' +
							'\"name\":\"test contact\",\"phone\":\"01494 333333\",\"time_zone\":\"Eastern Time (US & Canada)\"' +
							',\"twitter_id\":null,\"custom_fields\":{\"salesforce_contact_id\":"'+dummyIdForTesting+'"},' +
							'\"other_emails\":[],\"created_at\":\"2016-04-19T15:39:26Z\",\"updated_at\":\"2016-04-19T15:39:26Z\"}');
			} else {
				res = http.send(req);
			}
		} catch (System.CalloutException e) {
			System.debug('Callout error: '+ e);
        	System.debug(res.toString());
		}
		return res;
	}
	
}