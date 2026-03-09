import { LightningElement } from 'lwc';

export default class EcoLogout extends LightningElement {
    handleLogout() {
        // This is the standard Salesforce URL for logging out of a site
        window.location.href = '/secur/logout.jsp';
    }
}