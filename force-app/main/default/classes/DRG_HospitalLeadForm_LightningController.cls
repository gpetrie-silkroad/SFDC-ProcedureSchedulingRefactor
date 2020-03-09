global without sharing class DRG_HospitalLeadForm_LightningController{

  
 
 
	
	public static List<String> stateList;

	public static Map<String, DRG_Period_Headers__c> periodMap = DRG_Period_Headers__c.getAll();
	
	public static String pd1 = periodMap.get('Period1').value__c;
	public static String pd2 = periodMap.get('Period2').value__c;
	public static String pd3 = periodMap.get('Period3').value__c;
	public static String pd4 = periodMap.get('Period4').value__c;



	@AuraEnabled
	public static User getCurrentUser(){
		Id curUserId = UserInfo.getUserId();
		User currentUser = [SELECT Id, FirstName, LastName, Field_Responsibility__c, Profile.Name FROM User WHERE Id = : curUserId];
		return currentUser;
	}





	@AuraEnabled
	public static List<Account> acctList(){
		Id rtId = [SELECT ID FROM RecordType WHERE Name = 'Customer' AND sObjectType = 'Account' LIMIT 1].Id;
		List<Account> accountList = new List<Account>();
		Account nullAccount = new Account(Name = '- None Selected -');
		accountList.add(nullAccount);
		List<Account> accountList1 = [SELECT Id, Name FROM Account WHERE RecordTypeId = : rtId AND 	Is_Converted_Customer__c = TRUE ORDER BY NAME ASC];
		for(Account a : accountList1){
			accountList.add(a);
		}

		return accountList;
	}




//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%%% P E R I O D   H E A D E R S              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	@AuraEnabled
	public static String getPd1(){
		return pd1;
	}

	@AuraEnabled
	public static String getPd2(){
		return pd2;
	}

	@AuraEnabled
	public static String getPd3(){
		return pd3;
	}

	@AuraEnabled
	public static String getPd4(){
		return pd4;
	}






//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%%% W R A P P E R   C L A S S    (SORTABLE)  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	global class ProcedureCountWrapper implements Comparable{
		
		@AuraEnabled
		public Boolean SortByProcedures{get;set;}

		@AuraEnabled
		public String EntityName{get;set;}

		@AuraEnabled
		public String FirstName{get;set;}
			
		@AuraEnabled
		public String MiddleName{get;set;}
			
		@AuraEnabled
		public String LastName{get;set;}
			
		@AuraEnabled
		public String AccountId{get;set;}

		@AuraEnabled
		public String FacilityId{get;set;}
				
		@AuraEnabled
		public String ContactId{get;set;}

		@AuraEnabled
		public Integer CASPeriod1{get;set;}
		
		@AuraEnabled
		public Integer CEAPeriod1{get;set;}
		
		@AuraEnabled
		public Integer CASPeriod2{get;set;}
		
		@AuraEnabled
		public Integer CEAPeriod2{get;set;}

		@AuraEnabled
		public Integer CASPeriod3{get;set;}
		
		@AuraEnabled
		public Integer CEAPeriod3{get;set;}

		@AuraEnabled
		public Integer CASPeriod4{get;set;}
		
		@AuraEnabled
		public Integer CEAPeriod4{get;set;}
		@AuraEnabled
		public Integer TotalProcedures{get;set;}

		@AuraEnabled
		public Boolean Vqi{get;set;}

		@AuraEnabled
		public Boolean Cas{get;set;}

		@AuraEnabled
		public String RecordId{get;set;}

		@AuraEnabled
		public String LeadStatus{get;set;}

		@AuraEnabled
		public String Specialty{get;set;}
		
		@AuraEnabled
		public Boolean CkBox{get;set;}

		@AuraEnabled
		public String NPI_Number{get;set;}

		@AuraEnabled
		public String Hospital{get;set;}

		@AuraEnabled
		public String MedicareProvderId{get;set;}

		@AuraEnabled
		public String Street{get;set;}

		@AuraEnabled
		public String City{get;set;}

		@AuraEnabled
		public String State{get;set;}

		@AuraEnabled
		public String Zip{get;set;}

		public ProcedureCountWrapper(){
			this.SortByProcedures = SortByProcedures;
			this.EntityName = EntityName;
			this.FirstName = FirstName;
			this.MiddleName = MiddleName;
			this.LastName = LastName;
			this.AccountId = AccountId;
			this.ContactId = ContactId;
			this.FacilityId =FacilityId;
			this.Vqi = Vqi;
			this.Cas = Cas;
			this.RecordId = RecordId;
			this.LeadStatus = LeadStatus;
			this.Specialty = Specialty;
			this.CkBox = CkBox;
			this.NPI_Number = NPI_Number;
			this.Hospital = Hospital;
			this.MedicareProvderId = MedicareProvderId;
			this.Street = Street;
			this.City = City;
			this.State = State;
			this.Zip = zip;
			this.CASPeriod1 = CASPeriod1;
			this.CEAPeriod1 = CEAPeriod1;
			this.CASPeriod2 = CASPeriod2;
			this.CEAPeriod2 = CEAPeriod2;
			this.CASPeriod3 = CASPeriod3;
			this.CEAPeriod3 = CEAPeriod3;
			this.CASPeriod4 = CASPeriod4;
			this.CEAPeriod4 = CEAPeriod4;
			this.TotalProcedures = TotalProcedures;
		}

		global Integer compareTo(Object compareTo){
			ProcedureCountWrapper compareToPCW = (ProcedureCountWrapper) compareTo;
			if(compareToPCW.SortByProcedures){
				if(TotalProcedures == compareToPCW.TotalProcedures) return 0;
				if(TotalProcedures > compareToPCW.TotalProcedures) return -1;
				else return 1;
			}
			else{
				if(EntityName == compareToPCW.EntityName) return 0;
				if(EntityName > compareToPCW.EntityName) return 1;
				else return -1;
			}
		}
	}



	/******************************************************************************************
	*******     STATE                                     *************************************
	*******************************************************************************************/
	@AuraEnabled
	public static String[] getStateList(){

		String nullState = 'None Selected'; 
 
	    List<AggregateResult> arList = [SELECT  State_Provence__c state 
										FROM 		DRG_Facility__c 
										GROUP BY 	State_Provence__c 
										ORDER BY    State_Provence__c ASC]; 
		 
		List<String> stateList = new List<String>(); 
		stateList.add(nullState); 
		 
		for(AggregateResult ar : arList){
			String arString = String.valueOf(ar.get('state'));
			stateList.add(arString);
		}
	
		return stateList;
	}




	/******************************************************************************************
	*******     CITY                                      *************************************
	*******************************************************************************************/
	@AuraEnabled
	public static List<ProcedureCountWrapper> getProceduresByCity(	String state, 
																	Boolean sortByProcedures,
																	Boolean showHistory,
																	String source ){
		List<AggregateResult> arList;



		arList = [SELECT 	SUM(CAS__c) cas, 
								SUM(CEA__c) cea, 
								SUM(Total__c) ttl, 
								Period__c period, 
								DRG_Facility_Id__r.City__c city 
					FROM 		DRG_Procedure__c
					WHERE 		DRG_Facility_Id__r.State_Provence__c =  : state
					AND 		DRG_Physician_Id__r.Name <> 'other'
					GROUP BY 	Period__c,
					            DRG_Facility_Id__r.City__c];



							   			
	

		Set<String> citySet = new Set<String>();

		Map<String, Integer> pd1Cas = new Map<String, Integer>();
		Map<String, Integer> pd2Cas = new Map<String, Integer>();
		Map<String, Integer> pd3Cas = new Map<String, Integer>();
		Map<String, Integer> pd4Cas = new Map<String, Integer>();

		Map<String, Integer> pd1Cea = new Map<String, Integer>();
		Map<String, Integer> pd2Cea = new Map<String, Integer>();
		Map<String, Integer> pd3Cea = new Map<String, Integer>();
		Map<String, Integer> pd4Cea = new Map<String, Integer>();

		Map<String, Integer> pd1Ttl = new Map<String, Integer>();
		Map<String, Integer> pd2Ttl = new Map<String, Integer>();
		Map<String, Integer> pd3Ttl = new Map<String, Integer>();
		Map<String, Integer> pd4Ttl = new Map<String, Integer>();

		for(AggregateResult ar : arList){
			String period = String.valueOf(ar.get('period'));
			String city = String.valueOf(ar.get('city'));
			Integer cas = Integer.valueOf(ar.get('cas'));
			Integer cea = Integer.valueOf(ar.get('cea'));
			Integer ttl = Integer.valueOf(ar.get('ttl'));

			if(city != null){
				citySet.add(city);

				if(period == pd1){
					pd1Cas.put(city, cas);
					pd1Cea.put(city, cea);
					pd1Ttl.put(city, ttl);
				} 
				else if(period == pd2){
					pd2Cas.put(city, cas);
					pd2Cea.put(city, cea);
					pd2Ttl.put(city, ttl);
				}
				else if(period == pd3){
					pd3Cas.put(city, cas);
					pd3Cea.put(city, cea);
					pd3Ttl.put(city, ttl);
				}
				else if(period == pd4){
					pd4Cas.put(city, cas);
					pd4Cea.put(city, cea);
					pd4Ttl.put(city, ttl);
				}
			}	
		}
		
		List<ProcedureCountWrapper> pcwList = new List<ProcedureCountWrapper>();

		for(String s : citySet){

			ProcedureCountWrapper pcw = new ProcedureCountWrapper();
			
			pcw.SortByProcedures = sortByProcedures;
	

			pcw.EntityName = s;
			if(pd1Cas.get(s) == null){ pcw.CASPeriod1 = 0; } else { pcw.CASPeriod1 = pd1Cas.get(s); }
			if(pd1Cea.get(s) == null){ pcw.CEAPeriod1 = 0; } else { pcw.CEAPeriod1 = pd1Cea.get(s); }

			if(pd2Cas.get(s) == null){ pcw.CASPeriod2 = 0; } else { pcw.CASPeriod2 = pd2Cas.get(s); }
			if(pd2Cea.get(s) == null){ pcw.CEAPeriod2 = 0; } else { pcw.CEAPeriod2 = pd2Cea.get(s); }
			
			if(pd3Cas.get(s) == null){ pcw.CASPeriod3 = 0; } else { pcw.CASPeriod3 = pd3Cas.get(s); }
			if(pd3Cea.get(s) == null){ pcw.CEAPeriod3 = 0; } else { pcw.CEAPeriod3 = pd3Cea.get(s); }
			
			if(pd4Cas.get(s) == null){ pcw.CASPeriod4 = 0; } else { pcw.CASPeriod4 = pd4Cas.get(s); }
			if(pd4Cea.get(s) == null){ pcw.CEAPeriod4 = 0; } else { pcw.CEAPeriod4 = pd4Cea.get(s); }
			
			pcw.TotalProcedures = pcw.CASPeriod4 + pcw.CEAPeriod4;

			pcwList.add(pcw);
			pcwList.sort();		
		}
				   
		return pcwList;								

	}





	@AuraEnabled
	public static List<ProcedureCountWrapper> setOnlyOneCity(String selectedState, String selectedCity){
		List<AggregateResult> arList = [SELECT 	SUM(CAS__c) cas, 
													SUM(CEA__c) cea, 
													SUM(Total__c) ttl, 
													Period__c period, 
													DRG_Facility_Id__r.City__c city 
										FROM 		DRG_Procedure__c
										WHERE 		DRG_Facility_Id__r.State_Provence__c =  : selectedState
										AND			DRG_Facility_Id__r.City__c = : selectedCity
										GROUP BY 	Period__c,
											        DRG_Facility_Id__r.City__c];
					   						
		Set<String> citySet = new Set<String>();

		Map<String, Integer> pd1Cas = new Map<String, Integer>();
		Map<String, Integer> pd2Cas = new Map<String, Integer>();
		Map<String, Integer> pd3Cas = new Map<String, Integer>();
		Map<String, Integer> pd4Cas = new Map<String, Integer>();

		Map<String, Integer> pd1Cea = new Map<String, Integer>();
		Map<String, Integer> pd2Cea = new Map<String, Integer>();
		Map<String, Integer> pd3Cea = new Map<String, Integer>();
		Map<String, Integer> pd4Cea = new Map<String, Integer>();

		Map<String, Integer> pd1Ttl = new Map<String, Integer>();
		Map<String, Integer> pd2Ttl = new Map<String, Integer>();
		Map<String, Integer> pd3Ttl = new Map<String, Integer>();
		Map<String, Integer> pd4Ttl = new Map<String, Integer>();

		for(AggregateResult ar : arList){
			String period = String.valueOf(ar.get('period'));
			String city = String.valueOf(ar.get('city'));
			Integer cas = Integer.valueOf(ar.get('cas'));
			Integer cea = Integer.valueOf(ar.get('cea'));
			Integer ttl = Integer.valueOf(ar.get('ttl'));

			if(city != null){
				citySet.add(city);

				if(period == pd1){
					pd1Cas.put(city, cas);
					pd1Cea.put(city, cea);
					pd1Ttl.put(city, ttl);
				} 
				else if(period == pd2){
					pd2Cas.put(city, cas);
					pd2Cea.put(city, cea);
					pd2Ttl.put(city, ttl);
				}
				else if(period == pd3){
					pd3Cas.put(city, cas);
					pd3Cea.put(city, cea);
					pd3Ttl.put(city, ttl);
				}
				else if(period == pd4){
					pd4Cas.put(city, cas);
					pd4Cea.put(city, cea);
					pd4Ttl.put(city, ttl);
				}
			}	
		}
		
		List<ProcedureCountWrapper> pcwList = new List<ProcedureCountWrapper>();

		for(String s : citySet){

			ProcedureCountWrapper pcw = new ProcedureCountWrapper();
			
			pcw.SortByProcedures = false;
	

			pcw.EntityName = s;
			if(pd1Cas.get(s) == null){ pcw.CASPeriod1 = 0; } else { pcw.CASPeriod1 = pd1Cas.get(s); }
			if(pd1Cea.get(s) == null){ pcw.CEAPeriod1 = 0; } else { pcw.CEAPeriod1 = pd1Cea.get(s); }

			if(pd2Cas.get(s) == null){ pcw.CASPeriod2 = 0; } else { pcw.CASPeriod2 = pd2Cas.get(s); }
			if(pd2Cea.get(s) == null){ pcw.CEAPeriod2 = 0; } else { pcw.CEAPeriod2 = pd2Cea.get(s); }
			
			if(pd3Cas.get(s) == null){ pcw.CASPeriod3 = 0; } else { pcw.CASPeriod3 = pd3Cas.get(s); }
			if(pd3Cea.get(s) == null){ pcw.CEAPeriod3 = 0; } else { pcw.CEAPeriod3 = pd3Cea.get(s); }
			
			if(pd4Cas.get(s) == null){ pcw.CASPeriod4 = 0; } else { pcw.CASPeriod4 = pd4Cas.get(s); }
			if(pd4Cea.get(s) == null){ pcw.CEAPeriod4 = 0; } else { pcw.CEAPeriod4 = pd4Cea.get(s); }
			
			pcw.TotalProcedures = pcw.CASPeriod4 + pcw.CEAPeriod4;

			pcwList.add(pcw);
			pcwList.sort();		
		}
				   
		return pcwList;
	}


	/******************************************************************************************
	*******     N E T W O R K  / F A C I L I T Y          *************************************
	*******************************************************************************************/


/*	@AuraEnabled
	public static List<ProcedureCountWrapper> getProceduresByNetworkFacility(  String selectedState,
            															String selectedCity,
            															Boolean sortByProcedures,
            															String source){
		List<AggregateResult> arList;

		

		arList = [SELECT 	SUM(CAS__c) cas, 
									SUM(CEA__c) cea, 
									SUM(Total__c) ttl, 
									Period__c period,
									DRG_Facility_Id__r.Parent_Network_Name__c networkName,
									DRG_Facility_Id__r.Lead_Status__c leadStatus, 
									DRG_Facility_Id__c facilityId,
									DRG_Facility_Id__r.Name facility,
									DRG_Facility_Id__r.CAS_Module__c casModule,
									DRG_Facility_Id__r.VQI_Member__c vqi
						FROM 		DRG_Procedure__c
						WHERE 		DRG_Facility_Id__r.State_Provence__c =  : selectedState
						AND			DRG_Facility_Id__r.City__c = : selectedCity
						AND 		DRG_Physician_Id__r.Name <> 'other'
						GROUP BY 	Period__c,
									DRG_Facility_Id__r.Parent_Network_Name__c,
									DRG_Facility_Id__r.Lead_Status__c,
							        DRG_Facility_Id__c,
							        DRG_Facility_Id__r.Name,
							        DRG_Facility_Id__r.CAS_Module__c,
							        DRG_Facility_Id__r.VQI_Member__c
							       ];	
		
		


		Set<String> facilitySet = new Set<String>();

		Map<String, Id> idMap = new Map<String, Id>();
		Map<String, Boolean> casModMap = new Map<String, Boolean>();
		Map<String, Boolean> vqiMemMap = new Map<String, Boolean>();
		Map<String, String> networkNameMap = new Map<String, String>();

		Map<String, Integer> pd1Cas = new Map<String, Integer>();
		Map<String, Integer> pd2Cas = new Map<String, Integer>();
		Map<String, Integer> pd3Cas = new Map<String, Integer>();
		Map<String, Integer> pd4Cas = new Map<String, Integer>();

		Map<String, Integer> pd1Cea = new Map<String, Integer>();
		Map<String, Integer> pd2Cea = new Map<String, Integer>();
		Map<String, Integer> pd3Cea = new Map<String, Integer>();
		Map<String, Integer> pd4Cea = new Map<String, Integer>();

		Map<String, Integer> pd1Ttl = new Map<String, Integer>();
		Map<String, Integer> pd2Ttl = new Map<String, Integer>();
		Map<String, Integer> pd3Ttl = new Map<String, Integer>();
		Map<String, Integer> pd4Ttl = new Map<String, Integer>();

		for(AggregateResult ar : arList){
			String period = String.valueOf(ar.get('period'));
			String networkName = String.valueOf(ar.get('networkName'));
			Id facilityId = String.valueOf(ar.get('facilityId'));
			Boolean casModule = Boolean.valueOf(ar.get('casModule'));
			Boolean vqi = Boolean.valueOf(ar.get('vqi'));
			String leadStatus = String.valueOf(ar.get('leadStatus'));
			String facility = String.valueOf(ar.get('facility'));

			Integer cas = Integer.valueOf(ar.get('cas'));
			Integer cea = Integer.valueOf(ar.get('cea'));
			Integer ttl = Integer.valueOf(ar.get('ttl'));

			if(facility != null){
				facilitySet.add(facility);
				idMap.put(facility, facilityId);
				casModMap.put(facility, casModule);
				vqiMemMap.put(facility, vqi);
				//leadStatMap.put(facility, leadStatus);


				if(period == pd1){
					pd1Cas.put(facility, cas);
					pd1Cea.put(facility, cea);
					pd1Ttl.put(facility, ttl);
				} 
				else if(period == pd2){
					pd2Cas.put(facility, cas);
					pd2Cea.put(facility, cea);
					pd2Ttl.put(facility, ttl);
				}
				else if(period == pd3){
					pd3Cas.put(facility, cas);
					pd3Cea.put(facility, cea);
					pd3Ttl.put(facility, ttl);
				}
				else if(period == pd4){
					pd4Cas.put(facility, cas);
					pd4Cea.put(facility, cea);
					pd4Ttl.put(facility, ttl);
				}
			}	
		}

		List<DRG_Facility__c> drgFaList = [SELECT Id, Lead_Status__c FROM DRG_Facility__c WHERE Id IN : idMap.values()];
		Map<String, String> leadStatusMap = new Map<String, String>();
		for(DRG_Facility__c drgFa : drgFaList){
			leadStatusMap.put(drgFa.Id, drgFa.Lead_Status__c);
		}

		List<ProcedureCountWrapper> pcwList = new List<ProcedureCountWrapper>();

		for(String s : facilitySet){

			ProcedureCountWrapper pcw = new ProcedureCountWrapper();
			
			pcw.SortByProcedures = sortByProcedures;
	

			pcw.EntityName = s;
			pcw.Vqi = vqiMemMap.get(s);
			pcw.Cas = casModMap.get(s);
			pcw.RecordId = idMap.get(s);
			pcw.LeadStatus = leadStatusMap.get(idMap.get(s));

			if(pd1Cas.get(s) == null){ pcw.CASPeriod1 = 0; } else { pcw.CASPeriod1 = pd1Cas.get(s); }
			if(pd1Cea.get(s) == null){ pcw.CEAPeriod1 = 0; } else { pcw.CEAPeriod1 = pd1Cea.get(s); }

			if(pd2Cas.get(s) == null){ pcw.CASPeriod2 = 0; } else { pcw.CASPeriod2 = pd2Cas.get(s); }
			if(pd2Cea.get(s) == null){ pcw.CEAPeriod2 = 0; } else { pcw.CEAPeriod2 = pd2Cea.get(s); }
			
			if(pd3Cas.get(s) == null){ pcw.CASPeriod3 = 0; } else { pcw.CASPeriod3 = pd3Cas.get(s); }
			if(pd3Cea.get(s) == null){ pcw.CEAPeriod3 = 0; } else { pcw.CEAPeriod3 = pd3Cea.get(s); }
			
			if(pd4Cas.get(s) == null){ pcw.CASPeriod4 = 0; } else { pcw.CASPeriod4 = pd4Cas.get(s); }
			if(pd4Cea.get(s) == null){ pcw.CEAPeriod4 = 0; } else { pcw.CEAPeriod4 = pd4Cea.get(s); }
			
			pcw.TotalProcedures = pcw.CASPeriod4 + pcw.CEAPeriod4;

			pcwList.add(pcw);
			pcwList.sort();

		}

		return pcwList;
	}
*/


	/******************************************************************************************
	*******     N E T W O R K                             *************************************
	*******************************************************************************************/

	@AuraEnabled
	public static List<ProcedureCountWrapper> getProceduresByNetwork(   String selectedState,
            															String selectedCity,
            															Boolean sortByProcedures,
            															String source){
		List<AggregateResult> arList;

		if(source == 'Physician'){

			arList = [SELECT 	SUM(CAS__c) cas, 
								SUM(CEA__c) cea, 
								SUM(Total__c) ttl, 
								Period__c period, 
								DRG_Facility_Id__r.City__c city,
								DRG_Facility_Id__r.Parent_Network_Name__c networkName 
					FROM 		DRG_Procedure__c
					WHERE 		DRG_Facility_Id__r.State_Provence__c =  : selectedState
					AND			DRG_Facility_Id__r.City__c = : selectedCity
					AND 		DRG_Physician_Id__r.Lead_Status__c = 'DRG'
					AND 		DRG_Facility_Id__r.Lead_Status__c <> 'DRG'
					AND 		DRG_Physician_Id__r.Name <> 'other'
					GROUP BY 	Period__c,
						        DRG_Facility_Id__r.City__c,
						        DRG_Facility_Id__r.Parent_Network_Name__c];
		}
		else if (source == 'Hospital'){

			arList = [SELECT 	SUM(CAS__c) cas, 
								SUM(CEA__c) cea, 
								SUM(Total__c) ttl, 
								Period__c period, 
								DRG_Facility_Id__r.City__c city,
								DRG_Facility_Id__r.Parent_Network_Name__c networkName 
					FROM 		DRG_Procedure__c
					WHERE 		DRG_Facility_Id__r.State_Provence__c =  : selectedState
					AND			DRG_Facility_Id__r.City__c = : selectedCity
					AND   		DRG_Facility_Id__r.Lead_Status__c = 'DRG'
					AND 		DRG_Physician_Id__r.Name <> 'other'
					GROUP BY 	Period__c,
						        DRG_Facility_Id__r.City__c,
						        DRG_Facility_Id__r.Parent_Network_Name__c];
		}

		Set<String> networkSet = new Set<String>();

		Map<String, Integer> pd1Cas = new Map<String, Integer>();
		Map<String, Integer> pd2Cas = new Map<String, Integer>();
		Map<String, Integer> pd3Cas = new Map<String, Integer>();
		Map<String, Integer> pd4Cas = new Map<String, Integer>();

		Map<String, Integer> pd1Cea = new Map<String, Integer>();
		Map<String, Integer> pd2Cea = new Map<String, Integer>();
		Map<String, Integer> pd3Cea = new Map<String, Integer>();
		Map<String, Integer> pd4Cea = new Map<String, Integer>();

		Map<String, Integer> pd1Ttl = new Map<String, Integer>();
		Map<String, Integer> pd2Ttl = new Map<String, Integer>();
		Map<String, Integer> pd3Ttl = new Map<String, Integer>();
		Map<String, Integer> pd4Ttl = new Map<String, Integer>();

		for(AggregateResult ar : arList){
			String period = String.valueOf(ar.get('period'));
			String network = String.valueOf(ar.get('networkName'));
			Integer cas = Integer.valueOf(ar.get('cas'));
			Integer cea = Integer.valueOf(ar.get('cea'));
			Integer ttl = Integer.valueOf(ar.get('ttl'));

			if(network != null){
				networkSet.add(network);

				if(period == pd1){
					pd1Cas.put(network, cas);
					pd1Cea.put(network, cea);
					pd1Ttl.put(network, ttl);
				} 
				else if(period == pd2){
					pd2Cas.put(network, cas);
					pd2Cea.put(network, cea);
					pd2Ttl.put(network, ttl);
				}
				else if(period == pd3){
					pd3Cas.put(network, cas);
					pd3Cea.put(network, cea);
					pd3Ttl.put(network, ttl);
				}
				else if(period == pd4){
					pd4Cas.put(network, cas);
					pd4Cea.put(network, cea);
					pd4Ttl.put(network, ttl);
				}
			}	
		}

		List<ProcedureCountWrapper> pcwList = new List<ProcedureCountWrapper>();

		for(String s : networkSet){

			ProcedureCountWrapper pcw = new ProcedureCountWrapper();
			
			pcw.SortByProcedures = sortByProcedures;
	

			pcw.EntityName = s;
			if(pd1Cas.get(s) == null){ pcw.CASPeriod1 = 0; } else { pcw.CASPeriod1 = pd1Cas.get(s); }
			if(pd1Cea.get(s) == null){ pcw.CEAPeriod1 = 0; } else { pcw.CEAPeriod1 = pd1Cea.get(s); }

			if(pd2Cas.get(s) == null){ pcw.CASPeriod2 = 0; } else { pcw.CASPeriod2 = pd2Cas.get(s); }
			if(pd2Cea.get(s) == null){ pcw.CEAPeriod2 = 0; } else { pcw.CEAPeriod2 = pd2Cea.get(s); }
			
			if(pd3Cas.get(s) == null){ pcw.CASPeriod3 = 0; } else { pcw.CASPeriod3 = pd3Cas.get(s); }
			if(pd3Cea.get(s) == null){ pcw.CEAPeriod3 = 0; } else { pcw.CEAPeriod3 = pd3Cea.get(s); }
			
			if(pd4Cas.get(s) == null){ pcw.CASPeriod4 = 0; } else { pcw.CASPeriod4 = pd4Cas.get(s); }
			if(pd4Cea.get(s) == null){ pcw.CEAPeriod4 = 0; } else { pcw.CEAPeriod4 = pd4Cea.get(s); }
			
			pcw.TotalProcedures = pcw.CASPeriod4 + pcw.CEAPeriod4;

			pcwList.add(pcw);
			pcwList.sort();		
		}
				   
		return pcwList;
	}




	@AuraEnabled
	public static List<ProcedureCountWrapper> setOnlyOneNetwork(	String selectedState, 
																	String selectedCity, 
																	String selectedNetwork){

		List<AggregateResult> arList = [SELECT 	SUM(CAS__c) cas, 
													SUM(CEA__c) cea, 
													SUM(Total__c) ttl, 
													Period__c period, 
													DRG_Facility_Id__r.Parent_Network_Name__c netwrk 
										FROM 		DRG_Procedure__c
										WHERE 		DRG_Facility_Id__r.State_Provence__c =  : selectedState
										AND			DRG_Facility_Id__r.City__c = : selectedCity
										AND			DRG_Facility_Id__r.Parent_Network_Name__c = : selectedNetwork
										GROUP BY 	Period__c,
											        DRG_Facility_Id__r.Parent_Network_Name__c];

		Set<String> networkSet = new Set<String>();

		Map<String, Integer> pd1Cas = new Map<String, Integer>();
		Map<String, Integer> pd2Cas = new Map<String, Integer>();
		Map<String, Integer> pd3Cas = new Map<String, Integer>();
		Map<String, Integer> pd4Cas = new Map<String, Integer>();

		Map<String, Integer> pd1Cea = new Map<String, Integer>();
		Map<String, Integer> pd2Cea = new Map<String, Integer>();
		Map<String, Integer> pd3Cea = new Map<String, Integer>();
		Map<String, Integer> pd4Cea = new Map<String, Integer>();

		Map<String, Integer> pd1Ttl = new Map<String, Integer>();
		Map<String, Integer> pd2Ttl = new Map<String, Integer>();
		Map<String, Integer> pd3Ttl = new Map<String, Integer>();
		Map<String, Integer> pd4Ttl = new Map<String, Integer>();

		for(AggregateResult ar : arList){
			String period = String.valueOf(ar.get('period'));
			String network = String.valueOf(ar.get('netwrk'));
			Integer cas = Integer.valueOf(ar.get('cas'));
			Integer cea = Integer.valueOf(ar.get('cea'));
			Integer ttl = Integer.valueOf(ar.get('ttl'));

			if(network != null){
				networkSet.add(network);

				if(period == pd1){
					pd1Cas.put(network, cas);
					pd1Cea.put(network, cea);
					pd1Ttl.put(network, ttl);
				} 
				else if(period == pd2){
					pd2Cas.put(network, cas);
					pd2Cea.put(network, cea);
					pd2Ttl.put(network, ttl);
				}
				else if(period == pd3){
					pd3Cas.put(network, cas);
					pd3Cea.put(network, cea);
					pd3Ttl.put(network, ttl);
				}
				else if(period == pd4){
					pd4Cas.put(network, cas);
					pd4Cea.put(network, cea);
					pd4Ttl.put(network, ttl);
				}
			}	
		}
		
		List<ProcedureCountWrapper> pcwList = new List<ProcedureCountWrapper>();

		for(String s : networkSet){

			ProcedureCountWrapper pcw = new ProcedureCountWrapper();
			
			pcw.SortByProcedures = false;
	

			pcw.EntityName = s;
			if(pd1Cas.get(s) == null){ pcw.CASPeriod1 = 0; } else { pcw.CASPeriod1 = pd1Cas.get(s); }
			if(pd1Cea.get(s) == null){ pcw.CEAPeriod1 = 0; } else { pcw.CEAPeriod1 = pd1Cea.get(s); }

			if(pd2Cas.get(s) == null){ pcw.CASPeriod2 = 0; } else { pcw.CASPeriod2 = pd2Cas.get(s); }
			if(pd2Cea.get(s) == null){ pcw.CEAPeriod2 = 0; } else { pcw.CEAPeriod2 = pd2Cea.get(s); }
			
			if(pd3Cas.get(s) == null){ pcw.CASPeriod3 = 0; } else { pcw.CASPeriod3 = pd3Cas.get(s); }
			if(pd3Cea.get(s) == null){ pcw.CEAPeriod3 = 0; } else { pcw.CEAPeriod3 = pd3Cea.get(s); }
			
			if(pd4Cas.get(s) == null){ pcw.CASPeriod4 = 0; } else { pcw.CASPeriod4 = pd4Cas.get(s); }
			if(pd4Cea.get(s) == null){ pcw.CEAPeriod4 = 0; } else { pcw.CEAPeriod4 = pd4Cea.get(s); }
			
			pcw.TotalProcedures = pcw.CASPeriod4 + pcw.CEAPeriod4;

			pcwList.add(pcw);
			pcwList.sort();		
		}
				   
		return pcwList;
	}





	/******************************************************************************************
	*******     F A C I L I T Y                             ***********************************
	*******************************************************************************************/

	@AuraEnabled
	public static List<ProcedureCountWrapper> getProceduresByFacility(  String selectedState,
            															String selectedCity,
            															String selectedNetwork,
            															Boolean sortByProcedures,
            															String source){
		List<AggregateResult> arList;

		if(source == 'Physician'){

			arList = [SELECT 	SUM(CAS__c) cas, 
										SUM(CEA__c) cea, 
										SUM(Total__c) ttl, 
										Period__c period, 
										DRG_Facility_Id__c facilityId,
										DRG_Facility_Id__r.Name facility,
										DRG_Facility_Id__r.CAS_Module__c casModule,
										DRG_Facility_Id__r.VQI_Member__c vqi
							FROM 		DRG_Procedure__c
							WHERE 		DRG_Facility_Id__r.State_Provence__c =  : selectedState
							AND			DRG_Facility_Id__r.City__c = : selectedCity
							AND			DRG_Facility_Id__r.Parent_Network_Name__c =: selectedNetwork
							AND 		DRG_Physician_Id__r.Lead_Status__c = 'DRG'
							AND 		DRG_Facility_Id__r.Lead_Status__c <> 'DRG'
							AND 		DRG_Physician_Id__r.Name <> 'other'
							GROUP BY 	Period__c,
								        DRG_Facility_Id__c,
								        DRG_Facility_Id__r.Name,
								        DRG_Facility_Id__r.CAS_Module__c,
								        DRG_Facility_Id__r.VQI_Member__c
								       ];	
   		
   		}
   		else if(source == 'Hospital'){

   			arList = [SELECT 	SUM(CAS__c) cas, 
										SUM(CEA__c) cea, 
										SUM(Total__c) ttl, 
										Period__c period, 
										DRG_Facility_Id__c facilityId,
										DRG_Facility_Id__r.Name facility,
										DRG_Facility_Id__r.CAS_Module__c casModule,
										DRG_Facility_Id__r.VQI_Member__c vqi
							FROM 		DRG_Procedure__c
							WHERE 		DRG_Facility_Id__r.State_Provence__c =  : selectedState
							AND			DRG_Facility_Id__r.City__c = : selectedCity
							AND   		DRG_Facility_Id__r.Lead_Status__c = 'DRG'
							AND			DRG_Facility_Id__r.Parent_Network_Name__c =: selectedNetwork
							AND 		DRG_Physician_Id__r.Name <> 'other'
							GROUP BY 	Period__c,
								        DRG_Facility_Id__c,
								        DRG_Facility_Id__r.Name,
								        DRG_Facility_Id__r.CAS_Module__c,
								        DRG_Facility_Id__r.VQI_Member__c
								       ];	
   		}


		Set<String> facilitySet = new Set<String>();

		Map<String, Id> idMap = new Map<String, Id>();
		Map<String, Boolean> casModMap = new Map<String, Boolean>();
		Map<String, Boolean> vqiMemMap = new Map<String, Boolean>();
		//Map<String, String> leadStatMap = new Map<String, String>();

		Map<String, Integer> pd1Cas = new Map<String, Integer>();
		Map<String, Integer> pd2Cas = new Map<String, Integer>();
		Map<String, Integer> pd3Cas = new Map<String, Integer>();
		Map<String, Integer> pd4Cas = new Map<String, Integer>();

		Map<String, Integer> pd1Cea = new Map<String, Integer>();
		Map<String, Integer> pd2Cea = new Map<String, Integer>();
		Map<String, Integer> pd3Cea = new Map<String, Integer>();
		Map<String, Integer> pd4Cea = new Map<String, Integer>();

		Map<String, Integer> pd1Ttl = new Map<String, Integer>();
		Map<String, Integer> pd2Ttl = new Map<String, Integer>();
		Map<String, Integer> pd3Ttl = new Map<String, Integer>();
		Map<String, Integer> pd4Ttl = new Map<String, Integer>();

		for(AggregateResult ar : arList){
			String period = String.valueOf(ar.get('period'));
			Id facilityId = String.valueOf(ar.get('facilityId'));
			Boolean casModule = Boolean.valueOf(ar.get('casModule'));
			Boolean vqi = Boolean.valueOf(ar.get('vqi'));
			//String leadStatus = String.valueOf(ar.get('leadStatus'));
			String facility = String.valueOf(ar.get('facility'));

			Integer cas = Integer.valueOf(ar.get('cas'));
			Integer cea = Integer.valueOf(ar.get('cea'));
			Integer ttl = Integer.valueOf(ar.get('ttl'));

			if(facility != null){
				facilitySet.add(facility);
				idMap.put(facility, facilityId);
				casModMap.put(facility, casModule);
				vqiMemMap.put(facility, vqi);
				//leadStatMap.put(facility, leadStatus);


				if(period == pd1){
					pd1Cas.put(facility, cas);
					pd1Cea.put(facility, cea);
					pd1Ttl.put(facility, ttl);
				} 
				else if(period == pd2){
					pd2Cas.put(facility, cas);
					pd2Cea.put(facility, cea);
					pd2Ttl.put(facility, ttl);
				}
				else if(period == pd3){
					pd3Cas.put(facility, cas);
					pd3Cea.put(facility, cea);
					pd3Ttl.put(facility, ttl);
				}
				else if(period == pd4){
					pd4Cas.put(facility, cas);
					pd4Cea.put(facility, cea);
					pd4Ttl.put(facility, ttl);
				}
			}	
		}

		List<DRG_Facility__c> drgFaList = [SELECT Id, Lead_Status__c FROM DRG_Facility__c WHERE Id IN : idMap.values()];
		Map<String, String> leadStatusMap = new Map<String, String>();
		for(DRG_Facility__c drgFa : drgFaList){
			leadStatusMap.put(drgFa.Id, drgFa.Lead_Status__c);
		}

		List<ProcedureCountWrapper> pcwList = new List<ProcedureCountWrapper>();

		for(String s : facilitySet){

			ProcedureCountWrapper pcw = new ProcedureCountWrapper();
			
			pcw.SortByProcedures = sortByProcedures;
	

			pcw.EntityName = s;
			pcw.Vqi = vqiMemMap.get(s);
			pcw.Cas = casModMap.get(s);
			pcw.RecordId = idMap.get(s);
			pcw.LeadStatus = leadStatusMap.get(idMap.get(s));

			if(pd1Cas.get(s) == null){ pcw.CASPeriod1 = 0; } else { pcw.CASPeriod1 = pd1Cas.get(s); }
			if(pd1Cea.get(s) == null){ pcw.CEAPeriod1 = 0; } else { pcw.CEAPeriod1 = pd1Cea.get(s); }

			if(pd2Cas.get(s) == null){ pcw.CASPeriod2 = 0; } else { pcw.CASPeriod2 = pd2Cas.get(s); }
			if(pd2Cea.get(s) == null){ pcw.CEAPeriod2 = 0; } else { pcw.CEAPeriod2 = pd2Cea.get(s); }
			
			if(pd3Cas.get(s) == null){ pcw.CASPeriod3 = 0; } else { pcw.CASPeriod3 = pd3Cas.get(s); }
			if(pd3Cea.get(s) == null){ pcw.CEAPeriod3 = 0; } else { pcw.CEAPeriod3 = pd3Cea.get(s); }
			
			if(pd4Cas.get(s) == null){ pcw.CASPeriod4 = 0; } else { pcw.CASPeriod4 = pd4Cas.get(s); }
			if(pd4Cea.get(s) == null){ pcw.CEAPeriod4 = 0; } else { pcw.CEAPeriod4 = pd4Cea.get(s); }
			
			pcw.TotalProcedures = pcw.CASPeriod4 + pcw.CEAPeriod4;

			pcwList.add(pcw);
			pcwList.sort();

		}

		return pcwList;
	}





	@AuraEnabled
	public static List<ProcedureCountWrapper> setOnlyOneFacility(	String selectedFacility, 
																	String selectedFacilityRecordId
																	){
			List<AggregateResult> arList = [SELECT 	SUM(CAS__c) cas, 
													SUM(CEA__c) cea, 
													SUM(Total__c) ttl, 
													Period__c period, 
													DRG_Facility_Id__c facilityId,
													DRG_Facility_Id__r.Name facility,
													DRG_Facility_Id__r.CAS_Module__c casModule,
													DRG_Facility_Id__r.VQI_Member__c vqi
													//DRG_Facility_Id__r.Lead_Status__c leadStatus
										FROM 		DRG_Procedure__c
										WHERE 		DRG_Facility_Id__c = : selectedFacilityRecordId
										AND 		DRG_Facility_Id__r.Lead_Status__c = 'Customer'
										GROUP BY 	Period__c,
											        DRG_Facility_Id__c,
											        DRG_Facility_Id__r.Name,
											        DRG_Facility_Id__r.CAS_Module__c,
											        DRG_Facility_Id__r.VQI_Member__c
											        //DRG_Facility_Id__r.Lead_Status__c
											        ];

											        


		Set<String> facilitySet = new Set<String>();

		Map<String, Id> idMap = new Map<String, Id>();
		Map<String, Boolean> casModMap = new Map<String, Boolean>();
		Map<String, Boolean> vqiMemMap = new Map<String, Boolean>();
		Map<String, String> leadStatMap = new Map<String, String>();

		Map<String, Integer> pd1Cas = new Map<String, Integer>();
		Map<String, Integer> pd2Cas = new Map<String, Integer>();
		Map<String, Integer> pd3Cas = new Map<String, Integer>();
		Map<String, Integer> pd4Cas = new Map<String, Integer>();

		Map<String, Integer> pd1Cea = new Map<String, Integer>();
		Map<String, Integer> pd2Cea = new Map<String, Integer>();
		Map<String, Integer> pd3Cea = new Map<String, Integer>();
		Map<String, Integer> pd4Cea = new Map<String, Integer>();

		Map<String, Integer> pd1Ttl = new Map<String, Integer>();
		Map<String, Integer> pd2Ttl = new Map<String, Integer>();
		Map<String, Integer> pd3Ttl = new Map<String, Integer>();
		Map<String, Integer> pd4Ttl = new Map<String, Integer>();

		for(AggregateResult ar : arList){
			String period = String.valueOf(ar.get('period'));
			Id facilityId = String.valueOf(ar.get('facilityId'));
			Boolean casModule = Boolean.valueOf(ar.get('casModule'));
			Boolean vqi = Boolean.valueOf(ar.get('vqi'));
			//String leadStatus = String.valueOf(ar.get('leadStatus'));
			String facility = String.valueOf(ar.get('facility'));

			Integer cas = Integer.valueOf(ar.get('cas'));
			Integer cea = Integer.valueOf(ar.get('cea'));
			Integer ttl = Integer.valueOf(ar.get('ttl'));

			if(facility != null){
				facilitySet.add(facility);
				idMap.put(facility, facilityId);
				casModMap.put(facility, casModule);
				vqiMemMap.put(facility, vqi);
				//leadStatMap.put(facility, leadStatus);


				if(period == pd1){
					pd1Cas.put(facility, cas);
					pd1Cea.put(facility, cea);
					pd1Ttl.put(facility, ttl);
				} 
				else if(period == pd2){
					pd2Cas.put(facility, cas);
					pd2Cea.put(facility, cea);
					pd2Ttl.put(facility, ttl);
				}
				else if(period == pd3){
					pd3Cas.put(facility, cas);
					pd3Cea.put(facility, cea);
					pd3Ttl.put(facility, ttl);
				}
				else if(period == pd4){
					pd4Cas.put(facility, cas);
					pd4Cea.put(facility, cea);
					pd4Ttl.put(facility, ttl);
				}
			}	
		}

		List<DRG_Facility__c> drgFaList = [SELECT Id, Lead_Status__c FROM DRG_Facility__c WHERE Id IN : idMap.values()];
		Map<String, String> leadStatusMap = new Map<String, String>();
		for(DRG_Facility__c drgFa : drgFaList){
			leadStatusMap.put(drgFa.Id, drgFa.Lead_Status__c);
		}

		List<ProcedureCountWrapper> pcwList = new List<ProcedureCountWrapper>();

		for(String s : facilitySet){

			ProcedureCountWrapper pcw = new ProcedureCountWrapper();
			
			pcw.EntityName = s;
			pcw.Vqi = vqiMemMap.get(s);
			pcw.Cas = casModMap.get(s);
			pcw.RecordId = idMap.get(s);
			pcw.LeadStatus = leadStatusMap.get(idMap.get(s));

			if(pd1Cas.get(s) == null){ pcw.CASPeriod1 = 0; } else { pcw.CASPeriod1 = pd1Cas.get(s); }
			if(pd1Cea.get(s) == null){ pcw.CEAPeriod1 = 0; } else { pcw.CEAPeriod1 = pd1Cea.get(s); }

			if(pd2Cas.get(s) == null){ pcw.CASPeriod2 = 0; } else { pcw.CASPeriod2 = pd2Cas.get(s); }
			if(pd2Cea.get(s) == null){ pcw.CEAPeriod2 = 0; } else { pcw.CEAPeriod2 = pd2Cea.get(s); }
			
			if(pd3Cas.get(s) == null){ pcw.CASPeriod3 = 0; } else { pcw.CASPeriod3 = pd3Cas.get(s); }
			if(pd3Cea.get(s) == null){ pcw.CEAPeriod3 = 0; } else { pcw.CEAPeriod3 = pd3Cea.get(s); }
			
			if(pd4Cas.get(s) == null){ pcw.CASPeriod4 = 0; } else { pcw.CASPeriod4 = pd4Cas.get(s); }
			if(pd4Cea.get(s) == null){ pcw.CEAPeriod4 = 0; } else { pcw.CEAPeriod4 = pd4Cea.get(s); }
			
			pcw.TotalProcedures = pcw.CASPeriod4 + pcw.CEAPeriod4;

			pcwList.add(pcw);
			pcwList.sort();		
		}
		

		return pcwList;
	}




	@AuraEnabled
	public static DRG_Facility__c getFacilityRecord(Id facilityRecordId){
		DRG_Facility__c drgF = [SELECT 		Beds__c,
											CAS_Module__c,
											Census_Region__c,
											City__c,
											Country__c,
											County__c,
											Discharges__c,
											AccountId__c,
											Id,
											Name,
											Lead_Status__c,
											Medicare_Provider_ID__c,
											Parent_Network_Name__c,
											Patient_Days__c,
											Postal_Code__c,
											Revenue__c,
											Rural_or_Urban__c,
											State_Provence__c,
											Street_Address__c,
											VQI_Member__c
								FROM 		DRG_Facility__c
								WHERE		Id = : facilityRecordId];

		return drgF;
	}




	@AuraEnabled
	public static List<ProcedureCountWrapper> getProceduresByFacilityFromSearch(String searchString, Boolean sortByProcedures){

		List<AggregateResult> arList = [SELECT 	SUM(CAS__c) cas, 
													SUM(CEA__c) cea, 
													SUM(Total__c) ttl, 
													Period__c period, 
													DRG_Facility_Id__c facilityId,
													DRG_Facility_Id__r.Name facility,
													DRG_Facility_Id__r.CAS_Module__c casModule,
													DRG_Facility_Id__r.VQI_Member__c vqi
													//DRG_Facility_Id__r.Lead_Status__c leadStatus
										FROM 		DRG_Procedure__c
										WHERE 		DRG_Facility_Id__r.Name LIKE : searchString
										AND 		DRG_Facility_Id__r.Lead_Status__c = 'DRG'
										GROUP BY 	Period__c,
											        DRG_Facility_Id__c,
											        DRG_Facility_Id__r.Name,
											        DRG_Facility_Id__r.CAS_Module__c,
											        DRG_Facility_Id__r.VQI_Member__c
											        LIMIT 200
											        ];


   		SYSTEM.DEBUG('SEARCH STRING = [' + searchString + '] AR SIZE = [' + arList.size() + ']');


		Set<String> facilitySet = new Set<String>();

		Map<String, Id> idMap = new Map<String, Id>();
		Map<String, Boolean> casModMap = new Map<String, Boolean>();
		Map<String, Boolean> vqiMemMap = new Map<String, Boolean>();
		Map<String, String> leadStatMap = new Map<String, String>();

		Map<String, Integer> pd1Cas = new Map<String, Integer>();
		Map<String, Integer> pd2Cas = new Map<String, Integer>();
		Map<String, Integer> pd3Cas = new Map<String, Integer>();
		Map<String, Integer> pd4Cas = new Map<String, Integer>();

		Map<String, Integer> pd1Cea = new Map<String, Integer>();
		Map<String, Integer> pd2Cea = new Map<String, Integer>();
		Map<String, Integer> pd3Cea = new Map<String, Integer>();
		Map<String, Integer> pd4Cea = new Map<String, Integer>();

		Map<String, Integer> pd1Ttl = new Map<String, Integer>();
		Map<String, Integer> pd2Ttl = new Map<String, Integer>();
		Map<String, Integer> pd3Ttl = new Map<String, Integer>();
		Map<String, Integer> pd4Ttl = new Map<String, Integer>();

		for(AggregateResult ar : arList){
			String period = String.valueOf(ar.get('period'));
			Id facilityId = String.valueOf(ar.get('facilityId'));
			Boolean casModule = Boolean.valueOf(ar.get('casModule'));
			Boolean vqi = Boolean.valueOf(ar.get('vqi'));
			//String leadStatus = String.valueOf(ar.get('leadStatus'));
			String facility = String.valueOf(ar.get('facility'));

			Integer cas = Integer.valueOf(ar.get('cas'));
			Integer cea = Integer.valueOf(ar.get('cea'));
			Integer ttl = Integer.valueOf(ar.get('ttl'));

			if(facility != null){
				facilitySet.add(facility);
				idMap.put(facility, facilityId);
				casModMap.put(facility, casModule);
				vqiMemMap.put(facility, vqi);
				//leadStatMap.put(facility, leadStatus);


				if(period == pd1){
					pd1Cas.put(facility, cas);
					pd1Cea.put(facility, cea);
					pd1Ttl.put(facility, ttl);
				} 
				else if(period == pd2){
					pd2Cas.put(facility, cas);
					pd2Cea.put(facility, cea);
					pd2Ttl.put(facility, ttl);
				}
				else if(period == pd3){
					pd3Cas.put(facility, cas);
					pd3Cea.put(facility, cea);
					pd3Ttl.put(facility, ttl);
				}
				else if(period == pd4){
					pd4Cas.put(facility, cas);
					pd4Cea.put(facility, cea);
					pd4Ttl.put(facility, ttl);
				}
			}	
		}

		List<DRG_Facility__c> drgFaList = [SELECT Id, Lead_Status__c FROM DRG_Facility__c WHERE Id IN : idMap.values()];
		Map<String, String> leadStatusMap = new Map<String, String>();
		for(DRG_Facility__c drgFa : drgFaList){
			leadStatusMap.put(drgFa.Id, drgFa.Lead_Status__c);
		}

		List<ProcedureCountWrapper> pcwList = new List<ProcedureCountWrapper>();

		for(String s : facilitySet){

			ProcedureCountWrapper pcw = new ProcedureCountWrapper();
			
			pcw.SortByProcedures = sortByProcedures;
			pcw.EntityName = s;
			pcw.Vqi = vqiMemMap.get(s);
			pcw.Cas = casModMap.get(s);
			pcw.RecordId = idMap.get(s);
			pcw.LeadStatus = leadStatusMap.get(idMap.get(s));

			if(pd1Cas.get(s) == null){ pcw.CASPeriod1 = 0; } else { pcw.CASPeriod1 = pd1Cas.get(s); }
			if(pd1Cea.get(s) == null){ pcw.CEAPeriod1 = 0; } else { pcw.CEAPeriod1 = pd1Cea.get(s); }

			if(pd2Cas.get(s) == null){ pcw.CASPeriod2 = 0; } else { pcw.CASPeriod2 = pd2Cas.get(s); }
			if(pd2Cea.get(s) == null){ pcw.CEAPeriod2 = 0; } else { pcw.CEAPeriod2 = pd2Cea.get(s); }
			
			if(pd3Cas.get(s) == null){ pcw.CASPeriod3 = 0; } else { pcw.CASPeriod3 = pd3Cas.get(s); }
			if(pd3Cea.get(s) == null){ pcw.CEAPeriod3 = 0; } else { pcw.CEAPeriod3 = pd3Cea.get(s); }
			
			if(pd4Cas.get(s) == null){ pcw.CASPeriod4 = 0; } else { pcw.CASPeriod4 = pd4Cas.get(s); }
			if(pd4Cea.get(s) == null){ pcw.CEAPeriod4 = 0; } else { pcw.CEAPeriod4 = pd4Cea.get(s); }
			
			pcw.TotalProcedures = pcw.CASPeriod4 + pcw.CEAPeriod4;

			pcwList.add(pcw);
			pcwList.sort();		
		}
		

		return pcwList;
	}





	/******************************************************************************************
	*******     P H Y S I C I A N                             *********************************
	*******************************************************************************************/

	@AuraEnabled
	public static List<ProcedureCountWrapper> getProceduresByPhysician( String facilityId,
																		Boolean sortByProcedures){
	List<AggregateResult> arList = [SELECT 	SUM(CAS__c) cas, 
													SUM(CEA__c) cea, 
													SUM(Total__c) ttl, 
													Period__c period, 
													DRG_Physician_Id__c physicanId,
													DRG_Physician_Id__r.Name physName,

													DRG_Physician_Id__r.First_Name__c firstName,
													DRG_Physician_Id__r.Middle_Name__c middleName,
													DRG_Physician_Id__r.Last_Name__c lastName,


													DRG_Physician_Id__r.Primary_Specialty__c specialty
										FROM 		DRG_Procedure__c
										WHERE 		DRG_Facility_Id__c = : facilityId
										AND 		DRG_Physician_Id__r.Lead_Status__c = 'DRG'
										AND 		DRG_Physician_Id__r.Name <> 'other'
										GROUP BY 	Period__c,
											        DRG_Physician_Id__c,
											        DRG_Physician_Id__r.Name,

											        DRG_Physician_Id__r.First_Name__c,
											        DRG_Physician_Id__r.Middle_Name__c,
											        DRG_Physician_Id__r.Last_Name__c,

											        DRG_Physician_Id__r.Primary_Specialty__c];											        


		Set<String> physicianSet = new Set<String>();

		Map<String, Id> physianIdMap = new Map<String, Id>();
		Map<String, String> physNameMap = new Map<String, String>();

		Map<String, String> firstNameMap = new Map<String, String>();
		Map<String, String> middleNameMap = new Map<String, String>();
		Map<String, String> lastNameMap = new Map<String, String>();

		//Map<String, String> leadStatMap = new Map<String, String>();
		Map<String, String> specialtyMap = new Map<String, String>();

		Map<String, Integer> pd1Cas = new Map<String, Integer>();
		Map<String, Integer> pd2Cas = new Map<String, Integer>();
		Map<String, Integer> pd3Cas = new Map<String, Integer>();
		Map<String, Integer> pd4Cas = new Map<String, Integer>();

		Map<String, Integer> pd1Cea = new Map<String, Integer>();
		Map<String, Integer> pd2Cea = new Map<String, Integer>();
		Map<String, Integer> pd3Cea = new Map<String, Integer>();
		Map<String, Integer> pd4Cea = new Map<String, Integer>();

		Map<String, Integer> pd1Ttl = new Map<String, Integer>();
		Map<String, Integer> pd2Ttl = new Map<String, Integer>();
		Map<String, Integer> pd3Ttl = new Map<String, Integer>();
		Map<String, Integer> pd4Ttl = new Map<String, Integer>();

		for(AggregateResult ar : arList){
			String period = String.valueOf(ar.get('period'));
			Id physicianId = String.valueOf(ar.get('physicanId'));
			String physName = String.valueOf(ar.get('physName'));

			String firstName = String.valueOf(ar.get('firstName'));
			String middleName = String.valueOf(ar.get('middleName'));
			String lastName = String.valueOf(ar.get('lastName'));

			//String leadStatus = String.valueOf(ar.get('leadStatus'));
			String specialty = String.valueOf(ar.get('specialty'));

			Integer cas = Integer.valueOf(ar.get('cas'));
			Integer cea = Integer.valueOf(ar.get('cea'));
			Integer ttl = Integer.valueOf(ar.get('ttl'));

			if(physName != null){
				physicianSet.add(physName);
				physianIdMap.put(physName, physicianId);
				physNameMap.put(physName, physName);

				firstNameMap.put(physName, firstName);
				middleNameMap.put(physName, middleName);
				lastNameMap.put(physName, lastName);

				specialtyMap.put(physName, specialty);
				//leadStatMap.put(physName, leadStatus);


				if(period == pd1){
					pd1Cas.put(physName, cas);
					pd1Cea.put(physName, cea);
					pd1Ttl.put(physName, ttl);
				} 
				else if(period == pd2){
					pd2Cas.put(physName, cas);
					pd2Cea.put(physName, cea);
					pd2Ttl.put(physName, ttl);
				}
				else if(period == pd3){
					pd3Cas.put(physName, cas);
					pd3Cea.put(physName, cea);
					pd3Ttl.put(physName, ttl);
				}
				else if(period == pd4){
					pd4Cas.put(physName, cas);
					pd4Cea.put(physName, cea);
					pd4Ttl.put(physName, ttl);
				}
			}	
		}

		List<DRG_Physician__c> drgPhList = [SELECT Id, Lead_Status__c FROM DRG_Physician__c WHERE Id IN : physianIdMap.values()];
		Map<String, String> leadStatusMap = new Map<String, String>();
		for(DRG_Physician__c drgPh : drgPhList){
			leadStatusMap.put(drgPh.Id, drgPh.Lead_Status__c);
		}

		List<ProcedureCountWrapper> pcwList = new List<ProcedureCountWrapper>();

		for(String s : physicianSet){

			ProcedureCountWrapper pcw = new ProcedureCountWrapper();
			
			pcw.SortByProcedures = sortByProcedures;
	
			String firstName = firstNameMap.get(s);
			String middleName = middleNameMap.get(s);
			String lastName = lastNameMap.get(s);

			String entityName;

			if(middleName == null && lastName == null){
				entityName = firstName;
			}
			else if(middleName == null && lastName != null){
				entityName = lastName + ', ' + firstName; 
			}
			else{
				entityName = lastName + ', ' + firstName + ' ' + middleName;
			}	



			pcw.EntityName = entityName;

			pcw.RecordId = physianIdMap.get(s);
			pcw.LeadStatus = leadStatusMap.get(physianIdMap.get(s));
			pcw.Specialty = specialtyMap.get(s);

			if(pd1Cas.get(s) == null){ pcw.CASPeriod1 = 0; } else { pcw.CASPeriod1 = pd1Cas.get(s); }
			if(pd1Cea.get(s) == null){ pcw.CEAPeriod1 = 0; } else { pcw.CEAPeriod1 = pd1Cea.get(s); }

			if(pd2Cas.get(s) == null){ pcw.CASPeriod2 = 0; } else { pcw.CASPeriod2 = pd2Cas.get(s); }
			if(pd2Cea.get(s) == null){ pcw.CEAPeriod2 = 0; } else { pcw.CEAPeriod2 = pd2Cea.get(s); }
			
			if(pd3Cas.get(s) == null){ pcw.CASPeriod3 = 0; } else { pcw.CASPeriod3 = pd3Cas.get(s); }
			if(pd3Cea.get(s) == null){ pcw.CEAPeriod3 = 0; } else { pcw.CEAPeriod3 = pd3Cea.get(s); }
			
			if(pd4Cas.get(s) == null){ pcw.CASPeriod4 = 0; } else { pcw.CASPeriod4 = pd4Cas.get(s); }
			if(pd4Cea.get(s) == null){ pcw.CEAPeriod4 = 0; } else { pcw.CEAPeriod4 = pd4Cea.get(s); }
			
			pcw.TotalProcedures = pcw.CASPeriod4 + pcw.CEAPeriod4;

			pcwList.add(pcw);
			pcwList.sort();		
		}

		return pcwList;
	}






	@AuraEnabled
	public static List<ProcedureCountWrapper> setOnlyOnePhysician(Id physicianRecordId){
		List<AggregateResult> arList = [SELECT 	SUM(CAS__c) cas, 
													SUM(CEA__c) cea, 
													SUM(Total__c) ttl, 
													Period__c period, 
													DRG_Physician_Id__c physicanId,
													DRG_Physician_Id__r.Name physName,
													DRG_Physician_Id__r.NPI_Number__c npi,
													DRG_Physician_Id__r.Primary_Specialty__c specialty
										FROM 		DRG_Procedure__c
										WHERE 		DRG_Physician_Id__c = : physicianRecordId
										GROUP BY 	Period__c,
											        DRG_Physician_Id__c,
											        DRG_Physician_Id__r.Name,
											        DRG_Physician_Id__r.Primary_Specialty__c,
											        DRG_Physician_Id__r.NPI_Number__c
											        ];	

    	Set<String> physNameSet = new Set<String>();	


		Map<String, Id> physianIdMap = new Map<String, Id>();
		Map<String, String> specialtyMap = new Map<String, String>();
		Map<String, String> npiMap = new Map<String, String>();

		Map<String, Integer> pd1Cas = new Map<String, Integer>();
		Map<String, Integer> pd2Cas = new Map<String, Integer>();
		Map<String, Integer> pd3Cas = new Map<String, Integer>();
		Map<String, Integer> pd4Cas = new Map<String, Integer>();

		Map<String, Integer> pd1Cea = new Map<String, Integer>();
		Map<String, Integer> pd2Cea = new Map<String, Integer>();
		Map<String, Integer> pd3Cea = new Map<String, Integer>();
		Map<String, Integer> pd4Cea = new Map<String, Integer>();

		Map<String, Integer> pd1Ttl = new Map<String, Integer>();
		Map<String, Integer> pd2Ttl = new Map<String, Integer>();
		Map<String, Integer> pd3Ttl = new Map<String, Integer>();
		Map<String, Integer> pd4Ttl = new Map<String, Integer>();

		for(AggregateResult ar : arList){
			String period = String.valueOf(ar.get('period'));
			Id physicianId = String.valueOf(ar.get('physicanId'));
			String physName = String.valueOf(ar.get('physName'));
			String specialty = String.valueOf(ar.get('specialty'));
			String npi = String.valueOf(ar.get('npi'));

			Integer cas = Integer.valueOf(ar.get('cas'));
			Integer cea = Integer.valueOf(ar.get('cea'));
			Integer ttl = Integer.valueOf(ar.get('ttl'));

			if(physName != null){
				physNameSet.add(physName);
				physianIdMap.put(physName, physicianId);
				specialtyMap.put(physName, specialty);
				npiMap.put(physName, npi);

				if(period == pd1){
					pd1Cas.put(physName, cas);
					pd1Cea.put(physName, cea);
					pd1Ttl.put(physName, ttl);
				} 
				else if(period == pd2){
					pd2Cas.put(physName, cas);
					pd2Cea.put(physName, cea);
					pd2Ttl.put(physName, ttl);
				}
				else if(period == pd3){
					pd3Cas.put(physName, cas);
					pd3Cea.put(physName, cea);
					pd3Ttl.put(physName, ttl);
				}
				else if(period == pd4){
					pd4Cas.put(physName, cas);
					pd4Cea.put(physName, cea);
					pd4Ttl.put(physName, ttl);
				}
			}	
		}

		List<DRG_Physician__c> drgPhList = [SELECT Id, Name, Lead_Status__c FROM DRG_Physician__c WHERE Id IN : physianIdMap.values()];
		Map<String, String> leadStatusMap = new Map<String, String>();
		for(DRG_Physician__c drgPh : drgPhList){
			leadStatusMap.put(drgPh.Name, drgPh.Lead_Status__c);
		}

		List<ProcedureCountWrapper> pcwList = new List<ProcedureCountWrapper>();

		for(String s : physNameSet){

			ProcedureCountWrapper pcw = new ProcedureCountWrapper();
	
			pcw.EntityName = s;

			pcw.RecordId = physianIdMap.get(s);
			pcw.LeadStatus = leadStatusMap.get(s);
			pcw.Specialty = specialtyMap.get(s);
			pcw.NPI_Number = npiMap.get(s);


			if(pd1Cas.get(s) == null){ pcw.CASPeriod1 = 0; } else { pcw.CASPeriod1 = pd1Cas.get(s); }
			if(pd1Cea.get(s) == null){ pcw.CEAPeriod1 = 0; } else { pcw.CEAPeriod1 = pd1Cea.get(s); }

			if(pd2Cas.get(s) == null){ pcw.CASPeriod2 = 0; } else { pcw.CASPeriod2 = pd2Cas.get(s); }
			if(pd2Cea.get(s) == null){ pcw.CEAPeriod2 = 0; } else { pcw.CEAPeriod2 = pd2Cea.get(s); }
			
			if(pd3Cas.get(s) == null){ pcw.CASPeriod3 = 0; } else { pcw.CASPeriod3 = pd3Cas.get(s); }
			if(pd3Cea.get(s) == null){ pcw.CEAPeriod3 = 0; } else { pcw.CEAPeriod3 = pd3Cea.get(s); }
			
			if(pd4Cas.get(s) == null){ pcw.CASPeriod4 = 0; } else { pcw.CASPeriod4 = pd4Cas.get(s); }
			if(pd4Cea.get(s) == null){ pcw.CEAPeriod4 = 0; } else { pcw.CEAPeriod4 = pd4Cea.get(s); }
			
			pcw.TotalProcedures = 0;
			pcw.TotalProcedures = pcw.CASPeriod4 + pcw.CEAPeriod4;

			pcwList.add(pcw);
			pcwList.sort();		
		}

		return pcwList;
	}





	@AuraEnabled
	public static List<ProcedureCountWrapper> getProceduresByPhysicianFromSearch(String searchString){

		List<AggregateResult> arList = [SELECT 	SUM(CAS__c) cas, 
													SUM(CEA__c) cea, 
													SUM(Total__c) ttl, 
													Period__c period, 
													DRG_Physician_Id__c physicianId,
													DRG_Physician_Id__r.Name physName,
													DRG_Physician_Id__r.NPI_Number__c npi,
													DRG_Physician_Id__r.Primary_Specialty__c specialty,
													DRG_Facility_Id__c facilityId,
													DRG_Facility_Id__r.Name hospital,
													DRG_Facility_Id__r.City__c city,
													DRG_Facility_Id__r.State_Provence__c state
										FROM 		DRG_Procedure__c
										WHERE 		DRG_Physician_Id__r.Name LIKE  : searchString
										AND 		DRG_Physician_Id__r.Lead_Status__c = 'DRG'
										AND 		DRG_Facility_Id__r.Lead_Status__c <> 'DRG' 
										AND 		DRG_Physician_Id__r.Name <> 'other'
										GROUP BY 	Period__c,
											        DRG_Physician_Id__c,
													DRG_Physician_Id__r.Name,
													DRG_Physician_Id__r.NPI_Number__c,
													DRG_Physician_Id__r.Primary_Specialty__c,
													DRG_Facility_Id__c,
													DRG_Facility_Id__r.Name,
													DRG_Facility_Id__r.City__c,
													DRG_Facility_Id__r.State_Provence__c
											        ];								        	

        Set<String> keysetString = new Set<String>();

    	Set<Id> physIdSet = new Set<Id>();	

		Map<String, String> physNameMap = new Map<String, String>();
		Map<String, String> npiMap = new Map<String, String>();
		Map<String, String> specialtyMap = new Map<String, String>();
		Map<String, String> hospitalMap = new Map<String, String>();
		Map<String, Id> facilityIdMap = new Map<String, Id>();
		Map<String, String> cityMap = new Map<String, String>();
		Map<String, String> stateMap = new Map<String, String>();

		Map<String, Integer> pd1Cas = new Map<String, Integer>();
		Map<String, Integer> pd2Cas = new Map<String, Integer>();
		Map<String, Integer> pd3Cas = new Map<String, Integer>();
		Map<String, Integer> pd4Cas = new Map<String, Integer>();

		Map<String, Integer> pd1Cea = new Map<String, Integer>();
		Map<String, Integer> pd2Cea = new Map<String, Integer>();
		Map<String, Integer> pd3Cea = new Map<String, Integer>();
		Map<String, Integer> pd4Cea = new Map<String, Integer>();

		Map<String, Integer> pd1Ttl = new Map<String, Integer>();
		Map<String, Integer> pd2Ttl = new Map<String, Integer>();
		Map<String, Integer> pd3Ttl = new Map<String, Integer>();
		Map<String, Integer> pd4Ttl = new Map<String, Integer>();

		for(AggregateResult ar : arList){
			String period = String.valueOf(ar.get('period'));
			String physName = String.valueOf(ar.get('physName'));
			String physicianId = String.valueOf(ar.get('physicianId'));
			String npi = String.valueOf(ar.get('npi'));
			String specialty = String.valueOf(ar.get('specialty'));
			String hospital = String.valueOf(ar.get('hospital'));
			Id facilityId = String.valueOf(ar.get('facilityId'));
			String city = String.valueOf(ar.get('city'));
			String state = String.valueOf(ar.get('state'));

			Integer cas = Integer.valueOf(ar.get('cas'));
			Integer cea = Integer.valueOf(ar.get('cea'));
			Integer ttl = Integer.valueOf(ar.get('ttl'));

			String indexString = physicianId + '-' + facilityId;

			if(physName != null){
				physIdSet.add(physicianId);

				keysetString.add(indexString);	

				physNameMap.put(indexString, physName);
				npiMap.put(indexString, npi);
				specialtyMap.put(indexString, specialty);
				hospitalMap.put(indexString, hospital);
				facilityIdMap.put(indexString, facilityId);
				cityMap.put(indexString, city);
				stateMap.put(indexString, state);

				if(period == pd1){
					pd1Cas.put(indexString, cas);
					pd1Cea.put(indexString, cea);
					pd1Ttl.put(indexString, ttl);
				} 
				else if(period == pd2){
					pd2Cas.put(indexString, cas);
					pd2Cea.put(indexString, cea);
					pd2Ttl.put(indexString, ttl);
				}
				else if(period == pd3){
					pd3Cas.put(indexString, cas);
					pd3Cea.put(indexString, cea);
					pd3Ttl.put(indexString, ttl);
				}
				else if(period == pd4){
					pd4Cas.put(indexString, cas);
					pd4Cea.put(indexString, cea);
					pd4Ttl.put(indexString, ttl);
				}
			}	
		}

		List<DRG_Physician__c> drgPhList = [SELECT Id, Name, Lead_Status__c FROM DRG_Physician__c WHERE Id IN : physIdSet];
		Map<String, String> leadStatusMap = new Map<String, String>();
		for(DRG_Physician__c drgPh : drgPhList){
			leadStatusMap.put(drgPh.Name, drgPh.Lead_Status__c);
		}

		List<ProcedureCountWrapper> pcwList = new List<ProcedureCountWrapper>();

		for(String s : keysetString){


			ProcedureCountWrapper pcw = new ProcedureCountWrapper();

			pcw.RecordId = s;
			pcw.SortByProcedures = FALSE;	
			pcw.EntityName = physNameMap.get(s);

			pcw.NPI_Number = npiMap.get(s);
			pcw.Specialty = specialtyMap.get(s);
			pcw.Hospital = hospitalMap.get(s);
			pcw.AccountId = facilityIdMap.get(s);
			pcw.City = cityMap.get(s);
			pcw.State = stateMap.get(s);


			if(pd1Cas.get(s) == null){ pcw.CASPeriod1 = 0; } else { pcw.CASPeriod1 = pd1Cas.get(s); }
			if(pd1Cea.get(s) == null){ pcw.CEAPeriod1 = 0; } else { pcw.CEAPeriod1 = pd1Cea.get(s); }

			if(pd2Cas.get(s) == null){ pcw.CASPeriod2 = 0; } else { pcw.CASPeriod2 = pd2Cas.get(s); }
			if(pd2Cea.get(s) == null){ pcw.CEAPeriod2 = 0; } else { pcw.CEAPeriod2 = pd2Cea.get(s); }
			
			if(pd3Cas.get(s) == null){ pcw.CASPeriod3 = 0; } else { pcw.CASPeriod3 = pd3Cas.get(s); }
			if(pd3Cea.get(s) == null){ pcw.CEAPeriod3 = 0; } else { pcw.CEAPeriod3 = pd3Cea.get(s); }
			
			if(pd4Cas.get(s) == null){ pcw.CASPeriod4 = 0; } else { pcw.CASPeriod4 = pd4Cas.get(s); }
			if(pd4Cea.get(s) == null){ pcw.CEAPeriod4 = 0; } else { pcw.CEAPeriod4 = pd4Cea.get(s); }
			
			pcw.TotalProcedures = pcw.CASPeriod4 + pcw.CEAPeriod4;

			pcwList.add(pcw);
			pcwList.sort();		
		}

		return pcwList;
									

	}

/* WRAPPER CLASS FIELD LIST
			SortByProcedures    	=
			EntityName           	=
			Vqi                  	=
			Cas                  	=              
			RecordId             	=
			LeadStatus           	=
			Specialty            	=
			NPI_Number 				=
			Hospital 				=
			MedicareProvderId		=
			Street 					=
			City 					=
			State 					=
			Zip 					=
			CkBox                	=
			CASPeriod1           	=
			CEAPeriod1           	=
			CASPeriod2           	=
			CEAPeriod2           	=
			CASPeriod3           	=
			CEAPeriod3           	=
			CASPeriod4           	=
			CEAPeriod4           	=
			TotalProcedures      	=
*/



	/******************************************************************************************
	*******     C O N V E R T  T O   O P P O R T U N I T Y    *********************************
	*******************************************************************************************/




	@AuraEnabled
	public static String convertFacilityToOpportunity(Id facilityRecordId){
		DRG_Facility__c drgF = [SELECT 		Beds__c,
											CAS_Module__c,
											Census_Region__c,
											City__c,
											Country__c,
											County__c,
											Discharges__c,
											AccountId__c,
											Id,
											Name,
											Lead_Status__c,
											Medicare_Provider_ID__c,
											Parent_Network_Name__c,
											Patient_Days__c,
											Postal_Code__c,
											Revenue__c,
											Rural_or_Urban__c,
											State_Provence__c,
											Street_Address__c,
											VQI_Member__c
								FROM 		DRG_Facility__c
								WHERE		Id = : facilityRecordId			
								LIMIT 		1];


		update drgF;

		String medicareProviderId = drgF.Medicare_Provider_ID__c;

		List<Account> existAcctList = [SELECT Id, Medicare_Provider_Id__c,
												RecordTypeId,
												BillingCity,
												ShippingCity,
												BillingCountry,
												ShippingCountry,
												Name,
												Parent_Network_Name__c,
												BillingPostalCode,
												ShippingPostalCode,
												BillingState,
												ShippingState,
												BillingStreet,
												ShippingStreet,
												VQI_Status__c,
												OwnerId
										 FROM 	Account 
										 WHERE  Medicare_Provider_Id__c = : medicareProviderId
										 LIMIT  1];

		Account newProspectAccount;

		if(existAcctList != null && existAcctList.size() > 0 && medicareProviderId != null){
			newProspectAccount = existAcctList[0];
		}
		else{
			newProspectAccount = newAccountFromDrgFacility(drgF);
		}
		

		List<Contact> newPhysicianContactList = newPhysicianContactsFromDrgFacility(newProspectAccount.Id, drgF);
		Opportunity newOpportunityFromDrgFacility = opportunityFromDrgFacility(newProspectAccount, newPhysicianContactList);

		//return drgF;

		return newOpportunityFromDrgFacility.Id;

	}




	@AuraEnabled
	public static Account newAccountFromDrgFacility(DRG_Facility__c drgF){

		Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Prospective Hospital' LIMIT 1][0].Id;
		
		Account newProspectAccount = new Account();
		
		newProspectAccount.RecordTypeId = recordTypeId;
		
		newProspectAccount.BillingCity = drgF.City__c;
		newProspectAccount.ShippingCity = drgF.City__c;
		
		newProspectAccount.BillingCountry = drgF.Country__c;
		newProspectAccount.ShippingCountry = drgF.Country__c;

		newProspectAccount.Name = drgF.Name;
		
		newProspectAccount.Medicare_Provider_Id__c = drgF.Medicare_Provider_Id__c;

		newProspectAccount.Parent_Network_Name__c = drgF.Parent_Network_Name__c;

		newProspectAccount.BillingPostalCode = drgF.Postal_Code__c;
		newProspectAccount.ShippingPostalCode = drgF.Postal_Code__c;

		newProspectAccount.BillingState = drgF.State_Provence__c;
		newProspectAccount.ShippingState = drgF.State_Provence__c;

		newProspectAccount.BillingStreet = drgF.Street_Address__c;
		newProspectAccount.ShippingStreet = drgF.Street_Address__c;

		if(drgF.CAS_Module__c && drgF.VQI_Member__c){
			newProspectAccount.VQI_Status__c = 'VQI + CAS';
		}
		else if(drgF.CAS_Module__c && !drgF.VQI_Member__c){
			newProspectAccount.VQI_Status__c = 'CAS';
		}
		else if(!drgF.CAS_Module__c && drgF.VQI_Member__c){
			newProspectAccount.VQI_Status__c = 'VQI';
		}
		else{
			newProspectAccount.VQI_Status__c = 'None';
		}

		
		Id currentUserId = UserInfo.getUserId();
		User u = [SELECT Id, QAD_Territory_Id__c FROM User WHERE Id = : currentUserId LIMIT 1];
		String territoryCode;
		if(u.QAD_Territory_Id__c != null && u.QAD_Territory_Id__c.Left(2) == 'AM'){
			territoryCode = u.QAD_Territory_Id__c;
			newProspectAccount.Area_Manager_User__c = u.Id;
		}
		if(territoryCode != null){
			List<Territory__c> tList = [SELECT Id, Area_Director__c, Area_Director__r.QAD_Territory_Id__c, QAD_AM_Id__c, Region__c FROM Territory__c WHERE isActive__c = true AND QAD_AM_Id__c = : territoryCode];
			if(tList.size() == 1){
				Territory__c t = tList[0];
			
				newProspectAccount.Region__c = t.Region__c;

				String qadTerr = t.Area_Director__r.QAD_Territory_Id__c + '-' + t.QAD_AM_Id__c;
				newProspectAccount.QAD_cm_slspsn__c = qadTerr;

				if(t.Area_Director__c != null){
					SYSTEM.DEBUG('Area Director = [' + t.Area_Director__c + ']');
					newProspectAccount.Area_Director_Id__c = t.Area_Director__c;
				}
			}
		}



		newProspectAccount.OwnerId = currentUserId;

		insert newProspectAccount;

		drgF.AccountId__c = newProspectAccount.Id;

		update drgF;

		return newProspectAccount;


	}





	@AuraEnabled
	public static List<Contact> newPhysicianContactsFromDrgFacility(Id newProspectAccountId, DRG_Facility__c drgF){

		Set<String> npiSet = new Set<String>();
		List<DRG_Procedure__c> drgPrList = [SELECT DRG_Physician_Id__r.NPI_Number__c FROM DRG_Procedure__c WHERE DRG_Facility_Id__c = : drgF.Id];

		for(DRG_Procedure__c drgPr : drgPrList){
			if(drgPr.DRG_Physician_Id__r.NPI_Number__c != null && drgPr.DRG_Physician_Id__r.NPI_Number__c != ''){
				npiSet.add(drgPr.DRG_Physician_Id__r.NPI_Number__c);
			}	
		}

		
		List<Contact> newPhysicianList = new List<Contact>();
		
		List<DRG_Physician__c> drgPhList = [SELECT 			ContactId__c,
															Name,
															First_Name__c,
															Last_Name__c,
															Lead_Status__c,
															Legal_Business_Name__c,
															Middle_Name__c,
															NPI_Number__c,
															Postal_Code__c,
															Primary_Specialty__c,
															State_Provence__c	
												FROM 		DRG_Physician__c
												WHERE 		NPI_Number__c IN : npiSet];

		Set<Id> allContactIdSet = new Set<Id>();
		
		//CHECK TO SEE IF CONTACT ALREADY EXISTS
		Map<String, Contact> existingContactMap = new Map<String, Contact>();
		List<Contact> existingContacts = [SELECT Id, FirstName, LastName, NPI_Number__c, AccountId FROM Contact WHERE NPI_Number__c IN : npiSet];

		for(Contact c : existingContacts){
			existingContactMap.put(c.NPI_Number__c,c);
			allContactIdSet.add(c.Id);
		}	



		Id currUserId = UserInfo.getUserId();

		// CREATE NEW CONTACT RECORDS
		Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND Name = 'Physician' LIMIT 1][0].Id;

		for(DRG_Physician__c drgPh : drgPhList){
			//FOR CONTACTS THAT DO NOT EXIST
			if(!existingContactMap.keySet().Contains(drgPh.NPI_Number__c)){
				Contact c = new Contact();
				c.FirstName = drgPh.First_Name__c;
				c.LastName = drgPh.Last_Name__c;
				c.MiddleName = drgPh.Middle_Name__c;
				c.NPI_Number__c = drgPh.NPI_Number__c;
				c.Primary_Specialty__c = drgPh.Primary_Specialty__c;
				c.AccountId = newProspectAccountId;
				c.Original_DRG_Full_Name__c = drgPh.Name;
				c.OwnerId = currUserId;
				newPhysicianList.add(c);
			}	

		}
		insert newPhysicianList;

		for(Contact c : newPhysicianList){
			allContactIdSet.add(c.Id);
		}

		//BUILD INDEX OF EXISTING HOSPITAL AFFILIATIONS TO PREVENT DUPLICATES
		List<Hospital_Affiliation__c> existingHaList = [SELECT ID, Physician__c, Hospital__c FROM Hospital_Affiliation__c WHERE Physician__c IN : allContactIdSet ORDER BY Physician__c ASC];
		Set<String> haKeyString = new Set<String>();
		for(Hospital_Affiliation__c ha : existingHaList){
			String keyString = ha.Hospital__c + '-' + ha.Physician__c;
			haKeyString.add(keyString);
		}

		// UPDATE DRG_PHYSICIAN_DATA WITH NEW CONTACT ID's
		Map<String, Id> contactFnToIdMap = new Map<String, Id>();

		for(Contact c : newPhysicianList){
			contactFnToIdMap.put(c.Original_DRG_Full_Name__c, c.Id);
		}

		for(DRG_Physician__c drgPh : drgPhList){
			if(contactFnToIdMap.get(drgPh.Name) != null){
				drgPh.ContactId__c = contactFnToIdMap.get(drgPh.Name);
			}
		}

		update drgPhList;

		// BUILD HOSPITAL AFFILIATIONS TO ACCUNT WITH NEWLY CREATED CONTACTS
		List<Hospital_Affiliation__c> haList = new List<Hospital_Affiliation__c>();
		for(Contact c : newPhysicianList){
			String keyString = c.AccountId + '-' + c.Id;
			if(!haKeyString.contains(keyString)){
				Hospital_Affiliation__c ha = new Hospital_Affiliation__c();
				ha.Hospital__c = c.AccountId;
				ha.Physician__c = c.Id;
				haList.add(ha);
			}
		}

		//NOW CREATE NEW HOSPITAL AFFILIATIONS FOR PREVIOUSLY EXISTING CONTACTS
		for(Contact c : existingContactMap.Values()){
			String keyString = c.AccountId + '-' + c.Id;
			if(!haKeyString.contains(keyString)){
				Hospital_Affiliation__c ha = new Hospital_Affiliation__c();
				ha.Hospital__c = newProspectAccountId;
				ha.Physician__c = c.Id;
				haList.add(ha);
			}	
		}
			
		insert haList;	

		return newPhysicianList;
	}





	@AuraEnabled
	public static Contact newPhysicianContactsFromDrgPhysician(ProcedureCountWrapper pcw, Id facilityRecordId){

		Id currentUserId = UserInfo.getUserId();

		DRG_Facility__c drgFa = [SELECT AccountId__c, Parent_Network_Name__c FROM DRG_Facility__c WHERE Id = : facilityRecordId LIMIT 1];
		DRG_Physician__c drgPh = [SELECT Id, Name, ContactId__c, Primary_Specialty__c FROM DRG_Physician__c WHERE Id = : pcw.RecordId LIMIT 1];
		
		//CHECK TO SEE IF CONTACT ALREADY EXISTS
		List<Contact> cList = [SELECT Id, Original_DRG_Full_Name__c, AccountId, Account.VQI_Status__c FROM Contact WHERE NPI_Number__c = : pcw.NPI_Number LIMIT 1];
		
		Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND Name = 'Physician' LIMIT 1][0].Id;
		
		Contact c = new Contact();

		if(pcw.ContactID == null && cList.size() != 0){
			c = cList[0];
		}
		else if(drgPh.ContactId__c == null && cList.size() == 0){
			c = new Contact();
				c.FirstName = pcw.FirstName;
				c.LastName = pcw.LastName;
				c.MiddleName = pcw.MiddleName;
				c.NPI_Number__c = pcw.NPI_Number;

				c.CAS_Procedures_2015__c = pcw.CASPeriod1;
				c.CEA_Procedures_2015__c = pcw.CEAPeriod1;
				c.CAS_Procedures_2016__c = pcw.CASPeriod2;
				c.CEA_Procedures_2016__c = pcw.CEAPeriod2;
				c.CAS_Procedures_2017__c = pcw.CASPeriod3;
				c.CEA_Procedures_2017__c = pcw.CEAPeriod3;
				c.CAS_Proc_Most_Recent_12_Mo__c = pcw.CASPeriod4;
				c.CAS_Proc_Most_Recent_12_Mo__c = pcw.CEAPeriod4;
				
				c.Parent_Network_Name__c = drgFa.Parent_Network_Name__c;
				c.Primary_Specialty__c = drgPh.Primary_Specialty__c;
				c.AccountId = drgFa.AccountId__c;
				c.Original_DRG_Full_Name__c = drgPh.Name;
				c.OwnerId = currentUserId;

			insert c;
		}
		else if(pcw.ContactId != null){ 
			c = [SELECT Id, Original_DRG_Full_Name__c, AccountId, Account.VQI_Status__c FROM Contact WHERE Id = : pcw.ContactId LIMIT 1];
		}

		//QUERY ACCOUNTS ASSOCIATED WITH PHYSICIAN
		List<AggregateResult> arList = [SELECT 	DRG_Facility_Id__r.AccountId__c acctId 
										FROM 		DRG_Procedure__c 
										WHERE 		DRG_Physician_Id__c = : pcw.RecordId 
										AND 		DRG_Facility_Id__r.AccountId__c <> null
										GROUP BY 	DRG_Facility_Id__r.AccountId__c];

		Set<Id> acctIdSet = new Set<Id>();
		for(AggregateResult ar : arList){
			Id accountId = String.valueOf(ar.get('acctId'));
			acctIdSet.add(accountId);
		}	

		//QUERY EXISTING HOSPITAL ASSOCIATIONS WITH THIS CONTACT
		List<Hospital_Affiliation__c> existingHaList = [SELECT Hospital__c, Physician__c FROM Hospital_Affiliation__c WHERE Physician__c = : c.Id];

		Set<String> haIndexSet = new Set<String>();
		for(Hospital_Affiliation__c ha : existingHaList){
			String indexKey = ha.Hospital__c + '-' + ha.Physician__c;
			haIndexSet.add(indexKey);
		}
							

		// BUILD HOSPITAL AFFILIATIONS TO ACCUNT WITH NEWLY CREATED CONTACTS WHERE NEEDED
		List<Hospital_Affiliation__c> haList = new List<Hospital_Affiliation__c>();
		for(String acctId : acctIdSet){
			String indexKey = acctId + '-' + pcw.ContactId;
			if(!haIndexSet.contains(indexKey) && c.Id != null){
				Hospital_Affiliation__c ha = new Hospital_Affiliation__c();
				ha.Hospital__c = acctId;
				ha.Physician__c = c.Id;
				haList.add(ha);
			}
		}

		//UPDATE DRG_Physician__c Record
		drgPh.ContactId__c = c.Id;
		update drgPh;

		insert haList;

		return c;
	}





	@AuraEnabled
	public static Opportunity opportunityFromDrgFacility(Account newProspectAccount, List<Contact> newPhysicianConactList){
		
		Id currentUserId = UserInfo.getUserId();

		Id rtId = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND Name = 'Hospital' LIMIT 1].Id;

		// CREATE THE OPPORTUNITY
		Opportunity newOpportunityFromDrgFacility = new Opportunity();
		newOpportunityFromDrgFacility.Name = newProspectAccount.Name;
		newOpportunityFromDrgFacility.AccountId = newProspectAccount.Id;
		newOpportunityFromDrgFacility.Type = 'New Business';
		newOpportunityFromDrgFacility.RecordTypeId = rtId; 
		newOpportunityFromDrgFacility.StageName = 'Qualification';
		newOpportunityFromDrgFacility.CloseDate = System.Today().addDays(+90);
		newOpportunityFromDrgFacility.Projected_Close_Date__c = System.Today().addDays(+90);
 		newOpportunityFromDrgFacility.Probability = 50; 
 		newOpportunityFromDrgFacility.OwnerId = currentUserId;

		insert newOpportunityFromDrgFacility;

		// CREATE THE OPPORTUNITYCONTACT ROLES
		List<OpportunityContactRole> oppContRoleList = new List<OpportunityContactRole>();
		for(Contact c : newPhysicianConactList){
			OpportunityContactRole oppContRole = new OpportunityContactRole();
			oppContRole.ContactId = c.Id;
			oppContRole.OpportunityId = newOpportunityFromDrgFacility.Id;
			oppContRole.Role = 	'Influencer';
			oppContRoleList.add(oppContRole);
		}
		insert oppContRoleList;

		return newOpportunityFromDrgFacility;
	}






	@AuraEnabled
	public static Id convertPhysicianToOpportunity(Id physicianRecordId, Id facilityRecordId){

		SYSTEM.DEBUG('FACILITY ID = [' + facilityRecordId + ']');


		List<AggregateResult> arList = [SELECT 		Sum(CAS__c) cas,
													Sum(CEA__c) cea,
													SUM(Total__c) ttl,
													Period__c period,	
													DRG_Physician_Id__c physId,
													DRG_Physician_Id__r.ContactId__c contId,
													DRG_Physician_Id__r.Name physName,
													DRG_Physician_Id__r.First_Name__c firstName,
													DRG_Physician_Id__r.Last_Name__c lastName,
													DRG_Physician_Id__r.Middle_Name__c middleName,
													DRG_Physician_Id__r.NPI_Number__c npi,
													DRG_Physician_Id__r.Primary_Specialty__c specialty		
										FROM 		DRG_Procedure__c
										WHERE   	DRG_Physician_Id__c = : physicianRecordId
										GROUP BY	DRG_Physician_Id__c,
													Period__c,
													DRG_Physician_Id__r.ContactId__c,
													DRG_Physician_Id__r.Name,
													DRG_Physician_Id__r.First_Name__c,
													DRG_Physician_Id__r.Last_Name__c,
													DRG_Physician_Id__r.Middle_Name__c,
													DRG_Physician_Id__r.NPI_Number__c,
													DRG_Physician_Id__r.Primary_Specialty__c
													];




		Set<Id> physIdSet = new Set<Id>();	

		Map<Id, String> contIdMap = new Map<Id, String>();
		Map<Id, String> physNameMap = new Map<Id, String>();
		Map<Id, String> firstNameMap = new Map<Id, String>();
		Map<Id, String> lastNameMap = new Map<Id, String>();
		Map<Id, String> middleNameMap = new Map<Id, String>();
		Map<Id, String> npiMap = new Map<Id, String>();
		Map<Id, String> specialtyMap = new Map<Id, String>();


		Map<String, Integer> pd1Cas = new Map<String, Integer>();
		Map<String, Integer> pd2Cas = new Map<String, Integer>();
		Map<String, Integer> pd3Cas = new Map<String, Integer>();
		Map<String, Integer> pd4Cas = new Map<String, Integer>();

		Map<String, Integer> pd1Cea = new Map<String, Integer>();
		Map<String, Integer> pd2Cea = new Map<String, Integer>();
		Map<String, Integer> pd3Cea = new Map<String, Integer>();
		Map<String, Integer> pd4Cea = new Map<String, Integer>();

		Map<String, Integer> pd1Ttl = new Map<String, Integer>();
		Map<String, Integer> pd2Ttl = new Map<String, Integer>();
		Map<String, Integer> pd3Ttl = new Map<String, Integer>();
		Map<String, Integer> pd4Ttl = new Map<String, Integer>();

		for(AggregateResult ar : arList){
			String period = String.valueOf(ar.get('period'));
			Id physicianId = String.valueOf(ar.get('physId'));
			Id contId = String.valueOf(ar.get('contId'));
			String physName = String.valueOf(ar.get('physName'));
			String firstName = String.valueOf(ar.get('firstName'));
			String lastName = String.valueOf(ar.get('lastName'));
			String middleName = String.valueOf(ar.get('middleName'));
			String npi = String.valueOf(ar.get('npi'));
			String specialty = String.valueOf(ar.get('specialty'));

			Integer cas = Integer.valueOf(ar.get('cas'));
			Integer cea = Integer.valueOf(ar.get('cea'));
			Integer ttl = Integer.valueOf(ar.get('ttl'));
			
			if(physName != null){
				physIdSet.add(physicianId);
				contIdMap.put(physicianId, contId);
				physNameMap.put(physicianId, physName);
				firstNameMap.put(physicianId, firstName);
				lastNameMap.put(physicianId, lastName);
				middleNameMap.put(physicianId, middleName);
				npiMap.put(physicianId, npi);
				specialtyMap.put(physicianId, specialty);


				if(period == pd1){
					pd1Cas.put(physicianId, cas);
					pd1Cea.put(physicianId, cea);
					pd1Ttl.put(physicianId, ttl);
				} 
				else if(period == pd2){
					pd2Cas.put(physicianId, cas);
					pd2Cea.put(physicianId, cea);
					pd2Ttl.put(physicianId, ttl);
				}
				else if(period == pd3){
					pd3Cas.put(physicianId, cas);
					pd3Cea.put(physicianId, cea);
					pd3Ttl.put(physicianId, ttl);
				}
				else if(period == pd4){
					pd4Cas.put(physicianId, cas);
					pd4Cea.put(physicianId, cea);
					pd4Ttl.put(physicianId, ttl);
				}
			}	
		}

		ProcedureCountWrapper pcw = new ProcedureCountWrapper();

		if(pd1Cas.get(physicianRecordId) == null){ pcw.CASPeriod1 = 0; } else { pcw.CASPeriod1 = pd1Cas.get(physicianRecordId); }
		if(pd1Cea.get(physicianRecordId) == null){ pcw.CEAPeriod1 = 0; } else { pcw.CEAPeriod1 = pd1Cea.get(physicianRecordId); }

		if(pd2Cas.get(physicianRecordId) == null){ pcw.CASPeriod2 = 0; } else { pcw.CASPeriod2 = pd2Cas.get(physicianRecordId); }
		if(pd2Cea.get(physicianRecordId) == null){ pcw.CEAPeriod2 = 0; } else { pcw.CEAPeriod2 = pd2Cea.get(physicianRecordId); }
		
		if(pd3Cas.get(physicianRecordId) == null){ pcw.CASPeriod3 = 0; } else { pcw.CASPeriod3 = pd3Cas.get(physicianRecordId); }
		if(pd3Cea.get(physicianRecordId) == null){ pcw.CEAPeriod3 = 0; } else { pcw.CEAPeriod3 = pd3Cea.get(physicianRecordId); }
		
		if(pd4Cas.get(physicianRecordId) == null){ pcw.CASPeriod4 = 0; } else { pcw.CASPeriod4 = pd4Cas.get(physicianRecordId); }
		if(pd4Cea.get(physicianRecordId) == null){ pcw.CEAPeriod4 = 0; } else { pcw.CEAPeriod4 = pd4Cea.get(physicianRecordId); }
		
		pcw.TotalProcedures = pcw.CASPeriod4 + pcw.CEAPeriod4;

		pcw.SortByProcedures = false;
		pcw.EntityName = physNameMap.get(physicianRecordId);
		pcw.FirstName = firstNameMap.get(physicianRecordId);
		pcw.MiddleName = middleNameMap.get(physicianRecordId);
		pcw.LastName = lastNameMap.get(physicianRecordId);
		pcw.ContactId = contIdMap.get(physicianRecordId);
		pcw.RecordId = physicianRecordId;
		pcw.Specialty = specialtyMap.get(physicianRecordId);
		pcw.NPI_Number = npiMap.get(physicianRecordId);
		
		Contact newPhysicianContact = newPhysicianContactsFromDrgPhysician(pcw, facilityRecordId);
		Opportunity newPhysicianOpportunity = opportunityFromDrgPhysician(newPhysicianContact.Id);

		newPhysicianContact.Converted_From_DRG__c = true;
		update newPhysicianContact;

		return newPhysicianOpportunity.Id;

	}



	@AuraEnabled
	public static Opportunity opportunityFromDrgPhysician(Id newPhysicianContactId){
		
		Id rtId = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND Name = 'Physician' LIMIT 1].Id;

		Contact newPhysicianContact = [SELECT Id, Original_DRG_Full_Name__c, AccountId, Account.VQI_Status__c, FirstName, MiddleName, LastName FROM Contact WHERE Id = : newPhysicianContactId LIMIT 1];

        Id currentUserId = UserInfo.getUserId();

        string npcName = newPhysicianContact.FirstName;
        if(newPhysicianContact.MiddleName != null){
        	npcName = npcName + ' ' + newPhysicianContact.MiddleName + ' ' + newPhysicianContact.LastName;
        }
        else{
        	npcName = npcName + ' ' + newPhysicianContact.LastName;
        }
        
		// CREATE THE OPPORTUNITY
		Opportunity newOpportunityFromDrgPhysician = new Opportunity();
		newOpportunityFromDrgPhysician.Name = npcName;
		newOpportunityFromDrgPhysician.AccountId = newPhysicianContact.AccountId;
		newOpportunityFromDrgPhysician.Type = 'Physician Opportunity';
		newOpportunityFromDrgPhysician.RecordTypeId = rtId;
		newOpportunityFromDrgPhysician.StageName = 'Clinical Readiness';
		newOpportunityFromDrgPhysician.CloseDate = System.Today().addDays(+60);
		newOpportunityFromDrgPhysician.Projected_Close_Date__c = System.Today().addDays(+60);
 		newOpportunityFromDrgPhysician.Probability = 80; 
 		newOpportunityFromDrgPhysician.OwnerId = currentUserId;
 		newOpportunityFromDrgPhysician.Amount = 0;
 		newOpportunityFromDrgPhysician.Expected_Procedures__c = 1;
 		newOpportunityFromDrgPhysician.Physician_Champion__c = newPhysicianContact.Id;
 		if(newPhysicianContact.Account.VQI_Status__c == null){
 			newOpportunityFromDrgPhysician.VQI_Status__c = 'Unknown';
 		}
 		else{
 			newOpportunityFromDrgPhysician.VQI_Status__c = newPhysicianContact.Account.VQI_Status__c;
 		}


		insert newOpportunityFromDrgPhysician;
	
		// CREATE THE OPPORTUNITYCONTACT ROLES
		
		OpportunityContactRole oppContRole = new OpportunityContactRole();
		oppContRole.ContactId = newPhysicianContact.Id;
		oppContRole.OpportunityId = newOpportunityFromDrgPhysician.Id;
		oppContRole.Role = 	'New Physician';
	
		insert oppContRole;

		// SYSTEM.DEBUG('NEW OPPORTUNITY ID = [' + newOpportunityFromDrgPhysician.Id + ']');
  
		return newOpportunityFromDrgPhysician;
	}





 	@AuraEnabled
    public static Id newOppId(Contact regForm1,
    								String hospitalName,
									String providerNumber,
									String parentNetwork,
									Id accountId,
									Id drgFId){

    	Id currUserId = UserInfo.getUserId();
		Id physRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Contact' AND Name = 'Physician' LIMIT 1].Id;


		String fullName = regForm1.FirstName;
		if(regForm1.MiddleName != null && regForm1.MiddleName != ''){
			fullName = fullName + ' ' + regForm1.middleName + ' ' + regForm1.LastName;
		}
		else{
			fullName = fullName + ' ' + regform1.LastName;
		}
		regForm1.Original_DRG_Full_Name__c = fullName;
		regForm1.OwnerId = currUserId;
		regForm1.RecordTypeId = physRecordTypeId;
		regForm1.Original_Indicated_Hospital__c = hospitalName;
		regForm1.Parent_Network_Name__c = parentNetwork;
		regForm1.AccountId = accountId;

        INSERT regForm1;


        Opportunity newOpportunity = opportunityFromDrgPhysician(regForm1.Id);

        return newOpportunity.Id;

    }





}