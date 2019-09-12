/**
 * Created by ronanwilliams on 2019-09-12.
 */

public class IntegrationErrorHandler {

    public static void sendErrorEmail(String errors){

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses     = new String[] { 'ronan@ceterna.com' };
        message.subject         = 'Integration errors ' + Datetime.now();
        message.plainTextBody   = errors;
        Messaging.SingleEmailMessage[] messages =
        new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
}