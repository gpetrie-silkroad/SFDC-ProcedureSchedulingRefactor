@isTest(SeeAllData=true)
private class SRM_DeepDiveLotInventory_unitTest {
	
	@isTest static void test_method_one() {
		//Test getLocationList
		Location__c loc = new Location__c (QAD_Location__c = 'Test-Trunk',
											  Rep_Name__c = 'tester');
		upsert loc;
		List<Location__c> a = SRM_DDLInventory_ServerController.getLocationList();

		//Test getLotNoList
		List<Lot_Information__c> lotResult = SRM_DDLInventory_ServerController.getLotNoList();

		//test getTransactionsResult
		list<String> locationID = new list<String>();
		List<Transaction__c> tranResult = SRM_DDLInventory_ServerController.getTransactionsResult('', locationID,'');
		tranResult = SRM_DDLInventory_ServerController.getTranHis('Test');
		locationID.add('');
		tranResult = SRM_DDLInventory_ServerController.getTransactionsResult('', locationID,'Test');
		locationID[0] = 'test';
		tranResult = SRM_DDLInventory_ServerController.getTransactionsResult('', locationID,'Test');
		tranResult = SRM_DDLInventory_ServerController.getTransactionsResult('', locationID, null);

		//Test getProcedureResult
		User tester = [SELECT Employee_ID__c,Name FROM User WHERE Employee_ID__c != null LIMIT 1];
		List<Procedure_Form__c> result = SRM_DDLInventory_ServerController.getProcedureResult('',tester.Employee_ID__c);
		result = SRM_DDLInventory_ServerController.getProcedureResultUserIn('12345','Test');

		//Test getInventoryTransferFormResult
		List<Inventory_Transfer_Form_Transaction__c> ITFresult = SRM_DDLInventory_ServerController.getInventoryTransferFormResult('',tester.Employee_ID__c);

		//Test updateTransaction
		List<Transaction__c> listtransaction = new List<Transaction__c>();
		Transaction__c tran = new Transaction__c();
		upsert tran;
		listtransaction.add(tran);
		SRM_DDLInventory_ServerController.updateTransaction(listtransaction);

		Inventory_Transfer_Form__c ITF = [SELECT Id FROM Inventory_Transfer_Form__c LIMIT 1];
		tran = SRM_DDLInventory_ServerController.recordType(ITF.Id);
		Order Orderline = [SELECT Id FROM Order LIMIT 1];
		tran = SRM_DDLInventory_ServerController.recordType(Orderline.Id);
	}	
}