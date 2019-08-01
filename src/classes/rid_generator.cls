/*
 *  RID Generator Class
 *  - controls the RID Generator VF page
 * 
 *  @author 
 *  - Elliott Thurman-Newell <elliott@ceterna.com>
 *  @created 03/04/2017
 *  @version 1.1
 * 
 *  @changelog
 *  - 1.1 <elliott@ceterna.com>
 * 	  + Added new fields for generator and detail SOQLs (Salesforce_Cloud__c && Package__c)
 * 
 *  - 1.0 <elliott@ceterna.com>
 * 	  + Initial Commit
 * 
 */ 
global with sharing class rid_generator {
    
  // init vars
  public static String record_id { get; set; }
  public static String record_name { get; set; }
  public static String project_id { get; set; }
  public static String account_id { get; set; }
    
  // set opp name, opp id, proj id if any, and account id
  public rid_generator() {
    record_id = '' + ApexPages.currentPage().getParameters().get('id');
    record_name = [SELECT Name FROM Opportunity WHERE Id = :record_id].Name;
    List<Project_Line_New__c> project_line = [
      SELECT Id
      FROM Project_Line_New__c
      WHERE Opportunity__c = :record_id
    ];
    project_id = project_line.isEmpty() == true ? null : project_line[0].Id; 
    account_id = [SELECT AccountId FROM Opportunity WHERE Id = :record_id].AccountId;
  }

  // returns list of rid generator records
  @RemoteAction
  global static List<RID_Generator__c> get_rids() {
    List<RID_Generator__c> items = [
      SELECT Id, Area__c, Requirement__c, Solution__c, 
        Sort_Number_For_List__c, Estimated_Effort_Days__c,
        Functional_Area__c, Risk__c, Salesforce_Cloud__c, Package__c
      FROM RID_Generator__c
      WHERE Do_Not_Show__c = false
    ];
    return items;
  }
    
  // returns list of existing rid details
  @RemoteAction
  global static List<X2017_RIDS_DETAILS__c> get_existing(String id) {
    List<X2017_RIDS_DETAILS__c> items = [
      SELECT Id, Area__c, Functional_Area__c, Requirement__c, Solution__c, 
        Risk__c, Estimated_Effort_Days__c, Sort_Order__c, RID_Generator__c,
        Salesforce_Cloud__c, Package__c, Is_Package__c
      FROM X2017_RIDS_DETAILS__c
      WHERE Project_Line_New__c = :id
    ];
    return items;
  }
    
  // upserts a list of rid details (creates project line first if there isn't one)
  @RemoteAction
  global static void set_rids(List<X2017_RIDS_DETAILS__c> rids, String opp_id, string proj_id, String acc_id) {
    System.debug('creating for ' + opp_id + ' & ' + proj_id + ' & ' + acc_id);
    if (proj_id == 'NONE') {
      Project_Line_New__c project = new Project_Line_New__c(
      	Account__c = acc_id,
        Opportunity__c = opp_id
      );
      upsert project;
      proj_id = [SELECT Id FROM Project_Line_New__c WHERE Opportunity__c = :opp_id LIMIT 1].Id;
    }
    System.debug('new' + proj_id);
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
		Risk__c = rids[i].Risk__c,
        Salesforce_Cloud__c = rids[i].Salesforce_Cloud__c,
        Package__c = rids[i].Package__c,
        Is_Package__c = rids[i].Is_Package__c
      );
      items.add(item);
    }
    upsert items;
  }
    
  // deletes rid details based on a list of rid detail ids
  @RemoteAction
  global static void del_rids(List<String> ids) {
    List<X2017_RIDS_DETAILS__c> items = new List<X2017_RIDS_DETAILS__c>();
    for (integer i = 0; i < ids.size(); i++) {
      X2017_RIDS_DETAILS__c item = new X2017_RIDS_DETAILS__c(
        Id = ids[i]
      );
      items.add(item);
    }
    delete items;
  }
    
  // redirect to project line item id
  public static PageReference redirect(){
    String id = ApexPages.currentPage().getParameters().get('id');
    PageReference project = new PageReference('/' + id);
    project.setRedirect(true);
    return project;
  }
    
}