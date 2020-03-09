@isTest
private class DRG_HospitalLeadForm_LightningCont_Test {
	
	@isTest static void test_postUploadProcess() {
		UnitTestDataFactory.createDRGFacilityRecords();
		UnitTestDataFactory.createDRGPhysicianRecords();
		UnitTestDataFactory.createDRGProcedureRecords();
		UnitTestDataFactory.createDRGLinkedAccountsAndContacts();

		Test.startTest();
		DRG_Post_Upload_Processes.postUploadProcess();
		Test.stopTest();
	}





	@isTest static void TestAddNewContactsFromDRG_Batch_Launcher() {
		UnitTestDataFactory.createDRGFacilityRecords();
		UnitTestDataFactory.createDRGPhysicianRecords();
		UnitTestDataFactory.createDRGProcedureRecords();
		UnitTestDataFactory.createDRGLinkedAccountsAndContacts();

		List<DRG_Physician__c> drgPhList = [SELECT ContactId__c,First_Name__c,Id,Last_Name__c,Legal_Business_Name__c,Middle_Name__c,Name,NPI_Number__c,Postal_Code__c,Primary_Specialty__c,State_Provence__c FROM DRG_Physician__c];
		List<DRG_Physician__c> drgPh1 = DRG_Post_Upload_Processes.parsePhysicianNames(drgPhList);
		List<DRG_Physician__c> drgPh2 = DRG_Post_Upload_Processes.populateContactIdOnDrgPhysician(drgPh1);
		update drgPh2;

		List<DRG_Facility__c> drgFaList = [SELECT AccountId__c, Medicare_Provider_Id__c FROM DRG_Facility__c];
		Drg_Post_Upload_Processes.DRG_Post_Upload_Facility_PopulateAccountId(drgFaList);


		List<DRG_Procedure__c> drgPrList = [SELECT CAS__c,CEA__c,DRG_Facility_Id__c,DRG_Physician_Id__c,DRG_Procedure_ID__c,Id,Medicare__c,Name,Period__c,Physician_NPI__c,Total__c, CreatedDate FROM DRG_Procedure__c];
		Drg_Post_Upload_Processes.connectDRGProcedures(drgPrList);

		List<DRG_Procedure__c> drgPrList1 = [SELECT DRG_Facility_Id__c,DRG_Facility_Id__r.AccountId__c,DRG_Physician_Id__c,Id,Name,DRG_Physician_Id__r.NPI_Number__c FROM DRG_Procedure__c WHERE DRG_Facility_Id__r.AccountId__c <> null];
		
		Test.startTest();
			DRG_Post_Upload_Processes.addNewContactsFromDRG_Batch_Launcher();
		Test.stopTest();

	}






	@isTest static void test_DRG_HospitalLeadForm_LightningController() {
		UnitTestDataFactory.createDRGFacilityRecords();
		UnitTestDataFactory.createDRGPhysicianRecords();
		UnitTestDataFactory.createDRGProcedureRecords();
		UnitTestDataFactory.createDRGLinkedAccountsAndContacts();

		List<DRG_Physician__c> drgPhList = [SELECT ContactId__c,First_Name__c,Id,Last_Name__c,Legal_Business_Name__c,Middle_Name__c,Name,NPI_Number__c,Postal_Code__c,Primary_Specialty__c,State_Provence__c FROM DRG_Physician__c];
		List<DRG_Physician__c> drgPh1 = DRG_Post_Upload_Processes.parsePhysicianNames(drgPhList);
		List<DRG_Physician__c> drgPh2 = DRG_Post_Upload_Processes.populateContactIdOnDrgPhysician(drgPh1);
		update drgPh2;

		List<DRG_Facility__c> drgFaList = [SELECT AccountId__c, Medicare_Provider_Id__c FROM DRG_Facility__c];
		Drg_Post_Upload_Processes.DRG_Post_Upload_Facility_PopulateAccountId(drgFaList);


		List<DRG_Procedure__c> drgPrList = [SELECT CAS__c,CEA__c,DRG_Facility_Id__c,DRG_Physician_Id__c,DRG_Procedure_ID__c,Id,Medicare__c,Name,Period__c,Physician_NPI__c,Total__c, CreatedDate FROM DRG_Procedure__c];
		Drg_Post_Upload_Processes.connectDRGProcedures(drgPrList);

		List<DRG_Procedure__c> drgPrList1 = [SELECT DRG_Facility_Id__c,DRG_Facility_Id__r.AccountId__c,DRG_Physician_Id__c,Id,Name,DRG_Physician_Id__r.NPI_Number__c FROM DRG_Procedure__c WHERE DRG_Facility_Id__r.AccountId__c <> null];
		DRG_Post_Upload_Processes.addNewContactsFromDRG(drgPrList1);

		List<DRG_Period_Headers__c> periodHeaderList = new List<DRG_Period_Headers__c>();
		DRG_Period_Headers__c ph1 = new DRG_Period_Headers__c(Name = 'Period1', Value__c = '2015', Period__c = 'Period1');
		DRG_Period_Headers__c ph2 = new DRG_Period_Headers__c(Name = 'Period2', Value__c = '2016', Period__c = 'Period2');
		DRG_Period_Headers__c ph3 = new DRG_Period_Headers__c(Name = 'Period3', Value__c = '2017', Period__c = 'Period3');
		DRG_Period_Headers__c ph4 = new DRG_Period_Headers__c(Name = 'Period4', Value__c = '2018', Period__c = 'Period4');
		periodHeaderList.add(ph1);
		periodHeaderList.add(ph2);
		periodHeaderList.add(ph3);
		periodHeaderList.add(ph4);
		insert periodHeaderList;


 
		User currentUser = DRG_HospitalLeadForm_LightningController.getCurrentUser();
		List<Account> accountList = DRG_HospitalLeadForm_LightningController.acctList();

		String[] stateList = DRG_HospitalLeadForm_LightningController.getStateList();

		String pd1 = DRG_HospitalLeadForm_LightningController.getPd1();
		String pd2 = DRG_HospitalLeadForm_LightningController.getPd2();
		String pd3 = DRG_HospitalLeadForm_LightningController.getPd3();
		String pd4 = DRG_HospitalLeadForm_LightningController.getPd4();

		Test.startTest();
			DRG_HospitalLeadForm_LightningController.getProceduresByCity('AZ',True,True,'Physician');
			DRG_HospitalLeadForm_LightningController.getProceduresByCity('AZ',True,True,'Hospital');

			DRG_HospitalLeadForm_LightningController.setOnlyOneCity('AZ', 'Tuscon');

			DRG_HospitalLeadForm_LightningController.getProceduresByNetwork('AZ', 'Tuscon', True, 'Physician');
			DRG_HospitalLeadForm_LightningController.getProceduresByNetwork('AZ', 'Tuscon', False, 'Hospital');

			DRG_HospitalLeadForm_LightningController.setOnlyOneNetwork('AZ', 'Tuscon', 'MedStar Health');
			DRG_HospitalLeadForm_LightningController.getProceduresByFacility('AZ', 'Tuscon', 'Tri State Health', True, 'Physician');
			DRG_HospitalLeadForm_LightningController.getProceduresByFacility('AZ', 'Tuscon', 'MedStar Health', False, 'Hospital');

			DRG_Facility__c drgFa = [SELECT Name, Id FROM DRG_Facility__c WHERE State_Provence__c = 'AZ' AND  Medicare_Provider_ID__c = '999003' LIMIT 1];

			DRG_HospitalLeadForm_LightningController.setOnlyOneFacility(drgFa.Name, drgFa.Id);
			DRG_HospitalLeadForm_LightningController.getFacilityRecord(drgFa.Id);
			
			List<DRG_HospitalLeadForm_LightningController.ProcedureCountWrapper> pcwList = DRG_HospitalLeadForm_LightningController.getProceduresByFacilityFromSearch('%Test Hospital Facility%', True);																	
			pcwList.sort();

			DRG_HospitalLeadForm_LightningController.getProceduresByPhysician(drgFa.Id, True);

			DRG_Physician__c drgPh = [SELECT ID, Name FROM DRG_Physician__c LIMIT 1];
			DRG_HospitalLeadForm_LightningController.setOnlyOnePhysician(drgPh.Id);

			DRG_HospitalLeadForm_LightningController.getProceduresByPhysicianFromSearch('%A%');

			DRG_Facility__c drgFa1 = [SELECT Name, Id FROM DRG_Facility__c WHERE State_Provence__c = 'HI' LIMIT 1];
			DRG_HospitalLeadForm_LightningController.convertFacilityToOpportunity(drgFa1.Id);

			DRG_Procedure__c drgPr = [SELECT Id, DRG_Facility_Id__c, DRG_Physician_Id__c FROM DRG_Procedure__c WHERE DRG_Facility_Id__r.Name = 'Test Hospital Facility 999003' AND DRG_Physician_Id__r.Name = 'INGE CHARLEY' LIMIT 1];

			DRG_HospitalLeadForm_LightningController.convertPhysicianToOpportunity(drgPr.DRG_Physician_Id__c, drgPr.DRG_Facility_Id__c);

			Account acct = [SELECT Id FROM Account WHERE Medicare_Provider_ID__c = '999003' LIMIT 1];

			Contact regForm1 = new Contact(FirstName = 'OLLIE', MiddleName = 'T', LastName = 'AUSSIE', Primary_Specialty__c = 'Vasular Surgeon', Email = 'oaussie@yopmail.com', Phone = '6505551212', AccountId = acct.Id);

			DRG_HospitalLeadForm_LightningController.newOppId(regForm1, 'Test Hospital Facility 999003', '999003', 'Tri State Health', acct.Id, drgFa.Id);

		Test.stopTest();

	}
	

	
}