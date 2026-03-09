import { LightningElement, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import DRIVE_CHANNEL from '@salesforce/messageChannel/EcoDriveChannel__c';

export default class EcoDriveFilter extends LightningElement {
    @wire(MessageContext) messageContext;
    
    // Unified state object
    filters = { name: '', city: '', state: '' };

    handleInputChange(event) {
        // Dynamic assignment based on 'name' attribute
        this.filters = { ...this.filters, [event.target.name]: event.target.value };
        publish(this.messageContext, DRIVE_CHANNEL, { filters: this.filters });
    }
}