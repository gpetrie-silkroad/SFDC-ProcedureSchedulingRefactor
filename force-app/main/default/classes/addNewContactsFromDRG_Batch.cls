global class addNewContactsFromDRG_Batch implements Database.Batchable<sObject> {
	
	String query;
	
	global addNewContactsFromDRG_Batch(string q) {
		query = q;
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		DRG_Post_Upload_Processes.addNewContactsFromDRG(scope);
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}