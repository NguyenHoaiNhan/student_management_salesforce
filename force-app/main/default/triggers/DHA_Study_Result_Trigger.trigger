trigger DHA_Study_Result_Trigger on DHA_Study_Result__c (before insert, after insert, before update, after update) {
        switch on Trigger.operationType {
            when BEFORE_INSERT {
                DHA_Study_Result_Trigger_Handler.onBeforeInsert(Trigger.new);
            }
            when AFTER_INSERT {
                DHA_Study_Result_Trigger_Handler.onAfterInsert(Trigger.new);
            }
            when BEFORE_UPDATE {
                DHA_Study_Result_Trigger_Handler.onBeforeUpdate(Trigger.newMap, Trigger.oldMap);
            }
            when AFTER_UPDATE {
                DHA_Study_Result_Trigger_Handler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
            }
    }
}