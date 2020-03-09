({
	init : function(component, event, helper) {
		helper.updateOnHandQty(component);
		helper.updateDateColorCode(component);
	},

	changeOnHandQty : function(component, event, helper) {
		helper.updateOnHandQty(component);
	},

	changeSubmitDate: function(component, event, helper) {
		helper.updateDateColorCode(component);
	},

	updateHiddenField : function(component, event, helper) {
		var transaction = component.get('v.transaction');
		var IsChange = component.get('v.IsChange');
		IsChange = true;

		if(transaction.IsDisplayed__c)
			transaction.IsDisplayed__c = false;
		else
			transaction.IsDisplayed__c = true;

		component.set('v.transaction',transaction);
		component.set('v.IsChange',IsChange);
	},

	changeTransactionDetail : function(component, event, helper) {
		var transaction = component.get('v.transaction');
		var IsChange = component.get('v.IsChange');
		IsChange = true;
		helper.updateDateColorCode(component);
		helper.updateOnHandQty(component);

		component.set('v.transaction',transaction);
		component.set('v.IsChange',IsChange);
	},
})

// console.log("Create expense5: " + JSON.stringify(onhandlist));