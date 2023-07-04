@isTest
global class WhatsappUtilsCalloutMock implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
        response.setBody('{ "example": "test"}');

        return response;
    }
}