import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getPrograms from '@salesforce/apex/EcoDriveController.getPrograms';

const COLUMNS = [
    { label: 'Program Name', fieldName: 'Name', type: 'text' },
    { label: 'Status', fieldName: 'Status__c', type: 'text' },
    {
        type: 'button',
        typeAttributes: {
            label: 'View Dashboard',
            name: 'view_details',
            variant: 'brand'
        }
    }
];

export default class EcoProgramList extends NavigationMixin(LightningElement) {
    columns = COLUMNS;

    @wire(getPrograms) programs;

    handleRowAction(event) {
        if (event.detail.action.name === 'view_details') {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.detail.row.Id,
                    actionName: 'view'
                }
            });
        }
    }
}