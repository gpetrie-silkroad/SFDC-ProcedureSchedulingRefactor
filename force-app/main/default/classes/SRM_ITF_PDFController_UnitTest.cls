@isTest(SeeAllData=false)
private class SRM_ITF_PDFController_UnitTest
{
	@isTest static void ITFPDFControllerTest() {
		Inventory_Transfer_Form__c testITF = new Inventory_Transfer_Form__c();
		UnitTestDataFactory.createTestUsers();
		//UnitTestDataFactory.createTestIqmsArcustos();
		//UnitTestDataFactory.createTestIqmsBillTos();
		//UnitTestDataFactory.createTestIqmsShipTos();
		//UnitTestDataFactory.createTestContacts();
		//ParseIqmsDataTable.populateAccountAndContactObjects();
		Account newAccount = new Account();
		newAccount.name = 'Test Account';
		insert newAccount;
        Id userId = [SELECT ID FROM User LIMIT 1].Id;
        Id acctId = [SELECT Id FROM Account LIMIT 1].Id;        
		testITF.Name = 'test';
		testITF.Transfer_Date__c = Date.newInstance(2016, 12, 9);
		testITF.ITF_ID__c = 'Tester';
        testITF.other_qualified_srm_employee__c = userId;
        testITF.customer_to__c = acctId;
        testITF.customer_from__c = acctId;
		upsert	testITF;
		Test.startTest();
		PageReference pageRef = Page.SRM_ITF_PDFCustomerCopy;
		pageRef.getParameters().put('id', String.valueOf(testITF.Id));
		pageRef.getParameters().put('iTFPDFType', 'MTFLogistic');
		Test.setCurrentPage(pageRef);
        SRM_ITF_PDFController controller = new SRM_ITF_PDFController();
        
        testITF.srm_tds__c = userId;       
		upsert	testITF;
		PageReference pageRef2 = Page.SRM_ITF_PDFCustomerCopy;
		pageRef2.getParameters().put('id', String.valueOf(testITF.Id));
		pageRef2.getParameters().put('iTFPDFType', 'MTF-TSR-CS');
		Test.setCurrentPage(pageRef2);
        controller = new SRM_ITF_PDFController();
        
        testITF.srm_am__c = userId;        
		upsert	testITF;
		PageReference pageRef3 = Page.SRM_ITF_PDFCustomerCopy;
		pageRef3.getParameters().put('id', String.valueOf(testITF.Id));
		Test.setCurrentPage(pageRef3);
        controller = new SRM_ITF_PDFController();        
		Test.StopTest();
	}
}