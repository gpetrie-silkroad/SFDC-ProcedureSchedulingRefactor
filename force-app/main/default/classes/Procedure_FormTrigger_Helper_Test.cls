@isTest(seeAllData=false)
private class Procedure_FormTrigger_Helper_Test {
	
	@isTest static void Procedure_FormTrigger_Helper_Test() {
		UnitTestDataFactory.createProdcedure_Forms();
		Procedure_FormTrigger_Helper.totalValueToGoal('2018');
		Test.startTest();
		Procedure_FormTrigger_Helper.Procedure_Form_Count_BatchLauncher();
		Test.stopTest();
	}
	 
	@isTest static void ProcedureToGoalScheduler_Test() {
		Test.startTest();
			UnitTestDataFactory.createProdcedure_Forms();
			ProcedureFormToGoalTotal_Batch_Scheduler sh1 = new ProcedureFormToGoalTotal_Batch_Scheduler();
			String sch1 = '0 0 * * * ?'; 
			system.schedule('Test ParseIqmsDataTable_Scheduler', sch1, sh1); 
		Test.stopTest();
	}
	
}