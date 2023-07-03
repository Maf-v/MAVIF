@isTest
public class BatchDeleteOldAppointmentsTest {
    @TestSetup
    static void makeData(){
        List<ServiceAppointment> listServAppointment = new List<ServiceAppointment>();
        for(Integer i = 0; i < 30; i++) {
            ServiceAppointment newServAppointment = new ServiceAppointment(ParentRecordId = '0016e00003N4TTsAAN', Phone='542915719401', Email = 'mafsalesforce@gmail.com',EarliestStartTime = DateTime.now(), DueDate = DateTime.now(), SchedEndTime = Datetime.now().addYears(-2).addMonths(-1), Status = 'Scheduled');
            listServAppointment.add(newServAppointment);
        }

        insert listServAppointment;
    }

    @IsTest
    static void executeBatchTest(){

        List<ServiceAppointment> listServiceAppointment = [SELECT Id FROM ServiceAppointment WHERE SchedEndTime < LAST_N_YEARS:2];
        System.assertEquals(30, listServAppointment.size());
        
        Test.startTest();
        Id batchId = Database.executeBatch(new BatchDeleteOldAppointments());
        Test.stopTest();
        List<ServiceAppointment> newListServiceAppointment = [SELECT Id FROM ServiceAppointment WHERE SchedEndTime < LAST_N_YEARS:2];
        System.assertEquals(0, newListServiceAppointment.size());
    }
}