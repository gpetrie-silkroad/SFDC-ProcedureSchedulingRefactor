trigger OrderItemDetailTrigger on OrderItemDetail__c (
	after insert, 
	after update, 
	after delete, 
	before insert,
	before update, 
	before delete,
	after undelete) {
   
	if(Trigger.isBefore && !Trigger.isDelete && GlobalTriggerSwitch.runOrderItemDetailTrigger){
		OrderItemDetailTrigger_Helper.qad_connectInvoiceId(Trigger.new);
		OrderItemDetailTrigger_Helper.qad_connectShipment(Trigger.new);
	}
	if(Trigger.isAfter && !Trigger.isDelete && GlobalTriggerSwitch.runOrderItemDetailTrigger){
		OrderItemDetailTrigger_Helper.qad_updateOrderItem(Trigger.New);
	}
}