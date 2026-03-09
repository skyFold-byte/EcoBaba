import { LightningElement } from 'lwc';
import forgotPassword from '@salesforce/apex/EcoAuthController.forgotPassword';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class EcoForgotPassword extends LightningElement {
    identifier = '';

    handleInput(e) { this.identifier = e.target.value; }

    async handleReset() {
        if (!this.identifier) {
            this.showToast('Error', 'Please enter your email or phone.', 'error');
            return;
        }

        try {
            await forgotPassword({ identifier: this.identifier });
            this.showToast('Success', 'Check your email for the reset link.', 'success');
        } catch (e) {
            this.showToast('Error', 'Could not send reset email. Please try again.', 'error');
        }
    }

    showToast(t, m, v) {
        this.dispatchEvent(new ShowToastEvent({ title: t, message: m, variant: v }));
    }
}