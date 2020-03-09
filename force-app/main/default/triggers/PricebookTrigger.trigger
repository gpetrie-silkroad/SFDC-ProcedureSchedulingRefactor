trigger PricebookTrigger on Pricebook2 (
	before insert,
	after insert, 
	after update, 
	after undelete) {

		if (Trigger.isBefore && GlobalTriggerSwitch.runPricebook2Trigger) {
	    	Pricebook2Trigger_Helper.setPricebookName(Trigger.new);
	    
		} else if (Trigger.isAfter && GlobalTriggerSwitch.runPricebook2Trigger) {
	    	Pricebook2Trigger_Helper.associatePricebookToAccount(Trigger.new);
		}
}