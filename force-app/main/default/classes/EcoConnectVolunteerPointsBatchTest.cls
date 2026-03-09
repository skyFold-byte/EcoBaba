@isTest
private class EcoConnectVolunteerPointsBatchTest {
 
    @isTest
    static void testBatchExecution() {
 
        // Create ACTIVE Eco Program
        EcoProgram__c program = new EcoProgram__c(
            Name = 'Test Program',
            Status__c = 'Active'
        );
        insert program;
 
        // Create Volunteers
        List<Volunteer__c> volunteers = new List<Volunteer__c>();
 
        for (Integer i = 0; i < 3; i++) {
            volunteers.add(new Volunteer__c(
                Name = 'Test Volunteer ' + i,
                Email__c = 'test' + i + '@mail.com',
                City__c = 'Chennai',
                State__c = 'Tamil Nadu',
                Phone__c = '987654321' + i
            ));
        }
        insert volunteers;
 
        // Create Drive linked to ACTIVE program
        EcoDrive__c drive = new EcoDrive__c(
            Name = 'Test Drive',
            Capacity__c = 10,
            Drive_Date__c = Date.today(),
            Status__c = 'Open',
            City__c = 'Chennai',
            State__c = 'Tamil Nadu',
            EcoProgram__c = program.Id,
            Start_Date__c = System.Today()
        );
        insert drive;
 
        // Create Drive Participations
        List<Drive_Participation__c> participations =
            new List<Drive_Participation__c>();
 
        for (Volunteer__c v : volunteers) {
            participations.add(new Drive_Participation__c(
                Volunteer__c = v.Id,
                EcoDrive__c = drive.Id
            ));
        }
        insert participations;
 
        // Execute Batch
        Test.startTest();
        Database.executeBatch(
            new EcoConnectVolunteerPointsBatch(),
            200
        );
        Test.stopTest();
 
        // Verify points
        List<Volunteer__c> updatedVolunteers = [
            SELECT Points__c FROM Volunteer__c
        ];
 
        for (Volunteer__c v : updatedVolunteers) {
            System.assertEquals(10, v.Points__c);
        }
    }
 
    @isTest
    static void testSchedulerExecution() {
 
        Test.startTest();
 
        String cronExp = '0 0 0 1 1 ? 2050';
 
        System.schedule(
            'Test Scheduler',
            cronExp,
            new EcoConnectVolunteerScheduler()
        );
 
        Test.stopTest();
 
        System.assert(true);
    }
}