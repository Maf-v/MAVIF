List<ServiceAppointment> listServAppointment = [SELECT Id FROM ServiceAppointment WHERE CreatedDate = TODAY];
List<ServiceResource> listServResource = [SELECT Id FROM ServiceResource WHERE CreatedDate = TODAY];

List<AssignedResource> listAssigResource = new List<AssignedResource>();

for(Integer i = 0; i < listServAppointment.size(); i++) {
    AssignedResource newAssigResource = new AssignedResource(ServiceAppointmentId = listServAppointment[i].Id, ServiceResourceId = listServResource[i].Id);
    listAssigResource.add(newAssigResource);
}

insert listAssigResource;