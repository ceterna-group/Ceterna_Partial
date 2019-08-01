trigger AgreementTriggers on echosign_dev1__SIGN_Agreement__c (before update) 
{
    AgreementTriggerMethods.createContractorDocuments(trigger.oldMap, trigger.newMap);
}