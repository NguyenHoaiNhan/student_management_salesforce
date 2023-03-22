@isTest
public class DHA_Students_Controller_Test {
    @TestSetup
    static void setup(){
        return;
    }

    /**
     * function: findDuplicatedRecords(String name, Date birthdate, String address, String gender, String email)
     * scenerio: email is null, the others are required
     */
    @IsTest
    static void testCase1() {
        List<DHA_Student__c> actualResult = DHA_StudentsController.findDuplicatedRecords(
            'nguyen hoai nhan',
            Date.newInstance(2001, 1, 18),
            'Tay Ninh',
            'Male',
            null
        );
        List<DHA_Student__c> expectedResult = [
            select Id
            from 
        ];
    }
}