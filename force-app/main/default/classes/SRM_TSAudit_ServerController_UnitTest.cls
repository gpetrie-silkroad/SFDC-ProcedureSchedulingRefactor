@isTest(SeeAllData=true)
private class SRM_TSAudit_ServerController_UnitTest
{
	@isTest
	static void test_method_one()
	{
		Trunk_Stock_Cycle_Count_Report__c TSCC = SRM_TSAudit_ServerController.getPendingTSCC('N/A');
		TSCC = SRM_TSAudit_ServerController.getPendingTSCC('Test');
		User saleUser = [SELECT ID FROM User WHERE Field_Responsibility__c Like '%Area Manager%' and ManagerId != null LIMIT 1];
		system.runAs(saleUser)
		{
			TSCC = SRM_TSAudit_ServerController.getPendingTSCC('Test');
		}
		list<Lot_Inventory__c> lotInventories = SRM_TSAudit_ServerController.getLotInven();
		Trunk_Stock_Cycle_Count__c TSCCount = new Trunk_Stock_Cycle_Count__c();
		Id TSCCountId =  SRM_TSAudit_ServerController.createNewTSCCount(TSCCount);
		TSCCount = SRM_TSAudit_ServerController.getTSCCountAudit();
		TSCCount = SRM_TSAudit_ServerController.getTSCCountInfo(TSCCountId);
		list<Trunk_Stock_Cycle_Count_Report__c> TSCCReports = SRM_TSAudit_ServerController.getTSCCReportInfo(TSCCountId);
		TSCCReports = SRM_TSAudit_ServerController.getTSCCReportInfoOptional(TSCCountId);
		TSCC.Trunk_Stock_Cycle_Count__c = TSCCountId;
		TSCC.Submitted__c = true;

		list<Trunk_Stock_Cycle_Count_Report__c> TSCCReportCreatedList = new list<Trunk_Stock_Cycle_Count_Report__c>();
		TSCCReportCreatedList.add(TSCC);
		TSCCReportCreatedList = SRM_TSAudit_ServerController.createNewTSCCReport(TSCCReportCreatedList);
		TSCC.Id = TSCCReportCreatedList[0].Id;
		SRM_TSAudit_ServerController.updateTSCCReport(TSCC);
		list<Trunk_Stock_Cycle_Count_Item__c> TSCCItems = SRM_TSAudit_ServerController.getTSCCReportItemInfo(TSCC.Id); 
		SRM_TSAudit_ServerController.updateTSCCReportItems(TSCCItems);
		Trunk_Stock_Cycle_Count_Item__c TSCCItem = new Trunk_Stock_Cycle_Count_Item__c (Trunk_Stock_report__c  = TSCC.Id);
		insert TSCCItem;
		SRM_TSAudit_ServerController.updateTSCCItemToSFDC(TSCCItem);
		TSCCReports =  SRM_TSAudit_ServerController.getListSumLotInv();
		List<User> repTDSUsers =  SRM_TSAudit_ServerController.getListUserCycleCount();
		EmailTemplate email = SRM_TSAudit_ServerController.getTSCCEmailTemplate();
		email = SRM_TSAudit_ServerController.getTSAuditReminderEmailTemplate();
		SRM_TSAudit_ServerController.saveTSCCEmailTemplate(email);
		saleUser = SRM_TSAudit_ServerController.getCurrentUser();
		saleUser = SRM_TSAudit_ServerController.getrepTDSInformation(saleUser.Id);
		list<Lot_Information__c> lotinfo = SRM_TSAudit_ServerController.getLotInfomation();
		SRM_TSAudit_ServerController.submitTSCCount(TSCC,TSCCItems);
		repTDSUsers = SRM_TSAudit_ServerController.getCSUsers();
		String[] sendToAddresses = new String[]{'test@example.com', 'test1@example.com'};
        String[] bCCAddresses = new String[]{'test@example.com', 'test1@example.com'};
        String subject = 'I am a subject.';
        String emailBody = 'I am a body.';
		SRM_TSAudit_ServerController.sendAnEmail(sendToAddresses, bCCAddresses, subject, emailBody);

		Lot_Inventory__c admintrunk = new Lot_Inventory__c();
		User AdminUser = [SELECT Id FROM User Where Profile.Name = 'System Administrator' and IsActive = True Order By createdDate LIMIT 1];
		admintrunk.On_Hand_Qty__c = 1;
		admintrunk.OwnerId = AdminUser.ID;
		admintrunk.Name = 'SRM0000';
		insert admintrunk;

		TSCCReports = SRM_TSAudit_ServerController.getListAdminTrunk();
		TSCCItems = SRM_TSAudit_ServerController.getPreviousTSCCitem(TSCCItem.Id);

	//Test submitTSCCount + update DiscrepancyPeriods
		//Submit 1st count
		TSCCItem.Lot_Number__c = '200775';
		TSCCItem.Counted_Qty__c = 1;
		TSCCItem.Qty_on_system__c = 6;
		TSCCItem.Id = null;
		TSCCItem.period_discrepancy__c = '12345678901234567890';
		TSCCItem.Note__c = 'It is a long message====================================================================================================';
		TSCCItem.Note__c = TSCCItem.Note__c + '====================================================================================================================================';
		TSCCItem.TSCCItem_ID__c = 'Test unique item ID';
		TSCCItems.add(TSCCItem);
		TSCC.Total_Lot_Discrepancies__c = 1;
		TSCC.Submitted__c = true;
		SRM_TSAudit_ServerController.submitTSCCount(TSCC,TSCCItems);

		//Submit 2nd count
		TSCCount.Id = null;
		TSCCountId =  SRM_TSAudit_ServerController.createNewTSCCount(TSCCount);
		TSCC.Trunk_Stock_Cycle_Count__c = TSCCountId;
		TSCC.Id = null;
		TSCC.Submitted__c = false;
		TSCC.OwnerId = saleUser.ID;
		Location__c salelocation = new Location__c();
		salelocation.OwnerId = saleUser.ID;
		salelocation.Name = 'Test';
		insert salelocation;
		list<Trunk_Stock_Cycle_Count_Report__c> TSCCReportCreatedList1 = new list<Trunk_Stock_Cycle_Count_Report__c>();
		TSCCReportCreatedList1.add(TSCC);
		TSCCReportCreatedList1 = SRM_TSAudit_ServerController.createNewTSCCReport(TSCCReportCreatedList1);
		TSCC.Id = TSCCReportCreatedList1[0].Id;
		TSCC = SRM_TSAudit_ServerController.getPendingTSCC(TSCC.Id);
		TSCCItems[0].Id = null;
		TSCCItems[0].Counted_Qty__c = 1;
		TSCCItems[0].Qty_on_system__c = 3;
		TSCC.Total_Lot_Discrepancies__c = 1;
		TSCC.Submitted__c = true;
		SRM_TSAudit_ServerController.submitTSCCount(TSCC,TSCCItems);

		TSCCItems[0].Id = null;
		TSCCItems[0].Counted_Qty__c = 1;
		TSCCItems[0].Qty_on_system__c = 3;

		SRM_TSAudit_ServerController.submitTSCCount(TSCC,TSCCItems);
		TSCC.Id = SRM_TSAudit_ServerController.removeTSCCReportitems(TSCC);
		TSCC.Id = SRM_TSAudit_ServerController.deleteTSCCR(TSCC);

		SRM_TSAudit_ServerController.NewTSA_CCUSers_List();
		SRM_TSAudit_ServerController.getTSCCEmailTemplate2();

	//End of Test submitTSCCount + update DiscrepancyPeriods

	}
}