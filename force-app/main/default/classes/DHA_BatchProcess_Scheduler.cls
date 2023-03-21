public with sharing class DHA_BatchProcess_Scheduler implements Schedulable{
    public void execute(SchedulableContext sc){
        Id batchJobId = Database.executeBatch(new DHA_BatchProcess(), 10);
        system.debug('===> Run BatchJob <===' + ' with ID: ' + batchJobId);
    }
}