public without sharing class OrderItemDetailTrigger_Helper {
   	
	public static void qad_connectInvoiceId(List<OrderItemDetail__c> oidList) {
		Set<String> invoiceNoSet = new Set<String>();
		Set<Id> orderIdSet = new Set<Id>();
		Set<String> orderLineSet = new Set<String>();
		for(OrderItemDetail__c oid : oidList){
			invoiceNoSet.add(oid.InvoiceNo__c);
			SYSTEM.DEBUG(' T E S T OrderNumLine = [' + oid.OrderNumLine__c + '] Order_Item = [' + oid.Order_Item__c + ']');
			if(oid.OrderNumLine__c != null && oid.Order_Item__c == null){
				orderLineSet.add(oid.OrderNumLine__c);
			}
		}
		
		Map<String, Id> invoiceMap = new Map<String, Id>();
		List<Invoice__c> invoiceList = [SELECT Name, Id FROM Invoice__c WHERE Name IN: invoiceNoSet];
		for(Invoice__c i : invoiceList){
			invoiceMap.put(i.Name, i.Id);
			SYSTEM.DEBUG('Invoice No In = [' + i.Name + '] Id = [' + i.Id + ']');
		}

		Map<String, Id> orderIdToAccountIdMap = new Map<String, Id>();

		Map<String, Id> orderItemMap = new Map<String, Id>();
		Map<String, Id> orderMap = new Map<String, Id>();
		List<OrderItem> oiList = [SELECT Id, OrderNumLine__c, OrderId, Order.AccountId FROM OrderItem WHERE OrderNumLine__c IN : orderLineSet];
		for(OrderItem oi : oiList){
			orderItemMap.put(oi.OrderNumLine__c, oi.Id);
			orderMap.put(oi.OrderNumLine__c, oi.OrderId);
			orderIdToAccountIdMap.put(oi.OrderNumLine__c, oi.Order.AccountId);
		}	

		for(OrderItemDetail__c oid : oidList){
			if(oid.InvoiceNo__c != null && invoiceMap.get(oid.InvoiceNo__c) != null){
				oid.Invoice__c = invoiceMap.get(oid.InvoiceNo__c);
			}
			if(oid.Order_Item__c == null && oid.OrderNumLine__c != null && orderItemMap.get(oid.OrderNumLine__c) != null){
				oid.Order_Item__c = orderItemMap.get(oid.OrderNumLine__c);
			}
			if(oid.Order__c == null && oid.OrderNumLine__c != null && orderMap.get(oid.OrderNumLine__c) != null){
				oid.Order__c = orderMap.get(oid.OrderNumLine__c);
			}
			if(oid.OrderNumLine__c != null && orderIdToAccountIdMap.get(oid.OrderNumLine__c) != null){
				oid.AccountId__c = orderIdToAccountIdMap.get(oid.OrderNumLine__c);
			}
		}
	}




	public static void qad_connectShipment(List<OrderItemDetail__c> oidList) {
		Set<String> shipperStringSet = new Set<String>();
		for(OrderItemDetail__c oid : oidList){
			if(oid.Shipper_Number__c != null){
				shipperStringSet.add(oid.Shipper_Number__c);
			}
		}

		Map<String, Shipment__c> shipperIdMap = new Map<String, Shipment__c>();
		List<Shipment__c> shipList = [SELECT Id, Name, Tracking_Link__c, Tracking_Number__c FROM Shipment__c WHERE Name IN : shipperStringSet];
		for(Shipment__c s : shipList){
			shipperIdMap.put(s.Name, s);
		}

		for(OrderItemDetail__c oid : oidList){
			if(oid.Shipper_Number__c != null && shipperIdMap.get(oid.Shipper_Number__c) != null){
				oid.Shipment__c = shipperIdMap.get(oid.Shipper_Number__c).id;
				oid.Tracking_Link__c = shipperIdMap.get(oid.Shipper_Number__c).Tracking_Link__c;
				oid.Name = oid.OrderNumLine__c + '-[' + oid.QAD_abs_item__c + ']-' + shipperIdMap.get(oid.Shipper_Number__c).Tracking_Number__c;
			}
			else{
				oid.Name = oid.OrderNumLine__c + '-[' + oid.QAD_abs_item__c + ']';
			}
		}

    }






 
	public static void qad_updateOrderItem(List<OrderItemDetail__c> oidList){
		// GET RELATED ORDER ITEMS FROM THE OIDLIST
		Set<Id> orderItemIdSet = new Set<Id>();
		Map<Id, Decimal> orderItemIdToSumQtyShipped = new Map<Id, Decimal>();
		Map<Id, Decimal> orderItemIdToSumQtyToShip = new Map<Id, Decimal>();
		Map<Id, Date> orderItemIdToShipDate = new Map<Id, Date>();
		for(OrderItemDetail__c oid : oidList){
			if(orderItemIdSet.contains(oid.Order_Item__c)){
				Decimal qtyShipped = orderItemIdToSumQtyShipped.get(oid.Order_Item__c) + oid.Qty_Shipped__c;
				Decimal qtyToShip = orderItemIdToSumQtyToShip.get(oid.Order_Item__c) + oid.Qty_to_Ship__c;
				orderItemIdToSumQtyShipped.put(oid.Order_Item__c, qtyShipped);
				orderItemIdToSumQtyToShip.put(oid.Order_Item__c, qtyToShip);
				orderItemIdToShipDate.put(oid.Order_Item__c, oid.Ship_Date__c);
			}
			else{
				orderItemIdToSumQtyShipped.put(oid.Order_Item__c, oid.Qty_Shipped__c);
				orderItemIdToSumQtyToShip.put(oid.Order_Item__c, oid.Qty_to_Ship__c);
				orderItemIdToShipDate.put(oid.Order_Item__c, oid.Ship_Date__c);
			}
			orderItemIdSet.add(oid.Order_Item__c);
		}

		List<OrderItem> oiList = [SELECT Id, Ship_Date__c, OrderNumLine__c, OrderId, Shipped_Quantity__c, Line_Item_Complete__c FROM OrderItem WHERE ID IN: orderItemIdSet];

		Map<Id, OrderItem> oiMap = new Map<Id, OrderItem>();
		for(OrderItem oi : oiList){
			oiMap.put(oi.Id, oi);
		}

		// NOW LOOP THROUGH OIDLIST AND PROVIDE UPDATES TO ORDERITEM
		List<OrderItem> oiListToUpdate = new List<OrderItem>();
		for(OrderItem oi : oiList){
			Decimal qtyShipped = orderItemIdToSumQtyShipped.get(oi.Id);
			Decimal qtyToShip = orderItemIdToSumQtyToShip.get(oi.Id);
			Date shipDate = orderItemIdToShipDate.get(oi.Id);
			if(oi.OrderNumLine__c.left(1) != 'R'){
				oi.Ship_Date__c = orderItemIdToShipDate.get(oi.Id);
			}
			if(qtyShipped == qtyToShip){
				oi.Line_Item_Complete__c = true;
			}
		}
		update oiList;
	}
}