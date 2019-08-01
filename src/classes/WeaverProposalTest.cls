@IsTest
private class WeaverProposalTest {
    
  private static Opportunity createOpp(String templateId) {
    Opportunity opp = new Opportunity();
    opp.Name = 'Hello';
    opp.StageName = 'Opportunity Identified';
    opp.CloseDate = Date.today();
    opp.Weaver_Template_New__c = templateId;
    opp.Weaver_Version__c = null;
    opp.Is_converted__c = true;
    insert opp;
    return opp;
  }
    
  private static aptk_weaver__Weaver_Template__c createTemplate() {
    aptk_weaver__Weaver_Template__c template = new aptk_weaver__Weaver_Template__c();
    template.aptk_weaver__Object__c = 'Opportunity';
    insert template;
    return template;
  }
    
  private static aptk_weaver__Weaver_Component__c createComponent() {
    aptk_weaver__Weaver_Component__c component = new aptk_weaver__Weaver_Component__c();
    component.aptk_weaver__Object__c = 'Opportunity';
    insert component;
    return component;
  }
    
  @IsTest
  private static void runTest() {
    aptk_weaver__Weaver_Template__c template = createTemplate();
    aptk_weaver__Weaver_Component__c component = createComponent();
    Opportunity failureOpp = createOpp(null);
    String failureResult = WeaverProposal.generateProposal(failureOpp.Id, 'PDF', 'elliott@appitek.com');
    System.assertEquals('Please set a Weaver template for this opportunity.', failureResult);
    Opportunity successOpp = createOpp(template.Id);
    String successResult = WeaverProposal.generateProposal(successOpp.Id, 'PDF', 'elliott@appitek.com');
    System.assertEquals('Success', successResult);
    WeaverProposal.notifyUser(successOpp.Name, successOpp.Id, 1, 'elliott@appitek.com');
  }
  

}