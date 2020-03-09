public without sharing class SRM_PRF_ServerController {
	@AuraEnabled 
	public static Contact getContactInfo(Id contactID)
	{
		Contact physicianInfo = [SELECT Id, FirstName, LastName, Name, AccountId, is_External_Proctor__c, is_Internal_Proctor__c FROM Contact WHERE Id =: contactID];

		List<Proctor_Form__c> listPRF =[SELECT Id, Hospital_Name__r.Name, Proctor_Request_Date__c, Status__c 
										FROM Proctor_Form__c
										WHERE 
											Physician_to_be_proctored__c =: contactID
											AND Stage__c != 'Completed'
											AND Proctor_Request_Date__c >= TODAY
										ORDER BY Proctor_Request_Date__c DESC NULLS LAST
										LIMIT 1];
		if(listPRF.size()>0)
		{
			physicianInfo.Birthdate = listPRF[0].Proctor_Request_Date__c;
			physicianInfo.OwnerId = listPRF[0].Id;
			physicianInfo.Email = listPRF[0].Status__c;
			physicianInfo.Department = listPRF[0].Hospital_Name__r.Name;
		}

		return physicianInfo;
	}

	@AuraEnabled 
	public static list<Account> getHositalInfo(Id contactID, Id accountID)
	{
		List<Hospital_Affiliation__c> haList = [SELECT Id, Physician__c, Hospital__c FROM Hospital_Affiliation__c WHERE Physician__c = : contactID];

		Set<Id> hospitalIdSet = new Set<Id>();
		if(accountID == null)
		{
			hospitalIdSet.add(accountID);
		}

		for(Hospital_Affiliation__c ha : haList){
			hospitalIdSet.add(ha.Hospital__c);
		}


		List<Account> AccountList =[SELECT Id, Name 
									FROM Account
									WHERE Id IN : hospitalIdSet
									ORDER BY Name Asc];

		return AccountList;
	}

	@AuraEnabled 
	public static list<Contact> getSRMProctors()
	{
		List<Contact> SRMProctors =[SELECT 
										Id, FirstName, LastName, Name,
										Account.BillingCity, Account.BillingState
									FROM 
										Contact 
									WHERE
										RecordType.Name = 'Physician'
										AND
											(is_External_Proctor__c = true
											OR is_Internal_Proctor__c = true)
									ORDER BY 	
										LastName Asc];

		return SRMProctors;
	}

	@AuraEnabled
	public static User getCurrentUser(){
		Id curUserId = UserInfo.getUserId();
		User currentUser = [SELECT 
								Id, FirstName, LastName, ManagerId,
								Field_Responsibility__c, Profile.Name, SenderEmail,
								Email, MobilePhone, Title, Employee_ID__c
							FROM User 
							WHERE Id = : curUserId];
		return currentUser;
	}

	@AuraEnabled
	public static List<RecordType> getPFRecordTypeID(){
		List<RecordType> PRRecordTypeIDs = [SELECT
												Id, DeveloperName
											FROM
												RecordType
											WHERE
												SobjectType = 'Proctor_Form__c'];
		return PRRecordTypeIDs;
	}

	@AuraEnabled
	public static List<User> getTESLAUsers()
	{
		List<User> TESLAUsers =[SELECT
									City,Id,Name,State 
								FROM 
									User
								WHERE 
									TESLA__c = true
								ORDER BY 
									Name ASC NULLS FIRST];
		return TESLAUsers;
	}

	@AuraEnabled
	public static Id upsertPRForm(Proctor_Form__c PRF){
		List<Proctor_Form__c> listPRF = new list<Proctor_Form__c>();
		listPRF.add(PRF);

		Database.UpsertResult[] results = Database.upsert(listPRF, Proctor_Form__c.Proctor_Form_ID__c);

		if(results[0].isSuccess())
		{
			if(results[0].isCreated())
			{
				// create the new approval request to submit
	            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
	            // String message = 'Submitted for approval. Please approve a proctor request for ' + PRF.Physician_to_be_Proctored_Name__c;
	            // message = message + ' on '+ PRF.Proctor_Request_Date__c.format() + '.';
	            // req.setComments(message);
	            req.setObjectId(results[0].Id);
				
	            // submit the approval request for processing
	            Approval.ProcessResult result = Approval.process(req);
	            PRF.Id = results[0].Id;
	            PRF.ApprovalProcessID__c = String.valueOf(result.getNewWorkitemIds());
	            PRF.ApprovalProcessID__c = PRF.ApprovalProcessID__c.replace('(','').replace(')','');
	            update PRF;
			}
		}

		return results[0].Id;
	}
}