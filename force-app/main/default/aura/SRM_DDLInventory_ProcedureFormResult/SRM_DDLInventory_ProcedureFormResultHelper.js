({
	updateProcedureResult: function(component) {
		var locationID = component.get('v.LocationID');
		var lotno = component.get('v.LotNo');

		if( (locationID !== null & locationID !== '' & locationID !== ' ' & locationID !== undefined) 
			|| (lotno !== null & lotno !== '' & lotno !== ' ' & lotno !== undefined) ){
			var action = component.get('c.getProcedureResult');
	        action.setParams({
	            "employeeID": locationID,
	            "lotno": lotno
	        });
	        var self = this;
	        action.setCallback(this, function(actionResult) {
	            var result = actionResult.getReturnValue();
	            component.set('v.ListProcedureResult', result);
	            component.set('v.ListProcedureResultDefault', result);
	            component.set("v.WaitingWindow", false);
	        });
	        $A.enqueueAction(action);
	    }else
	    {
	    	component.set("v.WaitingWindow", false);
	    }
    },

	updateProcedureResultwithUserInput: function(component) {
		var UserInputCustomerName = component.get('v.UserInputCustomerName');
		var UserInputLotNo = component.get('v.UserInputLotNo');
		var isValidUserInputLotNo = true;
		var isValidcheckInputCustomerName = true;
		var errorMessage = '';

		if(UserInputCustomerName == null || UserInputCustomerName == '' || UserInputCustomerName == ' ' || UserInputCustomerName == undefined)
		{
			isValidcheckInputCustomerName = false;
			errorMessage = 'Invalid Customer Name\n';
			UserInputCustomerName = '%';
		}

		if(UserInputLotNo == null || UserInputLotNo == '' || UserInputLotNo == ' ' || UserInputLotNo == undefined)
		{
			isValidUserInputLotNo = false;
			errorMessage = errorMessage + 'Invalid Lot No\n';
			UserInputLotNo = '%';
		}

		if( isValidUserInputLotNo || isValidcheckInputCustomerName)
		{
			var action = component.get('c.getProcedureResultUserIn');
	        action.setParams({
	            "accountName": UserInputCustomerName,
	            "lotno": UserInputLotNo
	        });
	        var self = this;
	        action.setCallback(this, function(actionResult) {
	            var result = actionResult.getReturnValue();
	            component.set('v.ListProcedureResult', result);
	            component.set("v.WaitingWindow", false);
	        });
	        $A.enqueueAction(action);
	    }else
	    {
	    	alert(errorMessage);
	    	component.set("v.WaitingWindow", false);
	    }
    },
})