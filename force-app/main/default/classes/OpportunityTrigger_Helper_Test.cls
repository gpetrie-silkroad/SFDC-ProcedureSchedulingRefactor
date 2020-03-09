@isTest
private class OpportunityTrigger_Helper_Test {
	
	@isTest static void test_method_one() {
		UnitTestDataFactory.createTestUsers();
		UnitTestDataFactory.qad_createQadSourcedAccounts();

		List<Account> acctList = [SELECT ID, Area_Director_Id__c, Area_Manager_User__c FROM Account];
		List<User> userList = [SELECT Id FROM User WHERE IsActive = True];

		for(Account a : acctList){
			a.Area_Director_Id__c = userList[0].id;
			a.Area_Manager_User__c = userList[1].Id;
		}

		update acctList;

		Id rtId = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND Name = 'Physician' LIMIT 1].Id;
		Opportunity o = new Opportunity(
											Name = 'Test Opportunity',
											AccountId = acctList[0].id,
											Type = 'Physician Opportunity',
											RecordTypeId = rtId,
											StageName = 'Clinical Readiness',
											CloseDate = System.Today().addDays(+60),
											Projected_Close_Date__c = System.Today().addDays(+60),
 											Probability = 80,
 											OwnerId = userList[1].Id,
 											Amount = 0,
 											Expected_Procedures__c = 1
 											);
		insert o;
	}
	
	
}