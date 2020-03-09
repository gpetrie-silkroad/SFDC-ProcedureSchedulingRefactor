@isTest(SeeAllData = False)
private class Order_Test {
	  
	@isTest static void test_method_one() {
		UnitTestDataFactory.createTestUsers();
		UnitTestDataFactory.createTestTerritories();
		UnitTestDataFactory.qad_createQadSourcedAccounts();
		UnitTestDataFactory.qad_createQadSourceAddresses();
		UnitTestDataFactory.createTestTimePeriods();
		UnitTestDataFactory.createTestGoals();

		UnitTestDataFactory.qad_createQadSourceParts();
		UnitTestDataFactory.qad_createQadSourcedPricebooks();
		UnitTestDataFactory.qad_createQadSourcedPricebookEntries();
		UnitTestDataFactory.qad_createQadSourcedOrders();

		Test.startTest();
			OrderItemTrigger_Helper.totalUpRelatedOrders();
			OrderItemTrigger_Helper.totalValueToGoal();

			OrderTrigger_Helper.totalValueToGoal();

			List<Order> oList = [SELECT Id, Period__c, Territory__c, KeyString__c FROM Order];
			OrderTrigger_Helper.incrementalValueUpdateOrDeleteToGoal(oList);

			List<OrderItem> oiList = [SELECT ID, Ship_Date__c, QAD_Sourced__c FROM OrderItem];
			for(OrderItem oi : oiList){
				oi.Ship_Date__c = System.Today();
				oi.QAD_Sourced__c = false;
			}
			update oiList;

			OrderTrigger_Helper.totalValueToGoal();

			
			delete oiList[0];
		Test.stopTest();
	}




	
	@isTest static void test_method_two() {
		UnitTestDataFactory.createTestUsers();
		UnitTestDataFactory.createTestTerritories();
		UnitTestDataFactory.qad_createQadSourcedAccounts();
		UnitTestDataFactory.qad_createQadSourceAddresses();
		UnitTestDataFactory.createTestTimePeriods();
		UnitTestDataFactory.createTestGoals();

		UnitTestDataFactory.qad_createQadSourceParts();
		UnitTestDataFactory.qad_createQadSourcedPricebooks();
		UnitTestDataFactory.qad_createQadSourcedPricebookEntries();	
		
		

		UnitTestDataFactory.qad_createQadSourcedOrders();

		//UnitTestDataFactory.qad_createQadSourcedInvoice();			
		//UnitTestDataFactory.qad_createQadSourcedInvoiceItems();

		UnitTestDataFactory.qad_createQadSourcedOrderItem();
		UnitTestDataFactory.qad_createQadTestShipment();
		
		Test.startTest();	
			UnitTestDataFactory.qad_createQadSourcedOrderItemDetail();
		Test.stopTest();

	}






	@isTest static void test_method_three() {
		UnitTestDataFactory.createTestUsers();
		UnitTestDataFactory.createTestTerritories();
		UnitTestDataFactory.qad_createQadSourcedAccounts();
		UnitTestDataFactory.qad_createQadSourceAddresses();
		UnitTestDataFactory.createTestTimePeriods();
		UnitTestDataFactory.createTestGoals();

		UnitTestDataFactory.qad_createQadSourceParts();
		UnitTestDataFactory.qad_createQadSourcedPricebooks();
		UnitTestDataFactory.qad_createQadSourcedPricebookEntries();	
	
		UnitTestDataFactory.qad_createQadSourcedOrders();

		Test.startTest();
			UnitTestDataFactory.qad_createQadSourcedInvoice();			
			UnitTestDataFactory.qad_createQadSourcedInvoiceItems();
		Test.stopTest();
	}
	




	@isTest static void test_duplicatePartEntry() {
		UnitTestDataFactory.createTestUsers();
		UnitTestDataFactory.createTestTerritories();
		UnitTestDataFactory.qad_createQadSourcedAccounts();
		UnitTestDataFactory.qad_createQadSourceAddresses();
		UnitTestDataFactory.createTestTimePeriods();
		UnitTestDataFactory.createTestGoals();

		UnitTestDataFactory.qad_createQadSourceParts();

		List<Product2> p2List = [SELECT Description,Family,Id,IsActive,Name,ProductCode,QAD_pd_mod_date__c,QAD_pt_part__c,QAD_sourced__c FROM Product2 WHERE QAD_Sourced__c = true];

		List<Product2> p2InsertList = new List<Product2>();
		for(Product2 p2 : p2List){
			Product2 p201 = new Product2(Description = p2.Description, Family = p2.Family,
											IsActive = true, Name = p2.Name, ProductCode = p2.ProductCode, 
											QAD_pt_part__c = p2.QAD_pt_part__c, QAD_sourced__c = true 
											);
			p2InsertList.add(p201);
		}
		insert p2InsertList;

		Set<String> productCodeSet = new Set<String>();
		List<Product2> p2List2 = [SELECT Description,Family,Id,IsActive,Name,ProductCode,QAD_pd_mod_date__c,QAD_pt_part__c,QAD_sourced__c FROM Product2 WHERE QAD_Sourced__c = true AND IsActive = true ORDER BY ProductCode];
		Integer i = 0;
		for(Product2 p2 : p2List2){
			if(productCodeSet.contains(p2.ProductCode)){
				i++;
			}
			productCodeSet.add(p2.ProductCode);
		}
		//system.assertEquals(i,0);
	}


	

}