({
	getLotInfo : function(component) {
		var action = component.get('c.getLotInfomation');

        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting lot information.");

		action.setCallback(this, function(response)
		{
	        var state = response.getState();

	        if (state === "SUCCESS") 
	        {
	            var result = response.getReturnValue(); //get return value
	            component.set('v.lots', result)
	        }else
	        {
	        	alert("error on getting lot information.");
        		let errors = response.getError();
	            let errorMessage = 'Unknown error';
	            if (errors && Array.isArray(errors) && errors.length > 0) {
	                errorMessage = errors[0].message;
	            }
	            // Display the message
	            console.error(errorMessage);
	        }

	        var isReady = component.get('v.isReady');
	        isReady = isReady +1;
	        component.set("v.isReady", isReady);
	    });

	    //execute process
	    $A.enqueueAction(action);		
	},

	gettingLotInventory : function(component)
	{
		var action = component.get('c.getLotInven');

		component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is innitializing your trunk stock report.");

		action.setCallback(this, function(response)
		{
	        var state = response.getState();

	        if (state === "SUCCESS") 
	        {
	            var result = response.getReturnValue(); //get return value

	            if(result.length > 0)
	            {
	            	component.set("v.lotinventory", result);
	            }
	        }else
	        {
	        	alert("error on finding a Pending TSCCount.");
        		let errors = response.getError();
	            let errorMessage = 'Unknown error';
	            if (errors && Array.isArray(errors) && errors.length > 0) {
	                errorMessage = errors[0].message;
	            }
	            // Display the message
	            console.error(errorMessage);
	        }
	        
	        var isReady = component.get('v.isReady');
	        isReady = isReady +1;
	        component.set("v.isReady", isReady);
	    });

	    //execute process
	    $A.enqueueAction(action);
	},


	recalculateSummary : function(component)
	{
		var tempNPSItems = component.get("v.tempNPSItems");
		var tempStentItems = component.get("v.tempStentItems");
		var tempGWItems = component.get("v.tempGWItems");
		var tempMPKItems = component.get("v.tempMPKItems");
		var returnlist = [];
		var display = '';

		var i = 0;
		var total = 0;

		for(i=0; i < tempNPSItems.length; i++)
		{
			if(tempNPSItems[i].Counted_Qty__c > 0)
			{
				total = total + tempNPSItems[i].Counted_Qty__c;
				if(!tempNPSItems[i].Expiring_Status__c.includes('OK'))
				{					
					display	= tempNPSItems[i].Lot_Number__c + ' - ' + tempNPSItems[i].Product_No__c;
					display = display + ' (Qty: ' + tempNPSItems[i].Counted_Qty__c + ' EA)';
					display	= display + ' (Exp: ' + this.convertDatetoString(tempNPSItems[i].Expired_Date__c);
					display	= display + ' - ' + tempNPSItems[i].Expiring_Status__c + ')';					
					returnlist.push(display);
				}
			}
		}
		component.set('v.TotalNPS', total);

		total = 0;
		for(i=0; i < tempStentItems.length; i++)
		{
			if(tempStentItems[i].Counted_Qty__c > 0)
			{
				total = total + tempStentItems[i].Counted_Qty__c;
				if(!tempStentItems[i].Expiring_Status__c.includes('OK'))
				{
					display	= tempStentItems[i].Lot_Number__c + ' - ' + tempStentItems[i].Product_No__c;
					display = display + ' (Qty: ' + tempStentItems[i].Counted_Qty__c + ' EA)';
					display	= display + ' (Exp: ' + this.convertDatetoString(tempStentItems[i].Expired_Date__c) ;
					display	= display + ' - ' + tempStentItems[i].Expiring_Status__c + ')';
					returnlist.push(display);					
				}
			}
		}
		component.set('v.TotalStent', total);

		total = 0;
		for(i=0; i < tempGWItems.length; i++)
		{
			if(tempGWItems[i].Counted_Qty__c > 0)
			{
				total = total + tempGWItems[i].Counted_Qty__c;
				if(!tempGWItems[i].Expiring_Status__c.includes('OK'))
				{
					display	= tempGWItems[i].Lot_Number__c + ' - ' + tempGWItems[i].Product_No__c;
					display = display + ' (Qty: ' + tempGWItems[i].Counted_Qty__c + ' EA)';
					display	= display + ' (Exp: ' + this.convertDatetoString(tempGWItems[i].Expired_Date__c);
					display	= display + ' - ' + tempGWItems[i].Expiring_Status__c + ')';
					returnlist.push(display);
				}
			}
		}
		component.set('v.TotalGW', total);

		total = 0;
		for(i=0; i < tempMPKItems.length; i++)
		{
			if(tempMPKItems[i].Counted_Qty__c > 0)
			{
				total = total + tempMPKItems[i].Counted_Qty__c;
				if(!tempMPKItems[i].Expiring_Status__c.includes('OK'))
				{
					display	= tempMPKItems[i].Lot_Number__c + ' - ' + tempMPKItems[i].Product_No__c;
					display = display + ' (Qty: ' + tempMPKItems[i].Counted_Qty__c + ' EA)';
					display	= display + ' (Exp: ' + this.convertDatetoString(tempMPKItems[i].Expired_Date__c);
					display	= display + ' - ' + tempMPKItems[i].Expiring_Status__c + ')';
					returnlist.push(display);
				}
			}
		}
		component.set('v.TotalMPK', total);
		component.set('v.returnlist',returnlist);
	},

	recheckChildReady: function(component, currentStep)
	{
		var i = 0;
		if(currentStep == 0)
		{
			var tempNPSItems = component.get("v.tempNPSItems");
			for(i=0; i < tempNPSItems.length; i++)
				tempNPSItems[i].Confirmed__c = false;
			component.set('v.tempNPSItems', tempNPSItems);
		}else if(currentStep == 1)
		{
			var tempStentItems = component.get("v.tempStentItems");
			for(i=0; i < tempStentItems.length; i++)
				tempStentItems[i].Confirmed__c = false;
			component.set('v.tempStentItems', tempStentItems);
		}else if(currentStep == 2)
		{
			var tempGWItems = component.get("v.tempGWItems");
			for(i=0; i < tempGWItems.length; i++)
				tempGWItems[i].Confirmed__c = false;
			component.set('v.tempGWItems', tempGWItems);
		}else if(currentStep == 3)
		{
			var tempMPKItems = component.get("v.tempMPKItems");
			for(i=0; i < tempMPKItems.length; i++)
				tempMPKItems[i].Confirmed__c = false;
			component.set('v.tempMPKItems', tempMPKItems);
		}
	},

	createandsendTSCCReporttoserver: function(component)
	{
		var tempNPSItems = component.get("v.tempNPSItems");
		var tempStentItems = component.get("v.tempStentItems");
		var tempGWItems = component.get("v.tempGWItems");
		var tempMPKItems = component.get("v.tempMPKItems");
		var lotinventory = component.get("v.lotinventory");
		var TSCCReport = component.get("v.TSCCReport");
		var TSCCRItem = [];
		var tempTSCCRItem = tempNPSItems.concat(tempStentItems,tempGWItems,tempMPKItems);
		var i = 0;
		var j = 0;
		var isNewItem = true;
		var today = new Date();
		var year = today.getFullYear();
		var month = today.getMonth();
		var date = today.getDate();

		//Step 1: convert lot inventory into TSCCitem
		for(i=0; i < lotinventory.length; i++)
		{
			TSCCRItem.push({
                        'sobjectType':'Trunk_Stock_Cycle_Count_Item__c',
                        'Expired_Date__c': lotinventory[i].Lot_Expiration_Date__c,
                        'Lot_Number__c': lotinventory[i].Lot_Number__c,
                        'Product_No__c': lotinventory[i].Item_Number__c,
                        'Qty_on_system__c': lotinventory[i].On_Hand_Qty__c,
                        'Counted_Qty__c': 0,
                        'Trunk_Stock_report__c': TSCCReport.Id,
                        'Confirmed__c': true,
                        'Unit__c': 'EA',
                        'TSCCItem_ID__c': TSCCReport.Id + '-' + lotinventory[i].Lot_Number__c
                    });
		}

		//Step 2: add temp items into the list
		for(i=0; i < tempTSCCRItem.length; i++)
		{
			isNewItem = true;
			for(j=0; j < TSCCRItem.length; j++)
			{
				if(TSCCRItem[j].Lot_Number__c == tempTSCCRItem[i].Lot_Number__c)
				{
					isNewItem = false;
					TSCCRItem[j].Counted_Qty__c = tempTSCCRItem[i].Counted_Qty__c;
					TSCCRItem[j].Product_No__c = tempTSCCRItem[i].Product_No__c;
					break;
				}
			}

			if(isNewItem & tempTSCCRItem[i].Counted_Qty__c > 0)
			{
				TSCCRItem.push({
	                        'sobjectType':'Trunk_Stock_Cycle_Count_Item__c',
	                        'Expired_Date__c': tempTSCCRItem[i].Expired_Date__c,
	                        'Lot_Number__c': tempTSCCRItem[i].Lot_Number__c,
	                        'Product_No__c': tempTSCCRItem[i].Product_No__c,
	                        'Qty_on_system__c': 0,
	                        'Counted_Qty__c': tempTSCCRItem[i].Counted_Qty__c,
	                        'Trunk_Stock_report__c': TSCCReport.Id,
	                        'Confirmed__c': true,
	                        'Unit__c': 'EA',
	                        'TSCCItem_ID__c': TSCCReport.Id + '-' + tempTSCCRItem[i].Lot_Number__c
	                    });
			}
		}

		//Step 3: add estimated discrepancy period time.
		// var period = TSCCReport.Name.substring(0, 6);
		var period = year + '-' + (month+1);
		for(i=0; i < TSCCRItem.length; i++)
		{
			if(TSCCRItem[i].Counted_Qty__c !== TSCCRItem[i].Qty_on_system__c)
				TSCCRItem[i].period_discrepancy__c = period;
		}

		//Update Trunk Stock Cycle Count header
		TSCCReport.Submitted__c = true;

		//Check Trunk Stock discrepancy
		var discrepancy = false;
		var totallotDis = 0;
		var totalUnitDis = 0;
		for(i=0; i < TSCCRItem.length; i++)
		{
			if(TSCCRItem[i].Qty_on_system__c != TSCCRItem[i].Counted_Qty__c)
			{
				discrepancy = true;
				totallotDis = totallotDis + 1;
				if(TSCCRItem[i].Qty_on_system__c > TSCCRItem[i].Counted_Qty__c)
					totalUnitDis = totalUnitDis + TSCCRItem[i].Qty_on_system__c - TSCCRItem[i].Counted_Qty__c;
				else
					totalUnitDis = totalUnitDis + TSCCRItem[i].Counted_Qty__c - TSCCRItem[i].Qty_on_system__c;
			}
		}
		if(discrepancy)
			TSCCReport.Status__c = 'Auditing';
		else
		{
			TSCCReport.Status__c = 'Completed';
			TSCCReport.Reviewer__c = '===N/A===';
			TSCCReport.Review_Date__c = new Date(year,month, date);
		}
		if(TSCCReport.Total_Inventory_Units__c == 0 & TSCCRItem.length > 0)
			TSCCReport.Total_Inventory_Units__c = TSCCRItem.length;

		TSCCReport.Total_Unit_Discrepancies__c = totalUnitDis;
		TSCCReport.Total_Lot_Discrepancies__c = totallotDis;

		var returnlist = component.get('v.returnlist');
		if(returnlist.length > 0)
		{
			TSCCReport.Total_Expiring_Units__c = returnlist.length;
			TSCCReport.List_Expiring_Units__c = "Not Ready";
		}else
		{
			TSCCReport.Total_Expiring_Units__c = 0;
		}

		TSCCReport.Count_Date__c = new Date(year,month, date);

		//Remove the "Sent Reconciled email" out of the record - the field is controller by SFDC process
		TSCCReport.Sent_reconciled_email__c = undefined;

		this.uploadTSCCintoServer(component, TSCCReport, TSCCRItem);
	},

	uploadTSCCintoServer: function(component, TSCCReport, TSCCRItem)
	{
		var action = component.get('c.submitTSCCount');

        action.setParams({
            	"TSCCReport": TSCCReport,
            	"TSCCRItem": TSCCRItem
        });

        action.setCallback(this, function(response){
            var state = response.getState();


            if (state === "SUCCESS") 
            {
                var result = response.getReturnValue(); //get return value
				//this.sendNotifiedEmailIntoCS(component, TSCCReport, TSCCRItem);
				alert("Thank you for your patience.\n SRM-SFDC Assistance has successful saved your count.\n");
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
                alert("Sorry, we have an error on saving your trunk stock audit Report. Please contact the SRM-SFDC administrator.");
            }else if(state === "INCOMPLETE")
            {
            	alert("Look like Server is busy right now. Please try to hit 'submit' button one more time. Thanks");
            }else
            {
            	alert("Unexpected error - Please report this issue with the SRM-SFDC administrator.");
            }
        });
		component.set("v.WaitingWindow", false);

        //execute process
        $A.enqueueAction(action);
	},

	sendNotifiedEmailIntoCS: function(component, TSCCReport, TSCCRItem)
	{
        component.set("v.WaitingWindow", true);
        component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is creating and sending an notified email to customer success team.");
		var returnlist = component.get('v.returnlist');
		var i = 0;

		// Step 1: create a template email
		var emailList = [];
		var bccaddress = [];
		var url = location.href;

		if(!url.includes('silkroadmed.lightning.force.com'))
		{
			emailList.push('salesforce@silkroadmed.com');
			// bccaddress.add('salesforce@silkroadmed.com');
		}else
		{
			emailList.push('customerservice@silkroadmed.com');
			// bccaddress.add('salesforce@silkroadmed.com');		
		}

		var subject = 'TSAudit: ' + TSCCReport.Name + ' has been submitted';
		var emailBody = '<center>======This is an automated-email which is genereated by SRM-SFDC Assistant=======</center><br/>';
		emailBody = emailBody+ 'Dear, Customer Success team.<br/>';
		emailBody = emailBody + '<br/>' + TSCCReport.Name__c + ' has submitted the trunk stock audit. Please use the link below to access the trunk stock audit report.<br/>';
		emailBody = emailBody + 'https://silkroadmed.lightning.force.com/' + TSCCReport.Id + '<br/>';

		// Step 2: add expired product into email
		if(returnlist.length > 0)
		{
			emailBody = emailBody + '<br/>I, SRM-SFDC Assistant, found some expiring/expired units on '+ TSCCReport.Name__c+"' strunk.<br/>";
			for(i = 0; i < returnlist.length; i++)
			{
				emailBody = emailBody + '<div style ="padding-left: 8px; font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; + '+ returnlist[i] + '</div>';
			}
			emailBody = emailBody + 'Please review the RMA orders/log before issuing a new RMA number into rep/tds to return this product.<br/>';
		}

		// Step 2.1: add rep/tds note if he/she writes some notes.
		if(TSCCReport.Note__c != null & TSCCReport.Note__c != undefined & TSCCReport.Note__c !='')
		{
			emailBody = emailBody + '<br/>Here is a note from ' + TSCCReport.Name__c + ' on the Trunk Stock Audit Report.<br/>';
			emailBody = emailBody + '<b>"'+ TSCCReport.Note__c + '"</b><br/>';
		}

		//Step 3: send email template into SFDC server
		emailBody = emailBody + '<br/>Regards. <br/><br/>SRM-SFDC Assistant';

        var action = component.get('c.sendAnEmail');        

        action.setParams({
            "sendToAddresses": emailList,
            "bCCAddresses": bccaddress,
            "subject": subject,
            "emailBody": emailBody
        });

        action.setCallback(this, function(response){
            var state = response.getState();

            component.set("v.WaitingWindow", false);
            if (state === "SUCCESS")
            {
            	alert("Thank you for your patience.\n SRM-SFDC Assistance has successful submitted your trunk stock audit form and has sent a notified email to Customer Success.\n");
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
                alert("error on sending emails to announce this trunk stock audit.");
            }
        });     
        $A.enqueueAction(action);
	},


	checkChildReady: function(component)
	{
        var currentStep = component.get('v.currentStep');
        var isReady = component.get("v.isChildReady");

        if(currentStep == 0)
        {
            var tempNPSItems = component.get("v.tempNPSItems");
            if(tempNPSItems.length == isReady)
            {
                component.set("v.isChildReady",0);
                component.set("v.WaitingWindow", false);
            }

        }else if(currentStep == 1)
        {
            var tempStentItems = component.get("v.tempStentItems");
            if(tempStentItems.length  == isReady)
            {
                component.set("v.isChildReady",0);
                component.set("v.WaitingWindow", false);
            }
        }else if(currentStep == 2)
        {
            var tempGWItems = component.get("v.tempGWItems");
            if(tempGWItems.length  == isReady)
            {
                component.set("v.isChildReady",0);
                component.set("v.WaitingWindow", false);
            }
        }else if(currentStep == 3)
        {
            var tempMPKItems = component.get("v.tempMPKItems");
            if(tempMPKItems.length  == isReady)
            {
                component.set("v.isChildReady",0);
                component.set("v.WaitingWindow", false);
            }               
        }
	},

	convertDatetoString: function(inputDate)
	{
		if( inputDate !== undefined & inputDate !== null)
		{
			var array = inputDate.split("-");
			if(array.length = 3)
				return array[1]+'/'+array[2]+'/'+array[0];
			else
				return 'unknown';
		}else
		{
			return 'unknown';
		}
	},
})
// console.log("javascript debug: " + JSON.stringify(TSCCReport));