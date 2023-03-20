public with sharing class DHA_Student_Trigger_Handler {
    public static void onBeforeInsert(List<DHA_Student__c> newRecords) {
        for(DHA_Student__c student : newRecords){
            if(student.Name.trim().length() < 3){
                student.Name.addError('This student name is too short.');
                return;
            }

            if(student.Birthdate__c < Date.newInstance(1990, 01, 01)){
                student.Name.addError('This student birthdate is invalid. Birthdate should be after 1990/01/01');
                return;
            }

            if(student.Birthdate__c.daysBetween(date.today()) < 365 * 6){
                student.Name.addError('This student age is not enough to attend our classes.');
                return;
            }
        }
    }

	public static void onAfterInsert(List<DHA_Student__c> newRecords) {
        return;
    }

	public static void onBeforeUpdate(Map<Id, DHA_Student__c> newRecordMap, Map<Id, DHA_Student__c> oldRecordMap) {
        for(String key : newRecordMap.keySet()){
            DHA_Student__c student = newRecordMap.get(key);
            if(student.Name.trim().length() < 3){
                student.Name.addError('This student name is too short.');
                return;
            }

            if(student.Birthdate__c < Date.newInstance(1990, 01, 01)){
                student.Name.addError('This student birthdate is invalid. Birthdate should be after 1990/01/01');
                return;
            }

            if(student.Birthdate__c.daysBetween(date.today()) < 365 * 6){
                student.Name.addError('This student age is not enough to attend our classes.');
                return;
            }
        }
	}

	public static void onAfterUpdate(Map<Id, DHA_Student__c> newRecordMap, Map<Id, DHA_Student__c> oldRecordMap) {
        return;
	}
}