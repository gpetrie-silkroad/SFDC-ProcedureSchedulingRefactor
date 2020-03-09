({
	initialvalues : function(component, event, helper) 
	{
		var ITFTransactions = component.get('v.ITFTransactions');
		var Index = component.get('v.Index');

		component.set('v.Transaction', ITFTransactions[Index]);
		var device = $A.get("$Browser.formFactor");
        component.set('v.device', device);

console.log("javascript debug: " + JSON.stringify(ITFTransactions[Index]));
	},

	UpdatePossibleLotPickList : function(component)
	{
		var Transaction = component.get('v.Transaction');
		var userInventoryPickList = component.get('v.userInventoryPickList');
		var i = 0;
		var PossibleLotPickList = [];
		
		for(i=0; i<userInventoryPickList.length; i++)
		{
			if(!userInventoryPickList[i].IsTransactionComplete__c && userInventoryPickList[i].Product_Number__c == Transaction.Product_Number__c)
			{
				PossibleLotPickList.push(userInventoryPickList[i].Lot_number__c);			
			}else if(PossibleLotPickList.length > 1)
			{
				break;
			}
		}

		component.set('v.PossibleLotPickList', PossibleLotPickList);
		Transaction.Lot_number__c = '===Choose Lot #===';
		component.set('v.Transaction', Transaction);

		//Reset Qty
		var PossibleQtyPickList = [];
		PossibleQtyPickList.push('Please select lot # first');
		component.set('v.PossibleQtyPickList', PossibleQtyPickList);
	},

	UpdatePossibleQtyPickList : function(component)
	{
		var Transaction = component.get('v.Transaction');
		var userInventoryPickList = component.get('v.userInventoryPickList');
		var i = 0;
		var j = 0;
		var PossibleQtyPickList = [];

		//Update user's choice into the main transaction list
		var ITFTransactions = component.get('v.ITFTransactions');
		var Index = component.get('v.Index');
		ITFTransactions[Index] = Transaction;
		component.set('v.ITFTransactions', ITFTransactions);
		
		for(i=0; i<userInventoryPickList.length; i++)
		{
			if(!userInventoryPickList[i].IsTransactionComplete__c 
				&& userInventoryPickList[i].Product_Number__c == Transaction.Product_Number__c 
				&& userInventoryPickList[i].Lot_number__c == Transaction.Lot_number__c )
			{
				for (j=0; j<userInventoryPickList[i].Quantity__c+1; j++)
				{
					PossibleQtyPickList.push(j.toString());
				}
				break;
			}
		}
		component.set('v.SelectedQty', '0');
		component.set('v.PossibleQtyPickList', PossibleQtyPickList);
	},

	UpdateTransactions: function(component, event, helper)
	{
		helper.UpdateTransactions(component);
	},

	updateDisableChoice : function(component, event, helper) {
		var DisableLotItemChoice = component.get('v.DisableLotItemChoice');
		if(!DisableLotItemChoice)
		{
			helper.UpdateTransactions(component);
		}
	},

	RemoveTransaction : function(component, event, helper) {
		var ITFTransactions = component.get('v.ITFTransactions');
		var Index = component.get('v.Index');
		var userInventoryPickList = component.get('v.userInventoryPickList');
		var Transaction = component.get('v.Transaction');
		var i = 0;
		var j = 0;

		//Mark avaible pick list again for this item
		for(i=0; i<userInventoryPickList.length; i++)
		{
			if(	userInventoryPickList[i].Product_Number__c == Transaction.Product_Number__c 
				&& userInventoryPickList[i].Lot_number__c == Transaction.Lot_number__c )
			{
				userInventoryPickList[i].IsTransactionComplete__c = false;
				break;
			}
		}
		component.set('v.userInventoryPickList', userInventoryPickList);	

		//Remove the item outof pick list
		if(ITFTransactions.length == 1)
		{
			Transaction.Lot_number__c = 'Please select product # first';
			Transaction.Quantity__c = 0;
			Transaction.Product_Number__c = '=== Choose Product # ====';
			ITFTransactions[0] = Transaction;
			component.set('v.Transaction', Transaction);
			component.set('v.DisableLotItemChoice', false);
			component.set('v.SelectedQty', 'Please select lot # first');
		}
		else
			ITFTransactions.splice(Index, 1);
		component.set('v.ITFTransactions', ITFTransactions);
	},
})
// console.log("javascript debug: " + JSON.stringify(LookUpTDSValue));