({
	DeleteTransaction: function(component, event, helper) {
		var iTFTransaction = component.get("v.transaction");
		var deleteEvent = component.getEvent("deleteEvent");
		deleteEvent.setParams({ "ITFormTransaction": iTFTransaction }).fire();
	},
	
	EditTransaction: function(component, event, helper) {
		var iTFTransaction = component.get("v.transaction");
		component.set('v.tempITFTransaction', iTFTransaction);
		var status = component.get('v.DisplayAddNewEditTransaction');
		component.set('v.DisplayAddNewEditTransaction', true);
	},
})