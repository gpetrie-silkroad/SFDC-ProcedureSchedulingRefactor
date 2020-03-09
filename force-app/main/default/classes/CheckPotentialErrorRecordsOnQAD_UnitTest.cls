@isTest(SeeAllData=false)
private class CheckPotentialErrorRecordsOnQAD_UnitTest
{
	@isTest
	static void test_method_one()
	{
		List<QAD_Summary__c> QADSummary = new List<QAD_Summary__c>();
		QAD_Summary__c triggerRecord = new QAD_Summary__c();
		triggerRecord.Title__c = 'Test';
		triggerRecord.Name = 'Test';
		triggerRecord.Note__c = 'Test@test.com';
		insert triggerRecord;

		QAD_Summary__c record1 = new QAD_Summary__c();
		record1.Title__c = 'Test potential';
		record1.Name = 'Test potential';
		record1.Note__c = 'test Note';
		record1.Ref_No__c = 5;
		record1.Total_Number__c = 6;
		insert record1;

		Account testAcc = new Account();
		testAcc.Name = 'Test Account';
		testAcc.QAD_cm_addr__c = '12345';
		insert testAcc;
		Order duplicateOrder = new Order();
		duplicateOrder.AccountId = testAcc.Id;
		duplicateOrder.Status = 'Draft';
		duplicateOrder.EffectiveDate = datetime.now().date();
		duplicateOrder.IQMS_ORDER_NO__c = 'S123456';
		duplicateOrder.PO_Number__c = '456789PO';
		duplicateOrder.QAD_so_cust_c__c = '12345';
		insert duplicateOrder;
		Test.setCreatedDate(duplicateOrder.Id, System.now().addMinutes(-20));
		duplicateOrder.Id = null;
		duplicateOrder.IQMS_ORDER_NO__c = 'B234567';
		duplicateOrder.PO_Number__c = '456789PO';
		duplicateOrder.QAD_so_cust_c__c = '12345';
		insert duplicateOrder;
		Test.setCreatedDate(duplicateOrder.Id, System.now().addMinutes(-20));

		QADSummary.add(triggerRecord);
		QADSummary = CheckPotentialErrorRecordsOnQADAndSFDC.checkDuplicatePO(QADSummary);
	}
}