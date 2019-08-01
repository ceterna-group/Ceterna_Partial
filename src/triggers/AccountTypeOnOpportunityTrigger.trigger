/**
* Trigger to update the parent account of an opportunity when it is open, closed won or closed lost
* @author Constance Rouge - Ceterna Ltd
* @createddate 06/03/2017
*/

//This trigger is made inactive as on 20/2/2018 as Sean wants the account type to not to be set.

trigger AccountTypeOnOpportunityTrigger on Opportunity (after insert,after update) {
    
 /*   Map<Id,Account> acctToUpdateMap = new Map<Id,Account>();          
    List<String> AccToCheckLost = new List<string>();
    
    if(trigger.isAfter && (trigger.isUpdate || trigger.isInsert)){
        
        for (Opportunity opp : Trigger.New) {
            //First case: inserting a new Open opportunity will set the account Type as Open Opportunity
            if (trigger.isInsert  && !opp.isClosed) {  
                System.debug('1.1');
                acctToUpdateMap.put(opp.AccountId,new Account(Id=opp.AccountId, Type='Open Opportunity')) ;
            }
            
            //Second case: the opportunity is closed won (either inserted or updated to become closed won),
            //it will set the account Type as Customer
            if ((trigger.isInsert && opp.IsWon)
                || (trigger.isUpdate && opp.isWon && !trigger.oldMap.get(opp.id).isWon)
               ) {  
                    System.debug('2.1');
                   acctToUpdateMap.put(opp.AccountId,new Account(Id=opp.AccountId, Type='Customer')) ;
               }
            
            //Third case: the opportunity is closed lost (either inserted or updated to become closed won),
            //it depends if the account already has at least one closed won opportunity
            if ((Trigger.isInsert && opp.IsClosed && !opp.IsWon )
                || (trigger.isUpdate && !opp.IsWon && opp.IsClosed && (!trigger.oldMap.get(opp.id).isClosed || trigger.oldMap.get(opp.id).isWon))
               ) {  
                   AccToCheckLost.add(opp.AccountId);           
               }
        }
        
        //We verify the accounts for the closed lost opportunities
        for(Account acc:[select id,type,(select id, isWon from Opportunities) from Account where Id IN:AccToCheckLost]){ 
            //We verify if the account already has at least one closed won opportunity
            Boolean containAWonOpp=false;
            for(Opportunity opp:acc.opportunities){
                if(opp.IsWon){
                    containAWonOpp=true;
                }
            }
            //If yes, the type of the account becomes Customer
            if(containAWonOpp){
                System.debug('1');
                acc.Type ='Customer';
                acctToUpdateMap.put(acc.Id,acc);
            }
            //Else, it becomes Lost Opportunity
            else{
                System.debug('2');
                acc.Type='Lost Opportunity';
                acctToUpdateMap.put(acc.Id,acc);
            }
        }
        
        //Finally, we update the accounts
        if(acctToUpdateMap!=null && !acctToUpdateMap.isEmpty())
            System.debug('Acct to Update: ' + acctToUpdateMap);
            Database.update(acctToUpdateMap.values());
    }

    */
}