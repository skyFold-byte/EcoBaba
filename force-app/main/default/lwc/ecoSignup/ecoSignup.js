import { LightningElement, track } from 'lwc';
import registerUser from '@salesforce/apex/EcoAuthController.registerUser';
import loginUser from '@salesforce/apex/EcoAuthController.loginUser';

export default class EcoSignup extends LightningElement {
    @track fName = ''; @track lName = ''; @track email = '';
    @track password = ''; @track errorMessage = '';
    @track isLoginMode = true;
    @track isLoading = false;
    
    // Password visibility state
    @track passwordType = 'password';
    @track passwordIcon = 'utility:preview';

    get isRegistering() { return !this.isLoginMode; }
    get formTitle() { return this.isLoginMode ? 'Log In' : 'Create Account'; }
    get buttonLabel() { return this.isLoginMode ? 'Sign In' : 'Register'; }
    get toggleText() { return this.isLoginMode ? "New here? Create an account" : "Already have an account? Log in"; }

    togglePasswordVisibility() {
        this.passwordType = this.passwordType === 'password' ? 'text' : 'password';
        this.passwordIcon = this.passwordType === 'password' ? 'utility:preview' : 'utility:hide';
    }

    handleInput(event) { this[event.target.name] = event.target.value; }
    toggleForm() { this.isLoginMode = !this.isLoginMode; this.errorMessage = ''; }

    async handleSubmit() {
        this.isLoading = true;
        try {
            if (this.isLoginMode) {
                const startUrl = await loginUser({ username: this.email, password: this.password });
                window.location.href = startUrl;
            } else {
                await registerUser({ fName: this.fName, lName: this.lName, email: this.email, password: this.password });
                const startUrl = await loginUser({ username: this.email, password: this.password });
                window.location.href = startUrl;
            }
        } catch (error) {
            this.errorMessage = error.body.message;
        } finally {
            this.isLoading = false;
        }
    }
}