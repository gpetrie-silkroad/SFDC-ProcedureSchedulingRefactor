trigger ContactTrigger on Contact (
	 
	after insert, 
	after update,  
	after undelete) {

		if (Trigger.isBefore && GlobalTriggerSwitch.runContactTrigger) {
	    	//call your handler.before method
	    
		} 
		else if (Trigger.isAfter  && GlobalTriggerSwitch.runContactTrigger) {

			SYSTEM.DEBUG('CONTACT TRIGGER IS AFTER STARTED');

	    	ContactTrigger_Helper.addAccountToHospitalAssociation(Trigger.new);
	    
		}
}