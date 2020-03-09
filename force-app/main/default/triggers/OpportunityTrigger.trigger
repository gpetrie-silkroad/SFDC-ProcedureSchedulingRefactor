trigger OpportunityTrigger on Opportunity (
	after insert, 
	after update)

	 {

		if (Trigger.isAfter && GlobalTriggerSwitch.runOpportunityTrigger) {
	    	OpportunityTrigger_Helper.updateOpportunityWithAMandAD(Trigger.new);
	    
		}
}