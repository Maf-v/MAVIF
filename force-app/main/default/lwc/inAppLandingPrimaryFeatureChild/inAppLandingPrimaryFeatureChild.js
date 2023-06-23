import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import createShiftBasedonOrgCreationDate from "@salesforce/apex/ShiftInsertion.createShiftBasedonOrgCreation";
import getShiftCounts from "@salesforce/apex/ShiftInsertion.getShiftCount";

export default class InAppLandingPrimaryFeatureChild extends NavigationMixin(LightningElement) {
    
    @api image = "standard:all";
    @api heading = "";
    @api url = "";
    @api linkInNewTab = false;
    @api appText = "";
    @api noRecord = false;
    @api shiftsRecordsFromButton;
    @api buttonEnabled = false;
    @api secondaryTextPresent = false; 
    @api secondaryText = "";
    @api linkReference = "";
    @api app = "";
    @api page = "";
    @api objectName = "";
    @api objectId = "";
    @api filterName = "";
    @api pageReference = {};
    @api insideLinkPresent = false;
    @api insideLink = "";
    @api insideLinkBeforeText = "";
    @api insideLinkText = "";
    @api insideLinkAfterText = "";

    connectedCallback(){

        getShiftCounts().then(result => {
            var count = result;
            this.shiftsRecordsFromButton = (count > 2 ? false : true );
        });
        
    }

    handleClick(event) {

        if (this.linkReference == "standard__namedPage") {
            this.pageReference = {
                type: "standard__app",
                attributes: {
                    appTarget: this.app,
                    pageRef: {
                        type: "standard__namedPage",
                        attributes: {
                            pageName: this.page
                        }
                    }
                }
            }
        } else if (this.linkReference == "standard__navItemPage") {
            this.pageReference = {
                type: "standard__app",
                attributes: {
                    appTarget: this.app,
                    pageRef: {
                        type: "standard__navItemPage",
                        attributes: {
                            apiName: this.page
                        }
                    }
                }
            }
        } else if (this.linkReference == "standard__recordPage") {
            this.pageReference = {
                type: "standard__app",
                attributes: {
                    appTarget: this.app,
                    pageRef: {
                        type: 'standard__recordPage',
                        attributes: {
                            objectApiName: this.objectName,
                            actionName: 'view',
                            recordId: this.objectId
                        }
                    }
                }
            }
        } else if (this.linkReference == "standard__objectPage") {
            this.pageReference = {
                type: "standard__app",
                attributes: {
                    appTarget: this.app,
                    pageRef: {
                        type: 'standard__objectPage',
                        attributes: {
                            objectApiName: this.objectName,
                            actionName: 'list'
                        },
                        state: {
                            filterName: this.filterName
                        }
                    }
                }
            }
        } else if (this.linkReference == "standard__recordRelationshipPage") {
            this.pageReference = {
                type: "standard__app",
                attributes: {
                    appTarget: this.app,
                    pageRef: {
                        type: 'standard__recordRelationshipPage',
                        attributes: {
                            objectApiName: this.objectName,
                            actionName: 'view',
                            recordId: this.objectId,
                            relationshipApiName: this.relatedEntity
                        }
                    }
                }
            }
        } else if (this.linkReference == "standard__webPage") {
            this.pageReference = {
                type: 'standard__webPage',
                attributes: {
                    url: this.url
                }
            }
        }
        if (this.linkInNewTab) {
            const windowContextNameUUID = crypto.randomUUID();
            this[NavigationMixin.GenerateUrl](this.pageReference)
            .then(generated_url => {
                window.open('', windowContextNameUUID);
                window.open(generated_url, windowContextNameUUID);
            } );
        } else {
            this[NavigationMixin.Navigate](this.pageReference);
        }

    }

    callDataLoader(event) {

        createShiftBasedonOrgCreationDate().then(result => {
            var dataLoadStatus=result;
        }); 

    }
    
    get pass_true() {
        return true;
    }

    get pass_false() {
        return false;
    }

}