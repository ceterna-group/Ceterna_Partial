global class XeroInvoiceProcess {
    
            public static string Status;
        WebService static String handleInvoice(String invoiceNumber){
        system.debug('invoiceNumber is -->'+invoiceNumber);
        string xeroContactName;
        String Status1;
        List<Invoice__c> invlist;
        try
        {
        invlist = [Select inv.Xero_Account__c,
            inv.VAT__c,
            inv.VAT_Amount__c, 
            inv.Unit_Price__c,
            inv.Total_Amount__c,
            inv.Tax_Rate__c,
            inv.SystemModstamp,
            inv.Reference__c, 
            inv.Quantity__c,
            //inv.Project_Line__c, 
            inv.Name, 
            inv.LastModifiedDate, 
            inv.LastModifiedById, 
            inv.Item__c,
            inv.IsDeleted,
            inv.Invoice_Date__c,
            inv.Id, 
            inv.Due_Date__c, 
            inv.Description__c, 
            inv.CreatedDate, 
            inv.CreatedById, 
            inv.Xero_ID__c,
            inv.Amounts_Are__c,
            //inv.Account__r.Xero_Contact_Number__c,
            //inv.Account__r.Name,
            inv.Opportunity__c,
            inv.Account__r.Id,
            inv.Opportunity__r.Name,
            inv.Opportunity__r.Id,
            inv.Opportunity__r.Account.Xero_Contact_Number__c,
            inv.Opportunity__r.Account.Name,
            inv.Opportunity__r.Account.BillingCity,
            inv.Opportunity__r.Account.BillingPostalCode,
            inv.Opportunity__r.Account.BillingCountry,
            inv.Opportunity__r.Account.BillingState,
            inv.Opportunity__r.Account.BillingStreet,
            inv.Opportunity__r.Account.ShippingCity,
            inv.Opportunity__r.Account.ShippingPostalCode,
            inv.Opportunity__r.Account.ShippingCountry,
            inv.Opportunity__r.Account.ShippingState,
            inv.Opportunity__r.Account.ShippingStreet,
            inv.Opportunity__r.Contact_for_Invoice__r.FirstName,
            inv.Opportunity__r.Contact_for_Invoice__r.LastName,
            inv.Opportunity__r.Contact_for_Invoice__r.Email,
            inv.Account__c From Invoice__c inv where inv.name=: invoiceNumber ];
            if(invlist !=null && invlist.size()>0 && invlist.get(0).Opportunity__r.Account.Name !=null){
            	system.debug('Xero_Contact_Number__c is-->'+invlist.get(0).Opportunity__r.Account.Name);
                xeroContactName = queryContactFromXero(invlist.get(0).Opportunity__r.Account.Name);
                System.debug('Response from xero while quering contact is-->'+xeroContactName);
                if(test.isRunningTest())
				{
					xeroContactName=null;
				}
				if(Status==null)
				{
               		Status=createInvoice(invlist.get(0), xeroContactName);
				}
            }
            else
            {
            	if(invlist !=null && invlist.size()>0)
            	{
                	Status='Unable to Sync the Invoice as there is no Invoice available';
            	}
                else
                {
                	Status='Unable to Sync the Invoice as there is no Account available for the invoice :'+invoiceNumber;
                }
            }
        }
        catch(Exception ex)
        {
        	system.debug('Exception Occured while query contact and create invoice-->'+ex.getMessage());
        }
        Status1=Status;
            return Status1;
        }
    
    
    WebService static String queryContactFromXero(String xeroContName){
        // Create the request envelope
        DOM.Document doc = new DOM.Document();
        string resp;
        Httpresponse responseObj;
        try
        {
	        if(xeroContName !=null)
	        {
	           // responseObj = XeroPrivateConnection.syncXeroSFDC('GET','Contacts',xeroContName,null);
	            String wherecon='Name=='+'"'+xeroContName+'"';
	            system.debug('wherecon--->'+wherecon);
	            responseObj=XeroPrivateConnection.syncXeroSFDCWithWehereCondition('GET','Contacts', wherecon);
	            // Log the XML content
	            system.debug('responseObj--->'+responseObj);
	            if(responseObj!=null && responseObj.getStatusCode()==200 && responseObj.getBody() != null )
	            {
	            	system.debug('responseObj.getBody()--->'+responseObj.getBody());
	                resp = xmlParserContact(responseObj.getBody()); 
	            }
	            else
				{
					ExceptionStatus(responseObj,xeroContName,'Contacts');
				}
	            /*
	            else if(responseObj.getStatusCode()==204 || responseObj.getStatusCode()==401 || responseObj.getStatusCode()==402 || responseObj.getStatusCode()==403 || responseObj.getStatusCode()==404)
				{
					Status = 'Unable to sync with Xero: Authorization issue \n'+responseObj.getStatus();
				}
				else if(responseObj.getStatusCode()==500 || responseObj.getStatusCode()==501 || responseObj.getStatusCode()==502 || responseObj.getStatusCode()==503)
				{
					Status = 'Unable to sync with Xero: Server issue \n'+responseObj.getStatus();
				}
				else
				{
				    Status='Unable to Sync the Xero Contact details: '+xeroContName+':'+responseObj.getStatusCode()+' : '+responseObj.getStatus();
				}*/
	        }
        }
        catch(Exception ex)
        {
        	system.debug('Exception Occured while query and parse contact from Xero-->'+ex.getMessage());
        } 
        
        return resp;
    }
    
    
     WebService static String xmlParserContact(String strXml){
        String contName;
        try
        {
	         Dom.Document doc = new Dom.Document();
	         doc.load(strXml);
	          Dom.XMLNode Envelope = doc.getRootElement();
	        //  system.debug('Envelope--->'+Envelope);
	        if(Envelope.getChildElement('Contacts', null) !=null) {
	        Dom.XMLNode Body = Envelope.getChildElement('Contacts', null);
	        // system.debug('Body is==>'+Body);
	        Dom.XMLNode contBody = Body.getChildElement('Contact', null);
	        //system.debug('contBody==>'+contBody);
	        if(contBody !=null){
	            if(contBody.getChildElement('ContactNumber', null)!= null){
	                System.debug('Contact Nmumber is-->'+contBody.getChildElement('ContactNumber', null).getText());    
	            }
	             
	             if(contBody.getChildElement('Name', null)!= null){
	                System.debug('Contact Name is-->'+contBody.getChildElement('Name', null).getText());
	                contName =  contBody.getChildElement('Name', null).getText();            
	             }
	        }
	        }
        }
        catch(Exception ex)
        {
        	system.debug('Exception Occured while parsing contact-->'+ex.getMessage());
        }
        
        return contName;
    }

webservice static String createInvoice(Invoice__c onInvoice, String xeroContactName){
//String Status1;
Account accObj;
String xmlString;
Httpresponse responseObj;
try
	{
	if(onInvoice!=null)
	if(onInvoice.Opportunity__r.Account !=null)
	 accObj= onInvoice.Opportunity__r.Account;
	Dom.Document doc = new Dom.Document();
	 Dom.Xmlnode rootNode = doc.createRootElement('Invoices', null, null);
	Dom.Xmlnode InvoiceNode = rootNode.addChildElement('Invoice', null, null);
	InvoiceNode.addChildElement('Type', null, null).addTextNode('ACCREC');
	//Invoice Types
	//ACCPAY:	A bill – commonly known as a Accounts Payable or supplier invoice
	//ACCREC:	A sales invoice – commonly known as an Accounts Receivable or customer invoice
	
	if(onInvoice.Name !=null)
	InvoiceNode.addChildElement('InvoiceNumber', null, null).addTextNode(onInvoice.Name);
	
	if(onInvoice.Invoice_Date__c+'' !=null && onInvoice.Invoice_Date__c+''!='')
	InvoiceNode.addChildElement('Date', null, null).addTextNode(onInvoice.Invoice_Date__c+'');
	
	if(onInvoice.Due_Date__c+'' !=null && onInvoice.Due_Date__c+''!='')
	InvoiceNode.addChildElement('DueDate', null, null).addTextNode(onInvoice.Due_Date__c+'');
	
	if(onInvoice.Reference__c !=null && onInvoice.Reference__c!='')
	InvoiceNode.addChildElement('Reference', null, null).addTextNode(onInvoice.Reference__c);
	
	if(onInvoice.Amounts_Are__c !=null && onInvoice.Amounts_Are__c!='' && onInvoice.Amounts_Are__c=='Tax Exclusive')
	InvoiceNode.addChildElement('LineAmountTypes', null, null).addTextNode('Exclusive');
	
	Dom.Xmlnode contactNode = InvoiceNode.addChildElement('Contact', null, null);
	
	if(accObj.Xero_Contact_Number__c !=null && accObj.Xero_Contact_Number__c!='')
	contactNode.addChildElement('ContactNumber', null, null).addTextNode(accObj.Xero_Contact_Number__c);
	contactNode.addChildElement('Name', null, null).addTextNode((xeroContactName !=null && xeroContactName !='')?xeroContactName:(String)accObj.Name+'');
	//contactNode.addChildElement('ContactStatus', null, null).addTextNode('ACTIVE');
	//contactNode.addChildElement('EmailAddress', null, null).addTextNode('emailaddress@yourdomain.com');
	//contactNode.addChildElement('FirstName', null, null).addTextNode('Simon');
	//contactNode.addChildElement('LastName', null, null).addTextNode('Greenville');
	if(xeroContactName==null)
	{
	if(accObj.BillingCity!=null || accObj.BillingPostalCode!=null || accObj.BillingCountry!=null || accObj.BillingState!=null || accObj.BillingStreet!=null || onInvoice.Opportunity__r.Contact_for_Invoice__r.LastName !=null)
	     {
	            Dom.Xmlnode AddressesNode = contactNode.addChildElement('Addresses', null, null);
	            Dom.Xmlnode AddressNode = AddressesNode .addChildElement('Address', null, null);
	            AddressNode.addChildElement('AddressType', null, null).addTextNode('POBOX');
	            if(accObj.BillingStreet!=null)
	            AddressNode.addChildElement('AddressLine1', null, null).addTextNode(accObj.BillingStreet);
	            if(accObj.BillingCity!=null)
	            AddressNode.addChildElement('City', null, null).addTextNode(accObj.BillingCity);
	            if(accObj.BillingPostalCode!=null)
	            AddressNode.addChildElement('PostalCode', null, null).addTextNode(accObj.BillingPostalCode);
	            if(accObj.BillingCountry!=null)
	            AddressNode.addChildElement('Country', null, null).addTextNode(accObj.BillingCountry);
	            if(accObj.BillingState!=null)
	            AddressNode.addChildElement('Region', null, null).addTextNode(accObj.BillingState);
	            
	           if(onInvoice.Opportunity__r.Contact_for_Invoice__r.FirstName !=null && onInvoice.Opportunity__r.Contact_for_Invoice__r.FirstName !='')
	            contactNode.addChildElement('FirstName', null, null).addTextNode(onInvoice.Opportunity__r.Contact_for_Invoice__r.FirstName);
	            
	            if(onInvoice.Opportunity__r.Contact_for_Invoice__r.LastName !=null && onInvoice.Opportunity__r.Contact_for_Invoice__r.LastName !='')
	            contactNode.addChildElement('LastName', null, null).addTextNode(onInvoice.Opportunity__r.Contact_for_Invoice__r.LastName);
	            
	             if(onInvoice.Opportunity__r.Contact_for_Invoice__r.Email !=null && onInvoice.Opportunity__r.Contact_for_Invoice__r.Email !='')
	            contactNode.addChildElement('EmailAddress', null, null).addTextNode(onInvoice.Opportunity__r.Contact_for_Invoice__r.Email);
	
	     }
	  }
	     if(onInvoice.Description__c!=null || onInvoice.Quantity__c!=null || onInvoice.Unit_Price__c!=null || onInvoice.VAT_Amount__c!=null)
	     {
	            Dom.Xmlnode LineItemsNode = InvoiceNode.addChildElement('LineItems', null, null);
	            Dom.Xmlnode LineItemNode = LineItemsNode.addChildElement('LineItem', null, null);
	            if(onInvoice.Description__c!=null)
	            LineItemNode.addChildElement('Description', null, null).addTextNode(onInvoice.Description__c);
	            if(onInvoice.Quantity__c!=null)
	            LineItemNode.addChildElement('Quantity', null, null).addTextNode(onInvoice.Quantity__c+'');
	            if(onInvoice.Unit_Price__c!=null)
	            LineItemNode.addChildElement('UnitAmount', null, null).addTextNode(onInvoice.Unit_Price__c+'');
	            if(onInvoice.Total_Amount__c!=null)
	            LineItemNode.addChildElement('TaxAmount', null, null).addTextNode(onInvoice.VAT_Amount__c+'');
	            
	            if(onInvoice.Tax_Rate__c !=null && onInvoice.Tax_Rate__c!='' && onInvoice.Tax_Rate__c=='20% (VAT on Income)')
	            LineItemNode.addChildElement('TaxType', null, null).addTextNode('OUTPUT2');
	            
	            if(onInvoice.Xero_Account__c !=null && onInvoice.Xero_Account__c!='' && onInvoice.Xero_Account__c=='214 - Service/Fee Income')
	            LineItemNode.addChildElement('AccountCode', null, null).addTextNode('214'); 
	            
	            if(onInvoice.Item__c !=null && onInvoice.Item__c!='')
	            LineItemNode.addChildElement('ItemCode', null, null).addTextNode(onInvoice.Item__c); 
	            
	}
	
	xmlString=doc.toXmlString();
	if(xmlString!=null)
	{
		system.debug('string xml value-->'+xmlString);
		responseObj = XeroPrivateConnection.syncXeroSFDC('POST','Invoices',null,xmlString);
	}
	else
	{
		Status='LineItem, Account and Invoice information from Salesforce could not be prepared';
	}
}
catch(Exception ex)
{
    system.debug('Exception Occured while preparing the invoice string and send to xero-->'+ex.getMessage());
    Status=''+ex.getMessage();
}
if(responseObj!=null  && responseObj.getStatusCode()==200 && responseObj.getBody() != null)
{
           Status='Successfully synced the Invoice with xero is: '+onInvoice.Name;
  //update the the xero Id in salesforce from response xml
   try{
      Dom.Document document = new Dom.Document();
      document.load(responseObj.getBody());
       DOM.XMLNode risk = document.getRootElement();
         if(risk.getChildElement('Invoices', null) != null)
         {
		       Dom.XMLNode Body = risk.getChildElement('Invoices', null);
		       //system.debug('Body size is -->'+Body.getChildElements().size());
		       //system.debug('Body size is -->'+Body );
		        for(integer i=0;i<Body.getChildElements().size();i++){
		         Dom.XMLNode invBody= Body.getChildElements()[i];
		            if(invBody.getChildElement('InvoiceID', null) !=null){
		              onInvoice.Xero_ID__c = invBody.getChildElement('InvoiceID', null).getText();
		              update onInvoice;
		             }         
		        }
         }
   }
   catch(Exception ex)
   {
    	system.debug('Exception Occured while parsing and updating invoice id from xero-->'+ex.getMessage());
    	 Status=''+ex.getMessage();
   }
  
}
else if(responseObj!=null  && responseObj.getBody() != null && responseObj.getStatusCode()==400)
{
system.debug('fail to sync with xero-->');
try{
      Dom.Document document = new Dom.Document();
      document.load(responseObj.getBody());
      DOM.XMLNode risk = document.getRootElement();
      if(risk.getChildElement('Message', null) !=null) {
       Status = 'Unable to sync with Xero \n'+ risk.getChildElement('Message', null).getText()+'\n';
          Dom.XMLNode Body = risk.getChildElement('Elements', null);
        //  system.debug('Body is -->'+Body);
          Dom.XMLNode dataContractBody = Body .getChildElement('DataContractBase', null);
         // system.debug('dataContractBody is -->'+dataContractBody );
          Dom.XMLNode validationErrorsBody = dataContractBody.getChildElement('ValidationErrors', null);
        //  system.debug('validationErrorsBody is -->'+validationErrorsBody ); 
          Dom.XMLNode validationErrorBody = validationErrorsBody.getChildElement('ValidationError', null);
        //  system.debug('validationErrorsBody is -->'+validationErrorsBody ); 
          if(validationErrorBody.getChildElement('Message', null) !=null)
                Status = Status + validationErrorBody.getChildElement('Message', null).getText()+'\n';
           
           }
   
      
   }catch(Exception ex){
    system.debug('Exception Occured while parsing xero invoicestatus-->'+ex.getMessage());
    Status=''+ex.getMessage();
   }

}
else
{
	
	ExceptionStatus(responseObj,onInvoice.Name,'Invoices');
}
/*
else if(responseObj!=null  && (responseObj.getStatusCode()==204 || responseObj.getStatusCode()==401 || responseObj.getStatusCode()==402 || responseObj.getStatusCode()==403 || responseObj.getStatusCode()==404))
{
	Status = 'Unable to sync with Xero: Authorization issue \n'+responseObj.getStatus();
}
else if(responseObj!=null  && (responseObj.getStatusCode()==500 || responseObj.getStatusCode()==501 || responseObj.getStatusCode()==502 || responseObj.getStatusCode()==503))
{
	Status = 'Unable to sync with Xero: Server issue \n'+responseObj.getStatus();
}
else if(responseObj == null)
{
	Status='Network or Oauth connection problem';
}
else
{
    Status='Unable to Sync the Invoice: '+onInvoice.Name+':'+responseObj.getStatusCode()+' : '+responseObj.getStatus();
}*/
//Status1 =Status;
return Status;
}

public static String ExceptionStatus(Httpresponse responseObj,String InvName,String operationName){
if(responseObj!=null  && (responseObj.getStatusCode()==204 || responseObj.getStatusCode()==401 || responseObj.getStatusCode()==402 || responseObj.getStatusCode()==403 || responseObj.getStatusCode()==404))
{
	Status = 'Unable to sync with Xero: Authorization issue \n'+responseObj.getStatus();
}
else if(responseObj!=null  && (responseObj.getStatusCode()==500 || responseObj.getStatusCode()==501 || responseObj.getStatusCode()==502 || responseObj.getStatusCode()==503))
{
	Status = 'Unable to sync with Xero: Server issue \n'+responseObj.getStatus();
}
else if(responseObj != null && responseObj.getStatusCode()==0)
{
	Status='Network or Oauth connection problem';
}
else
{
	if(operationName=='Invoices')
	{
    	Status='Unable to Sync the Invoice: '+InvName+':'+responseObj.getStatusCode()+' : '+responseObj.getStatus();
	}
	else
	{
		Status='Unable to Sync the Xero Contact details: '+InvName+':'+responseObj.getStatusCode()+' : '+responseObj.getStatus();
	}
}
	
return 	Status;
}


}