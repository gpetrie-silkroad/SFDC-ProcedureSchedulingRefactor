({
    updateShippingInfo: function (component, ITForm) 
    {
    	ITForm.EditableByRepTDS__c = false;
    	ITForm.Status__c = 'Transacted Inventory/Verification';
    	// ITForm.SendEmailToCS__c = true;

        var action = component.get('c.updateITF');

        action.setParams({
            "iTForm": ITForm
        });

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();

                alert("The form was successfully updated. The page will be refreshed to update ITF status.");
                // var navEvt = $A.get("e.force:navigateToSObject");
                // navEvt.setParams({
                //     "recordId": result.Id,
                //     "slideDevName": "detail"
                // });
                // navEvt.fire();
                window.location.reload(true);
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
                alert("Sorry, we have an error on updating the form. Please contact the SRM-SFDC administrator.");
            }else if(state === "INCOMPLETE")
            {
                component.set("v.WaitingWindow", false);
                component.set('v.ITForm', ITForm);
                alert("Look like Server is busy right now. Please try to press update button again. Thanks");
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