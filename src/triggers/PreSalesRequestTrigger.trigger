/**
 * Created by ronanwilliams on 2019-08-30.
 */

trigger PreSalesRequestTrigger on Pre_Sales_Request__c (before insert, before update, before delete,
                                                        after insert, after update, after delete, after undelete) {

    if (Trigger.isBefore && !System.isFuture()) {
        if (Trigger.isInsert) {
        }
        if (Trigger.isUpdate) {
        }
    }

    if (Trigger.isAfter && !System.isFuture()) {
        if (Trigger.isInsert) {
            PreSalesRequestTriggerHandler.afterInsert(Trigger.newMap);
        }
        if (Trigger.isUpdate) {
        }
    }

}