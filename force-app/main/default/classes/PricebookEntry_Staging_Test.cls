@isTest(seeAllData=false)
private class PricebookEntry_Staging_Test {
	
	@isTest static void noExistingPBEorPB() {
		UnitTestDataFactory.qad_createQadSourceParts();
		UnitTestDataFActory.createPricebookEntryStagingTable();
	}

	@isTest static void noExistingPBEorPBnoStdPBE() {
		UnitTestDataFactory.qad_createQadSourceParts();
		UnitTestDataFactory.qad_createQadSourcedPricebooks();
		Id stdPricebookId = Test.getStandardPricebookId();
		List<PricebookEntry> stdPbeList = [SELECT ID FROM PricebookEntry WHERE Pricebook2Id = : stdPricebookId];
		delete stdPbeList;
		UnitTestDataFActory.createPricebookEntryStagingTable();
	}

	@isTest static void noExistingPBE() {
		UnitTestDataFactory.qad_createQadSourceParts();
		UnitTestDataFactory.qad_createQadSourcedPricebooks();
		UnitTestDataFActory.createPricebookEntryStagingTable();
	}

	@isTest static void existingPBEandPB() {
		UnitTestDataFactory.qad_createQadSourceParts();
		UnitTestDataFactory.qad_createQadSourcedPricebooks();
		UnitTestDataFactory.qad_createQadSourcedPricebookEntries();
		UnitTestDataFActory.createPricebookEntryStagingTable();
	}
	

	
}