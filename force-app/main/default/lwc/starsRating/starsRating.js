import { LightningElement, api } from 'lwc';

export default class StarsRating extends LightningElement {
    @api ratingData;
    stars = [];

    connectedCallback() {
        for (let i=0; i < 5; i++) {
            if (i < this.ratingData) {
                this.stars.push(
                    {
                        index: i,
                        state: 'warning'
                    }
                );
            } else {
                this.stars.push(
                    {
                        index: i,
                        state: 'default'
                    }
                )
            }
        }
    }
}