/*
   Author      : Uday Shankar/Ankush
   Date        : 21 - JAN -2015
   Name        : AcceptCaseController
   Description : This class will populate the Clinet Acknowledgement Message on Case from the caselist view vf page.
*/


public with sharing class AcceptCaseController {

	public List<case> lstCase {get;set;}
	public case objCase {get;set;}
	public string sClientAckMessage {get;set;}
    public string csid; 
    public string sSubject {get;set;}
    public string sDesc {get;set;}
	
	public AcceptCaseController() {
		system.debug('id===>'+ApexPages.CurrentPage().GetParameters().get('id'));
         if(ApexPages.CurrentPage().GetParameters().get('id')!=null && ApexPages.CurrentPage().GetParameters().get('id')!=''){
            csid=ApexPages.CurrentPage().GetParameters().get('id');
            system.debug('csid ====>'+csid);
          objCase = [select id,Description,Subject,Client_Acknowledgement_Message__c from Case where id=:csid];
          if(objCase!= null){
          	sSubject = objCase.Subject;
          	sDesc   = objCase.Description; 
          	sClientAckMessage = objCase.Client_Acknowledgement_Message__c;
          }
        }
    }
    
	public void Save(){
		if(sClientAckMessage != null){
			objCase.Client_Acknowledgement_Message__c = sClientAckMessage;
			 objCase.OwnerId = UserInfo.getUserId();
			 objCase.Initial_Respone_Date_Time__c =system.now();
			 system.debug('objCase ===>'+objCase);
			 if(objCase!= null)
			 	update objCase;
			system.debug('sClientAckMessage ===>'+sClientAckMessage);
		}
	}
}