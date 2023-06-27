@RestResource(urlMapping='/webhooks/whatsapp')
global class WhatsappWebhook {

    private static Final String VALID_MESSAGE = 'Verificado';
    private static Final String NOT_VALID_MESSAGE = 'No verificado';
    
    @HttpGet
    global static void whatsappGet() {
        RestResponse response = RestContext.response; // respuesta que se enviara
        RestRequest request = RestContext.request; // request que se esta recibiendo
        if (request.params.get('hub.verify_token') == System.Label.WhatsappAppToken) {
            response.responseBody = Blob.valueOf( request.params.get('hub.challenge'));
        }
    }

    // comprueba que es una request autentica
    @HttpPost
    global static void whatsappPost() {
        RestResponse response = RestContext.response; // crear una respuesta para decirle a fb si hubo un error o fue exitoso
        response.addHeader('Content-type', 'application/json');
        String messageString = RestContext.request.requestBody.toString(); // me el mensaje que envio el usuario
        Map<String, String> headers = RestContext.request.headers;
        String validationResponse = validateWhatsappMessage(RestContext.request, messageString);
       
        if(validationResponse == VALID_MESSAGE) {
            System.debug(System.LoggingLevel.DEBUG, 'Headers de la Respuesta Whatsapp \n ' + JSON.serialize(headers));
            System.debug(System.LoggingLevel.DEBUG, 'Respuesta desde Whatsapp \n ' + messageString);
            response.statusCode = 200;
            response.responseBody = Blob.valueOf(' {success: true, event: "success"}');
        }

    }

    // toma dos argumentos, la request que recibimos, y el mensaje
    private static String validateWhatsappMessage(RestRequest request, String messageString) {
        Map<String, String> headers = request.headers;

        String xHubSignature = headers.get('X-Hub-Signature-256');

        String requestData = RestContext.request.requestBody.toString();

        // verifica si el token de la request es igual a la guardada en el custom label
        String whatsappAppKey = System.Label.WhatsappAppKey;
        Blob signature = Crypto.generateMac('hmacSHA256', Blob.valueOf(requestData), Blob.valueOf(whatsappAppKey)); // este metodo genera un codigo de autentificacion

        String encodedTokenRequestData = 'sha256='+EncodingUtil.convertToHex(signature); // lo convierte a hexadecimal

        // compara si la firma generada es igual a la que contiene el header
        String validationResponse = (encodedTokenRequestData == xHubSignature) ? VALID_MESSAGE : NOT_VALID_MESSAGE;
        return validationResponse;
    }
}