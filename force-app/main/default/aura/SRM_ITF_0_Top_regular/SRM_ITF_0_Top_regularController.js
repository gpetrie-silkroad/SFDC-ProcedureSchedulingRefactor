({
	doInit: function(component, event, helper) {
		var recordId = component.get("v.recordId");
		if(recordId == null)
		{	
			helper.getIncompleteITForm(component);
		}
		helper.getAMUserslist(component);
		helper.getTDSUserslist(component);
		helper.getOtherUserslist(component);
		helper.getAccountslist(component);
		helper.getCurrentUser(component);
		helper.getItemNumberList(component);

		//Get Currenttime
		var today = new Date();
		var year = today.getFullYear();
		var month = today.getMonth()+1;
		if(month <=9)
			month = '0'+ month;

		var date = today.getDate();
		if(date <=9)
			date = '0'+ date;
		var hours = today.getHours();
		if(hours <=9)
			hours = '0'+ hours;
		var minutes = today.getMinutes();
		if(minutes <=9)
			minutes = '0'+ minutes;
		var seconds = today.getSeconds();
		if(seconds <=9)
			seconds = '0'+ seconds;
		
		var currenttime = year + '.' + month + '.' + date + '.' +'T'+ hours + '.' + minutes + '.' + seconds;
		component.set('v.currentTime', currenttime);
                    
		//If true: new Inventory Transfer Form; if false - edit Inventory Transfer Form
		if(recordId == null){		
			component.set('v.newITForm.Status__c', 'ITF Draft'); //Update status of ITF
			component.set('v.newITForm.Transfer_Date__c', year + "-" + month + "-" + date);//initial transfer date
			component.set('v.ITFID', currenttime);//Innitial ITFID and current time		
			//component.set('v.isITFReady', true);//Turn off loading screen - start new ITF process - moved to helper.getIncompleteITForm
			component.set('v.tempStatus', 1);
			var ITForm = component.get('v.newITForm');
			helper.initialFormType(component, ITForm);
		}else{
			component.set('v.newITForm.Id',recordId);
			component.set('v.recordIdfromUrl',recordId);
			component.set('v.controllingTransactionTypePickList',0);
			helper.getITFTransactions(component);
			helper.getITFinfo(component); 
			//initialFormType is run after get ITF Info
		}

		//check user's device type - to customize display on screen
		var device = $A.get("$Browser.formFactor");
		if(device == 'DESKTOP')
			component.set('v.isDesktop','True');
		else
		{
			component.set('v.isDesktop','False');
			if(device == 'TABLET')
				component.set('v.isTablet','True');
			else
				component.set('v.isTablet','False');
		}
		component.set("v.WaitingWindow", false);
	},

	updateStatus: function(component, event, helper) {
		var ITForm = component.get('v.newITForm');
		var currentStatus = 0;

		if(ITForm.Status__c !== null || ITForm.Status__c !== ''){
			currentStatus = 3;
		}

		component.set('v.currentStatus', currentStatus);
		component.set('v.tempStatus', currentStatus);		
		component.set('v.ITFID', ITForm.Name);
		component.set('v.newITForm', ITForm);
		helper.updateOwnerPickList(component);
		helper.updateSRMEmployeeAccountlist(component); //Display rep/tds/account who are no longer in the current lists
		component.set('v.isITFReady', true);
	},

	updateITFID: function(component, event, helper) {
		var tempITFID = component.get('v.ITFID');		
		var currentUser = component.get('v.currentUser');

		// Update ITFID
		component.set('v.ITFID',tempITFID+'-'+currentUser.FirstName + "." + currentUser.LastName);

		// Update currentUser into correct field
		if(currentUser.Field_Responsibility__c == 'Area Manager')
			component.set('v.newITForm.SRM_AM__c', currentUser.Id);
		else if(currentUser.Field_Responsibility__c == 'Therapy Development Specialist')
			component.set('v.newITForm.SRM_TDS__c', currentUser.Id);
		else
			component.set('v.newITForm.Other_Qualified_SRM_Employee__c',currentUser.Id);

		component.set('v.newITForm.From_Rep_TDS__c',currentUser.FirstName+' '+currentUser.LastName);
	},

	updateITForm: function(component, event, helper) {
		var ITForm = component.get('v.newITForm');
		var currentStatus = component.get('v.currentStatus');

		if(ITForm.Id == null){
			//only create a new record after user choooses transaction types			
			if(currentStatus != 1 & currentStatus != 0)
				helper.createNewITForm(component);
		}else{
			helper.updateITForm(component);
		}
		helper.updateOwnerPickList(component);
		helper.getITFTransactions(component);
	},

    updateITFdependant:  function(component)
    {
    	var ITForm = component.get('v.newITForm');

    	component.set('v.ITFcurrentStep', ITForm.Status__c);
    },

    closeWaitingPopUp: function(component, event, helper) {
        component.set("v.WaitingWindow", false);
    },
})
// console.log("Create expense0: " + JSON.stringify(ITForm));