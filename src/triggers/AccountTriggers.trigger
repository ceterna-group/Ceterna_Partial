trigger AccountTriggers on Account (after insert, after update) {

    if(Trigger.isAfter && Trigger.isInsert) {

        List<String> accountIds = new List<String>();

        for (Account account : Trigger.new) {
            if(account.Support_Name__c == null || account.Support_Name__c == '') {
                accountIds.add(account.id);
            }
        }

        if(!accountIds.isEmpty()) {
            CreateFreshdeskCompanyContact.createFreshdeskCompany(accountIds);
        }
    }


    if(Trigger.isAfter && Trigger.isUpdate) {

        List<String> accountIds = new List<String>();

        for (Account account : Trigger.new) {
            if((account.Freshdesk_Support_Client__c == true && Trigger.oldMap.get(account.Id).Freshdesk_Support_Client__c == false)
                    && (account.Support_Name__c == null || account.Support_Name__c == '')) {
                accountIds.add(account.id);
            }            
        }

        if(!accountIds.isEmpty()) {
            CreateFreshdeskCompanyContact.createFreshdeskCompany(accountIds);
        }
    }
}