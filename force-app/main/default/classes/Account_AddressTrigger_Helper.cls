public with sharing class Account_AddressTrigger_Helper {
	




	public static void qad_populateAccountRecordAddress(List<Account_Address__c> accountAddressList){
		Set<Id> accountIdSet = new Set<Id>();
		Map<String, String> busRelMap = new Map<String, String>();
		for(Account_Address__c a : accountAddressList){
			if(a.QAD_sourced__c){
				accountIdSet.add(a.Account__c);
				SYSTEM.DEBUG('BUS RELATION = [' + a.QAD_ad_bus_relation__c + '] Addr = [' + a.QAD_ad_addr__c + ']');
				busRelMap.put(a.QAD_ad_bus_relation__c, a.QAD_ad_addr__c);
			}
		}

		Map<Id, Account_Address__c> billToAddressMap = new Map<Id,Account_Address__c>();
		Map<Id, Account_Address__c> shipToAddressMap = new Map<Id,Account_Address__c>();

		for(Account_Address__c aa : accountAddressList){
			if(aa.Address_Type__c == 'Bill-To'){
				billToAddressMap.put(aa.Account__c, aa);
			}
			else if(aa.Address_Type__c == 'Ship-To'){
				shipToAddressMap.put(aa.Account__c, aa);
			}
		}

		List<Account> accountList = [SELECT Id, AccountNumber, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,
												ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, QAD_cm_addr__c,
												QAD_Sourced__c
									FROM 	Account WHERE Id IN : accountIdSet];

		SYSTEM.DEBUG('ACCOUNT LIST SIZE = ' + accountList.size());							

		for(Account a : accountList){
			if(a.QAD_Sourced__c){
				Account_Address__c bill_to = new Account_Address__c();
				Account_Address__c ship_to = new Account_Address__c();
				if(billToAddressMap.get(a.Id) != null){
					bill_to = billToAddressMap.get(a.Id);					
					a.BillingStreet = bill_to.Street_Address__c;
					a.BillingCity = bill_to.City__c;
					a.BillingState = bill_to.State_Province__c;
					a.BillingPostalCode = bill_to.Postal_Code__c;
					a.BillingCountry = bill_to.Country__c;
				}
				if(shipToAddressMap.get(a.Id) != null){
					ship_to = shipToAddressMap.get(a.Id);
					a.ShippingStreet = ship_to.Street_Address__c;
					a.ShippingCity = ship_to.City__c;
					a.ShippingState = ship_to.State_Province__c;
					a.ShippingPostalCode = ship_to.Postal_Code__c;
					a.ShippingCountry = ship_to.Country__c;
				}
				else if(billToAddressMap.get(a.Id) != null){
					a.ShippingStreet = bill_to.Street_Address__c;
					a.ShippingCity = bill_to.City__c;
					a.ShippingState = bill_to.State_Province__c;
					a.ShippingPostalCode = bill_to.Postal_Code__c;
					a.ShippingCountry = bill_to.Country__c;
				}

				SYSTEM.DEBUG('BUS REL GET = [' + a.QAD_cm_addr__c + '] Ret Val = [' + busRelMap.get(a.QAD_cm_addr__c ) + ']');
				if(busRelMap.get(a.QAD_cm_addr__c ) != null){
					a.QAD_cm_ship__c = busRelMap.get(a.QAD_cm_addr__c );
				}
			}
		}
		GlobalTriggerSwitch.runAccountTrigger = false;
		update accountList;
		GlobalTriggerSwitch.runAccountTrigger = true;
	}
}