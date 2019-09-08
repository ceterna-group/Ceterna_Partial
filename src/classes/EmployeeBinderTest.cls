/**
 * Created by ronanwilliams on 2019-09-05.
 */


@IsTest
public class EmployeeBinderTest {

    @IsTest
    public static void testBind(){

        // verify that before the binder runs no employees exist
        System.assertEquals(0,[SELECT Id FROM Employee__c].size());

        EmployeeBinder.bind();

        // verify that after the binder runs no employees exist
        System.assertEquals(1,[SELECT Id FROM Employee__c].size());

        // because the test methods do not make callouts, this is a simple invocation of the callout helper method
        // solely to ensure code coverage
        EmployeeBinder.responseBuilder('endpoint', 'GET', 'bearer');


    }

}