public without sharing class PricebookEntry_StagingTrigger_Helper {
	
	public static void setNameBeforeUpsert(List<PricebookEntry_Staging_Table__c> inputPbeStagingList){
		for(PricebookEntry_Staging_Table__c pbest : inputPbeStagingList){
			pbest.Name = (pbest.QAD_pi_cs_code__c + '-' + pbest.QAD_pi_part_code__c + '-' +  pbest.QAD_pi_um__c).toUpperCase();
		}
	}




	public static void setupPricebookEntries(List<PricebookEntry_Staging_Table__c> inputPbeStagingList){
		Set<String> csCodeSet = new Set<String>();
		Set<String> productCodeSet = new Set<String>();
		Set<String> keyCodeSet = new Set<String>();

		for(PricebookEntry_Staging_Table__c pbest : inputPbeStagingList){
			String csCode = pbest.QAD_pi_cs_code__c;
			String productCode = (pbest.QAD_pi_part_code__c + ' [' + pbest.QAD_pi_um__c + ']').toUpperCase();

			//SYSTEM.DEBUG('PRODUCT CODE SET = [' + productCode + ']');
			
			String keyCode = csCode + '-' + productCode;

			csCodeSet.add(csCode);
			productCodeSet.add(productCode);
			keyCodeSet.add(keyCode);
		}

		Integer z = 1;
		Map<String, Id> pricebookMap = new Map<String, Id>();
		List<Pricebook2> pb2List = [SELECT Id, QAD_pi_cs_code__c FROM Pricebook2 WHERE QAD_pi_cs_code__c <> null AND QAD_pi_cs_code__c IN : csCodeSet ];
		for(Pricebook2 pb2 : pb2List){
			pricebookMap.put(pb2.QAD_pi_cs_code__c, pb2.Id);
			//SYSTEM.DEBUG('[' + z + '] PRICEBOOK MAP ADD CODE = [' + pb2.QAD_pi_cs_code__c + ']');
			z++;
		}

		for(String s : productCodeSet){
			SYSTEM.DEBUG('PRODUCT CODE SET KEY = [' + s + ']');
		}


		Integer y = 1; 
		Map<String, Id> productMap = new Map<String, Id>();
		List<Product2> p2List = [SELECT QAD_pt_part__c, Id FROM Product2 WHERE QAD_pt_part__c IN : productCodeSet ];
		SYSTEM.DEBUG('P2 LIST SIZE = [' + p2List.size() + ']');
		for(Product2 p2 : p2List){
			productMap.put(p2.QAD_pt_part__c.toUpperCase(), p2.Id);
			SYSTEM.DEBUG('[' + y + '] PRODUCT MAP ADD CODE = [' + p2.QAD_pt_part__c + '] ID = [' + p2.Id + ']');
			y++;
		}

		Integer x = 1;
		Set<String> existingKeyCodesInPricebookEntry = new Set<String>();
		List<PriceBookEntry> pbeList = [SELECT Id, CsCode_Product_Key__c FROM PricebookEntry WHERE CsCode_Product_Key__c IN : keyCodeSet ];
		for(PricebookEntry pbe : pbeList){
			existingKeyCodesInPricebookEntry.add(pbe.CsCode_Product_Key__c);
			//SYSTEM.DEBUG('[' + x + '] EXISTING PRICEBOOK ENTRY MAP ADD CODE = [' + pbe.CsCode_Product_Key__c+ ']');
			x++;
		}

		Set<Id> standardProductPbeSet = new Set<Id>();
		Id stdPricebookId;
		if(Test.isRunningTest()){
			stdPricebookId = Test.getStandardPricebookId();
		}
		else{
			stdPricebookId = [SELECT Id FROM Pricebook2 WHERE Name = 'Standard Price Book' LIMIT 1][0].Id;
		}
		Integer w = 1;
		List<PricebookEntry> stdPbeList = [SELECT Product2Id, PriceBook2Id FROM PriceBookEntry WHERE PriceBook2Id = : stdPricebookId ];
		for(PricebookEntry pbe : stdPbeList){
			standardProductPbeSet.add(pbe.Product2Id);
			//SYSTEM.DEBUG('[' + w + '] EXISTING STD PRICEBOOK ENTRY MAP ADD CODE = [' + pbe.Product2Id + ']');
			w++;
		}

		List<PricebookEntry> pbeInsertList = new List<PricebookEntry>();
		List<PricebookEntry> stdPbeInsertList = new List<PricebookEntry>();

		Integer v = 1;
		for(PricebookEntry_Staging_Table__c pbest : inputPbeStagingList){
			String csCode = pbest.QAD_pi_cs_code__c;
			String productCode = (pbest.QAD_pi_part_code__c + ' [' + pbest.QAD_pi_um__c + ']').toUpperCase();
			String keyCode = csCode + '-' + productCode;

			SYSTEM.DEBUG('[' + v + '] GET PARAMETERS CSCODE = [' + csCode + '] PRODUCT CODE = [' + productCode + '] KEY CODE = [' + keyCode + ']');
			v++;

			//SYSTEM.DEBUG('Key Code in Pricebook Entry = [' + existingKeyCodesInPricebookEntry.contains(keyCode) + ']');
			if(!existingKeyCodesInPricebookEntry.contains(keyCode)){

				SYSTEM.DEBUG('PRICEBOOK MAP GET = [' + pricebookMap.get(csCode) + '] PRODUCT MAP GET = [' + productMap.get(productCode) + ']');
				
				if(pricebookMap.get(csCode) != null && productMap.get(productCode) != null){
					PricebookEntry pbe = new PricebookEntry();
					pbe.csCode_Product_Key__c = keyCode;
					pbe.Duplicate__c = false;
		
					if((pbe.UnitPrice == 1 || pbe.UnitPrice == null) && pbest.QAD_pi_list__c != null){
						pbe.UnitPrice = 1;
					}
					else if(pbe.UnitPrice == 1 || pbe.UnitPrice == null){
						pbe.UnitPrice = 1;
					}

					pbe.ListId__c = pbest.QAD_pi_List_id__c;
					pbe.Pricebook2Id = pricebookMap.get(csCode);
					pbe.Product2Id = productMap.get(productCode);
					pbe.QAD_sourced__c = true;

					existingKeyCodesInPricebookEntry.add(keyCode);

					pbeInsertList.add(pbe);

					if(!standardProductPbeSet.contains(pbe.Product2Id)){
						PricebookEntry stdPbe = new PriceBookEntry();
						stdPbe.Duplicate__c = false;
						if((stdPbe.UnitPrice == 1 || stdPbe.UnitPrice == null) && pbest.QAD_pi_list__c != null){
							stdPbe.UnitPrice = 1;
						}
						else if(stdPbe.UnitPrice == 1 || stdPbe.UnitPrice == null){
							stdPbe.UnitPrice = 1;
						}
						stdPbe.ListId__c = pbest.QAD_pi_List_id__c;
						stdPbe.Pricebook2Id = stdPricebookId;
						stdPbe.Product2Id = productMap.get(productCode);
						stdPbe.QAD_sourced__c = false;
						standardProductPbeSet.add(pbe.Product2Id);

						stdPbeInsertList.add(stdPbe);
					}

				}	
			}
		}

		Set<String> listIdSet = new Set<String>();
		List<PricebookEntry> pbeListList = [SELECT Id, ListId__c FROM PricebookEntry WHERE ListId__c <> null];
		for(PricebookEntry pbe : pbeListList){
			listIdSet.add(pbe.ListId__c);
		}

		List<PricebookEntry> pbeInsertList2 = new List<PricebookEntry>();
		for(PricebookEntry pbe : pbeInsertList){
			if(!listIdSet.contains(pbe.ListId__c)){
				pbeInsertList2.add(pbe);
				listIdSet.add(pbe.ListId__c);
			}
		}

		insert stdPbeInsertList;

	    

		insert pbeInsertList2;
	
	}	
}