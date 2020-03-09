({
	doInit: function(component, event, helper)
	{
		component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is initializing data.");
		var TSCCReports = component.get("v.TSCCReports");
		var i = 0;
		var selectedList = [];
		for(i=0; i<TSCCReports.length ; i++)
		{
			if(TSCCReports[i].Submitted__c == true)
			{
				selectedList.push(false);
			}else{
				selectedList.push(true);
			}			
		}

		component.set("v.selectedList", selectedList);
		component.set("v.updatedselectedList", true);
		helper.getEmailTemplate(component);
		helper.getRepTDSList(component);

		//Initialize CC users
		helper.getCCAddress(component);

		//Get origin url
		var currentLocation = window.location;
		component.set("v.URLOrigin", currentLocation.origin);
	},

	saveEmailTemplate: function(component, event, helper)
	{
		helper.saveEmail(component);
	},

    closeWaitingPopUp: function(component, event, helper) {
        component.set("v.WaitingWindow", false);
    },

	RemoveSelectedUsers: function(component, event, helper)
	{
		var selectedlist = component.get("v.selectedList");
		var i = 0;

		for( i=0; i<selectedlist.length; i++)
		{
			selectedlist[i] = false;
		}

		//trigger for child to update selected
		component.set("v.selectedList", selectedlist);
		if(component.get("v.updatedselectedList"))
			component.set("v.updatedselectedList", false);
		else 
			component.set("v.updatedselectedList", true);
	},

	SelectRepTDSnotSubmitted: function(component, event, helper)
	{
		var selectedlist = component.get("v.selectedList");
		var TSCCReports = component.get("v.TSCCReports");
		var i = 0;

		for( i=0; i<selectedlist.length; i++)
		{
			if(TSCCReports[i].Submitted__c)
				selectedlist[i] = false;
			else
				selectedlist[i] = true;
		}

		//trigger for child to update selected
		component.set("v.selectedList", selectedlist);
		if(component.get("v.updatedselectedList"))
			component.set("v.updatedselectedList", false);
		else 
			component.set("v.updatedselectedList", true);
	},	

	sendEmailToSelectedUser: function(component, event, helper)
	{
		helper.sendEmailTorepTDS(component);
	},

    updateTotalSelectedUSers: function(component, event, helper) {
        var selectedlist = component.get("v.selectedList");
        var totalslect = 0;
        var i = 0;

        for( i=0; i<selectedlist.length; i++)
        {
        	if(selectedlist[i])
        		totalslect++;
        }
        component.set("v.totalSelectedUser", totalslect);
    },

    updateProgress: function(component, event, helper)
	{
		helper.updateTSAHeader(component);
	},
})
// console.log("javascript debug: " + JSON.stringify(TSCCReports));