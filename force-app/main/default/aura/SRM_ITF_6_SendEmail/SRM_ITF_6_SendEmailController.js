({
	initializeEmail : function(component, event, helper) {
		var emailType = component.get('v.emailType');

		if(emailType == 2 || emailType == 1) //1 send to CS; 2 send to customer
		{//sending another person
			helper.getContactList(component); //Get Contact list, current user, create email template
		}
		else
		{
			alert('Unsupported email type ' + emailType);
			component.set('v.LoadingData', false);	
		}	
	},

	continueInitial : function(component, event, helper) {
		var emailType = component.get('v.emailType');
		if(emailType == 3 || emailType == 4 || emailType == 5)//3. auto send notified email to cs 4.auto send notified email to cs and closed 5. auto send notified email to cs and closed email module
		{
			//helper.uploadCSEmailtemplate(component);
			helper.sendEmail(component);
		}		
	},

	cancel : function(component, event, helper) {
		component.set('v.tempStatus',3);
		component.set('v.emailType', 0);		
	},

	send : function(component, event, helper) {
		helper.sendEmail(component);
	},

	updateEmailList: function(component, event, helper) 
	{
		var contactList = component.get('v.contactList');
		var emailList = [];

		if(contactList.length != null & contactList.length != 0){
			for (var i=0; i < contactList.length; i++){
				if(contactList[i].Email != null &  contactList[i].Email != '')
					emailList.push(contactList[i].Email);
			}
		}

		component.set('v.emailList',emailList);
	},

	closeWaitingPopUp: function(component, event, helper) {
        component.set("v.WaitingWindow", false);
	},

	handleSelectAllContact: function(component, event, helper)
	{
		var IsSelectedAllCOntact = component.get("v.IsSelectedAllCOntact");
		var selectedList = component.get("v.selectedList");
		var i = 0;

		for( i=0; i<selectedList.length; i++)
		{
			selectedList[i] = IsSelectedAllCOntact;
		}

		//trigger for child to update selected
		component.set("v.selectedList", selectedList);
		if(component.get("v.updatedselectedList"))
			component.set("v.updatedselectedList", false);
		else 
			component.set("v.updatedselectedList", true);
	},

})

// console.log("Create expense0: " + JSON.stringify(currentUser));