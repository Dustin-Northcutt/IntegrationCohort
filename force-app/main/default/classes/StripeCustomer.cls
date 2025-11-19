public with sharing class StripeCustomer {
    public string id;
    public string name;
    public string email;


    public class SearchResponse {
        public List<StripeCustomer> data;
    }
}

