@isTest
public class DHA_StudentSearchController_Test {
    @TestSetup
    static void setup(){
        DHA_Student__c st1 = new DHA_Student__c(
                Name = 'nguyen hoai nhan',
                Birthdate__c = Date.newInstance(2001, 1, 18),
                Email__c = 'nhan.nguyenhoai@gmail.com',
                Address__c = 'Tay Ninh',
                Gender__c = 'Male'
        );
        DHA_Student__c st2 = new DHA_Student__c(
                Name = 'nguyen hoai bao',
                Birthdate__c = Date.newInstance(2001, 1, 19),
                Email__c = 'bao.nguyenhoai@gmail.com',
                Address__c = 'Tay Ninh',
                Gender__c = 'Male'
        );
        DHA_Student__c st3 =new DHA_Student__c(
                Name = 'nguyen hoai tien',
                Birthdate__c = Date.newInstance(2001, 1, 20),
                Email__c = 'tien.nguyenhoai@gmail.com',
                Address__c = 'Tay Ninh',
                Gender__c = 'Male'
        );
        DHA_Student__c st4 =new DHA_Student__c(
                Name = 'nguyen hoai thanh',
                Birthdate__c = Date.newInstance(2001, 1, 21),
                Email__c = 'thanh.nguyenhoai@gmail.com',
                Address__c = 'Tay Ninh',
                Gender__c = 'Male'
        );
        DHA_Student__c st5 =new DHA_Student__c(
                Name = 'nguyen hoai phong',
                Birthdate__c = Date.newInstance(2001, 1, 22),
                Email__c = 'phong.nguyenhoai@gmail.com',
                Address__c = 'Tay Ninh',
                Gender__c = 'Male'
        );

        List<DHA_Student__c> students = new List<DHA_Student__c>{st1, st2, st3, st4, st5};
        insert students;

        DHA_Class__c cl1 = new DHA_Class__c(
                Start_Date__c = Date.newInstance(2023, 3, 12),
                End_Date__c = Date.newInstance(2023, 10, 12)
        );
        DHA_Class__c cl2 = new DHA_Class__c(
                Start_Date__c = Date.newInstance(2023, 4, 12),
                End_Date__c = Date.newInstance(2023, 11, 12)
        );
        DHA_Class__c cl3 = new DHA_Class__c(
                Start_Date__c = Date.newInstance(2023, 5, 12),
                End_Date__c = Date.newInstance(2023, 12, 12)
        );
        DHA_Class__c cl4 = new DHA_Class__c(
                Start_Date__c = Date.newInstance(2023, 6, 12),
                End_Date__c = Date.newInstance(2024, 1, 12)
        );
        DHA_Class__c cl5 = new DHA_Class__c(
                Start_Date__c = Date.newInstance(2023, 7, 12),
                End_Date__c = Date.newInstance(2024, 2, 12)
        );
        List<DHA_Class__c> classes = new List<DHA_Class__c>{cl1, cl2, cl3, cl4, cl5};
        insert classes;

        DHA_Class_Assignment__c ass1 = new DHA_Class_Assignment__c(
            DHA_Class__c = cl1.Id,
            DHA_Student__c = st1.Id
        );
        DHA_Class_Assignment__c ass2 = new DHA_Class_Assignment__c(
            DHA_Class__c = cl1.Id,
            DHA_Student__c = st2.Id
        );
        DHA_Class_Assignment__c ass3 = new DHA_Class_Assignment__c(
            DHA_Class__c = cl1.Id,
            DHA_Student__c = st3.Id
        );
        DHA_Class_Assignment__c ass4 = new DHA_Class_Assignment__c(
            DHA_Class__c = cl1.Id,
            DHA_Student__c = st4.Id
        );
        DHA_Class_Assignment__c ass5 = new DHA_Class_Assignment__c(
            DHA_Class__c = cl1.Id,
            DHA_Student__c = st5.Id
        );
        List<DHA_Class_Assignment__c> assignments = new List<DHA_Class_Assignment__c>{ass1, ass2, ass3, ass4, ass5};
        insert assignments;
    }

    /**
     * function: getStudentsWithConditions(String searchVal, Date birthDate, String className) 
     * scenerio: (null, null, null)
     */
    @IsTest
    static void testCase1() {
        List<DHA_Class_Assignment__c> actualResult = DHA_StudentSearchController.getStudentsWithConditions(null, null, null);
        List<DHA_Class_Assignment__c> expectedResult = [
            select Id 
            from DHA_Class_Assignment__c
        ];

        System.assertEquals(
            expectedResult.size(), 
            actualResult.size(), 
            'Failed if there are no query conditions'
        );
    }

    /**
     * function: getStudentsWithConditions(String searchVal, Date birthDate, String className) 
     * scenerio: (data, null, null)
     */
    @IsTest
    static void testCase2() {
        List<DHA_Class_Assignment__c> actualResult = DHA_StudentSearchController.getStudentsWithConditions('nguyen hoai nhan', null, null);
        List<DHA_Student__c> expectedResult = [
            select Id 
            from DHA_Student__c 
            where Name = 'nguyen hoai nhan'
        ];

        System.assertEquals(
            expectedResult.size(), 
            actualResult.size(), 
            'Failed if only searchVal contains data'
        );
    }

    /**
     * function: getStudentsWithConditions(String searchVal, Date birthDate, String className) 
     * scenerio: (null, data, null)
     */
    @IsTest
    static void testCase3() {
        List<DHA_Class_Assignment__c> actualResult = DHA_StudentSearchController.getStudentsWithConditions(null, Date.newInstance(1998, 1, 12), null);
        List<DHA_Student__c> expectedResult = [
            select Id 
            from DHA_Student__c 
            where Birthdate__c = 1998-01-12
        ];

        System.assertEquals(
            expectedResult.size(),
            actualResult.size(), 
            'Failed if only birthdate contains data'
        );
    }

    /**
     * function: getStudentsWithConditions(String searchVal, Date birthDate, String className) 
     * scenerio: (null, null, data)
     */
    @IsTest
    static void testCase4() {
        List<DHA_Class_Assignment__c> actualResult = DHA_StudentSearchController.getStudentsWithConditions(null, null, 'C-0001');
        List<DHA_Class_Assignment__c> expectedResult = [
            select Id 
            from DHA_Class_Assignment__c 
            where DHA_Class__r.Name = 'C-0001'
        ];

        System.assertEquals(
            expectedResult.size(),
            actualResult.size(), 
            'Failed if only className contains data'
        );
    }

    /**
     * function: getStudentsWithConditions(String searchVal, Date birthDate, String className) 
     * scenerio: (data, data, null)
     */
    @IsTest
    static void testCase5() {
        List<DHA_Class_Assignment__c> actualResult = DHA_StudentSearchController.getStudentsWithConditions('nguyen hoai nhan', Date.newInstance(2001, 1, 18), null);
        List<DHA_Class_Assignment__c> expectedResult = [
            select Id 
            from DHA_Class_Assignment__c 
            where DHA_Student__r.Name = 'nguyen hoai nhan' 
                and DHA_Student__r.Birthdate__c = 2001-01-18
        ];

        System.assertEquals(
            expectedResult.size(),
            actualResult.size(), 
            'Failed if only searhVal and birthDate contain data'
        );
    }

    /**
     * function: getStudentsWithConditions(String searchVal, Date birthDate, String className) 
     * scenerio: (data, null, data)
     */
    @IsTest
    static void testCase6() {
        List<DHA_Class_Assignment__c> actualResult = DHA_StudentSearchController.getStudentsWithConditions('nguyen hoai nhan', null, 'C-0001');
        List<DHA_Class_Assignment__c> expectedResult = [
            select Id 
            from DHA_Class_Assignment__c 
            where DHA_Student__r.Name = 'nguyen hoai nhan' 
                and DHA_Class__r.Name = 'C-0001'
        ];

        System.assertEquals(
            expectedResult.size(),
            actualResult.size(), 
            'Failed if only searhVal and className contain data'
        );
    }

    /**
     * function: getStudentsWithConditions(String searchVal, Date birthDate, String className) 
     * scenerio: (null, data, data)
     */
    @IsTest
    static void testCase7() {
        List<DHA_Class_Assignment__c> actualResult = DHA_StudentSearchController.getStudentsWithConditions(null, Date.newInstance(2001, 1, 18), 'C-0001');
        List<DHA_Class_Assignment__c> expectedResult = [
            select Id 
            from DHA_Class_Assignment__c 
            where DHA_Student__r.Birthdate__c = 2001-01-18 
                and DHA_Class__r.Name = 'C-0001'
        ];

        System.assertEquals(
            expectedResult.size(),
            actualResult.size(), 
            'Failed if only birthDate and className contain data'
        );
    }

    /**
     * function: getStudentsWithConditions(String searchVal, Date birthDate, String className) 
     * scenerio: (data, data, data)
     */
    @IsTest
    static void testCase8() {
        List<DHA_Class_Assignment__c> actualResult = DHA_StudentSearchController.getStudentsWithConditions('nguyen hoai nhan', Date.newInstance(2001, 1, 18), 'C-0001');
        List<DHA_Class_Assignment__c> expectedResult = [
            select Id 
            from DHA_Class_Assignment__c 
            where DHA_Student__r.Name = 'nguyen hoai nhan' 
                and DHA_Student__r.Birthdate__c = 2001-01-18 
                and DHA_Class__r.Name = 'C-0001'
        ];

        System.assertEquals(
            expectedResult.size(),
            actualResult.size(), 
            'Failed if searchVal, birthDate and className contain data'
        );
    }
}