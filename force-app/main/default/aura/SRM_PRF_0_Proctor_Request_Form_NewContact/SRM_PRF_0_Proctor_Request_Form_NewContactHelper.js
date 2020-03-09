({
	getPhysicianInfo : function(component) {
		var recordId = component.get("v.recordId");
		var action = component.get('c.getContactInfo');

        action.setParams({
            "contactID": recordId,
        });

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS") 
            {
                var contact= response.getReturnValue(); //get return value
                component.set("v.PhysicianContact", contact);

                //Prevent to create a proctor request for a SRM proctor contact
                if(contact.is_External_Proctor__c || contact.Is_Internal_Proctor__c)
                {
                    var errormessage = contact.Name + ' is our SRM proctor. You cannot request a proctor for the Physician.';
                    alert(errormessage);
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": contact.Id,
                        "slideDevName": "detail"
                    });
                    navEvt.fire();               
                }

                //Warning duplicate proctor request
                if(contact.Department != null && contact.Department != undefined && contact.Department != '' && !contact.is_External_Proctor__c && !contact.Is_Internal_Proctor__c)
                {
                    var errormessage = 'SRM-SFDC assistant finds an opening request form for the physician.\n\n';
                    errormessage = errormessage + 'Physician: ' + contact.Name + '\n';
                    errormessage = errormessage + 'Hospital: ' + contact.Department + '\n';
                    errormessage = errormessage + 'Request Date: ' + contact.Birthdate + '\n';
                    errormessage = errormessage + 'PRF Status: ' + contact.Email + '\n';
                    errormessage = errormessage + '\nDo you want to view the opening proctor request form?';
                    var choice = confirm(errormessage);
                    if(choice)
                    {
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": contact.OwnerId,
                            "slideDevName": "detail"
                        });
                        navEvt.fire();                          
                    }
                }

                this.getAccountList(component, contact);
            }else if(state === "ERROR")
            {
                let errors = response.getError();
                let errorMessage = 'Unknown error';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    errorMessage = errors[0].message;
                }
                // Display the message
                console.log(errorMessage);  
                component.set("v.WaitingWindow", false);                 
                alert("Sorry, we have an error on getting Physician info. Please contact the SRM-SFDC administrator.");
            }else if(state === "INCOMPLETE")
            {
            	component.set("v.WaitingWindow", false);
            	alert("Look like Server is busy right now. Please try to refresh the page again. Thanks");
            }else
            {
            	component.set("v.WaitingWindow", false);
            	alert("Unexpected error - Please report this issue with the SRM-SFDC administrator.");
            }
        });

        //execute process	
        $A.enqueueAction(action);        
	},

	getAccountList : function(component, contact) {
		var action = component.get('c.getHositalInfo');

		action.setParams({
            "contactID": contact.Id,
            "accountID": contact.AccountId
        });

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var Accounts= response.getReturnValue(); //get return value
                Accounts.unshift({Id:'', Name: 'Please select an Account'});
                component.set("v.AccountList", Accounts);
                this.getSRMProctorList(component, contact, Accounts);
            }else if(state === "ERROR")
            {
                let errors = response.getError();
                let errorMessage = 'Unknown error';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    errorMessage = errors[0].message;
                }
                // Display the message
                console.log(errorMessage);
                component.set("v.WaitingWindow", false);                   
                alert("Sorry, we have an error on getting Account list. Please contact the SRM-SFDC administrator.");
            }else if(state === "INCOMPLETE")
            {
                component.set("v.WaitingWindow", false);
            	alert("Look like Server is busy right now. Please try to refresh the page again. Thanks");
            }else
            {
                component.set("v.WaitingWindow", false);
            	alert("Unexpected error - Please report this issue with the SRM-SFDC administrator.");
            }
        });

        //execute process
        $A.enqueueAction(action);        	
	},

	getSRMProctorList : function(component, contact, Accounts) {
		var action = component.get('c.getSRMProctors');

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var SRMProctors= response.getReturnValue(); //get return value
                var NullProctor = { "Id":"N/A",
                                    "FirstName":"First Name",
                                    "LastName":"Last Name",
                                    "Account":{ "BillingCity":"City","BillingState":"State",}};
                SRMProctors.unshift(NullProctor);

                component.set("v.SRMProctors", SRMProctors);
                this.getSRMTESLAList(component, contact, Accounts, SRMProctors);
            }else if(state === "ERROR")
            {
                let errors = response.getError();
                let errorMessage = 'Unknown error';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    errorMessage = errors[0].message;
                }
                // Display the message
                console.log(errorMessage); 
                component.set("v.WaitingWindow", false);                  
                alert("Sorry, we have an error on getting SRM Proctor list. Please contact the SRM-SFDC administrator.");
            }else if(state === "INCOMPLETE")
            {
                component.set("v.WaitingWindow", false);
            	alert("Look like Server is busy right now. Please try to refresh the page again. Thanks");
            }else
            {
                component.set("v.WaitingWindow", false);
            	alert("Unexpected error - Please report this issue with the SRM-SFDC administrator.");
            }
        });

        //execute process
        $A.enqueueAction(action);        	
	},

    getSRMTESLAList : function(component, contact, Accounts, SRMProctors) {
		var action = component.get('c.getTESLAUsers');

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var SRMTeslaUsers= response.getReturnValue(); //get return value
                var NullTeslaUser = {"City":"City","Id":"N/A","Name":"Name","State":"State"};
                SRMTeslaUsers.unshift(NullTeslaUser);
                component.set("v.SRMTESLAUsers", SRMTeslaUsers);
                this.getUserInfo(component, contact, Accounts, SRMProctors);
            }else if(state === "ERROR")
            {
                let errors = response.getError();
                let errorMessage = 'Unknown error';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    errorMessage = errors[0].message;
                }
                // Display the message
                console.log(errorMessage); 
                component.set("v.WaitingWindow", false);                  
                alert("Sorry, we have an error on getting SRM TESLA list. Please contact the SRM-SFDC administrator.");
            }else if(state === "INCOMPLETE")
            {
                component.set("v.WaitingWindow", false);
            	alert("Look like Server is busy right now. Please try to refresh the page again. Thanks");
            }else
            {
                component.set("v.WaitingWindow", false);
            	alert("Unexpected error - Please report this issue with the SRM-SFDC administrator.");
            }
        });

        //execute process
        $A.enqueueAction(action);        	
	},

    getUserInfo : function(component, contact, Accounts, SRMProctors) 
    {
        var action = component.get('c.getCurrentUser');

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var userInfo= response.getReturnValue(); //get return value
                component.set("v.userInfo", userInfo);
                this.getRecordTypes(component, contact, Accounts, SRMProctors, userInfo);
            }else if(state === "ERROR")
            {
                let errors = response.getError();
                let errorMessage = 'Unknown error';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    errorMessage = errors[0].message;
                }
                // Display the message
                console.log(errorMessage); 
                component.set("v.WaitingWindow", false);                  
                alert("Sorry, we have an error on getting user information. Please contact the SRM-SFDC administrator.");
            }else if(state === "INCOMPLETE")
            {
                component.set("v.WaitingWindow", false);
                alert("Look like Server is busy right now. Please try to refresh the page again. Thanks");
            }else
            {
                component.set("v.WaitingWindow", false);
                alert("Unexpected error - Please report this issue with the SRM-SFDC administrator.");
            }
            
        });

        //execute process
        $A.enqueueAction(action);           
    },

    getRecordTypes : function(component, contact , Accounts, SRMProctors, userInfo) 
    {
        var action = component.get('c.getPFRecordTypeID');

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var RecordTypes= response.getReturnValue(); //get return value
                component.set("v.RecordTypes", RecordTypes);
                this.continuetoInitializePRF(component, contact, Accounts, SRMProctors, userInfo);
            }else if(state === "ERROR")
            {
                let errors = response.getError();
                let errorMessage = 'Unknown error';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    errorMessage = errors[0].message;
                }
                // Display the message
                console.log(errorMessage); 
                component.set("v.WaitingWindow", false);                  
                alert("Sorry, we have an error on getting list of proctor/TESLA types. Please contact the SRM-SFDC administrator.");
            }else if(state === "INCOMPLETE")
            {
                component.set("v.WaitingWindow", false);
                alert("Look like Server is busy right now. Please try to refresh the page again. Thanks");
            }else
            {
                component.set("v.WaitingWindow", false);
                alert("Unexpected error - Please report this issue with the SRM-SFDC administrator.");
            }
            
        });

        //execute process
        $A.enqueueAction(action);           
    },

	continuetoInitializePRF : function(component, contact , Accounts, SRMProctors, userInfo) 
	{
        var PRF = component.get("v.PRF");

        //Initialize unique ID
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
        PRF.Proctor_Form_ID__c = currenttime + "-" + userInfo.LastName + "," + userInfo.FirstName + "-" + contact.LastName + "," + contact.FirstName;
        if(PRF.Proctor_Form_ID__c.length > 79)
            PRF.Proctor_Form_ID__c = PRF.Proctor_Form_ID__c.substring(0, 79);
        PRF.Name = year + '.' + month + '.' + date + ' - ' + contact.FirstName + ' ' + contact.LastName + ' requested by ' + userInfo.FirstName + ' ' + userInfo.LastName;

        if(PRF.Name.length > 79)
        {
            PRF.Name = year + '.' + month + '.' + date + ' - ' + contact.FirstName.substring(0, 3) + ' ' + contact.LastName.substring(0, 3)  + ' requested by ';
            PRF.Name = PRF.Name + userInfo.FirstName.substring(0, 3) + ' ' + userInfo.LastName.substring(0, 3);
        }

        //Initialize all possible fields
        PRF.Hospital_Name__c = contact.AccountId;
        PRF.Requested_By__c = userInfo.Id;
        PRF.Request_Date__c = year + "-" + month + "-" + date;
        PRF.Physician_to_be_proctored__c = contact.Id;
        PRF.Physician_to_be_Proctored_Name__c = contact.LastName + ", " + contact.FirstName;
        PRF.Approved_by__c = userInfo.ManagerId;

        PRF.Status__c = "New";
        PRF.Stage__c = "AD Reviewing";

        var reason = component.get("v.ProctoringReason");
        reason.push("Selected - None");
        reason.push("90+ days past TEST Drive");
        reason.push("Exception to TEST Drive");
        reason.push("Hospital Mandated");

        component.set("v.ProctoringReason", reason);
        component.set("v.PRF", PRF);
        component.set("v.WaitingWindow", false);
	},

    checkPRFvalid : function(component) {
        var PRF = component.get("v.PRF");
        var isValid = true;
        var errorMessage ="";

        //Check TESLA/Proctor selection
        var selectedProctor = component.get("v.selectedProctor");
        var selectedTESLA = component.get("v.selectedTESLA");
        var selectedBoth = component.get("v.selectedBoth");

        if( !selectedProctor && !selectedTESLA && !selectedBoth)
        {
            errorMessage += "Missing Requested TESLA/Proctor\n";
            component.set("v.MissingRequestor", true);
            isValid = false;
        }else
        {
            component.set("v.MissingRequestor", false);
        }

        if(selectedProctor || selectedBoth)
        {
            var RequestProctor = component.find('RequestProctor');
            if(PRF.Requested_Proctor__c == null || PRF.Requested_Proctor__c == '' || PRF.Requested_Proctor__c == 'N/A' )
            {
                RequestProctor.set("v.errors", [{message:"Please select one proctor."}]);
                errorMessage += "Missing Requested Proctor\n";
                isValid = false;
            }else{
                RequestProctor.set("v.errors", null);
            }
        }

        if(selectedTESLA || selectedBoth)
        {
            var RequestTESLA = component.find('RequestTESLA');
            if(PRF.Requested_TESLA__c == null || PRF.Requested_TESLA__c == '' || PRF.Requested_TESLA__c == 'N/A' )
            {
                RequestTESLA.set("v.errors", [{message:"Please select one TESLA."}]);
                errorMessage += "Missing Requested TESLA\n";
                isValid = false;
            }else{
                RequestTESLA.set("v.errors", null);
            }
        }
        //End of Checking TESLA/Proctor selection

        var HospitalName = component.find('HospitalName');
        if(PRF.Hospital_Name__c == null || PRF.Hospital_Name__c == '' || PRF.Hospital_Name__c == undefined)
        {
            HospitalName.set("v.errors", [{message:"Please select one hospital."}]);
            errorMessage += "Missing a hospital\n";
            isValid = false;
        }else{
            HospitalName.set("v.errors", null);
        }

        var ProctorRequestDate = component.find('ProctorRequestDate');
        if(PRF.Proctor_Request_Date__c == null || PRF.Proctor_Request_Date__c == '' )
        {
            ProctorRequestDate.set("v.errors", [{message:"Please pick a date in future."}]);
            errorMessage += "Missing Requested Date\n";
            isValid = false;
        }else
        {
            var today = new Date();
            var pickDate = new Date(PRF.Proctor_Request_Date__c);

            if( pickDate < today )
            {
                ProctorRequestDate.set("v.errors", [{message:"Please pick a date in future."}]);
                errorMessage += "Wrong Requested Date\n";
                isValid = false;                
            }else
                ProctorRequestDate.set("v.errors", null);
        }   

        var ReasonProctoring = component.find('ReasonProctoring');
        if(PRF.Reason_for_Proctoring__c == null || PRF.Reason_for_Proctoring__c == '' || PRF.Reason_for_Proctoring__c == 'Selected - None')
        {
            ReasonProctoring.set("v.errors", [{message:"Please choose one reason."}]);
            errorMessage += "Missing Proctor reason\n";
            isValid = false;
        }else{
            ReasonProctoring.set("v.errors", null);
        }

        var HospitalCredentialing = component.find('HospitalCredentialing');
        var StringHospitalCredentialing = component.get('v.StringHospitalCredentialing');
        if(StringHospitalCredentialing == null || StringHospitalCredentialing == '' || StringHospitalCredentialing == 'N/A')
        {
            HospitalCredentialing.set("v.errors", [{message:"Please choose 'Yes'/'No' to confirm hospital credentialing requirement."}]);
            errorMessage += "Missing hospital credentialing requirement\n";
            isValid = false;
        }else{
            HospitalCredentialing.set("v.errors", null);
        }

        var Hours = component.get('v.Hours');
        var TotalCases = component.get('v.TotalCases');
        var Periods = component.get('v.Periods');
        var ProctorNumberCases = component.find('ProctorNumberCases');

        if(TotalCases == 0)
        {
            ProctorNumberCases.set("v.errors", [{message:"Please choose at least 1 TCAR case."}]);
            errorMessage += "Missing total TCAR expected cases\n";
            isValid = false;
        }else
        {
            ProctorNumberCases.set("v.errors", null);        
            var StartTimePeriod0 = component.find('StartTimePeriod0');
            if(Periods[0] == 'AM' && (Number(Hours[0])<5 || Number(Hours[0])>11))
            {
                StartTimePeriod0.set("v.errors", [{message:"Please pick a start time after 4:45 AM."}]);
                errorMessage += "Incorrect start time for the 1st TCAR case\n";
                isValid = false;
            }else{
                StartTimePeriod0.set("v.errors", null);
            }
        }

        if(!isValid)
        {
            alert(errorMessage);
        }

        return isValid;       
    },

    submitPRForm : function(component) {
        var PRF = component.get("v.PRF");

        var StringHospitalCredentialing = component.get('v.StringHospitalCredentialing');
        if(StringHospitalCredentialing == 'Yes')
            PRF.Special_Hospital_Credentialing_Required__c = true;

        var TotalCases = component.get('v.TotalCases');
        var Hours = component.get('v.Hours');        
        var Minutes = component.get('v.Minutes');
        var Periods = component.get('v.Periods');      
        var SRMAttendees = component.get('v.SRMAttendees');

        PRF.Number_of_cases__c = TotalCases;
        var TCARCaseInfo = '';
        var temp = '';
        var tempSRMAttendees = '';
        var i = 0;
        for(i=0; i<TotalCases; i++)
        {
            temp = 'Case ' + (i+1).toString() + ': ';
            tempSRMAttendees = SRMAttendees[i].replace(/\r\n/g,';').replace(/;;/g,';');
            if(Hours[i] == '0' && Minutes[i] == '0' && Periods[i] == 'AM')
            {
                temp += 'Start time - N/A | ';
            }else
            {
                if(Hours[i] == '0' && Periods[i] == 'PM')
                    temp += 'Start time - 12:' + Minutes[i] + ' ' +  Periods[i] + ' | ';
                else
                    temp += 'Start time - ' + Hours[i] + ':' + Minutes[i] + ' ' +  Periods[i] + ' | ';
            }

            if(tempSRMAttendees == '')
            {
                temp += 'SRM Attendees/Commments: N/A\n';
            }else
            {
                temp += 'SRM Attendees/Commments: ' + tempSRMAttendees + '\n';
            }
            TCARCaseInfo += temp;
        }

        if(TCARCaseInfo.length > 999)
        {
            PRF.TCAR_Cases_Info__c = TCARCaseInfo.substring(0, 990) + '\n...';
        }else
        {
            PRF.TCAR_Cases_Info__c = TCARCaseInfo;
        }

        //Set record type and clear unexpected TESLA/Proctor selection 
        var RecordTypes = component.get("v.RecordTypes");
        var selectedProctor = component.get("v.selectedProctor");
        var selectedTESLA = component.get("v.selectedTESLA");
        var selectedBoth = component.get("v.selectedBoth");

        if(selectedProctor)
        {
            //Remove selected TESLA User
            PRF.Requested_TESLA__c = null;

            for(i=0; i<RecordTypes.length; i++)
            {
                if(RecordTypes[i].DeveloperName == 'Proctor_Request_Form')
                {
                    PRF.RecordTypeId = RecordTypes[i].Id;
                }
            }
        }

        if(selectedTESLA)
        {
            //Remove selected Proctor Contact
            PRF.Requested_Proctor__c = null;

            for(i=0; i<RecordTypes.length; i++)
            {
                if(RecordTypes[i].DeveloperName == 'TESLA_Request_Form')
                {
                    PRF.RecordTypeId = RecordTypes[i].Id;
                }
            }
        }

        if(selectedBoth)
        {
            for(i=0; i<RecordTypes.length; i++)
            {
                if(RecordTypes[i].DeveloperName == 'Proctor_and_TESLA_Request_Form')
                {
                    PRF.RecordTypeId = RecordTypes[i].Id;
                }
            }
        }
        //End of Setting record type and clear unexpected TESLA/Proctor selection

        var action = component.get('c.upsertPRForm');

        action.setParams({
            "PRF": PRF
        });

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var objectID = response.getReturnValue();

                alert("The form was successfully saved. You will be redirect to the form record.");
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": objectID,
                    "slideDevName": "detail"
                });
                navEvt.fire();
            }else if(state === "ERROR")
            {
                let errors = response.getError();
                let errorMessage = 'Unknown error';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    errorMessage = errors[0].message;
                }
                // Display the message
                console.log(errorMessage); 
                component.set("v.WaitingWindow", false);                  
                alert("Sorry, we have an error on saving the form. Please contact the SRM-SFDC administrator.");
            }else if(state === "INCOMPLETE")
            {
                component.set("v.WaitingWindow", false);
                alert("Look like Server is busy right now. Please try to press submit button again. Thanks");
            }else
            {
                component.set("v.WaitingWindow", false);
                alert("Unexpected error - Please report this issue with the SRM-SFDC administrator.");
            }
            
        });

        //execute process
        $A.enqueueAction(action);           
    },
})

// console.log("Create expense8: " + JSON.stringify(result));