global class EcoConnectVolunteerPointsBatch
implements Database.Batchable<SObject> {
 
    global Database.QueryLocator start(Database.BatchableContext bc) {
 
        return Database.getQueryLocator([
            SELECT Id
            FROM Volunteer__c
        ]);
    }
 
    global void execute(Database.BatchableContext bc,
                        List<Volunteer__c> scope) {
 
        Set<Id> volunteerIds = new Set<Id>();
        for (Volunteer__c v : scope) {
            volunteerIds.add(v.Id);
        }
 
        // Aggregate participations per volunteer
        Map<Id, Integer> participationCountMap = new Map<Id, Integer>();
 
        for (AggregateResult ar : [
            SELECT Volunteer__c vId, COUNT(Id) totalCount
            FROM Drive_Participation__c
            WHERE Volunteer__c IN :volunteerIds
            GROUP BY Volunteer__c
        ]) {
            participationCountMap.put(
                (Id) ar.get('vId'),
                (Integer) ar.get('totalCount')
            );
        }
 
        // Update points only (Roll-up field handles count)
        for (Volunteer__c v : scope) {
 
            Integer count = participationCountMap.containsKey(v.Id)
                ? participationCountMap.get(v.Id)
                : 0;
 
            v.Points__c = count * 10; // 10 points per drive
        }
 
        update scope;
    }
 
    global void finish(Database.BatchableContext bc) {
        System.debug('EcoConnect Volunteer Points Recalculated Successfully');
    }
}