trigger ShipmentTrigger on Shipment__c (
	before insert, 
	before update, 
	after insert, 
	after update) {

		if (Trigger.isBefore && GlobalTriggerSwitch.runShipmentTrigger) {
	    	ShipmentTrigger_Helper.parseShipmentInfo(Trigger.new);
	    
		} else if (Trigger.isAfter && GlobalTriggerSwitch.runShipmentTrigger) {
	    	ShipmentTrigger_Helper.updateOrderItemDetail(Trigger.new);
	

		}
}