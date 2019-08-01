/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_Project_Line_NewTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_Project_Line_NewTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new Project_Line_New__c());
    }
}