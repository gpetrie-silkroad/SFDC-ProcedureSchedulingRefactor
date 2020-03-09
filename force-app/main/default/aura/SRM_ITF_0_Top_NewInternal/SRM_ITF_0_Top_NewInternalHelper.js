({
    checkPendingTSreturn: function(component, ITFType)
    {
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is checking your pending trunk stock return.");
        var action = component.get('c.checkPendingTrunkStockReturn');

        // Set up the callback
        var self = this;
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
console.log("javascript debug: it is running");    
                if(result == null || result == undefined || result == '')
                {
                    this.getCurrentUser(component, ITFType);                
                }
                else
                {
                    alert("Sorry, you cannot create a new trunk stock return. You have one open trunk stock return please update the trunk stock return before creating a new one.\nYou will be redirected into the open trunk stock return.");
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": result,
                        "slideDevName": "detail"
                    });
                    navEvt.fire();
                }
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
                alert("Sorry, we have an error on getting pending trunk stock return. Please contact the SRM-SFDC administrator.");
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
        $A.enqueueAction(action);
    },

  	getCurrentUser: function(component, ITFType)
  	{
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting User Info.");
    	var action = component.get('c.getCurrentUser');

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS")
            {
	    		var result = response.getReturnValue();
	    		component.set('v.currentUser', result);
                this.getUserInventory(component, result, ITFType);
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
                alert("Sorry, we have an error on getting current user Info. Please contact the SRM-SFDC administrator.");
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
        $A.enqueueAction(action);
    },

    getUserInventory: function(component, userinfo, ITFType)
    {
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting User Inventory.");
        var action = component.get('c.getLotInventory');

        action.setParams({
          "owner": userinfo.Name
        });        

        // Set up the callback
        var self = this;
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                component.set('v.userInventory', result);
                this.updateITFdefault(component, userinfo, ITFType);
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
                alert("Sorry, we have an error on getting current user Info. Please contact the SRM-SFDC administrator.");
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
        $A.enqueueAction(action);
    },

    updateITFdefault: function(component, result, ITFType)
    {
    	var ITF = component.get('v.ITForm');
 
    	if(result.Field_Responsibility__c == 'Area Manager')
    		ITF.SRM_AM__c = result.Id;
    	else if(result.Field_Responsibility__c == 'Area Manager')
    		ITF.SRM_TDS__c = result.Id;
    	else
    		ITF.Other_Qualified_SRM_Employee__c = result.Id;

		//Get Currenttime
		var today = new Date();
		var year = today.getFullYear();
		var month = today.getMonth()+1;
		if(month <=9)
			month = '0'+ month;

		var date = today.getDate();
		if(date <=9)
			date = '0'+ date;
		var hours = today.getHours();
		if(hours <=9)
			hours = '0'+ hours;
		var minutes = today.getMinutes();
		if(minutes <=9)
			minutes = '0'+ minutes;
		var seconds = today.getSeconds();
		if(seconds <=9)
			seconds = '0'+ seconds;
		
		var currenttime = year + '.' + month + '.' + date + '.' +'T'+ hours + '.' + minutes + '.' + seconds;
		ITF.Transfer_Date__c = year + "-" + month + "-" + date;
        ITF.AutoSaveCopy__c = false;
        ITF.Primary_Bill_Only_Number__c = result.FirstName[0] + result.LastName[0] + month + date + year.toString().substring(2,4);
        // ITF.SentClosedITFEmail__c = false;
        ITF.ITF_Type__c = 'Internal Transfer (AM/TDS to AM/TDS)';
        ITF.From_Rep_TDS__c = result.FirstName + ' ' + result.LastName;

        if(ITFType == 'Demo')
        {
            ITF.To_Rep_TDS__c = 'Demo';
            ITF.ITF_ID__c = currenttime + '-' + result.LastName + ',' + result.FirstName + '-Demo';
            ITF.Status__c = 'Transacted Inventory/Verification';
            ITF.EditableByRepTDS__c = false;
            // ITF.SendEmailToCS__c = true;
        }else if(ITFType == 'ReturnREPTS')
        {
            ITF.To_Rep_TDS__c = 'FG (Trunk Stock Return)';
            ITF.ITF_ID__c = currenttime + '-' + result.LastName + ',' + result.FirstName + '-TSReturn';
            ITF.Status__c = 'Shipment Information';
            ITF.EditableByRepTDS__c = true;
            // ITF.SendEmailToCS__c = false;
            // ITF.SentTSReturnInstruction__c = true;
        }

        ITF.Name = ITF.ITF_ID__c;

    	component.set('v.ITForm', ITF);
    	component.set("v.WaitingWindow", false);
    },

    submitITFDemo: function(component, ITForm, submittedlist)
    {
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is submitting your form on SFDC.");
        var action = component.get('c.upsertCompleteITF');

        action.setParams({
          "ITF": ITForm,
          "ITFTransactions": submittedlist
        });        

        // Set up the callback
        var self = this;
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                //Get error on creating MTF copy when upserting new ITF
                ITForm.Id = result;
                this.continuedtoaddMTFcopy(component, ITForm);
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
                alert("Sorry, we have an error on submitting the form. Please contact the SRM-SFDC administrator.");
            }else if(state === "INCOMPLETE")
            {
                component.set("v.WaitingWindow", false);
                alert("Look like Server is busy right now. Please try to press 'Submit' button again. Thanks");
            }else
            {
                component.set("v.WaitingWindow", false);
                alert("Unexpected error - Please report this issue with the SRM-SFDC administrator.");
            }
        });
        $A.enqueueAction(action);
    },

    continuedtoaddMTFcopy: function(component, ITForm)
    {
        // if(ITForm.To_Rep_TDS__c == 'FG (Trunk Stock Return)')
        // {
        //     ITForm.SentTSReturnInstruction__c = false;
        // }

        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is submitting your form on SFDC.");
        var action = component.get('c.createMTFPDFcopy');

        action.setParams({
          "ITF": ITForm
        });        

        // Set up the callback
        var self = this;
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();

                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": result,
                    "slideDevName": "detail"
                });
                navEvt.fire();

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
                alert("Sorry, we have an error on creating MTF copy. Please contact the SRM-SFDC administrator.");
            }else if(state === "INCOMPLETE")
            {
                component.set("v.WaitingWindow", false);
                alert("Look like Server is busy right now. Please try to press 'Submit' button again. Thanks");
            }else
            {
                component.set("v.WaitingWindow", false);
                alert("Unexpected error - Please report this issue with the SRM-SFDC administrator.");
            }
        });
        $A.enqueueAction(action);
    },
})
// console.log("javascript debug: " + JSON.stringify(LookUpTDSValue));