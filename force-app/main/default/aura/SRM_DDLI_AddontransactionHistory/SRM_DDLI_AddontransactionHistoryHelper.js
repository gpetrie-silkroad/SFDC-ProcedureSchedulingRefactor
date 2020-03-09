({
    initialTransction : function(component) 
    {
        var recordId = component.get("v.recordId");

        var action = component.get('c.recordType');

        action.setParams({
            "recordId": recordId
        });

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var result = response.getReturnValue(); //get return value
                component.set("v.type", result.TransReason__c);
                component.set("v.reason", result.Loc_Description__c);
                this.getTransactionHistory(component, result.Loc_Description__c)
            }else if(state === "ERROR")
            {
                let errors = response.getError();
                let errorMessage = 'Unknown error';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    errorMessage = errors[0].message;
                }
                // Display the message
                console.log(errorMessage);
                component.set("v.WaitingWindow", false);                   
                alert("Sorry, we have an error on checking recordID object. Please contact the SRM-SFDC administrator.");
            }else if(state === "INCOMPLETE")
            {
                component.set("v.WaitingWindow", false);
                alert("Look like Server is busy right now. Please try to refresh the page again. Thanks");
            }else
            {
                component.set("v.WaitingWindow", false);
                alert("Unexpected error - Please report this issue with the SRM-SFDC administrator.");
            }
        });

        //execute process
        $A.enqueueAction(action);           
    },

	getTransactionHistory : function(component, reason) 
	{
		var action = component.get('c.getTranHis');

		action.setParams({
            "reason": reason
        });

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var ListTransactionResult = response.getReturnValue(); //get return value
                component.set("v.ListTransactionResult", ListTransactionResult);
                component.set("v.WaitingWindow", false);
            }else if(state === "ERROR")
            {
                let errors = response.getError();
                let errorMessage = 'Unknown error';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    errorMessage = errors[0].message;
                }
                // Display the message
                console.log(errorMessage);
                component.set("v.WaitingWindow", false);                   
                alert("Sorry, we have an error on getting Account list. Please contact the SRM-SFDC administrator.");
            }else if(state === "INCOMPLETE")
            {
                component.set("v.WaitingWindow", false);
            	alert("Look like Server is busy right now. Please try to refresh the page again. Thanks");
            }else
            {
                component.set("v.WaitingWindow", false);
            	alert("Unexpected error - Please report this issue with the SRM-SFDC administrator.");
            }
        });

        //execute process
        $A.enqueueAction(action);        	
	},	
})
// console.log("Create expense8: " + JSON.stringify(result));