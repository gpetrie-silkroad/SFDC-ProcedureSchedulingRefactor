({
	initialvalues: function(component, event, helper){
		helper.updateUserNames(component);
		//Check a new ITF or an old ITF
		var recordId = component.get("v.recordId");
		if(recordId != null & recordId !=''){
			component.set('v.signInPerson', false);//set default upload customer signature files
		}else{
			component.set('v.signInPerson', true);
		}
	},

	updateNames: function(component, event, helper) {
        component.set('v.ITForm.AutoSaveCopy__c', false);
		helper.updateUserNames(component);
	},

	updateITForm: function(component, event, helper) {
		var ITForm = component.get("v.ITForm");
		var createEvent = component.getEvent("updateITFormFromPreview");        
        createEvent.setParams({ "ITForm": ITForm });
        createEvent.fire();
	},

    Init : function(component, event, helper) {
    	var ITForm = component.get("v.ITForm");
        var ITFTransactions = component.get('v.ITFTransactions');

    	// var signInPerson = component.get("v.signInPerson");
        var signInPerson = true
        component.set('v.signInPerson', true);

        var initialDrawing = component.get("v.initialDrawing");
    	if((ITForm.signAttachID__c == null || ITForm.signAttachID__c == '') 
            & signInPerson
            & initialDrawing
            & ITForm.ITF_Type__c !== 'Internal Transfer (AM/TDS to AM/TDS)'
            & (ITForm.CustomerSignViaDocumentID__c == null || ITForm.CustomerSignViaDocumentID__c =='')
            & ITFTransactions.length != 0)
        {
        	helper.doInit(component, event, helper);
            component.set('v.initialDrawing',false);
        }
    },

    erase:function(component, event, helper){
        helper.eraseHelper(component, event, helper);
    },

    saveSign:function(component, event, helper){
        var extrastep = 'sendNotifiedEmailtoCS';
        helper.saveHelper(component, event, helper, extrastep);
    },

    editSRMInfo:function(component, event, helper){
        //Check that do rep/tds forgot to save signature
        var isUnsavedSignature = helper.checkCustomerSignature(component);
        if(isUnsavedSignature)
            alert("Customer's signature area is not empty. Please save customer's signature or clear the area.")
        else
            component.set('v.tempStatus',0);
    },

    editSRMDetail:function(component, event, helper){
        var isUnsavedSignature = helper.checkCustomerSignature(component);
        if(isUnsavedSignature)
            alert("Customer's signature area is not empty. Please save customer's signature or clear the area.")
        else
            component.set('v.tempStatus',1);
    },

    editSRMTransactions:function(component, event, helper){
        var isUnsavedSignature = helper.checkCustomerSignature(component);
        if(isUnsavedSignature)
            alert("Customer's signature area is not empty. Please save customer's signature or clear the area.")
        else
            component.set('v.tempStatus',2);
    },    

    //Disable moving screen when customer is signing
    handleTouchMove: function(component, event, helper) {
    	event.stopPropagation();
	},

	createHardCopyPDF: function(component, event, helper) {
    	helper.createAttachPDFfile(component, 0);
	},

	sendEmailToSRMCS: function(component, event, helper) {
        //Disable delete ITF function for rep/tds before sending email
        var ITForm = component.get('v.ITForm');
        if(ITForm.EditableByRepTDS__c){
            component.set("v.ITForm.EditableByRepTDS__c", false);
            if(ITForm.Status__c == "ITF Draft"){
                component.set("v.ITForm.Status__c", "Transacted Inventory/Verification");
                ITForm.Status__c = 'Transacted Inventory/Verification';
            }
            ITForm.EditableByRepTDS__c = false;
            var createEvent = component.getEvent("updateITFormFromPreview");
            createEvent.setParams({ "ITForm": ITForm });
            createEvent.fire();
        }

        //Check that do rep/tds forgot to save signature
        var isUnsavedSignature = helper.checkCustomerSignature(component);

        if(isUnsavedSignature)
        {
            var extrastep = 'sendEmailToSRMCS';
            helper.saveHelper(component, event, helper, extrastep);
        }
        else
        {
            helper.sendEmailtoCS(component);
        }
	},

	sendPDFCopyToCustomer: function(component, event, helper) {
        component.set('v.WaitingWindow', true);
		helper.createRecordAttachPDFfile(component, 2);
	},

    handleUploadFinished: function (component, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        if(uploadedFiles.length > 0){
        	var ITForm = component.get("v.ITForm");
        	ITForm.CustomerSignViaDocumentID__c = uploadedFiles[0].documentId;
            component.set("v.ITForm.EditableByRepTDS__c", false);
            if(ITForm.Status__c == "ITF Draft"){
                component.set("v.ITForm.Status__c", "Transacted Inventory/Verification");
                ITForm.Status__c = 'Transacted Inventory/Verification';
            }
            ITForm.EditableByRepTDS__c = false;

            //Send a notified email
            component.set('v.emailType', 5);
            component.set('v.tempStatus',4);

            //Update the ITForm
			var createEvent = component.getEvent("updateITFormFromPreview");
        	createEvent.setParams({ "ITForm": ITForm });
        	createEvent.fire();
        }
    },

    signInPersonMode: function (component, event, helper) {
		component.set('v.signInPerson', true);
    },

    downloadUploadCustomerSignature: function(component) {
        var ITForm = component.get("v.ITForm");
        var baseurl = "/sfc/servlet.shepherd/document/download/";
        var download = "?&operationContext=S1";
        window.open(baseurl + ITForm.CustomerSignViaDocumentID__c + download);
    },

    turnoffwaitingwindow: function (component, event, helper) {
        component.set('v.WaitingWindow', false);
    },

    closeandjumtoCustomeroruserdetail: function (component, event, helper) 
    {
        //Check that do rep/tds forgot to save signature
        var isUnsavedSignature = helper.checkCustomerSignature(component);

        if(isUnsavedSignature)
        {
            var extrastep = 'close ITForm';
            helper.saveHelper(component, event, helper, extrastep);
        }
        else
        {
            helper.closeITForm(component);
        }
    },

    downloadPDFCopyDetailVersion: function(component, event, helper) {
        component.set('v.isLoading',true);
        helper.createRecordAttachPDFfile(component, 10);
    },

    downloadPDFCopyLightVersion: function(component, event, helper) {
        var ITForm = component.get("v.ITForm");
        var baseurl = "";
        var download = "";
        helper.createAttachPDFfile(component, 1);
        
        // if(ITForm.signAttachID__c != null & ITForm.signAttachID__c !='')
        // {
        //     if(ITForm.PDFID__c != null)
        //     {
        //         baseurl = "/servlet/servlet.FileDownload?file=";
        //         download = "&operationContext=S1";
        //         window.open(baseurl + ITForm.PDFID__c + download);
        //     }else
        //     {
        //         //create a pdf and download
        //         helper.createAttachPDFfile(component, 1);
        //     }
        // }else
        // {
        //     if(ITForm.CustomerSignViaDocumentID__c == null || ITForm.CustomerSignViaDocumentID__c == '')
        //         alert("The inventory transfer form is missed customer's signature. Please complete customer signature section before download a hard copy.");
        //     else
        //     {
        //         baseurl = "/sfc/servlet.shepherd/document/download/";
        //         download = "?&operationContext=S1";
        //         window.open(baseurl + ITForm.CustomerSignViaDocumentID__c + download);
        //     }
        // } 
    },

    deleteITF: function(component, event, helper) {
        if(component.get('v.ITForm.EditableByRepTDS__c'))
        {
            var userchoice = confirm("Do you want to delete this form?"); // return true or false based on user choose
            if(userchoice)
                helper.deleteITForm(component);
        }else
        {
            alert('Customer Success is reviewing the form. Please contact CS to delete the form.');
        }
    },

    closeWaitingPopUp: function(component, event, helper)
    { 
        component.set("v.WaitingWindow", false);
    },

    submitITF: function(component, event, helper)
    {
        var ITForm = component.get('v.ITForm');
        ITForm.EditableByRepTDS__c = false;
        ITForm.Status__c = 'Transacted Inventory/Verification';
        helper.UpdateITFormHeader(component, ITForm);
    },
})

// console.log("Error to create the new ITF info: " + JSON.stringify(ITForm));