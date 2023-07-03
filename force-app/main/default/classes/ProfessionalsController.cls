public without sharing class ProfessionalsController {

    @AuraEnabled(cacheable=true)
    public static List<ServiceResource> getProfessionalsByType(String workTypeGroup) {
        List<ServiceResource> listProfessionals = [SELECT Id, Name, Phone__c, (SELECT Id, Label, WorkTypeGroup.Name FROM ShiftServiceResources) FROM ServiceResource WHERE Id IN (SELECT ServiceResourceId FROM Shift WHERE WorkTypeGroup.Name = :workTypeGroup)  WITH SECURITY_ENFORCED];
        return listProfessionals;
    }

    @AuraEnabled(cacheable=true)
    public static List<Review__c> getReviewsByProfessionalName(String professionalName) {
        List<Review__c> listReviews = [SELECT Id, Comentario__c, Valoracion__c, Service_Appointment__c, CreatedDate FROM Review__c WHERE Service_Appointment__c IN (SELECT ServiceAppointmentId FROM AssignedResource WHERE ServiceResource.Name = :professionalName) WITH SECURITY_ENFORCED];
        return listReviews;
    }     

    @AuraEnabled(cacheable=true)
    public static List<WorkTypeGroup> getWorkTypesGroup() {
        List<WorkTypeGroup> listWorkTypes = [SELECT Id, Name FROM WorkTypeGroup WITH SECURITY_ENFORCED];
        return listWorkTypes;
    }

}