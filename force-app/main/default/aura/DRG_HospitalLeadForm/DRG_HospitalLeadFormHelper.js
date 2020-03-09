({
    //********************************************************************************************************************************
    // Fetch the currentUserRecord from the Apex controller
    //********************************************************************************************************************************
  	getCurrentUser: function(component) {
    	var action = component.get('c.getCurrentUser');

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.currentUser', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
 

    getPeriodHeaders: function(component){
    	var action4 = component.get('c.getPd4');
    	var self = this;
    	action4.setCallback(this, function(actionResult) {
     		component.set('v.pd4Hdr', actionResult.getReturnValue());
        });
        $A.enqueueAction(action4)
        
        var action3 = component.get('c.getPd3');
    	var self = this;
    	action3.setCallback(this, function(actionResult) {
     		component.set('v.pd3Hdr', actionResult.getReturnValue());
        });
        $A.enqueueAction(action3)
        
        var action2 = component.get('c.getPd2');
    	var self = this;
    	action2.setCallback(this, function(actionResult) {
     		component.set('v.pd2Hdr', actionResult.getReturnValue());
        });
        $A.enqueueAction(action2)
        
        var action1 = component.get('c.getPd1');
    	var self = this;
    	action1.setCallback(this, function(actionResult) {
     		component.set('v.pd1Hdr', actionResult.getReturnValue());
        });
        $A.enqueueAction(action1)
	},

    
    
    
    
	//********************************************************************************************************************************    
    // Fetch the DRG Facility List from the Apex controller
    //********************************************************************************************************************************
  	getDrgFacilityList: function(component) {
        var state = component.get('v.selectedState');
        var city = component.get('v.selectedCity');
        var parentNetworkName = component.get('v.selectedParentNetwork');
        
        if(state == "None Selected"){state = null;}
        if(city == "None Selected"){city = null;}
        if(parentNetworkName == "None Selected"){parentNetworkName = null;}
    	
        // Set the Apex Method Called to Return the Data
    	var action = component.get('c.getDrgFacilityList');
        
        //Set Parameters for Apex controller
        action.setParams({
			"state": state,
            "city": city,
            "parentNetworkName" : parentNetworkName
        });


    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.drgFacilityData', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    
    
    //********************************************************************************************************************************
    // Fetch the Parent List from the Apex controller
    //********************************************************************************************************************************
  	getParentNetworkList: function(component) {
        var state = component.get('v.selectedState');
        var city = component.get('v.selectedCity');
        
        if(state == "None Selected"){state = null;}
        if(city == "None Selected"){city = null;}
    	
        // Set the Apex Method Called to Return the Data
        var action = component.get('c.getParentNetworkList');
        
        //Set Parameters for Apex controller
        action.setParams({
            "state": state,
            "city": city
        });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.parentNetworkList', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    
    
    
    //********************************************************************************************************************************
    // Fetch the State List from the Apex controller
    //********************************************************************************************************************************
  	getStateList: function(component) {
    	var action = component.get('c.getStateList');
        var hideOpportunities = component.get("v.hideOpportunities");
        	
    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.stateList', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    
    
    
    //********************************************************************************************************************************
    // Fetch the City List from the Apex controller
    //********************************************************************************************************************************
  	getCityList: function(component) {
        var state = component.get('v.selectedState');
    	var action = component.get('c.getCityList');
        
        
        
        if(state == "None Selected"){state = null;}
        
        //Set Parameters for Apex controller
        action.setParams({
            "state": state
        });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.cityList', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    
    
    
    
    //********************************************************************************************************************************
    // Fetch the City List from the Apex controller
    //********************************************************************************************************************************
  	getProceduresByCity: function(component) {
        var state = component.get('v.selectedState');
        var sortByProcedures = component.get('v.sortByProcedures');
        var hideHistory = component.get('v.hideHistory');
    	var action = component.get('c.getProceduresByCity');
        var source = 'Hospital';
        
        var showHistory;
        if(hideHistory){showHistory = false; } else { showHistory = true;}
        
        if(state == "None Selected"){state = null;}
        
        //Set Parameters for Apex controller
        action.setParams({
            "state": state,
            "sortByProcedures": sortByProcedures,
            "showHistory": showHistory,
            "source" : source      
        });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.proceduresByCity', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    
    
    
    //********************************************************************************************************************************
    // Fetch the City List from the Apex controller
    //********************************************************************************************************************************
  	getProceduresByNetwork: function(component) {
        var selectedState = component.get('v.selectedState');
    	var selectedCity = component.get('v.selectedCity');
        var sortByProcedures = component.get('v.sortByProcedures');
        var source = 'Hospital';
        var action = component.get('c.getProceduresByNetwork');
        
        //Set Parameters for Apex controller
        action.setParams({
            "selectedState": selectedState,
            "selectedCity": selectedCity,
            "sortByProcedures": sortByProcedures,
            "source": source
        });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.proceduresByNetwork', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },


      
	    
    //********************************************************************************************************************************
    // Fetch the Facility List from the Apex controller
    //********************************************************************************************************************************
  	getProceduresByFacility: function(component) {
        var selectedState = component.get('v.selectedState');
    	var selectedCity = component.get('v.selectedCity');
        var selectedNetwork = component.get('v.selectedParentNetwork');
        var sortByProcedures = component.get('v.sortByProcedures');
        var source = 'Hospital';
        
        var action = component.get("c.getProceduresByFacility");
        
        //Set Parameters for Apex controller
        action.setParams({
            "selectedState": selectedState,
            "selectedCity": selectedCity,
            "selectedNetwork" : selectedNetwork,
            "sortByProcedures": sortByProcedures,
            "source" : source
        });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.proceduresByFacility', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    
    
    
    
    //********************************************************************************************************************************
    // Fetch the Facility Record from the Apex controller
    //********************************************************************************************************************************
  	getFacilityRecord: function(component) {
    	var facilityRecordId = component.get('v.facilityRecordId');
        
        var action = component.get('c.getFacilityRecord');
        //Set Parameters for Apex controller
        action.setParams({
            "facilityRecordId" : facilityRecordId
        });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.facilityRecord', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);  
    },    





    //********************************************************************************************************************************
    // Fetch the Physician Record from the Apex controller
    //********************************************************************************************************************************
  	getPhysicianRecord: function(component) {
    	var physicianRecordId = component.get('v.physicianRecordId');
        var action = component.get('c.getPhysicianRecord');
        //Set Parameters for Apex controller
        action.setParams({
            "physicianRecordId" : physicianRecordId
        });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.physicianRecord', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);  
    },        
    
    
    
    
    
     //********************************************************************************************************************************
    // Fetch the Physician List from the Apex controller
    //********************************************************************************************************************************
  	getProceduresByPhysician: function(component) {
        var facilityId = component.get("v.facilityRecordId");
        var action = component.get("c.getProceduresByPhysician");
        var sortByProcedures = component.get("v.sortByProcedures");
        
        //Set Parameters for Apex controller
        action.setParams({
            "facilityId" : facilityId,
            "sortByProcedures": sortByProcedures
        });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.proceduresByPhysician', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },




    
    
    //********************************************************************************************************************************
    // Fetch the City List from the Apex controller
    //********************************************************************************************************************************
  	getPhysicianList: function(component) {
        var selectedDrgFacility = component.get('v.selectedDrgFacility');
        alert('SelectedDrgFacility = [' + selectedDrgFacility + ']');
      
        //----------------------------------
        // GET PROCEDURE TOTALS BY FACILITY
    	//----------------------------------
    	var action = component.get('c.getProcedureCount');
        
        //Set Parameters for Apex controller
      //  action.setParams({
      //      "selectedDrgFacility": selectedDrgFacility
      //  });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set("v.procedureCountSet", actionResult.getReturnValue());
            //alert('Returned Value = ' + 'v.procedureCountSet');
        });
   	  	$A.enqueueAction(action);
    	
        
        //----------------------------------
        // GET PHYSICIAN LIST
        //----------------------------------
        var action = component.get('c.getPhysicianList');
        
        //Set Parameters for Apex controller
        action.setParams({
            "selectedDrgFacility": selectedDrgFacility
        });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.drgPhysicianData', actionResult.getReturnValue());
        });
        
        $A.enqueueAction(action);
    },
    
    showCitySelect : function (component, event, helper) {
    	var renderCityList = component.find("renderCityList");
        renderCityList.set("v.isTrue", false);
    },
    
    
    hideCitySelect : function (component, event, helper) {
    	var renderCityList = component.find("renderCityList");
        renderCityList.set("v.isTrue", true);
    },
    
    
    
   showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();

        var spinnerCity = component.find('spinnerCity');
        var evtCity = spinnerCity.get("e.toggle");
        evtCity.setParams({ isVisible : true });
        evtCity.fire();
       
        var spinnerState = component.find('spinnerState');
        var evtState = spinnerState.get("e.toggle");
        evtState.setParams({ isVisible : true });
        evtState.fire(); 
              
        var spinnerNetwork = component.find('spinnerNetwork');
        var evtNetwork = spinnerNetwork.get("e.toggle");
        evtNetwork.setParams({ isVisible : true });
        evtNetwork.fire();
       
        var spinnerFacility = component.find('spinnerFacility');
        var evtFacility = spinnerFacility.get("e.toggle");
        evtFacility.setParams({ isVisible : true });
        evtFacility.fire();
       
        var spinnerPhysician = component.find('spinnerPhysician');
        var evtPhysician = spinnerPhysician.get("e.toggle");
        evtPhysician.setParams({ isVisible : true });
        evtPhysician.fire();
    },
    
    
    
    
    hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire(); 
        
        var spinnerCity = component.find('spinnerCity');
        var evtCity = spinnerCity.get("e.toggle");
        evtCity.setParams({ isVisible : false });
        evtCity.fire();
        
        var spinnerState = component.find('spinnerState');
        var evtState = spinnerState.get("e.toggle");
        evtState.setParams({ isVisible : false });
        evtState.fire();
        
        var spinnerNetwork = component.find('spinnerNetwork');
        var evtNetwork = spinnerNetwork.get("e.toggle");
        evtNetwork.setParams({ isVisible : false });
        evtNetwork.fire();
       
        var spinnerFacility = component.find('spinnerFacility');
        var evtFacility = spinnerFacility.get("e.toggle");
        evtFacility.setParams({ isVisible : false });
        evtFacility.fire();
        
        var spinnerPhysician = component.find('spinnerPhysician');
        var evtPhysician = spinnerPhysician.get("e.toggle");
        evtPhysician.setParams({ isVisible : false });
        evtPhysician.fire();
    },

})