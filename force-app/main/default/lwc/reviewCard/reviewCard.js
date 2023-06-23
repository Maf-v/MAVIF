import { LightningElement, api } from 'lwc';

export default class ReviewCard extends LightningElement {
    @api reviewData;

    get createdDate() {
        let date = new Date(this.reviewData.CreatedDate.split('T')[0]);
        const options = { year: 'numeric', month: 'long', day: 'numeric' };
        return date.toLocaleDateString('es-ES', options);
    }

}