/**
 * Author      : Uday / Ankush Rao
 * Date        : 18th,March -2013
 * Description : Email services are automated processes that use Apex classes
 *               to process the contents, headers, and attachments of inbound email.
 */
global class EmailServices_ContactAndOppCapture implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult(); 
     
    system.debug('=======email.subject======>>'+email.subject);
    system.debug('===envolap from address=====>>'+envelope.fromAddress);   
    system.debug('=====email toAddresses====>>'+email.toAddresses[0]);
    system.debug('=====email====>>'+email);
    system.debug('=====email fromAddresses====>>'+email.fromAddress);
    system.debug('=====envelope====>>'+envelope);
    system.debug('=====envelope to address====>>'+envelope.toAddress);

  if((email.subject).contains('Forwarding Confirmation'))
  {
            Task objTask = new Task();
            objTask.Subject = email.subject;
            List<User> userList = [Select u.name,u.Profile.name, u.Id From User u where u.profile.Name ='system administrator' and u.IsActive =true and u.name='Sean Smith' limit 1];
            if(userList != null && userList.size() > 0)
            objTask.OwnerId = userList[0].id;
            objTask.Description = email.plainTextBody;
            objTask.ActivityDate = system.today();
            objTask.Type = 'email'; 
            objTask.Status ='Received';           
            insert objTask;
            system.debug('====objTask id=====>>'+objTask.id);
  }else
  {
   try{ 
    List<Opportunity> listOpps;  
      
    List<Contact> listCons = [select id ,AccountId,Email from Contact where Email =:email.fromAddress limit 1];
    
     if(listCons != null && listCons .size() > 0)
        listOpps = [select id from Opportunity where AccountId=:listCons[0].AccountId and stageName !='Closed Lost' and stageName !='Closed Won' and stageName !='Cancelled'];
    
     system.debug('===listCons====>>'+listCons);
     system.debug('===listOpps====>>'+listOpps);
     
    
    
    List<Task> listTasks = new List<Task>();   
    
    if((listCons!= null && listCons.size() > 0))
    {
            system.debug('****Entered in Con*****');
            Task objTask = new Task();
            objTask.Subject = email.subject;
            
            if(listOpps != null && listOpps.size() > 0)
               objTask.WhatId = listOpps[0].id;
            
            objTask.Status ='Received';           
            objTask.WhoId = listCons[0].id;
            
            objTask.Description = email.plainTextBody;     
            objTask.ActivityDate = system.today();
            objTask.Type = 'email';           
            
            listTasks.add(objTask);
    }    
    try{
    if(listTasks != null &&  listTasks.size() > 0){
        insert listTasks;
    }        
    }Catch(Exception exc){
        system.debug('**exception i insert event'+exc);
    }
   
// Inserting email Text Attachments as a Attachments to Task Object
if(email.textAttachments != null && email.textAttachments.size() > 0)
        {
         List<Attachment> listAttches1 = new List<Attachment>();         
         
         System.debug('====> it has text attachment');
         for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments)
          {
                if(listTasks != null && listTasks.size() > 0)
                {
                        Attachment attachment = new Attachment();
                        attachment.Name = tAttachment.fileName;
                        attachment.Body = Blob.valueOf(tAttachment.body);
                        // attach to the newly created event record
                        attachment.ParentId = listTasks[0].Id;
                        listAttches1.add(attachment);
                }
           }
           
           try{
                 if(listAttches1 != null && listAttches1.size() > 0)
                   insert listAttches1;
           }Catch(Exception excp){
                   system.debug('***Exception in Attach insert event text'+excp);
           }           
        }
        
        // Inserting email Binary Attachments as a Attachments to task Object
        if (email.binaryAttachments != null && email.binaryAttachments.size() > 0 ) 
        {
         List<Attachment> listAttchesBin1 = new List<Attachment>();        
         
        System.debug('====> it has binary attachment');
        
          for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) 
          {          
              if(listTasks != null && listTasks.size() > 0)
              {
                        Attachment attachment = new Attachment();
                        // attach to the newly created event record
                        attachment.ParentId = listTasks[0].Id;
                        attachment.Name = email.binaryAttachments[i].filename;
                        attachment.Body = email.binaryAttachments[i].body;
                        listAttchesBin1.add(attachment);
               }
          }
          
          try{
            if(listAttchesBin1 != null && listAttchesBin1.size() > 0)
               insert listAttchesBin1;
          }Catch(Exception excp){
               system.debug('***Exception in Attach insert event binary'+excp);
          }
          
        }
        
   }Catch(Exception ex){
       system.debug('*****Exception in a body *******'+ex);
   }    
  }      
  return result;
    }
}