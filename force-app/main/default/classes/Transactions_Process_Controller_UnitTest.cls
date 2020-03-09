@isTest(SeeAllData=true)
private class Transactions_Process_Controller_UnitTest
{
	@isTest
	static void testTransactionProcessApexController()
	{
		list<Inventory_Transfer_Form_Transaction__c> ITFTransactions = [SELECT 
																			Id, Bill_Only_Number__c,Lot_number__c,TSR_Received_By__c,
																			TSR_Received_Date__c,TSR_Received_Qty__c,TSR_Transaction_ID__c
																		FROM 
																			Inventory_Transfer_Form_Transaction__c
																		where
																			TSR_Transaction_ID__c = null
																			and Bill_Only_Number__c != null
																			AND ITF_Status__c != 'Received'
																			AND ITF_Status__c != 'Pending PO'
																			AND ITF_Status__c != 'Closed'
																		LIMIT 2];

		if(ITFTransactions.size() != 2)
		{
			ITFTransactions = [	SELECT 
									Id, Bill_Only_Number__c,Lot_number__c,TSR_Received_By__c, Inventory_Transfer_Form__c,
									TSR_Received_Date__c,TSR_Received_Qty__c,TSR_Transaction_ID__c
								FROM 
									Inventory_Transfer_Form_Transaction__c
								where
									TSR_Transaction_ID__c = null
									and Bill_Only_Number__c != null
									AND ITF_Status__c = 'Closed'
								LIMIT 2];
			
			Inventory_Transfer_Form__c updateITF = new Inventory_Transfer_Form__c();
			for (Inventory_Transfer_Form_Transaction__c element: ITFTransactions)
			{
				updateITF.Id = element.Inventory_Transfer_Form__c;
				updateITF.Status__c = 'Transacted Inventory/Verification';
				update updateITF;
			}
		}
		
		List<Transaction__c> TSReturnTransactions = new List<Transaction__c>();		
		for (Inventory_Transfer_Form_Transaction__c element: ITFTransactions)
		{
			TSReturnTransactions.add(new Transaction__c(
															LotNo__c = element.Lot_number__c,
															RefNo__c = element.Bill_Only_Number__c,
															Sales_Job__c = element.Bill_Only_Number__c,
															Loc_Desc__c = '12',
															TransferDate__c = date.parse('12/27/2015'),
															TranQuan__c = 2,
															UserID__c = 'asas'
														));		
		}
		
		if(TSReturnTransactions.size() > 0)
		{
			insert TSReturnTransactions;
		}
		TSReturnTransactions = Transactions_Process_Controller.Transactions_Process_Controller(TSReturnTransactions);
	}
}