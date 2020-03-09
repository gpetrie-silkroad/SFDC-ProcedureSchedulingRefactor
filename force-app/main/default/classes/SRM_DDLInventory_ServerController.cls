public without sharing class SRM_DDLInventory_ServerController {

	@AuraEnabled
	public static List<Location__c> getLocationList() {
		List<AggregateResult> results = [ SELECT QAD_Location__c, Rep_Name__c 
										  FROM Location__c
										  Group by QAD_Location__c, Rep_Name__c];

		List<Location__c> locationList = new List<Location__c>();

		for(AggregateResult element : results){
			locationList.add(new Location__c (QAD_Location__c = String.valueof(element.get('QAD_Location__c')),
											  Rep_Name__c = String.valueof(element.get('Rep_Name__c'))));
		}

		return locationList;		
	}

	@AuraEnabled
	public static List<Lot_Information__c> getLotNoList() {
		List<Lot_Information__c> lotResult = [	SELECT Item_No__c, Lot_Number__c 
												FROM Lot_Information__c 
												Order BY CreatedDate DESC LIMIT 500];

		return lotResult ;		
	}

	@AuraEnabled
	public static List<Transaction__c> getTransactionsResult (String lotno, list<String> locationID, String TranReason) {
		List<Transaction__c> tranResult = new List<Transaction__c>();
		if(lotno == '' || lotno == null || lotno == ' ')
			lotno = '%';

		Boolean isTranReasonEmpty = false; 
		if(TranReason == '' || TranReason == null)
		{
			TranReason = '%';
			isTranReasonEmpty = true;
		}
		else
			TranReason = '%' + TranReason + '%';

		Boolean isLocationIDEmpty = false; 
		if(locationID == null || locationID.isEmpty())
			isLocationIDEmpty = true;
		else
		{
			if(String.isBlank(locationID[0]) || locationID[0] == null)
				isLocationIDEmpty = true;
		}

		if(!isLocationIDEmpty)
		{
			if(isTranReasonEmpty)
				tranResult = [ 	SELECT Account__c,DeliveryTo__c,ItemNo__c,Loc_Description__c, QADTranasctionID__c, Note__c,
									   LotNo__c,Order__c,RefNo__c,TrackingNo__c,TranInOut__c,IQMSTransactionID__c, Loc_Desc__c,
									   TranQuan__c,TransferDate__c,TransReason__c,UserID__c, Batch__c, TransType__c, IsDisplayed__c
								FROM Transaction__c 
								WHERE LotNo__c like: lotno AND
									  Loc_Desc__c IN :locationID
								ORDER BY TransferDate__c, RefNo__c, TranInOut__c ASC NULLS LAST, TranQuan__c DESC NULLS LAST, Batch__c ASC NULLS FIRST
								Limit 500];
			else
				tranResult = [ 	SELECT Account__c,DeliveryTo__c,ItemNo__c,Loc_Description__c, QADTranasctionID__c, Note__c,
									   LotNo__c,Order__c,RefNo__c,TrackingNo__c,TranInOut__c,IQMSTransactionID__c, Loc_Desc__c,
									   TranQuan__c,TransferDate__c,TransReason__c,UserID__c, Batch__c, TransType__c, IsDisplayed__c
								FROM Transaction__c 
								WHERE LotNo__c like: lotno AND 
									  TransReason__c like :TranReason AND
									  Loc_Desc__c IN :locationID
								ORDER BY TransferDate__c, RefNo__c, TranInOut__c ASC NULLS LAST, TranQuan__c DESC NULLS LAST, Batch__c ASC NULLS FIRST
								Limit 500];
		}else
		{
			if(isTranReasonEmpty)
				tranResult = [ 	SELECT Account__c,DeliveryTo__c,ItemNo__c,Loc_Description__c, QADTranasctionID__c, Note__c,
									   LotNo__c,Order__c,RefNo__c,TrackingNo__c,TranInOut__c,IQMSTransactionID__c, Loc_Desc__c,
									   TranQuan__c,TransferDate__c,TransReason__c,UserID__c, Batch__c, TransType__c, IsDisplayed__c
								FROM Transaction__c 
								WHERE LotNo__c like :lotno
								ORDER BY TransferDate__c, RefNo__c, TranInOut__c ASC NULLS LAST, TranQuan__c DESC NULLS LAST, Batch__c ASC NULLS FIRST
								Limit 500];
			else
				tranResult = [ 	SELECT Account__c,DeliveryTo__c,ItemNo__c,Loc_Description__c, QADTranasctionID__c, Note__c,
									   LotNo__c,Order__c,RefNo__c,TrackingNo__c,TranInOut__c,IQMSTransactionID__c, Loc_Desc__c,
									   TranQuan__c,TransferDate__c,TransReason__c,UserID__c, Batch__c, TransType__c, IsDisplayed__c
								FROM Transaction__c 
								WHERE LotNo__c like :lotno AND
									  TransReason__c like :TranReason
								ORDER BY TransferDate__c, RefNo__c, TranInOut__c ASC NULLS LAST, TranQuan__c DESC NULLS LAST, Batch__c ASC NULLS FIRST
								Limit 500];
		}

		return tranResult;		
	}

	@AuraEnabled
	public static List<Procedure_Form__c> getProcedureResult (String lotno, String employeeID) {
		list<User> ownername = [SELECT Employee_ID__c,Name FROM User WHERE Employee_ID__c = :employeeID LIMIT 1];
		lotno = '%' + lotno + '%';

		List<Procedure_Form__c> result = new List<Procedure_Form__c>();
		if(!ownername.isEmpty())
			result = [ 	SELECT Account__r.Name, Guidewire_Lot_Number__c, MPK_Lot_Number__c,
												   MPK_Size__c, NPS_Lot_No__c, Procedure_Date__c,
												   Stent_1_Size__c,Stint_1_Lot_Number__c,
												   Stint_2_Lot_Number__c, Stint_2_Size__c, AD_Present__r.name,
												   Other_Qualified_SRM_Present__r.name, AM_Present__r.name,
												   TDS_Present__r.name, Other_SRM_Personnel_Present__c
											FROM Procedure_Form__c
											where ( Other_SRM_Personnel_Present__c =: ownername[0].Name
													or TDS_Present__r.Employee_ID__c =: employeeID
													or Other_Qualified_SRM_Present__r.Employee_ID__c =: employeeID
													or AM_Present__r.Employee_ID__c =: employeeID
													or AD_Present__r.Employee_ID__c =: employeeID) 
												and (Guidewire_Lot_Number__c like: lotno
													or MPK_Lot_Number__c like: lotno
													or NPS_Lot_No__c like: lotno
													or Stint_1_Lot_Number__c like: lotno
													or Stint_2_Lot_Number__c like: lotno)
											ORDER BY Procedure_Date__c ASC NULLS FIRST
											Limit 200];

		return result;		
	}

	@AuraEnabled
	public static List<Procedure_Form__c> getProcedureResultUserIn (String lotno, String accountName) {
		accountName = '%' + accountName + '%';
		lotno = '%' + lotno + '%';
		List<Procedure_Form__c> result = new List<Procedure_Form__c>();

		result = [ 	SELECT Account__r.Name, Guidewire_Lot_Number__c, MPK_Lot_Number__c,
						   MPK_Size__c, NPS_Lot_No__c, Procedure_Date__c,
						   Stent_1_Size__c,Stint_1_Lot_Number__c,
						   Stint_2_Lot_Number__c, Stint_2_Size__c, AD_Present__r.name,
						   Other_Qualified_SRM_Present__r.name, AM_Present__r.name,
						   TDS_Present__r.name, Other_SRM_Personnel_Present__c
					FROM Procedure_Form__c
					where 
							Account__r.Name like :accountName 
							and (Guidewire_Lot_Number__c like: lotno
								or MPK_Lot_Number__c like: lotno
								or NPS_Lot_No__c like: lotno
								or Stint_1_Lot_Number__c like: lotno
								or Stint_2_Lot_Number__c like: lotno)
					ORDER BY Procedure_Date__c ASC NULLS FIRST
					Limit 200];
		return result;		
	}

	@AuraEnabled
	public static List<Inventory_Transfer_Form_Transaction__c> getInventoryTransferFormResult (String lotno, String employeeID) {
		list<User> ownername = [SELECT ID, Employee_ID__c, Name FROM User WHERE Employee_ID__c = :employeeID LIMIT 1];

		List<Inventory_Transfer_Form_Transaction__c> result = new List<Inventory_Transfer_Form_Transaction__c>();
		if(!ownername.isEmpty())
			result = [ 	SELECT Inventory_Owner__c, Lot_number__c, Price__c, Product_Number__c, UOM__c, Quantity__c,
							   Transacted_By__c, Transfer_Date_System__c, Bill_Only_Number__c, IsTransactionComplete__c,
							   Inventory_Transfer_Form__r.Transfer_Date__c, Inventory_Transfer_Form__r.ITF_Type__c,
							   Inventory_Transfer_Form__r.To_Rep_TDS__c, Inventory_Transfer_Form__r.Name, ITF_Status__c
						FROM Inventory_Transfer_Form_Transaction__c
						WHERE Lot_number__c =: lotno
							  and Inventory_Owner__c =: ownername[0].Name
						ORDER BY Inventory_Transfer_Form__r.Transfer_Date__c ASC NULLS FIRST
						Limit 500];

		return result;		
	}

	@AuraEnabled
	public static void updateTransaction (List<Transaction__c> transactions)
	{
		update transactions;
	}

	@AuraEnabled
	public static Transaction__c recordType (Id recordId)
	{
		String objecType = String.valueof(recordId.getsobjecttype());
		Transaction__c tempStore = new Transaction__c();
		tempStore.TransReason__c = objecType;
		if(objecType == 'Inventory_Transfer_Form__c')
		{
			List<Inventory_Transfer_Form__c> ITFs = [	SELECT Primary_Bill_Only_Number__c 
														FROM Inventory_Transfer_Form__c
														WHERE Id =: recordId
														Limit 1];
			if(!ITFs.isEmpty())
			{
				tempStore.Loc_Description__c = ITFs[0].Primary_Bill_Only_Number__c; 
			}
		}else if(objecType == 'Order')
		{
			List<Order> Orders = [	SELECT Name
									FROM Order
									WHERE Id =: recordId
									Limit 1];
			if(!Orders.isEmpty())
			{
				tempStore.Loc_Description__c = Orders[0].Name; 
			}
		}

		return tempStore;
	}

	@AuraEnabled
	public static List<Transaction__c> getTranHis (String reason)
	{
		reason = '%' + reason + '%';

		List<Transaction__c> transactions = [SELECT Account__c,DeliveryTo__c,ItemNo__c,Loc_Description__c, QADTranasctionID__c, Note__c,
												   LotNo__c,Order__c,RefNo__c,TrackingNo__c,TranInOut__c,IQMSTransactionID__c, Loc_Desc__c,
												   TranQuan__c,TransferDate__c,TransReason__c,UserID__c, Batch__c, TransType__c, IsDisplayed__c
											FROM Transaction__c 
											WHERE 
												TransReason__c like: reason
											ORDER BY TransferDate__c, RefNo__c, TranInOut__c ASC NULLS LAST, TranQuan__c DESC NULLS LAST, Batch__c ASC NULLS FIRST
											Limit 500];
		return transactions;
	}
}
//System.Debug('Apex Debug:' + listResult[0]);