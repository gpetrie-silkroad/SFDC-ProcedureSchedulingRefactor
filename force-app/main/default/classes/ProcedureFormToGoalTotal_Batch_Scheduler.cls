global class ProcedureFormToGoalTotal_Batch_Scheduler implements Schedulable {
	global void execute(SchedulableContext sc) {
		Procedure_FormTrigger_Helper.totalValueToGoalBatchLauncher();	
	}
}