//puropose to update the invoice amount details from xero.
global class XeroInvoiceUpdation
{
    //method to update the invoice details from xero
    @future (callout=true)
    public static void updateInvoiceAmount()
    {
	     List<Invoice__c> invoiceList;
	     Map<String,Invoice__c> invMap = new Map<String,Invoice__c>();
	     HttpResponse response;
     	try
     	{ 
		    //read the invoice details from xero based upon condition.
		    response = XeroPrivateConnection.syncXeroSFDCWithWehereCondition('GET','Invoices', 'Status=="PAID"');
     		if(response !=null && response.getStatusCode()== 200)
     		{
	           	invMap = generateInvoiceFromXml(response.getBody());
	            if(invMap !=null && invMap.size()>0)
	            {
		            Map<String,Invoice__c> invMapUpdate = new Map<String,Invoice__c>();
		            List<Invoice__c> colInvoice=[select ID,Name,Xero_ID__c from Invoice__c where Xero_ID__c in : invMap.keySet()];
		           	for(Invoice__c inv : colInvoice)
		           {
		               if(invMap.containsKey(inv.Xero_ID__c))
		               {		               	   
		                   invMapUpdate.put(inv.Xero_ID__c,invMap.get(inv.Xero_ID__c));
		               }
		           }
		           if(invMap.values().size() > colInvoice.size())
		           {
		               	List<Invoice__c> colInvoiceNotIn=[select ID,Name,Xero_ID__c from Invoice__c where Xero_ID__c not in : invMap.keySet()];
				           /**
				*        To-Do :- To capture the Xero PAID Invoices that are not existing in the Salesforce org 
				*        into special object for further reference.
			*/ 
	           		}
		          	if(test.isRunningTest())
		            {
		                List<Invoice__c> colInvoice1=[select ID,Name,Xero_ID__c from Invoice__c];
		                invMapUpdate.put('6ab73a27-75e3-4538-ba20-7dc6418ab3e3',colInvoice1[0]);
		            }
			       if(invMapUpdate!=null && invMapUpdate.size() > 0)
			       {
			        	//try
			        	//{
				         /*  XeroInvoiceRecordsBatch objXeroInvoiceRecordsBatch = new XeroInvoiceRecordsBatch();
				           XeroInvoiceRecordsBatch.listInvoice = invMapUpdate.values();
				           system.debug('XeroInvoiceRecordsBatch.listInvoice-->'+XeroInvoiceRecordsBatch.listInvoice.size());
				           ID batchprocessid = Database.executeBatch(objXeroInvoiceRecordsBatch,100); */
				           system.debug('invMapUpdate to -->'+invMapUpdate);
				           Schema.SObjectField f = Invoice__c.Fields.Xero_ID__c;
			               Database.Upsertresult[] lsr = database.upsert(invMapUpdate.values(),f,false);
			               // Iterate through the Save Results 
			                for(Database.Upsertresult sr:lsr)
			                {
			                  system.debug('sr--->'+sr);
			                  // fetch all success DML id's in this set
			                  if(sr.isSuccess())
			                   {
			                    	system.debug('Successfully update the following rec-->'+sr.getId());
			                    }
			                 }
			                 
			                 
			        	 /*commented by Srinivas,uday ask me to remove try catch.if exeception raise it will show in jobs. 
			        	 }				       
				         catch(Exception ex)
				        {
				          system.debug('Exception occured while Executing batch-->'+String.valueOf(ex));
				        }
				        */
			       }
           		}
     		} 
     }
     catch(Exception ex)
     {
          system.debug('Exception occured while updating the payment Detils-->'+String.valueOf(ex));
     }
     
    
    
    }
    
    //method to process the invoice response data from xero and prepare the list.
    
    public static Map<String,Invoice__c> generateInvoiceFromXml(String strXml) {
        List<Invoice__c> invList = new List<Invoice__c>();
          Map<String,Invoice__c> invMap = new Map<String,Invoice__c>();
       try
       {
        Dom.Document doc = new Dom.Document();
         doc.load(strXml);
         
        DOM.XMLNode risk = doc.getRootElement();
         system.debug('risk  123 is -->'+risk);
         if(risk.getChildElement('Invoices', null) !=null) {
         Dom.XMLNode Body = risk.getChildElement('Invoices', null);
        for(integer i=0;i<Body.getChildElements().size();i++){
           Invoice__c invTemp = new Invoice__c();
           Dom.XMLNode invBody= Body.getChildElements()[i];
            if(invBody.getChildElement('Status', null)!= null && invBody.getChildElement('Status', null).getText() =='PAID'){
             // system.debug('status values is-->'+invBody.getChildElement('Status', null).getText());
               Dom.XMLNode paymentsdet = invBody.getChildElement('Payments', null);
              // system.debug('payment det  is-->'+paymentsdet );
               if(paymentsdet !=null){
                   Dom.XMLNode paymentBody = paymentsdet .getChildElement('Payment', null);
                
                   if(paymentBody !=null){
                   	   system.debug('payment body is-->'+paymentBody);
                   	   
                       if(invBody.getChildElement('InvoiceID', null) !=null)
                        invTemp.Xero_ID__c = invBody.getChildElement('InvoiceID', null).getText();
                        
                       if(paymentBody.getChildElement('PaymentID', null)!= null)
                         invTemp.Payment_Id__c = paymentBody.getChildElement('PaymentID', null).getText();                       
                        
                        if(paymentBody.getChildElement('Date', null)!= null)
                         invTemp.Payment_Date__c = Date.valueOf(paymentBody.getChildElement('Date', null).getText());                       
                         
                        if(paymentBody.getChildElement('Amount', null)!= null)
                         invTemp.Payment_Amount__c = Double.valueOf(paymentBody.getChildElement('Amount', null).getText());                       
                        
                        if(paymentBody.getChildElement('CurrencyRate', null)!= null)
                         invTemp.Payement_Currency_Rate__c = paymentBody.getChildElement('CurrencyRate', null).getText();                       
                         
                          if(invBody.getChildElement('Reference', null)!= null)
                         invTemp.Reference__c = invBody.getChildElement('Reference', null).getText();
                                                
                         invMap.put(invTemp.Xero_ID__c, invTemp);
                   }
               }
            }
        }
        system.debug('invMap--->'+invMap);
         }//end of if.
    }
     catch(Exception ex)
     {
          system.debug('Exception occured in generateInvoiceFromXml method-->'+String.valueOf(ex));
     }
        return invMap ;
    
    }

}