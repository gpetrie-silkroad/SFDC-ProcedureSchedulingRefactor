trigger Product2Trigger on Product2 (
	 
	after insert
	) {

		if (Trigger.isBefore) {
	    	//call your handler.before method
	    
		} else if (Trigger.isAfter && GlobalTriggerSwitch.runProduct2Trigger) {
	    	Product2Trigger_Helper.createStdPricebookEntry(Trigger.new);
	    
		}
}