@isTest
private class ReviewTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        Profile p = [select id from Profile where name='Chatter Free User'];

		String json = '[{\"firstName\":\"Gerardo\",\"lastName\":\"Houten\",\"email\":\"ghouten0@delicious.com\"}]';
        List<JSON2Apex> listObj = JSON2Apex.parse(json);

        WorkTypeGroup wTG = new WorkTypeGroup(Name = 'Test WTG', GroupType = 'Default');
        insert wTG;

        String alias = listObj[0].lastName + '0' + 'test';
        User u = new User(alias = alias.substring(0, 5), email='test' + listObj[0].email,
                emailencodingkey='UTF-8', firstName=listObj[0].firstName, lastname=listObj[0].lastName, languagelocalekey='en_US',
                localesidkey='en_US', profileid = p.id,
                timezonesidkey='Europe/London', username='test' + listObj[0].email);
        insert u;

        ServiceResource servResource = new ServiceResource(RelatedRecordId = u.Id, ResourceType = 'T', Name = u.firstName + ' ' + u.lastName, IsActive = true);
        insert servResource;

        List<ServiceAppointment> listServAppointment = new List<ServiceAppointment>();
        for(Integer i = 0; i < 5; i++) {
            ServiceAppointment newServAppointment = new ServiceAppointment(ParentRecordId = '0016e00003N4TTsAAN', EarliestStartTime = DateTime.now(), DueDate = DateTime.now(), Status = 'Scheduled');
            listServAppointment.add(newServAppointment);
        }
        insert listServAppointment;

        Map<Integer,String> comentarios = new Map<Integer,String>{1 => 'No demostro interes en mi problema', 2 => 'No me senti comodo', 3 => 'No fue puntual', 4 => '¡Muy profesional!',5 => '¡Excelente profesional! Recomendado.'};

        List<Review__c> listReviews = new List<Review__c>();
        for(Integer i = 0; i < listServAppointment.size(); i++) {
            Review__c newReview = new Review__c(Name = listServAppointment[i].AppointmentNumber, Service_Appointment__c = listServAppointment[i].Id, Valoracion__c = i + 1, Comentario__c = comentarios.get(i + 1));
            listReviews.add(newReview);
        }
        insert listReviews;

        List<AssignedResource> listAssigResource = new List<AssignedResource>();
        for(Integer i = 0; i < listReviews.size(); i++) {
            AssignedResource newAssigResource = new AssignedResource(ServiceAppointmentId = listServAppointment[i].Id, ServiceResourceId = servResource.Id);
            listAssigResource.add(newAssigResource);
        }
        insert listAssigResource;
    }

    @isTest
    static void bulkUpdateAverageRatingTest() {
        List<ServiceResource> servResource = [SELECT Id FROM ServiceResource WHERE Name = 'Gerardo Houten'];
        System.assertEquals(1, servResource.size());

        Datetime dt = Datetime.now().addMinutes(-2);
        List<Review__c> listReview = [SELECT Id, Service_Appointment__c FROM Review__c WHERE CreatedDate > :dt];
        System.assertEquals(5, listReview.size());

        List<ServiceResource> professional = ReviewTriggerHandler.bulkUpdateAverageRating(listReview);
        System.assertEquals(3, professional[0].Valoracion_Promedio__c);
    }
}