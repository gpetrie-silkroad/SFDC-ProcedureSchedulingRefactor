({
    init: function(component, event, helper) {
        component.set("v.WaitingWindow", true);
        var listOfStep = ['NPS','Stent','GW','MPK/KIT','Review'];
        component.set('v.steps', listOfStep);
        helper.getLotInfo(component);
        helper.gettingLotInventory(component);

        //check user's device type - to customize display on screen
        var device = $A.get("$Browser.formFactor");
        component.set('v.devicetype', device);

        var cmpTarget = component.find('backgroundform');
        if(device == 'PHONE' || device == 'TABLET')
        {
            $A.util.removeClass(cmpTarget, 'DesktopBackground');
        }else
        {
            $A.util.removeClass(cmpTarget, 'PhoneBackground');
        }
    },

    ContInit: function(component, event, helper)
    {
        var isReady = component.get('v.isReady');

        if(isReady == 2)
        {
            var lotinventory = component.get("v.lotinventory");
            var TSCCReport = component.get("v.TSCCReport");
            var i = 0;
            var tempNPSItems = [];
            var tempGWItems = [];
            var tempStentItems = [];
            var tempMPKItems = [];

            for(i=0; i < lotinventory.length; i++)
            {
                if(lotinventory[i].Item_Number__c != undefined)
                {
                    if(lotinventory[i].Item_Number__c.includes('SR-200-NPS'))
                    {
                        tempNPSItems.push({
                            'sobjectType':'Trunk_Stock_Cycle_Count_Item__c',
                            'Expired_Date__c': lotinventory[i].Lot_Expiration_Date__c,
                            'Expiring_Status__c': lotinventory[i].Expiring_Status__c,
                            'Lot_Number__c': lotinventory[i].Lot_Number__c,
                            'Product_No__c': lotinventory[i].Item_Number__c,
                            'Qty_on_system__c': lotinventory[i].On_Hand_Qty__c,
                            'Counted_Qty__c': 0,
                            'Trunk_Stock_report__c': TSCCReport.Id,
                            'Confirmed__c': true,
                            'Unit__c': 'EA'
                        });             
                    }else if(lotinventory[i].Item_Number__c.includes('-CS'))
                    {
                        tempStentItems.push({
                            'sobjectType':'Trunk_Stock_Cycle_Count_Item__c',
                            'Expired_Date__c': lotinventory[i].Lot_Expiration_Date__c,
                            'Expiring_Status__c': lotinventory[i].Expiring_Status__c,
                            'Lot_Number__c': lotinventory[i].Lot_Number__c,
                            'Product_No__c': lotinventory[i].Item_Number__c,
                            'Qty_on_system__c': lotinventory[i].On_Hand_Qty__c,
                            'Counted_Qty__c': 0,
                            'Trunk_Stock_report__c': TSCCReport.Id,
                            'Confirmed__c': true,
                            'Unit__c': 'EA'
                        });             
                    }else if(lotinventory[i].Item_Number__c.includes('-MP'))
                    {
                        tempMPKItems.push({
                            'sobjectType':'Trunk_Stock_Cycle_Count_Item__c',
                            'Expired_Date__c': lotinventory[i].Lot_Expiration_Date__c,
                            'Expiring_Status__c': lotinventory[i].Expiring_Status__c,
                            'Lot_Number__c': lotinventory[i].Lot_Number__c,
                            'Product_No__c': lotinventory[i].Item_Number__c,
                            'Qty_on_system__c': lotinventory[i].On_Hand_Qty__c,
                            'Counted_Qty__c': 0,
                            'Trunk_Stock_report__c': TSCCReport.Id,
                            'Confirmed__c': true,
                            'Unit__c': 'EA'
                        });             
                    }else
                    {
                        tempGWItems.push({
                            'sobjectType':'Trunk_Stock_Cycle_Count_Item__c',
                            'Expired_Date__c': lotinventory[i].Lot_Expiration_Date__c,
                            'Expiring_Status__c': lotinventory[i].Expiring_Status__c,
                            'Lot_Number__c': lotinventory[i].Lot_Number__c,
                            'Product_No__c': lotinventory[i].Item_Number__c,
                            'Qty_on_system__c': lotinventory[i].On_Hand_Qty__c,
                            'Counted_Qty__c': 0,
                            'Trunk_Stock_report__c': TSCCReport.Id,
                            'Confirmed__c': true,
                            'Unit__c': 'EA'
                        });             
                    }
                }
            }


            component.set('v.tempNPSItems',tempNPSItems);
            component.set('v.tempStentItems',tempStentItems);
            component.set('v.tempMPKItems',tempMPKItems);
            component.set('v.tempGWItems',tempGWItems);
            component.set("v.WaitingWindow", false);
        }
    },

    AddNPSUnit: function(component, event, helper) {
        var tempNPSItems = component.get("v.tempNPSItems");
        var TSCCReport = component.get("v.TSCCReport");

        tempNPSItems.push({
            'sobjectType':'Trunk_Stock_Cycle_Count_Item__c',
            'Product_No__c': 'SR-200-NPS',
            'Counted_Qty__c': 0,
            'Qty_on_system__c':0,
            'Lot_Number__c': '===N/A===',
            'Trunk_Stock_report__c': TSCCReport.Id,
            'Confirmed__c': false,
            'Unit__c': 'EA'
        });  
        component.set('v.tempNPSItems',tempNPSItems);
    },

    AddStentUnit: function(component, event, helper) {
        var tempStentItems = component.get("v.tempStentItems");
        var TSCCReport = component.get("v.TSCCReport");

        tempStentItems.push({
            'sobjectType':'Trunk_Stock_Cycle_Count_Item__c',
            'Product_No__c': '===N/A===',
            'Counted_Qty__c': 0,
            'Qty_on_system__c':0,
            'Lot_Number__c': '===N/A===',
            'Trunk_Stock_report__c': TSCCReport.Id,
            'Confirmed__c': false,
            'Unit__c': 'EA'
        });  
        component.set('v.tempStentItems',tempStentItems);
    },

    AddGWUnit: function(component, event, helper) {
        var tempGWItems = component.get("v.tempGWItems");
        var TSCCReport = component.get("v.TSCCReport");

        tempGWItems.push({
            'sobjectType':'Trunk_Stock_Cycle_Count_Item__c',
            'Product_No__c': 'SR-014-GW',
            'Counted_Qty__c': 0,
            'Qty_on_system__c':0,
            'Lot_Number__c': '===N/A===',
            'Trunk_Stock_report__c': TSCCReport.Id,
            'Confirmed__c': false,
        });  
        component.set('v.tempGWItems',tempGWItems);
    },    

    AddMPKUnit: function(component, event, helper) {
        var tempMPKItems = component.get("v.tempMPKItems");
        var TSCCReport = component.get("v.TSCCReport");

        tempMPKItems.push({
            'sobjectType':'Trunk_Stock_Cycle_Count_Item__c',
            'Product_No__c': '===N/A===',
            'Counted_Qty__c': 0,
            'Qty_on_system__c':0,
            'Lot_Number__c': '===N/A===',
            'Trunk_Stock_report__c': TSCCReport.Id,
            'Confirmed__c': false,
        });  
        component.set('v.tempMPKItems',tempMPKItems);
    },    

    closeWaitingPopUp: function(component, event, helper) {
        component.set("v.WaitingWindow", false);
    },

    updateSteps: function(component, event, helper) {
        component.set("v.waitingMessage","Please Wait. SRM-SFDC are updating lot and product info.")
        component.set("v.WaitingWindow", true);

        var devicetype = component.get('v.devicetype');
        if(devicetype !== 'PHONE')
        {
            var step = event.getSource().get('v.value');
            if(step == 4)
            {
                helper.recalculateSummary(component);
            }
            component.set('v.currentStep', step);            
        }else
        {
            var currentStepString = component.get("v.currentStepString");

            if(currentStepString == "NPS")
            {
                component.set('v.currentStep', 0);
            } 
            else if(currentStepString == "Stent")
            {
                component.set('v.currentStep', 1);
            }
            else if(currentStepString == "MPK/KIT")
            {
                component.set('v.currentStep', 3); 
            }
            else if(currentStepString == "GW")
            {
                component.set('v.currentStep', 2);
            }
            else
            {
                component.set('v.currentStep', 4);
                helper.recalculateSummary(component);
            }                
        }
        component.set("v.WaitingWindow", false);
    },

    previousSteps: function(component, event, helper)
    {
        component.set("v.waitingMessage","Please Wait. SRM-SFDC are updating lot and product info.")
        component.set("v.WaitingWindow", true);

        var currentStep = component.get('v.currentStep');
        if(currentStep  !== 0)
        {
            currentStep--;
            component.set('v.currentStep', currentStep);
            if(currentStep == 3)
            {
                component.set('v.currentStepString','MPK/KIT'); 
            }else if(currentStep == 2)
            {
                component.set('v.currentStepString','GW'); 
            }else if(currentStep == 1)
            {
                component.set('v.currentStepString','Stent'); 
            }else if(currentStep == 0)
            {
                component.set('v.currentStepString','NPS'); 
            }
        }
        component.set("v.WaitingWindow", false);
    },


    nextSteps: function(component, event, helper)
    {        
        component.set("v.waitingMessage","Please Wait. SRM-SFDC are updating lot and product info.")
        component.set("v.WaitingWindow", true);
        var currentStep = component.get('v.currentStep');
        if(currentStep  !== 4)
        {
            currentStep++;
            component.set('v.currentStep', currentStep);
            if(currentStep == 4)
            {
                helper.recalculateSummary(component);
                component.set('v.currentStepString','Review');
            }else if(currentStep == 3)
            {
                component.set('v.currentStepString','MPK/KIT');
            }else if(currentStep == 2)
            {
                component.set('v.currentStepString','GW'); 
            }else
            {
                component.set('v.currentStepString','Stent');
            }
        }
        component.set("v.WaitingWindow", false);
    },

    //remove multiple touch from user when TSCC moves between 2 step
    updateChildChange: function(component, event, helper)
    {
        var WaitingWindow = component.get("v.WaitingWindow");
        if(WaitingWindow)
        {
            //Count when move to next step
            var timer = component.get('v.timer');
            clearTimeout(timer);

            var timer = setTimeout(function(){
                helper.checkChildReady(component);
                clearTimeout(timer);
                component.set('v.timer', null);
            }, 500);

            component.set('v.timer', timer);
        }else
            //reset count when user add a new transaction
            component.set("v.isChildReady",0);

    },

    SubmitTSCC: function(component, event, helper)
    {
        component.set("v.waitingMessage","Please don't close the page.\n It will be take a while to send the report into SFDC server.")
        component.set("v.WaitingWindow", true);
        helper.createandsendTSCCReporttoserver(component);
        
    }
})
// console.log("javascript debug: " + JSON.stringify(LookUpTDSValue));