({
	updateOnHandQty : function(component) {
		var onhandlist = component.get('v.ListOnHandQty');
		var index = component.get('v.index');
		var tracking = component.get('v.transaction.TrackingNo__c');

		component.set('v.onHandQty', onhandlist[index]);
		if(tracking !== null & tracking !== undefined){
			tracking = tracking.replace(/\s/g,'');
			component.set('v.editTrackNo', tracking);
		}
	},

	updateDateColorCode : function(component) {
		var submittedDate = component.get('v.submittedDate');
		var transaction = component.get('v.transaction')


		if(submittedDate != null & submittedDate != undefined)
		{
			if(submittedDate > transaction.TransferDate__c)
				component.set('v.IsAfterCountDate', false);
			else
				component.set('v.IsAfterCountDate', true);			
		}else
			component.set('v.IsAfterCountDate', false);
	},
})