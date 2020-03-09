({
	NextSaveButton: function(component, event, helper) {
        var SRMInfoFormAMInputField = component.find('SRMInfoFormAM');
        var SRMInfoFormAMValue = SRMInfoFormAMInputField.get("v.value");
        var SRMInfoFormTDSInputField = component.find('SRMInfoFormTDS');
        var SRMInfoFormTDSValue = SRMInfoFormTDSInputField.get("v.value"); 
        var SRMInfoFormOtherInputField = component.find('SRMInfoFormOther');
        var SRMInfoFormOtherValue = SRMInfoFormOtherInputField.get("v.value");
        var SRMInfoFormInputField = component.find('SRMInfoForm');
        var SRMInfoFormValue = SRMInfoFormInputField.get("v.value");
        var isValid = false;
        var isDateValid = false;
        var currentStatus = component.get('v.currentStatus');
        var ITForm = component.get('v.ITForm');
        var errorMessage = '';

        if(SRMInfoFormValue != null & SRMInfoFormValue != ''){
            isDateValid = true;
            SRMInfoFormInputField.set("v.errors", null);
        }else{
            SRMInfoFormInputField.set("v.errors", [{message:"Please choose a valid date"}]);
            errorMessage = "\nMissing Transferred Date."
        }
        if(SRMInfoFormOtherValue != null & SRMInfoFormOtherValue != '')
            isValid = true;
        else if(SRMInfoFormTDSValue != null & SRMInfoFormTDSValue != '')
            isValid = true;
        else if(SRMInfoFormAMValue != null & SRMInfoFormAMValue != '')
            isValid = true;

        if(isValid){       
            SRMInfoFormOtherInputField.set("v.errors", null);
        }else{
            //error message for invalid field
            errorMessage += "\nPlease select at least 1 person field."
            SRMInfoFormOtherInputField.set("v.errors", [{message:'Please select at least 1 person field.'}]);
        }

        //Update the ITF when all fields are valid   
        if(isValid & isDateValid){
            if(currentStatus == 0){
                component.set('v.ITForm.Status__c', 'ITF Draft');
                component.set('v.currentStatus', 1);
                component.set('v.tempStatus', 1); //status 1: move to ITF Detail Section
            }
            else if(currentStatus < 3){
                component.set('v.tempStatus', 1);
            }else{
                component.set('v.tempStatus', currentStatus);
            }
            var createEvent = component.getEvent("updateITFormFromSRMInfo");
            createEvent.setParams({ "ITForm": ITForm });
            createEvent.fire(); 
        }else{
            alert(errorMessage);
        }
	},
})