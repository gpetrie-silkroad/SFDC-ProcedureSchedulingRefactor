({
	UpdateTransactions : function(component)
	{
		var Transaction = component.get('v.Transaction');
		var SelectedQty = component.get('v.SelectedQty');
		var DisableLotItemChoice = component.get('v.DisableLotItemChoice');
		var ITFTransactions = component.get('v.ITFTransactions');
		var Index = component.get('v.Index');
		var userInventoryPickList = component.get('v.userInventoryPickList');
		var DisableLotItemChoice = component.get('v.DisableLotItemChoice');
		var userInventoryPickList = component.get('v.userInventoryPickList');
		var i = 0;

		if(!DisableLotItemChoice)
		{
			component.set('v.DisableLotItemChoice', true);
			for(i=0; i<userInventoryPickList.length; i++)
			{
				if(	userInventoryPickList[i].Product_Number__c == Transaction.Product_Number__c 
					&& userInventoryPickList[i].Lot_number__c == Transaction.Lot_number__c )
				{
					userInventoryPickList[i].IsTransactionComplete__c = true;
					break;
				}
			}
			component.set('v.userInventoryPickList', userInventoryPickList);
		}

		if(Number(SelectedQty) == null)
			Transaction.Quantity__c = 0;
		else
			Transaction.Quantity__c = Number(SelectedQty);
		ITFTransactions[Index] = Transaction;
		component.set('v.Transaction', Transaction);
		component.set('v.ITFTransactions', ITFTransactions);
	}
})