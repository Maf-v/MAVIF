import { LightningElement, api } from 'lwc';
import getServiceAppointmentsList from '@salesforce/apex/GetRecordId.getServiceAppointments'
import getAccountsList from '@salesforce/apex/GetRecordId.getAccounts'

export default class InAppLandingSecondaryFeature extends LightningElement {

    @api welcomeText = "Explore different Outbound scheduling experiences";
    serviceappointmentId = "";
    serviceappointmentassetId = "";
    accountId = "";
  
    connectedCallback(){
       
        getServiceAppointmentsList({appNum:'SA-0001'}).then(result => {
            if (result.length) {
                this.serviceappointmentId = result[0].Id;
            }
        });

        getServiceAppointmentsList({appNum:'SA-0003'}).then(result => {
            if (result.length) {
                this.serviceappointmentassetId = result[0].Id;
            }
        });

        getAccountsList().then(result => {
            if (result.length) {
                this.accountId = result[0].Id;
            }
        });
    }

    get pass_true() {
        return true;
    }
    get pass_false() {
        return false;
    }

}