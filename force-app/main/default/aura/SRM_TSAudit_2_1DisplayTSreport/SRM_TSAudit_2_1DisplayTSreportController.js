({
    handleSelect: function (component, event, helper)
    {
    	var TSCCReport = component.get("v.TSCCReport");
        var selectedMenuItemValue = event.getParam("value");

        if(selectedMenuItemValue == 'OpenTSAReport')
        	helper.ViewDetail(component);
        else if(selectedMenuItemValue == 'ResetTSAReport')
        {
        	var warningMessage = TSCCReport.Name + " has been submitted his/her count. " + TSCCReport.Name__c;
        	warningMessage += "need to do cycle count again if you reset his count.\n";
        	warningMessage += "Do you want to continue to reset the count?";
        	var choice = confirm(warningMessage);

        	if(choice)
        	{
        		component.set("v.WaitingWindow", true);
        		component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant will be deleted the count on the SFDC.");
        		helper.resetcount(component);
        	}
        }
       	else if(selectedMenuItemValue == 'DeleteTSAReport')
       	{
        	var warningMessage = "After you delete the trunk stock audit report, " + TSCCReport.Name__c;
        	warningMessage += " can't do cycle count and his/her trunk will be excluded for this trunk stock audit.\n";
        	warningMessage += "Do you want to continue to delete the trunk stock report?";
        	var choice = confirm(warningMessage);

        	if(choice)
        	{
        		component.set("v.WaitingWindow", true);
        		component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant will be deleted the report on the SFDC.");
        		helper.deleteTrunkStockReport(component);
        	}
       	}
    },

	updatedSelectedfromParent: function(component, event, helper)
	{
		var index = component.get("v.index");
		var selectedList = component.get("v.selectedList");

		component.set("v.selected", selectedList[index]);
	},

	updatedSelectedList: function(component, event, helper)
	{
		var index = component.get("v.index");
		var selectedList = component.get("v.selectedList");
		var selected = component.get("v.selected");

		selectedList[index] = selected;

		component.set("v.selectedList", selectedList);
	},
})