({
    getITFTransactions: function(component) {
    	  var ITFID = component.get('v.ITForm.Id');
        var action = component.get('c.getITFTransactionsList');
        action.setParams({
          "ITFID": ITFID
        });
        component.set('v.waitingMessage', "SFDC is getting the transactions.");
        component.set('v.WaitingWindow', true);

        action.setCallback(this, function(response){
          var state = response.getState();
          component.set('v.WaitingWindow', false);
          
          if (state === "SUCCESS") {
          	  var result = response.getReturnValue();
          	  component.set("v.ITFTransactions",result);

              //Calculating summary total used items
              var itemList = component.get('v.listItemNumForCustomer');
              var listTotalitems = [];
              var qty = 0;
              var i = 0;
              var j = 0;
              for(i=0; i < itemList.length; i++)
                listTotalitems.push(qty);

              for(i=0; i< result.length; i++)
                for(j=0; j< itemList.length; j++)
                  if(result[i].Product_Number__c == itemList[j]){
                    listTotalitems[j] += result[i].Quantity__c;
                    j = itemList.length;
                  }
              var summary='';
              for(i=0; i < itemList.length; i++)
                if(listTotalitems[i]>0)
                  summary += listTotalitems[i]+'-'+itemList[i]+' ';
              summary.substr(0,254);
              component.set('v.ITForm.Summary_Used_Item__c', summary);
              //=========================================================================

          }else{
              alert("error on getting a list of ITFTransactions");
          }
        });

        $A.enqueueAction(action);
    },

    delTran: function(component, ITFormTransaction, callback) {
      component.set('v.waitingMessage', "SFDC is deleting the transactions.");
      component.set('v.WaitingWindow', true);
      var action = component.get("c.deleteITFTransaction");
      var transactionInfo = "\nProduct #: " + ITFormTransaction.Product_Number__c
                    + "\nlot#: " + ITFormTransaction.Lot_number__c 
                    + "\nQty: " + ITFormTransaction.Quantity__c;
      action.setParams({
        "iTFTransaction": ITFormTransaction
      });


      action.setCallback(this, function(response) {
        var state = response.getState();
        component.set('v.WaitingWindow', false);
        if (state === "SUCCESS") {
          this.getITFTransactions(component);
          alert("Deleted a Transaction: " + transactionInfo);
        }else
          alert("Error to remove a Transaction: " + transactionInfo);
      });
      $A.enqueueAction(action);
    },

    getCustomerPricebook: function(component, accountID) {
      component.set('v.waitingMessage', "SFDC is getting price book.");
      component.set('v.WaitingWindow', true);   

      var action = component.get('c.getAccountPriceBook');
      action.setParams({
        "accountID": accountID
      });

      action.setCallback(this, function(response){
        var state = response.getState();
        if (state === "SUCCESS")
        {
          var result = response.getReturnValue();
          component.set("v.customerPriceBook",result);          
        }else
        {
          alert("error on getting customer's price book");
        }

        component.set('v.WaitingWindow', false);
      });

      $A.enqueueAction(action);
    },

})

// console.log("Error to create the new ITF info: " + JSON.stringify(ITForm));