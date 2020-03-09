({
	initial : function(component, event, helper) {
		var Viewmode = component.get('v.Viewmode');

		if( Viewmode == 1 || Viewmode == 0)
			component.set('v.Viewall', false);

		helper.getTransResult(component);
	},

	updateTransactionResult : function(component, event, helper) {
		helper.getTransResult(component);
	},

	updateOnHandQty : function(component, event, helper) {
		var transactions = component.get('v.ListTransactionResult');

		var onHandQty = [];
		var total = 0;

		for(var i=0; i < transactions.length; i++ ){
			if(transactions[i].TranInOut__c == 'OUT')
				total = total - transactions[i].TranQuan__c;
			else
				total = total + transactions[i].TranQuan__c;
			onHandQty.push(total);
		}
		component.set("v.ListOnHandQty", onHandQty);
		component.set("v.TotalQty", total);

		//Update list transaction lite
		if(component.get('v.UpdateListTranLite'))
			component.set('v.UpdateListTranLite',false);
		else
			component.set('v.UpdateListTranLite',true);
	},

	downloadCsv : function(component,event,helper){        
	    // get the Records [contact] list from 'ListOfContact' attribute 
	    var data1 = component.get("v.ListTransactionResult");
	    var data2 = component.get("v.ListOnHandQty");
        var lotNo = component.get("v.LotNo");
        var locationID = component.get("v.LocationID");
        var keys = ['Transfer Date','Qty In','Qty Out','On Hand','Ref #', 'Ship To/Delivery To', 'Reason'];  
	    var csv = helper.convertArrayOfObjectsToCSV(component, data1, data2, keys, lotNo, locationID);   
	    
        if (csv == null){return;} 
       	// ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
	    var hiddenElement = document.createElement('a');
	    hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
	    hiddenElement.target = '_self'; //
        var name = locationID+' - '+lotNo+' - Transactions History'+'.csv';
	    hiddenElement.download = name;  // CSV file Name* you can change it.[only name not .csv] 
	    document.body.appendChild(hiddenElement); // Required for FireFox browser
		hiddenElement.click(); // using click() js function to download csv file
    },

    downloadCsvLite : function(component,event,helper){        
	    // get the Records [contact] list from 'ListOfContact' attribute 
	    var data1 = component.get("v.ListTransactionResultLite");
	    var data2 = component.get("v.ListOnHandQty");
        var lotNo = component.get("v.LotNo");
        var locationID = component.get("v.LocationID");
        var keys = ['Transfer Date','Qty In','Qty Out','On Hand','Ref #', 'Ship To/Delivery To', 'Reason'];  
	    var csv = helper.convertArrayOfObjectsToCSV(component, data1, data2, keys, lotNo, locationID);   
	    
        if (csv == null){return;} 
       	// ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
	    var hiddenElement = document.createElement('a');
	    hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
	    hiddenElement.target = '_self'; //
        var name = locationID+' - '+lotNo+' - Transactions History'+'.csv';
	    hiddenElement.download = name;  // CSV file Name* you can change it.[only name not .csv] 
	    document.body.appendChild(hiddenElement); // Required for FireFox browser
		hiddenElement.click(); // using click() js function to download csv file
    },

	saveTransaction : function(component,event,helper){
		var IsChange = component.get('v.IsChange');
		IsChange = false;
		component.set('v.IsChange', IsChange);
		helper.saveTran(component);

		//Update list transaction lite
		if(component.get('v.UpdateListTranLite'))
			component.set('v.UpdateListTranLite',false);
		else
			component.set('v.UpdateListTranLite',true);
    }, 

    switchView : function(component,event,helper){
		var view = component.get('v.Viewall');

		if(view)
		{
			component.set('v.Viewall',false);
		}else
		{
			component.set('v.Viewall',true);
		}
    }, 

	UpdatingListTranLite : function(component, event, helper) {
		var transactions = component.get('v.ListTransactionResult');

		var onHandQty = [];
		var transactionstemp = [];
		var total = 0;

		for(var i=0; i < transactions.length; i++ ){
			if(transactions[i].IsDisplayed__c)
			{
				transactionstemp.push(transactions[i]);

				if(transactions[i].TranInOut__c == 'OUT')
					total = total - transactions[i].TranQuan__c;
				else
					total = total + transactions[i].TranQuan__c;
				onHandQty.push(total);
			}
		}
		component.set("v.ListOnHandQtyLite", onHandQty);
		component.set("v.ListTransactionResultLite", transactionstemp);
		component.set("v.TotalQtyLite", total);
	},

})


// console.log("Create expense7: " + JSON.stringify(onHandQty));