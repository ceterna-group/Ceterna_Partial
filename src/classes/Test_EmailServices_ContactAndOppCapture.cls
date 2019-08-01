/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seeAllData = true)
private class Test_EmailServices_ContactAndOppCapture {    

    static testMethod void myUnitTest() {
   
   Account acc= new Account();
    acc.Name ='acc name';
    acc.Type ='test';
    acc.Rating = 'test';
    //acc.SFDC_Account_Manager__c = con.id;
    acc.Phone ='84465446';
    acc.Website ='www.ceterna.com';
    acc.Evolution_3_Day_Rate_ex_VAT__c = 2000;
    acc.Industry ='test';
    acc.Contact_s_for_documentation__c ='test';
    acc.URL_For_doc_Images__c ='test';
   insert acc;
   
   Contact con = new Contact();
     con.LastName = 'test';
     con.Phone = '94565665';
     con.Email ='test@test.com';
     con.AccountId = acc.id;
      insert con;
      
    
   
   Opportunity opp = new Opportunity();
	   opp.Name ='opp name';
	   opp.StageName ='visit';
	   opp.CloseDate =system.today();
	   opp.AccountId =acc.id;
	   opp.Opportunity_Description_for_opp_name__c ='test';
	   opp.Rating__c ='test';
	   opp.Competitive__c ='test';
	   opp.New_Existing__c ='new';
	   opp.Type ='test';
	   opp.LeadSource ='test';
	   opp.NextStep ='test';
   insert opp;
   
    List<string> strlst = new List<string>();
    strlst.add('test@gmail.com');
   // Create a new email, envelope object and Attachment
   Messaging.InboundEmail email1 = new Messaging.InboundEmail();
   Messaging.InboundEnvelope env1 = new Messaging.InboundEnvelope();
   
   Messaging.InboundEmail email11 = new Messaging.InboundEmail();
   Messaging.InboundEnvelope env11 = new Messaging.InboundEnvelope();
   
   Messaging.InboundEmail email111 = new Messaging.InboundEmail();
   Messaging.InboundEnvelope env111 = new Messaging.InboundEnvelope();
   
   Messaging.InboundEmail.BinaryAttachment inAtt1 = new Messaging.InboundEmail.BinaryAttachment();
   Messaging.InboundEmail.TextAttachment inTextAtt1 = new Messaging.InboundEmail.TextAttachment();
   
   email1.toAddresses = strlst; 
   email1.fromAddress ='test@test.com';  
   email1.fromname ='ankush samudrala';
   email1.subject = 'test';
   env1.fromAddress = 'test@test.com';
   env1.toaddress= 'uniquestemailservicesforleadandoppcapture@x-1xt0cudrnfpnhzxsd00e1k8nxlv9nwnhos900nscu69ki559o0.g-3kvyieas.cs17.apex.sandbox.salesforce.com';
   
   email11.toAddresses = strlst;
   email11.fromAddress ='test@test.com';
   email11.fromname ='ankush samudrala';
   email11.subject = 'Test Forwarding Confirmation';
   env11.fromAddress = 'test@test.com';
   env11.toaddress= 'contactandopportunitycapture@6-1gz9eovav67b3rt4jdaci6dz8kiylprt38bhzurrfjkijwb5y5.l-28swymam.cs8.apex.sandbox.salesforce.com';
   
   email111.toAddresses = strlst;
   email111.fromAddress ='test@test.com';
   email111.fromname ='ankush1 samudrala1';
   email111.subject = 'test subject';
   env111.fromAddress = 'test@test.com';
   env111.toaddress= 'contactandopportunitycapture@6-1gz9eovav67b3rt4jdaci6dz8kiylprt38bhzurrfjkijwb5y5.l-28swymam.cs8.apex.sandbox.salesforce.com';
   
   
   // set the body of the attachment
   inAtt1.body = blob.valueOf('test');
   inAtt1.fileName = 'my attachment name';
   //inAtt.mimeTypeSubType = 'plain/txt';
   
   // set the body of the attachment
   inTextAtt1.body = 'test';
   inTextAtt1.fileName = 'my attachment binary';
   inTextAtt1.mimeTypeSubType = 'plain/txt';
   
  
   email1.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt1 }; 
   email1.TextAttachments = new Messaging.inboundEmail.TextAttachment[] {inTextAtt1}; 

   // call the class and test it with the data in the testMethod
   EmailServices_ContactAndOppCapture emailServiceObj1 = new EmailServices_ContactAndOppCapture();
   emailServiceObj1.handleInboundEmail(email1, env1 ); 
   
    EmailServices_ContactAndOppCapture emailServiceObj11 = new EmailServices_ContactAndOppCapture();
   emailServiceObj11.handleInboundEmail(email11, env11 ); 
   
    EmailServices_ContactAndOppCapture emailServiceObj111 = new EmailServices_ContactAndOppCapture();
    emailServiceObj11.handleInboundEmail(email111, env111 );     
   
    }
}