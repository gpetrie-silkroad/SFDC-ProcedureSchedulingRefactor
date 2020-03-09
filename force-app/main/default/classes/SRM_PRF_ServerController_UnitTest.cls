@isTest(SeeAllData=true)
private class SRM_PRF_ServerController_UnitTest
{	
	@isTest static void test_method_one()
	{
		Contact physicianInfo =[SELECT Id 
								FROM Contact
								WHERE 
									Not RecordType.Name like 'Contact'
								LIMIT 1];

		Id accountID;
		list<Account> accountlist = SRM_PRF_ServerController.getHositalInfo(physicianInfo.Id, accountID);

		list<Contact> contactList = SRM_PRF_ServerController.getSRMProctors();

		List<RecordType> PRRecordTypeIDs = SRM_PRF_ServerController.getPFRecordTypeID();

		List<User> TESLAUsers = SRM_PRF_ServerController.getTESLAUsers();

		User currentUser = [SELECT Id
							From User
							WHERE 
								ManagerId != null
								and IsActive = true 
							LIMIT 1];
		System.runAs(currentUser)
		{
			currentUser = SRM_PRF_ServerController.getCurrentUser();
			Proctor_Form__c PRF = new Proctor_Form__c();
			PRF.Name = 'test';
			PRF.Physician_to_be_proctored__c = physicianInfo.Id;
			PRF.Proctor_Form_ID__c = '12346a';
			PRF.Stage__c = 'AD Reviewing';
			PRF.Proctor_Request_Date__c = Date.TODAY();
			accountID = SRM_PRF_ServerController.upsertPRForm(PRF);
			physicianInfo = SRM_PRF_ServerController.getContactInfo(physicianInfo.Id);			
		}
	}	
}