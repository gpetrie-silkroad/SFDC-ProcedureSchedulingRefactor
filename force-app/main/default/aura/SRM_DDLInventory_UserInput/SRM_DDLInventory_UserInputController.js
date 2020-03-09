({
	doInit : function(component, event, helper) {
		helper.getLocList(component);
		helper.getLotList(component);
		var lotno = component.get('v.LotNo');

		if(lotno !== null || lotno !=='')
			component.set('v.LotSearchName', lotno);
	},

	continueInital : function(component, event, helper) {
		var LocationID = component.get('v.LocationID');
		var ListLocation = component.get('v.ListLocation');
		var i = 0;

		for(i=0; i<ListLocation.length; i++){
			if(ListLocation[i].Location_Description__c == LocationID){
				component.set('v.LocationSearchName', LocationID);		
			}
		}
	},

	//=================Search location===========================
	SearchLocation : function(component, event, helper) {
		var ListLocation = component.get('v.ListLocation');
		var tempLocations = [];
		var SearchLocation = component.get('v.LocationSearchName').toLowerCase().trim();
		var i = 0;

		for(i=0; i<ListLocation.length; i++){
			if(ListLocation[i].Rep_Name__c != null)
				if(ListLocation[i].Rep_Name__c.toLowerCase().search(SearchLocation)>-1)
					tempLocations.push(ListLocation[i]);			
		}

		if(tempLocations.length == 0)
			component.set('v.displaySearchLocationList',false);
		else
			component.set('v.displaySearchLocationList',true);
        component.set('v.ListLocationTemp',tempLocations);

        if(SearchLocation == '' || SearchLocation == null)
        {
        	component.set('v.displaySearchLocationList',false);
        	component.set('v.LocationID', '');
        }
	},


	SelectLocation : function(component, event, helper) {
		var index = event.getSource().get('v.name');
		var ListLocationTemp = component.get('v.ListLocationTemp');
		component.set('v.LocationID', ListLocationTemp[index].QAD_Location__c);
		component.set('v.LocationSearchName', ListLocationTemp[index].Rep_Name__c);
		component.set('v.displaySearchLocationList',false);
		helper.updateSearchValue(component);
	},
	//=================End of Search location===========================

	//=================Search Lot Number===========================
	SearchLotNo : function(component, event, helper) {
		var searchingLot = component.get('v.LotSearchName').toLowerCase().trim();
		var ListLot = component.get('v.ListLot');
		var ListLotTemp = [];
		var i = 0;

		if( searchingLot == '' ||  searchingLot == null )
        {
        	component.set('v.displaySearchLotList',false);
        	component.set('v.LotNo', '');
        }else
        {
			for(i=0; i<ListLot.length; i++){
				if(ListLot[i].Lot_Number__c != null)
					if(ListLot[i].Lot_Number__c.toLowerCase().search(searchingLot)>-1)
						ListLotTemp.push(ListLot[i]);			
			} 

			if(ListLotTemp.length == 0)
				component.set('v.displaySearchLotList',false);
			else
				component.set('v.displaySearchLotList',true);

	        component.set('v.ListLotTemp',ListLotTemp);       	
        }
	},

	SelectLotNo : function(component, event, helper) {
		var index = event.getSource().get('v.name');
		var ListLotNo = component.get('v.ListLotTemp');

		component.set('v.LotNo', ListLotNo[index].Lot_Number__c);
		component.set('v.LotSearchName', ListLotNo[index].Lot_Number__c);
		component.set('v.displaySearchLotList',false);
		component.set('v.SelectedItemNo', ListLotNo[index].Item_No__c);
		helper.updateSearchValue(component);
	},
	//=================End of Lot Number===========================

	updateReason : function(component, event, helper) {
		var Reason = component.get('v.TranReasonInput');
		component.set('v.TranReason', Reason);	
	},

	StartSearch : function(component, event, helper) {
		helper.updateSearchValue(component);
	},
})
// console.log("Create expense4: " + JSON.stringify(SearchLocation));