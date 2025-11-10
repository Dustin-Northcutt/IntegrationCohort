public with sharing class MockStripeResponse_Test implements HttpCalloutMock {
    public MockStripeResponse_Test(HttpResponse response) {
        this.response = response;
    }

    private HttpResponse response;

    public HttpResponse respond(HTTPRequest req) {
        return response;
    }

}