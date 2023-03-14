public with sharing class DHA_StudentSearchController {
    
    @AuraEnabled
    public static List<DHA_Class_Assignment__c> getStudentsWithConditions(String searchVal, Date birthDate, String className){
        String queryString = 'select DHA_Student__r.Id, DHA_Student__r.Student_Code__c, DHA_Student__r.Name, DHA_Student__r.Birthdate__c, DHA_Student__r.Address__c, DHA_Student__r.Email__c from DHA_Class_Assignment__c';
        List<String> conditions = new List<String>();

        if(searchVal == null && birthDate == null && className == null){
            return Database.query(queryString);
        }

        if(searchVal != null){
            conditions.add('DHA_Student__r.Name like \'%' + searchVal + '%\'');
        }

        if(birthDate != null){
            conditions.add('DHA_Student__r.Birthdate__c=' + birthDate);
        }

        if(className != null){
            conditions.add('DHA_Class__r.Name=\'' + className + '\'');
        }

        queryString += ' where ';
        queryString += string.join(conditions, ' and ');
        List<DHA_Class_Assignment__c> result = Database.query(queryString);

        return result;
    }

    @AuraEnabled
    public static List<DHA_Class__c> getClasses(){          
        List<DHA_Class__c> result = [
                select Name
                from DHA_Class__c
            ];
        
        return result;
    }
}