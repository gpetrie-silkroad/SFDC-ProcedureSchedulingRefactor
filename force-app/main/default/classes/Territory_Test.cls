@isTest (seeAllData=false)
private class Territory_Test {
	
	@isTest static void test_method_one() {
		UnitTestDataFactory.createTestUsers();
		UnitTestDataFactory.createTestTerritories();
		Territory_History__c th = new Territory_History__c(Name = 'TEST');
		insert th;

		//TerritoryHistoryReportPageController.TerritoryHistoryReportPageController();
	}

	@isTest static void test_AM_Inactive() {
		UnitTestDataFactory.createTestInactiveUsers();

		UnitTestDataFactory.createTestIncompleteTerritories();


		List<Territory__c> terrList = [SELECT Area_Director__c,Area_Manager__c,Id,IsActive__c,Name,OwnerId,Owner_Role__c,QAD_AM_Id__c,Region__c FROM Territory__c];

		//Territory_Trigger_Helper.defineTerritoryOwnership(terrList);
	}
	
	
}