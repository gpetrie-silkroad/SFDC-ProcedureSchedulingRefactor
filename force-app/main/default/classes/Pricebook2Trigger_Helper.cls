public without sharing class Pricebook2Trigger_Helper {
	public static void associatePricebookToAccount(List<Pricebook2> pb2List) {
		Map<String, Id> pb2Map = new Map<String, Id>();
		for(Pricebook2 pb2 : pb2List){
			if(pb2.QAD_pi_cs_code__c != null){
				pb2Map.put(pb2.QAD_pi_cs_code__c, pb2.Id);
			}	
		}

		List<Account> acctList = [SELECT Id, Price_Book__c, QAD_cm_addr__c FROM Account WHERE QAD_cm_addr__c IN : pb2Map.keyset()];
		
		for(Account a : acctList){
			a.Price_Book__c = pb2Map.get(a.QAD_cm_addr__c);
		}
		update acctList;
	}





	public static void setPricebookName(List<Pricebook2> inputPricebookList){
		Set<String> acctNumSet = new Set<String>();
		for(Pricebook2 pb2 : inputPricebookList){
			if(pb2.QAD_pi_cs_code__c != null){
				acctNumSet.add(pb2.QAD_pi_cs_code__c);
			}
		}

		Map<String, String> acctMap = new Map<String, String>();
		List<Account> acctList = [SELECT Id, Name, QAD_cm_addr__c FROM Account WHERE QAD_cm_addr__c IN : acctNumSet];
		for(Account a : acctList){
			acctMap.put(a.QAD_cm_addr__c, a.Name);
		}

		for(Pricebook2 pb2 : inputPricebookList){
			if(pb2.QAD_pi_cs_code__c != null && acctMap.get(pb2.QAD_pi_cs_code__c) != null){
				pb2.Name = acctMap.get(pb2.QAD_pi_cs_code__c) + ' - [' + pb2.QAD_pi_cs_code__c + ']'; 
			}
		}		
	}
}