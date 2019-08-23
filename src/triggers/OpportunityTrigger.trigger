/**
 * Created by ronanwilliams on 2019-08-13.
 */

trigger OpportunityTrigger on Opportunity (before insert, before update, after insert, after update) {

    if (Trigger.isBefore && !System.isFuture()) {
        if (Trigger.isInsert) {
        }
        if (Trigger.isUpdate) {
        }
    }

    if (Trigger.isAfter && !System.isFuture()) {
        if (Trigger.isInsert) {
            OpportunityTriggerHandler.afterInsert(Trigger.newMap);
        }
        if (Trigger.isUpdate) {
            OpportunityTriggerHandler.afterUpdate(Trigger.newMap, Trigger.oldMap);
        }
    }


}