import { LightningElement,  wire } from 'lwc';
import getProfessionalsByName from '@salesforce/apex/ProfessionalsController.getProfessionalsByName';

export default class LightningExampleInputSearch extends LightningElement {
    queryTerm;
    error;
    listProfessionals = [];
    display = false;

    handleKeyUp(evt) {
        const isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            this.queryTerm = evt.target.value;
        }
    }

    @wire(getProfessionalsByName, { name : '$queryTerm'})
    wiredProfessionals(results) { 
        if (results.data) {
            this.listProfessionals = results.data;
            if(this.listProfessionals.length > 0 && this.queryTerm !== null) this.display = true
        } else if (results.error) {
            this.error = results.error;
        }
    }

    handleClick() {
        this.listProfessionals = [];
    }
}
