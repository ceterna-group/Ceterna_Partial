global class XeroPrivateConnection {
   private static String  Keyy =  Label.xpvk;
   //'MIICXAIBAAKBgQCu9tg7OGDDh3MPVo20a4sEb4oOnNu1OipPzbsam5fewPfD787tCnKuLTyr4KEHqPVIH1bgVLrrKkt3/kot0pyd75TlbuMqBRR2oW5RT6Ra/ev5oINV8UcEUN1AkqAUxa/cu7Yo9t0pj7ZyAqG02D6Zc8+3LH6e6Ov7ux8TOV592QIDAQABAoGAM8+XIppEVUJz+RPJbKb4CL065a7fhOAPjYg/otZ2d5kvBY+q+BjC8v8kW0VuigUndU8Ke+27WE4zAPqFXuJiTAjFLsOTVVwKquNmc3T3kBRVqb4H0kUpZ8+aaRngdOBlH6iFcmRRzgW/3x6jPsMmWSWhYBDhmM2P5iwUg4RVeV0CQQDnFpOkXxRf2cLM4siebs8+gAnj7wsMwGnqpajSU5Bn7bQUY9Q0LM1+9FqIkb0CVj9CKV8ArIhpVbo+XXt2CHyDAkEAwdNlKKjgHGXCWk/LE92B/NfF2H9XUaWhBWeWAZMKPq4e7Flt1wOJzhC2ZYudya2RnDACy32JeFXz3v6eyGAFcwJAF0WmyL7qhlyfyZJtMcdnB5xNYq8IJdia0g6s2cGgoVbG8+a50CdS6p4hH+/NYRbeeANClgbKFhGUGAPCEzj3kQJAOBzYE15Yi0AWdQjWtOiSwj1BZLzw7Y0ywZrMfaYw+BZ2k1wMhYvbsFF8TIeP5ZwfJIVtubWdP746fNtf4oiR6wJBALTozuFkYRVLIcBU/THEr9fpUN5LTK7XqSFtJwV1508vIhX1O4LsOQL2VaRV1ivxJv1C2QMX7NJ67o5kObzUneM=';
 //   'MIICXAIBAAKBgQCQ9pwysy+by5eBzUwHNGPppnXtHs+RqX2AVarU2vc9g5sm7g/yOvt3hqQ9a1CbvTyo6qvVbRMpVHV0L+N4Ql9wBA5d03r4wgKJX/D5Pc39IvocY6DsJXzjmWeRgelP393X9IAKY68RXumyFTpwFv3T1yKVXEHEMWcrWen5qXCEOQIDAQABAoGARseShpLE+R3UEPWrXI0xB4FWbPuxP57w/ztU2O887tUWaVCtiolQBRFBmheO2SvxtUw3sFK8m154ps1HFI3byLqjVqUd1UJ+ER6zoEK+ObhLToXhc5WKgNTXeHljMkSPM2x7DofNfw2gDbHK3XpLdKJQZCHdLGseEQqsjGQEd90CQQDBH6fnRPntJ/uaX8pW99lEqQE39sw7UzW+IIjG0IcrGv0xsGGH8P1b+iG2oJpLxfX2xnIRU8YTO+44zJebi4JTAkEAwCjrDoUps8MXmAor2cSn5oA4mA9lZ6l66owrc/w3xoixXse7ND21Ek+5ca1SUw4U++WFyB+FGo6RkOnecAjlwwJBAL7pHkA/LZnFlrGq1AlZBc0cDPpX3NkgjtYer1dquNRh374JEMEj+DG+eSliZmVVkqqazhRW7k4BRqObjJvVM8UCQAZED04c53w2G1nY0w85y2PHwJCsx9i2fQyS34PbsJHnuSjnCGKutG3RbbGYPjv5FJQWKuOYq4VvKq34AknS8HMCQAtKRNcEl8UjeobsnguBFL3xon/zjdlz45NKMhYaydt6oyTBvTFT/t/FkPa6qfLY62JlWNczE9hxdvVurts/oPU=';
    private static String timestamp;
    private static String signatureMethod;
    private static String consumerKey;
    private static String oauthVersion;
    private static String oautheToken;    
    private static String xeroUrl;
    private static String urlEncoding;
    
 public static HttpResponse syncXeroSFDC(String reqMethod,String operationName, String requestId,String xeroCreateXml)
 {
     Http http = new Http();
     HttpRequest req = new Httprequest();
     HttpResponse res = new HttpResponse();
     String finalUrl;
     String host;
     String nonce;
     String str;
     String EncSig;
     Blob sig;
     String signature;
     //map to hold xero credentials parameters.
     map<String, String> parameters = new Map<String, String>();
     //to hold parameter map keys.
     List<String> keys = new List<String>();
     try
	 {
	     //prearing nonce for Xero
	     nonce = String.valueOf(Crypto.getRandomLong());
	     // Generate timestamp for current time
	     timestamp = String.valueOf(DateTime.now().getTime()/1000);
	     //checking the custom setting for Xero Credentials.
	     if(Xero_Settings__c.getall().values()!=null)
	     {
		     for(Xero_Settings__c xeroSet : Xero_Settings__c.getall().values())
		     {
		          signatureMethod 	= xeroSet.Oauth_Signature_Method__c;
		          oauthVersion 		= xeroSet.Oauth_Version__c;
		          oautheToken 		= xeroSet.Oatuh_Token__c;
		          consumerKey 		= xeroSet.Oauth_Consumer_Key__c;
		          xeroUrl 			= xeroSet.Xero_Url__c;
		          signatureMethod 	= xeroSet.Oauth_Signature_Method__c;
		          urlEncoding 		= xeroSet.Url_Encoding__c;
		     }//end of for.
	    }// end of if.
	    //puttting the parameters into the map
	    parameters.put('oauth_token',oautheToken);
	    parameters.put('oauth_consumer_key',consumerKey);
	    parameters.put('oauth_signature_method',signatureMethod );
	    parameters.put('oauth_timestamp',timestamp);
	    parameters.put('oauth_nonce',nonce);
	    parameters.put('oauth_version',oauthVersion);
	    //setting the request method in HttpRequest
	    req.setMethod(reqMethod);
	    if(requestId !=null && requestId.length()>0){req.setEndpoint(xeroUrl+'/'+operationName+'/'+requestId);}
	    else{req.setEndpoint(xeroUrl+'/'+operationName);}
	    //setting Http request endpoint.
	    host = req.getEndpoint();
	    keys.addAll(parameters.keySet());
	    keys.sort();
	    str = keys.get(0)+'='+parameters.get(keys.get(0));
	    for(Integer i=1;i<keys.size();i++) 
	    {
	    	str = str +'&'+keys.get(i)+'='+parameters.get(keys.get(i));
	    }
	    EncSig =  req.getMethod().toUpperCase()+ '&' + 
	    EncodingUtil.urlEncode(host, urlEncoding) +'&'+ EncodingUtil.urlEncode(str, urlEncoding);
	    //preparing signature for xero.
	    sig = Crypto.sign(signatureMethod, Blob.valueOf(EncSig), EncodingUtil.base64decode(Keyy));
	    signature = EncodingUtil.base64encode(sig);
	    signature=EncodingUtil.urlEncode(signature, urlEncoding);
		if(requestId !=null && requestId.length()>0)
		{
			req.setEndpoint(xeroUrl+'/'+operationName+'/'+requestId+'?oauth_token='+oautheToken+'&oauth_consumer_key='+consumerKey+'&oauth_signature_method='+signatureMethod+'&oauth_version='+oauthVersion+'&oauth_nonce='+nonce+'&oauth_timestamp='+timestamp+'&oauth_signature='+signature);
		}
		else
		{
			req.setEndpoint(xeroUrl+'/'+operationName+'?oauth_token='+oautheToken+'&oauth_consumer_key='+consumerKey+'&oauth_signature_method='+signatureMethod+'&oauth_version='+oauthVersion+'&oauth_nonce='+nonce+'&oauth_timestamp='+timestamp+'&oauth_signature='+signature);
		}
	    if(reqMethod=='POST')
	    {
		     req.setHeader('Content-Type','text/xml');
		     req.setBody(xeroCreateXml);
	    }
	 }
	 catch(Exception ex)
	 {
	 	system.debug('Exception Occured while Preparing signature-->'+ex.getMessage());
	 	
	 }
 	try
		{
		if(test.isRunningTest())
		{
			res.setStatusCode(200);
		
		
		string strXml2='<Response>\n'+
	  '<Id>c8a8c8ee-098f-424b-b7d9-f49e4ba1bf71</Id>\n'+
	  '<Status>OK</Status>\n'+
	  '<ProviderName>Xero API Previewer</ProviderName>\n'+
	  '<DateTimeUTC>2013-11-17T18:30:37.3325631Z</DateTimeUTC>\n'+
	  '<Invoices>\n'+
	    '<Invoice>\n'+
	      '<Contact>\n'+
	        '<ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
	        '<Name>Ratna Tatikonda</Name>\n'+
	      '</Contact>\n'+
	      '<Date>2013-11-13T00:00:00</Date>\n'+
	      '<DueDate>2013-12-21T00:00:00</DueDate>\n'+
	      '<Status>AUTHORISED</Status>\n'+
	      '<LineAmountTypes>Inclusive</LineAmountTypes>\n'+
	      '<SubTotal>100.00</SubTotal>\n'+
	      '<TotalTax>0.00</TotalTax>\n'+
	      '<Total>100.00</Total>\n'+
	      '<UpdatedDateUTC>2013-11-12T14:58:55.42</UpdatedDateUTC>\n'+
	      '<CurrencyCode>GBP</CurrencyCode>\n'+
	      '<Type>ACCREC</Type>\n'+
	      '<InvoiceID>6ab73a27-75e3-4538-ba20-7dc6418ab3e3</InvoiceID>\n'+
	      '<InvoiceNumber>INV-API-001</InvoiceNumber>\n'+
	      '<AmountDue>100.00</AmountDue>\n'+
	      '<AmountPaid>0.00</AmountPaid>\n'+
	      '<HasAttachments>false</HasAttachments>\n'+
	    '</Invoice>\n'+
	'<Invoice>\n'+
	      '<Contact>\n'+
	       ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
	        '<Name>Ratna Tatikonda</Name>\n'+
	      '</Contact>\n'+
	     ' <Date>2013-11-18T00:00:00</Date>\n'+
	      '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
	      '<Status>PAID</Status>\n'+
	     ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
	     ' <SubTotal>60000.00</SubTotal>\n'+
	      '<TotalTax>12000.00</TotalTax>\n'+
	      '<Total>72000.00</Total>\n'+
	      '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
	     ' <CurrencyCode>GBP</CurrencyCode>\n'+
	      '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
	     ' <Type>ACCREC</Type>\n'+
	      '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
	      '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
	      '<Reference>Test oppor</Reference>\n'+
	      '<Payments>\n'+
	       ' <Payment>\n'+
	        '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
	         ' <Date>2013-11-18T00:00:00</Date>\n'+
	          '<Amount>72000.00</Amount>\n'+
	          '<CurrencyRate>1.000000</CurrencyRate>\n'+
	        '</Payment>\n'+
	      '</Payments>\n'+
	     ' <AmountDue>0.00</AmountDue>\n'+
	     ' <AmountPaid>72000.00</AmountPaid>\n'+
	     ' <HasAttachments>false</HasAttachments>\n'+
	    '</Invoice>\n'+
	    '<Invoice>\n'+
	      '<Contact>\n'+
	       ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
	        '<Name>Ratna Tatikonda</Name>\n'+
	      '</Contact>\n'+
	     ' <Date>2013-11-18T00:00:00</Date>\n'+
	      '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
	      '<Status>PAID</Status>\n'+
	     ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
	     ' <SubTotal>60000.00</SubTotal>\n'+
	      '<TotalTax>12000.00</TotalTax>\n'+
	      '<Total>72000.00</Total>\n'+
	      '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
	     ' <CurrencyCode>GBP</CurrencyCode>\n'+
	      '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
	     ' <Type>ACCREC</Type>\n'+
	      '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
	      '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
	      '<Reference>Test oppor</Reference>\n'+
	      '<Payments>\n'+
	       ' <Payment>\n'+
	        '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
	         ' <Date>2013-11-18T00:00:00</Date>\n'+
	          '<Amount>72000.00</Amount>\n'+
	          '<CurrencyRate>1.000000</CurrencyRate>\n'+
	        '</Payment>\n'+
	      '</Payments>\n'+
	     ' <AmountDue>0.00</AmountDue>\n'+
	     ' <AmountPaid>72000.00</AmountPaid>\n'+
	     ' <HasAttachments>false</HasAttachments>\n'+
	    '</Invoice>\n'+
	    '<Invoice>\n'+
	      '<Contact>\n'+
	       ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
	        '<Name>Ratna Tatikonda</Name>\n'+
	      '</Contact>\n'+
	     ' <Date>2013-11-18T00:00:00</Date>\n'+
	      '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
	      '<Status>PAID</Status>\n'+
	     ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
	     ' <SubTotal>60000.00</SubTotal>\n'+
	      '<TotalTax>12000.00</TotalTax>\n'+
	      '<Total>72000.00</Total>\n'+
	      '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
	     ' <CurrencyCode>GBP</CurrencyCode>\n'+
	      '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
	     ' <Type>ACCREC</Type>\n'+
	      '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
	      '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
	      '<Reference>Test oppor</Reference>\n'+
	      '<Payments>\n'+
	       ' <Payment>\n'+
	        '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
	         ' <Date>2013-11-18T00:00:00</Date>\n'+
	          '<Amount>72000.00</Amount>\n'+
	          '<CurrencyRate>1.000000</CurrencyRate>\n'+
	        '</Payment>\n'+
	      '</Payments>\n'+
	     ' <AmountDue>0.00</AmountDue>\n'+
	     ' <AmountPaid>72000.00</AmountPaid>\n'+
	     ' <HasAttachments>false</HasAttachments>\n'+
	    '</Invoice>\n'+
	    '<Invoice>\n'+
	      '<Contact>\n'+
	       ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
	        '<Name>Ratna Tatikonda</Name>\n'+
	      '</Contact>\n'+
	     ' <Date>2013-11-18T00:00:00</Date>\n'+
	      '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
	      '<Status>PAID</Status>\n'+
	     ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
	     ' <SubTotal>60000.00</SubTotal>\n'+
	      '<TotalTax>12000.00</TotalTax>\n'+
	      '<Total>72000.00</Total>\n'+
	      '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
	     ' <CurrencyCode>GBP</CurrencyCode>\n'+
	      '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
	     ' <Type>ACCREC</Type>\n'+
	      '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
	      '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
	      '<Reference>Test oppor</Reference>\n'+
	      '<Payments>\n'+
	       ' <Payment>\n'+
	        '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
	         ' <Date>2013-11-18T00:00:00</Date>\n'+
	          '<Amount>72000.00</Amount>\n'+
	          '<CurrencyRate>1.000000</CurrencyRate>\n'+
	        '</Payment>\n'+
	      '</Payments>\n'+
	     ' <AmountDue>0.00</AmountDue>\n'+
	     ' <AmountPaid>72000.00</AmountPaid>\n'+
	     ' <HasAttachments>false</HasAttachments>\n'+
	    '</Invoice>\n'+
	    '<Invoice>\n'+
	      '<Contact>\n'+
	       ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
	        '<Name>Ratna Tatikonda</Name>\n'+
	      '</Contact>\n'+
	     ' <Date>2013-11-18T00:00:00</Date>\n'+
	      '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
	      '<Status>PAID</Status>\n'+
	     ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
	     ' <SubTotal>60000.00</SubTotal>\n'+
	      '<TotalTax>12000.00</TotalTax>\n'+
	      '<Total>72000.00</Total>\n'+
	      '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
	     ' <CurrencyCode>GBP</CurrencyCode>\n'+
	      '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
	     ' <Type>ACCREC</Type>\n'+
	      '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
	      '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
	      '<Reference>Test oppor</Reference>\n'+
	      '<Payments>\n'+
	       ' <Payment>\n'+
	        '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
	         ' <Date>2013-11-18T00:00:00</Date>\n'+
	          '<Amount>72000.00</Amount>\n'+
	          '<CurrencyRate>1.000000</CurrencyRate>\n'+
	        '</Payment>\n'+
	      '</Payments>\n'+
	     ' <AmountDue>0.00</AmountDue>\n'+
	     ' <AmountPaid>72000.00</AmountPaid>\n'+
	     ' <HasAttachments>false</HasAttachments>\n'+
	    '</Invoice>\n'+
	    '<Invoice>\n'+
	      '<Contact>\n'+
	       ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
	        '<Name>Ratna Tatikonda</Name>\n'+
	      '</Contact>\n'+
	     ' <Date>2013-11-18T00:00:00</Date>\n'+
	      '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
	      '<Status>PAID</Status>\n'+
	     ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
	     ' <SubTotal>60000.00</SubTotal>\n'+
	      '<TotalTax>12000.00</TotalTax>\n'+
	      '<Total>72000.00</Total>\n'+
	      '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
	     ' <CurrencyCode>GBP</CurrencyCode>\n'+
	      '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
	     ' <Type>ACCREC</Type>\n'+
	      '<InvoiceID>BalleSrinvias</InvoiceID>\n'+
	      '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
	      '<Reference>Test oppor</Reference>\n'+
	      '<Payments>\n'+
	       ' <Payment>\n'+
	        '  <PaymentID>123456</PaymentID>\n'+
	         ' <Date>2013-11-18T00:00:00</Date>\n'+
	          '<Amount>72000.00</Amount>\n'+
	          '<CurrencyRate>1.000000</CurrencyRate>\n'+
	        '</Payment>\n'+
	      '</Payments>\n'+
	     ' <AmountDue>0.00</AmountDue>\n'+
	     ' <AmountPaid>72000.00</AmountPaid>\n'+
	     ' <HasAttachments>false</HasAttachments>\n'+
	    '</Invoice>\n'+
	  '</Invoices>\n'+
	'</Response>';
			res.setBody(strXml2);
			
		}     
		else
		{    
			if(req != null)
			res=http.send(req);
		}
	}
	catch(Exception ex)
	{
		system.debug('Exception Occured while Sending the request to Xero-->'+ex.getMessage());
		res=null;
		return res;
	}
    return res;
}
   
   
   //for wehere condition
   
   public static HttpResponse syncXeroSFDCWithWehereCondition(String reqMethod,String operationName, String whereConditon){
  Http http = new Http();
     HttpRequest req = new Httprequest();
     HttpResponse res = new HttpResponse();
    String finalUrl;
    String str;
    String EncStr;
    String signature;
    Blob sig;
    String nonce;
    String host;
    //map to hold xero credentials parameters.
    map<String, String> parameters = new Map<String, String>();
    //to hold parameter map keys.
    List<String> keys = new List<String>();
    try
    {
	    //prearing nonce for Xero
	    nonce = String.valueOf(Crypto.getRandomLong());
	    // Generate timestamp for current time
	    timestamp = String.valueOf(DateTime.now().getTime()/1000);
	    //checking the custom setting for Xero Credentials.
	     if(Xero_Settings__c.getall().values()!=null){
	     for(Xero_Settings__c xeroSet : Xero_Settings__c.getall().values()){
	         signatureMethod =xeroSet.Oauth_Signature_Method__c;
	          oauthVersion = xeroSet.Oauth_Version__c;
	          oautheToken = xeroSet.Oatuh_Token__c;
	          consumerKey = xeroSet.Oauth_Consumer_Key__c;
	          xeroUrl = xeroSet.Xero_Url__c;
	         signatureMethod = xeroSet.Oauth_Signature_Method__c;
	         urlEncoding = xeroSet.Url_Encoding__c;
	     }//end of for.
	    }// end of if.
	    //puttting the parameters into the map
	    String whereencod=EncodingUtil.urlEncode(whereConditon, urlEncoding).replace('+', '%20'); // Replace the + charecter, if space is there in Name . 
	    parameters.put('oauth_token',oautheToken);
	    parameters.put('oauth_consumer_key',consumerKey);
	    parameters.put('oauth_signature_method',signatureMethod );
	    parameters.put('oauth_timestamp',timestamp);
	    parameters.put('oauth_nonce',nonce);
	    parameters.put('oauth_version',oauthVersion);
	    parameters.put('where',whereencod);
	    req.setMethod(reqMethod);
	    req.setEndpoint(xeroUrl+'/'+operationName);
	    host = req.getEndpoint();
	    keys.addAll(parameters.keySet());
	    keys.sort();
	    str = keys.get(0)+'='+parameters.get(keys.get(0));
	    for(Integer i=1;i<keys.size();i++) 
	    {
	    	str = str +'&'+keys.get(i)+'='+parameters.get(keys.get(i));
	    }
	    EncStr =  req.getMethod().toUpperCase()+ '&' + 
	    EncodingUtil.urlEncode(host, urlEncoding) +'&'+ EncodingUtil.urlEncode(str, urlEncoding);
	    system.debug('EncStr-->'+EncStr);
	    //preparing signature for xero.
	    sig = Crypto.sign(signatureMethod, Blob.valueOf(EncStr), EncodingUtil.base64decode(Keyy));
	    signature = EncodingUtil.base64encode(sig);
	    signature=EncodingUtil.urlEncode(signature, urlEncoding);
	    String EncoStr=EncodingUtil.urlEncode(whereencod, urlEncoding); //to be verified
	    system.debug('whereencod-->'+whereencod);
	 //   whereencod='Name%3D%3D%22Barbican%20Insurance%22';
	    system.debug('EncoStr-->'+EncoStr);
		req.setEndpoint(xeroUrl+'/'+operationName+'?where='+whereencod+'&oauth_token='+oautheToken+'&oauth_consumer_key='+consumerKey+'&oauth_signature_method='+signatureMethod+'&oauth_version='+oauthVersion+'&oauth_nonce='+nonce+'&oauth_timestamp='+timestamp+'&oauth_signature='+signature);
		if(operationName=='Invoices'){
			req.setHeader('If-Modified-Since',(System.today()-1)+'');
		}
		
	}
	 catch(Exception ex)
	 {
	 	system.debug('Exception Occured while Preparing signature in syncXeroSFDCWithWehereCondition method-->'+ex.getMessage());
	 }
try
{
	if(test.isRunningTest())
	{
		res.setStatusCode(200);
		 string strXml2 = '<Response>\n'+
		  '<Id>ec9adb4e-fbb2-4658-801f-e02048e7ad31</Id>\n'+
		  '<Status>OK</Status>\n'+
		  '<ProviderName>appsharkIT</ProviderName>\n'+
		  '<DateTimeUTC>2013-11-16T09:24:28.8824687Z</DateTimeUTC>\n'+
		  '<Contacts>\n'+
		   ' <Contact>\n'+
		    '<ContactID>95cfb424-c72f-4228-a214-555aceea27f5</ContactID>\n'+
		     '<ContactNumber>00002</ContactNumber>\n'+
		      '<ContactStatus>ACTIVE</ContactStatus>\n'+
		      '<Name>XERO TEST1</Name>\n'+
		      '<FirstName>Simon</FirstName>\n'+
		      '<LastName>Greenville</LastName>\n'+
		      '<EmailAddress>emailaddress@yourdomain.com</EmailAddress>\n'+
		      '<SkypeUserName>Skype Name/Number</SkypeUserName>\n'+
		      '<BankAccountDetails>Bank Account Details</BankAccountDetails>\n'+
		      '<TaxNumber>Tax ID Number</TaxNumber>\n'+
		      '<AccountsReceivableTaxType>OUTPUT</AccountsReceivableTaxType>\n'+
		      '<AccountsPayableTaxType>INPUT</AccountsPayableTaxType>\n'+
		      '<Addresses>\n'+
		       '<Address>\n'+
		       '<AddressType>STREET</AddressType>\n'+
		        ' <AddressLine1>Level 71</AddressLine1>\n'+
		          '<AddressLine2>30 Rockefeller plaza</AddressLine2>\n'+
		          '<City>New York</City>\n'+
		          '<Region>New York State</Region>\n'+
		          '<PostalCode>10112</PostalCode>\n'+
		          '<Country>USA</Country>\n'+
		          '<AttentionTo>Simon G.</AttentionTo>\n'+
		        '</Address>\n'+
		        '<Address>\n'+
		          '<AddressType>POBOX</AddressType>\n'+
		          '<AddressLine1>PO Box 10112</AddressLine1>\n'+
		          '<City>New York</City>\n'+
		          '<Region>New York State</Region>\n'+
		          '<PostalCode>10112</PostalCode>\n'+
		          '<Country>USA</Country>\n'+
		          '<AttentionTo>Simon G.</AttentionTo>\n'+
		       '</Address>\n'+
		      '</Addresses>\n'+
		      '<Phones>\n'+
		        '<Phone>\n'+
		          '<PhoneType>DDI</PhoneType>\n'+
		          '<PhoneNumber>1234567</PhoneNumber>\n'+
		          '<PhoneAreaCode>877</PhoneAreaCode>\n'+
		          '<PhoneCountryCode>0001</PhoneCountryCode>\n'+
		        '</Phone>\n'+
		        '<Phone>\n'+
		          '<PhoneType>DEFAULT</PhoneType>\n'+
		          '<PhoneNumber>5996999</PhoneNumber>\n'+
		          '<PhoneAreaCode>877</PhoneAreaCode>\n'+
		          '<PhoneCountryCode>0001</PhoneCountryCode>\n'+
		        '</Phone>\n'+
		        '<Phone>\n'+
		          '<PhoneType>FAX</PhoneType>\n'+
		          '<PhoneNumber>7654321</PhoneNumber>\n'+
		          '<PhoneAreaCode>877</PhoneAreaCode>\n'+
		          '<PhoneCountryCode>0001</PhoneCountryCode>\n'+
		        '</Phone>\n'+
		        '<Phone>\n'+
		          '<PhoneType>MOBILE</PhoneType>\n'+
		          '<PhoneNumber>5555555</PhoneNumber>\n'+
		          '<PhoneAreaCode>877</PhoneAreaCode>\n'+
		          '<PhoneCountryCode>0001</PhoneCountryCode>\n'+
		        '</Phone>\n'+
		      '</Phones>\n'+
		      '<UpdatedDateUTC>2013-11-16T07:09:10.423</UpdatedDateUTC>\n'+
		      '<IsSupplier>false</IsSupplier>\n'+
		      '<IsCustomer>true</IsCustomer>\n'+
		      '<BatchPayments>\n'+
		        '<BankAccountNumber>Bank Account Details</BankAccountNumber>\n'+
		      '</BatchPayments>\n'+
		    '</Contact>\n'+
		  '</Contacts>\n'+
		'</Response>\n';
	string strXml1='<Response>\n'+
	  '<Id>c8a8c8ee-098f-424b-b7d9-f49e4ba1bf71</Id>\n'+
	  '<Status>OK</Status>\n'+
	  '<ProviderName>Xero API Previewer</ProviderName>\n'+
	  '<DateTimeUTC>2013-11-17T18:30:37.3325631Z</DateTimeUTC>\n'+
	  '<Invoices>\n'+
	    '<Invoice>\n'+
	      '<Contact>\n'+
	        '<ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
	        '<Name>Ratna Tatikonda</Name>\n'+
	      '</Contact>\n'+
	      '<Date>2013-11-13T00:00:00</Date>\n'+
	      '<DueDate>2013-12-21T00:00:00</DueDate>\n'+
	      '<Status>AUTHORISED</Status>\n'+
	      '<LineAmountTypes>Inclusive</LineAmountTypes>\n'+
	      '<SubTotal>100.00</SubTotal>\n'+
	      '<TotalTax>0.00</TotalTax>\n'+
	      '<Total>100.00</Total>\n'+
	      '<UpdatedDateUTC>2013-11-12T14:58:55.42</UpdatedDateUTC>\n'+
	      '<CurrencyCode>GBP</CurrencyCode>\n'+
	      '<Type>ACCREC</Type>\n'+
	      '<InvoiceID>6ab73a27-75e3-4538-ba20-7dc6418ab3e3</InvoiceID>\n'+
	      '<InvoiceNumber>INV-API-001</InvoiceNumber>\n'+
	      '<AmountDue>100.00</AmountDue>\n'+
	      '<AmountPaid>0.00</AmountPaid>\n'+
	      '<HasAttachments>false</HasAttachments>\n'+
	    '</Invoice>\n'+
	'<Invoice>\n'+
	      '<Contact>\n'+
	       ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
	        '<Name>Ratna Tatikonda</Name>\n'+
	      '</Contact>\n'+
	     ' <Date>2013-11-18T00:00:00</Date>\n'+
	      '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
	      '<Status>PAID</Status>\n'+
	     ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
	     ' <SubTotal>60000.00</SubTotal>\n'+
	      '<TotalTax>12000.00</TotalTax>\n'+
	      '<Total>72000.00</Total>\n'+
	      '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
	     ' <CurrencyCode>GBP</CurrencyCode>\n'+
	      '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
	     ' <Type>ACCREC</Type>\n'+
	      '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
	      '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
	      '<Reference>Test oppor</Reference>\n'+
	      '<Payments>\n'+
	       ' <Payment>\n'+
	        '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
	         ' <Date>2013-11-18T00:00:00</Date>\n'+
	          '<Amount>72000.00</Amount>\n'+
	          '<CurrencyRate>1.000000</CurrencyRate>\n'+
	        '</Payment>\n'+
	      '</Payments>\n'+
	     ' <AmountDue>0.00</AmountDue>\n'+
	     ' <AmountPaid>72000.00</AmountPaid>\n'+
	     ' <HasAttachments>false</HasAttachments>\n'+
	    '</Invoice>\n'+
	    '<Invoice>\n'+
	      '<Contact>\n'+
	       ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
	        '<Name>Ratna Tatikonda</Name>\n'+
	      '</Contact>\n'+
	     ' <Date>2013-11-18T00:00:00</Date>\n'+
	      '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
	      '<Status>PAID</Status>\n'+
	     ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
	     ' <SubTotal>60000.00</SubTotal>\n'+
	      '<TotalTax>12000.00</TotalTax>\n'+
	      '<Total>72000.00</Total>\n'+
	      '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
	     ' <CurrencyCode>GBP</CurrencyCode>\n'+
	      '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
	     ' <Type>ACCREC</Type>\n'+
	      '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
	      '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
	      '<Reference>Test oppor</Reference>\n'+
	      '<Payments>\n'+
	       ' <Payment>\n'+
	        '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
	         ' <Date>2013-11-18T00:00:00</Date>\n'+
	          '<Amount>72000.00</Amount>\n'+
	          '<CurrencyRate>1.000000</CurrencyRate>\n'+
	        '</Payment>\n'+
	      '</Payments>\n'+
	     ' <AmountDue>0.00</AmountDue>\n'+
	     ' <AmountPaid>72000.00</AmountPaid>\n'+
	     ' <HasAttachments>false</HasAttachments>\n'+
	    '</Invoice>\n'+
	    '<Invoice>\n'+
	      '<Contact>\n'+
	       ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
	        '<Name>Ratna Tatikonda</Name>\n'+
	      '</Contact>\n'+
	     ' <Date>2013-11-18T00:00:00</Date>\n'+
	      '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
	      '<Status>PAID</Status>\n'+
	     ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
	     ' <SubTotal>60000.00</SubTotal>\n'+
	      '<TotalTax>12000.00</TotalTax>\n'+
	      '<Total>72000.00</Total>\n'+
	      '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
	     ' <CurrencyCode>GBP</CurrencyCode>\n'+
	      '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
	     ' <Type>ACCREC</Type>\n'+
	      '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
	      '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
	      '<Reference>Test oppor</Reference>\n'+
	      '<Payments>\n'+
	       ' <Payment>\n'+
	        '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
	         ' <Date>2013-11-18T00:00:00</Date>\n'+
	          '<Amount>72000.00</Amount>\n'+
	          '<CurrencyRate>1.000000</CurrencyRate>\n'+
	        '</Payment>\n'+
	      '</Payments>\n'+
	     ' <AmountDue>0.00</AmountDue>\n'+
	     ' <AmountPaid>72000.00</AmountPaid>\n'+
	     ' <HasAttachments>false</HasAttachments>\n'+
	    '</Invoice>\n'+
	    '<Invoice>\n'+
	      '<Contact>\n'+
	       ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
	        '<Name>Ratna Tatikonda</Name>\n'+
	      '</Contact>\n'+
	     ' <Date>2013-11-18T00:00:00</Date>\n'+
	      '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
	      '<Status>PAID</Status>\n'+
	     ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
	     ' <SubTotal>60000.00</SubTotal>\n'+
	      '<TotalTax>12000.00</TotalTax>\n'+
	      '<Total>72000.00</Total>\n'+
	      '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
	     ' <CurrencyCode>GBP</CurrencyCode>\n'+
	      '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
	     ' <Type>ACCREC</Type>\n'+
	      '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
	      '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
	      '<Reference>Test oppor</Reference>\n'+
	      '<Payments>\n'+
	       ' <Payment>\n'+
	        '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
	         ' <Date>2013-11-18T00:00:00</Date>\n'+
	          '<Amount>72000.00</Amount>\n'+
	          '<CurrencyRate>1.000000</CurrencyRate>\n'+
	        '</Payment>\n'+
	      '</Payments>\n'+
	     ' <AmountDue>0.00</AmountDue>\n'+
	     ' <AmountPaid>72000.00</AmountPaid>\n'+
	     ' <HasAttachments>false</HasAttachments>\n'+
	    '</Invoice>\n'+
	    '<Invoice>\n'+
	      '<Contact>\n'+
	       ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
	        '<Name>Ratna Tatikonda</Name>\n'+
	      '</Contact>\n'+
	     ' <Date>2013-11-18T00:00:00</Date>\n'+
	      '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
	      '<Status>PAID</Status>\n'+
	     ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
	     ' <SubTotal>60000.00</SubTotal>\n'+
	      '<TotalTax>12000.00</TotalTax>\n'+
	      '<Total>72000.00</Total>\n'+
	      '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
	     ' <CurrencyCode>GBP</CurrencyCode>\n'+
	      '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
	     ' <Type>ACCREC</Type>\n'+
	      '<InvoiceID>e6b2fc81-27bd-40e6-8cd3-f89435cfa7a6</InvoiceID>\n'+
	      '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
	      '<Reference>Test oppor</Reference>\n'+
	      '<Payments>\n'+
	       ' <Payment>\n'+
	        '  <PaymentID>d4b199a3-39aa-43fb-b459-288207fdb631</PaymentID>\n'+
	         ' <Date>2013-11-18T00:00:00</Date>\n'+
	          '<Amount>72000.00</Amount>\n'+
	          '<CurrencyRate>1.000000</CurrencyRate>\n'+
	        '</Payment>\n'+
	      '</Payments>\n'+
	     ' <AmountDue>0.00</AmountDue>\n'+
	     ' <AmountPaid>72000.00</AmountPaid>\n'+
	     ' <HasAttachments>false</HasAttachments>\n'+
	    '</Invoice>\n'+
	    '<Invoice>\n'+
	      '<Contact>\n'+
	       ' <ContactID>70d7c5a1-57f2-47c1-baca-cf1adc96bca5</ContactID>\n'+
	        '<Name>Ratna Tatikonda</Name>\n'+
	      '</Contact>\n'+
	     ' <Date>2013-11-18T00:00:00</Date>\n'+
	      '<DueDate>2013-12-02T00:00:00</DueDate>\n'+
	      '<Status>PAID</Status>\n'+
	     ' <LineAmountTypes>Exclusive</LineAmountTypes>\n'+
	     ' <SubTotal>60000.00</SubTotal>\n'+
	      '<TotalTax>12000.00</TotalTax>\n'+
	      '<Total>72000.00</Total>\n'+
	      '<UpdatedDateUTC>2013-11-18T06:10:53.377</UpdatedDateUTC>\n'+
	     ' <CurrencyCode>GBP</CurrencyCode>\n'+
	      '<FullyPaidOnDate>2013-11-18T00:00:00</FullyPaidOnDate>\n'+
	     ' <Type>ACCREC</Type>\n'+
	      '<InvoiceID>BalleSrinvias</InvoiceID>\n'+
	      '<InvoiceNumber>CT10074</InvoiceNumber>\n'+
	      '<Reference>Test oppor</Reference>\n'+
	      '<Payments>\n'+
	       ' <Payment>\n'+
	        '  <PaymentID>123456</PaymentID>\n'+
	         ' <Date>2013-11-18T00:00:00</Date>\n'+
	          '<Amount>72000.00</Amount>\n'+
	          '<CurrencyRate>1.000000</CurrencyRate>\n'+
	        '</Payment>\n'+
	      '</Payments>\n'+
	     ' <AmountDue>0.00</AmountDue>\n'+
	     ' <AmountPaid>72000.00</AmountPaid>\n'+
	     ' <HasAttachments>false</HasAttachments>\n'+
	    '</Invoice>\n'+
	  '</Invoices>\n'+
	'</Response>';
	if(operationName=='Invoices')
	{
		res.setBody(strXml1);
	}
	else
	{
		res.setBody(strXml2);
	}
	}
	else
	{
		if(req!=null)
		res=http.send(req);
	}
}
	catch(Exception ex)
	{
		system.debug('Exception Occured while Sending the request to Xero in syncXeroSFDCWithWehereCondition method-->'+ex.getMessage());
	}
    return res;
   }
    
}