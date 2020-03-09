public with sharing class Transactions_Process_Controller {
	@InvocableMethod(label='Transaction Process Controller' description='Auto update another objects such as location, ITF, etc when transactions are created/edited')
	public static List<Transaction__c> Transactions_Process_Controller(List<Transaction__c> Transactions) 
	{
		List<Transaction__c> TSReturnTransactions = new List<Transaction__c>();
		for(Transaction__c element : Transactions)
		{
			//Update trunk stock return list
			if(element.Loc_Desc__c == '12')
				TSReturnTransactions.add(element);
		}

		if(TSReturnTransactions.size() > 0)
			updateTrunkStockReturn(TSReturnTransactions);

		return Transactions;
	}

	public static void updateTrunkStockReturn(List<Transaction__c> Transactions)
	{
		list<String> LotNumbers = new list<String>();
		list<String> TranReasons = new list<String>();

		for(Transaction__c element : Transactions)
		{
			LotNumbers.add(element.LotNo__c);
			if(!String.IsBlank(element.RefNo__c))
				TranReasons.add(element.RefNo__c);

			if(!String.IsBlank(element.Sales_Job__c))
				TranReasons.add(element.Sales_Job__c);
		}

		list<Inventory_Transfer_Form_Transaction__c> ITFTransactions = [SELECT 
																			Id, Bill_Only_Number__c,Lot_number__c,TSR_Received_By__c,
																			TSR_Received_Date__c,TSR_Received_Qty__c,TSR_Transaction_ID__c 
																		FROM 
																			Inventory_Transfer_Form_Transaction__c
																		where
																			TSR_Transaction_ID__c = null
																			AND ITF_Status__c != 'Received'
																			AND ITF_Status__c != 'Pending PO'
																			AND ITF_Status__c != 'Closed'
																			AND Lot_number__c In :LotNumbers
																			AND Bill_Only_Number__c In :TranReasons];

		if(ITFTransactions.size() > 0)
		{
			for(Inventory_Transfer_Form_Transaction__c element2 : ITFTransactions)
			{
				for(Transaction__c element1 : Transactions)
				{
					if(element2.Lot_number__c == element1.LotNo__c && (element2.Bill_Only_Number__c == element1.RefNo__c || element2.Bill_Only_Number__c == element1.Sales_Job__c))
					{
						element2.TSR_Received_By__c = element1.UserID__c;
						element2.TSR_Received_Date__c = element1.TransferDate__c.date();
						element2.TSR_Received_Qty__c = math.abs(element1.TranQuan__c);
						element2.TSR_Transaction_ID__c = element1.Id;
						break;
					}
				}
			}
			update ITFTransactions;
		}
	}
}

//System.Debug('Transaction receive:' + newITFTransaction.Inventory_Transfer_Form__c);