public with sharing class AgreementTriggerMethods 
{
    public static void createContractorDocuments(Map<ID,echosign_dev1__SIGN_Agreement__c> mapOldAgreements, Map<ID,echosign_dev1__SIGN_Agreement__c> mapNewAgreements)
    {
        if(mapNewAgreements != null && !mapNewAgreements.isEmpty())
        {
            Set<ID> accIds = new Set<ID>();
            
            for(echosign_dev1__SIGN_Agreement__c agreement : mapNewAgreements.values())
            {
                if(agreement.echosign_dev1__Account__c != null
                && mapOldAgreements.get(agreement.Id).echosign_dev1__Status__c != agreement.echosign_dev1__Status__c
                && agreement.echosign_dev1__Status__c == 'Signed')
                {
                    accIds.add(agreement.echosign_dev1__Account__c);
                }
            }
            
            if(accIds.size() > 0)
            {
            /*   Map<ID,ID> mapPortalUsers = new Map<ID,ID>();
                    
                Map<ID,User> mapUsers = new Map<ID,User>([Select Id, Contact.AccountId from User where Contact.AccountId in :accIds and IsActive=true]);
                
                if(mapUsers != null && !mapUsers.isEmpty())
                {
                    for(User user : mapUsers.values())
                    {
                        mapPortalUsers.put(user.Contact.AccountId, user.Id);
                    }
                }
                */
                List<Contractor_Document__c> lstContractorDocument = new List<Contractor_Document__c>();
                
                for(echosign_dev1__SIGN_Agreement__c agreement : mapNewAgreements.values())
                {
                    if(agreement.echosign_dev1__Account__c != null
                    && mapOldAgreements.get(agreement.Id).echosign_dev1__Status__c != agreement.echosign_dev1__Status__c
                    && agreement.echosign_dev1__Status__c == 'Signed')
                    {
                       // if(mapPortalUsers.containsKey(agreement.echosign_dev1__Account__c))
                    //    {
                            Contractor_Document__c contractorDocument = new Contractor_Document__c();
                            contractorDocument.Account__c = agreement.echosign_dev1__Account__c;
                            contractorDocument.Document_Link__c = agreement.echosign_dev1__SignedPDF__c;
                            //contractorDocument.OwnerId = mapPortalUsers.get(agreement.echosign_dev1__Account__c);
                            
                            contractorDocument.Document_Description__c = 'Outsauce Contractor Agreements';
                            contractorDocument.Agreement__c = agreement.Id;

                            lstContractorDocument.add(contractorDocument);
                      //  }
                    }
                }
                
                if(lstContractorDocument.size() > 0)
                {
                    insert lstContractorDocument;
                }
            }
        }
    }
    
    /*
    public static void changeOwner(List<echosign_dev1__SIGN_Agreement__c> lstAgreements)
    {
        if(lstAgreements != null && lstAgreements.size() > 0)
        {
            Set<ID> accIds = new Set<ID>();
            
            for(echosign_dev1__SIGN_Agreement__c agreement : lstAgreements)
            {
                if(agreement.echosign_dev1__Account__c != null)
                {
                    accIds.add(agreement.echosign_dev1__Account__c);
                }
            }
            
            if(accIds.size() > 0)
            {
                Map<ID,ID> mapPortalUsers = new Map<ID,ID>();
                    
                Map<ID,User> mapUsers = new Map<ID,User>([Select Id, Contact.AccountId from User where Contact.AccountId in :accIds and IsActive=true]);
                
                if(mapUsers != null && !mapUsers.isEmpty())
                {
                    for(User user : mapUsers.values())
                    {
                        mapPortalUsers.put(user.Contact.AccountId, user.Id);
                    }
                }
            
                for(echosign_dev1__SIGN_Agreement__c agreement : lstAgreements)
                {
                    if(agreement.echosign_dev1__Account__c != null)
                    {
                        if(mapPortalUsers.containsKey(agreement.echosign_dev1__Account__c))
                        {
                            agreement.OwnerId = mapPortalUsers.get(agreement.echosign_dev1__Account__c);
                            System.debug('## agreement.OwnerId : ' + agreement.OwnerId);
                        }
                    }
                }
            }
        }
    }
    */
    
    public testmethod static void testChangeOwner()
    {
        User usr = [Select Id, Contact.AccountId from User where ContactId != null and IsActive=true limit 1];
        
        System.runAs(usr)
        {
            echosign_dev1__SIGN_Agreement__c agreement = new echosign_dev1__SIGN_Agreement__c();
            agreement.echosign_dev1__Account__c = usr.Contact.AccountId;
            insert agreement;
            
            agreement = [Select Id, OwnerId from echosign_dev1__SIGN_Agreement__c where Id =:agreement.Id limit 1];
            System.debug('## agreement : ' + agreement);
            //System.assert(agreement.OwnerId == usr.Id);
            
            agreement.echosign_dev1__Status__c = 'Signed';
            update agreement;
        }
    }
}