import { LightningElement, wire } from 'lwc';
import getOpenDrives from '@salesforce/apex/EcoDriveController.getOpenDrives';
 
export default class OpenDrivesCard extends LightningElement {
 
    drives = [];
 
    @wire(getOpenDrives)
    wiredDrives({ error, data }) {
        if (data) {
            this.drives = data.map(drive => {
                return {
                    id: drive.Id,
                    name: drive.Name,
                    venue: this.formatVenue(drive.City__c, drive.State__c),
                    date: drive.Start_Date__c,
                    time: drive.Start_Time__c,
                    joined: drive.Total_Participants__c,
                    spotsLeft: drive.Remaining_Slots__c,
                    isFull: drive.Remaining_Slots__c === 0,
                    spotsClass: drive.Remaining_Slots__c <= 5
                        ? 'spots danger'
                        : 'spots'
                };
            });
        } else if (error) {
            console.error(error);
        }
    }
 
    formatVenue(city, state) {
        if (city && state) return city + ', ' + state;
        return city || state || '';
    }
 
    handleRegister(event) {
        const driveId = event.target.dataset.id;
        window.location.href = '/detail/' + driveId;
    }
}