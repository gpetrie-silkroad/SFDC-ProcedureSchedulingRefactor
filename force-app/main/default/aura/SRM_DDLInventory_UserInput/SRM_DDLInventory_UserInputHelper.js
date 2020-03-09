({
	getLocList : function(component) {
		var action = component.get('c.getLocationList');
    	var self = this;
    	action.setCallback(this, function(actionResult) {
    		var result = actionResult.getReturnValue();

            //add users not on SFDC
            result.push({'sobjectType':'Location__c','Rep_Name__c': 'Stewart Kume', 'QAD_Location__c': 'TS-SKUME'});
            result.push({'sobjectType':'Location__c','Rep_Name__c': 'Christa Lafontaine', 'QAD_Location__c': 'TS-TDS-CLAFONTANE'});
            result.push({'sobjectType':'Location__c','Rep_Name__c': 'Noelle Lemonds', 'QAD_Location__c': 'TS-NLEMONDS'});
    		component.set('v.ListLocation', result);
        });
        $A.enqueueAction(action);
	},

    getLotList : function(component) {
        var action = component.get('c.getLotNoList');

        var self = this;
        action.setCallback(this, function(actionResult) {
            var result = actionResult.getReturnValue();
            component.set('v.ListLot', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },

    updateSearchValue: function(component)
    {
        var UpdateTrigger = component.get('v.UpdateTrigger');

        // var Reason = component.get('v.TranReasonInput');
        var auraInputReason = component.find("ReasonInput");
        var inputReasonValue = auraInputReason.get('v.value');
        component.set('v.TranReason', inputReasonValue);

        // var SearchLocationInput = component.find("SearchLocationInput");
        // var SearchLocationInputValue = SearchLocationInput.get('v.value');
        // component.set('v.LocationID', SearchLocationInputValue);

        var SearchLotInput = component.find("SearchLotInput");
        var SearchLotInputValue = SearchLotInput.get('v.value');
        component.set('v.LotNo', SearchLotInputValue.toUpperCase().trim());

        if(UpdateTrigger)
            component.set('v.UpdateTrigger', false);    
        else
            component.set('v.UpdateTrigger', true);
    }
})