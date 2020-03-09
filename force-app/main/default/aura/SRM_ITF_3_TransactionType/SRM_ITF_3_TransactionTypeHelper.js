({
    // Check ITFtype field
    CheckITFType:function(component) {
        var SRMInfoForm_TranType = component.find('SRMInfoForm_TranType');
        var SRMInfoForm_TranTypeValue = SRMInfoForm_TranType.get("v.value");

        if(SRMInfoForm_TranTypeValue == null || SRMInfoForm_TranTypeValue == ''){
          SRMInfoForm_TranType.set("v.errors", [{message:'Missing Transaction Type'}]);
          alert("Missing Transaction Type\n");
          return false;
        }else{
          SRMInfoForm_TranType.set("v.errors", null);
          return true;
        }
    },

    // Check required field of "transfer to Customer" section
    CheckTransferToCustomerForm:function(component) {
        var CustomerToForm = component.find('SearchNameTextBox');
        var CustomerToValue = component.get('v.ITForm.Customer_To__c');
        var errorMessage = new String();
        var count = 0;

        if(CustomerToValue == null || CustomerToValue == ''){
          CustomerToForm.set("v.errors", [{message:'Please select one valid customer.'}]);
          errorMessage = "Missing customer name\n";
          count++;
        }else{
          CustomerToForm.set("v.errors", null);
        }

        if(count == 0){
          return true;
        }else{
          alert(errorMessage);
          count = 0;
          return false;
        }
    },


    // Check required field of "Customer to Customer" section
    CheckCustomertoCustomerForm:function(component) {
        var CustomerToForm = component.find('SearchNameTextBox1');
        var CustomerToValue = component.get('v.ITForm.Customer_To__c');
        var CustomerFromForm = component.find('SearchNameTextBox2');
        var CustomerFromValue = component.get('v.ITForm.Customer_From__c');
        var errorMessage = "";
        var count = 0;

        if(CustomerToValue == null || CustomerToValue == ''){
          CustomerToForm.set("v.errors", [{message:'Please select one valid customer.'}]);
          errorMessage = "Missing customer name on the 'Customer To' field\n";
          count++;
        }else{
          CustomerToForm.set("v.errors", null);
        }

        if(CustomerFromValue == null || CustomerFromValue == ''){
          CustomerFromForm.set("v.errors", [{message:'Please select one valid customer.'}]);
          errorMessage += "Missing customer name on the 'Customer From' field\n";
          count++;
        }else{
          CustomerFromForm.set("v.errors", null);
        }


        if(count == 0){
          return true;
        }else{
          alert(errorMessage);
          count = 0;
          return false;
        }
    },

    // Check lookup required field for rep to rep form
   	CheckReptoRepForm:function(component) {
        // var fromAM = component.find('fromAM');
        // var fromAMValue = component.get('v.ITForm.SRM_AM__c');
        // var fromTDS = component.find('fromTDS');
        // var fromTDSValue = component.get('v.ITForm.SRM_TDS__c');  
        // var fromOther = component.find('fromOther');
        // var fromOtherValue = component.get('v.ITForm.Other_Qualified_SRM_Employee__c');
        // var isFromValid = false;


        // if(fromAMValue != null & fromAMValue != '')
        //     isFromValid = true;
        // else if(fromTDSValue != null & fromTDSValue != '')
        //     isFromValid = true;
        // else if(fromOtherValue != null & fromOtherValue != '')
        //     isFromValid = true;

        // if(isFromValid){
        //     fromOther.set("v.errors", null);
        // }else{
        //     //error message for invalid field
        //     var errorMessage = "Please select at least one person on 'from Rep/TDS' field."
        //     fromOther.set("v.errors", [{message:errorMessage}]);
        //     alert(errorMessage);
        // }
        var isFromValid = true;

        var toRepTDS = component.get('v.ITForm.To_Rep_TDS__c');
        var isToValid = false;
        var changeToREPTDS = component.get('v.changeToREPTDS');
        if( changeToREPTDS != true & (toRepTDS != null || toRepTDS != ''))
            isToValid = true;
        else{
            var LookUpTDS = component.find('ToTDS');
            var LookUpTDSValue = LookUpTDS.get("v.value");    
            var LookUpOther = component.find('ToOther');
            var LookUpOtherValue = LookUpOther.get("v.value");  
            var LookUpAM = component.find('ToAM');
            var LookUpAMValue = LookUpAM.get("v.value");
            var name = new String();
            var count = 0;
            
            

            if(LookUpTDSValue != null & LookUpTDSValue !='- N / A -'){
                name = LookUpTDSValue;
                count++;
            }

            if(LookUpOtherValue != null & LookUpOtherValue !='- N / A -'){
                name = LookUpOtherValue;
                count++;
            }

            if(LookUpAMValue != null & LookUpAMValue !='- N / A -'){
                name = LookUpAMValue;
                count++;
            }

            if(count == 1){
                count = 0;
                LookUpTDS.set("v.value",null);
                LookUpOther.set("v.value",null);
                LookUpAM.set("v.value",null);
                LookUpOther.set("v.errors", null);
                component.set('v.ITForm.To_Rep_TDS__c', name);
                isToValid = true;
            }else if( count == 0 & toRepTDS != null){
                LookUpTDS.set("v.value",null);
                LookUpOther.set("v.value",null);
                LookUpAM.set("v.value",null);
                LookUpOther.set("v.errors", null);
                isToValid = true;                            
            }else{
                if(count == 0){
                    name = "Please select one name on 'To Rep/TDS' field.";
                    LookUpOther.set("v.errors", [{message:name}]); 
                }
                else{
                    name = "Please don't select more than one name on 'To Rep/TDS' field.";
                    LookUpOther.set("v.errors", [{message:name}]); 
                }
                count = 0;
                alert(name);
                isToValid = false;
            }           
        }

        return isToValid & isFromValid;
	},


    updateFromRepTDSNames: function(component) {
    //Iniitialize fromUsers' name       
        var ITForm = component.get('v.ITForm');
        var i = 0;

        var repTDSnames = '';
        if(ITForm.SRM_AM__c !== null & ITForm.SRM_AM__c !== '' & ITForm.SRM_AM__c !== undefined)
        {
            var AMlist = component.get('v.AMUsers');
            for(i=0; i<AMlist.length; i++)
            {
                if(AMlist[i].Id == ITForm.SRM_AM__c)
                {
                    repTDSnames = AMlist[i].FirstName + ' ' + AMlist[i].LastName;
                    i = AMlist.length;
                }
            }
        }

        if(ITForm.SRM_TDS__c !== null & ITForm.SRM_TDS__c !== '' & ITForm.SRM_TDS__c!== undefined)
        {
            var TDSlist = component.get('v.TDSUsers');
            for(i=0; i<TDSlist.length; i++)
            {
                if(TDSlist[i].Id == ITForm.SRM_TDS__c)
                {
                    if(repTDSnames == '')
                        repTDSnames = TDSlist[i].FirstName + ' ' + TDSlist[i].LastName;
                    else
                        repTDSnames += ', ' + TDSlist[i].FirstName + ' ' + TDSlist[i].LastName;
                    i = TDSlist.length;
                }
            }
        }

        if(ITForm.Other_Qualified_SRM_Employee__c !== null & ITForm.Other_Qualified_SRM_Employee__c !== '' & ITForm.Other_Qualified_SRM_Employee__c!== undefined)
        {
            var otherlist = component.get('v.OtherUsers');
            for(i=0; i<otherlist.length; i++)
            {
                if(otherlist[i].Id == ITForm.Other_Qualified_SRM_Employee__c)
                {
                    if(repTDSnames == '')
                        repTDSnames = otherlist[i].FirstName + ' ' + otherlist[i].LastName;
                    else
                        repTDSnames += ' & ' + otherlist[i].FirstName + ' ' + otherlist[i].LastName;
                    i = otherlist.length;
                }
            }
        }

        component.set("v.currentSelectedUsers", repTDSnames);
    },  
})