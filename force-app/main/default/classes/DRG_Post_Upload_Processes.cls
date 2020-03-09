public without sharing class DRG_Post_Upload_Processes {

	public static void postUploadProcess(){
		//PROCESS PHYSICIANS
		      // Connects Contacts to DRG_Physician__c
		      // Parses DRG_Physician__c Names
		DRG_Post_Upload_Physician_Batch_Launcher();

		//PROCESS FACILITIES
		     // Connects Accounts to DRG_Facility__c
		List<DRG_Facility__c> drgFaList = [SELECT AccountId__c, Medicare_Provider_Id__c FROM DRG_Facility__c];
		DRG_Post_Upload_Facility_PopulateAccountId(drgFaList);

		//PROCESS PROCEDURES
		     // Connects DRG_Procedure__c to DRG_Facility__c
		     // Connects DRG_Procedure__c ro DRG_Physician__c
		DRG_Post_Upload_Procedure_Batch_Launcher();
		addNewContactsFromDRG_Batch_Launcher();     
	}

	/******************************************************************************************
	*******     DRG_Physcian__c POST UPLOAD PROCESSING    *************************************
	*******************************************************************************************/
	
	public static List<DRG_Physician__c> parsePhysicianNames(List<DRG_Physician__c> drgPhList){
		Set<String> npiSet = new Set<String>();
		for(DRG_Physician__c drgPh : drgPhList){
			npiSet.add(drgPh.NPI_Number__c);
		}
											
	 	// PARSE FULL NAME INTO FIRST MIDDLE AND LAST NAMES AND TO CONNECT PHYSICIAN DATA TO FACILITY DATA										
		for(DRG_Physician__c drgPh : drgPhList){

			String fullName = drgPh.Name;

			SYSTEM.DEBUG('FULL NAME = [' + fullName + ']');

			if(fullName != null){
				
				String[] parsedFullName = fullName.split(' ');
				Integer nameSegments = parsedFullName.size();

				SYSTEM.DEBUG('Name Segments = [' + nameSegments + ']');

				if(nameSegments == 1 || nameSegments == 0){
					drgPh.First_Name__c = parsedFullName[0];
					drgPh.Last_Name__c = parsedFullName[0];
				}
				else if(nameSegments == 2){
					drgPh.First_Name__c = parsedFullName[0];
					drgPh.Last_Name__c = parsedFullName[1];
				}
				else if(nameSegments == 3){
					drgPh.First_Name__c = parsedFullName[0];
					drgPh.Middle_Name__c = parsedFullName[1];
					drgPh.Last_Name__c = parsedFullName[2];
				}
				else{
					Integer i = nameSegments - 1;
					drgPh.First_Name__c = parsedFullName[0];
					drgPh.Middle_Name__c = parsedFullName[1];
					String lastName = parsedFullName[i];
					while(i > 2){
						i--;
						lastName = parsedFullName[i] + ' ' + lastName;
						
					}
					drgPh.Last_Name__c = lastName;
				}
			}
		}	
		return drgPhList;
	}




	public static List<DRG_Physician__c> populateContactIdOnDrgPhysician(List<DRG_Physician__c> drgPhList){

		Set<String> npiSet = new Set<String>();
		for(DRG_Physician__c drgPh : drgPhList){
			npiSet.add(drgPh.NPI_Number__c);
		}

		Map<String, Id> npiToContactMap = new Map<String, Id>();
		List<Contact> cList = [SELECT Id, NPI_Number__c FROM Contact WHERE NPI_Number__c IN : npiSet];
		for(Contact c : cList){
			npiToContactMap.put(c.NPI_Number__c, c.Id);
		}

		for(DRG_Physician__c drgPh : drgPhList){
			if(npiToContactMap.get(drgPh.NPI_Number__c) != null){
				drgPh.ContactId__c = npiToContactMap.get(drgPh.NPI_Number__c);
			}
		}
		return drgPhList;
	}





	public static void DRG_Post_Upload_Physician_Batch_Launcher(){
		String query = 'SELECT ContactId__c,First_Name__c,Id,Last_Name__c,Legal_Business_Name__c,Middle_Name__c,Name,NPI_Number__c,Postal_Code__c,Primary_Specialty__c,State_Provence__c FROM DRG_Physician__c';

		DRG_Post_Upload_Physician_Batch m = new DRG_Post_Upload_Physician_Batch(query);
		Database.executeBatch(m,200);
	}




	/******************************************************************************************
	*******     DRG_Facility__c POST UPLOAD PROCESSING    *************************************
	*******************************************************************************************/	
	public static void DRG_Post_Upload_Facility_PopulateAccountId(List<DRG_Facility__c> drgFaList){
		Set<String> provIdSet = new Set<String>();
		for(DRG_Facility__c drgFa : drgFaList){
			provIdSet.add(drgFa.Medicare_Provider_ID__c);
		}

		Map<String, Id> provIdToAcctIdMap = new Map<String,Id>();
		List<Account> aList = [SELECT Id, Medicare_Provider_Id__c FROM Account WHERE Medicare_Provider_Id__c IN : ProvIdSet];
		for(Account a : aList){
			provIdToAcctIdMap.put(a.Medicare_Provider_Id__c, a.Id);
		}

		for(DRG_Facility__c drgFa : drgFaList){
			if(provIdToAcctIdMap.get(drgFa.Medicare_Provider_ID__c) != null){
				drgFa.AccountId__c = provIdToAcctIdMap.get(drgFa.Medicare_Provider_ID__c);
			}
		}
		update drgFaList;
	}




	/******************************************************************************************
	*******     DRG_Procedure__c POST UPLOAD PROCESSING    *************************************
	*******************************************************************************************/
	public static void connectDRGProcedures(List<DRG_Procedure__c> drgPrList){
		
		Set<String> npiSet = new Set<String>();
		Set<String> provIdSet = new Set<String>();
		
		for(DRG_Procedure__c drgPr : drgPrList){
			npiSet.add(drgPr.Physician_NPI__c);
			provIdSet.add(drgPr.Medicare__c);
		}


		Map<String,Id> npiMap = new Map<String, Id>();
		List<DRG_Physician__c> drgPhList = [SELECT Id, NPI_Number__c FROM DRG_Physician__c WHERE NPI_Number__c IN : npiSet];
		for(DRG_Physician__c drgPh : drgPhLIst){
			npiMap.put(drgPh.NPI_Number__c, drgPh.Id);
		}

		Map<String, Id> provMap = new Map<String, Id>();
		List<DRG_Facility__c> drgFaList = [SELECT Id, Medicare_Provider_Id__c FROM DRG_Facility__c WHERE Medicare_Provider_Id__c IN : provIdSet];
		for(DRG_Facility__c drgFa : drgFaList){
			provMap.put(drgFa.Medicare_Provider_ID__c, drgFa.Id);
		}

		for(DRG_Procedure__c drgPr : drgPrList){
			if(npiMap.get(drgPr.Physician_NPI__c) != null){
				drgPr.DRG_Physician_Id__c = npiMap.get(drgPr.Physician_NPI__c);
			}
			if(provMap.get(drgPr.Medicare__c) != null){
				drgPr.DRG_Facility_Id__c = provMap.get(drgPr.Medicare__c);
			}
		}

		update drgPrList;
		
	}





	public static void DRG_Post_Upload_Procedure_Batch_Launcher(){
		String query = 'SELECT CAS__c,CEA__c,DRG_Facility_Id__c,DRG_Physician_Id__c,DRG_Procedure_ID__c,Id,Medicare__c,Name,Period__c,Physician_NPI__c,Total__c, CreatedDate FROM DRG_Procedure__c';

		DRG_Post_Upload_Procedure_Batch m = new DRG_Post_Upload_Procedure_Batch(query);
		Database.executeBatch(m,200);
	}




	public static void addNewContactsFromDRG_Batch_Launcher(){
		String query = 'SELECT DRG_Facility_Id__c,DRG_Facility_Id__r.AccountId__c,DRG_Physician_Id__c,Id,Name,DRG_Physician_Id__r.NPI_Number__c FROM DRG_Procedure__c WHERE DRG_Facility_Id__r.AccountId__c <> null';
		addNewContactsFromDRG_Batch m = new addNewContactsFromDRG_Batch(query);
		Database.executeBatch(m,200);
	}


	public static void addNewContactsFromDRG(List<DRG_Procedure__c> drgProcList){
		Map<String, Id> npiAccountMap = new Map<String, Id>();
		Set<String> npiAcctIndecies = new Set<String>();

		for(DRG_Procedure__c drgPr : drgProcList){
			if(drgPr.DRG_Physician_Id__r.NPI_Number__c != null){
				npiAccountMap.put(drgPr.DRG_Physician_Id__r.NPI_Number__c, drgPr.DRG_Facility_Id__r.AccountId__c);
				String s = drgPr.DRG_Physician_Id__r.NPI_Number__c + '-' + drgPr.DRG_Facility_Id__r.AccountId__c;
				npiAcctIndecies.add(s);
				SYSTEM.DEBUG('NPI ACCT INDICIES ADD = [' + s + ']');
			}	
		}

		Map<String,Id> existingNpiAccountMap = new Map<String,Id>();
		List<Contact> contList = [SELECT NPI_Number__c, AccountId FROM Contact WHERE NPI_Number__c IN : npiAccountMap.Keyset()];
		for(Contact c : contList){
			existingNpiAccountMap.put(c.NPI_Number__c, c.AccountId);
		}

		Set<String> npiHAIndicies = new Set<String>();
		List<Hospital_Affiliation__c> haList = [SELECT Physician__r.NPI_Number__c, Hospital__c FROM Hospital_Affiliation__c WHERE Physician__r.NPI_Number__c IN : npiAccountMap.Keyset()];
		for(Hospital_Affiliation__c ha : haList){
			String s = ha.Physician__r.NPI_Number__c + '-' + ha.Hospital__c;
			npiHAIndicies.add(s);
		}

		Set<String> npiContactAdd = new Set<String>();
		for(String s : npiAcctIndecies){
			String[] sSet = s.split('-');
			String evalNPI = sSet[0];
			Id evalAcct = sSet[1];

			if(!existingNpiAccountMap.keyset().contains(evalNPI)){
				npiContactAdd.add(evalNPI);
			}
		}

		//Create new contacts and track Hospital Associations created
		List<DRG_Physician__c> drgPhList = [SELECT ContactId__c,First_Name__c,Last_Name__c,Middle_Name__c,NPI_Number__c,Primary_Specialty__c FROM DRG_Physician__c WHERE NPI_Number__c IN : npiContactAdd];
		id rtId = [SELECT Id FROM RecordType WHERE Name = 'Physician' AND sObjectType = 'Contact' LIMIT 1].Id;
		List<Contact> newContacts = new List<Contact>();
		for(DRG_Physician__c drgPh : drgPhList){
			Contact c = new Contact(FirstName = drgPh.First_Name__c, MiddleName = drgPh.Middle_Name__c,
									LastName = drgPh.Last_Name__c, NPI_Number__c = drgPh.NPI_Number__c,
									Primary_Specialty__c = drgPh.Primary_Specialty__c, RecordTypeId = rtId,
									AccountId = npiAccountMap.get(drgPh.NPI_Number__c));
			newContacts.add(c);
		}
		Database.DMLOptions dml = new Database.DMLOptions();
		dml.DuplicateRuleHeader.AllowSave = true; 

		List<Database.SaveResult> sr = Database.insert(newContacts, dml);
	
		upsert newContacts;

		Map<String, Id> newContactNpiMap = new Map<String, Id>();
		for(Contact c : newContacts){
			String s = c.NPI_Number__c + '-' + c.AccountId;
			npiHAIndicies.add(s);
			newContactNpiMap.put(c.NPI_Number__c, c.Id);
		}

		//Update the DRG_Physician__c Record
		for(DRG_Physician__c drgPh : drgPhList){
			drgPh.ContactId__c = newContactNpiMap.get(drgPh.NPI_Number__c);
		}
		update drgPhList;

		Map<String, Id> contactMap = new Map<String, Id>();
		List<Contact> existingContacts = [SELECT Id, NPI_Number__c FROM Contact WHERE NPI_Number__c IN : npiAccountMap.keyset() AND NPI_Number__c <> null];
		for(Contact c : existingContacts){
			contactMap.put(c.NPI_Number__c, c.Id);
		}

		List<Hospital_Affiliation__c> newHAList = new List<Hospital_Affiliation__c>();
		for(String s : npiAcctIndecies){
			if(!npiHAIndicies.contains(s)){
				String[] stringSet = s.split('-');
				SYSTEM.DEBUG('STRING SET = [' + stringSet + ']');
				String npiNo = stringSet[0];
				Id acctId = stringSet[1];
				Id contactId = contactMap.get(npiNo);
				Hospital_Affiliation__c newHA = new Hospital_Affiliation__c(Hospital__c = acctId, Physician__c = contactId);
				newHAList.add(newHA);
			}
		}
		insert newHAList;
	}


}