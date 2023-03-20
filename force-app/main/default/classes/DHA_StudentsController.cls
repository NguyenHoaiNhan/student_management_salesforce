public with sharing class DHA_StudentsController {
    @AuraEnabled
    public static List<DHA_Student__c> findDuplicatedRecords(String name, Date birthdate, String address, String gender, String email){
        String queryString = 'select Name, Birthdate__c, Gender__c, Email__c, CreatedBy.Name, CreatedDate from DHA_Student__c where Name =:name and Birthdate__c =:birthdate and Address__c =:address and Gender__c =:gender';

        if(email != null && email.trim() != ''){
            queryString += ' and Email__c =:email';
        }

        List<DHA_Student__c> result = Database.query(queryString);
        return result;
    }

    @AuraEnabled
    public static String insertStudent(String name, Date birthdate, String address, String gender, String email){
        DHA_Student__c student = new DHA_Student__c(
            Name = name,
            Birthdate__c = birthdate,
            Address__c = address,
            Gender__c = gender,
            Email__c = email
        );
    
        Database.SaveResult[] srList = Database.insert(new List<DHA_Student__c>{student}, false);
        return srList[0].getId();
    }

    @AuraEnabled
    public static List<DHA_Class__c> getClasses(){
        List<DHA_Class__c> result = [
        select Name, (   
                select Name 
                from DHA_Class_Assignments__r
            ), 
            Start_Date__c, 
            End_Date__c
        from DHA_Class__c
        ];
        return result; 
    }

    @AuraEnabled
    public static void assignStudent(String studentId, List<String> classCodes){
        List<DHA_Class__c> classesToAssign = [select Id from DHA_Class__c where Name in :classCodes];
        List<DHA_Class_Assignment__c> assignList = new List<DHA_Class_Assignment__c>();
        
        for(DHA_Class__c classItem : classesToAssign){  
            DHA_Class_Assignment__c temp = new DHA_Class_Assignment__c(
                Assigned_Date__c = date.today(),
                DHA_Student__c = studentId,
                DHA_Class__c = classItem.Id
            );
            assignList.add(temp);
        }

        Database.SaveResult[] rsList = Database.insert(assignList, false);
    }
}