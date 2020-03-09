({
    getRequestTSCCEmailTem: function(component, emailSubject) 
    {
        var action = component.get('c.getTSCCEmailTemplate');

        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting an email template for requesting TSCCount.");

        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                component.set('v.EmailTemplate', result);
                component.set('v.EmailTemplate.Subject', emailSubject);
                this.getLotInvList(component);
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
            component.set("v.WaitingWindow", false);
        });     
        $A.enqueueAction(action);       
    },

	getLotInvList: function(component) 
	{
        var action = component.get('c.getListSumLotInv');

        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting trunk stock inventory to initialze TS Audit.");

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                component.set('v.listLotInventory', result);
                this.getreptdsnotSFDClist(component);
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
                alert("error on getting TSCC Info.");
            }
            component.set("v.WaitingWindow", false);
        });     
        $A.enqueueAction(action);		
    },

    getreptdsnotSFDClist: function(component) 
    {
        var action = component.get('c.getListAdminTrunk');

        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting list of rep/tds users who have trunk stock but don't have SFDC accounts.");

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                component.set('v.MissingNoneSFDCUsers', result);
                this.getCCEmailList(component);
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
                alert("error on getting TSCC Info.");
            }
            component.set("v.WaitingWindow", false);
        });     
        $A.enqueueAction(action);       
    },

    getCCEmailList: function(component)
    {
        var action = component.get('c.NewTSA_CCUSers_List');

        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting list of users who will be in the CC list.");

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                component.set('v.CCEmailAddress', result);
                this.getRepTDSList(component);
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
                alert("error on getting CC list.");
            }
            component.set("v.WaitingWindow", false);
        });     
        $A.enqueueAction(action);  
    },
    
    getRepTDSList: function(component) 
    {
        var action = component.get('c.getListUserCycleCount');

        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting a list of Rep/TDS/AD User to initialze TS Audit.");

        action.setCallback(this, function(response){
            var state = response.getState();

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
            component.set("v.WaitingWindow", false);
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
                alert("The email template has been save for a next time.");
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

    sendEmails: function(component, emailList, UnselectedTSCCReportCreatedList) 
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

            component.set("v.WaitingWindow", false);
            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                this.sendResultEmailstoCSADMin(component, UnselectedTSCCReportCreatedList);
                // location.reload(true);
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
                alert("error on sending emails to announce this trunk stock audit.");
            }
        });     
        $A.enqueueAction(action);       
    },

    sendResultEmailstoCSADMin: function(component, UnselectedTSCCReportCreatedList) 
    {
        var emailList = [];
        var url = location.href;
        var i = 0;

        if(!url.includes('silkroadmed.lightning.force.com'))
        {
            emailList.push('salesforce@silkroadmed.com');
        }else
        {
            emailList.push('customerservice@silkroadmed.com');
        }

        var bccaddress = [];
        bccaddress.push('salesforce@silkroadmed.com');

        var EmailTemplate = component.get("v.EmailTemplate");
        EmailTemplate.Subject += ' - Summary';

        var emailbody = '';
        //Add unselected list and users who can't do audit via SFDC.
        emailbody += '<center> =====This is an automatic email which is generated by SRM-SFDC assistant.===== </center>';
        emailbody = "<div style = 'text-align: left; width: 100%'>";
        emailbody = emailbody + 'Dear Customer Success,<br/><br/>';
        emailbody = emailbody + 'A new trunk stock Audit email has been sent to AMs, ADs and other people. There is a list of users who are excluded on this trunk stock audit.<br/>';
        emailbody = emailbody + "<table style = 'border-collapse:collapse;'><tr><th style = 'border: 1px solid black; padding: 1px'>Name</th>";
        emailbody = emailbody + "<th style = 'border: 1px solid black; padding: 1px'>Total Expected Units</th>";
        emailbody = emailbody + "<th style = 'border: 1px solid black; padding: 1px'>Title</th>"
        emailbody = emailbody + "<th style = 'border: 1px solid black; padding: 1px'>Reason</th></tr>";


        var MissingNoneSFDCUsers = component.get('v.MissingNoneSFDCUsers');
        for(i = 0; i < MissingNoneSFDCUsers.length; i++)
        {
            emailbody = emailbody + "<tr><td style = 'border: 1px solid black; padding: 1px'>" + MissingNoneSFDCUsers[i].Name__c + "</td>";
            emailbody = emailbody + "<td style = 'border: 1px solid black; padding: 1px'>" + MissingNoneSFDCUsers[i].Total_Inventory_Units__c + "</td>";
            emailbody = emailbody + "<td style = 'border: 1px solid black; padding: 1px'>N/A</td>";
            emailbody = emailbody + "<td style = 'border: 1px solid black; padding: 1px'>Not a SFDC user to join this activity</td></tr>";
        }

        var MissingSFDCUsers = component.get('v.MissingSFDCUsers');
        for(i = 0; i < MissingSFDCUsers.length; i++)
        {
            emailbody = emailbody + "<tr><td style = 'border: 1px solid black; padding: 1px'>" + MissingSFDCUsers[i].Name__c + "</td>";
            emailbody = emailbody + "<td style = 'border: 1px solid black; padding: 1px'>" + MissingSFDCUsers[i].Total_Inventory_Units__c + "</td>";
            emailbody = emailbody + "<td style = 'border: 1px solid black; padding: 1px'>N/A</td>";
            emailbody = emailbody + "<td style = 'border: 1px solid black; padding: 1px'>A SFDC User can't access Trunk Stock Audit</td></tr>";
        }

        for(i = 0; i < UnselectedTSCCReportCreatedList.length; i++)
        {
            emailbody = emailbody + "<tr><td style = 'border: 1px solid black; padding: 1px'>" + UnselectedTSCCReportCreatedList[i].Name__c + "</td>";
            emailbody = emailbody + "<td style = 'border: 1px solid black; padding: 1px'>" + UnselectedTSCCReportCreatedList[i].Total_Inventory_Units__c + "</td>";
            emailbody = emailbody + "<td style = 'border: 1px solid black; padding: 1px'>" + UnselectedTSCCReportCreatedList[i].Reviewer__c + "</td>";
            emailbody = emailbody + "<td style = 'border: 1px solid black; padding: 1px'> CS user removed the person out of the trunk stock audit list.</td></tr>";
        }
        emailbody = emailbody + "</table>";
        emailbody = emailbody + '<br/>Sincerely,<br/><br/>SRM-SFDC administrator<br/>';
        emailbody = emailbody + '</div> <br/>';
        emailbody += '<center> ===== This is a copy of this trunk stock audit email sent to sales team ===== </center>';

        EmailTemplate.HtmlValue = emailbody + EmailTemplate.HtmlValue;

        var action = component.get('c.sendAnEmail');        

        action.setParams({
            "sendToAddresses": emailList,
            "bCCAddresses": bccaddress,
            "subject": EmailTemplate.Subject,
            "emailBody": EmailTemplate.HtmlValue
        });

        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is sending a summary email to CS and SRM-SFDC administrator.");

        action.setCallback(this, function(response){
            var state = response.getState();

            component.set("v.WaitingWindow", false);
            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                location.reload(true);
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
                alert("error on sending emails to announce this trunk stock audit.");
            }
        });     
        $A.enqueueAction(action);       
    },

    createNewTSCC: function(component) 
	{
        var TSCCount = component.get('v.TSCCount');

        TSCCount.Name = TSCCount.Trunk_Stock_Cycle_Count_ID__c;

        var totalSelectedUser = component.get('v.totalSelectedUser');
        TSCCount.Total_Trunk_Stock_Reports__c = totalSelectedUser;
        TSCCount.IsActive__c = true;

        //Server side - don't like ipnut date from ui:inputDate?????
        //Write a code to convert ui:inputDate into Date
        var  convertDate = new Date(TSCCount.Start_Date__c);
        TSCCount.Start_Date__c= convertDate ;
        convertDate = new Date(TSCCount.Due_Date__c);
        TSCCount.Due_Date__c= convertDate ;
        convertDate = new Date(TSCCount.End_Date__c);
        TSCCount.End_Date__c= convertDate ;
        TSCCount.Completed_Percentage__c = 10 ;

        var action = component.get('c.createNewTSCCount');

        action.setParams({
            "TSCCount": TSCCount
        });

        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is creating a new trunk stock audit on server.");

        action.setCallback(this, function(response){
            var state = response.getState();

            component.set("v.WaitingWindow", false);
            if (state === "SUCCESS")
            {
                var resultID = response.getReturnValue();
                this.continueSendREPTDSEmails(component, resultID);
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
                alert("error on creating a new Trunk Stock Audit.");
            }
        });     
        $A.enqueueAction(action);		
	},

    continueSendREPTDSEmails: function(component, resultID)
    {
        var selectedlist = component.get("v.selectedList");
        var TSCCReports = component.get("v.TSCCReports");
        var listAMTDSADUsers = component.get("v.listAMTDSADUsers");
        var nameAudit = component.get('v.TSCCount.Trunk_Stock_Cycle_Count_ID__c');
        var emailList = [];
        var TSCCReportCreatedList = [];
        var UnselectedTSCCReportCreatedList = [];
        var i = 0;
        var j = 0;

        for( i=0; i<selectedlist.length; i++)
        {
            if(selectedlist[i])
            {
                TSCCReports[i].Trunk_Stock_Cycle_Count__c = resultID;
                TSCCReports[i].Name = TSCCReports[i].Name__c + ' - ' + nameAudit.substr(0,8) + ' Trunk Stock Audit';
                TSCCReports[i].Reviewer__c = null;
                TSCCReportCreatedList.push(TSCCReports[i]);


                for(j=0; j < listAMTDSADUsers.length; j++)
                {
                    if(TSCCReports[i].OwnerId == listAMTDSADUsers[j].Id)
                    {
                        emailList.push(listAMTDSADUsers[j].Email);
                        j = listAMTDSADUsers.length;
                    }
                }
            }else
            {
                UnselectedTSCCReportCreatedList.push(TSCCReports[i]);
            }
        }

        if(TSCCReportCreatedList.length > 0)
        {
            this.createTSCCReport(component, TSCCReportCreatedList, emailList, UnselectedTSCCReportCreatedList);
        }else
        {
            component.set("v.WaitingWindow", false);
            alert('I cannot find any users need to create a trunk stock audit report. Please check your selected list and redo');
        }
    },

    createTSCCReport: function(component, TSCCReportCreatedList, emailList, UnselectedTSCCReportCreatedList) 
    {
        var action = component.get('c.createNewTSCCReport');

        action.setParams({
            "TSCCReportCreatedList": TSCCReportCreatedList
        });

        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is creating a new TSAReport for rep/TDS.");

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
                if(emailList.length > 0 & emailList[0] !=='')
                {
                    this.sendEmails(component, emailList, UnselectedTSCCReportCreatedList);       
                }else
                {
                    component.set("v.WaitingWindow", false);
                }
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
                alert("error on creating TSAReports.");
                component.set("v.WaitingWindow", false);
            }
        });     
        $A.enqueueAction(action);       
    },
})
// console.log("javascript debug 1: " + JSON.stringify(emailList));