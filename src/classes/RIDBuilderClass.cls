global with sharing class RIDBuilderClass {
    
  // init vars
  public static String record_id { get; set; }
  public static String record_name { get; set; }
  public static String record_type { get; set; }
  public static String project_id { get; set; }
  public static String account_id { get; set; }
    
  // set opp name, opp id, proj id if any, and account id
  public RIDBuilderClass() {
    record_id = '' + ApexPages.currentPage().getParameters().get('id');
    Opportunity opp = [
      SELECT Name, Type__c, AccountId 
      FROM Opportunity 
      WHERE Id = :record_id 
      LIMIT 1
    ];
    List<Project_Line_New__c> project_line = [
      SELECT Id
      FROM Project_Line_New__c
      WHERE Opportunity__c = :record_id
    ];
    project_id = project_line.isEmpty() == true ? 'NONE' : project_line[0].Id; 
    record_type = opp.Type__c;
    record_name = opp.Name;
    account_id = opp.AccountId;
  }

  // returns list of rid generator records
  @RemoteAction
  global static List<RID_Generator__c> getTemplates() {
    List<RID_Generator__c> items = [
      SELECT Id, Area__c, Requirement__c, Solution__c, 
        Sort_Number_For_List__c, Estimated_Effort_Days__c,
        Functional_Area__c, Risk__c
      FROM RID_Generator__c
      WHERE Do_Not_Show__c = false
    ];
    return items;
  }
    
  // returns list of rid extra templates
  @RemoteAction
  global static List<RID_Extras__c> getExtras() {
    List<RID_Extras__c> items = [
      SELECT Id, Name, Area__c, Description__c, Type__c
      FROM RID_Extras__c
      WHERE Template__c = true
    ];
    return items;
  }
    
  // returns list of rid generator records
  @RemoteAction
  global static List<RID_Extras__c> getExistingExtras(String id) {
    List<RID_Extras__c> items = [
      SELECT Id, Name, Area__c, Description__c, Type__c
      FROM RID_Extras__c
      WHERE Project__c = :id
    ];
    return items;
  }
    
  // returns list of existing rid details
  @RemoteAction
  global static List<X2017_RIDS_DETAILS__c> getItems(String id) {
    List<X2017_RIDS_DETAILS__c> items = [
      SELECT Id, Area__c, Functional_Area__c, Requirement__c, Solution__c, 
        Risk__c, Estimated_Effort_Days__c, Sort_Order__c, RID_Generator__c, 
        Change_Reason__c
      FROM X2017_RIDS_DETAILS__c
      WHERE Project_Line_New__c = :id
    ];
    return items;
  }
    
  // upserts a list of rid details (creates project line first if there isn't one)
  @RemoteAction
  global static String saveItems(List<X2017_RIDS_DETAILS__c> rids, String opp_id, String proj_id, String acc_id, List<RID_Extras__c> extras) {
    if (proj_id == 'NONE') {
      Project_Line_New__c project = new Project_Line_New__c(
        Account__c = acc_id,
        Opportunity__c = opp_id
      );
      upsert project;
      proj_id = [SELECT Id FROM Project_Line_New__c WHERE Opportunity__c = :opp_id LIMIT 1].Id;
    }
    List<RID_Extras__c> existingExtras = [
      SELECT Id 
      FROM RID_Extras__c 
      WHERE Project__c =: proj_id
      AND Template__c = false
    ];
    delete existingExtras;
    for (integer i = 0; i < extras.size(); i++) {
      extras[i].Project__c = proj_id;
    }
    insert extras;
    List<X2017_RIDS_DETAILS__c> items = new List<X2017_RIDS_DETAILS__c>();
    for (integer i = 0; i < rids.size(); i++) {
      X2017_RIDS_DETAILS__c item = new X2017_RIDS_DETAILS__c(
        Id = rids[i].Id,
        Area__c = rids[i].Area__c.unescapeHtml4(),
        Project_Line_New__c = proj_id,
        Requirement__c = rids[i].Requirement__c.unescapeHtml4(),
        Solution__c = rids[i].Solution__c.unescapeHtml4(),
        Opportunity__c = opp_id,
        Estimated_Effort_Days__c = rids[i].Estimated_Effort_Days__c,
        Sort_Order__c = rids[i].Sort_Order__c,
        Functional_Area__c = rids[i].Functional_Area__c.unescapeHtml4(),
        RID_Generator__c = rids[i].RID_Generator__c,
        Change_Reason__c = rids[i].Change_Reason__c,
        Risk__c = rids[i].Risk__c
      );
      items.add(item);
    }
    upsert items;
    return proj_id;
  }
    
  // deletes rid details based on a list of rid detail ids
  @RemoteAction
  global static void deleteItems(List<String> ids) {
    List<X2017_RIDS_DETAILS__c> items = new List<X2017_RIDS_DETAILS__c>();
    for (integer i = 0; i < ids.size(); i++) {
      X2017_RIDS_DETAILS__c item = new X2017_RIDS_DETAILS__c(
        Id = ids[i]
      );
      items.add(item);
    }
    delete items;
  }

}