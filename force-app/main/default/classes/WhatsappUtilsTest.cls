@isTest
private with sharing class WhatsappUtilsTest {
    /*
    @TestSetup
    static void makeData() {
        Account account = [SELECT Id FROM Account WHERE Name = 'Mariano Folco' LIMIT 0];
	    ServiceAppointment newServAppointment = new ServiceAppointment(ParentRecordId = account.Id, Phone='542915719401', EarliestStartTime = DateTime.now(), DueDate = DateTime.now(), Status = 'Scheduled');
        insert newServAppointment;
    }
    */

    @isTest
    static void executeTest() {
        Test.setMock(HttpCalloutMock.class, new WhatsappUtilsCalloutMock());

        WhatsappUtils.FlowInputs flowInputs = new WhatsappUtils.FlowInputs();
        flowInputs.firstName = 'Test';
        flowInputs.phoneNumber = '542915719401';
        flowInputs.workType = 'Test Work Type';
        flowInputs.appointmentDate = '24/08/2023';
        List<WhatsappUtils.FlowInputs> listFlowInputs = new List<WhatsappUtils.FlowInputs>();
        listFlowInputs.add(flowInputs);

        Test.startTest();
        WhatsappUtils.sendMessage(listFlowInputs);
        Integer callouts = Limits.getCallouts();
        Test.stopTest();

        System.assertEquals(1, callouts, 'Un callout se debe haber hecho');
    }
}