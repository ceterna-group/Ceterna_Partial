/**
 * Created by ronanwilliams on 2019-08-30.
 */

public with sharing class PreSalesRequestTriggerHandler {


    public static void beforeInsert(List<Pre_Sales_Request__c> newRecords) {

    }

    public static void afterInsert(Map<Id, Pre_Sales_Request__c> newRecordMap) {
        handlePost(newRecordMap, new Map<Id, Pre_Sales_Request__c>());
    }

    public static void beforeUpdate(Map<Id, Pre_Sales_Request__c> newRecordMap, Map<Id, Pre_Sales_Request__c> oldRecordMap) {

    }

    public static void afterUpdate(Map<Id, Pre_Sales_Request__c> newRecordMap, Map<Id, Pre_Sales_Request__c> oldRecordMap) {
        handlePost(newRecordMap, oldRecordMap);
    }

    public static void handlePost(Map<Id,Pre_Sales_Request__c> newRecordMap, Map<Id,Pre_Sales_Request__c> oldRecordMap){




    }

}