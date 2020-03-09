({
	doInit : function(component, event, helper)
	{
		helper.getrepTDSInfo(component);
        helper.getCSUsers(component);

        var TSCCReport = component.get('v.TSCCReport');
        if(TSCCReport.Review_Date__c == null || TSCCReport.Review_Date__c == undefined )
        {
            var today = new Date();
            var year = today.getFullYear();
            var month = today.getMonth()+1;
            var date = today.getDate();
            TSCCReport.Review_Date__c = month + '/' + date + '/' + year;
            component.set('v.TSCCReport',TSCCReport);
        }

        //check user's device type - to customize display on screen
        var device = $A.get("$Browser.formFactor");
        component.set('v.devicetype', device);

        //Possible Under Reason
        var possibleUnderReason = new Array();
        possibleUnderReason.push('Missing ITForm.');
        possibleUnderReason.push('An ITForm unit is waiting for transacted.');
        possibleUnderReason.push('RMA unit is on the way/ is received.');
        possibleUnderReason.push('Unit was used as demo without paperwork.');
        possibleUnderReason.push('Unit was transacted to another rep/tds without paperwork.');
        possibleUnderReason.push('Miscount.');
        possibleUnderReason.push('Others.');
        component.set('v.possibleUnderReason', possibleUnderReason); 

        //Possible Over Reason
        var possibleOverReason = new Array();;
        possibleOverReason.push('An ITForm was submitted 2 times.');
        possibleOverReason.push('An ITForm was transacted 2 times.');
        possibleOverReason.push('Got a returned unit from customer.');
        possibleOverReason.push('Receiving an unit from another rep/tds without paperwork.');
        possibleOverReason.push('Miscount.');
        possibleOverReason.push('Others.');
        component.set('v.possibleOverReason', possibleOverReason);      
	},


	changeSelectedTab : function(component, event, helper)
	{
		var selectedTabId = event.getSource().get("v.selectedTabId");

		if(selectedTabId !== "TSDeepDive")//disable deep dive tab
		{
            var IsChangeSelectedTSCCItem = component.get("v.IsChangeSelectedTSCCItem");
            if(IsChangeSelectedTSCCItem)
            {
                component.set("v.IsChangeSelectedTSCCItem", false);
                helper.updateTSCCItemToserver(component);
                helper.updateTSCCItemToCachedArray(component);
            }

			component.set("v.DisplayDeepDive", false);
		}

        if(selectedTabId == "SendEmailToRepTDS")//Update notified email
        {
            component.set("v.WaitingWindow", true);
            component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is generating the email.");

            var EmailTemplate = component.get('v.EmailTemplate');
            var ToEmailAddress = component.get('v.ToEmailAddress');
            var CCEmailAddress = component.get('v.CCEmailAddress');
            var TSCCReport = component.get('v.TSCCReport');
            var TSCCItems = component.get("v.TSCCItems");
            var repTDSUser = component.get('v.repTDSUser');
            var emailbody = '';
            var i = 0;
            var url = location.href;

            if(ToEmailAddress == null || ToEmailAddress == undefined || ToEmailAddress == '')
            {
                ToEmailAddress = repTDSUser.Email;           
                component.set('v.ToEmailAddress', ToEmailAddress);
            }

            if(CCEmailAddress == null || CCEmailAddress == undefined || CCEmailAddress == '')
            {
                if(repTDSUser.Manager != null & repTDSUser.Manager != undefined)                
                    if(repTDSUser.Manager.Email != null & repTDSUser.Manager.Email != undefined & repTDSUser.Manager.Email !='')
                        CCEmailAddress = repTDSUser.Manager.Email;
                
                
                //Get CCEmailAddress & Email template
                helper.getCCEmailAddress(component, EmailTemplate, CCEmailAddress, TSCCReport, TSCCItems, repTDSUser, emailbody, i, url);
            }
        }
    },

    viewDeepDive: function(component, event, helper) {
    	var index = event.getSource().get("v.value");
    	var TSCCItems = component.get("v.TSCCItems");
		var UpdateTrigger = component.get("v.UpdateTrigger");

    	component.set("v.SelectedTSCCItem", TSCCItems[index]);
    	component.set("v.DisplayDeepDive", true);
    	component.set("v.selectedTabId", "TSDeepDive");
    	if(UpdateTrigger)
			component.set("v.UpdateTrigger", false);
		else
			component.set("v.UpdateTrigger", true);
    },

    onChangeSelectedTSCCItem: function(component, event, helper) {
        component.set("v.IsChangeSelectedTSCCItem", true);

        //recalculate delta
        var SelectedTSCCItem = component.get("v.SelectedTSCCItem");
        if(SelectedTSCCItem.Qty_on_system__c > SelectedTSCCItem.Counted_Qty__c)
        {
        	SelectedTSCCItem.difference__c = SelectedTSCCItem.Qty_on_system__c - SelectedTSCCItem.Counted_Qty__c;
        	SelectedTSCCItem.Different_Type__c = 'Under';
        }else if(SelectedTSCCItem.Qty_on_system__c < SelectedTSCCItem.Counted_Qty__c)
        {
        	SelectedTSCCItem.difference__c = SelectedTSCCItem.Counted_Qty__c - SelectedTSCCItem.Qty_on_system__c;
        	SelectedTSCCItem.Different_Type__c = 'Over';
        }else
        {
        	SelectedTSCCItem.difference__c = 0;
        	SelectedTSCCItem.Different_Type__c = '';
        }
        component.set("v.SelectedTSCCItem", SelectedTSCCItem);
    },

    updateTSCCItem: function(component, event, helper)
    {
    	component.set("v.IsChangeSelectedTSCCItem", false);
    	helper.updateTSCCItemToserver(component);
    	helper.updateTSCCItemToCachedArray(component);
    },

    closeWaitingPopUp: function(component, event, helper) {
        component.set("v.WaitingWindow", false);
    },

    changeTSCCHeader: function(component, event, helper) {
        component.set("v.IschangeTSCCHeader", true);
    },

    changeTSCCLineitems: function(component, event, helper) {
        component.set("v.IschangeTSCCDetail", true);
    },

    saveTSCCReport: function(component, event, helper) {
        var IschangeTSCCHeader = component.get("v.IschangeTSCCHeader");
        var IschangeTSCCDetail = component.get("v.IschangeTSCCDetail");

        if(IschangeTSCCHeader)
        {
            helper.updateTSCCReportHeader(component, IschangeTSCCDetail);
        }else if(IschangeTSCCDetail)
            helper.updateTSCCReportItems(component);
    },

    handleSelect : function (component, event, helper) {
        var stepName = event.getParam("detail").value;
        component.set('v.TSCCReport.Status__c',  stepName);
        component.set("v.IschangeTSCCHeader", true);
    },

    sendEmail : function (component, event, helper) {
        helper.sendEmailhelper(component);
    },

    changedSelectedTSCCItem :  function (component, event, helper) {
        helper.updatePreviousTSCCitem(component);
    },

    changedDisplayPreviousCount:  function (component, event, helper) {
        var activeSections = component.get("v.activeSections");
        activeSections.push('H');
        component.set('v.activeSections', activeSections);
    },
})
// console.log("javascript debug: " + JSON.stringify(TSCCItems));