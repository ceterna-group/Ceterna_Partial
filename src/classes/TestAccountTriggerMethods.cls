@isTest
private class TestAccountTriggerMethods 
{
    static testMethod void testCreateProjectLines() 
    {
        Account acc = new Account();
        acc.Name = 'test account';
        acc.Appraisals__c = true;
        acc.Associate_management__c = true;
        acc.Campaigns_management__c = true;
        acc.Contract_management__c = true;
        acc.Credit_Control__c = true;
        acc.Customer_Services__c = true;
        acc.Event_management__c = true;
        acc.Expense_management__c = true;
        acc.Expenses__c = true;
        acc.Field_Sales__c = true;
        acc.Field_support__c = true;
        acc.Grading__c = true;
        acc.In_house_support_desk__c = true;
        acc.Internal_Sales__c = true;
        acc.Price_books__c = true;
        acc.Product_configuration__c = true;
        acc.Product_management__c = true;
        acc.Project_management__c = true;
        acc.Recruitment__c = true;
        acc.Reseller_Sales__c = true;
        acc.Resource_management__c = true;
        acc.Salary_reviews__c = true;
        acc.Satisfaction_surveys__c = true;
        acc.Service_provider_management__c = true;
        acc.Social_Media__c = true;
        acc.Telemarketing__c = true;
        acc.Time_management__c = true;
        acc.Training__c = true;
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'test account 2';
        acc1.Appraisals__c = false;
        acc1.Associate_management__c = false;
        acc1.Campaigns_management__c = false;
        acc1.Contract_management__c = false;
        acc1.Credit_Control__c = false;
        acc1.Customer_Services__c = false;
        acc1.Event_management__c = false;
        acc1.Expense_management__c = false;
        acc1.Expenses__c = false;
        acc1.Field_Sales__c = false;
        acc1.Field_support__c = false;
        acc1.Grading__c = false;
        acc1.In_house_support_desk__c = false;
        acc1.Internal_Sales__c = false;
        acc1.Price_books__c = false;
        acc1.Product_configuration__c = false;
        acc1.Product_management__c = false;
        acc1.Project_management__c = false;
        acc1.Recruitment__c = false;
        acc1.Reseller_Sales__c = false;
        acc1.Resource_management__c = false;
        acc1.Salary_reviews__c = false;
        acc1.Satisfaction_surveys__c = false;
        acc1.Service_provider_management__c = false;
        acc1.Social_Media__c = false;
        acc1.Telemarketing__c = false;
        acc1.Time_management__c = false;
        acc1.Training__c = false;
        insert acc1;
        
        acc1.Appraisals__c = true;
        acc1.Associate_management__c = true;
        acc1.Campaigns_management__c = true;
        acc1.Contract_management__c = true;
        acc1.Credit_Control__c = true;
        acc1.Customer_Services__c = true;
        acc1.Event_management__c = true;
        acc1.Expense_management__c = true;
        acc1.Expenses__c = true;
        acc1.Field_Sales__c = true;
        acc1.Field_support__c = true;
        acc1.Grading__c = true;
        acc1.In_house_support_desk__c = true;
        acc1.Internal_Sales__c = true;
        acc1.Price_books__c = true;
        acc1.Product_configuration__c = true;
        acc1.Product_management__c = true;
        acc1.Project_management__c = true;
        acc1.Recruitment__c = true;
        acc1.Reseller_Sales__c = true;
        acc1.Resource_management__c = true;
        acc1.Salary_reviews__c = true;
        acc1.Satisfaction_surveys__c = true;
        acc1.Service_provider_management__c = true;
        acc1.Social_Media__c = true;
        acc1.Telemarketing__c = true;
        acc1.Time_management__c = true;
        acc1.Training__c = true;
        update acc1;
        
    }
}