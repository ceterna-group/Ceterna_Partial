trigger AfterUpdateContactTrigger on Contact (after update) 
{    
	if(trigger.isAfter && trigger.isUpdate)
	{
		Map<Id, Contact> oldMap = Trigger.oldMap;
		List<String> contactIds = new List<String>();
		for (Contact con : Trigger.new) 
		{
			Contact oldContact = oldMap.get(con.Id);
			if((con.Freshdesk_Support_Client__c == true && oldContact.Freshdesk_Support_Client__c == false) && (con.Freshdesk_Id__c == null || con.Freshdesk_Id__c == ''))
			{
            	contactIds.add(con.id);
			}            
        }
        if(!contactIds.isEmpty())
        {
        	CreateFreshdeskCompanyContact.createFreshdeskContact(contactIds);
        }
	}	
}