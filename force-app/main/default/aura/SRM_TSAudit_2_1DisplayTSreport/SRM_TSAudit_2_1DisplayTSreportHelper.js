({
	ViewDetail: function(component)
	{
		var TSCCReportID = component.get("v.TSCCReport.Id");
		var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": TSCCReportID,
            "slideDevName": "detail"
        });
    	navEvt.fire();
	},

	resetcount: function(component)
	{
		var TSCCReport = component.get("v.TSCCReport");

		//Reset the form
		TSCCReport.Count_Date__c = null;
		TSCCReport.Submitted__c = false;
		TSCCReport.Sent_reconciled_email__c = false;
		TSCCReport.Review_Date__c = null;
		TSCCReport.Status__c = 'Not Submitted';
		TSCCReport.Total_Unit_Discrepancies__c = null;
		TSCCReport.Total_Lot_Discrepancies__c = null;
		TSCCReport.Reviewer__c = null;

        var action = component.get('c.removeTSCCReportitems');

        action.setParams({
            "TSCCReport": TSCCReport
        });


        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
            	//Successfull reset the count
            	window.location.reload(true);
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
                alert("Sorry, we have an error on reseting the cycle count. Please contact the SRM-SFDC administrator.");
            }else if(state === "INCOMPLETE")
            {
                component.set("v.WaitingWindow", false);
                alert("Look like Server is busy right now. Please try to refresh the page and do it again. Thanks");
            }else
            {
                component.set("v.WaitingWindow", false);
                alert("Unexpected error - Please report this issue with the SRM-SFDC administrator.");
            }
            
        });

        //execute process
        $A.enqueueAction(action);  
	},

	deleteTrunkStockReport: function(component)
	{
		var TSCCReport = component.get("v.TSCCReport");

        var action = component.get('c.deleteTSCCR');

        action.setParams({
            "TSCCReport": TSCCReport
        });


        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
            	//Successfull delete the report
            	window.location.reload(true);
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
                alert("Sorry, we have an error on deleting the report. Please contact the SRM-SFDC administrator.");
            }else if(state === "INCOMPLETE")
            {
                component.set("v.WaitingWindow", false);
                alert("Look like Server is busy right now. Please try to refresh the page and do it again. Thanks");
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