({
	doInit: function(component, event, helper)
	{
		component.set('v.waitingMessage', 'Initialzing the lot inventory and rep/tds list.');

		//Initialize TSAudit Header
		var today = new Date();
		var year = today.getFullYear();
		var month = today.getMonth();
		var day = today.getDay();
		var date = today.getDate();
		const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
		component.set("v.TSCCount.Trunk_Stock_Cycle_Count_ID__c", year + "-" + monthNames[month] + " Trunk Stock Audit");
		var emailSubject =  year + "-" + monthNames[month] + " Monthly Trunk Stock Audit";

		var monthDisplay = month+1;
		component.set("v.TSCCount.Start_Date__c", year + "-" + monthDisplay + "-" + date);

		today = new Date(year, month, date+7);
		
		month = today.getMonth();
		date = today.getDate();
		year = today.getFullYear();
		monthDisplay = month+1;
		component.set("v.TSCCount.Due_Date__c", year + "-" + monthDisplay + "-" + date);

		today = new Date(year, month, 0);
		date = today.getDate();
		component.set("v.TSCCount.End_Date__c", year + "-" + monthDisplay + "-" + date);

		//Get all related Infos on SFDC - Lot Inv, trunk stock user list, email temp, user not in the list, and user in the CC list
		helper.getRequestTSCCEmailTem(component, emailSubject);
		// helper.getLotInvList(component);
		
		// 
		// helper.getreptdsnotSFDClist(component);
// helper.getRepTDSList(component);
		//Initialize CC users
		// var CCaddress = '';
		// var url = location.href;
                
		// if(!url.includes('silkroadmed.lightning.force.com'))
		// {
		// 	CCaddress = 'salesforce@silkroadmed.com';
		// }else
		// {
		// 	CCaddress = 'hgrosu@silkroadmed.com';
		// 	CCaddress += '; fversprille@silkroadmed.com';
		// 	CCaddress += '; andrew.davis@silkroadmed.com';
		// 	CCaddress += '; dclark@silkroadmed.com';
		// 	CCaddress += '; scurtis@silkroadmed.com';
		// 	CCaddress += '; jwright@silkroadmed.com';
		// 	CCaddress += '; rbarr@silkroadmed.com';
		// 	CCaddress += '; fviano@silkroadmed.com';			
		// }
		// component.set('v.CCEmailAddress',CCaddress);
	},
	
	updateAferRecListUser: function(component, event, helper)
	{
		component.set("v.WaitingWindow", true);
		component.set('v.waitingMessage', 'Initialzing the lot inventory and rep/tds list.');

		var listLotInventory = component.get("v.listLotInventory");
		var listAMTDSADUsers = component.get("v.listAMTDSADUsers");
		var TSCCount = component.get("v.TSCCount");
		var TSCCReports = [];
		var selectedlist = [];
		var tempNum = 0;
		var i = 0;
		var j = 0;

		for( i=0; i<listAMTDSADUsers.length; i++)
		{
			//Update TSCCReport
			tempNum = 0;
			for( j=0; j<listLotInventory.length; j++)
			{
				if(listAMTDSADUsers[i].Id == listLotInventory[j].Note__c) //Note__c: store ownerID of lot Inventory
				{
					listLotInventory[j].Submitted__c = true;
					tempNum = listLotInventory[j].Total_Inventory_Units__c;
					j = listLotInventory.length;
				}
			}

			TSCCReports.push({ 
								'sobjectType':'Trunk_Stock_Cycle_Count_Report__c',
								'Name__c': listAMTDSADUsers[i].Name,
								'Total_Inventory_Units__c': tempNum,
								'OwnerId': listAMTDSADUsers[i].Id,
								'Reviewer__c': listAMTDSADUsers[i].Title
							});

			//Initialize selected list - rep/tds have at least 1 units
			// if(tempNum > 0)
			// 	selectedlist.push(true);
			// else
			// 	selectedlist.push(false);

			// Initialize selected list - select all
			selectedlist.push(true);
		}
		component.set("v.TSCCReports", TSCCReports);

		//Check do we miss any re/tds own trunk stock but not show on the main list
		var MissingSFDCUsers = [];
		for( j=0; j<listLotInventory.length; j++)
		{
			if(!listLotInventory[j].Submitted__c)
			{
				listLotInventory[j].Note__c = 'Missing name on the main list';
				MissingSFDCUsers.push(listLotInventory[j]);
			}
		}
		component.set('v.MissingSFDCUsers', MissingSFDCUsers);

		//trigger for child to update selected
		component.set("v.selectedList", selectedlist);
		if(component.get("v.updatedselectedList"))
			component.set("v.updatedselectedList", false);
		else 
			component.set("v.updatedselectedList", true);

		component.set("v.WaitingWindow", false);
	},

	SelectAllUsers: function(component, event, helper)
	{
		var selectedlist = component.get("v.selectedList");
		var i = 0;

		for( i=0; i<selectedlist.length; i++)
		{
			selectedlist[i] = true;
		}

		//trigger for child to update selected
		component.set("v.selectedList", selectedlist);
		if(component.get("v.updatedselectedList"))
			component.set("v.updatedselectedList", false);
		else 
			component.set("v.updatedselectedList", true);
	},

	RemoveSelectedUsers: function(component, event, helper)
	{
		var selectedlist = component.get("v.selectedList");
		var i = 0;

		for( i=0; i<selectedlist.length; i++)
		{
			selectedlist[i] = false;
		}

		//trigger for child to update selected
		component.set("v.selectedList", selectedlist);
		if(component.get("v.updatedselectedList"))
			component.set("v.updatedselectedList", false);
		else 
			component.set("v.updatedselectedList", true);
	},

	SelectRepTDSAtleast1unit: function(component, event, helper)
	{
		var selectedlist = component.get("v.selectedList");
		var TSCCReports = component.get("v.TSCCReports");
		var i = 0;

		for( i=0; i<selectedlist.length; i++)
		{
			if(TSCCReports[i].Total_Inventory_Units__c)
				selectedlist[i] = true;
			else
				selectedlist[i] = false;
		}

		//trigger for child to update selected
		component.set("v.selectedList", selectedlist);
		if(component.get("v.updatedselectedList"))
			component.set("v.updatedselectedList", false);
		else 
			component.set("v.updatedselectedList", true);
	},

	saveEmailTemplate: function(component, event, helper)
	{
		helper.saveEmail(component);
	},

	CreateTSCCAndSendEmails: function(component, event, helper)
	{
		helper.createNewTSCC(component);
	},

    closeWaitingPopUp: function(component, event, helper) {
        component.set("v.WaitingWindow", false);
    },

    updateTotalSelectedUSers: function(component, event, helper) {
        var selectedlist = component.get("v.selectedList");
        var totalslect = 0;
        var i = 0;

        for( i=0; i<selectedlist.length; i++)
        {
        	if(selectedlist[i])
        		totalslect++;
        }
        component.set("v.totalSelectedUser", totalslect);
    },
})
// console.log("javascript debug: " + JSON.stringify(LookUpTDSValue));