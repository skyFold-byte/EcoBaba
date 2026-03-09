import { LightningElement, wire } from 'lwc';
import getVolunteerProfile from '@salesforce/apex/VolunteerProfileController.getVolunteerProfile';
 
export default class EcoVolunteerProfile extends LightningElement {
 
profile;
 
@wire(getVolunteerProfile)
wiredProfile({data,error}){
 
if(data){
this.profile = data;
}
 
if(error){
console.error(error);
}
 
}
 
downloadCertificate(){
 
window.open('/apex/EcoConnectCertificatePDF?id=' + this.profile.volunteerId);
 
}
 
}