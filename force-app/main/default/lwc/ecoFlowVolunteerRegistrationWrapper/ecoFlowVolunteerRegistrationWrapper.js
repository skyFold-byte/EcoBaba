import { LightningElement, api } from 'lwc';

export default class EcoFlowVolunteerRegistrationWrapper extends LightningElement {
    @api headerTitle = 'Volunteer Registration';

    handleStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            console.log('User registered successfully!');
        }
    }
}