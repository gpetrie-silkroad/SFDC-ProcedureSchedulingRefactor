({
	doInit: function(component, event, helper){
        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is initializing the proctor form.");
        helper.getPhysicianInfo(component);

        //Get device type: DESKTOP, PHONE and TABLET
        var device = $A.get("$Browser.formFactor");
        component.set('v.devicetype', device);        
	},

    closeWaitingPopUp: function(component, event, helper) {
        component.set("v.WaitingWindow", false);
    },

    SubmitProctorForm: function(component, event, helper) {
    	component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is saving the proctor form into the SFDC server.");
        var isvalid = helper.checkPRFvalid(component);
        if(isvalid)
            helper.submitPRForm(component);
        else
            component.set("v.WaitingWindow", false);
    },

    selectedTESLAChange: function(component, event, helper) {
        var selectedTESLA = component.get("v.selectedTESLA");

        if(selectedTESLA)
        {
            component.set("v.selectedProctor", false);
            component.set("v.selectedBoth", false);

            //Remove selected Exception to TEST Drive
            var PRF = component.get("v.PRF");
            if(PRF.Reason_for_Proctoring__c == "Exception to TEST Drive")
            {
                PRF.Reason_for_Proctoring__c = null;
                component.set("v.PRF", PRF);
            }            
        }

        var reasonlist = ["Selected - None","90+ days past TEST Drive","Hospital Mandated"];
        component.set("v.ProctoringReason", reasonlist);
    },

    selectedProctorChange: function(component, event, helper) {
        var selectedProctor = component.get("v.selectedProctor");

        if(selectedProctor)
        {
            component.set("v.selectedTESLA", false);
            component.set("v.selectedBoth", false);
        }

        var reasonlist = ["Selected - None","90+ days past TEST Drive","Exception to TEST Drive","Hospital Mandated"];
        component.set("v.ProctoringReason", reasonlist);
    },

    selectedBothChange: function(component, event, helper) {
        var selectedBoth = component.get("v.selectedBoth");

        if(selectedBoth)
        {
            component.set("v.selectedTESLA", false);
            component.set("v.selectedProctor", false);

            //Remove selected Exception to TEST Drive
            var PRF = component.get("v.PRF");
            if(PRF.Reason_for_Proctoring__c == "Exception to TEST Drive")
            {
                PRF.Reason_for_Proctoring__c = null;
                component.set("v.PRF", PRF);
            }  
        }

        var reasonlist = ["Selected - None","90+ days past TEST Drive","Hospital Mandated"];
        component.set("v.ProctoringReason", reasonlist);
    },
})
// console.log("javascript debug: " + JSON.stringify(LookUpTDSValue));