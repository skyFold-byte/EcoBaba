import { LightningElement, api } from 'lwc';

export default class EcoFlowRaiseIssueWrapper extends LightningElement {
    @api headerTitle = 'Report an Environmental Issue';

    handleStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            // Add a small delay or custom success message if needed
            console.log('User successfully reported an issue!');
        }
    }
}