public with sharing class ReviewTriggerHandler {

    public static List<ServiceResource> bulkUpdateAverageRating(List<Review__c> reviewList) {
        // Primero comprueba que el campo sea actualizable
        if (!Schema.sObjectType.ServiceResource.fields.Valoracion_Promedio__c.isUpdateable()) {
            return null;
        }

        // Obtiene todos los id de los turnos relacionados a cada nuevo review
        List<Id> serviceAppointmentIdList = new List<Id>();
        for(Review__c review : reviewList) {
            serviceAppointmentIdList.add(review.Service_Appointment__c);
        }
        // Se usan para obtener los assigned resource relacionados a los turnos de los nuevos reviews
        List<AssignedResource> listAssignedResource = [SELECT Id, ServiceAppointmentId, ServiceResourceId, ServiceResource.Name FROM AssignedResource WHERE ServiceAppointmentId IN :serviceAppointmentIdList WITH SECURITY_ENFORCED];

        // Obtiene los id de los profesionales
        Set<Id> professionalIdSet = new Set<Id>(); 
        for(AssignedResource assigResource : listAssignedResource) {
            professionalIdSet.add(assigResource.ServiceResourceId);
        }

        // Devuelve TODOS los turnos de esos profesionales y sus reviews
        List<ServiceAppointment> servAppointmentList = [SELECT Id, (SELECT Id, Valoracion__c FROM RelatedReviews__r), (SELECT Id, ServiceAppointmentId, ServiceResourceId FROM ServiceResources) FROM ServiceAppointment WHERE Id IN (SELECT ServiceAppointmentId FROM AssignedResource WHERE ServiceResourceId IN :professionalIdSet) WITH SECURITY_ENFORCED];
        
        // Crea un Map con los Id de los profesionales como key, y una lista de sus valoraciones como valor
        Map<Id,List<Integer>> professionalsValoracionMap = new Map<Id,List<Integer>>();
        for(ServiceAppointment servAppointment : servAppointmentList) {
            for(AssignedResource assigResource : servAppointment.ServiceResources) {
                // Si todavia no se encuentra el Id de ese profesional en el map, agregarlo
                if(!professionalsValoracionMap.containsKey(assigResource.ServiceResourceId)) {
                    professionalsValoracionMap.put(assigResource.ServiceResourceId, new List<Integer>());
                }
                
                for(Review__c review : servAppointment.RelatedReviews__r) {
                    professionalsValoracionMap.get(assigResource.ServiceResourceId).add(Integer.valueOf(review.Valoracion__c));
                }
            }
        }
        
        List<ServiceResource> professionalsRecords = [SELECT Id, Valoracion_Promedio__c FROM ServiceResource WHERE Id IN :professionalIdSet WITH SECURITY_ENFORCED];
        Set<Id> badRatingProfessionals = new Set<Id>();
        for(ServiceResource professional : professionalsRecords) {
            Double averageRating = calculateAverage(professionalsValoracionMap.get(professional.Id));
            professional.Valoracion_Promedio__c = averageRating;
            // Si la valoracion promedio es menor a 3, se lo agrega al Set para luego enviar la notificacion
            if(averageRating < 3) {
                badRatingProfessionals.add(professional.Id);
            }
        }

        update professionalsRecords;

        // Crea un Set de Strings con los usuarios que tienen ese perfil
        List<User> users = [SELECT Id, Profile.Name FROM User WHERE Profile.Name = 'Director de Profesionales'];
        Set<String> usersId = new Set<String>();
        for(User user : users) {
            usersId.add((String)user.Id);
        }
        CustomNotification.sendCustomNotification(usersId, badRatingProfessionals);
        
        return professionalsRecords;
    }

    public static Double calculateAverage(List<Integer> valoracionList) {
        Double suma = 0;
        for(Integer valoracion : valoracionList) {
            suma += valoracion;
        }
        Double promedio = suma / valoracionList.size();
        return promedio;
    }
}