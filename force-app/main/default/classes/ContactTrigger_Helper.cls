public without sharing class ContactTrigger_Helper {

	// THIS HELPER METHOD MAKES SURE THAT ALL ACCOUNTS ASSOCIATED WITH A PHYSICIAN CONTACT (Contact RecordType)
	// HAVE A CORRESPONDING HOSPITAL AFFILIATION.  THIS HELPS MAINTAIN THE PHYSICIAN CONTACT
	// MANY - TO - MANY RELATIONSHIP WITH HOSPITALS (Account RecordType)

	public static void addAccountToHospitalAssociation(List<Contact> inputContList) {
		Set<String> contAcctString = new Set<String>();
		Set<Id> physicianStringSet = new Set<Id>();
		Id rtId = [SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND Name = 'Physician' LIMIT 1].Id;

		for(Contact c : inputContList){
			if(c.RecordTypeId == rtId && c.AccountId != null){
				contAcctString.add(c.Id + '-' + c.AccountId);
				physicianStringSet.add(c.Id);
			}
		}
		List<Hospital_Affiliation__c> haList = [SELECT ID, Physician__c, Hospital__c FROM Hospital_Affiliation__c WHERE Physician__c IN : physicianStringSet ORDER BY Physician__c ASC];
		Set<String> haStringSet = new Set<String>();

		for(Hospital_Affiliation__c ha : haList){
			haStringSet.add(ha.Physician__c + '-' + ha.Hospital__c);
		}


		Set<String> insertStringSet = new Set<String>();
		for(String s : contAcctString){
			if(!haStringSet.contains(s)){
				insertStringSet.add(s);
			}
		}
		
		List<Hospital_Affiliation__c> haInsertList = new List<Hospital_Affiliation__c>();
		for(String s : insertStringSet){
			List<String> splitList = s.split('-');
			String phys = splitList[0];
			String hosp = splitList[1];
			Hospital_Affiliation__c ha = new Hospital_Affiliation__c(Physician__c = phys, Hospital__c = hosp);
			haInsertList.add(ha);
		}
		insert haInsertList;
		
	}
}