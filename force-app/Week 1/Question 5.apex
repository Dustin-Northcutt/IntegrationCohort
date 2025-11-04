HttpRequest request = new HttpRequest();
request.setEndpoint('https://735ef563-176d-431c-85ce-2cc07056ef03.mock.pstmn.io/payments/link');
request.setMethod('GET');

Http http = new Http();
HttpResponse response = http.send(request);
if (response.getStatus() == 'OK') {
    Map<string, Object> responseMap = (Map<string, Object>)JSON.deserializeUntyped(response.getBody());
    Map<string, Object> resTransaction = (Map<string, Object>)responseMap.get('transaction');
    Map<string, Object> transactionDetails = (Map<string, Object>)resTransaction.get('details');
    string IP = (string)transactionDetails.get('IP');
    system.debug('IP :::::::: ' + IP);
    //TODO Use ApexType instead of Maps
} else {
    Logger.error('Error: ' + response.getStatus() + ' ' + response.getStatusCode());
    Logger.saveLog();
}
