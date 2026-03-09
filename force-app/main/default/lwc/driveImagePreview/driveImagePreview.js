import { LightningElement, api, wire } from 'lwc';
import getDriveImageUrl from '@salesforce/apex/DriveImageController.getDriveImageUrl';
 
export default class DriveImagePreview extends LightningElement {
 
    @api recordId;
    imageUrl;
 
    @wire(getDriveImageUrl, { driveId: '$recordId' })
    wiredImage({ data, error }) {
        if (data) {
            this.imageUrl = data;
        } else {
            this.imageUrl = null;
        }
    }
}