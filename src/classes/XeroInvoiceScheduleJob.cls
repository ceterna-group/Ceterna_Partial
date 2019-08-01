global class XeroInvoiceScheduleJob implements Schedulable {
   global void execute(SchedulableContext SC) {
      XeroInvoiceUpdation.updateInvoiceAmount();
 /* XeroInvoiceRecordsBatch objXeroInvoiceRecordsBatch = new XeroInvoiceRecordsBatch();
   ID batchprocessid = Database.executeBatch(objXeroInvoiceRecordsBatch,100); */
   }
}