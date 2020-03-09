({
	doInit: function(component, event, helper){
        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting transaction history of this records on SFDC Server.");
		helper.initialTransction(component);
	},

    closeWaitingPopUp: function(component, event, helper) {
        component.set("v.WaitingWindow", false);
    },

    search: function(component, event, helper) {
        component.set("v.WaitingWindow", true);
        var reason = component.get("v.reason");
        helper.getTransactionHistory(component, reason);
    },
})