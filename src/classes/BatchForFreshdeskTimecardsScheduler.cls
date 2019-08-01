global class BatchForFreshdeskTimecardsScheduler implements Schedulable
{
    //schedule to run every midnight.
	global static String timecardScheduler() {
        return System.schedule('Schedule every midnight', '0 03 00 * * ?', new BatchForFreshdeskTimecardsScheduler());
    }
    
    global void execute (SchedulableContext SC){
         BatchForFreshdeskTimecards timecardBatch = new  BatchForFreshdeskTimecards();
       	 ID batchprocessid = Database.executeBatch(timecardBatch,200);       	 
    }
}