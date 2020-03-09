({
	doInit: function(component, event, helper)
	{
        component.set("v.WaitingWindow", true);
		var recordId = component.get("v.recordId");
		if(recordId == null)
		{
            helper.checkcurrentTSAudit(component);
            component.set("v.viewType", 1);
		}else
		{
            component.set('v.selectedTabId', 'CurrentTS');
            helper.getCurrentUserInfo(component, recordId);
		}
	},

    closeWaitingPopUp: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "False"  
        component.set("v.WaitingWindow", false);
    },
})
// console.log("javascript debug: " + JSON.stringify(LookUpTDSValue));