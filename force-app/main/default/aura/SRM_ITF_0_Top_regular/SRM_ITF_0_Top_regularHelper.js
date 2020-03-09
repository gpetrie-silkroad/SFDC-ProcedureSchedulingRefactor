({
  	// Fetch the currentUserRecord from the Apex controller
  	getCurrentUser: function(component) {
      component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting User Info.");
      component.set("v.WaitingWindow", true);

    	var action = component.get('c.getCurrentUser');

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult)
      {
    		var result = actionResult.getReturnValue();
    		component.set('v.currentUser', result);
        component.set("v.WaitingWindow", false);
      });
      $A.enqueueAction(action);
    },

    // Send ITF Info to Salesforce database to create a new ITF
    createNewITForm: function(component) {
      component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is creating an ITF on SFDC.");
      component.set("v.WaitingWindow", true);
      var ITForm = component.get('v.newITForm');
      var action = component.get('c.createNewITF');
      action.setParams({
          "newITForm": ITForm
      });

      action.setCallback(this, function(response)
      {
        var state = response.getState();

        if (state === "SUCCESS") {
            var result = response.getReturnValue();
            component.set('v.newITForm.Id', result);
        }else{
            alert("error on creating a new ITForm");
        }
        component.set("v.WaitingWindow", false);
      });     
      $A.enqueueAction(action);
    },

    // Send update ITF Info to Salesforce database to update the ITF
    updateITForm: function(component) 
    {
      component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is updating the ITF on SFDC.");
      component.set("v.WaitingWindow", true);
      var ITForm = component.get('v.newITForm');
      var action = component.get('c.updateITF');

      action.setParams({
          "iTForm": ITForm
      });
      
      action.setCallback(this, function(response)
      {
        var state = response.getState();
        if (state === "SUCCESS") {
            var result = response.getReturnValue();
            component.set('v.newITForm', result);
        }
        else {
            alert("error on updating ITForm")
        }
        component.set("v.WaitingWindow", false);
      });     
      $A.enqueueAction(action);
    },

    getAMUserslist: function(component) 
    {
      component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting Area Manager List.");
      component.set("v.WaitingWindow", true);
      var action = component.get('c.getAMUsers');
      action.setParams({
            "isCurrentUser": '0'
      });

      // Set up the callback
      var self = this;
      action.setCallback(this, function(actionResult)
      {
        var state = actionResult.getState();
        if(state ==="SUCCESS")
              component.set('v.AMUsers', actionResult.getReturnValue());
        component.set("v.WaitingWindow", false);
      });
      $A.enqueueAction(action);
    },

    // Fetch list of TDS users from the Apex controller
    getTDSUserslist: function(component) 
    {
      component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting TDS List.");
      component.set("v.WaitingWindow", true);
      var action = component.get('c.getTDSUsers');
      action.setParams({
            "isCurrentUser": '0'
      });

      // Set up the callback
      var self = this;
      action.setCallback(this, function(actionResult) 
      {
        component.set('v.TDSUsers', actionResult.getReturnValue());
        component.set("v.WaitingWindow", false);
      });
      $A.enqueueAction(action);
    },

    // Fetch list of other qualified users from the Apex controller
    getOtherUserslist: function(component)
    {
      component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting other Users List.");
      component.set("v.WaitingWindow", true);
      var action = component.get('c.getOtherUsers');
      action.setParams({
            "isCurrentUser": '0'
      });      

      // Set up the callback
      var self = this;
      action.setCallback(this, function(actionResult)
      {
        component.set('v.OtherUsers', actionResult.getReturnValue());
        component.set("v.WaitingWindow", false);
      });
      $A.enqueueAction(action);
    },

    // Fetch list of Accounts from the Apex controller
    getAccountslist: function(component)
    {
      component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting Accounts List.");
      component.set("v.WaitingWindow", true);
      var action = component.get('c.getAccounts');     

      // Set up the callback
      var self = this;
      action.setCallback(this, function(actionResult) 
      {
        component.set('v.Accounts', actionResult.getReturnValue());
        component.set("v.WaitingWindow", false);
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

    getLotInven: function(component, ownerName, savelocation) 
    {
      component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting selected users' inventory List.");
      component.set("v.WaitingWindow", true);
      var action = component.get("c.getLotInventory");

      action.setParams({
        "owner": ownerName
      });

      action.setCallback(this, function(response)
      {
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
        component.set("v.WaitingWindow", false);
      });
      $A.enqueueAction(action);
    },

    getItemNumberList: function(component) 
    {
      component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting item List.");
      component.set("v.WaitingWindow", true);

      var action = component.get("c.getSoldItemNumber");

      action.setCallback(this, function(response) 
      {
        var state = response.getState();
        if (state === "SUCCESS") {
          var result = response.getReturnValue();
          component.set('v.listItemNumForCustomer', result);
        }
        else{
          alert('Error on getting item number list');
        }
        component.set("v.WaitingWindow", false);
      });
      $A.enqueueAction(action);
    },
    
    getITFinfo: function(component) 
    {
      component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting ITF Information.");
      component.set("v.WaitingWindow", true);
      var iTFID = component.get("v.recordId");
      var action = component.get("c.getITF");
      action.setParams({
        "iTFID": iTFID
      });

      action.setCallback(this, function(response)
      {
        var state = response.getState();
        if (state === "SUCCESS") {
          var result = response.getReturnValue();
          component.set('v.newITForm', result);
          this.initialFormType(component, result);
          component.set('v.completeGetITForm', true);
          if(result.To_Rep_TDS__c != undefined & result.To_Rep_TDS__c == 'FG (Trunk Stock Return)')
          {
            component.set('v.ITFType', 'Trunk Stock Return Form');
          }
        }
        component.set("v.WaitingWindow", false);
      });
      $A.enqueueAction(action);
    },

    getITFTransactions: function(component)
    {
      component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is getting ITF transactions Information.");
      component.set("v.WaitingWindow", true);
      var ITFID = component.get('v.newITForm.Id');
      var action = component.get('c.getITFTransactionsList');
      action.setParams({
        "ITFID": ITFID
      });

      action.setCallback(this, function(response)
      {
        var state = response.getState();

        if (state === "SUCCESS") {
            var result = response.getReturnValue();
            component.set("v.ITFTransactions",result);
        }else{
            alert("error on getting a list of ITFTransactions");
        }
        component.set("v.WaitingWindow", false);
      });

      $A.enqueueAction(action);
    },

    getIncompleteITForm: function(component) 
    {
      component.set("v.waitingMessage", "Please wait. SRM-SFDC Assistant is checking open ITFs.");
      component.set("v.WaitingWindow", true);
      var action = component.get('c.getIncompleteITF');

      action.setCallback(this, function(response)
      {
        var state = response.getState();
        component.set('v.isITFReady', true);
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
        component.set("v.WaitingWindow", false);
      });

      $A.enqueueAction(action);
    },
    
    updateSRMEmployeeAccountlist: function(component) {
        var ITForm = component.get('v.newITForm');
        var AMUsers = component.get('v.AMUsers');
        var TDSUsers = component.get('v.TDSUsers');
        var OtherUsers = component.get('v.OtherUsers');
        var currentUser = component.get('v.currentUser');
        var Accounts = component.get('v.Accounts');

        if(ITForm.SRM_AM__c != null & ITForm.SRM_AM__c != '')
        {
          currentUser.Id = ITForm.SRM_AM__c;
          currentUser.FirstName = ITForm.SRM_AM__r.FirstName;
          currentUser.LastName = ITForm.SRM_AM__r.LastName;
          var updateUsersList = [];
          updateUsersList.push(currentUser);
          for(var i=0; i<AMUsers.length;i++)
              updateUsersList.push(AMUsers[i]);
          component.set('v.AMUsers',updateUsersList);          
        }

        if(ITForm.SRM_TDS__c != null & ITForm.SRM_TDS__c != '')
        {
          currentUser.Id = ITForm.SRM_TDS__c;
          currentUser.FirstName = ITForm.SRM_TDS__r.FirstName;
          currentUser.LastName = ITForm.SRM_TDS__r.LastName;
          var updateUsersList = [];
          updateUsersList.push(currentUser);
          for(var i=0; i<TDSUsers.length;i++)
              updateUsersList.push(TDSUsers[i]);
          component.set('v.TDSUsers',updateUsersList);          
        }

        if(ITForm.Other_Qualified_SRM_Employee__c != null & ITForm.Other_Qualified_SRM_Employee__c != '')
        {
          currentUser.Id = ITForm.Other_Qualified_SRM_Employee__c;
          currentUser.FirstName = ITForm.Other_Qualified_SRM_Employee__r.FirstName;
          currentUser.LastName = ITForm.Other_Qualified_SRM_Employee__r.LastName;
          var updateUsersList = [];
          updateUsersList.push(currentUser);
          for(var i=0; i<OtherUsers.length;i++)
              updateUsersList.push(OtherUsers[i]);
          component.set('v.OtherUsers',updateUsersList);          
        }

        var updateAccountsList = [];
        if(ITForm.Customer_To__c != null & ITForm.Customer_To__c != '')
        {
          var addAccount1 =  component.get('v.tempAccount1');
          addAccount1.Id = ITForm.Customer_To__c;
          addAccount1.IQMS_Customer_Number__c = ITForm.Customer_To__r.IQMS_Customer_Number__c;
          addAccount1.Name = ITForm.Customer_To__r.Name;
          updateAccountsList.push(addAccount1);
        }
        if(ITForm.Customer_From__c != null & ITForm.Customer_From__c != '') 
        {
          var addAccount2 =  component.get('v.tempAccount2');
          addAccount2.Id = ITForm.Customer_From__c;
          addAccount2.IQMS_Customer_Number__c = ITForm.Customer_From__r.IQMS_Customer_Number__c;
          addAccount2.Name = ITForm.Customer_From__r.Name;
          updateAccountsList.push(addAccount2);
        }
        if(updateAccountsList.length > 0) 
        {
          for(var i=0; i<Accounts.length;i++)
              updateAccountsList.push(Accounts[i]);
          component.set('v.Accounts', updateAccountsList); 
        }
    },

    initialFormType: function(component, returnITF)
    {
      var listOfStep = [];
      //Initilize steps
      if(returnITF.To_Rep_TDS__c == 'FG (Trunk Stock Return)')
      {
        listOfStep = ['ITF Draft','Shipment Information','Transacted Inventory/Verification', 'In Transit', 'Received'];
        component.set('v.DisplayShipmentInfo', true);
      }
      else if(returnITF.ITF_Type__c == 'Internal Transfer (AM/TDS to AM/TDS)')
      {
        listOfStep = ['ITF Draft', 'Transacted Inventory/Verification', 'Closed'];
      }else
      {
        listOfStep = ['ITF Draft','Transacted Inventory/Verification','Pending PO', 'Closed'];        
      }
      component.set('v.ITFsteps', listOfStep);

      //Initialize current step
      if(returnITF.Status__c == null || returnITF.Status__c == undefined || returnITF.Status__c =='')
      {
        component.set('v.ITFcurrentStep', 'ITF Draft');
      }else
      {
        component.set('v.ITFcurrentStep', returnITF.Status__c);
      }      
    },
})
// console.log("Create expense8: " + JSON.stringify(result));