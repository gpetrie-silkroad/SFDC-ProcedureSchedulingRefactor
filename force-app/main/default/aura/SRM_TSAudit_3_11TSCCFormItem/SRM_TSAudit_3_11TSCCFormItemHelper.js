({
	updateLotNumber : function(component, itemNo, lotlist) {
		var lots = component.get('v.lots');
		var i = 0;

		for( i=0; i<lots.length; i++)
		{
// console.log("javascript debug 123: " + JSON.stringify(lots[i].Item_No__c));
// console.log("javascript debug 321: " + JSON.stringify(itemNo));

			if(lots[i].Item_No__c == itemNo)
			{
				lotlist.push(lots[i].Lot_Number__c);
			}
		}

		return lotlist;
	},

	changeQuantity: function(component)
	{
        var displayMode = component.get('v.displayMode');
        var QtyEA = component.get('v.QtyEA');
        var QtyBX = component.get('v.QtyBX');
        var totalQty = 0;

        if(displayMode == 2)
        {
            totalQty = QtyEA + QtyBX * 5;
        }else
        {
            totalQty = QtyEA + QtyBX * 10;
        }

        component.set('v.TSCCItem.Counted_Qty__c', totalQty);
    },
})
// console.log("javascript debug: " + JSON.stringify(totalQty));