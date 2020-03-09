({
    doInit: function(component, event, helper)
    {
        var TSCCFItem = component.get('v.TSCCItem');
    	var displayMode = component.get('v.displayMode');
    	var itemlist = ['Item #: N/A'];
    	var lotlist = ['Lot #: N/A'];
        var lotStatus = '';

    	if(displayMode == 0)
    	{
            lotlist = helper.updateLotNumber(component, 'SR-200-NPS', lotlist);
    	}else if(displayMode == 1)
    	{
			itemlist.push('SR-1040-CS');
			itemlist.push('SR-1030-CS');
			itemlist.push('SR-0940-CS');
			itemlist.push('SR-0930-CS');
			itemlist.push('SR-0840-CS');
			itemlist.push('SR-0830-CS');
			itemlist.push('SR-0740-CS');
			itemlist.push('SR-0730-CS');
			itemlist.push('SR-0640-CS');
			itemlist.push('SR-0630-CS');
			itemlist.push('SR-0620-CS');
			itemlist.push('SR-0540-CS');

   //          itemlist.push('SR-1040-CS [EA]');
   //          itemlist.push('SR-1030-CS [EA]');
   //          itemlist.push('SR-0940-CS [EA]');
   //          itemlist.push('SR-0930-CS [EA]');
   //          itemlist.push('SR-0840-CS [EA]');
   //          itemlist.push('SR-0830-CS [EA]');
   //          itemlist.push('SR-0740-CS [EA]');
   //          itemlist.push('SR-0730-CS [EA]');
   //          itemlist.push('SR-0640-CS [EA]');
   //          itemlist.push('SR-0630-CS [EA]');
   //          itemlist.push('SR-0620-CS [EA]');
   //          itemlist.push('SR-0540-CS [EA]');
            if(TSCCFItem.Product_No__c !==null & TSCCFItem.Product_No__c !== undefined)
                lotlist = helper.updateLotNumber(component, TSCCFItem.Product_No__c, lotlist);
        }else if(displayMode == 2)
        {
            lotlist = helper.updateLotNumber(component, 'SR-014-GW', lotlist);
            if(TSCCFItem.Counted_Qty__c > 0)
            {
                var QtyEA = TSCCFItem.Counted_Qty__c%5;
                var QtyBx = (TSCCFItem.Counted_Qty__c-QtyEA)/5;
                component.set('v.QtyEA', QtyEA);
                component.set('v.QtyBX', QtyBx);
            }
    	}else if(displayMode == 3)
    	{
			itemlist.push('SR-4F21G7D-MP');
			itemlist.push('SR-4F21G4D-MP');
			itemlist.push('KIT-069-15');
			itemlist.push('KIT-069-05');
            if(TSCCFItem.Product_No__c !==null & TSCCFItem.Product_No__c !== undefined)
                lotlist = helper.updateLotNumber(component, TSCCFItem.Product_No__c, lotlist);
            if(TSCCFItem.Counted_Qty__c > 0)
            {
                var QtyEA = TSCCFItem.Counted_Qty__c%10;
                var QtyBx = (TSCCFItem.Counted_Qty__c-QtyEA)/10;
                component.set('v.QtyEA', QtyEA);
                component.set('v.QtyBX', QtyBx);
            }		
    	}

    	component.set('v.ListLot', lotlist);
    	component.set('v.ListItemNo', itemlist);

		//Refresh display data
        component.set('v.TSCCItem', TSCCFItem);

        if(TSCCFItem.Expiring_Status__c !== null & TSCCFItem.Expiring_Status__c !== undefined)
        {
            if(TSCCFItem.Expiring_Status__c.includes('OK'))
                lotStatus = 'OK';
            else if(TSCCFItem.Expiring_Status__c.includes('Expired'))
                lotStatus = 'Expired';
            else
                lotStatus = 'Expiring';            
        }
        component.set("v.LotStatus", lotStatus);
        component.set("v.WaitingWindow", false);

        var isReady = component.get("v.isChildReady");
        component.set("v.isChildReady", isReady+1);
    },

    closeWaitingPopUp: function(component, event, helper) {
        component.set("v.WaitingWindow", false);
    },

    ChangeLotNo: function(component, event, helper) {
        var TSCCFItem = component.get('v.TSCCItem');

        var lots = component.get('v.lots');
        var i = 0;
        var lotStatus = '';

        //update Expired Date
        for( i=0; i<lots.length; i++)
        {
            if(lots[i].Lot_Number__c == TSCCFItem.Lot_Number__c)
            {
                TSCCFItem.Expired_Date__c = lots[i].Expired_Date__c;
                TSCCFItem.Expiring_Status__c =  lots[i].Expiring_Status__c;
                if(TSCCFItem.Expiring_Status__c.includes('OK'))
                    lotStatus = 'OK';
                else if(TSCCFItem.Expiring_Status__c.includes('Expired'))
                    lotStatus = 'Expired';
                else
                    lotStatus = 'Expiring';
            }
        }

        component.set('v.LotStatus', lotStatus);
        component.set('v.TSCCItem', TSCCFItem);
    },

    ChangeProductNo: function(component, event, helper) {
        var lotlist = ['Lot #: N/A'];
        var TSCCFItem = component.get('v.TSCCItem');

        lotlist = helper.updateLotNumber(component, TSCCFItem.Product_No__c, lotlist);

        component.set('v.ListLot', lotlist);
    },

    ChangeQty: function(component, event, helper) {
        helper.changeQuantity(component);
    },

    increaseQty: function(component, event, helper) {
        var Counted_Qty__c = component.get('v.TSCCItem.Counted_Qty__c');

        component.set('v.TSCCItem.Counted_Qty__c', Counted_Qty__c+1);
    },

    decreaseQty: function(component, event, helper) {
        var Counted_Qty__c = component.get('v.TSCCItem.Counted_Qty__c');

        component.set('v.TSCCItem.Counted_Qty__c', Counted_Qty__c-1);
    },

    increaseQtyEA: function(component, event, helper) {
        var Counted_Qty__c = component.get('v.QtyEA');

        component.set('v.QtyEA', Counted_Qty__c+1);
        helper.changeQuantity(component);
    },

    decreaseQtyEA: function(component, event, helper) {
        var Counted_Qty__c = component.get('v.QtyEA');

        component.set('v.QtyEA', Counted_Qty__c-1);
        helper.changeQuantity(component);
    },

    increaseQtyBX: function(component, event, helper) {
        var Counted_Qty__c = component.get('v.QtyBX');

        component.set('v.QtyBX', Counted_Qty__c+1);
        helper.changeQuantity(component);
    },

    decreaseQtyBX: function(component, event, helper) {
        var Counted_Qty__c = component.get('v.QtyBX');

        component.set('v.QtyBX', Counted_Qty__c-1);
        helper.changeQuantity(component);
    },
})
// console.log("javascript debug: " + JSON.stringify(LookUpTDSValue));