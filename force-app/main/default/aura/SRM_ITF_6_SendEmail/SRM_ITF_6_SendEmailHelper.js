({
	getContactList : function(component){
		var accountId = component.get('v.ITForm.Customer_To__c');
		var action = component.get('c.getContactAccount');

    	action.setParams({
      		"idAccount": accountId
    	});

        action.setCallback(this, function(response){
        	var state = response.getState();

			if (state === "SUCCESS") 
			{
				var result = response.getReturnValue();
				component.set('v.contactList', result);

				//Initial Selected conact size
				var selectedList = [];
				for( var i=0; i<result.length; i++)
					selectedList.push(false);
				component.set("v.selectedList", selectedList);
				
				this.getCurrentUser(component);		
			}else
			{
				var message = "error on getting Contacts from AccountID: " + accountId + ".\nSorry about the inconvenience";
                alert(message);
			}

        });
        $A.enqueueAction(action);
	},

  	getCurrentUser: function(component) {
    	var action = component.get('c.getCurrentUser');

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult)
      	{
    		var result = actionResult.getReturnValue();
    		component.set('v.currentUser', result);
			component.set('v.CCEmailAddress', result.Email);	
        	this.uploadCustomerEmailtemplate(component, result);	
      	});
      $A.enqueueAction(action);
    },

	uploadCustomerEmailtemplate : function(component, currentUser){
		var ITForm = component.get('v.ITForm');
		var emailType = component.get('v.emailType');
		var EmailTemaplateName = "";

		if(emailType == 1)
		{
			EmailTemaplateName = "ITF_Send_A_ITF_Copy_to_SRMCustomerSuccess";
		}else
		{
			EmailTemaplateName = "ITF_Send_A_ITF_Copy_to_Customer";
		}

		var action = component.get('c.GetEmailTemplate');
    	action.setParams({
      		"EmailName": EmailTemaplateName,
      		"ITFID": ITForm.Id
    	});

        action.setCallback(this, function(response){
        	var state = response.getState();

			if (state === "SUCCESS") 
			{
				var result = response.getReturnValue();
				
				if(result.HtmlValue === 'N/A')
				{
					component.set('v.Subject', 'SRM ITF - ' + ITForm.ITF_ID__c);
					component.set('v.EmailBody', '');
				}else
				{
					component.set('v.Subject', result.Subject);
					component.set('v.EmailBody', result.HtmlValue);
				}
				component.set('v.AttachPDFID', ITForm.PDFIDCurrentITForm__c);

				if(emailType == 1)
				{
					component.set('v.ToEmailAddress', 'customerservice@silkroadmed.com');
				}

				component.set('v.LoadingData', false);	
			}else
			{
				var message = "error on getting Email Template: " + EmailTemaplateName + ".\nSorry about the inconvenience";
                alert(message);
			}

        });
        $A.enqueueAction(action);
	},


	getDate:function(component){
		var temString = "";
		temString = component.get('v.ITForm.ITF_ID__c');
		var date = temString.split('.');
		var formatDate = date[1] + '/' + date[2] + '/' + date[0];
		return formatDate;
	},

	uploadCSEmailtemplate : function(component){
		//Email Address
		// component.set('v.ToEmailAddress', 'customerservice@silkroadmed.com');
		component.set('v.ToEmailAddress', 'snguyen@silkroadmed.com');

		//Email Subject	
		var ITForm = component.get('v.ITForm');
		var subject = 'SRM ITF - ' + ITForm.ITF_ID__c;
		component.set('v.Subject', subject);

		//Email body
		var currentUser = component.get('v.currentUser');
		var EmailBody ='';

		//add auto note if email was sent directly
		var emailType = component.get('v.emailType');
		if(emailType == 5)
			EmailBody +='=====This is an automatic email which is generated by SRM-SFDC assistant.=====\n\n';

		EmailBody += 'Dear Customer Success,\n';
		EmailBody += '\nI have created an Inventory Transfer Form on salesforce.\n';
		EmailBody += '\nPlease use reference link below to access the Inventory Transfer Form.\n';
		EmailBody += '\nhttps://silkroadmed.lightning.force.com/lightning/r/Inventory_Transfer_Form__c/';
		EmailBody += ITForm.Id + '/view\n';
		EmailBody += '\nThank you.\n\n';
		EmailBody += this.senderInfo(component);
		component.set('v.EmailBody', EmailBody);

		component.set('v.AttachPDFID', ITForm.PDFIDCurrentITForm__c);

		//Turn off loading data window
		component.set('v.LoadingData', false);
		component.set('v.IsSendingAttachment', false);	
	},

	senderInfo: function(component){
		var currentUser = component.get('v.currentUser');
		var info = "";
		info += currentUser.FirstName + ' ' + currentUser.LastName +'\n';
		info += currentUser.Title + '\n';
		info += 'Silk Road Medical Inc'+'\n';
		info += '1213 Innsbruck Drive' + '\n';
		info += 'Sunnyvale, CA 94089' + '\n';
		info += 'O: (408) 720-9002' + '\n';
		info += 'M: '+ currentUser.MobilePhone;
		return info;
	},

	sendEmail:function(component, userchoice){
		var emailType = component.get('v.emailType');
		var Toaddress1 = component.find('Toaddress');
        var Toaddress1Value = Toaddress1.get("v.value");
        var isDesktop = component.get('v.isDesktop');
        var contactList = component.get('v.contactList');
        var i = 0;
        var Toaddress2Value = '';
        var emailType = component.get('v.emailType');
        if(emailType == 2)
        {
        	if(isDesktop == 'True')
        	{
        		var selectedList = component.get('v.selectedList');
        		var isFirstEmail = true;

        		for(i=0; i < contactList.length; i++)
        		{
        			if(selectedList[i])
        			{
        				if(isFirstEmail)
        				{
        					Toaddress2Value += contactList[i].Email;
        					isFirstEmail = false;
        				}else
        				{
        					Toaddress2Value += ';' + contactList[i].Email;
        				}
        			}
        		}
        	}else
        	{
		       	var Toaddress2 = component.find("selectedEmails");
		        Toaddress2Value = Toaddress2.get("v.value");
        	}       	
        }

        var Toaddress = '';

        if(Toaddress1Value !== null & Toaddress1Value !== '')
        {
        	if(Toaddress2Value !== null & Toaddress2Value !== '')
        		Toaddress = Toaddress2Value + ';' + Toaddress1Value;
        	else
        		Toaddress = Toaddress1Value;
        }else if(Toaddress2Value !== null & Toaddress2Value !== '')
        	Toaddress = Toaddress2Value;

        if(Toaddress == null || Toaddress == '')
        {
        	alert ('Missing Send to Email Address');
        	Toaddress1.set("v.errors", [{message:'Missing an email address.'}]);        	
        }else
        {
        	var Toaddresses = Toaddress.split(';');
        	Toaddress1.set("v.errors", null);

        	//Add contact ID to save the send email
        	var ContactIDSaveEmail = "";
        	for(i=0; i < Toaddresses.length; i++)
        	{
        		for(var j=0; j < contactList.length; j++)
        		{
        			if(contactList[j].Email == Toaddresses[i])
        			{
        				ContactIDSaveEmail = contactList[j].Id;
        				i = Toaddresses.length;
        				j = contactList.length;
        			}
        		}
        	}

        	var BccAddresses = component.get('v.CCEmailAddress').split(';');
        	var Subject	= component.get('v.Subject');
        	var EmailBody = component.get('v.EmailBody');
        	var ITFID = component.get('v.ITForm.Id');
        	var IsSendITFCopy = component.get('v.IsSendingAttachment');
        	var MTFID = "";
        	var action = component.get('c.sendAnEmail');
        	component.set('v.waitingMessage', "SFDC is sending an email." );
            component.set('v.WaitingWindow', true);
        	action.setParams({
          		"sendToAddresses": Toaddresses,
          		"bCCAddresses": BccAddresses,
          		"subject": Subject,
          		"emailBody": EmailBody,
          		"ITFID": ITFID,
          		"IsSendITFCopy": IsSendITFCopy,
          		"ContactIDSaveEmail": ContactIDSaveEmail,
          		"MTFID": MTFID
        	});

        	action.setCallback(this, function(response){
            	var state = response.getState();
            	var message = "";
				component.set('v.WaitingWindow', false);
		        if (state === "SUCCESS")
		        {
		        	message = "An email has been successfully sent to " + Toaddress;
		        	message += ".\nIf the email is not shown in receiver's inbox, please check the spam folder.";

        		    if(emailType == 4)
        		    {
        		    	alert(message);
        		    	this.closeITForm(component);
        		    }
        		    else if(emailType == 5)
        		    {
        		    	//alert(message);
        		    	component.set('v.tempStatus',3);
						component.set('v.emailType', 0);
        		    }else
        		    {
        		    	alert(message);
	    		    	component.set('v.tempStatus',3);
						component.set('v.emailType', 0);
        		    }

            	}else if(state === "ERROR")
            	{
            		message = "error on sending an email to "+Toaddress+".\nPlease recheck email addresses on 'To' and 'Bcc' fields.";
            		let errors = response.getError();
            		let errorMessage = 'Unknown error';
					if (errors && Array.isArray(errors) && errors.length > 0) {
					    errorMessage = errors[0].message;
					}
					// Display the message
					console.error(errorMessage);           		

            		alert(message);
            	}else if(state === "INCOMPLETE")
            	{
					message = "Your internet connection is unstable. Please try it later.";
                	alert(message);
				}else
				{
            		message = "An error has occurred.\nWe are sorry for the inconvenience. Please contact SRM SFDC administrator for help.";
            		alert(message);
                }
        	});
        	$A.enqueueAction(action);
        }
	},

	closeITForm : function(component){
    	var ITForm = component.get("v.ITForm");
		var objectID;
		if(ITForm.ITF_Type__c == 'Transfer to Customer' || ITForm.ITF_Type__c == 'External Transfer (Customer to Customer)')
			objectID = ITForm.Customer_To__c;
		else
			objectID = component.get("v.currentUser.Id");

		var navEvt = $A.get("e.force:navigateToSObject");
		navEvt.setParams({
			"recordId": objectID,
			"slideDevName": "detail"
		});
		navEvt.fire();
	},
})

// console.log("Create expense0: " + JSON.stringify(response.getReturnValue()));