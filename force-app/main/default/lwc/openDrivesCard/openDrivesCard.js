import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getOpenDrives from '@salesforce/apex/EcoDriveController.getOpenDrives';

export default class OpenDrivesCard extends NavigationMixin(NavigationMixin(LightningElement)) {
    drives;

    @wire(getOpenDrives)
    wired({ error, data }) {
        if (data) this.drives = data;
        else if (error) console.error(error);
    }

    handleRegister(e) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: e.target.dataset.id,
                objectApiName: 'Eco_Drive__c',
                actionName: 'view'
            }
        });
    }
}