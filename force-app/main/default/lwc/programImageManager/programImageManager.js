import { LightningElement, api, wire } from 'lwc';
import getProgramImage from '@salesforce/apex/ProgramImageController.getProgramImage';
import generatePublicImageUrl from '@salesforce/apex/ProgramImageController.generatePublicImageUrl';
import { refreshApex } from '@salesforce/apex';

export default class ProgramImageManager extends LightningElement {
    @api recordId;
    imageUrl;
    wiredResult;

    @wire(getProgramImage, { recordId: '$recordId' })
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