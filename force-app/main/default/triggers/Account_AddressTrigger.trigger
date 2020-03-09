trigger Account_AddressTrigger on Account_Address__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

		if (Trigger.isBefore) {
	    	//call your handler.before method
	    
		} else if (Trigger.isAfter && GlobalTriggerSwitch.RunAccount_AddressTrigger) {
	    	Account_AddressTrigger_Helper.qad_populateAccountRecordAddress(Trigger.New);
	    
		}
}