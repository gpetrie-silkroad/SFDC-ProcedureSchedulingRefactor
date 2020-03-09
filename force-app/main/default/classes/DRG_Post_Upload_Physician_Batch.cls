global class DRG_Post_Upload_Physician_Batch implements Database.Batchable<sObject> {
	
	String query;
	
	global DRG_Post_Upload_Physician_Batch(String q) {
		query = q;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		List<DRG_Physician__c> drgPh1 = DRG_Post_Upload_Processes.parsePhysicianNames(scope);
		List<DRG_Physician__c> drgPh2 = DRG_Post_Upload_Processes.populateContactIdOnDrgPhysician(drgPh1);
		update drgPh2;
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}