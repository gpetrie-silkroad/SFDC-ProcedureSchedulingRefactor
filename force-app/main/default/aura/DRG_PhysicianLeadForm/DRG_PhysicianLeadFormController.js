({
	doInit: function(component, event, helper) {
        
      var device = $A.get("$Browser.formFactor");
      component.set('v.device', device);
				
        	//alert("Mark 1");
			helper.showCitySelect(component);
        	//alert("Mark 2");
            helper.getCurrentUser(component);
        	//alert("Mark 3");
        	helper.getPeriodHeaders(component);
        	//alert("Mark 4");
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
        component.set('v.physicianSearchString', null);
        component.set('v.selectedPhysician', null);
        component.set('v.physicianRecordId', null);      
        component.set('v.physicianRecord', null);
                
        component.set('v.sortByProcedures', true);
        component.set('v.hideOpportunities', true);
        component.set('v.hidePhysicianTable', false);
        component.set('v.hideSelectedPhysicianTable', true);
        component.set('v.hideNewPhysicianButton', true);
        component.set('v.hideNewPhysician', false);
        component.set("v.showSearchCreateContactButton", true);
        
        
        var renderSearchSection = component.find("renderSearchSection");
		var renderStateSection = component.find("renderStateSection");
		var renderCitySection = component.find("renderCitySection");
		var renderNetworkSection = component.find("renderNetworkSection");
		var renderFacilitySection = component.find("renderFacilitySection");
        var renderPhysicianSection = component.find("renderPhysicianSection");
        var renderPhysicianList2 = component.find("renderPhysicianList2");
        var renderPhysicianList = component.find("renderPhysicianList");
        var renderSeletedPhysician = component.find("renderSeletedPhysician");
       
        
        component.set("v.hideSelectedPhysicianTable", false);
        
        renderSearchSection.set("v.isTrue",true);
		renderStateSection.set("v.isTrue",false);
		renderCitySection.set("v.isTrue",false);
		renderNetworkSection.set("v.isTrue",false);
		renderFacilitySection.set("v.isTrue",false);
        renderPhysicianSection.set("v.isTrue", false);
        renderPhysicianList2.set("v.isTrue",true);
        renderSeletedPhysician.set("v.isTrue",true);
        
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
        for(var i=0; i<iCkbox.length; i++){
             iCkbox[i].set("v.value",true);
        }
        
    },

    
    
    citySelect1 : function(component,event,helper) {
        var elm = event.getSource();
        var selectedEntity = elm.get("v.name");
        var hideOpportunities = component.get('v.hideOpportunities');

        component.set('v.selectedCity', selectedEntity);
        console.log(elm);
        
        var pcwList = component.get('v.proceduresByCity');
        
        var action = component.get('c.setOnlyOneCity');
        //Set Parameters for Apex controller
        action.setParams({
            "selectedEntity": selectedEntity,
            "hideOpportunities": hideOpportunities
        });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.proceduresByCity', actionResult.getReturnValue());
        });
        

      	helper.getProceduresByNetwork(component);
        
        $A.enqueueAction(action);
    },

    
    
    
    
    
    facilitySelect : function(component,event,helper) {
        
        var elm = event.getSource();
        var selectedEntity = elm.get("v.name");
        var selectedFacilityRecordId = elm.get("v.text");
        var hideOpportunities = component.get("v.hideOpportunities");
        component.set('v.facilityRecordId', selectedFacilityRecordId);

        component.set('v.selectedFacility', selectedEntity);
        console.log(elm);
        
        var pcwList = component.get('v.proceduresByFacility');
        
        var action = component.get('c.setOnlyOneFacility');
        //Set Parameters for Apex controller
        action.setParams({
            "selectedEntity": selectedEntity,
            "selectedFacilityRecordId": selectedFacilityRecordId,
            "hideOpportunities": hideOpportunities
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
    
    
    
    
    
    selectPhysician: function(component, event, helper){
    	
        var elm = event.getSource();
        var selectedEntity = elm.get("v.name");
        var physicianRecordId = elm.get("v.text");
        
        var facilityRecordId = component.get("v.facilityRecord.Id");
        
        component.set("v.facilityRecordId", facilityRecordId);
        component.set('v.physicianRecordId', physicianRecordId);
        component.set('v.selectedPhysician', selectedEntity);
        console.log(elm);
        
        var pcwList = component.get('v.proceduresByPhysician');
        var action = component.get('c.setOnlyOnePhysician');
        
        action.setParams({
            "physicianRecordId" : physicianRecordId,
            "facilityRecordId" : facilityRecordId
        });
        
        var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set("v.physicianRecord", actionResult.getReturnValue());
        });
        
        var renderSearchSection = component.find("renderSearchSection");
		var renderStateSection = component.find("renderStateSection");
		var renderCitySection = component.find("renderCitySection");
		var renderNetworkSection = component.find("renderNetworkSection");
		var renderFacilitySection = component.find("renderFacilitySection");
        var renderPhysicianSection = component.find("renderPhysicianSection");
        var renderPhysicianList2 = component.find("renderPhysicianList2");
        var renderPhysicianList = component.find("renderPhysicianList");
        var renderSeletedPhysician = component.find("renderSeletedPhysician");
       
        component.set("v.hideSelectedPhysicianTable", false);
        renderSearchSection.set("v.isTrue",true);
        renderStateSection.set("v.isTrue",false);
        renderCitySection.set("v.isTrue",false);
        renderNetworkSection.set("v.isTrue",false);
        renderFacilitySection.set("v.isTrue",false);
        renderPhysicianSection.set("v.isTrue", true);
        renderPhysicianList2.set("v.isTrue",true);
        renderPhysicianList.set("v.isTrue",true);
        renderSeletedPhysician.set("v.isTrue",false);

        $A.enqueueAction(action);
    },
    
    
    selectPhysicianFromList2: function(component, event, helper){
    	
        var elm = event.getSource();
        var selectedEntity = elm.get("v.name");
        var physicianRecordString = elm.get("v.text");
        
        var physicianRecordArray = physicianRecordString.split("-");
        var physicianRecordId = physicianRecordArray[0];
        var facilityRecordId = physicianRecordArray[1];
        
        component.set("v.facilityRecordId", facilityRecordId);
        component.set('v.physicianRecordId', physicianRecordId);
        component.set('v.selectedPhysician', selectedEntity);
        console.log(elm);

        var pcwList = component.get('v.proceduresByPhysician');
        var action = component.get('c.setOnlyOnePhysician');
        
        action.setParams({
            "physicianRecordId" : physicianRecordId,
            "facilityRecordId" : facilityRecordId
        });
        
        var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set("v.physicianRecord", actionResult.getReturnValue());
        });
        
        var renderSearchSection = component.find("renderSearchSection");
		var renderStateSection = component.find("renderStateSection");
		var renderCitySection = component.find("renderCitySection");
		var renderNetworkSection = component.find("renderNetworkSection");
		var renderFacilitySection = component.find("renderFacilitySection");
        var renderPhysicianSection = component.find("renderPhysicianSection");
        var renderPhysicianList2 = component.find("renderPhysicianList2");
        var renderPhysicianList = component.find("renderPhysicianList");
        var renderSeletedPhysician = component.find("renderSeletedPhysician");
       
        component.set("v.hideSelectedPhysicianTable", false);
        renderSearchSection.set("v.isTrue",false);
		renderStateSection.set("v.isTrue",true);
		renderCitySection.set("v.isTrue",true);
		renderNetworkSection.set("v.isTrue",true);
		renderFacilitySection.set("v.isTrue",true);
        renderPhysicianSection.set("v.isTrue", true);
        renderPhysicianList2.set("v.isTrue",true);
        renderPhysicianList.set("v.isTrue",true);
        renderSeletedPhysician.set("v.isTrue",false);
         
        $A.enqueueAction(action);
    },
    
    
    
    convertPhysicianLead: function(component, event, helper){

        var physicianRecordId = component.get('v.physicianRecordId');
        var facilityRecordId = component.get('v.facilityRecordId');
        
        var action1 = component.get("c.convertPhysicianToOpportunity");
        
        var x;
        
        action1.setParams({
            "physicianRecordId" : physicianRecordId,
            "facilityRecordId" : facilityRecordId
        });
        
        var self = this;
        action1.setCallback(this, function(actionResult) {
            component.set('v.newOpportunityId', actionResult.getReturnValue());
            x = component.get('v.newOpportunityId');
            
            var u = window.location.href;
        	u = "https://" + u.split("/")[2] + "/one/one.app#/sObject/" + x + "/view";
            
            var urlEvent = $A.get("e.force:navigateToURL");
    			urlEvent.setParams({
      				"url": u
    			});
    		urlEvent.fire();
           
        });  
               
        $A.enqueueAction(action1); 
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
    
    
    
    
    togglePhysicianSearch: function(component, event, helper){
    	var tf = component.get("v.facilityLookup");
      	var renderSearchSection = component.find("renderSearchSection");
		var renderStateSection = component.find("renderStateSection");
		var renderCitySection = component.find("renderCitySection");
		var renderNetworkSection = component.find("renderNetworkSection");
		var renderNetworkSection = component.find("renderNetworkSection");
        var renderPhysicianList2 = component.find("renderPhysicianList2");
        var renderPhysicianList = component.find("renderPhysicianList");
        
        if(tf == true){
            component.set("v.facilityLookup", false);
            renderSearchSection.set("v.isTrue",false);
            renderStateSection.set("v.isTrue",true);
			renderCitySection.set("v.isTrue",true);
			renderNetworkSection.set("v.isTrue",true);
			renderNetworkSection.set("v.isTrue",true);
            renderPhysicianList2.set("v.isTrue", false);
            renderPhysicianList.set("v.isTrue", true);
        }
        else{
            component.set("v.facilityLookup", true);
            renderSearchSection.set("v.isTrue",true);
            renderStateSection.set("v.isTrue",false);
			renderCitySection.set("v.isTrue",false);
			renderNetworkSection.set("v.isTrue",false);
			renderNetworkSection.set("v.isTrue",false);
            renderPhysicianList2.set("v.isTrue", true);
            renderPhysicianList.set("v.isTrue", false);
        }
    },
    
    
    
    
    partialSearch: function(component, event, helper){
    	var searchString = component.get("v.searchString");
        var hideOpportunities = component.get("v.hideOpportunities");
        var sortByProcedures = component.get("v.sortByProcedures");
        var action = component.get("c.getProceduresByFacilityFromSearch");
        
        searchString = "%" + searchString + "%";
        
        
        //Set Parameters for Apex controller
        action.setParams({
            "searchString": searchString,
            "hideOpportunities": hideOpportunities,
            "sortByProcedures": sortByProcedures
        });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set("v.proceduresByFacility", actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    
    
    
	partialPhysicianSearch: function(component, event, helper){
    	var searchString = component.get("v.physicianSearchString");
        var hidePhysicianTable = component.get("v.hidePhysicianTable");
        var sortByProcedures = component.get("v.sortByProcedures");
        var action = component.get("c.getProceduresByPhysicianFromSearch");
        
        if(searchString != null && searchString != ""){
            component.set("v.showSearchCreateContactButton", false);
        }
        
        searchString = "%" + searchString + "%";
        
        //Set Parameters for Apex controller
        action.setParams({
            "searchString": searchString
        });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set("v.proceduresByPhysician", actionResult.getReturnValue());
        });
        
        var renderPhysicianList2 = component.find("renderPhysicianList2");
        renderPhysicianList2.set("v.isTrue", false);
        
        
        
        $A.enqueueAction(action);
    },
    
    
    
    
    newPhysicianContact: function(component, event, helper){
        component.set("v.hideNewPhysician", true);
        component.set("v.hidePhysicianTable", true);

    },
    
    
    
    
    
    newPopup : function(component, event, helper){
        var cmpTarget = component.find('Modalbox1');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
    },

    
    
    

    newPopup1 : function(component, event, helper){
        var cmpTarget = component.find('Modalbox1');
        var cmpBack = component.find('Modalbackdrop');
        
        var action = component.get("c.acctList");
        var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set("v.acctList", actionResult.getReturnValue());
        });
     
        $A.enqueueAction(action);
        
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
    },



    
    saveModal : function(component, event, helper){
        var regForm = component.get("v.contForm");
        var regFormAccount = component.get("v.contForm.AccountId");
        var firstName = component.get("v.contForm.FirstName");
        var lastName = component.get("v.contForm.LastName");
        var contEmail = component.get("v.contForm.Email");
               
        var action = component.get("c.newOppId");
        
        var hospitalName = component.get("v.selectedFacility");
        var providerNumber = component.get("v.facilityRecord.Name");
        var parentNetwork = component.get("v.selectedParentNetwork");
        var accountId = component.get("v.facilityRecord.AccountId__c");
        var drgFId = component.get("v.facilityRecord.Id");
        
        if(accountId == null && regFormAccount != null){
            accountId = regFormAccount;
        }
		     
        if(accountId == null || accountId == ""){
            alert("Account is Required");
        }        
        else if(firstName == null || firstName == ""){
            alert("First Name is Required");
        }
        else if(lastName == null || lastName == ""){
            alert("Last Name is Required");
        }
        else if(contEmail == null || contEmail == ""){
            alert("Email is Required");
        }
        else{    
        
            action.setParams({
                regForm1  : regForm,
                hospitalName : hospitalName,
                providerNumber : providerNumber,
                accountId : accountId,
                drgFId : drgFId
                
            });
            var self = this;    
            action.setCallback(this, function(response) {
                var state = response.getState();         
                if (state === "SUCCESS") { 
                    
                    component.set("v.newOpportunityId", response.getReturnValue());
                    var iid = component.get("v.newOpportunityId");
                    
                    
                    $A.get('e.force:refreshView').fire();
                    var cmpTarget = component.find('Modalbox1');
                    var cmpBack = component.find('Modalbackdrop');
                    $A.util.removeClass(cmpBack,'slds-backdrop--open');
                    $A.util.removeClass(cmpTarget, 'slds-fade-in-open');                 
                    helper.convertPhysicianFromNewContact(component);                
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    alert("Error Creating Opportunity and Contact.  Please verify that the contact you adding is not a duplicate contact.  Additional Info: " + errors[0].message);
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +
                                        errors[0].message);
                        }
                    }
                    else {
                        console.log(response.getReturnValue());
                    }
                }
            });
            $A.enqueueAction(action);
        }   
    },

    
    
    
    
    closeNewModal : function(component, event, helper){
        var cmpTarget = component.find('Modalbox1');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
    },
    
    
    

})