List<ServiceAppointment> listServAppointment = new List<ServiceAppointment>();
for(Integer i = 0; i < 30; i++) {
	ServiceAppointment newServAppointment = new ServiceAppointment(ParentRecordId = '0016e00003N4TTsAAN', EarliestStartTime = DateTime.now(), DueDate = DateTime.now(), Status = 'Scheduled');
	listServAppointment.add(newServAppointment);
}

insert listServAppointment;

Map<Integer,String> comentarios = new Map<Integer,String>{1 => 'No demostro interes en mi problema', 2 => 'No me senti comodo', 3 => 'No fue puntual', 4 => '¡Muy profesional!',5 => '¡Excelente profesional! Recomendado.'};

List<Review__c> listReviews = new List<Review__c>();
for(ServiceAppointment servAppointment : listServAppointment) {
	Integer random = Integer.valueof((Math.random() * 5) + 1);
	Review__c newReview = new Review__c(Name = servAppointment.AppointmentNumber, Service_Appointment__c = servAppointment.Id, Valoracion__c = random, Comentario__c = comentarios.get(random));
	listReviews.add(newReview);
} 

insert listReviews;

List<ServiceResource> listServResource = [SELECT Id FROM ServiceResource WHERE CreatedDate = TODAY];

List<AssignedResource> listAssigResource = new List<AssignedResource>();
for(Integer i = 0; i < listServAppointment.size(); i++) {
    AssignedResource newAssigResource = new AssignedResource(ServiceAppointmentId = listServAppointment[i].Id, ServiceResourceId = listServResource[i].Id);
    listAssigResource.add(newAssigResource);
}

insert listAssigResource;
