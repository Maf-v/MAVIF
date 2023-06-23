import { LightningElement, wire } from 'lwc';
import getProfessionalsByType from '@salesforce/apex/ProfessionalsController.getProfessionalsByType';

export default class ProfessionList extends LightningElement {
    activeSectionMessage = '';
    listGastroenterologia;

    handleToggleSection(event) {
        this.activeSectionMessage =
            'Open section name:  ' + event.detail.openSections;
    }

    @wire(getProfessionalsByType, { workTypeGroup: 'Gastroenterologia'})
    wiredProfessionals(results) { 
        if (results.data) {
            this.listGastroenterologia = results.data; 
            /* borrar */
            console.log('Aca esta listGastroenterologia');
            console.log(this.listGastroenterologia);
        } else if (results.error) {
            console.log(results.error);
        }
    }
}