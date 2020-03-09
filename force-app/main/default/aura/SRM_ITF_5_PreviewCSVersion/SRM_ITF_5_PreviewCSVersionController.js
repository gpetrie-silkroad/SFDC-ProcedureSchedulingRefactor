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
		helper.updateUserNames(component);
	},

	updateITForm: function(component, event, helper) {
		var ITForm = component.get("v.ITForm");
		var createEvent = component.getEvent("updateITFormFromPreview");
        createEvent.setParams({ "ITForm": ITForm });
        createEvent.fire();
	},

    Init : function(component, event, helper) {
    	var signAttachID = component.get("v.ITForm.signAttachID__c");
    	var signInPerson = component.get("v.signInPerson");
        var initialDrawing = component.get("v.initialDrawing");
    	if((signAttachID == null || signAttachID == '') & signInPerson & initialDrawing){
        	helper.doInit(component, event, helper);
            component.set('v.initialDrawing',false);
        }

        var ITForm = component.get("v.ITForm");
        if(ITForm.ITF_CS_Process__c == "New" &  ITForm.Status__c == 'Transacted Inventory/Verification')
        {
            component.set("v.ITForm.ITF_CS_Process__c", "In Process");
            console.log("Initial it is running");
            ITForm.ITF_CS_Process__c = "In Process";
            helper.updateITFCSProcess(component, ITForm);
        }          
    },

    erase:function(component, event, helper){
        helper.eraseHelper(component, event, helper);
    },
    save:function(component, event, helper){
        helper.saveHelper(component, event, helper);
    },

    editSRMInfo:function(component, event, helper){
        component.set('v.tempStatus',0);
    },

    editSRMDetail:function(component, event, helper){
        component.set('v.tempStatus',1);
    },

    editSRMTransactions:function(component, event, helper){
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
		helper.createRecordAttachPDFfile(component, 1);
	},

	sendPDFCopyToCustomer: function(component, event, helper) {
		helper.createRecordAttachPDFfile(component, 2);
	},

	refreshTransactionsData: function(component, event, helper) {
		helper.getITFTransactions(component);
		var transactions = component.get('v.ITFTransactions');
	},

	onChangeITFTransaction: function(component) {
        component.set('v.isChangeonITFTransaction', true);
    },

    onChangeITForm: function(component) {
        component.set('v.isChangeonITForm', true);
    },

    updateITFtoSFDC: function(component, event, helper){
        var status = component.get("v.ITForm.Status__c");
        var ITFCSProcess = component.get("v.ITForm.ITF_CS_Process__c");
        var isChangeonITForm = component.get('v.isChangeonITForm');
        var isChangeonITFTransaction = component.get('v.isChangeonITFTransaction');
        var editableByRepTDS__c = component.get('v.ITForm.EditableByRepTDS__c');

        //check status - change if neccessary
        if(status == "ITF Draft"){
            component.set("v.ITForm.Status__c", "Transacted Inventory/Verification");
            isChangeonITForm = true;
        }

        if(status == 'Pending PO' || status == 'Closed')
        {
            component.set("v.ITForm.ITF_CS_Process__c", "Complete");
            isChangeonITForm = true;
        }

        //Disable edit funtion for Rep/TDS if it is still on
        if(editableByRepTDS__c == true)
        {
            component.set("v.ITForm.EditableByRepTDS__c", false);
            isChangeonITForm = true;
        }

        //Update Summary used item
        var transactions = component.get('v.ITFTransactions');
        var summary = '';
        for(var i=0; i<transactions.length; i++)
        {
            if(i==0)
            {
                summary = transactions[i].Quantity__c + '-' + transactions[i].Product_Number__c;
            }else
            {
                summary = summary + ', ' + transactions[i].Quantity__c + '-' + transactions[i].Product_Number__c;
            }
        }
        summary.substr(0,254);
        var summaryUsedItem = component.get('v.ITForm.Summary_Used_Item__c');
        if( summaryUsedItem !== summary)
        {
            component.set('v.ITForm.Summary_Used_Item__c', summary);
            isChangeonITForm = true;
        }

        //Update ITform and transaction if neccessary
    	if(isChangeonITForm)
    		helper.updateITFormDirectly(component, isChangeonITFTransaction);

    	if(isChangeonITFTransaction){
    		//var transactions = component.get('v.ITFTransactions');
    		for(var i=0; i<transactions.length; i++){
				helper.updateITFTransactionDirectly(component, transactions[i]);
			}    		
    	}
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

    downloadUploadCustomerSignature: function(component) {
    	var ITForm = component.get("v.ITForm");
    	var baseurl = "/sfc/servlet.shepherd/document/download/";
    	var download = "?&operationContext=S1";
    	window.open(baseurl + ITForm.CustomerSignViaDocumentID__c + download);
    },

    downloadPDFCopyDetailVersion: function(component, event, helper) {
    	component.set('v.isLoading',true);
    	helper.createRecordAttachPDFfile(component, 10);
    },

    handleUploadFinished: function (component, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        if(uploadedFiles.length > 0){
        	var ITForm = component.get("v.ITForm");
            component.set("v.ITForm.EditableByRepTDS__c", false);
        	ITForm.CustomerSignViaDocumentID__c = uploadedFiles[0].documentId;
            ITForm.EditableByRepTDS__c = false;
			var createEvent = component.getEvent("updateITFormFromPreview");
        	createEvent.setParams({ "ITForm": ITForm });
        	createEvent.fire();
        }
    },

    signInPersonMode: function (component, event, helper) {
		component.set('v.signInPerson', true);
    },


    deleteITF: function (component, event, helper) {
        var userchoice = confirm("Do you want to delete this form?"); // return true or false based on user choose
        if(userchoice)
            helper.deleteITForm(component);
    },

    updateCSProcess: function (component, event, helper) {
        var ITForm = component.get("v.ITForm");

        if(ITForm.ITF_CS_Process__c == "New" &  ITForm.Status__c == 'Transacted Inventory/Verification')
        {
            component.set("v.ITForm.ITF_CS_Process__c", "In Process");
            console.log("it is running");
            ITForm.ITF_CS_Process__c = "In Process";
            helper.updateITFCSProcess(component, ITForm);

        }
    },

    editTransactionDetail: function (component, event, helper)
    {
        var message = 'Before editing transaction detail, please be aware that:\n'
        message = message + '1. Please adjust transacted units on QAD if you have transacted the item on ERP System.\n';
        message = message + '2. Please send the updated ITF to rep/customer after you update.\n'
        alert(message);
        component.set("v.DisableDetailModify", false);
    },

    downloadMTFVersion: function(component, event, helper)
    {
        helper.createMTFPDFfile(component);
    },
})

// console.log("Create expense4: " + JSON.stringify(uploadedFiles));