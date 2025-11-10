HttpRequest request = new HttpRequest();
request.setEndpoint('https://735ef563-176d-431c-85ce-2cc07056ef03.mock.pstmn.io/payments/link');
request.setMethod('GET');

Http http = new Http();
HttpResponse response = http.send(request);
if (response.getStatus() == 'OK') {
    Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
    Map<String, Object> resTransaction = (Map<String, Object>)responseMap.get('transaction');
    Map<String, Object> transactionDetails = (Map<String, Object>)resTransaction.get('details');
    String IP = (String)transactionDetails.get('IP');
    system.debug('IP :::::::: ' + IP);
    //TODO Use ApexType instead of Maps
} else {
    Logger.error('Error: ' + response.getStatus() + ' ' + response.getStatusCode());
    Logger.saveLog();
}