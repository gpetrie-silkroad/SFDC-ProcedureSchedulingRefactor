trigger PricebookEntry_Staging_TableTrigger on PricebookEntry_Staging_Table__c (
	before insert, 
	before update, 
	//before delete, 
	after insert, 
	after update 
	//after delete, 
	//after undelete
	) {

		if (Trigger.isBefore) {
	    	PricebookEntry_StagingTrigger_Helper.setNameBeforeUpsert(Trigger.new);
	    
		} else if (Trigger.isAfter) {
	    	PricebookEntry_StagingTrigger_Helper.setupPricebookEntries(Trigger.new);
	    
		}
}