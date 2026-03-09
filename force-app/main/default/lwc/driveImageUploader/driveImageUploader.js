import { LightningElement, api, wire, track } from 'lwc';
import hasDriveImage from '@salesforce/apex/DriveImageController.hasDriveImage';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
 
export default class DriveImageUpload extends LightningElement {
 
    @api recordId;
    @track disableUpload = false;
 
    @wire(hasDriveImage, { driveId: '$recordId' })
    wiredImage({ data, error }) {
        if (data === true) {
            this.disableUpload = true;
        } else {
            this.disableUpload = false;
        }
    }
 
    handleUploadFinished(event) {
        this.disableUpload = true;
 
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Image uploaded successfully',
                variant: 'success'
            })
        );
    }
}