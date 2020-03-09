global class Analytics_Controller_Scheduler implements Schedulable {
	global void execute(SchedulableContext sc) {
		Analytics_Controller.deleteAytdList();
		Analytics_Controller.getRevenueYtdNumbers();
		Analytics_Controller.getProcedureYtdNumbers();
	}
}