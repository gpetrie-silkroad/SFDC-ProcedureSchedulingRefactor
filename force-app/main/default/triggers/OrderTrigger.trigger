trigger OrderTrigger on Order (
	after insert, 
	after update, 
	after delete, 
	before insert,
	before update,
	after undelete) {
 
	if(Trigger.isAfter &&  !Trigger.isDelete && GlobalTriggerSwitch.runOrderTrigger == TRUE){

		OrderItemTrigger_Helper.incrementalValueToGoal2_FromOrderChange(Trigger.new);
		OrderTrigger_Helper.qad_processBorders(Trigger.new);
		OrderTrigger_Helper.handleNonPickedOrders(Trigger.new);
	}
	if(Trigger.isBefore && !Trigger.isDelete &&  GlobalTriggerSwitch.runOrderTrigger == TRUE){
		if(Trigger.isInsert){
			OrderTrigger_Helper.setOrderPricebookFieldRepsTerritoriesTimePeriods(Trigger.new, 'Insert');

		}
		if(Trigger.isUpdate){
			OrderTrigger_Helper.setOrderPricebookFieldRepsTerritoriesTimePeriods(Trigger.new, 'Update');
		}
		OrderTrigger_Helper.qad_setAccountAndAddresses(Trigger.new);
	}
}