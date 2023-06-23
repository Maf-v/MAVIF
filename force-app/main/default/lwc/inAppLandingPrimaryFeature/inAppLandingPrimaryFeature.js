import { LightningElement, api } from 'lwc';
import getWorkTypeGroupList from '@salesforce/apex/GetRecordId.getWorkTypeGroups'
import getWorkTypeList from '@salesforce/apex/GetRecordId.getWorkTypes'
import getWorkTypeGroupMemberList from '@salesforce/apex/GetRecordId.getWorkTypeGroupMembers'
import getServiceTerritoriesList from '@salesforce/apex/GetRecordId.getServiceTerritories'
import getServiceTerritoryWorkTypesList from '@salesforce/apex/GetRecordId.getServiceTerritoryWorkTypes'
import getOperatingHoursList from '@salesforce/apex/GetRecordId.getOperatingHours'
import getTimeSlotsList from '@salesforce/apex/GetRecordId.getTimeSlots'
import getAppointmentTopicTimeSlotsList from '@salesforce/apex/GetRecordId.getAppointmentTopicTimeSlots'
import getSkillRequirementsList from '@salesforce/apex/GetRecordId.getSkillRequirements'
import getServiceResourcesList from '@salesforce/apex/GetRecordId.getServiceResources'
import getServiceResourceSkillsList from '@salesforce/apex/GetRecordId.getServiceResourceSkills'
import getServiceTerritoryMembersList from '@salesforce/apex/GetRecordId.getServiceTerritoryMembers'
import getResourceAbsencesList from '@salesforce/apex/GetRecordId.getResourceAbsences'
import getOperatingHoursHolidaysList from '@salesforce/apex/GetRecordId.getOperatingHoursHolidays'
import getShiftsList from '@salesforce/apex/GetRecordId.getShifts'

export default class InAppLandingPrimaryFeature extends LightningElement {

    @api welcomeText = "Understanding the Salesforce Scheduler Setup";
    worktypegroupId = "";
    appointmenttempId = "";
    grouptemptopicId = "";
    serviceterritoryId = "";
    serviceterritoryworktypeId = "";
    operatinghoursId = "";
    timeslotId = "";
    appointmenttopictimeslotId = "";
    skillreqId = "";
    serviceresourceId = "";
    serviceresourceassetId = "";
    serviceresourceskillId = "";
    servicereterritorymemberId = "";
    resourceabsenceId = "";
    shiftId = "";
    operatinghoursholidayId = "";
   
    connectedCallback() {

        getWorkTypeGroupList()
        .then(result => {
            if (result.length) {
                this.worktypegroupId = result[0].Id;
            }
        });

        getWorkTypeList()
        .then(result => {
            if (result.length) {
                this.appointmenttempId = result[0].Id;
            }
        });

        getWorkTypeGroupMemberList()
        .then(result => {
            if (result.length) {
                this.grouptemptopicId = result[0].Id;
            }
        });

        getServiceTerritoriesList().
        then(result => {
            if (result.length) {
                this.serviceterritoryId = result[0].Id;
            }
        });

        getServiceTerritoryWorkTypesList().
        then(result => {
            if (result.length) {
                this.serviceterritoryworktypeId = result[0].Id;
            }
        });

        getOperatingHoursList().
        then(result => {
            if (result.length) {
                this.operatinghoursId = result[0].Id;
            }
        });

        getTimeSlotsList().
        then(result => {
            if (result.length) {
                this.timeslotId = result[0].Id;
            }
        });

        getAppointmentTopicTimeSlotsList().
        then(result => {
            if (result.length) {
                this.appointmenttopictimeslotId = result[0].Id;
            }
        });

        getSkillRequirementsList().
        then(result => {
            if (result.length) {
                this.skillreqId = result[0].Id;
            }
        });

        getServiceResourcesList({resourceType:'T'}).
        then(result => {
            if (result.length) {
                this.serviceresourceId = result[0].Id;
            }
        });

        getServiceResourcesList({resourceType:'S'}).
        then(result => {
            if (result.length) {
                this.serviceresourceassetId = result[0].Id;
            }
        });

        getServiceResourceSkillsList().
        then(result => {
            if (result.length) {
                this.serviceresourceskillId = result[0].Id;
            }
        });

        getServiceTerritoryMembersList().
        then(result => {
            if (result.length) {
                this.servicereterritorymemberId = result[0].Id;
            }
        });

        getResourceAbsencesList().
        then(result => {
            if (result.length) {
                this.resourceabsenceId = result[0].Id;
            }
        });

        getShiftsList().
        then(result => {
            if (result.length) {
                this.shiftId = result[0].Id;
            }
        });

        getOperatingHoursHolidaysList().
        then(result => {
            if (result.length) {
                this.operatinghoursholidayId = result[0].Id;
            }
        });

    }

    get pass_false() {
        return false;
    }

    get pass_true() {
        return true;
    }

}