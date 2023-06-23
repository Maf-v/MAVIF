trigger ReviewTrigger on Review__c (after insert) {

    switch on Trigger.operationType {
        when AFTER_INSERT {
            ReviewTriggerHandler.bulkUpdateAverageRating(Trigger.new);
        }
    }
}