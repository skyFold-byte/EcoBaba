import { LightningElement, wire } from 'lwc';
import getMyImpact from '@salesforce/apex/MyImpactController.getMyImpact';
 
import { loadScript } from 'lightning/platformResourceLoader';
import CONFETTI from '@salesforce/resourceUrl/confetti';
 
export default class MyImpact extends LightningElement {
 
    impact;
    animatedPoints = 0;
    animatedHours = 0;
 
    confettiLoaded = false;
 
    renderedCallback() {
 
        if (this.confettiLoaded) {
            return;
        }
 
        this.confettiLoaded = true;
 
        loadScript(this, CONFETTI)
            .then(() => {
                this.launchConfetti();
            })
            .catch(error => {
                console.error('Confetti error', error);
            });
    }
 
    @wire(getMyImpact)
    wiredImpact({ data, error }) {
 
        if (data) {
            this.impact = data;
            this.animateValues();
        }
 
        if (error) {
            console.error(error);
        }
    }
 
    animateValues() {
 
        let interval = setInterval(() => {
 
            if (this.animatedPoints < this.impact.totalPoints) {
                this.animatedPoints += 1;
            }
 
            if (this.animatedHours < this.impact.totalHours) {
                this.animatedHours += 0.5;
            }
 
            if (this.animatedPoints >= this.impact.totalPoints &&
                this.animatedHours >= this.impact.totalHours) {
 
                clearInterval(interval);
            }
 
        }, 20);
    }
 
    launchConfetti() {
 
        const duration = 2000;
        const end = Date.now() + duration;
 
        const interval = setInterval(function () {
 
            confetti({
                particleCount: 6,
                spread: 70,
                origin: { y: 0.6 }
            });
 
            if (Date.now() > end) {
                clearInterval(interval);
            }
 
        }, 200);
    }
 
    get badgeImage() {
 
        if (this.impact.badge === 'Platinum Champion') {
            return 'https://img.icons8.com/color/96/trophy.png';
        }
 
        if (this.impact.badge === 'Gold Warrior') {
            return 'https://img.icons8.com/color/96/gold-medal.png';
        }
 
        if (this.impact.badge === 'Silver Hero') {
            return 'https://img.icons8.com/color/96/silver-medal.png';
        }
 
        return 'https://img.icons8.com/color/96/bronze-medal.png';
    }
 
    get progressStyle() {
        return `width:${this.impact.progressPercent}%`;
    }
 
    handleDownload() {
 
        const url = window.location.origin +
            '/apex/EcoConnectCertificatePDF?id=' + this.impact.volunteerId;
 
        window.open(url);
    }
}