public with sharing class Product2Trigger_Helper {
	
	public static void createStdPricebookEntry(List<Product2> inputProduct2List){
		Id stdPricebookId;
		if(Test.isRunningTest()){
			stdPricebookId = Test.getStandardPricebookId();
		}
		else{
			stdPricebookId = [SELECT Id FROM Pricebook2 WHERE Name = 'Standard Price Book'][0].Id;
		}

		Set<String> stdPricebookStringSet = new Set<String>();
		List<PricebookEntry> standardPricebookList = [SELECT Id, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Pricebook2Id = : stdPricebookId];
		for(PricebookEntry pbe : standardPricebookList){
			stdPricebookStringSet.add(pbe.Pricebook2Id + '-' + pbe.Product2Id);
		}

		List<PricebookEntry> pbeToInsertList = new List<PricebookEntry>();
		for(Product2 p2 : inputProduct2List){
			String pbeKeyString = stdPricebookId + '-' + p2.Id;
			if(!stdPricebookStringSet.contains(pbeKeyString)){
				PricebookEntry newPbe= new PricebookEntry(Pricebook2Id = stdPricebookId , Product2Id = p2.Id , IsActive = true, QAD_sourced__c = false, Duplicate__c = false, UnitPrice = 1);
				pbeToInsertList.add(newPbe);
			}
		}
		Insert pbeToInsertList;
	}
}