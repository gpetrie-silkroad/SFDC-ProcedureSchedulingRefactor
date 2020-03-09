global class DRG_Post_Upload_Procedure_Batch implements Database.Batchable<sObject> {
		
	String query;
	
	global DRG_Post_Upload_Procedure_Batch(String q) {
		query = q;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		Drg_Post_Upload_Processes.connectDRGProcedures(Scope);
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}