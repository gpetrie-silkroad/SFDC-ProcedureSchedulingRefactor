({
	createProcedureForm: function(component, procedureForm) {
        var state;
        var action = component.get("c.saveProcedureForm");
        action.setParams({
            "procedureForm": procedureForm
        });
         
        action.setCallback(this, function(actionResult){
            state = actionResult.getState();

            component.set("v.procedureForms", actionResult.getReturnValue());
            
            if (state == "SUCCESS") {

                alert("Save Procedure Form Status [" + state + "]");
                
                var procedureForms = component.get("v.procedureForms");
                procedureForms.push(actionResult.getReturnValue());
                component.set("v.procedureForms", procedureForms);
                var isMobile = component.get("v.isLEX");
               
            }
            else {
                alert('Procedure NOT Saved!  Refer to Debug Logs')
            }
        });     
        $A.enqueueAction(action);
        
        var procedureForms = component.get("v.procedureForms");
        var procedureFormId = procedureForm.Id;

    },

     
    
    
    
    
    // Fetch the accounts from the Apex controller
  	getAccountList: function(component) {
    	var action = component.get('c.getAccountList');

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.accounts', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    
        // Fetch the accounts from the Apex controller
  	getAccount: function(component) {
    	var action = component.get('c.getAccount');
        var acctId = component.get('v.recordId');  // FOR TESTING USING AURA REPLACD THIS LINE WITH "0014100001BvjyvAAB";
      //  alert('Account Id = ' + acctId);
      	component.set("v.recordId", acctId )
        
        action.setParams({
            "acctId": acctId
        });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.account', actionResult.getReturnValue());
            
            var a = component.get('v.account');
            component.set("v.hospitalName", a.Name);
            component.set("v.hospitalStreet", a.BillingStreet);
            component.set("v.hospitalCity", a.BillingCity);
            component.set("v.hospitalState", a.BillingState);
            component.set("v.vendorCredentailCompany", a.Vendor_Credential_Company__c);

           // var timeZone = component.get(a.Time_Zone__c);
            
            component.set("v.hospitalTimeZone", a.Time_Zone__c);
            
            var locInfo = a.Name;
            component.set("v.locationInfo", a.Name + '\n' + a.BillingStreet + '\n' + a.BillingCity + ', ' + a.BillingState);
            
            component.set('v.newProcedureForm.Account__c', acctId);
        });

        $A.enqueueAction(action);
    },
    
    
    testMethod: function(component){
        var x = component.get("v.account");
        //component.set("v.hospitalName", x.Name);
    },
    
    
    
    
    // Fetch the accounts from the Apex controller
  	getPhysicianList: function(component) {
        var accountId = component.get('v.recordId');
    	var action = component.get('c.getPhysician');
        var recordId = component.get("v.newProcedureForm.Stenter__c");

        action.setParams({
            inputId : recordId, 
            accountId : accountId
        });
    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.physicians', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },

    
    getProctorList: function(component) {
    	var action = component.get('c.getProctors');
        var accountId = component.get('v.recordId');

    	// Set up the callback
    	var self = this;
        var recordId = component.get("v.newProcedureForm.SRM_Proctor__c");
        action.setParams({
        		inputId : recordId,
            	accountId : accountId
    	});
    	action.setCallback(this, function(actionResult) {
     		component.set('v.proctors', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    
    getStenterList: function(component) {
    	var action = component.get('c.getStenters');
        var accountId = component.get('v.recordId');

    	// Set up the callback
    	var self = this;
        var recordId = component.get("v.newProcedureForm.Stenter__c");
        action.setParams({
        		inputId : recordId, 
            	accountId : accountId
    	});

    	action.setCallback(this, function(actionResult) {
     		component.set('v.stenters', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    
    
    
    getCutdownList: function(component) {
    	var action = component.get('c.getCutdown');
        var accountId = component.get('v.recordId');
 
    	// Set up the callback
    	var self = this;
        var recordId = component.get("v.newProcedureForm.Cutdown_Physician__c");
        action.setParams({
        		inputId : recordId, 
            	accountId : accountId
    	});

    	action.setCallback(this, function(actionResult) {
     		component.set('v.cutdown', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },




    // Fetch the accounts from the Apex controller
  	getAMUsers: function(component) {
    	var action = component.get('c.getAMUsers');

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.amUsers', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },    
    
    
    

  	getDisUsers: function(component) {
        var noSRMselect = component.get("v.newProcedureForm.No_SRM_Personnel_Present__c");
        
            var action = component.get('c.getDisUsers');
    
            // Set up the callback
            var self = this;
            action.setCallback(this, function(actionResult) {
                component.set('v.qualUsers', actionResult.getReturnValue());
                component.set('v.amUsers', actionResult.getReturnValue());
                component.set('v.tdsUsers', actionResult.getReturnValue());
                component.set('v.tdsUsers2', actionResult.getReturnValue());
                component.set('v.adUsers', actionResult.getReturnValue());
                
            });
            $A.enqueueAction(action);
    },
    
    
    
    
    
    
    disableSecondaryTds: function(component) {
        var action = component.get('c.getDisUsers');
    	var tdsSelect2 = component.find("tdsSelect2");

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
            component.set('v.tdsUsers2', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    	tdsSelect2.set("v.disabled", true);
	},
    


  
    
    // Fetch the accounts from the Apex controller
  	getTDSUsers: function(component) {
    	var action = component.get('c.getTDUsers');

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.tdsUsers', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },  
    
 
    
    
  	getTDSUsers2: function(component)  {
        var inputId = component.get("v.newProcedureForm.TDS_Present__c");
        var nullId = component.get("v.nullId");
        var selectedTds2 = component.get("v.newProcedureForm.Secondary_TDS_Present__c");
    	
        var disableTds2 = component.get("v.disableTds2");
        //var renderBottom = component.get("renderBottom");
        
        if(inputId == null || inputId == 'none'){     
            
            var action = component.get('c.getDisUsers');
            
            var self = this;
            action.setCallback(this, function(actionResult) {
                component.set('v.tdsUsers2', actionResult.getReturnValue());
            });
            $A.enqueueAction(action);
            component.set("v.disableTds2", true);
            component.set("v.newProcedureForm.Secondary_TDS_Present__c", nullId);
        }
        else{
            if(selectedTds2 == 'none'){
                selectedTds2 == nullId;
            }   
            
            var action = component.get('c.getSecondaryTDUsers');
            
            var self = this;
            action.setParams({
                inputId : inputId,
                selectedTds2 : selectedTds2
            });
            action.setCallback(this, function(actionResult) {
                component.set('v.tdsUsers2', actionResult.getReturnValue());
            });
            $A.enqueueAction(action);
            component.set("v.disableTds2", false);
        }
    }, 
    
    
    
    
        // Fetch the accounts from the Apex controller
  	getQualUsers: function(component) {
    	var action = component.get('c.getSMQualUsers');

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.qualUsers', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    }, 
    
    
    
    
    // Fetch the accounts from the Apex controller
  	getADUsers: function(component) {
    	var action = component.get('c.getADUsers');

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.adUsers', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    }, 
    	
    
    
    
    
    
    
    setNone: function(component){
        var am  = component.get("v.newProcedureForm.AM_Present__c");
        var ad  = component.get("v.newProcedureForm.AD_Present__c");
        var tds = component.get("v.newProcedureForm.TDS_Present__c");
        var nullId = component.get("v.nullId");
        
        if(am == "none"){
            component.set("v.newProcedureForm.AM_Present__c", nullId);
        }
        if(ad == "none"){
            component.set("v.newProcedureForm.AD_Present__c", nullId);
        }
         if(tds == "none"){
            component.set("v.newProcedureForm.TDS_Present__c", nullId);
        }
    },
    
    
    
    	
    
    
    	
    
    
    
    // Fetch the currentUserRecord from the Apex controller
  	getCurrentUser: function(component) {
        
    	var action = component.get('c.getCurrentUser');
        var fieldResponsibility;   
        var nullId = component.get("v.nullId");

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.currentUser', actionResult.getReturnValue());
            var v = component.get("v.currentUser");
            fieldResponsibility = v.Field_Responsibility__c;
            
            if(fieldResponsibility == "Area Director"){
                component.set("v.newProcedureForm.AD_Present__c", v.Id);
            }
            else{
                component.set("v.newProcedureForm.AD_Present__c", nullId)
            }
            if(fieldResponsibility == "Area Manager"){
                component.set("v.newProcedureForm.AM_Present__c", v.Id);
            }
            else{
                component.set("v.newProcedureForm.AM_Present__c", nullId)
            }
            if(fieldResponsibility == "Therapy Development Specialist"){
                component.set("v.newProcedureForm.TDS_Present__c", v.Id);
            }
            else{
                component.set("v.newProcedureForm.TDS_Present__c", nullId)
            }
        });
        $A.enqueueAction(action);
    },




    getTimeListForSelect: function(component){
        var action = component.get('c.getTimeList');
        action.setCallback(this, function(actionResult) {
        	component.set("v.timeList", actionResult.getReturnValue());
        });
        $A.enqueueAction(action)
    },
    
    
    
    
    
    
    
    // Fetch the currentUserRecord from the Apex controller
  	getCurrentTime: function(component) {
    	var action = component.get('c.getCurrentTime');

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set("v.nowTime", actionResult.getReturnValue());         
            var nowDateTime = component.get("v.nowTime");
            
            var currentDate = nowDateTime.substring(0, 10);
            component.set("v.nowDate", currentDate);
            component.set('v.newProcedureForm.Procedure_Date__c', currentDate);
            
            var currentHour = nowDateTime.substring(11, 13);
            var currentMin  = nowDateTime.substring(14, 16);
            var currentMin15;
            
            var minute = nowDateTime.substring(14, 16);
            
            if(currentMin > "53"){ currentMin15 = "00";}
            else if(currentMin > "43"){ currentMin15 = "45";}
            else if(currentMin > "23"){ currentMin15 = "30";}
            else if(currentMin > "13"){ currentMin15 = "15";}
            else if(currentMin <= "12"){ currentMin15 = "00";}
            
            component.set("v.currentDateTime", nowDateTime);
            component.set("v.startTime", currentHour + ":" + currentMin15 + ":00");

            //var testStartTime = component.get("v.startTime");
            //alert("Test Start Time = [" + testStartTime + "]");
            
            var endHour;
            if(currentHour == '00'){endHour = '01';}
            else if(currentHour == '01'){endHour = '02';}
            else if(currentHour == '02'){endHour = '03';}
            else if(currentHour == '03'){endHour = '04';}
            else if(currentHour == '04'){endHour = '05';}
            else if(currentHour == '05'){endHour = '06';}
            else if(currentHour == '06'){endHour = '07';}
            else if(currentHour == '07'){endHour = '08';}
            else if(currentHour == '08'){endHour = '09';}
            else if(currentHour == '09'){endHour = '10';}
            else if(currentHour == '10'){endHour = '11';}
            else if(currentHour == '11'){endHour = '12';}
            else if(currentHour == '12'){endHour = '13';}
            else if(currentHour == '13'){endHour = '14';}
            else if(currentHour == '14'){endHour = '15';}
            else if(currentHour == '15'){endHour = '16';}
            else if(currentHour == '16'){endHour = '17';}
            else if(currentHour == '17'){endHour = '18';}
            else if(currentHour == '18'){endHour = '19';}
            else if(currentHour == '19'){endHour = '20';}
            else if(currentHour == '20'){endHour = '21';}
            else if(currentHour == '21'){endHour = '22';}
            else if(currentHour == '22'){endHour = '23';}
            else if(currentHour == '23'){endHour = '23';}
            else {endHour = '00';}
            
            component.set("v.endTime", endHour + ":" + currentMin15 + ":00");

            // var testEndTime = component.get("v.endTime");
            // alert("Test End Time = [" + testEndTime + "]");
                    
        });
        $A.enqueueAction(action);
    },
    
    
    
    
    

    
    
    
    
    
    
    disableNoSrm: function(component, event, helper){
        var amSelect = component.get("v.newProcedureForm.AM_Present__c");
        var tdsSelect = component.get("v.newProcedureForm.TDS_Present__c");
        var adSelect = component.get("v.newProcedureForm.AD_Present__c");
        var qualSelect = component.get("v.newProcedureForm.Other_Qualified_SRM_Present__c");
        
        var noRenderBottom = component.get("v.noRenderBottom");
    
        if(!noRenderBottom){
            if ((amSelect == null || amSelect == "none") && (tdsSelect == null || tdsSelect == "none") && (adSelect == null || adSelect == "none") && (qualSelect == null || qualSelect == "none")){
                component.set("v.noSrmPres_dis", false);
            }
            else {
                component.set("v.noSrmPres_dis", true);
                component.set("v.newProcedureForm.No_SRM_Personnel_Present__c", false);
            }
            
        }    
    }, 

    
     updateProcedureNameOnInit: function(component, event){
        var procDt = component.find("proceduredate").get("v.value");
	    component.set('v.newProcedureForm.Name', procDt + " : "); 
         
        //Determine what ui is appropriate
        var action1 = component.get("c.getUIThemeDescription");
        action1.setCallback(this, function(b){
        	component.set("v.Name", a.getReturnValue());                    
        	if(b.getReturnValue() == 'Theme4t'){
            	component.set("v.Desc", "View is Mobile");
                component.set("v.isLEX", true);
        	}
            else{
                component.set("v.Desc", "View is Not Mobile");
                component.set("v.isLEX", false);
            }
    	});
    },
    
    
    
    
    checkTest: function(target){
        
       
        var nm = target.getLocalId();
        var unit = nm.substr(nm.length -2);
        //alert('Units are :' + unit);
        var targetValue = target.get('v.value');
        var testedValue = Number(targetValue);
        
        //alert('Tested Value = ' + testedValue);
        
        if(targetValue.includes('.') || targetValue.includes(':') || targetValue.includes('-')){
            alert('Only Enter Positive Integers!');
            target.set('v.class', "redBGColor");
        }
        else if(isNaN(testedValue)){        	
                alert('Only Enter Positive Integers!');
                target.set('v.class', "redBGColor");
        }        	
        else if(unit == 'Hr' && testedValue > 24 || testedValue < 0 ){
                alert('Range must be 0-24');
                target.set('v.class', "redBGColor");
        }
        else if((unit == 'Mn' || unit == 'Ss') && testedValue > 59 || testedValue < 0 ){
                alert('Range must be 0-59');
                target.set('v.class', "redBGColor");
        }
        else{
                target.set('v.class', "whiteBGColor");
        }
       
    }
    

   

})