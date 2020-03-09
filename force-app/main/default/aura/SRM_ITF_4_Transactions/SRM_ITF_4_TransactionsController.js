({
	doInit: function(component, event, helper) {
		component.set('v.DisplayAddNewEditTransaction', false);

		var accountID = component.get('v.ITForm.Customer_To__c');
		if(accountID !== null & accountID !== undefined & accountID !=='')
			helper.getCustomerPricebook(component, accountID);
	},

	updateITFTransaction: function(component, event, helper) {
		var id = component.get('v.ITForm.Id');
		var checkITFField = component.get('v.tempITFTransaction.Inventory_Transfer_Form__c');

		if(checkITFField == null || checkITFField == '')
			component.set('v.tempITFTransaction.Inventory_Transfer_Form__c', id);
	},

	deleteEvent: function(component, event, helper) {
		helper.delTran(component, event.getParam("ITFormTransaction"));
	},

	updateITFTransactions: function(component, event, helper) {
		helper.getITFTransactions(component);
	},

	backButton: function(component, event, helper)
	{
		component.set('v.tempStatus', 1);
	},

	nextButton: function(component, event, helper) {
		var currentStatus = component.get('v.currentStatus');
		var controllingTransactionTypePickList = component.get('v.controllingTransactionTypePickList');
		var ITFTransactions = component.get('v.ITFTransactions');
		
		if(ITFTransactions.length == 0)
		{
			alert("Please add at least 1 item before moving the next step.");
		}else
		{
			if(controllingTransactionTypePickList == 1 || controllingTransactionTypePickList == 2)
			{
				var objectID = component.get("v.ITForm.Id");
				var navEvt = $A.get("e.force:navigateToSObject");
		        navEvt.setParams({
		            "recordId": objectID,
		            "slideDevName": "detail"
		        });
	        	navEvt.fire();
			}else
			{
				if(currentStatus == 2){
					component.set('v.tempStatus', 3);
					component.set('v.currentStatus', 3);
				}else{
					component.set('v.tempStatus', currentStatus);
				}				
				var createEvent = component.getEvent("updateITForm");
				var ITForm = component.get('v.ITForm');

				component.set('v.ITForm.AutoSaveCopy__c', false);
				createEvent.setParams({ "ITForm": ITForm });
				createEvent.fire();			
			}
		}
	},

	addTransaction: function(component, event, helper) {
		component.set('v.DisplayAddNewEditTransaction', true);
	},
})

// console.log("Create expense0: " + JSON.stringify(ITForm));