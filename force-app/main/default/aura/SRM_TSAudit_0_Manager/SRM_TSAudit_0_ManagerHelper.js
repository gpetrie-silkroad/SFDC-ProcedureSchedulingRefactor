({
    checkcurrentTSAudit: function(component) 
    {
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is checking do you have any open Trunk Stock Audit.");
        var action = component.get('c.getTSCCountAudit');

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                component.set('v.TSCCount', result);
                this.getTSCCReports(component, result.Id);
                component.set('v.selectedTabId', 'CurrentTS');
            }else
            {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                // alert("SRM-SFDC Assistant can't find any open Trunk Stock Audit.");
                component.set('v.selectedTabId', 'NewTS');
                component.set("v.WaitingWindow", false);
            }
        });     
        $A.enqueueAction(action);
    },

    getTSAuditInfo: function(component, recordId) 
    {
        var action = component.get('c.getTSCCountInfo');

        action.setParams({
            "recordId": recordId
        });

        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting a TS audit info from the server.");

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                component.set('v.TSCCount', result);
                this.getTSCCReports(component, result.Id);
            }else
            {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                alert("error on getting TSAudit Info.");
                component.set("v.WaitingWindow", false);
            }
        });     
        $A.enqueueAction(action);       
    },

    getTSCCReports: function(component, recordId) 
    {
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting a TS audit reports info from the server.");

        var action = component.get('c.getTSCCReportInfo');

        action.setParams({
            "recordId": recordId
        });        

        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                component.set('v.TSCCReports', result);
                this.getTSCCReportsOptional(component, recordId);
            }else
            {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                alert("error on getting TSCC reports.");
                component.set("v.WaitingWindow", false);
            }            
        });     
        $A.enqueueAction(action);       
    },

    getTSCCReportsOptional: function(component, recordId) 
    {
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting a TS audit reports info from the server.");

        var action = component.get('c.getTSCCReportInfoOptional');

        action.setParams({
            "recordId": recordId
        });        

        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                component.set('v.TSCCReportsOption', result);
                component.set("v.WaitingWindow", false);
            }else
            {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                alert("error on getting TSCC reports.");
                component.set("v.WaitingWindow", false);
            }            
        });     
        $A.enqueueAction(action);       
    },

    getCurrentUserInfo : function(component, recordId)
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
                if(result.Profile.Name == 'System Administrator' || result.Profile.Name == 'SRM Customer Success Team')
                {
                    component.set("v.viewType", 1);
                    this.getTSAuditInfo(component, recordId);
                }else
                {
                    component.set("v.viewType", 0);
                    component.set("v.WaitingWindow", false);
                } 

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
                component.set("v.WaitingWindow", false);
            }
            
        });

        //execute process
        $A.enqueueAction(action);
    },
})
// console.log("javascript debug: " + JSON.stringify(result));