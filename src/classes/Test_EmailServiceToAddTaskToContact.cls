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
@isTest
private class Test_EmailServiceToAddTaskToContact {

    static testMethod void myUnitTest() {
   Account acc= new Account();
    acc.Name ='acc name';
    acc.Type ='test';
    acc.Rating = 'test';
    acc.Phone ='84465446';
    acc.Website ='www.ceterna.com';
    acc.Industry ='test';
   insert acc;
   
   Contact con = new Contact();
     con.LastName = 'test';
     con.Phone = '94565665';
     con.Email ='hi@gmail.com';
     con.AccountId = acc.id;
   insert con;
      
      
    List<string> strlst = new List<string>();
    strlst.add('hi@gmail.com');
    
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
   email1.fromAddress ='hi@gmail.com';  
   email1.fromname ='ankush samudrala';
   email1.subject = 'test';
   env1.fromAddress = 'hi@gmail.com';
   env1.toaddress= 'hi@gmail.com';
   
   email11.toAddresses = strlst;
   email11.fromAddress ='hi@gmail.com';
   email11.fromname ='ankush samudrala';
   email11.subject = 'Test Forwarding Confirmation';
   env11.fromAddress = 'hi@gmail.com';
   env11.toaddress= 'hi@gmail.com';
   
   email111.toAddresses = strlst;
   email111.fromAddress ='hi@gmail.com';
   email111.fromname ='ankush1 samudrala1';
   email111.subject = 'test subject';
   env111.fromAddress = 'hi@gmail.com';
   env111.toaddress= 'hi@gmail.com';
   
   
   // set the body of the attachment
   inAtt1.body = blob.valueOf('test 47887');
   inAtt1.fileName = 'my attachment name';
   //inAtt.mimeTypeSubType = 'plain/txt';
   
   // set the body of the attachment
   inTextAtt1.body = 'test 4545';
   inTextAtt1.fileName = 'my attachment binary';
   inTextAtt1.mimeTypeSubType = 'plain/txt';
   
  
   email1.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt1 }; 
   email1.TextAttachments = new Messaging.inboundEmail.TextAttachment[] {inTextAtt1}; 

   // call the class and test it with the data in the testMethod
   EmailServiceToAddTaskToContact emailServiceObj1 = new EmailServiceToAddTaskToContact();
   emailServiceObj1.handleInboundEmail(email1, env1 ); 
   
    EmailServiceToAddTaskToContact emailServiceObj11 = new EmailServiceToAddTaskToContact();
   emailServiceObj11.handleInboundEmail(email11, env11 ); 
   
    EmailServiceToAddTaskToContact emailServiceObj111 = new EmailServiceToAddTaskToContact();
    emailServiceObj11.handleInboundEmail(email111, env111 ); 
    }
}