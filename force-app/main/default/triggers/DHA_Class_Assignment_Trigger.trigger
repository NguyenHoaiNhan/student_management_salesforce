trigger DHA_Class_Assignment_Trigger on DHA_Class_Assignment__c (before insert, before update, after insert, after update) {
        switch on Trigger.operationType {
        when BEFORE_INSERT {
            DHA_Class_Assignment_Trigger_Handler.onBeforeInsert(Trigger.new);
        }
        when AFTER_INSERT {
            DHA_Class_Assignment_Trigger_Handler.onAfterInsert(Trigger.new);
        }
        when BEFORE_UPDATE {
            DHA_Class_Assignment_Trigger_Handler.onBeforeUpdate(Trigger.newMap, Trigger.oldMap);
        }
        when AFTER_UPDATE {
            DHA_Class_Assignment_Trigger_Handler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
        }
    }
}