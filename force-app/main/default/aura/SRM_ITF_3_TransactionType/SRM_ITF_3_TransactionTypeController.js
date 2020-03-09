({
// Initialize local Attributes=============================================
	initialvalues: function(component, event, helper){
		var ITForm = component.get('v.ITForm');
		var Accounts = component.get('v.Accounts');
		var controllingTransactionTypePickList = component.get('v.controllingTransactionTypePickList');
		var accountToName = '';
		var accountFromName = '';
		var i = 0;

		if(ITForm.ITF_Type__c == null || ITForm.ITF_Type__c == '')
		{
			if(controllingTransactionTypePickList == 2)
			{
				component.set('v.ITForm.ITF_Type__c','Internal Transfer (AM/TDS to AM/TDS)');
				component.set('v.ITF_Type__c','Internal Transfer (AM/TDS to AM/TDS)');
			}else
			{
				component.set('v.ITForm.ITF_Type__c','Transfer to Customer');
				component.set('v.ITF_Type__c','Transfer to Customer');
			}
		}else
		{
			component.set('v.ITF_Type__c', ITForm.ITF_Type__c);
			if(ITForm.ITF_Type__c == 'Transfer to Customer')
			{
				component.set('v.controllingTransactionTypePickList',1);
			}else
			{
				component.set('v.controllingTransactionTypePickList',2);
			}
		}

		if(ITForm.To_Rep_TDS__c == null || ITForm.To_Rep_TDS__c == '')
			component.set('v.changeToREPTDS', true);

		if(ITForm.Customer_To__c != null & ITForm.Customer_To__c != ''){
			for(i=0; i<Accounts.length; i++){
				if(Accounts[i].Id == ITForm.Customer_To__c){
            		accountToName = Accounts[i].IQMS_Customer_Number__c+ '-' +Accounts[i].Name;
            		i = Accounts.length;
				}
			}
			if(accountToName == ''){
				alert('Cannot find a customer info.');
				accountToName = ITForm.Customer_To__c;
			}
			component.set('v.SearchCustomerToName', accountToName);
		}

		if(ITForm.Customer_From__c != null & ITForm.Customer_From__c != ''){
			for(i=0; i<Accounts.length; i++){
				if(Accounts[i].Id == ITForm.Customer_From__c){
            		accountFromName = Accounts[i].IQMS_Customer_Number__c+ '-' +Accounts[i].Name;
            		i = Accounts.length;
				}
			}
			if(accountFromName == ''){
				alert('Cannot find a customer info.');
				accountFromName = ITForm.Customer_To__c;
			}
			component.set('v.SearchCustomerFromName', accountFromName);
		}

		//Iniitialize fromUsers' name
		helper.updateFromRepTDSNames(component);	
	},
//==============================================================

	updateCurrentSelectedUsers: function(component, event, helper) {
	//Iniitialize fromUsers' name		
		helper.updateFromRepTDSNames(component);
	},	
	
	backButton: function(component, event, helper) {
		component.set('v.tempStatus', 0);
	},

	nextButton: function(component, event, helper) {
		var ITForm = component.get('v.ITForm');
		var tempITFID = component.get('v.ITFID');
		var AccountList = component.get('v.Accounts');
		var Isvalid = true;
		var i = 0;

		//1st step check transaction type
		Isvalid = helper.CheckITFType(component);

		//2nd step check specifc field of each transaction type
		if(Isvalid){
			if(ITForm.ITF_Type__c == 'Internal Transfer (AM/TDS to AM/TDS)'){
				Isvalid = helper.CheckReptoRepForm(component);
				tempITFID += '-3.'+ ITForm.To_Rep_TDS__c;
			}
			else if (ITForm.ITF_Type__c == 'External Transfer (Customer to Customer)'){
				Isvalid = helper.CheckCustomertoCustomerForm(component);
				if(ITForm.Id == null)
				{
					for(i=0; i<AccountList.length; i++){
						if(ITForm.Customer_To__c == AccountList[i].Id)
							tempITFID += '-2.'+ AccountList[i].IQMS_Customer_Number__c + '.' + AccountList[i].Name;
					}
				}
			}
			else{
				Isvalid = helper.CheckTransferToCustomerForm(component);
				if(ITForm.Id == null)
				{
					for(i=0; i<AccountList.length; i++){
						if(ITForm.Customer_To__c == AccountList[i].Id)
							tempITFID += '-1.'+ AccountList[i].IQMS_Customer_Number__c + '.' + AccountList[i].Name;
					}
				}
			}
		}

		//Update the form if all required fields are valid.
		if (Isvalid){
			var currentStatus = component.get('v.currentStatus');
            if(currentStatus < 2){
                component.set('v.currentStatus', 2);
                component.set('v.tempStatus', 2); //status 1: move to ITF Detail Section
            }
            else{
                component.set('v.tempStatus', currentStatus);
            }
			if(tempITFID.length > 70)
				tempITFID = tempITFID.substring(0,69);
			if(ITForm.Id == null){
				component.set('v.ITForm.ITF_ID__c', tempITFID);
				component.set('v.ITForm.Name', tempITFID);
			}
			
			component.set('v.ITForm.AutoSaveCopy__c', true);
			var createEvent = component.getEvent("updateITFormFromITFDetail");
        	createEvent.setParams({ "ITForm": ITForm });
        	createEvent.fire(); 
		}
	},

	TransfertoCustomerButton: function(component, event, helper) {
		component.set('v.ITForm.ITF_Type__c','Transfer to Customer');
		component.set('v.ITF_Type__c','Transfer to Customer');
	},

	ExternalTransferButton: function(component, event, helper) {
		component.set('v.ITForm.ITF_Type__c','External Transfer (Customer to Customer)');
		component.set('v.ITF_Type__c','External Transfer (Customer to Customer)');
	},

	InternalTransferButton: function(component, event, helper) {
		component.set('v.ITForm.ITF_Type__c','Internal Transfer (AM/TDS to AM/TDS)');
		component.set('v.ITF_Type__c','Internal Transfer (AM/TDS to AM/TDS)');
	},	

	evaluationButton: function(component, event, helper) {
		component.set('v.ITForm.ITF_Type__c','Transfer to Customer');
		component.set('v.ITF_Type__c','Transfer to Customer');
		component.set('v.ITForm.Bill_Only_PO__c','evaluation');
	},

	DemoButton: function(component, event, helper) {
		component.set('v.ITForm.ITF_Type__c','Internal Transfer (AM/TDS to AM/TDS)');
		component.set('v.ITF_Type__c','Internal Transfer (AM/TDS to AM/TDS)');
		component.set('v.ITForm.To_Rep_TDS__c','Demo');
	},

	updateTransactionType: function(component, event, helper) {
		var userChoiceTranType = component.find('SRMInfoForm_TranType');
        var transactionType = userChoiceTranType.get("v.value");
		if(transactionType == 'Demo'){
			component.set('v.ITForm.ITF_Type__c','Internal Transfer (AM/TDS to AM/TDS)');
			component.set('v.ITForm.To_Rep_TDS__c','Demo');
			// userChoiceTranType.set('v.value', 'Internal Transfer (AM/TDS to AM/TDS)');
			component.set('v.changeToREPTDS', false);			
		}else if(transactionType == 'Evaluation'){
			component.set('v.ITForm.ITF_Type__c','Transfer to Customer');
			component.set('v.ITForm.Bill_Only_PO__c','evaluation');
			// userChoiceTranType.set('v.value', 'Transfer to Customer');
		}else
		{
			component.set('v.ITForm.ITF_Type__c', transactionType);
		}
	},

	// Searching To Customer Functions
	SearchButton : function(component, event, helper) {
		var Accounts = component.get('v.Accounts');
		var tempAccounts = [];
		var SearchName = component.get('v.SearchCustomerToName').toLowerCase();
		var i = 0;
		var matchIndex = -1;
		var customerfullname = '';

		if(SearchName == null || SearchName == '')
			component.set('v.showSearchCustomerTO',false);
		else
			component.set('v.showSearchCustomerTO',true);

		for(i=0; i<Accounts.length; i++){
			if(Accounts[i].Name != null)
				if(Accounts[i].Name.toLowerCase().search(SearchName)>-1)
					tempAccounts.push(Accounts[i]);	

			//if user copy and paste full customer
			customerfullname = Accounts[i].IQMS_Customer_Number__c+ '-' +Accounts[i].Name;
			if(SearchName == customerfullname.toLowerCase()){
				matchIndex = i;

			}
		}

		if(matchIndex !== -1)
		{
			component.set('v.showSearchCustomerTO',false);
			component.set('v.ITForm.Customer_To__c', Accounts[matchIndex].Id);
		}
        component.set('v.tempAccounts',tempAccounts);
	},

	SelectButton : function(component, event, helper) {
		var index = event.getSource().get('v.name');
		var ITForm = component.get('v.ITForm');
		var Accounts = component.get('v.tempAccounts');
		component.set('v.ITForm.Customer_To__c', Accounts[index].Id);
		component.set('v.SearchCustomerToName',Accounts[index].IQMS_Customer_Number__c+ '-' +Accounts[index].Name);
		component.set('v.showSearchCustomerTO',false);
	},
// ============================

// Search From Customer Functions
	SearchButton2 : function(component, event, helper) {
		var Accounts = component.get('v.Accounts');
		var tempAccounts = [];
		var SearchName = component.get('v.SearchCustomerFromName').toLowerCase();
		var i = 0;
		var matchIndex = -1;
		var customerfullname = '';

		if(SearchName == null || SearchName == '')
			component.set('v.showSearchCustomerTO2',false);
		else
			component.set('v.showSearchCustomerTO2',true);

		for(i=0; i<Accounts.length; i++){
			if(Accounts[i].Name != null)
				if(Accounts[i].Name.toLowerCase().search(SearchName)>-1)
					tempAccounts.push(Accounts[i]);	

			//if user copy and paste full customer
			customerfullname = Accounts[i].IQMS_Customer_Number__c+ '-' +Accounts[i].Name;
			if(SearchName == customerfullname)
				matchIndex = i;		
		}

		if(matchIndex !== -1)
		{
			component.set('v.showSearchCustomerTO2',false);
			component.set('v.ITForm.Customer_From__c', Accounts[matchIndex].Id);
		}
        component.set('v.tempAccounts2',tempAccounts);
	},

	SelectButton2 : function(component, event, helper) {
		var index = event.getSource().get('v.name');
		var ITForm = component.get('v.ITForm');
		var Accounts = component.get('v.tempAccounts2');
		component.set('v.ITForm.Customer_From__c', Accounts[index].Id);
		component.set('v.SearchCustomerFromName',Accounts[index].IQMS_Customer_Number__c+ '-' +Accounts[index].Name);
		component.set('v.showSearchCustomerTO2',false);
	},
// ============================

	turnonchangeToREPTDS: function(component, event, helper) {
		component.set('v.changeToREPTDS', true);
	},
})

// console.log("Create expense4: " + JSON.stringify(LookUpTDSValue));