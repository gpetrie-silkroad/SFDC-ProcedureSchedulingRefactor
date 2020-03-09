({
	getITFresult: function(component) {
		var LocationID = component.get('v.LocationID');
		var lotno = component.get('v.LotNo');

		if(LocationID == undefined || LocationID == null)
		{
			alert("Missing Employee ID. Please contact SFDC administration to update employeeID to search ITF correctly");
			LocationID = 'N/A';
		}
		if( (LocationID.includes("SRM")) 
			& (lotno !== null || lotno !== '') ){
			var action = component.get('c.getInventoryTransferFormResult');
	        action.setParams({
	            "employeeID": LocationID,
	            "lotno": lotno
	        });

	        action.setCallback(this, function(actionResult) {
	            var result = actionResult.getReturnValue();
	            component.set('v.listITF', actionResult.getReturnValue());

	            var activeSections = component.get('v.activeSections');
	            var index = activeSections.indexOf('I');
	            if((result == null || result.length ==0)  & index > -1)
	            {
	            	activeSections.splice(index,1);
	            }

	            if(result !== null & result.length !==0  & index == -1)
	            {
	            	activeSections.push('I');
	            	component.set('v.activeSections',activeSections);
	            }
	        });
	        $A.enqueueAction(action);
	    }
    },
})