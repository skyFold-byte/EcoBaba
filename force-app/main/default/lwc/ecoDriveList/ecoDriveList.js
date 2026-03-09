import { LightningElement, wire, api } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import DRIVE_CHANNEL from '@salesforce/messageChannel/EcoDriveChannel__c';
import getDrives from '@salesforce/apex/EcoDriveController.getDrives';

export default class EcoDriveList extends LightningElement {
    @api recordId;
    filters = {}; // Initialized empty; wire handles undefined properties gracefully

    @wire(MessageContext) messageContext;

    // Reactive wire: refreshes automatically when recordId or filters change
    @wire(getDrives, { 
        programId: '$recordId', 
        name: '$filters.name', 
        city: '$filters.city', 
        state: '$filters.state' 
    })
    drives;

    connectedCallback() {
        // Direct subscription without extra method overhead
        subscribe(this.messageContext, DRIVE_CHANNEL, (msg) => {
            if (msg.filters) this.filters = { ...msg.filters };
        });
    }

    handleSelect(event) {
        // Dispatches the ID for any listener on the page
        const driveId = event.currentTarget.dataset.id;
        this.dispatchEvent(new CustomEvent('selection', { detail: driveId }));
    }

    get hasResults() {
        return this.drives?.data?.length > 0;
    }
}