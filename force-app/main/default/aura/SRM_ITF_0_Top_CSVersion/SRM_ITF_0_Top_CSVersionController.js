({
	doInit: function(component, event, helper) {
		helper.getAMUserslist(component);
		helper.getTDSUserslist(component);
		helper.getOtherUserslist(component);
		helper.getAccountslist(component);
		helper.getCSUsers(component);
		helper.getCurrentUser(component); //trigger to initial local values after getting SFDC data
		
		
		var recordId = component.get("v.recordId");

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

		var recordId = component.get("v.recordId");
		//If true: new Inventory Transfer Form; if false - edit Inventory Transfer Form
		if(recordId == null){		
			component.set('v.newITForm.Status__c', 'ITF Draft'); //Update status of ITF
			component.set('v.newITForm.Transfer_Date__c', year + "-" + month + "-" + date);//initial transfer date
			component.set('v.ITFID', currenttime);//Innitial ITFID and current time
			var ITForm = component.get('v.newITForm');
			helper.initialFormType(component, ITForm);		
			component.set('v.isITFReady', true);//Turn off loading screen - start new ITF process
		}else{
			component.set('v.newITForm.Id',recordId);
			component.set('v.recordIdfromUrl',recordId);
			helper.getITFTransactions(component);
			helper.getITFinfo(component);
			//initialFormType is run after get ITF Info
		}

		//check user's device type - to customize display on screen
		var device = $A.get("$Browser.formFactor");
		if(device == 'DESKTOP')
			component.set('v.isDesktop','True');
		else
			component.set('v.isDesktop','False');

		var transactedDate = year + '-' + month + '-' + date;
		component.set('v.tempTransactedDate', transactedDate);
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
		helper.updateSRMInfo(component); //Display rep/tds who have changed their position and is not on current rep/tds list
		component.set('v.isITFReady', true);

	},

	updateITFID: function(component, event, helper) {
		var tempITFID = component.get('v.ITFID');		
		var currentUser = component.get('v.currentUser');
		var CSUsers = component.get('v.CSUsers');
		var CSUserNames = component.get('v.possibleCSList');
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

		CSUserNames.push('----N/A----');
		CSUserNames.push('Material Team');
		for(var i=0; i<CSUsers.length; i++){
			CSUserNames.push(CSUsers[i].FirstName + " " + CSUsers[i].LastName);
		}
		component.set('v.possibleCSList',CSUserNames);

	},

	updateITForm: function(component, event, helper) {
		var ITForm = component.get('v.newITForm');
		var currentStatus = component.get('v.currentStatus');
		if(ITForm.Id == null){
			//only create a new record after user choooses transaction types
			// console.log("Create expense0: " + JSON.stringify(currentStatus));
			if(currentStatus != 1)
				helper.createNewITForm(component);
		}else{
			helper.updateITForm(component);
		}
		helper.updateOwnerPickList(component);
		helper.getITFTransactions(component);
	},

	updateITFormTransactions: function(component, event, helper) {
		// component.set('v.isITFReady', false);
		var CSname = component.get('v.tempCSName');
		if(CSname == null || CSname == '' || CSname == '----N/A----')
			alert("Please select a valid customer success name");
		else
		{
			var salenumber = component.get('v.tempSONumber');
			component.set('v.newITForm.Primary_Bill_Only_Number__c',salenumber);
			var status = component.get("v.newITForm.Status__c");
	        if(status == "ITF Draft")
	        {
	            component.set("v.newITForm.Status__c", "Transacted Inventory/Verification");
	        }
	        component.set("v.newITForm.EditableByRepTDS__c", false);
			helper.updateITForm(component);		
			helper.updateTransactions(component);			
		}
	},

	closeWaitingPopUp: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.WaitingWindow", false);
    },

    updateITFdependant:  function(component)
    {
    	var ITForm = component.get('v.newITForm');

    	component.set('v.ITFcurrentStep', ITForm.Status__c);
    },

    updateITFSteps: function(component, event)
    {
    	var ITFcurrentStep = event.getSource().get('v.value');
    	var ITForm = component.get('v.newITForm');
    	var isChangeonITForm = component.get('v.isChangeonITForm');

    	ITForm.Status__c = ITFcurrentStep;
    	isChangeonITForm = true;

    	component.set('v.newITForm', ITForm);
    	component.set('v.isChangeonITForm', isChangeonITForm);
    },

    handleSelectCSProcess: function(component, event, helper)
    {
    	var stepName = event.getParam("detail").value;
    	var ITForm = component.get('v.newITForm');
    	var isChangeonITForm = component.get('v.isChangeonITForm');

    	ITForm.ITF_CS_Process__c = stepName;
    	isChangeonITForm = true;

    	component.set('v.newITForm', ITForm);
    	component.set('v.isChangeonITForm', isChangeonITForm);    	
    },
})
// console.log("Create expense0: " + JSON.stringify(ITForm));