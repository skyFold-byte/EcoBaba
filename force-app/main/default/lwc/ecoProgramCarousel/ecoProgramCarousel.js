import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getPrograms from '@salesforce/apex/EcoProgramController.getPrograms';

export default class EcoProgramCarousel extends NavigationMixin(LightningElement) {
    @track status = 'Active'; 

    // Wire the Apex method to fetch programs based on status
    @wire(getPrograms, { status: '$status' }) 
    programs;

    // Options for the status filter combobox
    get options() {
        return [
            { label: 'Planned', value: 'Planned' },
            { label: 'Active', value: 'Active' },
            { label: 'Completed', value: 'Completed' }
        ];
    }

    // Handles the change event from the combobox filter
    handleStatusChange(event) {
        this.status = event.detail.value;
    }

    // Logical check to see if programs were returned
    get hasPrograms() {
        return this.programs.data && this.programs.data.length > 0;
    }

    /**
     * Navigates to the program drives page.
     * Note: 'Program_Drives_Page__c' must match the API Name in Page Properties.
     */
    handleNavigate(event) {
        // Accessing the data-id from the target or currentTarget depending on click depth
        const programId = event.target.dataset.id || event.currentTarget.dataset.id;
        
        if (programId) {
            this[NavigationMixin.Navigate]({
                type: 'comm__namedPage',
                attributes: {
                    // Check Experience Builder -> Page Properties -> API Name
                    // It often adds __c to the name you provided
                    name: 'Program_Drives_Page__c' 
                },
                state: {
                    programId: programId
                }
            });
        } else {
            console.error('Navigation failed: programId not found in dataset.');
        }
    }
}