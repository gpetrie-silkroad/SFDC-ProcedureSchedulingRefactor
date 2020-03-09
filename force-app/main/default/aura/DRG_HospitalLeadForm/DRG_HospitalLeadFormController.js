({
	doInit: function(component, event, helper) {
        
      var device = $A.get("$Browser.formFactor");
      component.set('v.device', device);

              helper.showCitySelect(component);
              helper.getCurrentUser(component);
        	  helper.getPeriodHeaders(component);
              helper.getStateList(component);

    },
    
    refreshView : function(component,event,helper){
        
        component.set('v.selectedState', null);
        component.set('v.cityList', null);
        component.set('v.selectedCity', null);
        component.set('v.selectedCity1', null);
        component.set('v.parentNetworkList', null);
        component.set('v.selectedParentNetwork', null);
        component.set('v.drgPhysicianData', null);
        component.set('v.selectedDrgPhysician', null);
        component.set('v.procedureCountSet', null);
        component.set('v.proceduresByCity', null);
        component.set('v.proceduresByNetwork', null);
        component.set('v.proceduresByFacility', null);
        component.set('v.selectedFacility', null);
        component.set('v.facilityRecordId', null);
        component.set('v.facilityRecord', null);
        component.set('v.proceduresByPhysician', null);
        component.set('v.selectedPhysician', null);
        component.set('v.physicianRecordId', null);
        component.set('v.sortByProcedures', true);
        component.set('v.hideOpportunities', true);
        helper.getProceduresByCity(component);


        var action = component.get('c.doNothing');
        // your code to send contact details to server
        
        action.setCallback(this, function(action) {
            $A.get('e.force:refreshView').fire();
        });
         
        $A.enqueueAction(action);

 
    },
    
    
    
	updateState: function(component, event, helper) {
        
        component.set('v.selectedCity', null);
        component.set('v.selectedCity1', null);
        component.set('v.parentNetworkList', null);
        component.set('v.selectedParentNetwork', null);
        component.set('v.drgPhysicianData', null);
        component.set('v.selectedDrgPhysician', null);
        component.set('v.procedureCountSet', null);
        component.set('v.proceduresByCity', null);
        component.set('v.proceduresByNetwork', null);
        component.set('v.proceduresByFacility', null);
        component.set('v.selectedFacility', null);
        component.set('v.facilityRecordId', null);
        component.set('v.facilityRecord', null);
        component.set('v.proceduresByPhysician', null);
        component.set('v.selectedPhysician', null);
        component.set('v.physicianRecordId', null);
      	
        helper.getProceduresByCity(component);  
      	helper.showCitySelect(component);
    },  
    
    
    
    
    updateCity: function(component, event, helper) {
      helper.getProceduresByNetwork(component); 
    }, 
    
    
    
    
	updateParentNetwork: function(component, event, helper) {
      helper.getParentNetworkList(component);
    },
    
    
    
    
    
    updatePhysicianList: function(component, event, helper) {
    	helper.getPhysicianList(component);
    },
    
    
    
    
    doNothing: function(component, even, helper){},
    
    
    
    onCkboxSel: function(component, event, helper) {
        var checkValue = component.find("iCkbox"); 
        //var cityName = checkContact.get('v.text');
        //alert(cityName);

        for(var i=0; i<iCkbox.length; i++){
             iCkbox[i].set("v.value",true);
        }
        
    },

    
    
    
    
    citySelect : function(component,event,helper) {
        var elm = event.getSource();
        var selectedCity = elm.get("v.name");
        var selectedState = component.get("v.selectedState");

        component.set('v.selectedCity', selectedCity);
        console.log(elm);
        
        var pcwList = component.get('v.proceduresByCity');
        
        var action = component.get('c.setOnlyOneCity');

        action.setParams({
            "selectedState": selectedState,
            "selectedCity": selectedCity
        });

    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.proceduresByCity', actionResult.getReturnValue());
        });
        
      	helper.getProceduresByNetwork(component);
        
        $A.enqueueAction(action);
    },

    
    
    
    
    networkSelect : function(component,event,helper) {
        var elm = event.getSource();
        var selectedNetwork = elm.get("v.name");
        var selectedState = component.get("v.selectedState");
        var selectedCity = component.get("v.selectedCity");
        var hideHistory = component.get("v.hideHistory");
        
        var showHistory;
        if(hideHistory == true){ showHistory = true; } else { showHistory = false;}
        
        component.set('v.selectedParentNetwork', selectedNetwork);
        console.log(elm);
        
        var pcwList = component.get('v.proceduresByFacility');
        
        var action = component.get('c.setOnlyOneNetwork');
        //Set Parameters for Apex controller
        action.setParams({
            "selectedState": selectedState,
            "selectedCity": selectedCity,
            "selectedNetwork": selectedNetwork
        });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.proceduresByNetwork', actionResult.getReturnValue());
            
        });

      	helper.getProceduresByFacility(component);
        
        $A.enqueueAction(action);
    },
    
    
    
    
    
    facilitySelect : function(component,event,helper) {
        var elm = event.getSource();
        var selectedEntity = elm.get("v.name");
        var selectedFacilityRecordId = elm.get("v.text");
        var hideHistory = component.get("v.hideHistory");
        
        

        component.set('v.facilityRecordId', selectedFacilityRecordId);

        component.set('v.selectedFacility', selectedEntity);
        console.log(elm);
        
        var pcwList = component.get('v.proceduresByFacility');
        
        var action = component.get('c.setOnlyOneFacility');

        action.setParams({
            "selectedEntity": selectedEntity,
            "selectedFacilityRecordId": selectedFacilityRecordId,
        });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set("v.proceduresByFacility", actionResult.getReturnValue());
        });
        
      	helper.getProceduresByPhysician(component);
        helper.getFacilityRecord(component);
        $A.enqueueAction(action);
    },
    
    
    
    
    physicianSelect: function(component, event, helper){
        var elm = event.getSource();
        var selectedEntity = elm.get("v.name");
        var physicianRecordId = elm.get("v.text");
        
        component.set('v.physicianRecordId', physicianRecordId);
        component.set('v.selectedPhysician', selectedEntity);
        console.log(elm);
        
        var pcwList = component.get('v.proceduresByPhysician');
        var action = component.get('c.setOnlyOnePhysician');
        //Set Parameters for Apex controller
        action.setParams({
            //"selectedEntity": selectedEntity,
            "physicianRecordId" : physicianRecordId
        });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.proceduresByPhysician', actionResult.getReturnValue());
        });
        
      	//helper.getProceduresByPhysician(component);
      	
        helper.getPhysicianRecord(component);
        
        $A.enqueueAction(action);
    },
    
    
    
    convertFacilityLead: function(component, event, helper){
        var fId = component.get('v.facilityRecordId');
        var action1 = component.get('c.convertFacilityToOpportunity');
        var x;
        action1.setParams({
            "facilityRecordId" : fId
        });
        var self = this;
        action1.setCallback(this, function(actionResult) {
            component.set('v.newOpportunityId', actionResult.getReturnValue());
            x = component.get('v.newOpportunityId');
            var u = window.window.location.href;
        	u = "https://" + u.split("/")[2] + "/one/one.app#/sObject/" + x + "/view";
           
            var urlEvent = $A.get("e.force:navigateToURL");
    			urlEvent.setParams({
      				"url": u
    			});
    		urlEvent.fire();
                   
        });
        
        $A.enqueueAction(action1);
          
    },
    
    
    
    convertPhysicianLead: function(component, event, helper){
        var pId = component.get('v.physicianRecordId');
        var action = component.get('c.convertPhysicianToLead');
        action.setParams({
            "physicianRecordId" : pId
        });
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set('v.physicianRecord', actionResult.getReturnValue());
        });
        component.set('v.physicianRecordId', pId);
        helper.getPhysicianRecord(component);
        alert('Lead Created - please go to Leads Tab to manage your lead');
        
        
        $A.enqueueAction(action);
       
        var selectedEntity = component.get('v.selectedFacility');
        
        var pcwList = component.get('v.proceduresByPhysician');
        component.set('v.selectedPhysician', null);
        
        var action = component.get('c.setOnlyOneFacility');
        //Set Parameters for Apex controller
        action.setParams({
            "selectedEntity": selectedEntity,
        });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.proceduresByFacility', actionResult.getReturnValue());
        });
        	
      	helper.getProceduresByPhysician(component);
      
        $A.enqueueAction(action);
    },
    
    
    
    
    
    showSpinner: function(component, event, helper){
    	helper.showSpinner(component);
	},
    
    
    
    
    hideSpinner: function(component, event, helper){
    	helper.hideSpinner(component);
	},
    
    
    
    
    toggleSortByProcedures: function(component, event, helper){
    	var tf = component.get("v.sortByProcedures");
        var selectedCity = component.get("v.selectedCity");
        var selectedParentNetwork = component.get("v.selectedParentNetwork");
        var selectedFacility = component.get("v.selectedFacility");
        if(tf == true){
            component.set("v.sortByProcedures", false);
        }
        else{
            component.set("v.sortByProcedures", true);
        }
        
        if(selectedCity == null){
        	helper.getProceduresByCity(component);
        }
        else if(selectedParentNetwork == null){
        	helper.getProceduresByNetwork(component);    
        }
        else if(selectedFacility == null){
            helper.getProceduresByFacility(component);
        }
        else{
   			helper.getProceduresByPhysician(component);            
        }
    },




    toggleHideHistory: function(component, event, helper){
    	var tf = component.get("v.hideHistory");
        if(tf == true){
            component.set("v.hideHistory", false);
        }
        else{
            component.set("v.hideHistory", true);
        }
        
    },
    
    
    
    
    toggleHideOpportunities: function(component, event, helper){
    	var tf = component.get("v.hideOpportunities");
        var selectedCity = component.get("v.selectedCity");
        var selectedParentNetwork = component.get("v.selectedParentNetwork");
        var selectedFacility = component.get("v.selectedFacility");
        if(tf == true){
            component.set("v.hideOpportunities", false)
        }
        else{
            component.set("v.hideOpportunities", true);
        }
        
        if(selectedCity == null){
        	helper.getProceduresByCity(component);
        }
        else if(selectedCity != null) {
            //****************************************************************************************************************
            //**  FIGURE OUT WHAT TO DO IF OPTIONS WITH OPPORTUNITIES ARE SELECTED THEN THE HIDE OPPORTUNITIES ARE CLICKED
            //****************************************************************************************************************
        }
        else if(selectedParentNetwork == null){
        	helper.getProceduresByNetwork(component);    
        }
        else if(selectedFacility == null){
            helper.getProceduresByFacility(component);
        }
        else{
   			helper.getProceduresByPhysician(component);            
        }
        
    },
    
    
    
    
    toggleFacilitySearch: function(component, event, helper){
    	var tf = component.get("v.facilityLookup");
        if(tf == true){
            component.set("v.facilityLookup", false);
        }
        else{
            component.set("v.facilityLookup", true);
        }
    },
    
    
    
    
    partialSearch: function(component, event, helper){
    	var searchString = component.get("v.searchString");
        var sortByProcedures = component.get("v.sortByProcedures");
        var action = component.get("c.getProceduresByFacilityFromSearch");
        
        searchString = "%" + searchString + "%";
        
        
        //Set Parameters for Apex controller
        action.setParams({
            "searchString": searchString,
            "sortByProcedures": sortByProcedures
        });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set("v.proceduresByFacility", actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    }
    
    
    

})