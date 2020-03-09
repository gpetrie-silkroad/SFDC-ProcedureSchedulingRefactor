({
	updateProceResult : function(component, event, helper) 
	{
		component.set("v.WaitingWindow", true);
		helper.updateProcedureResult(component);
		var lotnumber = component.get('v.LotNo');
		component.set('v.UserInputLotNo', lotnumber);
	},

	Search : function(component, event, helper) 
	{
		component.set("v.WaitingWindow", true);
		helper.updateProcedureResultwithUserInput(component);
		component.set('v.searchtype', true);
	},

	Reset : function(component, event, helper) 
	{
		var ListProcedureResult = component.get('v.ListProcedureResultDefault');
		component.set('v.ListProcedureResult', ListProcedureResult);
		component.set('v.searchtype', false);
	},

	closeWaitingPopUp: function(component, event, helper) {
        component.set("v.WaitingWindow", false);
    },
})