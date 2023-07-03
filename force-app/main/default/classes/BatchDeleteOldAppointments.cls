public class BatchDeleteOldAppointments implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM ServiceAppointment WHERE SchedEndTime < LAST_N_YEARS:2');
    }

    public void execute(Database.BatchableContext bc, List<ServiceAppointment> listServAppointment) {
        if(!listServAppointment.isEmpty()) {
            delete listServAppointment;
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug(bc);
    }
}