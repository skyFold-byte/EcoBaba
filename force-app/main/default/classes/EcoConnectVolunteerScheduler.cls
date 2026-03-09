global class EcoConnectVolunteerScheduler
implements Schedulable {
 
    global void execute(SchedulableContext sc) {
 
        EcoConnectVolunteerPointsBatch batch =
            new EcoConnectVolunteerPointsBatch();
 
        Database.executeBatch(batch, 200);
    }
}