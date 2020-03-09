({
	getrepTDSInfo : function(component)
	{
        var action = component.get('c.getrepTDSInformation');
        var TSCCReport = component.get("v.TSCCReport");

        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting current user Information.");

        action.setParams({
        		"reptdsID": TSCCReport.OwnerId
        });

        action.setCallback(this, function(response){
            var state = response.getState();            
            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                component.set('v.repTDSUser', result);
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
                alert("error on getting user Info.");
            }
            component.set("v.WaitingWindow", false);
        });     
        $A.enqueueAction(action);   		
	},

    // Fetch list of Customer Service users from the Apex controller
    getCSUsers: function(component) {
        var action = component.get('c.getCSUsers'); 

        //Display waiting message
        component.set('v.waitingMessage', 'SFDC is initializing the ITF.' );
        component.set('v.WaitingWindow', true);

        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult)
        {
            var state = actionResult.getState();
            if (state === "SUCCESS")
            {
                var result = actionResult.getReturnValue();
                var i = 0;
                var CSName = [];
                CSName.push('===N/A===');
                for(i=0; i<result.length; i++)
                {
                    CSName.push(result[i].FirstName + ' ' + result[i].LastName);
                }
                component.set('v.possibleCSList', CSName);   
                component.set('v.IsCSListReady',true); //turn on selected CS name           
            } 
            component.set('v.WaitingWindow', false);
        });
        $A.enqueueAction(action);
    },

    updateTSCCItemToserver : function(component)
    {
        var SelectedTSCCItem = component.get("v.SelectedTSCCItem");
        var action = component.get('c.updateTSCCItemToSFDC');

        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is updating your change into SFDC.");

        action.setParams({
                "SelectedTSCCItem": SelectedTSCCItem
        });

        action.setCallback(this, function(response){
            var state = response.getState();            
            if (state === "SUCCESS")
            {
                //update successful
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
                alert("error on updating a trunk stock audit line item.");
            }
            component.set("v.WaitingWindow", false);
        });     
        $A.enqueueAction(action);           
    },

    updateTSCCItemToCachedArray : function(component)
    {
        var SelectedTSCCItem = component.get("v.SelectedTSCCItem");
        var TSCCItems = component.get("v.TSCCItems");
        var i = 0;

        for(i = 0; i < TSCCItems.length; i++)
        {
            if(SelectedTSCCItem.Id == TSCCItems[i].Id)
            {
                TSCCItems[i] = SelectedTSCCItem;
                i = TSCCItems.length;
            }
        }

        component.set("v.TSCCItems",TSCCItems);

        //Update discrepancy
        var totallotDis = 0;
        var totalUnitDis = 0;
        for(i=0; i < TSCCItems.length; i++)
        {
            if(TSCCItems[i].Qty_on_system__c != TSCCItems[i].Counted_Qty__c)
            {
                if(!((TSCCItems[i].Qty_on_system__c == null && TSCCItems[i].Counted_Qty__c == 0) || (TSCCItems[i].Qty_on_system__c == 0 && TSCCItems[i].Counted_Qty__c == null)))
                    totallotDis = totallotDis + 1;
                if(TSCCItems[i].Qty_on_system__c == null)
                    totalUnitDis = totalUnitDis + TSCCItems[i].Counted_Qty__c;
                else if (TSCCItems[i].Counted_Qty__c == null)
                    totalUnitDis = totalUnitDis + TSCCItems[i].Qty_on_system__c;
                else if(TSCCItems[i].Qty_on_system__c > TSCCItems[i].Counted_Qty__c)
                    totalUnitDis = totalUnitDis + TSCCItems[i].Qty_on_system__c -TSCCItems[i].Counted_Qty__c;
                else
                    totalUnitDis = totalUnitDis + TSCCItems[i].Counted_Qty__c - TSCCItems[i].Qty_on_system__c;
            }
        }
        var TSCCReport = component.get('v.TSCCReport');
        TSCCReport.Total_Unit_Discrepancies__c = totalUnitDis;
        TSCCReport.Total_Lot_Discrepancies__c = totallotDis;
        component.set('v.TSCCReport',TSCCReport);
        var IschangeTSCCDetail = component.get('v.IschangeTSCCDetail');
        this.updateTSCCReportHeader(component, IschangeTSCCDetail);
    },

    updateTSCCReportHeader : function(component, IschangeTSCCDetail)
    {
        var TSCCReport = component.get('v.TSCCReport');
        var action = component.get('c.updateTSCCReport');

        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is updating the TSCC Report Info.");

        action.setParams({
                "TSCCReport": TSCCReport
        });

        action.setCallback(this, function(response){
            var state = response.getState();            
            if (state === "SUCCESS")
            {
                component.set("v.IschangeTSCCHeader", false);
                if(IschangeTSCCDetail)
                    this.updateTSCCReportItems(component);
                else
                    this.refreshpage(component);
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
                alert("error on updating the TSCC Report Info.");
            }
            component.set("v.WaitingWindow", false);
        });     
        $A.enqueueAction(action);           
    },

    updateTSCCReportItems : function(component)
    {
        var TSCCItems = component.get("v.TSCCItems");
        var action = component.get('c.updateTSCCReportItems');

        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is updating the TSCC Line Items.");

        action.setParams({
                "TSCCItems": TSCCItems
        });

        action.setCallback(this, function(response){
            var state = response.getState();            
            if (state === "SUCCESS")
            {
                component.set("v.IschangeTSCCDetail", false);
                this.refreshpage(component);
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
                alert("error on updating the TSCC Report Info.");
            }
            component.set("v.WaitingWindow", false);
        });     
        $A.enqueueAction(action);           
    },

    refreshpage : function(component)
    {
       window.location.reload(true);
    },

    sendEmailhelper: function(component)
    {
        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is sending an email to rep/tds.");

        var EmailTemplate = component.get('v.EmailTemplate');
        var ToEmailAddress = component.get('v.ToEmailAddress');
        var CCEmailAddress = component.get('v.CCEmailAddress');

        var BccAddresses = component.get('v.CCEmailAddress').split(';');
        var Toaddresses = ToEmailAddress.split(';');

        var action = component.get('c.sendAnEmail');        

        action.setParams({
            "sendToAddresses": Toaddresses,
            "bCCAddresses": BccAddresses,
            "subject": EmailTemplate.Subject,
            "emailBody": EmailTemplate.HtmlValue
        });

        action.setCallback(this, function(response){
            var state = response.getState();

            component.set("v.WaitingWindow", false);
            if (state === "SUCCESS")
            {
                alert("Thank you for your patience.\n SRM-SFDC Assistance has successful sent a notified email to rep/tds.\n");
                var TSCCReport = component.get('v.TSCCReport');
                if(TSCCReport.Status__c == 'Auditing')
                {
                    TSCCReport.Status__c = 'Reconciling';
                    component.set('v.TSCCReport',TSCCReport);
                    var IschangeTSCCDetail = component.get('v.IschangeTSCCDetail');
                    this.updateTSCCReportHeader(component, IschangeTSCCDetail);
                }else
                    this.refreshpage(component);
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
                alert("error on sending email. Please check your email addresses.");
            }
        });     
        $A.enqueueAction(action);
    },

    updatePreviousTSCCitem: function(component)
    {
        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is checking previous trunk stock audit report.");
        var SelectedTSCCItem = component.get("v.SelectedTSCCItem");
        
        var action = component.get('c.getPreviousTSCCitem');        

        action.setParams({
            "currentTSCCItemId": SelectedTSCCItem.Id
        });

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                component.set('v.PreviousTSCCItems',  result);
                if(result.length > 0)
                {
                    component.set('v.displayPreviousCounts', true);
                }else
                {
                    component.set('v.displayPreviousCounts', false);
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
                alert("error on sending email. Please check your email addresses.");
            }
            component.set("v.WaitingWindow", false);
        });     
        $A.enqueueAction(action);
    },

    getCCEmailAddress: function(component, EmailTemplate, CCEmailAddress, TSCCReport, TSCCItems, repTDSUser, emailbody, i, url)
    {
        if(!url.includes('silkroadmed.lightning.force.com'))
        {
            if(CCEmailAddress == null || CCEmailAddress == undefined || CCEmailAddress == '')
                CCEmailAddress = 'salesforce@silkroadmed.com';
            else
                CCEmailAddress = CCEmailAddress + ';salesforce@silkroadmed.com';

            component.set('v.CCEmailAddress', CCEmailAddress);
            this.getEmailTemplate(component, EmailTemplate, CCEmailAddress, TSCCReport, TSCCItems, repTDSUser, emailbody, i, url);
        }else
        {
            var action = component.get('c.getCCUSersForEmail');        
    
            action.setCallback(this, function(response){
                var state = response.getState();
    
                if (state === "SUCCESS")
                {
                    var result = response.getReturnValue();

                    //Don't need to include users on the CC permission set (CS will manual enter the email)
                    // if(CCEmailAddress == null || CCEmailAddress == undefined || CCEmailAddress == '')
                    //     CCEmailAddress = result;
                    // else
                    // {
                    //     CCEmailAddress = CCEmailAddress + ";" + result + ";customerservice@silkroadmed.com";
                    // }
                    CCEmailAddress = CCEmailAddress + "; customerservice@silkroadmed.com";

                    component.set('v.CCEmailAddress', CCEmailAddress);
                    this.getEmailTemplate(component, EmailTemplate, CCEmailAddress, TSCCReport, TSCCItems, repTDSUser, emailbody, i, url);
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
                    alert("error on getting CCUser. Please check the TSSudit permission set");
                }
                component.set("v.WaitingWindow", false);
            });     
            $A.enqueueAction(action);              
        }      
    },

    getEmailTemplate: function(component, EmailTemplate, CCEmailAddress, TSCCReport, TSCCItems, repTDSUser, emailbody, i, url)
    {
        var DiscrepanciesExpiringList = "";
        DiscrepanciesExpiringList = this.generateDisExpList(component, EmailTemplate, CCEmailAddress, TSCCReport, TSCCItems, repTDSUser, emailbody, i, url)
        
        var action = component.get('c.getTSCCEmailTemplate2');        
    
        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();

                emailbody = result.HtmlValue;
                var subject = result.Subject;
                
                subject = subject.replace("{!Trunk_Stock_Cycle_Count_Report__c.Name__c}", TSCCReport.Name);

                emailbody = emailbody.replace("{!Trunk_Stock_Cycle_Count_Report__c.OwnerFirstName}", repTDSUser.FirstName);
                emailbody = emailbody.replace("{!Trunk_Stock_Cycle_Count_Report__c.Name__c}", TSCCReport.Name);
                emailbody = emailbody.replace("{!DiscrepanciesExpiringList}", DiscrepanciesExpiringList);
                emailbody = emailbody.replace("{!Trunk_Stock_Cycle_Count_Report__c.Id}", TSCCReport.Id);

                EmailTemplate.Subject = subject;
                EmailTemplate.HtmlValue = emailbody;
                component.set('v.EmailTemplate', EmailTemplate);
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
                alert("error on getting email template 'TSA after CS review'. Please check the email template.");
            }
            component.set("v.WaitingWindow", false);
        });     
        $A.enqueueAction(action); 
    },

    generateDisExpList: function(component, EmailTemplate, CCEmailAddress, TSCCReport, TSCCItems, repTDSUser, emailbody, i, url)
    {
        emailbody = emailbody + "<br/><b>Table 1: The list of discrepant lots</b><br/>";
        emailbody = emailbody + "<table style = 'border-collapse:collapse;'><tr><th style = 'border: 1px solid black; padding: 1px'>Item#</th>";
        emailbody = emailbody + "<th style = 'border: 1px solid black; padding: 1px'>Lot#</th>";
        emailbody = emailbody + "<th style = 'border: 1px solid black; padding: 1px'>Reported Qty</th>";
        emailbody = emailbody + "<th style = 'border: 1px solid black; padding: 1px'>System Qty</th>";
        emailbody = emailbody + "<th style = 'border: 1px solid black; padding: 1px'>Discrepancy Period</th>";
        emailbody = emailbody + "<th style = 'border: 1px solid black; padding: 1px'>note</th></tr>";
        var ExpiringList = "";

        //Create expiring list + discrepancy list
        for(i = 0; i < TSCCItems.length; i++)
        {
            if(TSCCItems[i].Qty_on_system__c != TSCCItems[i].Counted_Qty__c)
            {
                emailbody = emailbody + "<tr><td style = 'border: 1px solid black; padding: 1px'>" + TSCCItems[i].Product_No__c + "</td>";
                emailbody = emailbody + "<td style = 'border: 1px solid black; padding: 1px'>" + TSCCItems[i].Lot_Number__c + "</td>";
                emailbody = emailbody + "<td style = 'border: 1px solid black; padding: 1px'>" + TSCCItems[i].Counted_Qty__c + "</td>";
                emailbody = emailbody + "<td style = 'border: 1px solid black; padding: 1px'>" + TSCCItems[i].Qty_on_system__c + "</td>";
                if(TSCCItems[i].period_discrepancy__c == undefined)
                    TSCCItems[i].period_discrepancy__c = '';
                emailbody = emailbody + "<td style = 'border: 1px solid black; padding: 1px'>" + TSCCItems[i].period_discrepancy__c + "</td>";
                if(TSCCItems[i].Note__c == undefined)
                    TSCCItems[i].Note__c = '';
                emailbody = emailbody + "<td style = 'border: 1px solid black; padding: 1px'>" + TSCCItems[i].Note__c + "</td></tr>";
            }

            if(TSCCItems[i].Counted_Qty__c != 0 && TSCCItems[i].Expiring_Status__c.includes("Expir"))
            {
                ExpiringList = ExpiringList + "<tr><td style = 'border: 1px solid black; padding: 1px'>" + TSCCItems[i].Product_No__c + "</td>";
                ExpiringList = ExpiringList + "<td style = 'border: 1px solid black; padding: 1px'>" + TSCCItems[i].Lot_Number__c + "</td>";
                ExpiringList = ExpiringList + "<td style = 'border: 1px solid black; padding: 1px'>" + TSCCItems[i].Counted_Qty__c + "</td>";
                ExpiringList = ExpiringList + "<td style = 'border: 1px solid black; padding: 1px'>" + TSCCItems[i].Expired_Date__c + "</td>";
                ExpiringList = ExpiringList + "<td style = 'border: 1px solid black; padding: 1px'>" + TSCCItems[i].Expiring_Status__c + "</td>";
                if(TSCCItems[i].Note__c == undefined)
                    TSCCItems[i].Note__c = '';
                ExpiringList = ExpiringList + "<td style = 'border: 1px solid black; padding: 1px'>" + TSCCItems[i].Note__c + "</td></tr>";
            }
        }
        emailbody = emailbody + "</table>";

        if(ExpiringList != "")
        {
            emailbody = emailbody + "<br/><b>Table 2: The list of expiring lots</b><br/>";
            emailbody = emailbody + "<table style = 'border-collapse:collapse;'><tr><th style = 'border: 1px solid black; padding: 1px'>Item#</th>";
            emailbody = emailbody + "<th style = 'border: 1px solid black; padding: 1px'>Lot#</th>";
            emailbody = emailbody + "<th style = 'border: 1px solid black; padding: 1px'>Reported Qty</th>";
            emailbody = emailbody + "<th style = 'border: 1px solid black; padding: 1px'>Expired Date</th>";
            emailbody = emailbody + "<th style = 'border: 1px solid black; padding: 1px'>Expiring Status</th>";
            emailbody = emailbody + "<th style = 'border: 1px solid black; padding: 1px'>note</th></tr>";
            emailbody = emailbody + ExpiringList;
            emailbody = emailbody + "</table>";
        }

        return emailbody;
    },
})