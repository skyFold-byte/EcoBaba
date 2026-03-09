import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getVolunteerName from '@salesforce/apex/VolunteerWelcomeController.getVolunteerName';
import getDashboardStats from '@salesforce/apex/EcoDashboardController.getDashboardStats';

export default class EcoHero extends NavigationMixin(LightningElement) {
    name = 'Volunteer';
    volunteers = 0;
    drives = 0;
    
    // Detect if we are in the Builder to prevent crashes
    get isBuilder() {
        return window.location.href.includes('builder');
    }

    @wire(getVolunteerName) wiredName({ data }) {
        if (data) this.name = data;
    }

    @wire(getDashboardStats) wiredStats({ error, data }) {
        if (!this.isBuilder && data) {
            this.targets = {
                volunteers: data.totalVolunteers || 0,
                drives: data.totalDrives || 0
            };
            this.startCounter();
        }
    }

    connectedCallback() {
        // The problematic call to 'initializeAdvancedFeatures' is removed.
    }

    startCounter() {
        const duration = 2000;
        const startTime = performance.now();
        const animate = (now) => {
            const progress = Math.min((now - startTime) / duration, 1);
            this.volunteers = Math.floor(progress * this.targets.volunteers);
            this.drives = Math.floor(progress * this.targets.drives);
            if (progress < 1) requestAnimationFrame(animate);
        };
        requestAnimationFrame(animate);
    }

    navigateToDrives() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: { name: 'drive_cards__c' }
        });
    }
}