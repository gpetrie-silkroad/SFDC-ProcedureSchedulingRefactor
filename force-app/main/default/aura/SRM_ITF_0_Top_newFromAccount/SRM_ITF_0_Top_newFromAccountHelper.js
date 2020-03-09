({
  	// Fetch the currentUserRecord from the Apex controller
  	getCurrentUser: function(component) {
    	var action = component.get('c.getCurrentUser');

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
    		var result = actionResult.getReturnValue();
    		component.set('v.currentUser', result);
        });
        $A.enqueueAction(action);
    },

    // Send ITF Info to Salesforce database to create a new ITF
    createNewITForm: function(component) {
        var ITForm = component.get('v.newITForm');
        var action = component.get('c.createNewITF');
        action.setParams({
            "newITForm": ITForm
        });

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set('v.newITForm.Id', result);
            }else{
                alert("error on creating a new ITForm");
            }
        });     
        $A.enqueueAction(action);
    },

    // Send update ITF Info to Salesforce database to update the ITF
    updateITForm: function(component) {
        var ITForm = component.get('v.newITForm');
        var action = component.get('c.updateITF');

        action.setParams({
            "iTForm": ITForm
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set('v.newITForm', result);
            }
            else {
                alert("error on updating ITForm")
            }
        });     
        $A.enqueueAction(action);
    },

    getAMUserslist: function(component) {
      var action = component.get('c.getAMUsers');
      action.setParams({
            "isCurrentUser": '0'
      });

        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
        var state = actionResult.getState();
        if(state ==="SUCCESS")
              component.set('v.AMUsers', actionResult.getReturnValue());
      });
        $A.enqueueAction(action);
    },

    // Fetch list of TDS users from the Apex controller
    getTDSUserslist: function(component) {
      var action = component.get('c.getTDSUsers');
      action.setParams({
            "isCurrentUser": '0'
      });

      // Set up the callback
      var self = this;
      action.setCallback(this, function(actionResult) {
        component.set('v.TDSUsers', actionResult.getReturnValue());
      });
        $A.enqueueAction(action);
    },

    // Fetch list of other qualified users from the Apex controller
    getOtherUserslist: function(component) {
      var action = component.get('c.getOtherUsers');
      action.setParams({
            "isCurrentUser": '0'
      });      

      // Set up the callback
      var self = this;
      action.setCallback(this, function(actionResult) {
        component.set('v.OtherUsers', actionResult.getReturnValue());
      });
        $A.enqueueAction(action);
    },

    // Fetch list of Accounts from the Apex controller
    getAccountslist: function(component) {
      var action = component.get('c.getAccounts');     

      // Set up the callback
      var self = this;
      action.setCallback(this, function(actionResult) {
        component.set('v.Accounts', actionResult.getReturnValue());
      });
        $A.enqueueAction(action);
    },

    // UpdateOwnerPickList and "From AM/TDS field"
    updateOwnerPickList: function(component) {
        var ITForm = component.get('v.newITForm');
        var ownerPickList = [];
        var name = '';
        var Accounts = component.get('v.Accounts');
        var AMUsers = component.get('v.AMUsers');
        var TDSUsers = component.get('v.TDSUsers');
        var OtherUsers = component.get('v.OtherUsers');
        var fromAMTDS ='';
        var i = 0;
        var ownerName ='';

        if(ITForm.SRM_AM__c != null){
          for(i=0; i<AMUsers.length; i++){
            if(ITForm.SRM_AM__c == AMUsers[i].Id){
              name = AMUsers[i].FirstName + ' ' + AMUsers[i].LastName;
              ownerName = '%'+AMUsers[i].FirstName+'%'+AMUsers[i].LastName+'%';
              var amLotInvenName = component.get("v.amLotInvenName");
              if(amLotInvenName != name){
                component.set("v.amLotInvenName", name);
                this.getLotInven(component, ownerName, 1);
              }
            }
          }
          ownerPickList.push(name);
          fromAMTDS = name;
        }

        if(ITForm.SRM_TDS__c != null){
          for(i=0; i<TDSUsers.length; i++){
            if(ITForm.SRM_TDS__c == TDSUsers[i].Id)
              name = TDSUsers[i].FirstName + ' ' + TDSUsers[i].LastName;
              ownerName = '%'+TDSUsers[i].FirstName+'%'+TDSUsers[i].LastName+'%';

              var tdsLotInvenName = component.get("v.tdsLotInvenName");
              if(tdsLotInvenName != name){
                component.set("v.tdsLotInvenName", name);
                this.getLotInven(component, ownerName, 2);
              }
          }
          ownerPickList.push(name);
          if(fromAMTDS  =='')
            fromAMTDS = name;
          else
            fromAMTDS = fromAMTDS + ', ' + name;
        }

        if(ITForm.Other_Qualified_SRM_Employee__c != null){
          for(i=0; i<OtherUsers.length; i++){
            if(ITForm.Other_Qualified_SRM_Employee__c == OtherUsers[i].Id){
              name = OtherUsers[i].FirstName + ' ' + OtherUsers[i].LastName;
              ownerName = '%'+OtherUsers[i].FirstName+'%'+OtherUsers[i].LastName+'%';

              var otherLotInvenName = component.get("v.otherLotInvenName");
              if(otherLotInvenName != name){
                component.set("v.otherLotInvenName", name);
                this.getLotInven(component, ownerName, 3);
              }
            }            
          }
          ownerPickList.push(name);
          if(fromAMTDS  =='')
            fromAMTDS = name;
          else
            fromAMTDS = fromAMTDS + ', ' + name;          
        }

        if(ITForm.ITF_Type__c == 'External Transfer (Customer to Customer)'){
            for(i=0; i<Accounts.length; i++){
                if(ITForm.Customer_From__c == Accounts[i].Id){
                  name = Accounts[i].IQMS_Customer_Number__c + ' - ' + Accounts[i].Name;
                }
            }
            name = name.substring(0,69);
            var customerInventoryName = component.get("v.listItemNumForCustomerName");
            if(customerInventoryName != name){
              component.set("v.listItemNumForCustomerName", name);
              if(customerInventoryName == null || customerInventoryName =='')
                this.getItemNumberList(component);
            }
            ownerPickList.push(name);
        }

        if(ITForm.ITF_Type__c == 'Internal Transfer (AM/TDS to AM/TDS)'){
          component.set('v.newITForm.From_Rep_TDS__c',fromAMTDS);
        }

        //Add N/A to user list if we have more than 1 user to choose
        var tempList = [];
        if(ownerPickList.length !=1){
            tempList.push("----N/A----");
        }
        for(i=0; i<ownerPickList.length;i++)
            tempList.push(ownerPickList[i]);
        component.set('v.possibleOwnerList',tempList);
    },

    getLotInven: function(component, ownerName, savelocation) {
        var action = component.get("c.getLotInventory");
 
         action.setParams({
          "owner": ownerName
        });

        action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS") {
            var result = response.getReturnValue();
            if(savelocation==3)
              component.set('v.otherLotInven', result);
            else if(savelocation==2)
              component.set('v.tdsLotInven', result);
            else if(savelocation==1)
              component.set('v.amLotInven', result);
            else
              alert('Invalid savelocation number - ' + savelocation);
          }
          else{
            alert('Error on getting lot inventory for ID:' + id);
          }
        });
        $A.enqueueAction(action);
    },

    getItemNumberList: function(component) {
        var action = component.get("c.getSoldItemNumber");

        action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS") {
            var result = response.getReturnValue();
            component.set('v.listItemNumForCustomer', result);
          }
          else{
            alert('Error on getting item number list');
          }
        });
        $A.enqueueAction(action);
    },
    
    getITFinfo: function(component) {
        var iTFID = component.get("v.recordId");
        var action = component.get("c.getITF");
        action.setParams({
          "iTFID": iTFID
        });

        action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS") {
            var result = response.getReturnValue();
            component.set('v.newITForm', result);
            component.set('v.completeGetITForm', true);
          }
        });
        $A.enqueueAction(action);
    },

    getITFTransactions: function(component) {
        var ITFID = component.get('v.newITForm.Id');
        var action = component.get('c.getITFTransactionsList');
        action.setParams({
          "ITFID": ITFID
        });

        action.setCallback(this, function(response){
          var state = response.getState();

          if (state === "SUCCESS") {
              var result = response.getReturnValue();
              component.set("v.ITFTransactions",result);
          }else{
              alert("error on getting a list of ITFTransactions");
          }
        });

        $A.enqueueAction(action);
    },

    checkCustomerInfo: function(component) {
        var recordId = component.get("v.recordId");
        var action = component.get('c.isValidAccountForITF');
        action.setParams({
          "accountID": recordId
        });

        action.setCallback(this, function(response){
          var state = response.getState();
          if (state === "SUCCESS")
          {
            var result = response.getReturnValue();

            if(result)
            {
              this.getIncompleteITForm(component);              
            }else
            {
              alert("The account has not been create on our ERP system. Please update the opportunity of the account so the customer success team can create the account on ERP system. Thanks.");
              var navEvt = $A.get("e.force:navigateToSObject");
              navEvt.setParams({
                  "recordId": recordId,
                  "slideDevName": "detail"
              });
              navEvt.fire();
            }
          }
          else
          {
            alert("An unexpected error. Please check your internet connection.");
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": recordId,
                "slideDevName": "detail"
            });
            navEvt.fire();            
          }
        });

        $A.enqueueAction(action);
    },

    getIncompleteITForm: function(component) {
        var recordId = component.get("v.recordId");
        var action = component.get('c.getIncompleteITF');
        action.setParams({
          "customerID": recordId,
          "iTFType": 'Transfer to Customer'
        });

        action.setCallback(this, function(response){
          var state = response.getState();
          if (state === "SUCCESS")
          {
            var result = response.getReturnValue();
            if(result !== null & result !== '')
            {
              var message = "I, SRM-SFDC Assistant, find an incomplete ITF which is created by you today. Do you want to continue to work on the incomplete ITF?";
              var userchoice = confirm(message);
              if(userchoice)
              {
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": result,
                    "slideDevName": "detail"
                });
                navEvt.fire();
              }
            }
          }
          component.set('v.isITFReady', true);
        });

        $A.enqueueAction(action);
    },
})

// console.log("Create expense8: " + JSON.stringify(result));