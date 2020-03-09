public without sharing class AccountTrigger_Helper {
  
	public static void qad_beforeAccountUpsert(List<Account> accountList){

		//SET THE RECORD TYPE FOR THE ACCOUNT COMING FROM QAD=>Boomi
		Id rtId = [SELECT ID FROM RecordType WHERE Name = 'Customer' AND SObjectType = 'Account' LIMIT 1].Id;
		
		Id currentUserId = UserInfo.getUserId();

		for(Account a : accountList){
			if(a.QAD_cm_addr__c != null){
				a.RecordTypeId = rtId;
				a.OwnerId = currentUserId;
			}
		}

		//SET TERRITORY PERSONNEL AND TERRITORY
		qad_beforeUpsertSetTerritoryValues(accountList);

	}



	public static void syncAccountContactOwners(List<Account> accountList){
		Set<Id> idSet = new Set<Id>();
		for(Account a : accountList){
			idSet.add(a.Id);
		}

        List<Contact> contUpdateList = new List<Contact>();
        Boolean isUpdate = false;
        
		List<Contact> contactList = [SELECT Account.OwnerId, OwnerId, Id FROM Contact WHERE Account.Id IN : idSet];
		for(Contact c : contactList){
			if(c.OwnerId != c.Account.OwnerId){
				c.OwnerId = c.Account.OwnerId;
                contUpdateList.add(c);
                isUpdate = true;
			}
		} 
        if(isUpdate){
			update contUpdateList;
        }
	}




	public static void syncAccountOpportunityOwners(List<Account> accountList){
		Set<Id> idSet = new Set<Id>();
		for(Account a : accountList){
			idSet.add(a.Id);
		}

		List<Opportunity> oppUpdateList = new List<Opportunity>();
		Boolean isUpdate = false;        
        
		List<Opportunity> opportunityList = [SELECT Account.OwnerId, OwnerId, Id FROM Opportunity WHERE Account.Id IN : idSet AND StageName <>  'Closed Won' AND StageName <> 'Closed Lost'];
		for(Opportunity o : opportunityList){
			if(o.OwnerId != o.Account.OwnerId){
				o.OwnerId = o.Account.OwnerId;
                oppUpdateList.add(o);
                isUpdate = true;
			}
		} 
		
        if(isUpdate){
			SYSTEM.DEBUG('Attempting to update Opportunities');
			update oppUpdateList;
        }
	}




	public static void qad_beforeUpsertSetTerritoryValues(List<Account> accountList){
		
		
        // Collect a list of field representatives in the incoming records
		List<String> allFieldRepsReferenced = new List<String>();
		for(Account a : accountList){
			if(a.QAD_cm_slspsn__c != null & a.QAD_cm_slspsn__c != ''){
				List<String> stringList = a.QAD_cm_slspsn__c.split('-');
				allFieldRepsReferenced.addall(stringList);				
			}

		}

		// Turn the list of field representatives into a list of userId's and QAD Territory Ids
		List<User> indicatedUserList = [SELECT Id, FirstName, LastName, QAD_Territory_Id__c, IsActive FROM User WHERE QAD_Territory_Id__c IN : allFieldRepsReferenced AND IsActive = true ];

		// And make a map of QAD_cm_slspsn values to SFDC.User.Id values
		Map<String, Id> qad_to_sfdcIdMap = new Map<String,Id>();
		Map<String, String> qad_to_sfdcNameMap = new Map<String, String>();

		for(User u : indicatedUserList){
			qad_to_sfdcIdMap.put(u.QAD_Territory_Id__c, u.Id);
			qad_to_sfdcNameMap.put(u.QAD_Territory_Id__c, u.FirstName + ' ' + u.LastName);
		}


		List<Territory__c> tList = [SELECT Id, Name, QAD_AM_Id__c FROM Territory__c WHERE QAD_AM_ID__c IN : allFieldRepsReferenced AND isActive__c = TRUE];

		Map<String, String> terIdMap = new Map<String, String>();
		Map<String, String> terNmMap = new Map<String, String>();
		for(Territory__c t : tList){
			terIdMap.put(t.QAD_AM_Id__c, t.Id);
			terNmMap.put(t.QAD_AM_ID__c, t.Name);
		}

		Id SysAdminUserId = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1].Id;
 
		for(Account a : accountList){
			if(a.QAD_cm_slspsn__c != null & a.QAD_cm_slspsn__c != ''){

				List<String> slspsnList = a.QAD_cm_slspsn__c.split('-');

				Integer i = 0;
				for(String s : slspsnList){
					i++;

					//Separate the values to determine if 'AD', 'AM', or 'TDS'
					String ad;
					String am;
					String td;

					if(s.Left(2) == 'AD'){
						ad = s;
						// Lookup the User's Name and ID from User using maps
						a.Area_Director_Name__c = qad_to_sfdcNameMap.get(s);
						a.Area_Director_Id__c = qad_to_sfdcIdMap.get(s);

					}
					else if(s.Left(2) == 'AM'){
						am = s;

						// Lookup the User's Name and ID from User using maps
						a.Area_Manager_Name__c = qad_to_sfdcNameMap.get(s);
						a.Area_Manager_User__c = qad_to_sfdcIdMap.get(s);
						a.SFDCTerritoryId__c = terIdMap.get(s);
						a.Territory_Name__c = terNmMap.get(s);
						
						if(a.Area_Manager_User__c != null){
							a.OwnerId = a.Area_Manager_User__c;
						}
						else if(a.Area_Director_Id__c != null){
							a.OwnerId = a.Area_Director_Id__c;
						}
						else{
							a.OwnerId = SysAdminUserId;
						}
						
						// * * * * * *    N O W    D E A L    W I T H    T E R R I T O R I E S    * * * * * * * * * * * * *

					}
					else if(s.Left(2) == 'TD'){
						td = s;

						// Lookup the User's Name and ID from User using maps
						a.Therapy_Development_Specialist_Name__c = qad_to_sfdcNameMap.get(s);
						a.Therapy_Development_Specialist_User__c = qad_to_sfdcIdMap.get(s);
					}	
				

				}

			}
		}
	}



 

	public static void qad_setAccountTeamAfterUpsert(Map<Id, Account> oldAccountMap, Map<Id, Account> newAccountMap, Boolean isUpdate){
		
		List<AccountTeamMember> acctTeamList = [SELECT Id, UserId, AccountId, TeamMemberRole, AccountAccessLevel FROM AccountTeamMember WHERE AccountId IN: newAccountMap.keyset()];
		Map<String, AccountTeamMember> atmMap = new Map<String, AccountTeamMember>();
		for(AccountTeamMember atm : acctTeamList){
			String keyString;
			if(atm.TeamMemberRole == 'Area Manager'){
				keyString = atm.AccountId + '-AM';
			}
			else if(atm.TeamMemberRole == 'Area Director'){
				keyString = atm.AccountId + '-AD';
			}
			else if(atm.TeamMemberRole == 'Therapy Development Specialist'){
				keyString = atm.AccountId + '-TD';
			}
			atmMap.put(keyString, atm);
		}

		List<AccountTeamMember> newAtmList = new List<AccountTeamMember>();
		List<AccountTeamMember> delAtmList = new List<AccountTeamMember>();

		for(Account newAcct : newAccountMap.values()){

			Account oldAcct = new Account();
			if(isUpdate){
				if(oldAccountMap.get(newAcct.Id) != null){
					oldAcct = oldAccountMap.get(newAcct.Id);
					if(newAcct.Area_Manager_User__c != oldAcct.Area_Manager_User__c){
						String keyString = newAcct.Id + '-AM';
						if(atmMap.get(keyString) != null){
							delAtmList.add(atmMap.get(keyString));
						}
						if(newAcct.Area_Manager_User__c != null){
							AccountTeamMember newAtm = new AccountTeamMember(AccountId = newAcct.Id, UserId = newAcct.Area_Manager_User__c, TeamMemberRole = 'Area Manager');
							newAtmList.add(newAtm);
						}
					}
					else{
						if(newAcct.Area_Manager_User__c != null && atmMap.get(newAcct.Id + '-AM') == null){
							AccountTeamMember newAtm = new AccountTeamMember(AccountId = newAcct.Id, UserId = newAcct.Area_Manager_User__c, TeamMemberRole = 'Area Manager');
							newAtmList.add(newAtm);
						}	
					}
					if(newAcct.Area_Director_Id__c != oldAcct.Area_Director_Id__c){
						String keyString = newAcct.Id + '-AD';
						if(atmMap.get(keyString) != null){
							delAtmList.add(atmMap.get(keyString));
						}
						if(newAcct.Area_Director_Id__c != null){
							AccountTeamMember newAtm = new AccountTeamMember(AccountId = newAcct.Id, UserId = newAcct.Area_Director_Id__c, TeamMemberRole = 'Area Director');
							newAtmList.add(newAtm);
						}
					}
					else{
						if(newAcct.Area_Director_Id__c != null && atmMap.get(newAcct.Id + '-AD') == null){
							AccountTeamMember newAtm = new AccountTeamMember(AccountId = newAcct.Id, UserId = newAcct.Area_Director_Id__c, TeamMemberRole = 'Area Director');
							newAtmList.add(newAtm);
						}	
					}
					
					if(newAcct.Therapy_Development_Specialist_User__c != oldAcct.Therapy_Development_Specialist_User__c){
						String keyString = newAcct.Id + '-TD';
						if(atmMap.get(keyString) != null){
							delAtmList.add(atmMap.get(keyString));
						}
						if(newAcct.Therapy_Development_Specialist_User__c != null){
							AccountTeamMember newAtm = new AccountTeamMember(AccountId = newAcct.Id, UserId = newAcct.Therapy_Development_Specialist_User__c, TeamMemberRole = 'Therapy Development Specialist');
							newAtmList.add(newAtm);
						}
					}
					else{
						if(newAcct.Therapy_Development_Specialist_User__c != null && atmMap.get(newAcct.Id + '-TD') == null){
							AccountTeamMember newAtm = new AccountTeamMember(AccountId = newAcct.Id, UserId = newAcct.Therapy_Development_Specialist_User__c, TeamMemberRole = 'Therapy Development Specialist');
							newAtmList.add(newAtm);
						}	
					}
				}
			}		
			else if(!isUpdate){
				if(newAcct.Area_Manager_User__c != null){
						AccountTeamMember newAtm = new AccountTeamMember(AccountId = newAcct.Id, UserId = newAcct.Area_Manager_User__c, TeamMemberRole = 'Area Manager');
						newAtmList.add(newAtm);
				}
				if(newAcct.Area_Director_Id__c != null){
						AccountTeamMember newAtm = new AccountTeamMember(AccountId = newAcct.Id, UserId = newAcct.Area_Director_Id__c, TeamMemberRole = 'Area Director');
						newAtmList.add(newAtm);
				}
				if(newAcct.Therapy_Development_Specialist_User__c != null){
						AccountTeamMember newAtm = new AccountTeamMember(AccountId = newAcct.Id, UserId = newAcct.Therapy_Development_Specialist_User__c, TeamMemberRole = 'Therapy Development Specialist');
						newAtmList.add(newAtm);
				}
			}
		}// END FOR LOOP

		delete delAtmList;

		Set<Id> userIdSet = new Set<Id>();
		for(AccountTeamMember atm : newAtmList){
			userIdSet.add(atm.UserId);
		}
		Map<Id, Boolean> activeMap = new Map<Id, Boolean>();
		List<User> uList = [SELECT Id, IsActive FROM User WHERE Id IN : userIdSet];
		for(User u : uList){
			activeMap.put(u.Id, u.IsActive);
		}
		List<AccountTeamMember> newAtmList2 = new List<AccountTeamMember>();
		for(AccountTeamMember atm : newAtmList){
			if(activeMap.get(atm.userId) == true){
				newAtmList2.add(atm);
			}
		}

		insert newAtmList2;



	}
}