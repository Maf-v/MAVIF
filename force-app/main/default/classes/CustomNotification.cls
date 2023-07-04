public without sharing class CustomNotification {

    public static void sendCustomNotification(Set<String> recipientsIds, Set<Id> setRecordIds) {
        // Se obtiene el Id del custom notification type creado
        CustomNotificationType customNotification = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='BellNotification'];

        for(Id recordId : setRecordIds) {
            // Crea un objeto custom notification
            Messaging.CustomNotification notification = new Messaging.CustomNotification();

            // Se le define el titulo y cuerpo de la notificacion
            notification.setTitle('Baja valoracion del profesional');
            notification.setBody('Revisar las opiniones de los asociados, porque su valoracion esta por debajo de 3.');

            // Se define el tipo de notificacion (la obtenida al inicio)
            notification.setNotificationTypeId(customNotification.Id);

            // Se define el id del registro al cual hace referencia la notificacion, y al cual sera redirigido el usuario al clickear en ella
            notification.setTargetId(recordId);

            // Envia la notificacion
            try {
                // Tiene que ser un Set de Strings
                notification.send(recipientsIds);
            }
            catch (Exception e) {
                System.debug('Problem sending notification: ' + e.getMessage());
            }
        }

    }

}