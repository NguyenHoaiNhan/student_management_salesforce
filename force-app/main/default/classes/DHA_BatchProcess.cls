public with sharing class DHA_BatchProcess implements Database.Batchable<SObject>, Database.stateful {
    private Integer numOfUpdated = 0;

    public Database.QueryLocator start(Database.BatchableContext bc){
        Decimal defaultPassScore = DHA_Management_Setting__c.getInstance(UserInfo.getUserId()).Pass_Score__c;
        
        String queryString = 'select Name, Result__c from DHA_Study_Result__c where Is_Lastest__c = true and Final_Score__c > :defaultPassScore';

        return Database.getQueryLocator(queryString);
    }

    public void execute(Database.BatchableContext bc, List<DHA_Study_Result__c> records){
        if(!records.isEmpty()){
            for(DHA_Study_Result__c result : records){
                result.Result__c = 'Passed';
                numOfUpdated += 1;
            }
            update records;
        }
    }

    public void finish(Database.BatchableContext bc){
        system.debug(
            string.format(
                'There are {0} updated study result(s) in the batch process.', 
                new string[]{string.valueOf(numOfUpdated)}
            )
        );
    }
}