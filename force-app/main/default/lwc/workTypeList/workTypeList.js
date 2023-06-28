import { LightningElement, wire } from 'lwc';
import getWorkTypesGroup from '@salesforce/apex/ProfessionalsController.getWorkTypesGroup';

export default class ProfessionList extends LightningElement {
    activeSectionMessage = '';
    listWorkTypesGroup;

    handleToggleSection(event) {
        this.activeSectionMessage =
            'Open section name:  ' + event.detail.openSections;
    }

    @wire(getWorkTypesGroup)
    wiredWorkTypesGroup(results) {
        if(results.data) {
            this.listWorkTypesGroup = results.data;
        } else if(results.error) {
            console.log(results.error);
        }
    }
}