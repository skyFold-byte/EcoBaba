import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import getActionDrives from '@salesforce/apex/EcoConnectController.getActionDrives';

export default class EcoProgramExplorer extends NavigationMixin(LightningElement) {
    @track programmeId; // Matches the key in your working URL
    @track drives = [];

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference && currentPageReference.state) {
            // Updated to 'programmeId' to match your working detail page
            this.programmeId = currentPageReference.state.programmeId;
        }
    }

    @wire(getActionDrives, { programmeId: '$programmeId' })
    wiredDrives({ error, data }) {
        if (data) {
            this.drives = data;
        } else if (error) {
            console.error('Error loading drives:', error);
        }
    }

    get driveCount() {
        return this.drives ? this.drives.length : 0;
    }

    // Navigates directly to the Action Drive record page as per your working logic
    handleJoinClick(event) {
        const selectedDriveId = event.currentTarget.dataset.id;
        if (selectedDriveId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: `/environmentcare/s/detail/${selectedDriveId}`
                }
            });
        }
    }
}