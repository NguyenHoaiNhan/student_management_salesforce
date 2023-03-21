public with sharing class DHA_Study_Result_Trigger_Handler {
    public static DHA_Management_Setting__c getCustomSettings(){
        return DHA_Management_Setting__c.getInstance(UserInfo.getUserId());
    }

    public static Boolean isUpdating = false;

    public static void onBeforeInsert(List<DHA_Study_Result__c> newRecords){
        Decimal defaultScoreToPass = getCustomSettings().Pass_Score__c;
        for(DHA_Study_Result__c item : newRecords){
            if(item.Result__c == 'Passed' && item.Final_Score__c < defaultScoreToPass){
                item.Result__c.addError(string.format('Cannot create this result because Final Score is less than {0}', new string[]{string.valueOf(defaultScoreToPass)}));
                return;
            }

            item.Is_Lastest__c = true;
            List<DHA_Study_Result__c> lastestResult = [
                select Is_Lastest__c
                from DHA_Study_Result__c
                where DHA_Class_Assignment__c =: item.DHA_Class_Assignment__c and Id !=: item.Id and Is_Lastest__c = true
            ];

            if(!lastestResult.isEmpty()){
                for(DHA_Study_Result__c resultToUpdate : lastestResult){
                    resultToUpdate.Is_Lastest__c = false;
                    system.debug(resultToUpdate + ' - ' + resultToUpdate.Is_Lastest__c);
                }
                isUpdating = true;
                update lastestResult;
            }
        }
    }

    public static void onAfterInsert(List<DHA_Study_Result__c> newRecords){
        return;
    }

    public static void onBeforeUpdate(Map<Id, DHA_Study_Result__c> newRecordMap, Map<Id, DHA_Study_Result__c> oldRecordMap){
        if(isUpdating){
            return;
        }

        Decimal defaultScoreToPass = getCustomSettings().Pass_Score__c;
        for(String key : newRecordMap.keySet()){
            DHA_Study_Result__c result = newRecordMap.get(key);
            
            if(result.Result__c == 'Passed' && result.Final_Score__c < defaultScoreToPass){
                result.Result__c.addError(string.format('Cannot update this result because Final Score is less than {0}', new string[]{string.valueOf(defaultScoreToPass)}));
                return;
            }

            result.Is_Lastest__c = true;

            List<DHA_Study_Result__c> lastestResult = [
                select Is_Lastest__c
                from DHA_Study_Result__c
                where DHA_Class_Assignment__c =: result.DHA_Class_Assignment__c and Id !=: result.Id and Is_Lastest__c = true
            ];

            if(!lastestResult.isEmpty()){
                for(DHA_Study_Result__c resultToUpdate : lastestResult){
                    resultToUpdate.Is_Lastest__c = false;
                    system.debug(resultToUpdate + ' - ' + resultToUpdate.Is_Lastest__c);
                }
                isUpdating = true;
                update lastestResult;
            }
        }
    }

    public static void onAfterUpdate(Map<Id, DHA_Study_Result__c> newRecordMap, Map<Id, DHA_Study_Result__c> oldRecordMap){
        return;
    }
}