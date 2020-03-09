({
	getCurrentUserInfo : function(component)
	{
		var action = component.get('c.getCurrentUser');

		component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting User Info.");

		action.setCallback(this, function(response)
		{
	        var state = response.getState();

	        if (state === "SUCCESS") 
	        {
	            var result = response.getReturnValue(); //get return value
	            component.set("v.currentUser", result);

	        }else
	        {
	        	alert("error on getting User Info. Please check your Internet Connection.");
        		let errors = response.getError();
	            let errorMessage = 'Unknown error';
	            if (errors && Array.isArray(errors) && errors.length > 0) {
	                errorMessage = errors[0].message;
	            }
	            // Display the message
	            console.error(errorMessage);
	        }
	        component.set("v.WaitingWindow", false);
	    });

	    //execute process
	    $A.enqueueAction(action);
	},

	gettingTSCCInfo : function(component)
	{
		var recordId = component.get("v.recordId");
		if(recordId == null)
		{
			recordId = 'N/A';
		}

		var action = component.get('c.getPendingTSCC');
	    action.setParams({
        		"TSCCReportId": recordId
        });

		component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is checking your pending TSCCount.");

		action.setCallback(this, function(response)
		{
	        var state = response.getState();

	        if (state === "SUCCESS") 
	        {
	            var result = response.getReturnValue(); //get return value

	            if(result.Id == null)
	            {
	            	component.set("v.status", 0);
	            }else
	            {
	            	component.set("v.TSCCReport", result);
	            	if(result.Submitted__c)
	            		component.set("v.status", 2);
	            	else
	            		component.set("v.status", 1);
	            }
	        }else
	        {
	        	alert("error on finding a Pending TSCCount.");
        		let errors = response.getError();
	            let errorMessage = 'Unknown error';
	            if (errors && Array.isArray(errors) && errors.length > 0) {
	                errorMessage = errors[0].message;
	            }
	            // Display the message
	            console.error(errorMessage);
	        }
	        component.set("v.WaitingWindow", false);
	    });

	    //execute process
	    $A.enqueueAction(action);
	},

	gettingTSCCItems : function(component)
	{
		component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting detail counted items of the report.");

		var TSCCReport = component.get("v.TSCCReport");
		var action = component.get('c.getTSCCReportItemInfo');
	    action.setParams({
        		"recordId": TSCCReport.Id
        });		


		action.setCallback(this, function(response)
		{
	        var state = response.getState();

	        if (state === "SUCCESS") 
	        {
	            var result = response.getReturnValue(); //get return value
	            component.set("v.TSCCItems", result);
	        }else
	        {
	        	alert("error on getting info of counted items");
        		let errors = response.getError();
	            let errorMessage = 'Unknown error';
	            if (errors && Array.isArray(errors) && errors.length > 0) {
	                errorMessage = errors[0].message;
	            }
	            // Display the message
	            console.error(errorMessage);
	        }
	        component.set("v.WaitingWindow", false);
	    });

	    //execute process
	    $A.enqueueAction(action);
	},
})

// console.log("javascript debug: " + JSON.stringify(result));