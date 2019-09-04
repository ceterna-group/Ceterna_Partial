/**
 * Created by ronanwilliams on 2019-08-30.
 */

public with sharing class PreSalesRequestTriggerHandler {


    public static void beforeInsert(List<Pre_Sales_Request__c> newRecords) {

    }

    public static void afterInsert(Map<Id, Pre_Sales_Request__c> newRecordMap) {
//        handlePost(newRecordMap, new Map<Id, Pre_Sales_Request__c>());
    }

    public static void beforeUpdate(Map<Id, Pre_Sales_Request__c> newRecordMap, Map<Id, Pre_Sales_Request__c> oldRecordMap) {

    }

    public static void afterUpdate(Map<Id, Pre_Sales_Request__c> newRecordMap, Map<Id, Pre_Sales_Request__c> oldRecordMap) {
//
//        Set<Id> postIds = new Set<Id>();
//
//        for ()
//
//        handlePost(newRecordMap, oldRecordMap);
    }

    public static void handlePost(Set<Id> recordIds){


//        title - (required) the title of the story - max 200 characters
//        story_type - (required) the type of the story: task, deliverable, or milestone
//        workspace_id - (required) the ID of the Workspace in which the story will be created
//        description - (optional) a description of the new story - max 1000 characters
//        parent_id - (optional) represents the parent of this story, making this a sub-story
//        start_date - (optional) the date the story should be started; format should look like YYYY-MM-DD
//        archived - (optional) the archived status of the story (true or false)
//                due_date - (optional) the date the story is due; format should look like YYYY-MM-DD
//        assignee_ids - (optional) an array of User IDs that the new story should be assigned to
//        budget_estimate_in_cents - (optional) the budget in cents of the new story (integer). This is only valid in budgeted Workspaces and if the user can view budget information
//        time_estimate_in_minutes - (optional) the time estimate in minutes of the new story (integer). This is only valid in budgeted Workspaces and if the user can view budget information
//        fixed_fee - (optional) the fixed fee status of the story (true or false). Time logged against a fixed fee story does not impact the story's budget. Only present for budgeted workspaces and if the authenticated user can view budget information.
//        billable - (optional) whether this story is billable time. Only present for budgeted workspaces and if the authenticated user can view budget information.
//        tag_list - (optional) a comma separated String of tags
//        checklist - (optional) an array of strings. Each string will become a separate checklist item.
//        percentage_complete - (optional) the completion percentage of the story; setting above 0 starts the story and setting to 100 completes the story.

    }

}