public with sharing class LeadQuery {
    public static List<Lead> queryLeadsForOrgByById(Set<Id> leadIds) {
        return [SELECT id, firstname, lastname, email, company
                FROM Lead
                WHERE id IN :leadIds];
    }
}