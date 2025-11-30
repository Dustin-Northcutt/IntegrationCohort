public with sharing class OrgBService {

    public class OrgBException extends Exception{}

    public LeadPayload setLeadPayloadFromLeadd(List<Lead> leads) {
        Integer maxRecords = 200;

        if (leads.size() > maxRecords) throw new OrgBException('Max ' + maxRecords + ' records allowed');

        LeadPayload payload = new LeadPayload();
        for (Lead lead : leads) {
            LeadPayload.LeadInt leadInt = new LeadPayload.LeadInt();
            leadInt.firstname = lead.firstname;
            leadInt.lastname = lead.lastname;
            leadInt.email = lead.email;
            leadInt.company = lead.company;
            leadInt.attributes = new LeadPayload.Attributes();
            leadInt.attributes.type = 'Lead';
            leadInt.attributes.referenceId = lead.id;
            if (payload.records == null) {
                payload.records = new List<LeadPayload.LeadInt>{leadInt};
            } else {
                payload.records.add(leadInt);
            }
        }
        return payload;
    }

    public HttpResponse sendLeadsToOrgB(LeadPayload payload) {
        String requestMethod = 'POST';
        String endpoint = 'callout:SF_Server/services/data/v65.0/composite/tree/Lead/';
        String contentType = 'application/json';
        
        HttpRequest request = new HttpRequest();
        request.setMethod(requestMethod);
        request.setEndpoint(endpoint);
        request.setHeader('Content-Type',contentType);
        request.setBody(JSON.serialize(payload));
        return sendRequest(request);
    }

    public HttpResponse sendRequest(HttpRequest request) {
        Http http = new Http();
        HttpResponse response = http.send(request);
        if (response.getStatus() != 'OK') {
            Logger.error('Error sending request to Org B');
            Logger.saveLog();
            throw new OrgBException('Error sending request to Org B');
        }
        return response;
    }
}