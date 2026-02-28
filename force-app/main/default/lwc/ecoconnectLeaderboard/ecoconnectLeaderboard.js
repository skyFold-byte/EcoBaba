import { LightningElement, wire, api } from 'lwc';
import getTopVolunteers from '@salesforce/apex/EcoConnectLeaderboardController.getTopVolunteers';
 
export default class EcoconnectLeaderboard extends LightningElement {
 
    @api limitSize = 5;
    volunteers = [];
 
    @wire(getTopVolunteers, { limitSize: '$limitSize' })
    wiredVolunteers({ data, error }) {
        if (data) {
            this.volunteers = data.map((vol, index) => {
                return {
                    ...vol,
                    rank: index + 1
                };
            });
        } else if (error) {
            console.error(error);
        }
    }
}