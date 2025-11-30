public with sharing class LeadPayload {
    public class LeadInt {
        public String firstname;
        public String lastname;
        public String company;
        public String email;
        public attributes attributes;
    }

    public class Attributes {
        public String type;
        public String referenceId;
    }

    public List<LeadInt> records;
}