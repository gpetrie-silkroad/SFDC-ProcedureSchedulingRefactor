global class SellingDaysCalculator implements Schedulable {
	global void execute(SchedulableContext sc) {
		SellingDaysCalculator_Helper.updateAll();
	}
}