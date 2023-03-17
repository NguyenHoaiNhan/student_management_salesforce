public with sharing class DHA_StudentsController {
    
    @AuraEnabled
    public static List<DHA_Student__c> findDuplicatedRecords(String name, Date birthdate, String address, String gender, String email){
        String queryString = 'select Name, Birthdate__c, Gender__c, Email__c, CreatedBy.Name, CreatedDate from DHA_Student__c where Name =:name and Birthdate__c =:birthdate and Address__c =:address and Gender__c =:gender';

        if(email != null){
            queryString += ' and Email__c =:email';
        }

        List<DHA_Student__c> result = Database.query(queryString);
        return result;
    }
}