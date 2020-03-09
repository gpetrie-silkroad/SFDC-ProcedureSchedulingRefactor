trigger OrderItemTrigger on OrderItem (
	after insert, 
	after update, 
	after delete, 
	before insert, 
	before delete,
	before update,
	after undelete) {
     	
	if (Trigger.isAfter && GlobalTriggerSwitch.runOrderDetailTrigger == true) {
		if(!Trigger.isDelete){
			if(GlobalTriggerSwitch.runOrderDetailTrigger){
				// Using the Ship Date and Territory Update Order Item Record with Appropropriate Goal
    			OrderItemTrigger_Helper.incrementalValueToGoal(Trigger.new);
				// Aggregate sum(Shipped_Quantity__c * Unit Price) all related orders for the Goal and update the Goal Record  
    			OrderItemTrigger_Helper.incrementalTotalUpRelatedOrders(Trigger.new);
				// Updates the Account Status if a Purchase has been Made
    			OrderItemTrigger_Helper.setAccountCustomerStatus(Trigger.new);  
    		}
    	}
    }		
	if(Trigger.isBefore && !Trigger.isDelete && GlobalTriggerSwitch.runOrderDetailTrigger == true){
		// Connect related Order Id
		OrderItemTrigger_Helper.qad_setOrderIdBefore(Trigger.New);
		// Set Sales Territory based on Account and sets Time Period based on Ship Date
		OrderItemTrigger_Helper.qad_setSalesRepsTerritoriesTimePeriod(Trigger.new);
		// Based on Territory and Time Period Goal is Set.
		OrderItemTrigger_Helper.qad_connectToGoal(Trigger.new);

		if(trigger.isInsert){	
			OrderItemTrigger_Helper.qad_setPricebookEntry(Trigger.new);
		}	

	}
	if (Trigger.isDelete   && GlobalTriggerSwitch.runOrderDetailTrigger == true){
		Set<Id> orderIdSet = new Set<Id>();
		for(OrderItem oi : Trigger.Old){
   			orderIdSet.add(oi.OrderId);
		}
		List<Order> orderList = [SELECT Id FROM Order WHERE Id IN : orderIdSet];
		// Recalculate Goal upon Delete
		OrderItemTrigger_Helper.incrementalValueToGoal2_FromOrderChange(orderList);
	}

}