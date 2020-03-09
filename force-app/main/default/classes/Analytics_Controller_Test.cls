@isTest (seeallData=False)
private class Analytics_Controller_Test {
	
	@isTest static void test_method_one() {
		
		GlobalTriggerSwitch.runOrderDetailTrigger= false;
 		GlobalTriggerSwitch.runProcedureFormTrigger = false;

		UnitTestDataFactory.createProdcedure_Forms();
		Analytics_Controller.getRevenueYtdNumbers();
		Analytics_Controller.getProcedureYtdNumbers();
		Analytics_Controller.deleteAytdList();
		
		Analytics_Controller.getProcedureYtdNumbers();
		Analytics_Controller.getRevenueYtdNumbers();

	}

	@isTest static void test_scheduletrigger1(){
		Test.StartTest();
			UnitTestDataFactory.createProdcedure_Forms();

			Analytics_Controller_Scheduler sh1 = new Analytics_Controller_Scheduler();
			String sch1 = '0 0 * * * ?'; 
			system.schedule('Test Analytics_Controller_Scheduler', sch1, sh1); 
		Test.stopTest();

	}
	


}