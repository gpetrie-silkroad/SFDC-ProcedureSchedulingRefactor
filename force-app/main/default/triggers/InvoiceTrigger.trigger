trigger InvoiceTrigger on Invoice__c (
	before insert, 
	before update,
	after insert,
	after update
	){

		if (Trigger.isBefore && GlobalTriggerSwitch.runInvoiceTrigger) {
			if(!Trigger.isDelete){
				InvoiceTrigger_Helper.qad_setAccountId(Trigger.new);
				InvoiceTrigger_Helper.qad_populateInvoiceFieldsBeforeUpsert(Trigger.new);
			}
	    }

	    if (Trigger.isAfter && GlobalTriggerSwitch.runInvoiceTrigger) {
			if(!Trigger.isDelete){
				InvoiceTrigger_Helper.afterPopulateRMAShipDates(Trigger.new);
			}
			if(Trigger.isInsert){
				InvoiceTrigger_Helper.afterInsertPopulateRMATerritories(Trigger.new);
			}	
		}		
}