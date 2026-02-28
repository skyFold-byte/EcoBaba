import { LightningElement, wire } from 'lwc';
import getDashboardStats from '@salesforce/apex/EcoDashboardController.getDashboardStats';
 
export default class EcoDashboard extends LightningElement {
 
    stats = {};
 
    @wire(getDashboardStats)
    wiredStats({ error, data }) {
        if (data) {
            this.stats = data;
        } else if (error) {
            console.error(error);
        }
    }
}