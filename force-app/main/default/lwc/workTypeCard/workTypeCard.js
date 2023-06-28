import { LightningElement, api, wire } from 'lwc';
import getProfessionalsByType from '@salesforce/apex/ProfessionalsController.getProfessionalsByType';

export default class WorkTypeCard extends LightningElement {
    @api workTypeGroupName;
    listProfessionals;

    @wire(getProfessionalsByType, { workTypeGroup: '$workTypeGroupName'})
    wiredProfessionals(results) { 
        if (results.data) {
            this.listProfessionals = results.data; 
        } else if (results.error) {
            console.log(results.error);
        }
    }
}