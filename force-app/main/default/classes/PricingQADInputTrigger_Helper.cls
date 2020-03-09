public with sharing class PricingQADInputTrigger_Helper {
	 






	public static void createPartIfNecessary(List<PricingQADInput__c> inputPricingQadList){
		Set<String> itemSet = new Set<String>();
		Map<String, PricingQadInput__c> pqiMap = new Map<String, PricingQadInput__c>();

		for(PricingQADInput__c pqi : inputPricingQadList){
			if(pqi.ItemNumber__c != null){
				String itemUom = pqi.ItemNumber__c + ' [' + pqi.UOM__c.toUpperCase() + ']';
				itemSet.add(itemUom);
				pqiMap.put(itemUom, pqi);
			}
		}
		

		//Collect Existing Parts Where they Exist
		Map<String, Id> partMap = new Map<String, Id>();
		List<Product2> p2List = [SELECT Id, QAD_pt_part__c FROM Product2 WHERE QAD_pt_part__c IN : itemSet AND isActive = true];
		for(Product2 p2 : p2List){
			partMap.put(p2.QAD_pt_part__c, p2.Id);
		}


		List<Product2> p2InsertList = new List<Product2>();
		for(String s : itemSet){
			if(partMap.get(s) == null && pqiMap.get(s) != null){
                PricingQADInput__c pqi = pqiMap.get(s);
				// Create New Part
				Product2 newP2 = new Product2(Description = s, Family = null, IsActive = true, Name = s, ProductCode = pqi.ItemNumber__c, QAD_pt_part__c = s);
				p2InsertList.add(newP2);
			}
		}
		insert p2InsertList;
		// NOTE WHEN A PART IS INSERTED A STANDARD PRICEBOOK ENTRY IS AUTOMATICALLY MADE
	}






	public static void createPricebookIfNecessary(List<PricingQADInput__c> inputPricingQadList){

		Set<String> cmAddrSet = new Set<String>();

		for(PricingQADInput__c pqi : inputPricingQadList){
			if(pqi.CustomerNumber__c != null){
				cmAddrSet.add(pqi.CustomerNumber__c);
			}
		}

		//QUERY WHERE PRICEBOOKS EXIST
		Map<String, Id> pb2Map = new Map<String, Id>();
		List<Pricebook2> pb2List = [SELECT Id, QAD_pi_cs_code__c FROM Pricebook2 WHERE QAD_pi_cs_code__c IN : cmAddrSet AND isActive = true];
		for(Pricebook2 pb2 : pb2List){
			pb2Map.put(pb2.QAD_pi_cs_code__c, pb2.Id);
		}

		//QUERY ACCOUNT FOR NAME
		Map<String, String> acctMap = new Map<String, String>();
		List<Account> accountList = [SELECT Id, Name, QAD_cm_addr__c FROM Account WHERE QAD_cm_addr__c IN : cmAddrSet];
		for(Account a : accountList){
			acctMap.put(a.QAD_cm_addr__c, a.Name + ' - [' + a.QAD_cm_addr__c + ']');
		} 

		List<Pricebook2> pb2InsertList = new List<Pricebook2>();

		for(PricingQADInput__c pqi : inputPricingQadList){
			if(pqi.CustomerNumber__c != null && pb2Map.get(pqi.CustomerNumber__c) == null && acctMap.get(pqi.CustomerNumber__c) != null){
				
				Pricebook2 newPb2 = new Pricebook2(IsActive = true, Name = acctMap.get(pqi.CustomerNumber__c), QAD_pi_cs_code__c = pqi.CustomerNumber__c,	QAD_sourced__c = true);
				
				// NOTE PRICEBOOK2 NAME IS SET BY PRICEBOOK2 TRIGGER
				
				pb2InsertList.add(newPb2);
			}
		}
		insert pb2InsertList;
	}




	public static void updatePricebookId(List<PricingQADInput__c> inputPricingQadList){
		Set<String> cmAddrSet = new Set<String>();

		for(PricingQADInput__c pqi : inputPricingQadList){
			if(pqi.CustomerNumber__c != null){
				cmAddrSet.add(pqi.CustomerNumber__c);
			}
		}

		Map<String, Id> pbMap = new Map<String, Id>();
		List<Pricebook2> pb2List = [SELECT ID, QAD_pi_cs_code__c FROM Pricebook2 WHERE QAD_pi_cs_code__c IN : cmAddrSet AND isActive = true];
		for(Pricebook2 pb2 : pb2List){
			pbMap.put(pb2.QAD_pi_cs_code__c, pb2.id);
		}

		for(PricingQADInput__c pqi : inputPricingQadList){
			if(pqi.CustomerNumber__c != null && pbMap.get(pqi.CustomerNumber__c) != null){
				pqi.Pricebook2__c = pbMap.get(pqi.CustomerNumber__c);
			}
		}	

	}





	public static void createUpdatePricebookEntry(List<PricingQADInput__c> inputPricingQadList){
		//By the time this method is called. Any missing Pricebook should have been created, any part should have been created, and parts, Standard Pricebook Entries and AccountId and ProductId is updated on the PricingQADInput__c

		Date currentday = SYSTEM.TODAY();

		if(Test.isRunningTest()){
			currentDay = Date.newInstance(2018,1,31);
		}

		Set<String> pb_partKeyStringSet = new Set<String>();
		Set<Id> pricebookIdSet = new Set<Id>();
		for(PricingQADInput__c pqi : inputPricingQadList){
			if(pqi.PriceBook2__c != null && pqi.Product__c != null){
				String pb_partKeyString = pqi.PriceBook2__c + '-' + pqi.Product__c;
				pb_partKeyStringSet.add(pb_partKeyString);
				pricebookIdSet.add(pqi.Pricebook2__c);
			}
		}

		//GET RELEVANT PRICEBOOKS
		Set<String> keyStringSet = new Set<String>();
		Map<String, PricebookEntry> pbeMap = new Map<String, PricebookEntry>();
		List<PricebookEntry> pbeList = [SELECT Id, Pricebook2Id, Product2Id, IsActive, csCode_Product_Key__c, Expire_Date__c, UnitPrice, Start_Date__c, UseStandardPrice, Product2.QAD_pt_part__c, Product2.ProductCode FROM PricebookEntry WHERE Pricebook2Id IN : pricebookIdSet AND isActive = true];
		for(PricebookEntry pbe : pbeList){
			String keyString = pbe.Pricebook2Id + '-' + pbe.Product2Id;
			pbeMap.put(keyString, pbe);
			keyStringSet.add(keyString);
			SYSTEM.DEBUG('KEYSTRING ADD = [' + keyString + ']');
		}

		//SEPARATE PricingQADInput__c RECORDS INTO THOSE THAT UPDATE PRICEBOOKENTRIES VS THOSE TO CREATE PRICEBOOK ENTRYIES
		List<PricingQADInput__c> pqiForInsert = new List<PricingQADInput__c>();
		List<PricingQADInput__c> pqiForUpdate = new List<PricingQADInput__c>();
		Set<Id> newProductIdSet = new Set<Id>();

		for(PricingQADInput__c pqi : inputPricingQadList){
			if(pqi.PriceBook2__c != null && pqi.Product__c != null){
				String pb_partKeyString = pqi.PriceBook2__c + '-' + pqi.Product__c;
				if(pbeMap.get(pb_partKeyString) != null && keyStringSet.contains(pb_partKeyString)){
					pqiForUpdate.add(pqi);
				}
				else if(!keyStringSet.contains(pb_partKeystring)){
					pqiForInsert.add(pqi);
					newProductIdSet.add(pqi.Product__c);
				}
			}	
		}

		List<PricebookEntry> pbeInsertList = new List<PricebookEntry>();
		List<PricebookEntry> pbeUpdateList = new List<PricebookEntry>();


		//Update Pricebook Entries from Update List
		for(PricingQADInput__c pqi : pqiForUpdate){
			String itemUom = pqi.ItemNumber__c + ' [' + pqi.UOM__c.toUpperCase() + ']';
			String pb_partKeyString = pqi.PriceBook2__c + '-' + pqi.Product__c;
			PricebookEntry pbe = pbeMap.get(pb_partKeyString );

			pbe.IsActive = true;

			if(pqi.Expired_Date__c != null && pqi.Expired_Date__c < currentday){
				pbe.isActive = false;
			}
			else if(pqi.Start_Date__c != null && pqi.Start_Date__c > currentday){
				pbe.isActive = false;
			}
			pbe.csCode_Product_Key__c = pqi.CustomerNumber__c + '-' + itemUom;
			pbe.Expire_Date__c = pqi.Expired_Date__c;
			pbe.UnitPrice = pqi.Price_Amount__c;
			pbe.Start_Date__c = pqi.Start_Date__c;
			pbe.UseStandardPrice = false;

			pbeUpdateList.add(pbe);
		}

		update pbeUpdateList;
		
		//Insert Pricebook Entries from Update List
		for(PricingQADInput__c pqi : pqiForInsert){
			String itemUom = pqi.ItemNumber__c + ' [' + pqi.UOM__c.toUpperCase() + ']';
			PricebookEntry pbe = new PricebookEntry();
			
			pbe.Pricebook2Id = pqi.PriceBook2__c;
			pbe.Product2Id = pqi.Product__c;
			
			pbe.IsActive = true;

			if(pqi.Expired_Date__c != null && pqi.Expired_Date__c < currentday){
				pbe.isActive = false;
			}
			else if(pqi.Start_Date__c != null && pqi.Start_Date__c > currentday){
				pbe.isActive = false;
			}
			pbe.csCode_Product_Key__c = pqi.CustomerNumber__c + '-' + itemUom;
			
			pbe.Expire_Date__c = pqi.Expired_Date__c;
			pbe.UnitPrice = pqi.Price_Amount__c;
			pbe.Start_Date__c = pqi.Start_Date__c;
			pbe.UseStandardPrice = false;
			
			pbeInsertList.add(pbe);
		}

		// Query Standard Pricebook to See if new products are in the Standard Pricebook
		//newProductIdSet.add(pqi.Product__c);
		Id stdPricebookId;
		if(Test.isRunningTest()){
			stdPricebookId = Test.getStandardPricebookId();
		}
		else{
			stdPricebookId = [SELECT Id FROM Pricebook2 WHERE Name = 'Standard Price Book' LIMIT 1].Id;
		}

		Set<Id> stdProductIdSet = new Set<Id>();
		List<PricebookEntry> stdPricebookEntry = [SELECT Id, Product2Id FROM PriceBookEntry WHERE Pricebook2Id = : stdPricebookId  AND isActive = true];
		for(PricebookEntry pbe : stdPricebookEntry){
			stdProductIdSet.add(pbe.Product2Id);
		}

		List<PricebookEntry> newStdPricebookEntryList = new List<PricebookEntry>();
		for(PricebookEntry pbe : pbeInsertList){
			if(!stdProductIdSet.contains(pbe.Product2Id) && pbe.Product2Id != null){
				PricebookEntry newStdPbe = new PricebookEntry();
				  	newStdPbe.Pricebook2Id = stdPricebookId;
    				newStdPbe.Product2Id = pbe.Product2Id;
				    newStdPbe.UnitPrice = 1;
				    newStdPbe.UseStandardPrice = false;
				    newStdPbe.isActive = true;
				//PricebookEntry newStdPbe = new PricebookEntry(Pricebook2Id = stdPricebookId, Product2Id = pbe.Product2Id, UnitPrice = 1, UseStandardPrice = true, IsActive = true);
				newStdPricebookEntryList.add(newStdPbe);
			}
		}
		insert newStdPricebookEntryList;

		//check for duplicates on the insert list
		List<PricebookEntry> pbeInsertList2 = new List<PricebookEntry>();
		
		Set<Id> pbIdSet = new Set<Id>();
		for(PricebookEntry pbe : pbeInsertList){
			pbIdSet.add(pbe.Pricebook2Id);
		}
		List<PriceBookEntry> pbeExistList = [SELECT Id, Pricebook2Id, Product2Id FROM PriceBookEntry WHERE Pricebook2Id IN : pbIdSet];
		Set<String> ksIdSet = new Set<String>();
		for(PricebookEntry pbeI : pbeExistList){
			String keyString = pbeI.Pricebook2Id + '-' + pbeI.Product2Id;
			ksIdSet.add(keyString);
		}
		for(PricebookEntry pbe2 : pbeInsertList){
			String keyString = pbe2.Pricebook2Id + '-' + pbe2.Product2Id;
			if(ksIdSet.contains(keyString)){

			}
			else{
				pbeInsertList2.add(pbe2);
				ksIdSet.add(keyString);
			}
		}


		insert pbeInsertList2;

	}





	public static void pricingQADInputSetAccountAndProduct(List<PricingQADInput__c> inputPricingQadList){

		Set<String> itemSet = new Set<String>();
		Set<String> cmAddrSet = new Set<String>();

		for(PricingQADInput__c pqi : inputPricingQadList){
			if(pqi.ItemNumber__c != null){
				String itemUom = pqi.ItemNumber__c + ' [' + pqi.UOM__c.toUpperCase() + ']';
				itemSet.add(itemUom);
			}
			if(pqi.CustomerNumber__c != null){
				cmAddrSet.add(pqi.CustomerNumber__c);
			}
		}

		//Collect Existing Parts Where they Exist
		Map<String, Id> partMap = new Map<String, Id>();
		List<Product2> p2List = [SELECT Id, QAD_pt_part__c FROM Product2 WHERE QAD_pt_part__c IN : itemSet  AND isActive = true];
		for(Product2 p2 : p2List){
			partMap.put(p2.QAD_pt_part__c, p2.Id);
		}

		Map<String, Id> cmAddrMap = new Map<String, Id>();
		List<Account> acctList = [SELECT Id, QAD_cm_addr__c FROM Account WHERE QAD_cm_addr__c IN : cmAddrSet];
		for(Account a : acctList){
			cmAddrMap.put(a.QAD_cm_addr__c, a.Id);
		}

		for(PricingQADInput__c pqi : inputPricingQadList){
			if(pqi.ItemNumber__c != null){
				String itemUom = pqi.ItemNumber__c + ' [' + pqi.UOM__c.toUpperCase() + ']';
				if(partMap.get(itemUom) != null){
					pqi.Product__c = partMap.get(itemUom);
				}
			}
			if(pqi.CustomerNumber__c != null && cmAddrMap.get(pqi.CustomerNumber__c) != null){
				pqi.Account__c = cmAddrMap.get(pqi.CustomerNumber__c);
			}
		}
	}





	public static void connectPricebookEntryToPricingQADInput(List<PricingQADInput__c> inputPricingQadList){
		Set<Id> pricebookIdSet = new Set<Id>();
		Map<String, Id> pqiMap = new Map<String, Id>();

		for(PricingQADInput__c pqi : inputPricingQadList){
			if(pqi.ItemNumber__c != null){
				String pb_partKeyString = pqi.PriceBook2__c + '-' + pqi.Product__c;
				pqiMap.put(pb_partKeyString, pqi.Id);
			}
			if(pqi.CustomerNumber__c != null){
				pricebookIdSet.add(pqi.Pricebook2__c);
			}
		}

		//Collect Existing PricebookEntry Where they Exist
		List<PricebookEntry> pbeUpdateList = new List<PricebookEntry>();
		Map<String, PricebookEntry> pbeMap = new Map<String, PricebookEntry>();
		List<PricebookEntry> pbeList = [SELECT Id, Pricebook2Id, Product2Id, Pricing_QAD_Input__c FROM PricebookEntry WHERE Pricebook2Id IN : pricebookIdSet  AND isActive = true AND isDeleted = false AND isArchived = false];
		for(PricebookEntry pbe : pbeList){
			String pb_partKeyString = pbe.PriceBook2Id + '-' + pbe.Product2Id;
			if(pbe.Pricing_QAD_Input__c == null && pqiMap.get(pb_partKeyString) != null){
				pbe.Pricing_QAD_Input__c = pqiMap.get(pb_partKeyString);
				pbeUpdateList.add(pbe);
			}
		}
		Update pbeUpdateList;
	}



	public static void deletePricingQADInput(List<PricingQADInput__c> inputList){

		Set<String> priceBook_ProductIdString = new Set<String>();
		Set<Id> priceBookIdSet = new Set<Id>();
		Set<Id> productIdSet = new Set<Id>();
		Map<String, PricebookEntry> pbeKeyMap = new Map<String, PricebookEntry>();

		//Collect PricebookId - Product2Id pairs to identify impacted PricebookEntries
		for(PricingQADInput__c pqi : inputList){
			String key = pqi.Pricebook2__c + '-' + pqi.Product__c;
			priceBookIdSet.add(pqi.Pricebook2__c);
			productIdSet.add(pqi.Product__c);
			priceBook_ProductIdString.add(key);
		}

		//Query Possible PricebookEntries
		List<PricebookEntry> pbeList = [SELECT Id, Pricebook2Id, Product2Id, isActive, IsArchived FROM PricebookEntry WHERE Pricebook2Id IN : pricebookIdSet AND Product2Id IN : productIdSet AND Pricebook2.Name <> 'Standard Price Book' ORDER BY CreatedDate DESC];
		for(PricebookEntry pbe : pbeList){
			String key = pbe.Pricebook2Id + '-' + pbe.Product2Id;
			pbeKeyMap.put(key, pbe);
		}

		//Collect Keyed PricebookEntries and set them to inactive and archived
		List<PricebookEntry> pbeArchiveList = new List<PricebookEntry>();
		for(String k : priceBook_ProductIdString){
			if(pbeKeyMap.get(k) != null){
				PricebookEntry pbe = pbeKeyMap.get(k);
				pbe.isActive = False;
				pbeArchiveList.add(pbe);
			}
		}
		delete pbeArchiveList;
	}




}