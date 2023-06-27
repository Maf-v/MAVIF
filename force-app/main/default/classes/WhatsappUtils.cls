global class WhatsappUtils {

	@InvocableMethod(label='SendWhatsApp' description='Envia un mensaje por whatsapp')
    public static void sendMessage(List<FlowInputs> flowInputs) {
		for(FlowInputs flowInput : flowInputs) {
			// Request
			HttpRequest request = new HttpRequest();
			request.setEndpoint('callout:WhatsAppCredential');
			request.setMethod('POST');
	
			String messageContent = 'Hola ' + flowInput.firstName + '\\n' +
			'Se ha registrado su turno de ' + flowInput.workType + ' correctamente para el dia ' + flowInput.appointmentDate + '\\n' +
			'Por favor atender al mismo con 10 minutos de antelación. \\n' +
			'Muchas gracias, estamos a su disposición.';
			String phoneNumber = flowInput.phoneNumber;
			
			String messageBody =		'{'+
			'  "recipient_type": "individual",'+
			'  "messaging_product": "whatsapp",'+
			'  "to" : "'+phoneNumber+'",'+
			'  "type": "interactive",'+
			'  "interactive":{'+
			'    "type": "button",'+
			'    "body": {'+
			'        "text":"'+messageContent+'"'+
			'    }, '+
			'    "action": {'+
			'        "buttons": ['+
			'            {'+
			'                "type": "reply",'+
			'                "reply": {'+
			'                    "id": "unique_postback_id",'+
			'                    "title": "Primer boton"'+
			'                }'+
			'            },'+
			'            {'+
			'                "type": "reply",'+
			'                "reply": {'+
			'                    "id":"unique_postback_id2",'+
			'                    "title": "Segundo boton"'+
			'                }'+
			'            }'+
			'        ]'+
			'    }'+
			'  }'+
			'}';
			request.setBody(messageBody);
	
			// Response
			Http http = new Http();
	
			try {
				HttpResponse response = http.send(request);
				if(response.getStatusCode() == 200) {
					System.debug('Enviado exitosamente');
				}
			} catch (System.Exception ex) {
				System.debug(ex.getStackTraceString());
			}
		}
    }

	global class FlowInputs {
		@InvocableVariable @AuraEnabled 
		global String firstName;
	
		@InvocableVariable @AuraEnabled 
		global String phoneNumber;
	
		@InvocableVariable @AuraEnabled 
		global String workType;
	
		@InvocableVariable @AuraEnabled 
		global String appointmentDate;
	}
}