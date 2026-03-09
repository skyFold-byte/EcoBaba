import { LightningElement, wire } from 'lwc';
import getDashboardStats from '@salesforce/apex/EcoDashboardController.getDashboardStats';

export default class EcoDashboard extends LightningElement {
    stats = {};

    @wire(getDashboardStats)
    wiredStats({ error, data }) {
        if (data) this.stats = data;
        else if (error) console.error(error);
    }

    // Creates an array for the loop to keep HTML clean
    get statsArray() {
        return [
            { label: 'Total Drives', value: this.stats.totalDrives || 0 },
            { label: 'Active Drives', value: this.stats.activeDrives || 0 },
            { label: 'Volunteers', value: this.stats.totalVolunteers || 0 },
            { label: 'Participations', value: this.stats.totalParticipations || 0 }
        ];
    }
}