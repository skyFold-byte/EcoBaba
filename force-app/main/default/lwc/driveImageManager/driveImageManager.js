import { LightningElement, api, wire } from 'lwc';
import getDriveImageUrl from '@salesforce/apex/DriveImageController.getDriveImageUrl';
import makeFilePublic from '@salesforce/apex/DriveImageController.makeFilePublic';
import { refreshApex } from '@salesforce/apex';
 
export default class DriveImageManager extends LightningElement {
 
    @api recordId;
    imageUrl;
    wiredResult;
 
    @wire(getDriveImageUrl, { recordId: '$recordId' })
    wiredImage(result) {
        this.wiredResult = result;
        this.imageUrl = result.data;
    }
 
    handleUploadFinished() {
 
        makeFilePublic({ recordId: this.recordId })
            .then(() => refreshApex(this.wiredResult))
            .catch(error => console.error(error));
    }
}