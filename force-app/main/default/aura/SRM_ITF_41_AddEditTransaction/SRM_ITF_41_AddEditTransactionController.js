({
	doInit: function(component, event, helper) {
		var userList = component.get('v.possibleOwnerList');
		var tempITFTransaction = component.get('v.tempITFTransaction');
		var check = true;

		if(tempITFTransaction.Id != null & tempITFTransaction.Id != ''){
			//Update Product list + Lot List (else for rep/tds name has been removed in step 1)
			check = helper.updateProductList(component, tempITFTransaction.Inventory_Owner__c);
			if (check == false & userList.length == 1){
					helper.updateProductList(component, userList[0]);      
					var qtyList = ['0'];
					component.set('v.qtyPickList',qtyList);  
			}
			//Update Lot List
			helper.updateLotList(component, tempITFTransaction.Inventory_Owner__c, tempITFTransaction.Product_Number__c);
			//Update Qty List
			helper.updateQtyList(component, tempITFTransaction.Inventory_Owner__c, tempITFTransaction.Lot_number__c);

			component.set('v.workingITFTransaction', tempITFTransaction);
			//Update price status
			helper.updatePrice(component);

			component.set('v.qtyString', tempITFTransaction.Quantity__c.toString());
		}else{
			if(userList.length == 1){
				helper.updateProductList(component, userList[0]);      
				var qtyList = ['0'];
				component.set('v.qtyPickList',qtyList);                                                                                                                                                 
			}
		}

		//Auto set price to 0 if rep to rep transfer
		var ITF = component.get('v.ITForm');
		if(ITF.ITF_Type__c == 'Internal Transfer (AM/TDS to AM/TDS)')
		{
			component.set('v.workingITFTransaction.Price__c', 0);
			component.set("v.warningSuggestedPrice", 1);
		}
	},

	updateAfterChoosingInventory: function(component, event, helper) {
		var ownerName = component.get('v.workingITFTransaction.Inventory_Owner__c');
		var Product = component.get('v.workingITFTransaction.Product_Number__c');
		helper.updateProductList(component, ownerName);
		var qtyList = ['0'];
		component.set('v.qtyPickList',qtyList);
		if(Product != null && Product !='')
			helper.updateLotList(component, ownerName, Product);
		component.set('v.workingITFTransaction.Lot_number__c','');
		component.set('v.workingITFTransaction.Quantity__c', 0);
		component.set('v.qtyString','');
		var ITF = component.get('v.ITForm');
		if(ITF.ITF_Type__c !== 'Internal Transfer (AM/TDS to AM/TDS)')
		{
			component.set('v.workingITFTransaction.Price__c', null);
			component.set("v.warningSuggestedPrice", 0);		
		}
	},

	updateAfterChoosingProduct: function(component, event, helper) {
		var Product = component.get('v.workingITFTransaction.Product_Number__c');
		var ownerName = component.get('v.workingITFTransaction.Inventory_Owner__c');
		var qtyList = ['0'];
		helper.setDefaultValues(component);
		helper.updateLotList(component, ownerName, Product);
		component.set('v.qtyPickList',qtyList);
		component.set('v.workingITFTransaction.Quantity__c', 0);
		component.set('v.qtyString','');
		component.set('v.workingITFTransaction.Lot_number__c','');
		helper.updatePrice(component);
	},

	updateAfterChoosingLot: function(component, event, helper) {
		var lotNumber= component.get('v.workingITFTransaction.Lot_number__c');
		var ownerName = component.get('v.workingITFTransaction.Inventory_Owner__c');
		helper.updateProductNum(component, lotNumber);
		helper.updateQtyList(component, ownerName, lotNumber);
	},

	updateAfterChoosingQty: function(component, event, helper) {
		var qtyString= component.get('v.qtyString');
		component.set('v.workingITFTransaction.Quantity__c', parseInt(qtyString));
	},

	cancelITFTransaction: function(component, event, helper) {
		var userchoice = confirm("Do you want to continue without saving the transaction");
		if(userchoice){
			helper.clearWorkingITFTransaction(component);
			var status = component.get('v.DisplayAddNewEditTransaction');
			var createEvent = component.getEvent("ITFormTransactions");
            createEvent.fire();
			component.set('v.DisplayAddNewEditTransaction', false);
		}
	},

	saveITFTransaction: function(component, event, helper) {
		var isValid = helper.checkITFTransaction(component);

		var workingITFTransaction = component.get('v.workingITFTransaction');
		if(isValid){
		 	helper.addTempITFTran(component, workingITFTransaction);
		}
	},

	updatingExpiringStatus: function(component, event, helper) {
		var workingITFTransaction = component.get('v.workingITFTransaction');
		var lotNumber = workingITFTransaction.Lot_number__c;
		if(lotNumber == '' || lotNumber == null || lotNumber =='N/A')
			component.set('v.expiringStatus', '0');
		else{
			var expiringDate = helper.getExpiringDate(component, workingITFTransaction.Inventory_Owner__c, lotNumber);
			if(expiringDate	== null || expiringDate	== '')
				component.set('v.expiringStatus', '3');
			else{
				var usedDate = component.get('v.ITForm.Transfer_Date__c');
				if(usedDate>expiringDate)
					component.set('v.expiringStatus', '2');
				else
					component.set('v.expiringStatus', '1');
			}
		}
	},

	updatingUOM: function(component, event, helper) {
		var product = component.get('v.workingITFTransaction.Product_Number__c');

		if(product == undefined || product == '')
		{
			component.set('v.isGWMPK',true);
		}else
		{
			if(product.includes("GW") || product.includes("MP"))
				component.set('v.isGWMPK',true);
			else
				component.set('v.isGWMPK',false);			
		}		
	},

	closeWaitingPopUp: function(component, event, helper) { 
        component.set("v.WaitingWindow", false);
    },

	updateAfterChoosingUOM: function(component, event, helper) { 
        component.set("v.WaitingWindow", false);
        helper.updatePrice(component);
    },

    changePrice: function(component)
    {
    	// var warningSuggestedPrice = component.get("v.warningSuggestedPrice");
    	component.set("v.warningSuggestedPrice", 2);
    }
})
// console.log("Create expense0: " + JSON.stringify(ITForm));