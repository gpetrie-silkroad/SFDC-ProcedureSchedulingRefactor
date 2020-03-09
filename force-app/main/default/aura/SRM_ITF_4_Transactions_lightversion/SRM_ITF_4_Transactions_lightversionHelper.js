({
    addoneITFTransaction: function(component)
    {
		var currentUser = component.get('v.currentUser');
    	var ITFTransactions = component.get("v.ITFTransactions");

    	ITFTransactions.push({
                        'sobjectType':'Inventory_Transfer_Form_Transaction__c',
                        'Inventory_Owner__c': currentUser.Name,
                        'Quantity__c': 0,
                        'Product_Number__c': '=== Choose Product # ====', 
                        'Lot_number__c': 'Please select product # first'
                    });

    	component.set("v.ITFTransactions", ITFTransactions);
    },

    initializeUserPicklist: function(component)
    {
		var userInventory = component.get('v.userInventory');
		var userInventoryPickList = [];
		var i = 0;

		for(i=0; i<userInventory.length; i++)
		{
	    	userInventoryPickList.push
	    	({
                    'sobjectType':'Inventory_Transfer_Form_Transaction__c',
                    'Product_Number__c': userInventory[i].Item_Number__c,
                    'Lot_number__c': userInventory[i].Lot_Number__c,
                    'Quantity__c': userInventory[i].On_Hand_Qty__c,
                    'IsTransactionComplete__c' : false,
	        });
    	}
    	component.set("v.userInventoryPickList", userInventoryPickList);
    },
})
// console.log("javascript debug: " + JSON.stringify(userInventory));