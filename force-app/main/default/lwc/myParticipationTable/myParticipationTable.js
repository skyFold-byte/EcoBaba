import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getMyParticipations from '@salesforce/apex/DriveParticipationController.getMyParticipations';

const COLUMNS = [
    {
        label: 'Participation ID',
        fieldName: 'participationUrl',
        type: 'url',
        initialWidth: 140,
        typeAttributes: {
            label: { fieldName: 'participationName' },
            target: '_self'
        },
        cellAttributes: { 
            class: 'font-weight-bold',
            iconName: 'utility:Tower' // Adds a small icon next to the ID
        }
    },
    { label: 'Drive Name', fieldName: 'driveName' },
    { label: 'Date', fieldName: 'driveDate', type: 'date', 
      typeAttributes: { month: 'short', day: '2-digit', year: 'numeric' } 
    },
    { label: 'Time', fieldName: 'driveTime', cellAttributes: { iconName: 'utility:event' } },
    { label: 'Venue', fieldName: 'venue' },
    { 
        label: 'Status', 
        fieldName: 'attendance',
        cellAttributes: {
            class: { fieldName: 'statusClass' } // Dynamic coloring (Green for Attended, etc.)
        }
    },
    { label: 'Hours', fieldName: 'hours', type: 'number', initialWidth: 80 }
];

export default class MyParticipationTable extends NavigationMixin(LightningElement) {
    participations = [];
    columns = COLUMNS;

    get participationCount() {
        return this.participations.length;
    }

    @wire(getMyParticipations)
    async wiredData({ data, error }) {
        if (data) {
            this.participations = await Promise.all(data.map(async (item) => {
                const rec = item.participation;

                const url = await this[NavigationMixin.GenerateUrl]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: rec.Id,
                        objectApiName: 'Drive_Participation__c',
                        actionName: 'view'
                    }
                });

                return {
                    Id: rec.Id,
                    participationName: rec.Name,
                    participationUrl: url,
                    driveName: rec.EcoDrive__r?.Name,
                    driveDate: rec.EcoDrive__r?.Start_Date__c,
                    driveTime: item.formattedStartTime,
                    venue: `${rec.EcoDrive__r?.City__c || ''}, ${rec.EcoDrive__r?.State__c || ''}`,
                    attendance: rec.Attendance_Status__c,
                    hours: rec.Hours_Contributed__c || 0,
                    // Brand coloring logic for the Status column
                    statusClass: rec.Attendance_Status__c === 'Attended' ? 'status-green' : 'status-grey'
                };
            }));
        }
    }
}