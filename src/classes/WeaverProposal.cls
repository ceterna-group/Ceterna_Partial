global without sharing class WeaverProposal {
    
  @AuraEnabled
  global static String generateProposal(String recordId, String fileType, String userEmail) {
    Opportunity opp = new Opportunity();
    opp = [
      SELECT Id, Name, Weaver_Version__c, Weaver_Template_New__c, 
        Owner_Name__c
      FROM Opportunity
      WHERE Id =: recordId
      LIMIT 1
    ];
    if (opp.Weaver_Template_New__c == null) {
      return 'Please set a Weaver template for this opportunity.';
    }
    if (opp.Weaver_Version__c == null) opp.Weaver_Version__c = 1;
    String fileName = opp.Name + ' - ' + opp.Owner_Name__c + ' - v' + opp.Weaver_Version__c; 
    String render = aptk_weaver.WeaverCore.saveToRecord(opp.Weaver_Template_New__c, recordId, fileType, fileName);
    System.debug('Render: ' + render);
    if (render == 'Success') {
      opp.Weaver_Version__c = (opp.Weaver_Version__c + 1);
      notifyUser(opp.Name, opp.Id, opp.Weaver_Version__c, userEmail);
      try {
        update opp;
        return 'Success';
      } catch(DMLException e) {
        return 'Error: ' + e;        
      }
    }
    return render;
  }
    
  @Future
  public static void notifyUser(String oppName, String oppId, Decimal versionNo, String userEmail) {
    User u = [
      SELECT Id, Name 
      FROM User
      WHERE Id = :UserInfo.getUserId()
      LIMIT 1
    ];
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String subject = 'PROPOSAL CREATED: ' + u.Name + ' has generated a new proposal for ' + oppName;
    String body = 'New proposal generated. <br><br>';
    List<String> toAddress = new List<String>();
    toAddress.add(userEmail);
    body += 'User: ' + u.Name + '<br>';
    body += 'Opportunity: <a href="https://ceterna.lightning.force.com/' + oppId + '" target="_blank">' + oppName + '</a><br>';
    body += 'Version: ' + versionNo;
    mail.setSubject(subject);
    mail.setHtmlBody(body);
    mail.setToAddresses(toAddress);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  }

}