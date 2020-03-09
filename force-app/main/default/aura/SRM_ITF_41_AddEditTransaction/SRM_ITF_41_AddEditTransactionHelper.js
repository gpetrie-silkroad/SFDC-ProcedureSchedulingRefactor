({
  setDefaultValues: function (component){
    var ITF = component.get('v.ITForm');
    if(ITF.ITF_Type__c !== 'Internal Transfer (AM/TDS to AM/TDS)')
    {
      component.set('v.workingITFTransaction.Price__c', null);
      component.set("v.warningSuggestedPrice", 0);
    }
    component.set('v.workingITFTransaction.Replenish__c', false);   
  },

  updateProductList: function (component, ownerName){
    var i = 0;
    var productList = ['N/A'];
    var productListProcess = [];
    var lotList = ['N/A'];

    var AMName = component.get('v.amLotInvenName');
    if(ownerName == AMName){
      //Update Product Number Pick List
      var AMNamelist = component.get('v.amLotInven');
      for(i=0; i < AMNamelist.length; i++){
        productList.push(AMNamelist[i].Item_Number__c);
        lotList.push(AMNamelist[i].Lot_Number__c);
      }
    }else{
      var otherLotInvenName = component.get('v.otherLotInvenName');
      if(ownerName == otherLotInvenName){
        //Update Product Number Pick List
        var otherLotInvenlist = component.get('v.otherLotInven');
        for(i=0; i < otherLotInvenlist.length; i++){
          productList.push(otherLotInvenlist[i].Item_Number__c);
          lotList.push(otherLotInvenlist[i].Lot_Number__c);
        }
      }else{
        var tdsLotInvenName = component.get('v.tdsLotInvenName');
        if(ownerName == tdsLotInvenName){
          //Update Product Number Pick List
          var tdsLotInvenlist = component.get('v.tdsLotInven');
          for(i=0; i < tdsLotInvenlist.length; i++){
            productList.push(tdsLotInvenlist[i].Item_Number__c);
            lotList.push(tdsLotInvenlist[i].Lot_Number__c);
          }
        }else
        {
          var customerInventoryName = component.get('v.listItemNumForCustomerName');
          if(ownerName == customerInventoryName){
              var templist = component.get('v.listItemNumForCustomer');
              for(i=0; i<templist.length ; i++)
                  lotList.push(templist[i])
              component.set('v.productNumberPickList',lotList);
              component.set('v.manualInput',true);
              return true;
          }else
          {
              var tempITFTransaction = component.get('v.tempITFTransaction');
              if(tempITFTransaction.Id != null & tempITFTransaction.Id != '')
              {
                var templist = component.get('v.listItemNumForCustomer');
                for(i=0; i<templist.length ; i++)
                  lotList.push(templist[i])
                component.set('v.productNumberPickList',lotList);
                component.set('v.manualInput',true);
                return true;
              }else
              {
                alert('Cannot find Inventory for ' + ownerName + '.\nPlease check Inventory Owner.');
                return false;                
              }
          }
        }
      }
    } 

    component.set('v.manualInput',false);

    //Remove the duplicate Product Number
    if(productList.length > 0)
      productListProcess.push(productList[0]);
    for(i=0; i < productList.length-1; i++){
      if(productList[i] != productList[i+1])
        productListProcess.push(productList[i+1]);
    }

    component.set('v.productNumberPickList',productListProcess);
    component.set('v.lotNumberPickList',lotList);
    return true;
  },

  updateLotList: function (component, ownerName, Product){
    var lotList = ['N/A'];
    
    var i = 0;
    var AMName = component.get('v.amLotInvenName');
    if(ownerName == AMName){
      //Update Lot Number Pick List
      var AMNamelist = component.get('v.amLotInven');
      for(i=0; i < AMNamelist.length; i++){
        if(AMNamelist[i].Item_Number__c == Product)
          lotList.push(AMNamelist[i].Lot_Number__c);
      }
    }else{
      var tdsLotInvenName = component.get('v.tdsLotInvenName');
      if(ownerName == tdsLotInvenName){
        //Update Lot Number Pick List
        var tdsLotInvenlist = component.get('v.tdsLotInven');
        for(i=0; i < tdsLotInvenlist.length; i++){
          if(tdsLotInvenlist[i].Item_Number__c == Product)
            lotList.push(tdsLotInvenlist[i].Lot_Number__c);
        }
      }else{
        var otherLotInvenName = component.get('v.otherLotInvenName');
        if(ownerName == otherLotInvenName){
          //Update Lot Number Pick List
          var otherLotInvenlist = component.get('v.otherLotInven');
          for(i=0; i < otherLotInvenlist.length; i++){
            if(otherLotInvenlist[i].Item_Number__c == Product)
              lotList.push(otherLotInvenlist[i].Lot_Number__c);
          }
        }
      }
    }

    component.set('v.lotNumberPickList',lotList);
  },

  updateQtyList: function (component, ownerName, lotNumber){
    var qtyList = ['0'];
    var maxQty = 0;

    var i = 0;
    var AMName = component.get('v.amLotInvenName');
    if(ownerName == AMName){
      //Update Lot Number Pick List
      var AMNamelist = component.get('v.amLotInven');
      for(i=0; i < AMNamelist.length; i++){
        if(AMNamelist[i].Lot_Number__c == lotNumber){
          maxQty = AMNamelist[i].On_Hand_Qty__c;
          i=AMNamelist.length;
        }
      }
    }else{
      var tdsLotInvenName = component.get('v.tdsLotInvenName');
      if(ownerName == tdsLotInvenName){
        //Update Lot Number Pick List
        var tdsLotInvenlist = component.get('v.tdsLotInven');
        for(i=0; i < tdsLotInvenlist.length; i++){
          if(tdsLotInvenlist[i].Lot_Number__c == lotNumber){
            maxQty = tdsLotInvenlist[i].On_Hand_Qty__c;
            i=tdsLotInvenlist.length;
          }
        }
      }else{
        var otherLotInvenName = component.get('v.otherLotInvenName');
        if(ownerName == otherLotInvenName){
          //Update Lot Number Pick List
          var otherLotInvenlist = component.get('v.otherLotInven');
          for(i=0; i < otherLotInvenlist.length; i++){
            if(otherLotInvenlist[i].Lot_Number__c == lotNumber){
              maxQty = otherLotInvenlist[i].On_Hand_Qty__c;
              i=otherLotInvenlist.length;
            }
          }
        }
      }
    }

    for(i=0; i < maxQty; i++){
      qtyList.push((i+1).toString());
    }

    component.set('v.qtyPickList',qtyList);
  },

  getExpiringDate: function (component, ownerName, lotNumber){
    var i = 0;
    var AMName = component.get('v.amLotInvenName');
    if(ownerName == AMName){
      //Update Lot Number Pick List
      var AMNamelist = component.get('v.amLotInven');
      for(i=0; i < AMNamelist.length; i++){
        if(AMNamelist[i].Lot_Number__c == lotNumber){
          return AMNamelist[i].Lot_Expiration_Date__c;
        }
      }
    }else{
      var tdsLotInvenName = component.get('v.tdsLotInvenName');
      if(ownerName == tdsLotInvenName){
        //Update Lot Number Pick List
        var tdsLotInvenlist = component.get('v.tdsLotInven');
        for(i=0; i < tdsLotInvenlist.length; i++){
          if(tdsLotInvenlist[i].Lot_Number__c == lotNumber){
            return tdsLotInvenlist[i].Lot_Expiration_Date__c  ;
          }
        }
      }else{
        var otherLotInvenName = component.get('v.otherLotInvenName');
        if(ownerName == otherLotInvenName){
          //Update Lot Number Pick List
          var otherLotInvenlist = component.get('v.otherLotInven');
          for(i=0; i < otherLotInvenlist.length; i++){
            if(otherLotInvenlist[i].Lot_Number__c == lotNumber){
              return otherLotInvenlist[i].Lot_Expiration_Date__c;
            }
          }
        }
      }
    }
  },

  checkITFTransaction: function(component) {
      var checkingTransaction = component.get('v.workingITFTransaction');
      var isValid = true;
      var errorMessage ="";

      //Checking Inventory Owner
      var invenOwnForm = component.find('invenOwnForm');
      var userList = component.get('v.possibleOwnerList');      
      if((checkingTransaction.Inventory_Owner__c == null ||  
          checkingTransaction.Inventory_Owner__c == '' || 
          checkingTransaction.Inventory_Owner__c == '----N/A----') 
         & userList.length != 1){
        invenOwnForm.set("v.errors", [{message:"Please select one Inventory Owner's name."}]);
        errorMessage += "Missing Inventory Owner\n";
        isValid = false;
      }else{
        invenOwnForm.set("v.errors", null);
      }




      //Checking Product
      var ITFType = component.get('v.ITForm.ITF_Type__c');
      var manualInput = component.get('v.manualInput');

      if((ITFType == 'External Transfer (Customer to Customer)') & manualInput)
      {
        var productNumForm = component.find('productNumForm');
        if( checkingTransaction.Product_Number__c == "N/A" 
            || checkingTransaction.Product_Number__c == ""
            || checkingTransaction.Product_Number__c == null
            || checkingTransaction.Product_Number__c == undefined)
        {
          productNumForm.set("v.errors", [{message:"Please choose a product number."}]);
          errorMessage += "Missing Product Number.\n";
          isValid = false;
        }else
        {
          productNumForm.set("v.errors", null);
        }
      }

      //Checking Lot number
      // var manualInput = component.get('v.manualInput');
      var lotForm;
      var QuantityForm;
      if(manualInput){
        lotForm = component.find('manualLotForm');
        QuantityForm = component.find('QuantityForm');
      }
      else{
        lotForm = component.find('lotForm');
        QuantityForm = component.find('qtyForm');
      }

      if(checkingTransaction.Lot_number__c == "N/A" || checkingTransaction.Lot_number__c == "" || checkingTransaction.Lot_number__c == null){
          lotForm.set("v.errors", [{message:"Please enter a lot number."}]);
          errorMessage += "Missing Lot Number.\n";
          isValid = false;
      }else{
          lotForm.set("v.errors", null);
      }

      //Checking Quantity
      if(checkingTransaction.Quantity__c == 0 || checkingTransaction.Quantity__c == null){
          QuantityForm.set("v.errors", [{message:"Please enter quantity."}]);
          errorMessage += "Missing quantity.\n";
          isValid = false;
      }else{
          QuantityForm.set("v.errors", null);
      }

      //CHecking Price
      var PriceForm = component.find('PriceForm');
      if(checkingTransaction.Price__c == null){
          PriceForm.set("v.errors", [{message:"Please enter a price."}]);
          errorMessage += "Missing Price.\n";
          isValid = false;
      }else{
          PriceForm.set("v.errors", null);
      }

      if(!isValid)
          alert(errorMessage);

      return isValid;
  },

  clearWorkingITFTransaction: function(component) {
      component.set('v.workingITFTransaction.Price__c', null);
      component.set("v.warningSuggestedPrice", 0);
      component.set('v.workingITFTransaction.Replenish__c', false);  
      component.set('v.workingITFTransaction.Note__c', ''); 
      component.set('v.workingITFTransaction.Inventory_Owner__c', ''); 
      component.set('v.workingITFTransaction.Lot_number__c', null); 
      component.set('v.workingITFTransaction.Product_Number__c', null); 
      component.set('v.workingITFTransaction.Quantity__c', null); 
      component.set('v.qtyString', null);
      component.set('v.workingITFTransaction.Id', null);
	},

  addTempITFTran: function(component) {
    var workingITFTransaction = component.get('v.workingITFTransaction');
    workingITFTransaction.Inventory_Transfer_Form__c = component.get('v.ITFormID');
     
    var action = component.get('c.addNewITFTransaction');

    action.setParams({
      "newITFTransaction": workingITFTransaction
    });

    component.set('v.waitingMessage', "SFDC is saving the transaction.");
    component.set('v.WaitingWindow', true);

    action.setCallback(this, function(response){
        var state = response.getState();
        component.set('v.WaitingWindow', false);
        
        if (state === "SUCCESS") {
            var result = response.getReturnValue();
            this.clearWorkingITFTransaction(component);
            var status = component.get('v.DisplayAddNewEditTransaction');
            component.set('v.DisplayAddNewEditTransaction', false);
            var createEvent = component.getEvent("ITFormTransactions");
            createEvent.fire();
              // component.set('v.newITForm', result);
        }else{
            alert("error on updating a ITFTransaction");
        }
    });
    $A.enqueueAction(action);
  },

  updateProductNum: function(component, lotNumber)
  {
    var LotInventory = [];
    var productNum = '';
    var i = 0;

    var ownerName = component.get('v.workingITFTransaction.Inventory_Owner__c');
    var AMName = component.get('v.amLotInvenName');
    if(ownerName == AMName)
    {
      LotInventory = component.get('v.amLotInven');
    }else
    {
      var otherLotInvenName = component.get('v.otherLotInvenName');
      if(ownerName == otherLotInvenName)
      {
        LotInventory = component.get('v.otherLotInven');
      }else
      {
        var tdsLotInvenName = component.get('v.tdsLotInvenName');
        if(ownerName == tdsLotInvenName)
        {
          LotInventory = component.get('v.tdsLotInven');
        }
      }
    }   

    for(i = 0; i < LotInventory.length; i++)
    {
      if( LotInventory[i].Lot_Number__c == lotNumber)
      {
        productNum = LotInventory[i].Item_Number__c;
        break;
      }
    }
    
    if(productNum != '')
    {
      component.set('v.workingITFTransaction.Product_Number__c', productNum);
      this.updatePrice(component);
    }
    
  },


  updatePrice: function(component)
  {
    var Product = component.get('v.workingITFTransaction.Product_Number__c');
    var suggestedprice = 0;
    var customerPriceBook = component.get('v.customerPriceBook');
    var UOM = component.get('v.workingITFTransaction.UOM__c');
    var productUOM = '';
    var ITForm = component.get('v.ITForm');
    
    if(ITForm.Bill_Only_PO__c == 'evaluation')
    {
      component.set('v.workingITFTransaction.Price__c', 0);
      component.set('v.warningSuggestedPrice', 2);
    }else
    {
      if(UOM == 'BX')
      {
        productUOM = Product + ' [BX]';
      }else
      {
        productUOM = Product;
      }

      var i = 0;
      for(i = 0; i < customerPriceBook.length; i++)
      {
        if(customerPriceBook[i].ProductCode == productUOM)
        {
          suggestedprice = customerPriceBook[i].UnitPrice;
          component.set('v.workingITFTransaction.Price__c', suggestedprice);
          component.set('v.warningSuggestedPrice', 1);
          break;
        }
      }      
    }
  },   	
})
// console.log("Create expense0: " + JSON.stringify(customerPriceBook));