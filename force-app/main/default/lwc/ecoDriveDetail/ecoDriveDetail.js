import { LightningElement, wire } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import DRIVE_CHANNEL from '@salesforce/messageChannel/EcoDriveChannel__c';

export default class EcoDriveDetail extends LightningElement {
    selectedDriveId;
    @wire(MessageContext) messageContext;

    connectedCallback() {
        subscribe(this.messageContext, DRIVE_CHANNEL, (msg) => {
            if (msg.driveId) this.selectedDriveId = msg.driveId;
        });
    }
}