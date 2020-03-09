({
	closeWaitingPopUp: function(component, event, helper) {
        component.set("v.WaitingWindow", false);
    },

	doInit: function(component, event, helper) {
		var ITForm = component.get("v.ITForm");

		if(ITForm.Ship_Date__c == null || ITForm.Ship_Date__c == undefined)
		{
			var today = new Date();
	        var year = today.getFullYear();
	        var month = today.getMonth()+1;
	        if(month <=9)
	            month = '0'+ month;

	        var date = today.getDate();
	        if(date <=9)
	            date = '0'+ date;

			component.set('v.ITForm.Ship_Date__c', year + "-" + month + "-" + date);
		}else
		{
			component.set('v.IsShipDateBlank', false);
		}
		component.set("v.WaitingWindow", false);
		

    },

    handleUploadFinished: function (component, event, helper) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        if(uploadedFiles.length > 0){
        	component.set("v.WaitingWindow", true);
        	var ITForm = component.get("v.ITForm");
        	ITForm.TrackingNumberPictureID__c = uploadedFiles[0].documentId;
            helper.updateShippingInfo(component, ITForm);
        }
    },

    submitShippingInfo: function (component, event, helper) 
    {
    	var ITForm = component.get("v.ITForm");
    	var TrackingNumberUploadfile = component.find('TrackingNumber');
    	var errorMessage ="";

    	// if( ITForm.Tracking_Number__c == null || ITForm.Tracking_Number__c == undefined || ITForm.Tracking_Number__c == '')
    	// {
     //        TrackingNumberUploadfile.set("v.errors", [{message:"Please enter a tracking number or take/upload picture of the tracking number."}]);
     //        errorMessage += "Missing tracking number.\n";
    	// }else
    	// {
    	// 	TrackingNumberUploadfile.set("v.errors", null);
    	// }

    	if(errorMessage !== "")
    		alert(errorMessage);
    	else
    	{
    		component.set("v.WaitingWindow", true);
    		helper.updateShippingInfo(component, ITForm);
    	}
    	   	
    },
})
// console.log("javascript debug: " + JSON.stringify(ITForm));