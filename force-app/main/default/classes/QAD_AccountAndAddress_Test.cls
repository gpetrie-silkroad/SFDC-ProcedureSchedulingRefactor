@isTest(SeeAllData = false)
private class QAD_AccountAndAddress_Test {
	
	@isTest static void qad_AccountAndAddressInsertTest() {

		UnitTestDataFactory.createTestUsers();
		UnitTestDataFactory.createTestTerritories();
		UnitTestDataFactory.qad_createQadSourcedAccounts();
		UnitTestDataFactory.qad_createQadSourceAddresses();
 
 		Set<String> stringSet = new Set<String>();

 		Integer i = 1;
		
		List<Account> aList = [SELECT Id, Credit_Terms__c, QAD_cm_addr__c, IQMS_Customer_Number__c, QAD_cm_slspsn__c, BillingStreet FROM Account WHERE (NOT QAD_cm_addr__c LIKE '%S%') AND (NOT QAD_cm_addr__c LIKE '%B%') AND (NOT QAD_cm_addr__c LIKE '500014') ORDER BY QAD_cm_addr__c];
		for(Account a : aList){
			

			//a.QAD_cm_addr__c = String.valueOf(i);
			//a.IQMS_Customer_Number__c = String.valueOf(i);
			//i++;

				if(a.QAD_cm_slspsn__c == 'AD00001-AM00002'){
					a.QAD_cm_slspsn__c = 'AD00002-AM00001-TDS0001';
				}
				else if(a.QAD_cm_slspsn__c == 'AD00002'){
					a.QAD_cm_slspsn__c = 'AD00001-AM00002-TDS0001';
				}
				else if(a.QAD_cm_slspsn__c == 'AD00002-AM00003-TDS0001'){
					a.QAD_cm_slspsn__c = 'AD00003-AM00004-TDS0002';

				}
				else if(a.QAD_cm_slspsn__c == null){
					a.QAD_cm_slspsn__c = 'AD00001-AM00002-TDS0001';

				}
			a.IQMS_Customer_Number__c = a.QAD_cm_addr__c;	
			//SYSTEM.DEBUG('IQMS CUSTOMER NUMBER = [' + a.IQMS_Customer_Number__c + ']');

		}
		for(account a: aList){
			SYSTEM.DEBUG('Account Id = [' + a.Id + '] QAD_cm_addr__c = [' + a.QAD_cm_addr__c + '] Billing Street = [' + a.BillingStreet + ']');
		}
		update aList;

		List<AccountTeamMember> acctTeamList = [SELECT Id, UserId, AccountId, TeamMemberRole, AccountAccessLevel FROM AccountTeamMember];

		delete acctTeamList;

  		//SYSTEM.DEBUG('*********');

		List<Account> a1List = [SELECT Id, Credit_Terms__c, Name, Therapy_Development_Specialist_User__r.QAD_Territory_Id__c, QAD_cm_slspsn__c FROM Account];
		for(Account a : a1List){

			//SYSTEM.DEBUG('Account A1 Name = [' + a.Name + '] TDS U = [' + a.Therapy_Development_Specialist_User__r.QAD_Territory_Id__c +']');
			
			if(a.Name == 'QAD Test Account 1'){
				a.QAD_cm_slspsn__c = 'AD00003-AM00003-TDS0001';
				a.Name = 'QAD Test Account 1a';
			}
		}

		update aList;
	}
	

	
}