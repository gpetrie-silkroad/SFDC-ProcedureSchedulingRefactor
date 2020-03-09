trigger Invoice_ItemTrigger on Invoice_Item__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

		if (Trigger.isBefore && GlobalTriggerSwitch.runInvoiceItemTrigger) {
	    	if(!Trigger.isDelete){
	    		Invoice_ItemTrigger_Helper.qad_setInvoiceNumber(Trigger.new);
	    		Invoice_ItemTrigger_Helper.qad_setSalesFields(Trigger.new);
	    	}
	    
		} else if (Trigger.isAfter) {
	    	//call handler.after method
	    
		}
}