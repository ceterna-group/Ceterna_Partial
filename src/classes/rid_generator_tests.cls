/*
 *  RID Generator Tests
 *  - tests for the RID Generator class
 * 
 *  @authors 
 * 	- Alan Abishev <alan@ceterna.com>
 * 	- Elliott Thurman-Newell <elliott@ceterna.com>
 *  @created 21/04/2017
 *  @version 1.1
 * 
 *  @changelog:
 * 	- 1.1 <elliott@ceterna.com>
 * 	  + Added new fields for generator and detail SOQLs (Salesforce_Cloud__c && Package__c)
 * 
 *    
 * 	- 1.0 <alan@ceterna.com>
 * 	  + Initial Commit
 * 
 */
@isTest
public class rid_generator_tests {
    
    
    
    // set opp name, opp id, proj id if any, and account id
    @isTest
    private static void testFirst() {
        
        Test.startTest();
        rid_generator_tests rt = new rid_generator_tests();
        Account acc = rt.getAccount();
        insert acc;
        Opportunity opp = rt.getOpportunity(acc.id);
        insert opp;
        
        //To get id from URL
        apexpages.currentpage().getparameters().put('id' , opp.id);
        //Instantiating Rid Generator controller (also invokes constructor test)
        rid_generator rd = new rid_generator();
        
        RID_Generator__c ridGen = rt.getRidGenerator();
        insert ridGen;
        
        List<RID_Generator__c> lstOfRids = rid_generator.get_rids();
        System.debug(lstOfRids);
        
        Project_Line_New__c pl = rt.getProjectLine(acc,opp);       
        insert pl;
        
        X2017_RIDS_DETAILS__c ridDetail = rt.getRidDetails(opp,pl,ridGen);
        insert ridDetail;
        
        List<X2017_RIDS_DETAILS__c> lstOfRidDetails = rid_generator.get_existing(pl.id);
        System.debug(lstOfRidDetails);
        
        rid_generator.set_rids(lstOfRidDetails, opp.id, pl.id, acc.id);
        rid_generator.set_rids(lstOfRidDetails, opp.id, 'NONE', acc.id);
        
        List<String> lstOfRidIds = new List<String>();
        for (X2017_RIDS_DETAILS__c ridDet :lstOfRidDetails){
            lstOfRidIds.add(ridDet.id);
        }
        
        rid_generator.del_rids(lstOfRidIds);
        
        PageReference pr =  rid_generator.redirect();
        
        test.stopTest();
    }
    
    
    //Test Data
    
    public Account getAccount(){
        Account acc = new Account(Name='testAcc ');
        
        return acc;
    }
    
    public Opportunity getOpportunity(String accId){
        
        Opportunity opp = new Opportunity(Name='testOpp ',AccountId = accId,CloseDate= system.today().addDays(20),StageName= 'New');
        
        return opp;
    }
    
    public RID_Generator__c getRidGenerator(){
        RID_Generator__c ridGen = new RID_Generator__c(
            Area__c='sample area', 
            Requirement__c='sample requirement',
            Solution__c='sample solution', 
            Sort_Number_For_List__c=5, 
            Estimated_Effort_Days__c=4,
            Functional_Area__c='API Integration', 
            Salesforce_Cloud__c='Sales Cloud',
            Package__c='Sales Cloud QS 1',
            Risk__c=2,
            Do_Not_Show__c = false);
        return ridGen;  
    }   
    
    public Project_Line_New__c getProjectLine(Account acc, Opportunity opp){
        Project_Line_New__c pl = new Project_Line_New__c( Account__c = acc.id,
                                                         Opportunity__c = opp.id);
        return pl;
    }
    
    public X2017_RIDS_DETAILS__c getRidDetails(Opportunity opp, Project_Line_New__c pl,RID_Generator__c rg ){
        X2017_RIDS_DETAILS__c ridDetails = new X2017_RIDS_DETAILS__c(
            RID_Generator__c = rg.id,
            Area__c='sample area', 
            Opportunity__c = opp.id ,
            Project_Line_New__c = pl.id,
            Requirement__c='sample requirement',
            Solution__c='sample solution', 
            Estimated_Effort_Days__c=4,
            Functional_Area__c='API Integration', 
            Salesforce_Cloud__c='Sales Cloud',
            Package__c='Sales Cloud QS 1',
            Is_Package__c = false,
            Risk__c=2,
            Sort_Order__c=3);
        return ridDetails;  
    }
    
    
    
    
}