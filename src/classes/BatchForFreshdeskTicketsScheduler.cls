global class BatchForFreshdeskTicketsScheduler implements Schedulable
{
    //schedule to run every midnight.
	global static String ticketScheduler() {
        return System.schedule('Schedule every midnight', '0 00 00 * * ?', new BatchForFreshdeskTicketsScheduler());
    }
    
    global void execute (SchedulableContext SC){
         BatchForFreshdeskTickets ticketBatch = new  BatchForFreshdeskTickets();
       	 ID batchprocessid = Database.executeBatch(ticketBatch,200);       	 
    }
}