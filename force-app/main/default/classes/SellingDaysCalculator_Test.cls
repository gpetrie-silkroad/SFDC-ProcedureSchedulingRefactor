@isTest(SeeAllData=false)
private class SellingDaysCalculator_Test {
	
	@isTest static void test_method_one() {
		UnitTestDataFactory.createTestTimePeriods();
		UnitTestDataFactory.createSellingDaysRecords();

		Test.startTest();
			SellingDaysCalculator m = new SellingDaysCalculator();
			String chron = '1 1 0 * * ?'; 
			System.schedule('Test Sched', chron, m);
		Test.stopTest();
	}
	

	
}