public without sharing class ShipmentTrigger_Helper {
	
	public static void parseShipmentInfo(List<Shipment__c> inputShipmentList){
		
		Map<String, String> shipToInvoiceNoMap = new Map<String, String>();

		for(Shipment__c s : inputShipmentList){
			String inputString = s.QAD_abs_qad01__c.normalizeSpace();
			inputString = inputString.replace(' ',':');
			String[] stringList = inputString.split(':', 4);

			Integer len = stringList.size();

			SYSTEM.DEBUG('* * * * * * * * * * * * * * * * * * * *');
			SYSTEM.DEBUG('* * * * * * * * * * * * * * * * * * * *');
			SYSTEM.DEBUG('List Length = [' + len + ']');
			SYSTEM.DEBUG('Input String = [' + inputString + ']');
			SYSTEM.DEBUG('* * * * * * * * * * * * * * * * * * * *');

			if(len > 0){
				SYSTEM.DEBUG('String 1 = [' + stringList[0] + ']');
				s.Ship_Method__c = stringList[0];
				s.Carrier__c = stringList[0].left(3);
			}
			if(len > 1){
				SYSTEM.DEBUG('String 2 = [' + stringList[1] + ']');
				s.FOB__c = stringList[1];
			}
			if(len > 2){	
				SYSTEM.DEBUG('String 3 = [' + stringList[2] + ']');
			}	
            if(len > 3){
				SYSTEM.DEBUG('String 4 = [' + stringList[3] + ']');
				s.Tracking_Number__c = stringList[3];
				if(s.Carrier__c == 'FDX'){
					s.Tracking_Link__c = 'https://www.fedex.com/apps/fedextrack/?action=track&trackingnumber=' + stringList[3] + '&cntry_code=us&locale=en_US'; 
				}
				else if(s.Carrier__c == 'UPS'){
					s.Tracking_Link__c = 'https://www.ups.com/track?loc=en_US&tracknum=' + stringList[3] + '&requester=WT/trackdetails';
				}
            }

            if(s.QAD_abs_inv_nbr__c != null){
            	String modInvNumber = s.QAD_abs_inv_nbr__c.replace('/','');
            	SYSTEM.DEBUG('Invoice Number = [' + modInvNumber + ']');
            	shipToInvoiceNoMap.put(s.Name, modInvNumber);
            }
		}

		//Now get Invoice Id's and build a map
		Map<String, Invoice__c> invoiceMap = new Map<String, Invoice__c>();
		List<Invoice__c> invList = [SELECT Id, Invoice_Number__c, Account__c FROM Invoice__c WHERE Invoice_Number__c IN :shipToInvoiceNoMap.values()];
		for(Invoice__c i : invList){
			invoiceMap.put(i.Invoice_Number__c, i);
		}

		for(Shipment__c s : inputShipmentList){
			string modInvNumber;
			if(s.QAD_abs_inv_nbr__c != null){
				modInvNumber = s.QAD_abs_inv_nbr__c.replace('/','');
			}
			if(modInvNumber != null && invoiceMap.get(modInvNumber) != null){
				s.Invoice__c = invoiceMap.get(modInvNumber).Id;
				s.Account__c = invoiceMap.get(modInvNumber).Account__c;
			}
		}

	}





	public static void updateOrderItemDetail(List<Shipment__c> inputShipmentList){
		//NOTE THAT THIS METHOD IS NEEDED SO THAT THE SHIPMENT LINKS ARE UPDATED
		Set<Id> shipmentIdSet = new Set<Id>();
		for(Shipment__c s : inputShipmentList){
			shipmentIdSet.add(s.Id);
		}

		List<OrderItemDetail__c> oidList = [SELECT ID, Tracking_Number__c, Tracking_Link__c, Shipment__c FROM OrderItemDetail__c WHERE Shipment__c IN : shipmentIdSet];

		update oidList;
		
	}
}