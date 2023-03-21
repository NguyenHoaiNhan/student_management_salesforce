public with sharing class DHA_Class_Assignment_Trigger_Handler {
    public static DHA_Management_Setting__c getCustomSettings(){
        return DHA_Management_Setting__c.getInstance(UserInfo.getUserId());
    }

    public static void onBeforeInsert(List<DHA_Class_Assignment__c> newRecords){
        for(DHA_Class_Assignment__c item : newRecords){
            Integer currentAssignNum =  DHA_StudentSearchController.getNumberOfAssignedClassByStudentId(item.DHA_Student__c);

            if(currentAssignNum > getCustomSettings().Max_Assigned_Classes__c){
                item.DHA_Student__c.addError('This student is attending to too much class.');
                return;
            }
        }
    }

    public static void onAfterInsert(List<DHA_Class_Assignment__c> newRecords){
        for(DHA_Class_Assignment__c item : newRecords){
            List<SObject> assignmentData = [
                select dha_class__c, count(dha_student__r.Id) countVal
                from dha_class_assignment__c
                where dha_class__c =: item.DHA_Class__c
                group by dha_class__c
            ];
            Decimal currentClassMember = (Double)assignmentData[0].get('countVal');

            if(currentClassMember > getCustomSettings().Max_Students_In_Class__c){
                item.DHA_Student__c.addError('There is no seat to join this class.');
                return;
            }

            DHA_Study_Result__c lastestResult = new DHA_Study_Result__c(
                DHA_Class_Assignment__c = item.Id,
                Is_Lastest__c = true
            );
            insert lastestResult;
        }
    }

    public static void onBeforeUpdate(Map<Id, DHA_Class_Assignment__c> newRecordMap, Map<Id, DHA_Class_Assignment__c> oldRecordMap){
        for(String key : newRecordMap.keySet()){
            DHA_Class_Assignment__c assignment = newRecordMap.get(key);
            Integer currentAssignNum =  DHA_StudentSearchController.getNumberOfAssignedClassByStudentId(assignment.DHA_Student__c);

            if(currentAssignNum > getCustomSettings().Max_Assigned_Classes__c){
                assignment.DHA_Student__c.addError('This student is attending to too much class.');
                return; 
            }
        }
    }

    public static void onAfterUpdate(Map<Id, DHA_Class_Assignment__c> newRecordMap, Map<Id, DHA_Class_Assignment__c> oldRecordMap){
        for(String key : newRecordMap.keySet()){
            DHA_Class_Assignment__c assignment = newRecordMap.get(key);
            List<SObject> assignmentData = [
                select dha_class__c, count(dha_student__r.Id) countVal
                from dha_class_assignment__c
                where dha_class__c =: assignment.DHA_Class__c
                group by dha_class__c
            ];
            Decimal currentClassMember = (Double)assignmentData[0].get('countVal');

            if(currentClassMember > getCustomSettings().Max_Students_In_Class__c){
                assignment.DHA_Student__c.addError('There is no seat to join this class.');
                return;
            }
        }
    }
}