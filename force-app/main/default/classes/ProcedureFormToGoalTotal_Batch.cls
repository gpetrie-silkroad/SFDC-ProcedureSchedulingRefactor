global class ProcedureFormToGoalTotal_Batch implements Database.Batchable<sObject> {
	
	String query;
	
	global ProcedureFormToGoalTotal_Batch(String q) {
		query = q;
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   			Procedure_FormTrigger_Helper.totalValueToGoalBatchController(scope);	
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}