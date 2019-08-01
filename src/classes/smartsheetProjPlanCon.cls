/*
Created By : Ankush Rao.
Date       : 26-dec-2013.
Purpose    :It brings the logged in users Smartsheet key from his Contact's Account.

*/

public with sharing class smartsheetProjPlanCon {

public string sheetKey{set;get;}

//Constructor.
	public smartsheetProjPlanCon()
	{
		
		system.debug('====UserInfo.getUserId()====>>'+UserInfo.getUserId());
			 List<user> userslist = [select id,contactId from User where id =:UserInfo.getUserId()];
		
		system.debug('====userslist====>>'+userslist);
		     List<Contact> conObj;
			 if(userslist != null && userslist.size() > 0)
				  conObj =[select id,AccountId from Contact where id=:userslist[0].ContactId];
		     
		system.debug('====conObj====>>'+conObj);    
		 
		     List<Account> accObj;
		     if(conObj != null && conObj.size() > 0)
		           accObj =[select id ,Community_Smartsheet_Key__c from Account where id=:conObj[0].AccountId];
		           
		system.debug('====accObj====>>'+accObj);
		     
		     if(accObj != null && accObj.size() > 0)
		     		sheetKey = accObj[0].Community_Smartsheet_Key__c;
		     	
		system.debug('====sheetKey====>>'+sheetKey);
	}
}