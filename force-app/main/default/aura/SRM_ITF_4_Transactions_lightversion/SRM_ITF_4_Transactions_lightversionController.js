({
	updateUserchoices : function(component, event, helper) {
		helper.addoneITFTransaction(component);
		helper.initializeUserPicklist(component);
	},

	addNewTransaction : function(component, event, helper) {
		//Check the last transaction - valid allow to add nw, if not - error will show up
		var ITFTransactions = component.get("v.ITFTransactions");

		var length = ITFTransactions.length - 1;
		if(ITFTransactions[length].Lot_number__c !== 'Please select product # first' &&  ITFTransactions[length].Lot_number__c !== '===Choose Lot #===')		
		{
			var TriggerDisableProductLotChoice = component.get('v.TriggerDisableProductLotChoice');
			if(TriggerDisableProductLotChoice)
				component.set('v.TriggerDisableProductLotChoice', false);
			else
				component.set('v.TriggerDisableProductLotChoice', true);
			helper.addoneITFTransaction(component);
		}
		else
		{
			alert('Please fill in the last item before adding a new item');
		}
	},

	updateItemPickLists : function(component, event, helper) {
		var userInventoryPickList = component.get('v.userInventoryPickList');
		var PossibleItemPickList = [];
		var i = 0;
		var index = -1;

		// PossibleItemPickList.push('=== Choose Product # ====');
		for(i=0; i<userInventoryPickList.length; i++)
		{
			if(!userInventoryPickList[i].IsTransactionComplete__c && (index == -1 || PossibleItemPickList[index] !== userInventoryPickList[i].Product_Number__c))
			{
				index++;
				PossibleItemPickList.push(userInventoryPickList[i].Product_Number__c);
			}			
		}

		component.set("v.PossibleItemPickList", PossibleItemPickList);
	},
})
// console.log("javascript debug: " + JSON.stringify(LookUpTDSValue));