import { LightningElement, api, wire } from 'lwc';
import getDriveImage from '@salesforce/apex/DriveImageController.getDriveImage';
import generatePublicImageUrl from '@salesforce/apex/DriveImageController.generatePublicImageUrl';
import { refreshApex } from '@salesforce/apex';

export default class DriveImageManager extends LightningElement {
    @api recordId;
    imageUrl;
    wiredResult;

    @wire(getDriveImage, { recordId: '$recordId' })
    wiredImage(result) {
        this.wiredResult = result;
        if (result.data) this.imageUrl = result.data;
    }

    handleUploadFinished(event) {
        const documentId = event.detail.files[0].documentId;
        generatePublicImageUrl({ driveId: this.recordId, documentId: documentId })
            .then(() => refreshApex(this.wiredResult))
            .catch(error => console.error('Upload Error:', error));
    }
}