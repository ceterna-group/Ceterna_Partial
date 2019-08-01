public with sharing class CaseTriggerMethods 
{/*
	public static void processConfigurationRequest(List<Case> lstCases)
	{
		List<Project_Line__c> lstProjectLines = new List<Project_Line__c>();

		Set<ID> caseIdsToUpdate = new Set<ID>();
				
		for(Case c : lstCases)
		{
			//if(c.Req_Type__c != null && c.Req_Type__c != '' && c.Project_Line_Created__c == false && c.Create_Project_Line__c == 'True')
			if(c.Create_Project_Line__c == 'True')
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = c.Subject;
				pl.Account__c = c.AccountId;
				pl.Related_Case__c = c.Id;
				pl.Start_Date__c = c.Start_Date__c;
				pl.Email_Source__c = c.SuppliedEmail;
				//pl.Request_Type__c = c.Req_Type__c;
				pl.Request_Type__c = c.Type;
				
				//c.Project_Line_Created__c = true;
				
				lstProjectLines.add(pl);
				
				caseIdsToUpdate.add(c.Id);
			}
		}
		
		if(lstProjectLines.size() > 0)
		{
			insert lstProjectLines;
			
			if(caseIdsToUpdate.size() > 0)
			{
				CaseTriggerMethods.updateCaseProjectLineCreatedFlag(caseIdsToUpdate);
			}
		}
	}
	
	@future public static void updateCaseProjectLineCreatedFlag(Set<ID> caseIds)
	{
		if(caseIds != null && caseIds.size() > 0)
		{
			List<Case> lstCases = [Select Id, Project_Line_Created__c from Case where Id in :caseIds];
			
			if(lstCases != null && lstCases.size() > 0)
			{
				for(Case c : lstCases)
				{
					c.Project_Line_Created__c = true;
				}
				
				update lstCases;
			}
		}
	}*/
}