trigger AccountTriggers on Account (after insert, after update) 
{
    //AccountTriggerMethods.createProjectLines(trigger.oldMap, trigger.newMap);
    
    if(trigger.isAfter && trigger.isUpdate)
    {
        Map<Id, Account> oldMap = Trigger.oldMap;
        List<String> accountIds = new List<String>();
        for (Account account : Trigger.new) 
        {
            Account oldAccount = oldMap.get(account.Id);
            if((account.Freshdesk_Support_Client__c == true && oldAccount.Freshdesk_Support_Client__c == false) && (account.Support_Name__c == null || account.Support_Name__c == ''))
            {
                accountIds.add(account.id);
            }            
        }
        if(!accountIds.isEmpty())
        {
            CreateFreshdeskCompanyContact.createFreshdeskCompany(accountIds);
        }
    }
}