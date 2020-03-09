global class Procedure_Form_Count_Batch implements Database.Batchable<sObject> {
	
	String query;
	
	global Procedure_Form_Count_Batch(String q) {
		query = q;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		Procedure_FormTrigger_Helper.updatePhysicianProcedureCountNew(scope);
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}