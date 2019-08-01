public with sharing class MyDocumentsController 
{
    public List<Contractor_Document__c> lstContractorDocuments {get; set;}
    
    public MyDocumentsController()
    {
        lstContractorDocuments = new List<Contractor_Document__c>();
        
        User usr = [Select Id, ContactId, ProfileId, Profile.Name from User where Id=:Userinfo.getUserId() limit 1];
        Id contactId = usr.ContactId;
        Id accountId = [Select Id, AccountId from Contact where Id=:contactId limit 1].AccountId;
        
        lstContractorDocuments = [Select     Id, Name, Account__c, Document_Link__c, Document_Description__c, Share_With__c, Agreement__c, Document_Link_Formula__c 
                                  From       Contractor_Document__c 
                                  Where      ((Account__c =:accountId and Share_With__c = 'Account') or Share_With__c = 'Public')];
    }
    
    public static testmethod void testMyDocumentsController()
    {
        User user = [Select Id, ContactId from User where IsActive=true and ContactId != null limit 1];
        System.assert(user != null);
        
        Contact contact = [Select Id, AccountId from Contact where Id =:user.ContactId limit 1];
        
        Contractor_Document__c conDocument = new Contractor_Document__c();
        conDocument.Account__c = contact.AccountId;
        insert conDocument;
        
        System.runAs(user)
        {
            Test.setCurrentPage(Page.MyDocuments);
            MyDocumentsController ctrl = new MyDocumentsController();
        }
    }
}