/**
 * Created by ronanwilliams on 2019-09-12.
 */

public class IntegrationErrorHandler {

    public static void sendErrorEmail(String className, String errors, Integer count){

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses     = new String[] { 'ronan@ceterna.com' };
        message.subject         = className + ': ' + count + ' integration errors ' + Datetime.now();
        message.plainTextBody   = count + ' ERRORS: \n' + errors;
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results     = Messaging.sendEmail(messages);
    }
}