import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import IS_GUEST from '@salesforce/user/isGuest';

export default class EcoNavbar extends NavigationMixin(LightningElement) {
    
    get isLoggedIn() {
        return !IS_GUEST;
    }

    // We keep handleJoin because login pages often require 
    // specific parameters handled best by the Mixin
    // handleJoin() {
    //     this[NavigationMixin.Navigate]({
    //         type: 'comm__loginPage',
    //         attributes: { actionName: 'login' }
    //     });
    // }
}