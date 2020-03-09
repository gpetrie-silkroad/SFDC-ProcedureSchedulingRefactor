({
    doInit : function(component, event, helper) {
            var canvas, ctx, flag = false,
            prevX = 0,
            currX = 0,
            prevY = 0,
            currY = 0,
            dot_flag = false;
       
        var x = "black",
            y = 2,
            w,h;
        canvas=component.find('can').getElement();
        var ratio = Math.max(window.devicePixelRatio || 1, 1);
        w = canvas.width*ratio;
        h = canvas.height*ratio;

        ctx = canvas.getContext("2d");
        ctx.fillStyle = "white";
        ctx.fillRect(0, 0, canvas.width, canvas.height);
       
        canvas.addEventListener("mousemove", function (e) {
            findxy('move', e)
        }, false);
        canvas.addEventListener("mousedown", function (e) {
            findxy('down', e)
        }, false);
        canvas.addEventListener("mouseup", function (e) {
            findxy('up', e)
        }, false);
        canvas.addEventListener("mouseout", function (e) {
            findxy('out', e)
        }, false);

        // Set up touch events for mobile, etc
        canvas.addEventListener("touchstart", function (e) {
            var touch = e.touches[0];
            var mouseEvent = new MouseEvent("mousedown", {
                clientX: touch.clientX,
                clientY: touch.clientY
            });
            canvas.dispatchEvent(mouseEvent);
             e.preventDefault();
        }, false);
        canvas.addEventListener("touchend", function (e) {
            var mouseEvent = new MouseEvent("mouseup", {});
            canvas.dispatchEvent(mouseEvent);
        }, false);
        canvas.addEventListener("touchmove", function (e) {
            var touch = e.touches[0];
            var mouseEvent = new MouseEvent("mousemove", {
                clientX: touch.clientX,
                clientY: touch.clientY
            });
            canvas.dispatchEvent(mouseEvent);
             e.preventDefault();
           
        }, false);
       
        // Get the position of a touch relative to the canvas
        function getTouchPos(canvasDom, touchEvent) {
            var rect = canvasDom.getBoundingClientRect();
            return {
                x: touchEvent.touches[0].clientX - rect.left,
                y: touchEvent.touches[0].clientY - rect.top
            };
        }
       
        function findxy(res, e){
            const rect = canvas.getBoundingClientRect();
            if (res == 'down') {
                prevX = currX;
                prevY = currY;
                currX = e.clientX - rect.left ;
                currY = e.clientY -  rect.top;
               
                flag = true;
                dot_flag = true;
                if (dot_flag) {
                    ctx.beginPath();
                    ctx.fillStyle = x;
                    ctx.fillRect(currX, currY, 2, 2);
                    ctx.closePath();
                    dot_flag = false;
                }
            }
            if (res == 'up' || res == "out") {
                flag = false;
            }
            if (res == 'move') {
                if (flag) {
                    prevX = currX;
                    prevY = currY;
                    currX = e.clientX -  rect.left;
                    currY = e.clientY - rect.top;
                    draw(component,ctx);
                }
            }
        }
        function draw() {
            ctx.beginPath();
            ctx.moveTo(prevX, prevY);
            ctx.lineTo(currX, currY);
            ctx.strokeStyle = x;
            ctx.lineWidth = y;
            ctx.stroke();
            ctx.closePath();
        }       
    },
    
    eraseHelper: function(component, event, helper){
        var m = confirm("Do you want to clear the signature?");
        if (m) {
            var canvas=component.find('can').getElement();
            var ctx = canvas.getContext("2d");
            var w = canvas.width;
            var h = canvas.height;
            ctx.fillStyle = "white";
            ctx.fillRect(0, 0, w, h);
       }
    },

    saveHelper:function(component, event, helper, extrastep){
        var pad=component.find('can').getElement();
        var dataUrl = pad.toDataURL();
        var strDataURI=dataUrl.replace(/^data:image\/(png|jpg);base64,/, "");
        var parentID = component.get("v.ITForm.Id");
        var ITFormName = component.get("v.ITForm.Name");
        var errorMessage ="";
        var currentStatus = component.get('v.currentStatus');

        //Check Customer signature
        var blank = document.createElement('canvas');
        blank.width = pad.width;
        blank.height = pad.height;
        var ctx = blank.getContext("2d");
        ctx.fillStyle = "white";
        ctx.fillRect(0, 0, blank.width, blank.height);
        var blankUrl = blank.toDataURL();
        if( blankUrl == dataUrl)
            errorMessage += "\nMissing Customer Signature";

        var recipientNameForm = component.find('recipientNameForm');
        var recipientNameValue = recipientNameForm.get("v.value");
        var recipientTitleForm = component.find('recipientTitleForm');
        var recipientTitleValue = recipientTitleForm.get("v.value");        

        if(recipientNameValue == null || recipientNameValue==''){
            recipientNameForm.set("v.errors", [{message:'Missing Customer Name'}]);
            errorMessage += "\nMissing Customer Name";            
        }else
            recipientNameForm.set("v.errors", null);

        if(errorMessage !=""){
            errorMessage = "Fail to save a customer signature:" + errorMessage;
            alert(errorMessage);
        }else{
            var action = component.get("c.saveSignature");
            var attachName = recipientNameValue + "-"+ ITFormName;
            attachName = attachName.substring(0,69);

            action.setParams({
                "signatureBody": strDataURI,
                "parentId": parentID,
                "name": attachName,
                "recipientNameValue": recipientNameValue,
                "recipientTitleValue": recipientTitleValue
            });

            component.set('v.waitingMessage', "SFDC is saving the customer's signature." );
            component.set('v.WaitingWindow', true);

            action.setCallback(this,function(res){
                var state = res.getState();
                component.set('v.WaitingWindow', false);
                if(state==="SUCCESS"){
                    var attachID = res.getReturnValue();
                    var status = component.get("v.ITForm.Status__c");
                    if(status == "ITF Draft"){
                        component.set("v.ITForm.Status__c", "Transacted Inventory/Verification");
                    }
                    alert("Signature saved successfully.\nThank you for choosing to use our products.\nAn email will be automatically sent to SRM customer success.");
                    component.set("v.ITForm.signAttachID__c",attachID);
                    component.set("v.ITForm.EditableByRepTDS__c", false);

                    var POMessage = '';
                    var PONumber = component.get("v.ITForm.Bill_Only_PO__c");
                    if(PONumber != null & PONumber != undefined & PONumber != '' & PONumber != 'evaluation')
                    {
                        POMessage = "the bill-only PO#: " + PONumber;
                        PONumber += ' (Pending - need a hard copy)';
                        if(PONumber.length < 50)
                            component.set("v.ITForm.Bill_Only_PO__c",PONumber);                        
                    }                

                    if(POMessage != '')
                    {
                        POMessage = 'To close the ITF, please ask the customer an electronic/hard copy of ' + POMessage + ' and send it to CS. Thank you.';
                        alert(POMessage);
                    }

                    var updateITF = component.get("v.updateITFormSignal");
                    if(updateITF)
                        component.set("v.updateITFormSignal", false);
                    else
                        component.set("v.updateITFormSignal", true);

                    if(extrastep == 'close ITForm')
                    {
                        component.set('v.emailType', 4);
                        component.set('v.tempStatus',4);
                    }
                    else if(extrastep == 'sendEmailToSRMCS')
                        this.createRecordAttachPDFfile(component, 4);
                    else if(extrastep == 'sendNotifiedEmailtoCS')
                    {
                        //The notified email is sent by SFDC ITF process
                        // component.set('v.emailType', 5);
                        // component.set('v.tempStatus',4);
                    }
                }
                else{
                    alert("Signature saved unsuccessfully");
                }
            });       
            $A.enqueueAction(action);
        }
    },

    createAttachPDFfile : function(component, type) //type: 0: only create a PDF file; 1: create, save and download
    {
        var ITFID = component.get('v.ITForm.Id');
        var action = component.get('c.createPDFCopy');
        var name = component.get('v.ITForm.Name');
        action.setParams({
          "iTFID": ITFID,
          "name": name,
          "PDFID": ""
        });

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.ITForm.PDFID__c", result);

                //Trigger updateITF form
                var updateITF = component.get("v.updateITFormSignal");
                if(updateITF)
                    component.set("v.updateITFormSignal", false);
                else
                    component.set("v.updateITFormSignal", true);

                if(type == 1)
                {
                    var baseurl = "/servlet/servlet.FileDownload?file=";
                    var download = "&operationContext=S1";
                    window.open(baseurl + result + download);
                }
            }else{
                alert("error on creating PDF copy");
            }
        });
        $A.enqueueAction(action);
    },

    createRecordAttachPDFfile: function(component, emailType) {
        //Check is PDF ready to send
        var PDFID = component.get("v.ITForm.PDFID__c");
        if(PDFID != null & PDFID != "" & emailType ==2){
            var type = component.get('v.emailType', emailType);
            component.set('v.emailType', emailType);
            component.set('v.tempStatus',4);
        }
        else{
            //if not create a PDF
            var ITFID = component.get('v.ITForm.Id');
            var suggestedPDFID = component.get("v.ITForm.PDFIDCurrentITForm__c");
            var name = component.get('v.ITForm.Name');
            if(emailType == 2){
                var action = component.get('c.createPDFCopy');
                name = name + ' - customer copy';
            }else{
                var action = component.get('c.createPDFDetailCopy');
                name = name + ' - detail copy';
            }

            action.setParams({
                "iTFID": ITFID,
                "name": name,
                "pDFID": suggestedPDFID
            });
            //Display waiting message
            component.set('v.waitingMessage', 'SFDC is generating a PDF copy.' );
            component.set('v.WaitingWindow', true);

            action.setCallback(this, function(response){
                var state = response.getState();
                component.set('v.WaitingWindow', false);
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    component.set("v.ITForm.PDFIDCurrentITForm__c", result);

                    if(emailType == 10){//Downloading the PDF file
                        var baseurl = "/servlet/servlet.FileDownload?file=";
                        var download = "&operationContext=S1";
                        // window.open(baseurl + result+ download);
                        download = baseurl+result+download;
                        var navEvent = $A.get("e.force:navigateToURL");
                        navEvent.setParams({
                            "url": download
                        });
                        navEvent.fire();
                        component.set('v.isLoading',false);
                    }else{//Send an email after creating PDF file
                        // Trigger updateITF form
                        // var status = component.get("v.ITForm.Status__c");
                        // if(status == "ITF Draft"){
                        //     component.set("v.ITForm.Status__c", "Transacted Inventory/Verification");
                        // }
                        // component.set("v.ITForm.EditableByRepTDS__c", false);
                        var updateITF = component.get("v.updateITFormSignal");

                        if(updateITF)
                            component.set("v.updateITFormSignal", false);
                        else
                            component.set("v.updateITFormSignal", true);

                        //Attach PDF ready to send
                        var type = component.get('v.emailType', emailType);
                        component.set('v.emailType', emailType);
                        component.set('v.tempStatus',4);
                    }
                }else{
                    alert("Error on creating PDF copy.");
                    component.set('v.isLoading',false);
                    // if(emailType == 10){

                    // }else{
                    //     var type = component.get('v.emailType', emailType);
                    //     component.set('v.emailType', emailType);
                    //     component.set('v.tempStatus',4);
                    // }
                }                
            });
            $A.enqueueAction(action);
        }
    },

    updateUserNames: function(component) {
        
        var listCustomer = component.get("v.Accounts");
        var iTF = component.get("v.ITForm");
        var i = 0;

        if(iTF.SRM_AM__c != null & iTF.SRM_AM__c != '')
        {
            if(iTF.SRM_AM__r != undefined)
                component.set('v.AMName', iTF.SRM_AM__r.FirstName + " " + iTF.SRM_AM__r.LastName);
            else
            {
                var listAM = component.get("v.AMUsers");
                for(i=0; i<listAM.length; i++)
                {
                    if(iTF.SRM_AM__c == listAM[i].Id)
                    {
                        component.set('v.AMName', listAM[i].FirstName + " " + listAM[i].LastName);
                        i = listAM.length;
                    }
                }
            }
        }

        if(iTF.SRM_TDS__c != null & iTF.SRM_TDS__c != '')
        {   
            if(iTF.SRM_TDS__r != undefined)
                component.set('v.TDSName', iTF.SRM_TDS__r.FirstName + " " + iTF.SRM_TDS__r.LastName);
            else
            {
                var listTDS = component.get("v.TDSUsers");
                for(i=0; i<listTDS.length; i++)
                {
                    if(iTF.SRM_TDS__c == listTDS[i].Id)
                    {
                        component.set('v.TDSName', listTDS[i].FirstName + " " + listTDS[i].LastName);
                        i = listTDS.length;
                    }
                }
            }
        }

        if(iTF.Other_Qualified_SRM_Employee__c != null & iTF.Other_Qualified_SRM_Employee__c != '')
        {
            if(iTF.Other_Qualified_SRM_Employee__r != undefined)
            {
                component.set('v.OtherName', iTF.Other_Qualified_SRM_Employee__r.FirstName + " " + iTF.Other_Qualified_SRM_Employee__r.LastName);
            }
            else
            {
                var otherList = component.get("v.OtherUsers");
                for(i=0; i<otherList.length; i++)
                {
                    if(iTF.Other_Qualified_SRM_Employee__c == otherList[i].Id)
                    {
                        component.set('v.OtherName', otherList[i].FirstName + " " + otherList[i].LastName);
                        i = otherList.length;
                    }
                }
            }
        }

        if(iTF.Customer_From__c != null & iTF.Customer_From__c != '')
        {
            if(iTF.Customer_From__r != undefined)
                component.set('v.fromAccountName', iTF.Customer_From__r.IQMS_Customer_Number__c + ' - ' + iTF.Customer_From__r.Name);
            else
            {
                for(i=0; i<listCustomer.length; i++)
                {
                    if(iTF.Customer_From__c == listCustomer[i].Id)
                    {
                        component.set('v.fromAccountName', listCustomer[i].IQMS_Customer_Number__c + ' - ' + listCustomer[i].Name);
                        i = listCustomer.length;
                    }                
                }
            }
        }

        if(iTF.Customer_To__c != null & iTF.Customer_To__c != '')
        {
            if(iTF.Customer_To__r != undefined)
                component.set('v.toAccountName', iTF.Customer_To__r.IQMS_Customer_Number__c + ' - ' + iTF.Customer_To__r.Name);
            else
            {
                for(i=0; i<listCustomer.length; i++)
                {
                    if(iTF.Customer_To__c == listCustomer[i].Id)
                    {
                        component.set('v.toAccountName', listCustomer[i].IQMS_Customer_Number__c + ' - ' + listCustomer[i].Name);
                        i = listCustomer.length;
                    }                
                }
            }
        }        
    },

    deleteITForm: function(component) {
        var action = component.get("c.deleteITForm");
        var ITF = component.get('v.ITForm');

        if(ITF.Id !== null & ITF.Id !== '')
        {
            action.setParams({
              "iTF": ITF
            });

            //Display waiting message
            component.set('v.waitingMessage', 'SFDC is deleting the ITF.' );
            component.set('v.WaitingWindow', true);

            action.setCallback(this, function(response) {
                var state = response.getState();
                component.set('v.WaitingWindow', false);
                if (state === "SUCCESS") {
                    alert('The ITF has been deleted');
                    this.jumptoITFlistview(component);

                }else
                    alert("Error on deleting the ITFID: " + ITF.Id + ". Please Take a screenshot and send it to Customer Success.");
            });
            $A.enqueueAction(action);
        }
    },

    jumptoITFlistview: function(component){
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Inventory_Transfer_Form__c"
        });
        homeEvent.fire();
    },

    closeITForm: function(component){
        var ITForm = component.get("v.ITForm");
        var objectID;
        if(ITForm.ITF_Type__c == 'Transfer to Customer' || ITForm.ITF_Type__c == 'External Transfer (Customer to Customer)')
            objectID = ITForm.Customer_To__c;
        else
            objectID = component.get("v.currentUser.Id");

        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": objectID,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },

    checkCustomerSignature: function(component){
        var itf = component.get('v.ITForm');
        var ITFTransactions = component.get('v.ITFTransactions');
        var displaySign = component.get('v.signInPerson');
        if((itf.signAttachID__c == null || itf.signAttachID__c == '')
            & (itf.CustomerSignViaDocumentID__c == null || itf.CustomerSignViaDocumentID__c == '')
            & displaySign
            & itf.ITF_Type__c !== 'Internal Transfer (AM/TDS to AM/TDS)'
            & ITFTransactions.length != 0)
        {
            var pad=component.find('can').getElement();
            var dataUrl = pad.toDataURL();
            var strDataURI=dataUrl.replace(/^data:image\/(png|jpg);base64,/, "");
            var parentID = component.get("v.ITForm.Id");
            var ITFormName = component.get("v.ITForm.Name");
            var errorMessage ="";
            var currentStatus = component.get('v.currentStatus');

            //Check Customer signature
            var blank = document.createElement('canvas');
            blank.width = pad.width;
            blank.height = pad.height;
            var ctx = blank.getContext("2d");
            ctx.fillStyle = "white";
            ctx.fillRect(0, 0, blank.width, blank.height);
            var blankUrl = blank.toDataURL();
            if( blankUrl == dataUrl)
                return false;
            else
                return true;
        }else
        {
            return false;
        }
    },

    sendEmailtoCS: function(component){
        component.set('v.WaitingWindow', true);
        this.createRecordAttachPDFfile(component, 1);
    },

    UpdateITFormHeader: function(component, ITForm)
    {
        component.set('v.waitingMessage', 'SFDC is updating the ITF on SFDC.' );
        component.set('v.WaitingWindow', true);
        var action = component.get('c.updateITF');
        action.setParams({
            "iTForm": ITForm
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                alert("The ITF has been successfully saved on SFDC. You will be redirect into the ITF record.");
                //refresh the webpage
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": result.Id,
                    "slideDevName": "detail"
                });
                navEvt.fire();
                
            }
            else {
                alert("error on updating ITForm");
            }
            component.set('v.WaitingWindow', false);
        });     
        $A.enqueueAction(action);
    },
})

// console.log("Error to create the new ITF info: " + JSON.stringify(ITForm));