public with sharing class DHA_StudentSearchController {
    @AuraEnabled
    public static List<DHA_Class_Assignment__c> getStudentsWithConditions(String searchVal, Date birthDate, String className){
        String queryString = 'select DHA_Student__r.Id, DHA_Student__r.Student_Code__c, DHA_Student__r.Name, DHA_Student__r.Birthdate__c, DHA_Student__r.Address__c, DHA_Student__r.Email__c from DHA_Class_Assignment__c';
        List<String> conditions = new List<String>();
        List<DHA_Class_Assignment__c> response;

        if(searchVal == null && birthDate == null && className == null){
            response = Database.query(queryString);
        } else{
            if(searchVal != null){
                conditions.add('DHA_Student__r.Name like \'%' + searchVal + '%\'');
            }

            if(birthDate != null){
                conditions.add('DHA_Student__r.Birthdate__c =: birthDate');
            }

            if(className != null){
                conditions.add('DHA_Class__r.Name=\'' + className + '\'');
            }

            queryString += ' where ';
            queryString += string.join(conditions, ' and ');
            System.debug(queryString);
            response = Database.query(queryString);
        }

        Map<String, DHA_Class_Assignment__c> studentsMap = new Map<String, DHA_Class_Assignment__c>();
        for(DHA_Class_Assignment__c item : response){
            studentsMap.put(item.DHA_Student__r.Student_Code__c, item);
        }

        return studentsMap.values();
    }

    @AuraEnabled
    public static List<DHA_Class__c> getClasses(){          
        List<DHA_Class__c> result = [
                select Name
                from DHA_Class__c
            ];
        
        return result;
    }

    @AuraEnabled
    public static List<DHA_Study_Result__c> getAssignmentsByStudentCode(String studentCode){
        List<DHA_Study_Result__c> result = [
            select DHA_Class_Assignment__r.DHA_Class__r.Name, Score_1__c, Score_2__c, Score_3__c, Final_Score__c, Result__c
            from DHA_Study_Result__c 
            where DHA_Class_Assignment__r.DHA_Student__r.Student_Code__c =: studentCode
            and Is_Lastest__c = true
        ];

        return result;
    }

    @AuraEnabled
    public static Integer getNumberOfAssignedClassByStudentId(String id){
        List<SObject> result = [
            select DHA_Student__r.Id, count(Name) countVal 
            from DHA_Class_Assignment__c 
            where DHA_Student__r.Id =: id
            group by DHA_Student__r.Id 
        ];

        return result.size() > 0 ?  (Integer)result[0].get('countVal') : 0;
    }
    
    @AuraEnabled
    public static Double getAvarageOfFinalResults(String id){
        List<SObject> result = [
            select DHA_Class_Assignment__r.DHA_Student__r.Id, avg(final_score__c) avgVal
            from DHA_Study_Result__c
            where DHA_Class_Assignment__r.DHA_Student__r.Id =: id and Is_Lastest__c = true
            group by DHA_Class_Assignment__r.DHA_Student__r.Id
        ];

        return result.size() > 0 ? ((Decimal)result[0].get('avgVal')).setScale(2) : 0;
    }

    @AuraEnabled
    public static Integer getNumberOfFinalScores(String id){
        List<SObject> result = [
            select DHA_Class_Assignment__r.DHA_Student__r.Id, count(DHA_Class_Assignment__r.Name) countVal
            from DHA_Study_Result__c
            where DHA_Study_Result__c.Final_Score__c != null and Is_Lastest__c = true
                and DHA_Class_Assignment__r.DHA_Student__r.Id =: id 
            group by DHA_Class_Assignment__r.DHA_Student__r.Id
        ];

        return result.size() > 0 ? (Integer)result[0].get('countVal') : 0;
    }
}