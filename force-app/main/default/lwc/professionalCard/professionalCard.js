import { LightningElement, api, wire } from 'lwc';
import getReviewsByProfessionalName from '@salesforce/apex/ProfessionalsController.getReviewsByProfessionalName';

export default class ProfessionalsList extends LightningElement {
    @api professionalData;
    listReviews;
    averageRating;
    cantReviews;
    error;

    activeSectionMessage = '';

    handleToggleSection(event) {
        this.activeSectionMessage =
            'Open section name:  ' + event.detail.openSections;
    }

    @wire(getReviewsByProfessionalName, { professionalName: '$professionalData.Name'})
    wiredReviews(results) { 
        if (results.data) {
            this.listReviews = results.data;
            this.averageRating = this.getAverageRating(results.data);
            this.cantReviews = results.data.length;
        } else if (results.error) {
            this.error = results.error;
        }
    }

    getAverageRating(listReviews) {
        let ratings = [];
        for (let review of listReviews) {
            ratings.push(parseInt(review.Valoracion__c));
        }
        let sum = ratings.reduce((acum, current) => acum + current);
        let average = sum / ratings.length;
        return average;
    }

}