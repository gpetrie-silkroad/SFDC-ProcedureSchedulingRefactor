({
    getEmailTemplate: function(component) 
    {
        var TSCCount = component.get('v.TSCCount');
        var action = component.get('c.getTSAuditReminderEmailTemplate');

        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting an email template for requesting TSCCount.");

        action.setCallback(this, function(response){
            var state = response.getState();

            component.set("v.WaitingWindow", false);
            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                result.Subject = TSCCount.Trunk_Stock_Cycle_Count_ID__c;
                component.set('v.EmailTemplate', result);
            }else
            {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                alert("error on getting email template.");
            }
        });     
        $A.enqueueAction(action);       
    },

    getRepTDSList: function(component) 
    {
        var action = component.get('c.getListUserCycleCount');

        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting a list of Rep/TDS/AD User to initialze TS Cycle Count.");

        action.setCallback(this, function(response){
            var state = response.getState();

            component.set("v.WaitingWindow", false);
            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                component.set('v.listAMTDSADUsers', result);
            }else
            {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                alert("error on getting Rep/TDS/AD Info.");
            }
        });     
        $A.enqueueAction(action);       
    },

    getCCAddress: function(component) 
    {
        var action = component.get('c.NewTSA_CCUSers_List');

        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting a list of CC addresses.");

        action.setCallback(this, function(response){
            var state = response.getState();

            component.set("v.WaitingWindow", false);
            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                component.set('v.CCEmailAddress', result);
            }else
            {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                alert("error on getting a list of CC addresses.");
            }
        });     
        $A.enqueueAction(action);       
    },

    saveEmail: function(component) 
    {
        var EmailTemplate = component.get('v.EmailTemplate');
        var action = component.get('c.saveTSCCEmailTemplate');

        action.setParams({
            "email": EmailTemplate
        });

        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is saving the email template.");

        action.setCallback(this, function(response){
            var state = response.getState();

            component.set("v.WaitingWindow", false);
            if (state === "SUCCESS")
            {
                alert("The email template has been saved for using a next time.")
            }else
            {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                alert("error on saving email template.");
            }
        });     
        $A.enqueueAction(action);       
    },

    sendEmailTorepTDS: function(component)
    {
        var selectedlist = component.get("v.selectedList");
        var TSCCReports = component.get("v.TSCCReports");
        var listAMTDSADUsers = component.get("v.listAMTDSADUsers");
        var emailList = [];
        var i = 0;
        var j = 0;

        for( i=0; i<selectedlist.length; i++)
        {
            if(selectedlist[i])
            {
                for(j=0; j < listAMTDSADUsers.length; j++)
                {
                    if(TSCCReports[i].OwnerId == listAMTDSADUsers[j].Id)
                    {
                        emailList.push(listAMTDSADUsers[j].Email);
                        j = listAMTDSADUsers.length;
                    }
                }
            }
        }

        if(emailList.length > 0 & emailList[0] !=='')
        {
            this.sendEmails(component, emailList);       
        }
    },

    sendEmails: function(component, emailList) 
    {
        var EmailTemplate = component.get("v.EmailTemplate");
        var bccaddress = component.get('v.CCEmailAddress').split(';');
        var action = component.get('c.sendAnEmail');        

        action.setParams({
            "sendToAddresses": emailList,
            "bCCAddresses": bccaddress,
            "subject": EmailTemplate.Subject,
            "emailBody": EmailTemplate.HtmlValue

        });

        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is sending an email to rep/TDS.");

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                var activeSections = component.get('v.activeSections');
                var index = activeSections.indexOf('S');
                activeSections.splice(index,1);
                component.set('v.activeSections', activeSections);
                alert("SRM-SFDC Assistant have sent a reminding email to selected users.");
            }else
            {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                alert("error on sending reminding email. Please check CC email address(es).");
            }
            component.set("v.WaitingWindow", false);
        });     
        $A.enqueueAction(action);       
    },

    updateTSAHeader:  function(component)
    {
        var TSCCount = component.get("v.TSCCount");
        var action = component.get('c.updateTrunkStockAudit');        

        action.setParams({
            "TSSCCId": TSCCount.Id,
        });

        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is updating the header of the trunk stock audit.");

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
                window.location.reload(true);
            }else
            {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                alert("error on updating the header of the trunk stock audit.");
            }
            component.set("v.WaitingWindow", false);
        });     
        $A.enqueueAction(action);    
    },
})