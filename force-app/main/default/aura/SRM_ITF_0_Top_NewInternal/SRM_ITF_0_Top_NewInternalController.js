({
	doInit : function(component, event, helper) {
        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is initializing the ITF.");
        var myPageRef = component.get("v.pageReference");
        var ITFType = myPageRef.state.c__ITFType;

        //Check does the component is called by user press back button
        var ITForm = component.get('v.ITForm');
        if(ITForm.Id !== null && ITForm.Id !== undefined)
        {
            ITForm.Id = null;
            component.set('v.ITForm', ITForm);
        }

        if(ITFType == 'ReturnREPTS')
            helper.checkPendingTSreturn(component, ITFType);
        else
            helper.getCurrentUser(component, ITFType);

		//check user's device type - to customize display on screen
		var device = $A.get("$Browser.formFactor");
        component.set('v.device', device);
		if(device == 'DESKTOP')
			component.set('v.isDesktop','True');
		else
			component.set('v.isDesktop','False');	

        component.set('v.ITFType', ITFType);
        // if(ITFType == 'Demo')
        //     component.set('v.ITFHeader', 'Inventory Transfer Form - Demo');
        // else if(ITFType == 'ReturnREPTS')
        //     component.set('v.ITFHeader', 'Inventory Transfer Form - TS Return');

        //Reset all user choices
        var ITFTransactions = component.get('v.ITFTransactions');
        ITFTransactions = []
        component.set('v.ITFTransactions', ITFTransactions);
        if(ITFTransactions.length > 0)
        {
            reset = component.get('v.Reset');
            if(Reset)
                component.set('v.Reset', false);
            else
                component.set('v.Reset', true);
        }
	},
	
	closeWaitingPopUp: function(component, event, helper) {
        component.set("v.WaitingWindow", false);
    },

	submit: function(component, event, helper) {
		component.set("v.WaitingWindow", true);
        var ITFTransactions = component.get('v.ITFTransactions');
        var currentUser = component.get('v.currentUser');
        var ITForm = component.get('v.ITForm');
        var submittedlist = [];
        var summaryUsedItem = '';
        var unsubmittedlist = [];
        var runsubmithelper = false;
        var i = 0;

        for(i=0; i < ITFTransactions.length; i++)
        {
        	if(ITFTransactions[i].Lot_number__c !== "===Choose Lot #===" && ITFTransactions[i].Lot_number__c !== "Please select product # first")
        	{
        		if(ITFTransactions[i].Quantity__c > 0 )
                {
                    summaryUsedItem += ITFTransactions[i].Quantity__c.toString() + '-' + ITFTransactions[i].Product_Number__c+',';
                    ITFTransactions[i].Bill_Only_Number__c = ITForm.Primary_Bill_Only_Number__c;
                    ITFTransactions[i].UOM__c = 'EA';
                    ITFTransactions[i].Price__c = 0;
                    ITFTransactions[i].ITF_Transaction_ID__c = 'ITFDemo-'+ currentUser.Employee_ID__c + '-' + ITForm.ITF_ID__c.substring(0,20) + '-' + ITFTransactions[i].Lot_number__c;
                    if(ITFTransactions[i].ITF_Transaction_ID__c.length > 49)
                        ITFTransactions[i].ITF_Transaction_ID__c = ITFTransactions[i].ITF_Transaction_ID__c.substring(0,49);
        			submittedlist.push(ITFTransactions[i]);
                }
        		else
                {
        			unsubmittedlist.push(ITFTransactions[i]);
                }
        	}
        }

        if(submittedlist.length < 1)
        {
        	alert('Sorry, we cannot create an ITF - Error: no valid transaction.\nNote: we need at least 1 line item which has quantity more than 0 to submit the form');
        }
        else if(unsubmittedlist.length > 0)
        {
            var warningMessage = '';
            warningMessage = 'The line(s) below will be deleted because of zero quantity.\n';
        	for(i=0; i < unsubmittedlist.length; i++)
        		warningMessage += '     +'+ unsubmittedlist[i].Product_Number__c + ' - ' + unsubmittedlist[i].Lot_number__c + '\n';
        	warningMessage += 'Do you want to continue to submit the form without the line(s)?\n';

        	var choice = confirm(warningMessage);
        	if(choice)
        		runsubmithelper = true;        		
        }
        else
            runsubmithelper = true;        	

        if(runsubmithelper)
        {
            if(summaryUsedItem.length > 250)
                ITForm.Summary_Used_Item__c = summaryUsedItem.substring(0,250) + '...';
            else
                ITForm.Summary_Used_Item__c = summaryUsedItem.substring(0,summaryUsedItem.length-1);
            helper.submitITFDemo(component, ITForm, submittedlist);
        }
        else
            component.set("v.WaitingWindow", false);

    },
})
// console.log("javascript debug: " + JSON.stringify(LookUpTDSValue));