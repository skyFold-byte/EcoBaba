import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import USER_ID from '@salesforce/user/Id';
 
export default class EcoHero extends NavigationMixin(LightningElement) {
 
    trees = 0;
    volunteers = 0;
    drives = 0;
 
    targetTrees = 2450;
    targetVolunteers = 1120;
    targetDrives = 450;
 
    connectedCallback() {
        this.startCounter();
    }
 
    startCounter() {
        const interval = setInterval(() => {
 
            if (this.trees < this.targetTrees) {
                this.trees += 50;
            }
 
            if (this.volunteers < this.targetVolunteers) {
                this.volunteers += 25;
            }
 
            if (this.drives < this.targetDrives) {
                this.drives += 10;
            }
 
            if (
                this.trees >= this.targetTrees &&
                this.volunteers >= this.targetVolunteers &&
                this.drives >= this.targetDrives
            ) {
                clearInterval(interval);
            }
 
        }, 30);
    }
 
    navigateToDrives() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Drives__c'
            }
        });
    }
}