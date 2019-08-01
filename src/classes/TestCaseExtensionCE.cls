@isTest
private class TestCaseExtensionCE 
{
    static testMethod void testControllerExtension() 
    {
        Test.setCurrentPage(Page.Evolution2);
        
        Case c = new Case();
        
        CaseExtension controller = new CaseExtension(new ApexPages.StandardController(c));
    }
}