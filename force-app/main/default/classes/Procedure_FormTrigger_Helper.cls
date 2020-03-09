public without sharing class Procedure_FormTrigger_Helper {
     
	public static void setNameBeforSave(List<Procedure_Form__c> inputProcedureForm) {
		Set<Id> acctIdSet = new Set<Id>();
		Map<Id, Account> accountMap = new Map<Id, Account>();
		for(Procedure_Form__c pf : inputProcedureForm){
			acctIdSet.add(pf.Account__c);
		} 

		List<Account> accountList = [SELECT ID, Name , IQMS_Customer_Number__c FROM Account WHERE Id IN : acctIdSet LIMIT 1];
		for(Account a : accountList){
			accountMap.put(a.Id, a);
		}


		for(Procedure_Form__c pf : inputProcedureForm){
			
			if(accountMap.get(pf.Account__c) != null){
				Account acct = accountMap.get(pf.Account__c);

				String acctName = acct.IQMS_Customer_Number__c + ' - ' + acct.Name;

				Date procDate = System.Today();
				String procType = 'No ProcType';

				if(pf.Procedure_Date__c != null){
					procDate = pf.Procedure_Date__c;
				}
				if(pf.Procedure_Type__c != null){
					procType = pf.Procedure_Type__c;
				}
				String recordName = String.valueOf(procDate) + ' : ' + acctName + ' : ' + procType;

				if(recordName.length() > 79){
					pf.Name = recordName.substring(0,79);
				}
				else{
					pf.Name = recordName;
				}
			}			

		}
		 
	}

	public static void totalValueToGoalBatchLauncher(){
		String yrString = String.valueOf(System.Today().Year());
		if(Test.isRunningTest()){
			yrString = '2018';
		}
		String query = 'SELECT Id, Account__c FROM Procedure_Form__c WHERE TimePeriod__r.Year__c = \'' + yrString + '\' ORDER BY Goal__c';
		ProcedureFormToGoalTotal_Batch m = new ProcedureFormToGoalTotal_Batch(query);
		Database.executeBatch(m, 200);
	}

	public static void totalValueToGoalBatchController(List<Procedure_Form__c> pfList){
		procedureFormFieldUpdates(pfList);
		incrementalUpdateProcedureFormTotals(pfList);	
	}

	public static void totalValueToGoal(String year){
		List<Procedure_Form__c> pfList = [SELECT Id, Account__c FROM Procedure_Form__c WHERE TimePeriod__r.Year__c = : year];
		procedureFormFieldUpdates(pfList);
		incrementalUpdateProcedureFormTotals(pfList);	
	}









	public static void setProcedureEventParams(List<Procedure_Form__c> inputProcedureFormList){
		for(Procedure_Form__c pf : inputProcedureFormList){

			SYSTEM.DEBUG('PF ATTACHED = [' + pf.Event_Attached__c + ']');
			if(pf.Event_Attached__c){
				DateTime startTimeConv  = CalendarAndEvent_Utilities.stringToDateTimeConverter(String.ValueOf(pf.Procedure_Date__c), String.ValueOf(pf.Event_Local_Start_Time__c));
				DateTime endTimeConv  = CalendarAndEvent_Utilities.stringToDateTimeConverter(String.ValueOf(pf.Procedure_Date__c), String.ValueOf(pf.Event_Local_End_Time__c));
				Integer offset = CalendarAndEvent_Utilities.calculateOffset(pf.Event_Local_Time_Zone__c, startTimeConv);

				DateTime startTimeGMTConv = CalendarAndEvent_Utilities.dateTimeGMT(startTimeConv, offset);
				DateTime endTimeGMTConv = CalendarAndEvent_Utilities.dateTimeGMT(endTimeConv, offset);

				pf.Event_StartDateTime__c = startTimeGMTConv;
				pf.Event_EndDateTime__c = endTimeGMTConv;

				pf.Event_DurationMinutes__c = CalendarAndEvent_Utilities.calculateDuation(startTimeGMTConv, endTimeGMTConv);
			}
		}	
	}









	public static void createProcedureEvent(List<Procedure_Form__c> inputProcedureFormList){

		List<Procedure_Form__c> proceduresWithEvents = new List<Procedure_Form__c>();
		for(Procedure_Form__c pf : inputProcedureFormList){
			if(pf.Event_Attached__c){
				proceduresWithEvents.add(pf);
			}
		}
		CalendarAndEvent_Utilities.createNewProcedureEvent(proceduresWithEvents);
	}












	public static void procedureFormFieldUpdates(List<Procedure_Form__c> inputProcedureFormList){
		Set<Id> inputProcedureFormIdSet = new Set<Id>();
		Set<Id> accountIdSet = new Set<Id>();
		for(Procedure_Form__c p : inputProcedureFormList){
			inputProcedureFormIdSet.add(p.Id);
			accountIdSet.add(p.Account__c);
		}

		List<Procedure_Form__c> procedureFormUpdateList = [SELECT ID, Account__c,
																		Account__r.Area_Manager_User__c,
																		Account__r.Area_Manager_User__r.IsActive,
																		AD_Present__c,
																		Additional_Physician_s__c,
																		AM_Present__c,
																		Anesthesia__c,
																		Arterial_Sheath_Access__c,
																		Arterial_Sheath_Placement_Wire__c,
																		Atropene__c,
																		Atropine_Glyuco__c,
																		Case_Type__c,
																		Comments__c,
																		Contrast_Used__c,
																		Converted_to_GA__c,
																		CreatedById,
																		Cutdown_Physician__c,
																		Debris_in_Filter__c,
																		Dissection_Step__c,
																		Dissection_Type__c,
																		Enroute__c,
																		ENROUTE_Delivery_System_Removal__c,
																		ENROUTE_Stint_Deployment__c,
																		Filter_Photo_Taken__c,
																		Fluoro_Time_mGy__c,
																		Fluoro_Time_minutes__c,
																		Glyccopyrrolate__c,
																		Goal__c,
																		HRC_ANA_BILA__c,
																		HRC_ANA_CAD__c,
																		HRC_ANA_CEA__c,
																		HRC_ANA_CONT__c,
																		HRC_ANA_HIGH__c,
																		HRC_ANA_HOST__c,
																		HRC_ANA_LARYN__c,
																		HRC_ANA_NONE__c,
																		HRC_ANA_SPIN__c,
																		HRC_ANA_TAND__c,
																		HRC_CLIN_NONE__c,
																		HRC_CLN_AGE__c,
																		HRC_CLN_ANG__c,
																		HRC_CLN_CCS__c,
																		HRC_CLN_CHF__c,
																		HRC_CLN_CNI__c,
																		HRC_CLN_COPD__c,
																		HRC_CLN_DIAB__c,
																		HRC_CLN_HEART__c,
																		HRC_CLN_LVEF__c,
																		HRC_CLN_MI__c,
																		HRC_CLN_RENA__c,
																		HRC_CLN_STRESS__c,
																		HRC_CLN_SURG__c,
																		IQMS_Customer_Number__c,
																		LastModifiedById,
																		Local_Complications__c,
																		MPK_Dialator__c,
																		MPK_Manufacturer__c,
																		MPK_Size__c,
																		Name,
																		Needle_Length__c,
																		No_SRM_Personnel_Present__c,
																		NPS_Lot_No__c,
																		NPS_Version__c,
																		Number_of_Stents_Used__c,
																		Other_Arterial_Sheath_Placement_Wire__c,
																		Other_Local_Complications__c,
																		Other_MPK_Manufacturer__c,
																		Other_Post_Dil_Balloon_Size__c,
																		Other_Pre_Dil_Balloon_Size__c,
																		Other_Qualified_SRM_Present__c,
																		Other_Stent_1_Type__c,
																		Other_Stent_2_Type__c,
																		OwnerId,
																		Patient_Age__c,
																		Patient_Gender__c,
																		Patient_Id__c,
																		Physician_Primary_Operator__c,
																		Post_Dialation_Balloon_Size__c,
																		Pre_Dilation_Balloon_Size__c,
																		Procedure_Completion__c,
																		Procedure_Date__c,
																		Procedure_Type__c,
																		Reason_Aborted__c,
																		Reverse_Flow_Time__c,
																		Skin_to_Skin_Time__c,
																		SRM_Proctor__c,
																		Stent_1_Size__c,
																		Stent_No_1_Type__c,
																		Stent_No_2_Type__c,
																		Stenter__c,
																		Stint_1_Lot_Number__c,
																		Stint_2_Lot_Number__c,
																		Stint_2_Size__c,
																		Symptomatic__c,
																		Target_Vessel__c,
																		TDS_Present__c,
																		Territory__c,
																		Territory__r.Area_Manager__c,
																		TimePeriod__c,
																		Toleration_of_Reverse_Flow__c,
																		Use_of_Interventional_Tools__c,
																		Wire_Technique__c
																FROM 	Procedure_Form__c		
																WHERE 	Id IN : inputProcedureFormIdSet];

		Date stDt;
		Date enDt;

		for(Procedure_Form__c p : procedureFormUpdateList){
			if(p.Procedure_Date__c != null){
				if(stDt == null && enDt == null){
					stDt = p.Procedure_Date__c;
					enDt = p.Procedure_Date__c;
				}
				else{ 
					if(stDt > p.Procedure_Date__c){
						stDt = p.Procedure_Date__c;
					}
					if(enDt < p.Procedure_Date__c){
						enDt = p.Procedure_Date__c;
					}
				}
			}
			else{
				stDt = System.Today();
				enDt = System.Today();
			}
			stDt = stDt.addMonths(-1);
			enDt = enDt.addMonths(+1);

			
		}

		List<Account> aList = [SELECT IQMS_Customer_Number__c, Id, Name, SFDCTerritoryId__c FROM Account WHERE ID IN : accountIdSet];
		Set<Id> territoryIdSet = new Set<Id>();


		Map<String, Account> custoMap = new Map<String, Account>();
		for(Account a : aList){
		    custoMap.put(a.IQMS_Customer_Number__c, a);
		    territoryIdSet.add(a.SFDCTerritoryId__c);
		}


		List<TimePeriods__c> tpList = [SELECT Name, Id FROM TimePeriods__c WHERE Start_Date__c >= : stDt AND End_Date__c <= : enDt];

		Set<Id> tpIdSet = new Set<Id>();
		Map<String, Id> tpMap = new Map<String, Id>();
		for(TimePeriods__c tp : tpList){
			tpIdSet.add(tp.Id);
    		tpMap.put(tp.Name, tp.Id);
		}

		List<Goal__c> goalList = [SELECT Id, TimePeriod__c, Territory__c FROM Goal__c WHERE Territory__c IN : territoryIdSet AND TimePeriod__c IN : tpIdSet];


		Map<String,Id> goalKeyMap = new Map<String, Id>();
		for(Goal__c g : goalList){
			String keyString = String.valueOf(g.TimePeriod__c) + String.valueOf(g.Territory__c);
			goalKeyMap.put(keyString, g.Id);
		}
		
		
		for(Procedure_Form__c p : procedureFormUpdateList){
		  
		    if(custoMap.get(p.IQMS_Customer_Number__c) == null){
		    	p.Account__c = '0014100001CnTUS' ;
		    }
		    else{
		    	 p.Account__c = custoMap.get(p.IQMS_Customer_Number__c).Id;
		    	 p.Territory__c = custoMap.get(p.IQMS_Customer_Number__c).SFDCTerritoryId__c;
		    }

		    if(p.Procedure_Date__c == null){
		    	p.Procedure_Date__c = System.Today();
		    }

		    String yrString = String.valueOf(p.Procedure_Date__c.year());
    		String moString;
		    if(p.Procedure_Date__c.month() < 10){
		        moString = '-0' + String.valueOf(p.Procedure_Date__c.month());
		    }
		    else {
		         moString = '-' + p.Procedure_Date__c.month();
		    }
		    String periodString = yrString + moString;

		    if(tpMap.get(periodString) != null){
		    	p.TimePeriod__c = tpMap.get(periodString);
		    }

		    String keyString = String.ValueOf(p.TimePeriod__c) + String.valueOf(p.Territory__c);

		    if(goalKeyMap.get(keyString) != null){
		    	p.Goal__c = goalKeyMap.get(keyString);
		    }

		    if(p.OwnerId != p.Account__r.Area_Manager_User__c && p.Account__r.Area_Manager_User__c!= null && p.Account__r.Area_Manager_User__r.IsActive){
		    	p.OwnerId = p.Account__r.Area_Manager_User__c;
		    }
		
		}
 
		GlobalTriggerSwitch.runProcedureFormTrigger = false;
		update procedureFormUpdateList;
		GlobalTriggerSwitch.runProcedureFormTrigger = true;
	
	}




	public static void updateContactCustomerStatus(List<Procedure_Form__c> inputProcedureFormList){
		Set<Id> idSet = new Set<Id>();
		for(Procedure_Form__c pf : inputProcedureFormList){
			idSet.add(pf.Id);
		}

		List<AggregateResult> arList = [SELECT Stenter__c contId FROM Procedure_Form__c WHERE Procedure_Completion__c <> 'Aborted' AND Procedure_Completion__c <> 'Scheduled' AND Id IN : idSet GROUP BY Stenter__c]; 

		Set<Id> contIdSet = new Set<Id>();

		for(AggregateResult ar : arList){
		     Id contId = String.valueOf(ar.get('contId'));
		     contIdSet.add(contId);
		}

		List<Contact> contList = [SELECT Id, Converted_From_DRG__c FROM Contact WHERE Id IN : contIdSet];
		for(Contact c : contList){
		     c.Converted_From_DRG__c = TRUE;
		}

		update contList;
	}




   	/*****************************************************************************************************************************************************************
   	******************************************************************************************************************************************************************
	**********      USE THIS METHOD TO SYNCH UP REVENUE TO GOAL AND TOTAL GOAL TO REVENUE    																**********
	**********      Here is the execute anomyous code to run:																								**********
	**********  																																			**********
	**********      List<Procedure_Form__c> pfList = [SELECT Id FROM Procedure_Form__c WHERE Procedure_Date__c > YYYY-MM-DD];								**********
	**********      Procedure_FormTrigger_Helper.incrementalUpdateProcedureFormTotals(pfList);																		**********
	******************************************************************************************************************************************************************
	*****************************************************************************************************************************************************************/

	public static void incrementalUpdateProcedureFormTotals(List<Procedure_Form__c> inputProcedureFormList){
		Set<Id> inputIdSet = new Set<Id>();
		for(Procedure_Form__c p : inputProcedureFormList){
				inputIdSet.add(p.Id);			
		}

		List<Procedure_Form__c> requeriedProcedureFormList = [SELECT ID, Goal__c FROM Procedure_Form__c WHERE ID IN : inputIdSet];

		Set<Id> goalIdSet = new Set<Id>();
		Set<Date> procedureDateSet = new Set<Date>();
		for(Procedure_Form__c p : requeriedProcedureFormList){
			goalIdSet.add(p.Goal__c);
		}
		List<AggregateResult> arList = [SELECT Goal__c goalId, Count(Id) cnt FROM Procedure_Form__c WHERE (Goal__c IN : goalIdSet 
															AND Procedure_Completion__c <> null
															AND Enroute__c <> null
															AND Procedure_Completion__c <> 'Converted to CEA'
															AND Procedure_Completion__c <> 'Converted to TF-CAS'
															AND Procedure_Completion__c <> 'Aborted'
															AND Procedure_Completion__c <> 'Scheduled'
															AND Procedure_Completion__c <> 'Procedure Turned Down'
															AND Procedure_Completion__c <> 'Cancelled/Rescheduled'
															AND Procedure_Type__c <> '- T E S T -')
															OR  ((Goal__c IN : goalIdSet AND Procedure_Completion__c = 'Aborted' AND Enroute__c = 'NPS placed and reverse flow established')
															OR  (Goal__c IN : goalIdSet AND Procedure_Completion__c = 'Aborted' AND  Enroute__c = 'NPS placed, reverse flow not established, and TCAR procedure aborted')
															OR  (Goal__c IN : goalIdSet AND Procedure_Completion__c = 'Converted to CEA' AND Enroute__c = 'NPS placed and reverse flow established')
															OR  (Goal__c IN : goalIdSet AND Procedure_Completion__c = 'Converted to CEA' AND  Enroute__c = 'NPS placed, reverse flow not established, and TCAR procedure aborted')
															OR  (Goal__c IN : goalIdSet AND Procedure_Completion__c = 'Converted to TF-CAS' AND Enroute__c = 'NPS placed and reverse flow established')
															OR  (Goal__c IN : goalIdSet AND Procedure_Completion__c = 'Converted to TF-CAS' AND  Enroute__c = 'NPS placed, reverse flow not established, and TCAR procedure aborted')
															)
															GROUP BY Goal__c];

		Map<Id, Double> goalProcedureFormCountMap = new Map<Id, Double>();
		for(AggregateResult ar : arList){
			Integer cnt = Integer.valueOf((ar.get('cnt')));
			String goalId = String.valueOf(ar.get('goalId'));
			goalProcedureFormCountMap.put(goalId, cnt);
		}
		List<Goal__c> goalList = [SELECT Id, Actual_Number_of_Procedures__c FROM Goal__c WHERE Id IN : goalIdSet];

		for(Goal__c g : goalList){
			if(goalProcedureFormCountMap.get(g.Id) != null){
				g.Actual_Number_of_Procedures__c = goalProcedureFormCountMap.get(g.Id);
			}
			else{
				g.Actual_Number_of_Procedures__c = 0;
			}
		}
		update goalList;
	}





	public static void updatePhysicianProcedureCount(List<Procedure_Form__c> inputPfList){

		// Build a set list of Stentor Id's (Contact Id's) referenced in the inputPfList
		Set<Id> stentorIdSet = new Set<Id>();
		for(Procedure_Form__c pf : inputPfList){
			if(pf.Stenter__c != null){
				stentorIdSet.add(pf.Stenter__c);
			}
		}

		// Now Query All Procedure Forms Associated with these stenters
		List<Procedure_Form__c> pfList = [SELECT Id, Stenter__c, Procedure_Date__c FROM Procedure_Form__c WHERE Stenter__c IN : stentorIdSet ORDER BY Stenter__c, Procedure_Date__c ASC];
		
		// Build a map of Stentor__c (Contact Id's) to Number of Procedures from the Procedure 
		Map<Id, Integer> stentorIdToProcedureCountMap = new Map<Id, Integer>();
		// Build a map of Stentor__c (Contact Id's) to Number of Procedures from the Procedure 
		Map<Id, Date> stentorIdToEarliestProcedureDateMap = new Map<Id, Date>();
		Map<Id, Date> stentorIdToFifthProcedureDateMap = new Map<Id, Date>();
		Map<Id, Date> stentorIdToTenthProcedureDateMap = new Map<Id, Date>();
		Map<Id, Date> stentorIdToFifteenthProcedureDateMap = new Map<Id, Date>();
		for(Procedure_Form__c pf : pfList){
			if(stentorIdToProcedureCountMap.get(pf.Stenter__c) == null){
				Date pDate = pf.Procedure_Date__c;
				stentorIdToProcedureCountMap.put(pf.Stenter__c, 1);
				stentorIdToEarliestProcedureDateMap.put(pf.Stenter__c ,pf.Procedure_Date__c);
			}
			else{
				Date pDate = stentorIdToEarliestProcedureDateMap.get(pf.Stenter__c);
				// Keep track of the date entering the loop
				Date oDate = pf.Procedure_Date__c;
				if(pf.Procedure_Date__c < pDate){
					pDate = pf.Procedure_Date__c;
				}
				Integer pCount = stentorIdToProcedureCountMap.get(pf.Stenter__c);
				pCount++;
				stentorIdToProcedureCountMap.put(pf.Stenter__c, pCount);
				stentorIdToEarliestProcedureDateMap.put(pf.Stenter__c, pDate);

				if(pCount == 5){
					stentorIdToFifthProcedureDateMap.put(pf.Stenter__c, oDate);
				}
				else if(pCount == 10){
					stentorIdToTenthProcedureDateMap.put(pf.Stenter__c, oDate);
				}
				else if(pCount == 15){
					stentorIdToFifteenthProcedureDateMap.put(pf.Stenter__c, oDate);
				}
			}	
		} // END FOR LOOP

		//Now query the Contact Records to be updated
		List<Contact> contactList = [SELECT Id, Number_of_Procedure_Forms__c, First_Case_Date__c, Fifth_Case_Date__c, Tenth_Case_Date__c, Fifteenth_Case_Date__c FROM Contact WHERE Id IN : stentorIdToProcedureCountMap.keyset()];
		//And update the Contact Records with Procedure Counts
		for(Contact c : contactList){
			c.Number_of_Procedure_Forms__c = stentorIdToProcedureCountMap.get(c.Id);
			c.First_Case_Date__c = stentorIdToEarliestProcedureDateMap.get(c.Id);

			// Record the Fifth Case Date
			if(stentorIdToFifthProcedureDateMap.get(c.Id) != null){
				c.Fifth_Case_Date__c = stentorIdToFifthProcedureDateMap.get(c.Id);
			}

			// Record the Tenth Case Date
			if(stentorIdToTenthProcedureDateMap.get(c.Id) != null){
				c.Tenth_Case_Date__c = stentorIdToTenthProcedureDateMap.get(c.Id);
			}

			if(stentorIdToFifteenthProcedureDateMap.get(c.Id) != null){
				c.Fifteenth_Case_Date__c = stentorIdToFifteenthProcedureDateMap.get(c.Id);
			}
		}
		update contactList;
	}





/**********************************************************************************************************************
***     U S E   T H I S    M E T H O D   I F   A L L   P R O C E D U R E S   N E E D    R E C A L C U L A T I O N    **
***      Procedure_FormTrigger_Helper.Procedure_Form_Count_BatchLauncher();                                           **
**********************************************************************************************************************/
	public static void Procedure_Form_Count_BatchLauncher(){
		String query = 'SELECT Id, Physician_Primary_Operator__c, Stenter__c, Cutdown_Physician__c, Additional_Physician_1__c, Additional_Physician_2__c FROM Procedure_Form__c ORDER BY Physician_Primary_Operator__c, Stenter__c, Cutdown_Physician__c, Additional_Physician_1__c, Additional_Physician_2__c';
		Procedure_Form_Count_Batch pfcb = new Procedure_Form_Count_Batch(query);
		Database.executeBatch(pfcb, 100);
	}

/***********************************************************************************************************************
***  This Method adds all doctors referenced as Primary Operator, Stenter, Cutdown, and Additional in a Procedure    *** 
***  form to be relevant in adding up Procedure Counts an then runs the procedure count routine for all involved     ***
***  physicians.                                                                                         			 ***
***********************************************************************************************************************/        
	public static void updatePhysicianProcedureCountNew(List<Procedure_Form__c> inputPfList){

		Set<Id> involvedPhysicianIdSet = new Set<Id>();
		Set<Id> primaryOperatorIdSet = new Set<Id>();
		Set<Id> stenterIdSet = new Set<Id>();
		Set<Id> cutdownIdSet = new Set<Id>();
		Set<Id> additionalIdSet = new Set<Id>();

		for(Procedure_Form__c pf : inputPfList){
			if(pf.Physician_Primary_Operator__c != null){
				involvedPhysicianIdSet.add(pf.Physician_Primary_Operator__c);
				primaryOperatorIdSet.add(pf.Physician_Primary_Operator__c);
			}
			if(pf.Stenter__c != null){
				involvedPhysicianIdSet.add(pf.Stenter__c);
				stenterIdSet.add(pf.Stenter__c);
			}
			if(pf.Cutdown_Physician__c != null){
				involvedPhysicianIdSet.add(pf.Cutdown_Physician__c);
				cutdownIdSet.add(pf.Cutdown_Physician__c);
			}
			if(pf.Additional_Physician_1__c != null){
				involvedPhysicianIdSet.add(pf.Additional_Physician_1__c);
				additionalIdSet.add(pf.Additional_Physician_1__c);
			}
			if(pf.Additional_Physician_2__c != null){
				involvedPhysicianIdSet.add(pf.Additional_Physician_2__c);
				additionalIdSet.add(pf.Additional_Physician_2__c);
			}
		}

		updateProcedureCountOnPhysicianContact(involvedPhysicianIdSet, primaryOperatorIdSet, stenterIdSet, cutdownIdSet, additionalIdSet);

	}
	


/***********************************************************************************************************************
***  This Method is called by the one above and is used to maintain various Procedure Count Metrics for the          *** 
***  Physician Status Report(s)																					     ***
***********************************************************************************************************************/
	public static void updateProcedureCountOnPhysicianContact(	Set<Id> involvedPhysicianIdSet,
																Set<Id> primaryOperatorIdSet,
																Set<Id> stenterIdSet,
																Set<Id> cutdownIdSet,
																Set<Id> additionalIdSet
																){
		
		// QUERY ALL RELEVANT CONTACT RECORDS INCLUDING ALL FIELDS TO BE UPDATED FOR PROCEDURE COUNT
		List<Contact> contactList = [SELECT 	ID,

											// Fields to determine if TCAR CERTIFIED
												External_Proctored__c,
												Internal_Proctored__c,
												Is_External_Proctor__c,
												Is_Internal_Proctor__c,
												Legacy_TCAR_Certified_Trainer__c,
												Legacy_TCAR_Trained_during_Round_1__c,
												Test_Drive__c,
												Sent_Training_Date__c,
												
											// TCAR CERTIFICATION INFORMATION
												TCAR_Certification_Date__c,
												TCAR_Certification_Hold__c,
												TCAR_Certification_Notes__c,
												TCAR_Certification_Status__c,
												TCAR_Certification_Type__c,
												//TCAR_Certified__c,
												TCAR_Certified_Trainer__c,
												TCAR_Certified_Trainer__r.Name,
											
											// KEY CASE DATES
												First_Case_Post_Test_Drive__c,
												First_Case_Date__c,
												Fifth_Case_Date__c,
												First_Case_Post_Cert__c,
												Tenth_Case_Date__c,
												Fifteenth_Case_Date__c,

											// NUMBER OF PROCEDURE FORMS REFERENCED	
												Number_of_Procedure_Forms__c,

											// DAYS TO METRICS	
												Days_since_Test_Drive_Without_a_Case__c,
												Days_to_100th_Case_All_Time__c,
												Days_to_100th_Case_Post_Cert__c,
												Days_to_10th_Case_All_Time__c,
												Days_to_10th_Case_Post_Cert__c,
												Days_to_1st_Case_Post_Cert__c,
												Days_to_20th_Case_All_Time__c,
												Days_to_20th_Case_Post_Cert__c,
												Days_to_30th_Case_All_Time__c,
												Days_to_30th_Case_Post_Cert__c,
												Days_to_50th_Case_All_Time__c,
												Days_to_50th_Case_Post_Cert__c,
												Days_to_5th_Case_All_Time__c,
												Days_to_5th_Case_Post_Cert__c,
												Days_to_First_Case_Post_Test_Drive__c,
												Days_to_Max_Cases_All_Time__c,
												Days_to_Max_Cases_Post_Cert__c,

											// PROCEDURES AS ROLE METRICS	
												Procedures_as_Additional_All_Time__c,
												Procedures_as_Additional_Post_Cert__c,
												Procedures_as_Cutdown_Only_All_Time__c,
												Procedures_as_Cutdown_Only_Post_Cert__c,
												Procedures_as_Primary_Operator_All_Time__c,
												Procedures_as_Primary_Operator_Post_Cert__c,
												Procedures_as_Stenter_Cutdown_Post_Cert__c,
												Procedures_as_Stenter_Only_All_Time__c,
												Procedures_as_Stenter_Only_Post_Cert__c,
												Procedures_as_Stenter_Cutdown_All_Time__c,
												Procedures_Total_All_Time__c,
												Procedures_Total_Post_Cert__c
		                             FROM 		Contact
		                             WHERE		Id IN : involvedPhysicianIdSet];

// * * * * DO WE NEED THESE SEPARATE MAPS?  CAN WE DO THIS WITH ONE?


        // PUT CONTACT RECORDS INTO APPROPRIATE MAPS SO CONTACT RETRIEVAL IS EASIER
     	Map<Id, Contact> allInvolvedContactMap = new Map<Id, Contact>();
		Map<Id, Contact> primaryOperatorContactMap = new Map<Id, Contact>();
		Map<Id, Contact> stenterContactMap = new Map<Id, Contact>();
		Map<Id, Contact> cutdownContactMap = new Map<Id, Contact>();
		Map<Id, Contact> additionalContactMap = new Map<Id, Contact>();
     	for(Contact c : contactList){
     		allInvolvedContactMap.put(c.Id, c);

			if(primaryOperatorIdSet.contains(c.Id)){
				primaryOperatorContactMap.put(c.Id, c);
			}
			if(stenterIdSet.contains(c.Id)){
				stenterContactMap.put(c.Id, c);
			}
			if(cutdownIdSet.contains(c.Id)){
				cutdownContactMap.put(c.Id, c);
			}
			if(additionalIdSet.contains(c.Id)){
				additionalContactMap.put(c.id, c);
			}
     	}


		// QUERY RELATED PROCEDURE FORMS
     	list<Procedure_Form__c> pfList = [SELECT 	Id,
													Account__c,     												 
     												Physician_Primary_Operator__c,
     												Stenter__c,
     												Cutdown_Physician__c,
     												Additional_Physician_1__c,
     												Additional_Physician_2__c,
     												Procedure_Date__c,
     												Procedure_Completion__c,
     												Enroute__c
											FROM 	Procedure_Form__c
											WHERE   Procedure_Completion__c <> null
													AND Procedure_Completion__c <> 'Scheduled'
													AND Procedure_Type__c <> '- T E S T -'
													AND (Procedure_Completion__c <> 'Converted to CEA' 
														OR (Procedure_Completion__c = 'Converted to CEA' AND Enroute__c = 'NPS placed and reverse flow established') 
														OR (Procedure_Completion__c = 'Converted to CEA' AND  Enroute__c = 'NPS placed, reverse flow not established, and TCAR procedure aborted')
													)
													AND (Procedure_Completion__c <> 'Aborted' 
														OR (Procedure_Completion__c = 'Aborted' AND Enroute__c = 'NPS placed and reverse flow established')
													)
													AND (
													    	Physician_Primary_Operator__c IN : allInvolvedContactMap.keyset()
															OR Stenter__c IN : allInvolvedContactMap.keyset()
															OR Cutdown_Physician__c  IN : allInvolvedContactMap.keyset()
															OR Additional_Physician_1__c  IN : allInvolvedContactMap.keyset()
															OR Additional_Physician_2__c  IN : allInvolvedContactMap.keyset()
														)
										ORDER BY 	Procedure_Date__c ASC			
	 												];

		// CREATE MAPS OF CONTACT ID TO CERTIFICATION DATA ON CONTACT RECORD
		Map<Id, Boolean> contIdCertYnMap = new Map<Id, Boolean>();
		Map<Id, Date> contIdCertDateMap = new Map<Id, Date>();
		Map<Id, Contact> contMap = new Map<Id, Contact>();


		// FIRST LOOP THROUGH CONTACT LIST TO GET INFO ON CERTIFICATION
	 	for(Contact c : contactList){

			// Collect information in the contact record and put them into local variables
	 		Date testDriveDate = c.Test_Drive__c;
	 		Date intProctored = c.Internal_Proctored__c;
	 		Date extProctored = c.External_Proctored__c;
	 		Date tcarCertificationDate;
	 		Date firstCasePostTestDrive;
	 		Date currentDate = Date.Today();

	 		Boolean isInternalProctor = c.Is_Internal_Proctor__c;
	 		Boolean isExternalProctor = c.Is_External_Proctor__c;
	 		Boolean legacyTrained = c.Legacy_TCAR_Trained_during_Round_1__c;
	 		Boolean isTcarCertified = false;

			String legacyTCARTrainer = c.Legacy_TCAR_Certified_Trainer__c;

			// Create some local variables for later storage
			String tcarCertificationType;
	 		//String tcarCertificationNotes;
	 		String tcarCertificationStatus;
	 		Integer daysToFirstCasePostTCAR;

			// CONDITION 1 IF Legacy TCAR Trained During Round 1 THEN "Legacy Round 1"
			if(legacyTrained){
				isTcarCertified = true;
	 			tcarCertificationStatus = 'Legacy Round 1';
	 			tcarCertificationType = 'Legacy Round 1' ;
	 			//tcarCertificationNotes = 'Legacy Round 1';
			}

			// CONDITION 2 IF Externally Proctored Date <> null AND Test Drive Date = null THEN "Externally Proctored but Not Certified"
	 		else if(extProctored != null && (testDriveDate == null || c.TCAR_Certification_Hold__c == true)){
	 			tcarCertificationDate = null;
	 			tcarCertificationType = 'Externally Proctored but Not Certified';
	 			tcarCertificationStatus  = 'Externally Proctored but Not Certified';
	 			isTcarCertified = false;
	 		}

			// CONDITION 3 IF External Proctored <> null AND Test Drive Date != null THEN "Externally Proctored and Certified"
			else if(extProctored != null && testDriveDate != null &&  c.TCAR_Certification_Hold__c != true){
	 			tcarCertificationDate = testDriveDate;
	 			tcarCertificationType = 'Externally Proctored and Certified';
	 			tcarCertificationStatus  = 'Externally Proctored and Certified';
	 			isTcarCertified = true;
	 		}

			// CONDITION 4 IF Internal Proctored <> null, AND Test Drive Date = null THEN "Internally Proctored but Not Certified" 
	 		else if(intProctored != null && (testDriveDate == null || c.TCAR_Certification_Hold__c == true)){
	 			tcarCertificationDate = null;
	 			tcarCertificationType = 'Internal Proctored but Not Certified';
	 			tcarCertificationStatus = 'Internal Proctored but Not Certified';
	 			isTcarCertified = false;
	 		}

			// CONDITION 5 IF Internal Proctored <> null, AND Test Drive Date <> null THEN "Internally Proctored and Certified"
	 		else if(intProctored != null && testDriveDate != null && c.TCAR_Certification_Hold__c != true){
	 			tcarCertificationDate = testDriveDate;
	 			tcarCertificationType = 'Internal Proctored and Certified';
	 			tcarCertificationStatus = 'Internal Proctored and Certified';
	 			isTcarCertified = true;
	 		} 
		
			// Handle Test Drive Not Null
	 		else if(testDriveDate != null){
	 			for(Procedure_Form__c pf : pfList){
	 				if(pf.Stenter__c == c.Id || pf.Cutdown_Physician__c == c.Id && pf.Procedure_Date__c >= testDriveDate){
	 					if(firstCasePostTestDrive == null || firstCasePostTestDrive > pf.Procedure_Date__c){
	 						firstCasePostTestDrive = pf.Procedure_Date__c;
	 					}
	 				}
	 			}
	 			
				// CONDITION 6 IF Test Drive Date != null
	 			if(c.TCAR_Certification_Hold__c == false || c.TCAR_Certification_Hold__c == null){	
	 				tcarCertificationDate = testDriveDate;
	 				firstCasePostTestDrive = firstCasePostTestDrive;
	 				tcarCertificationStatus = 'Completed: Test Drive Complete';
	 				tcarCertificationType = 'TEST Drive';
	 				//tcarCertificationNotes = 'Completed: Test Drive Complete';
	 				isTcarCertified = true;

	 				if(firstCasePostTestDrive != null){
	 					daysToFirstCasePostTCAR = testDriveDate.daysBetween(firstCasePostTestDrive);
	 				}	

	 			}
	 			else{
					tcarCertificationDate = null;
	 				firstCasePostTestDrive = null;
	 				tcarCertificationStatus = 'TCAR Certification on Hold';
	 				tcarCertificationType = null;
	 				//tcarCertificationNotes = 'TCAR Certification on Hold';
	 				//isTcarCertified = false;
	 			}	
	 		} // End Test Drive Not Null


			// ADDITIONAL CRITERIA IF CONTACT IS A LEGACY TRAINER
	 		else if(legacyTCARTrainer != null){
	 			isTcarCertified = true;
	 			tcarCertificationStatus = 'Legacy Proctored';
	 			tcarCertificationType = 'Proctored by ' + c.Legacy_TCAR_Certified_Trainer__c ;
	 			//tcarCertificationNotes = 'Proctored by ' + c.Legacy_TCAR_Certified_Trainer__c ;
	 		}

			// ADDITIONAL CRITERIA IF CONTACT IS AN EXTERNAL PROCTOR 
			else if(isExternalProctor){
				isTcarCertified = true;
	 			tcarCertificationStatus = 'Trained as External Proctor';
	 			tcarCertificationType = 'Trained as External Proctor' ;
	 			//tcarCertificationNotes = 'Trained as External Proctor';
			}

			// ADDITIONAL CRITERIA IF CONTACT IS AN INTERNAL PROCTOR
			else if(isInternalProctor){
				isTcarCertified = true;
	 			tcarCertificationStatus = 'Trained as Internal Proctor';
	 			tcarCertificationType = 'Trained as Internal Proctor' ;
	 			//tcarCertificationNotes = 'Trained as Trained Proctor';
			}

			// FINALLY IF NONE OF THE ABOVE CRITERIA IS MET, NOT TCAR CERTIFIED
			else{
				isTcarCertified = false;
				daysToFirstCasePostTCAR = null;
			}

			// Set the new values
			//c.Is_TCAR_Certified__c = isTcarCertified;
			c.TCAR_Certification_Date__c = tcarCertificationDate;
			c.TCAR_Certification_Type__c = tcarCertificationType;
			c.First_Case_Post_Test_Drive__c = firstCasePostTestDrive;

			// Calculate Days Between Test Drive and First Case
			if(testDriveDate != null && testDriveDate <= firstCasePostTestDrive && firstCasePostTestDrive != null){
				c.Days_to_First_Case_Post_Test_Drive__c =  testDriveDate.daysBetween(firstCasePostTestDrive);
			}

			// Update TCAR Certification Notes
			//if(c.TCAR_Certification_Notes__c == null){
			//	c.TCAR_Certification_Notes__c = tcarCertificationNotes;
			//}

			// Update Certifcation Maps
			contIdCertYnMap.put(c.Id, isTcarCertified);
			contIdCertDateMap.put(c.Id, tcarCertificationDate);
			contMap.put(c.Id, c);
	 	} // END FIRST LOOP THROUGH CONTACTS

		// SET MAPS FOR PROCEDURE COUNTS
		Map<Id, Integer> contId_To_PrimaryPostTCAR = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_StentorPostTCAR = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_CutdownPostTCAR = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_StentorOnlyPostTCAR = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_CutdownOnlyPostTCAR = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_StentorAndCutdownPostTCAR = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_AdditionalPostTCAR = new Map<Id, Integer>();

		Map<Id, Integer> contId_To_AccountCount = new Map<Id, Integer>();

		Map<Id, Integer> contId_To_PrimaryAllTime = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_StentorAllTime = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_CutdownAllTime = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_StentorOnlyAllTime = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_CutdownOnlyAllTime = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_StentorAndCutdownAllTime = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_AdditionalAllTime = new Map<Id, Integer>();

		Map<Id, Map<Integer, Date>> contId_To_CaseNoToDatePostTCAR = new Map<Id, Map<Integer, Date>>();
		Map<Id, Map<Integer, Date>> contId_To_CaseNoToDateAllTime = new Map<Id, Map<Integer, Date>>();

		// SECOND LOOP THROUGH CONTACTS POST CERT UPDATE FOR PROCEDURE COUNTS
		for(Contact c : contactList){

			// DETERMINE IF CONTACT IS TCAR CERTIFIED
			Boolean isTCAR = false;
			Date tCarCertDate = c.TCAR_Certification_Date__c;


// * * * QUESTION IF NO TCAR CERT DATE (eg Legacy Trained) Should isTCAR == TRUE?
			if(tCarCertDate == null){
				isTCAR = false;
			}
			else{
				isTCAR = true;
			}

			// SET INITIAL VALUES FOR THE CONTACT
			Integer allTimeProcedureCount = 0;
			Integer postTCARProcedureCount = 0;

			contId_To_PrimaryPostTCAR.put(c.Id, 0);
			contId_To_StentorPostTCAR.put(c.Id, 0);
			contId_To_CutdownPostTCAR.put(c.Id, 0);
			contId_To_StentorOnlyPostTCAR.put(c.Id, 0);
			contId_To_CutdownOnlyPostTCAR.put(c.Id, 0);
			contId_To_StentorAndCutdownPostTCAR.put(c.Id, 0);
			contId_To_AdditionalPostTCAR.put(c.Id, 0);

			contId_To_AccountCount.put(c.Id, 0);
			Set<Id> accountsInProcedureForm = new Set<Id>();

			contId_To_PrimaryAllTime.put(c.Id, 0);
			contId_To_StentorAllTime.put(c.Id, 0);
			contId_To_CutdownAllTime.put(c.Id, 0);
			contId_To_StentorOnlyAllTime.put(c.Id, 0);
			contId_To_CutdownOnlyAllTime.put(c.Id, 0);
			contId_To_StentorAndCutdownAllTime.put(c.Id, 0);
			contId_To_AdditionalAllTime.put(c.Id, 0);

			Map<Integer, Date> innerMapTCAR = new Map<Integer, Date>();
			Map<Integer, Date> innerMapAllTime = new Map<Integer, Date>();

			innerMapTCAR.put(0,null);
			innerMapAllTime.put(0,null);

			contId_To_CaseNoToDatePostTCAR.put(c.Id, innerMapTCAR);
			contId_To_CaseNoToDateAllTime.put(c.Id, innerMapAllTime);

			// LOOP THROUGH PROCEDURE LISTS TO COUNT UP PROCEDURES AND POPULATE COMPLEX MAPS TO MAINTAIN THE COUNT
			// NOTE THAT THIS IS AN INNER LOOP WITHIN CONTAT RECORD LOOP
			for(Procedure_Form__c pf : pfList){
				Integer asPrimaryPostTCAR = contId_To_PrimaryPostTCAR.get(c.Id);
				Integer asStenterPostTCAR = contId_To_StentorPostTCAR.get(c.Id);
				Integer asCutdownPostTCAR = contId_To_CutdownPostTCAR.get(c.Id);
				Integer asStenterOnlyPostTCAR = contId_To_StentorPostTCAR.get(c.Id);
				Integer asCutdownOnlyPostTCAR = contId_To_CutdownPostTCAR.get(c.Id);
				Integer asStenterAndCutdownPostTCAR = contId_To_StentorAndCutdownPostTCAR.get(c.Id);
				Integer asAdditionalPostTCAR = contId_To_AdditionalPostTCAR.get(c.Id);

				Integer procInAcctCount = contId_To_AccountCount.get(c.Id);

				Integer asPrimaryAllTime = contId_To_PrimaryAllTime.get(c.Id);
				Integer asStenterAllTime = contId_To_StentorAllTime.get(c.Id);
				Integer asCutdownAllTime = contId_To_CutdownAllTime.get(c.Id);
				Integer asStenterOnlyAllTime = contId_To_StentorAllTime.get(c.Id);
				Integer asCutdownOnlyAllTime = contId_To_CutdownAllTime.get(c.Id);
				Integer asStenterAndCutdownAllTime = contId_To_StentorAndCutdownAllTime.get(c.Id);
				Integer asAdditionalAllTime = contId_To_AdditionalAllTime.get(c.Id);	

				Map<Integer, Date> tempInnerTCARMap = contId_To_CaseNoToDatePostTCAR.get(c.Id);
				Map<Integer, Date> tempInnerAllTimeMap = contId_To_CaseNoToDateAllTime.get(c.Id);

				// INCREMENT COUNTS AS WE LOOP THROUGH RECORDS
				if(pf.Physician_Primary_Operator__c == c.Id){
					asPrimaryAllTime++;
					if(isTCAR && pf.Procedure_Date__c <= tCarCertDate){
						asPrimaryPostTCAR++;
					}
				}

				if(pf.Stenter__c == c.Id){
					asStenterAllTime++;
					if(isTCAR && pf.Procedure_Date__c <= tCarCertDate){
						asStenterPostTCAR++;
					}
				}

				if(pf.Stenter__c == c.Id && pf.Cutdown_Physician__c != c.Id && pf.Physician_Primary_Operator__c != c.Id && pf.Additional_Physician_1__c != c.Id && pf.Additional_Physician_2__c != null){
					asStenterOnlyAllTime++;
					if(isTCAR && pf.Procedure_Date__c <= tCarCertDate){
						asStenterOnlyPostTCAR++;
					}
				}

				if(pf.Cutdown_Physician__c == c.Id && pf.Stenter__c != c.Id && pf.Physician_Primary_Operator__c != c.Id && pf.Additional_Physician_1__c != c.Id && pf.Additional_Physician_2__c != null){
					asCutdownOnlyAllTime++;
					if(isTCAR && pf.Procedure_Date__c <= tCarCertDate){
						asCutdownOnlyPostTCAR++;
					}
				}

				if(pf.Cutdown_Physician__c == c.Id && pf.Stenter__c == c.Id){
					asStenterAndCutdownAllTime++;
					if(isTCAR && pf.Procedure_Date__c <= tCarCertDate){
						asStenterAndCutdownPostTCAR++;
					}
				}

				if(pf.Additional_Physician_1__c == c.Id || pf.Additional_Physician_2__c == c.Id){
					asAdditionalAllTime++;
					if(isTCAR && pf.Procedure_Date__c <= tCarCertDate){
						asAdditionalPostTCAR++;
					}
				}
				if(pf.Stenter__c == c.Id || pf.Cutdown_Physician__c == c.Id || pf.Physician_Primary_Operator__c == c.Id){
					allTimeProcedureCount++;
					innerMapAllTime.put(allTimeProcedureCount, pf.Procedure_Date__c);
					if(!accountsInProcedureForm.contains(pf.Account__c)){
						procInAcctCount++;
						accountsInProcedureForm.add(pf.Account__c);
					}
					if(isTCAR && pf.Procedure_Date__c <= tCarCertDate){
						postTCARProcedureCount++;
						innerMapTCAR.put(postTCARProcedureCount, pf.Procedure_Date__c);
					}
				}

				// PASS FINAL COUNTS INTO MAPS FOR LATER UPDATING OF CONTACTS
				contId_To_PrimaryPostTCAR.put(c.Id, asPrimaryPostTCAR);
				contId_To_StentorPostTCAR.put(c.Id, asStenterPostTCAR);
				contId_To_CutdownPostTCAR.put(c.Id, asCutdownPostTCAR);
				contId_To_StentorOnlyPostTCAR.put(c.Id, asStenterOnlyPostTCAR);
				contId_To_CutdownOnlyPostTCAR.put(c.Id, asCutdownOnlyPostTCAR);
				contId_To_StentorAndCutdownPostTCAR.put(c.Id, asStenterAndCutdownPostTCAR);
				contId_To_AdditionalPostTCAR.put(c.Id, asAdditionalPostTCAR);

				contId_To_PrimaryAllTime.put(c.Id, asPrimaryAllTime);
				contId_To_StentorAllTime.put(c.Id, asStenterAllTime);
				contId_To_CutdownAllTime.put(c.Id, asCutdownAllTime);
				contId_To_StentorOnlyAllTime.put(c.Id, asStenterOnlyAllTime);
				contId_To_CutdownOnlyAllTime.put(c.Id, asCutdownOnlyAllTime);
				contId_To_StentorAndCutdownAllTime.put(c.Id, asStenterAndCutdownAllTime);
				contId_To_AdditionalAllTime.put(c.Id, asAdditionalAllTime);

				contId_To_AccountCount.put(c.Id, procInAcctCount);

				contId_To_CaseNoToDatePostTCAR.put(c.Id, innerMapTCAR);
				contId_To_CaseNoToDateAllTime.put(c.Id, innerMapAllTime);
					
			} // END OF PROCEDURE FORM INNER LOOP
				
		}// END SECOND CONTACT LOOP

		// THIRD LOOP THROUGH CONTACTS ONE LAST TIME TO POPULATE THE ANALYTICS FIELDS
		for(Contact c : contactList){

			Map<Integer, Date> innerTCARMap = contId_To_CaseNoToDatePostTCAR.get(c.Id);
			Map<Integer, Date> innerAllTimeMap = contId_To_CaseNoToDateAllTime.get(c.Id);
		
		// KEY CASE DATES
			if(c.Is_TCAR_Certified__c && c.Test_Drive__c != null){
				c.First_Case_Post_Test_Drive__c = innerTCARMap.get(1);
				c.First_Case_Date__c = innerAllTimeMap.get(1);
				c.Fifth_Case_Date__c = innerTCARMap.get(5);
				c.First_Case_Post_Cert__c = innerTCARMap.get(1);	
				c.Tenth_Case_Date__c = innerTCARMap.get(10);			
				c.Fifteenth_Case_Date__c = innerTCARMap.get(15);
			}

		// NUMBER OF PROCEDURE FORMS REFERENCED
			List<Integer> intList = new List<Integer>();
			intList.addAll(innerAllTimeMap.keyset());
			intList.sort();
			c.Number_of_Procedure_Forms__c = intList[intList.size()-1];

		// DAYS TO METRICS	
			//c.Days_since_Test_Drive_Without_a_Case__c = null;

			//TCAR 
			if(c.Is_TCAR_Certified__c && c.TCAR_Certification_Date__c != null){

				if(innerTCARMap.get(100) != null) {c.Days_to_100th_Case_Post_Cert__c = c.TCAR_Certification_Date__c.daysBetween(innerTCARMap.get(100));}
				if(innerTCARMap.get(10) != null) {c.Days_to_10th_Case_Post_Cert__c = c.TCAR_Certification_Date__c.daysBetween(innerTCARMap.get(10));}
				if(innerTCARMap.get(1) != null) {c.Days_to_1st_Case_Post_Cert__c = c.TCAR_Certification_Date__c.daysBetween(innerTCARMap.get(1));}
				if(innerTCARMap.get(20) != null) {c.Days_to_20th_Case_Post_Cert__c = c.TCAR_Certification_Date__c.daysBetween(innerTCARMap.get(20));}
				if(innerTCARMap.get(30) != null) {c.Days_to_30th_Case_Post_Cert__c = c.TCAR_Certification_Date__c.daysBetween(innerTCARMap.get(30));}
				if(innerTCARMap.get(50) != null) {c.Days_to_50th_Case_Post_Cert__c = c.TCAR_Certification_Date__c.daysBetween(innerTCARMap.get(50));}
				if(innerTCARMap.get(5) != null) {c.Days_to_5th_Case_All_Time__c = c.TCAR_Certification_Date__c.daysBetween(innerTCARMap.get(5));}

				if(c.Test_Drive__c != null && c.Is_TCAR_Certified__c  && innerTCARMap.get(1) != null){
					c.Days_to_First_Case_Post_Test_Drive__c = c.Test_Drive__c.DaysBetween(innerTCARMap.get(1));
				}
			}	

			//ALL TIME
			if(innerAllTimeMap.get(100) != null) {c.Days_to_100th_Case_All_Time__c = innerAllTimeMap.get(1).daysBetween(innerAllTimeMap.get(100));}
			if(innerAllTimeMap.get(10) != null) {c.Days_to_10th_Case_All_Time__c = innerAllTimeMap.get(1).daysBetween(innerAllTimeMap.get(10));}
			if(innerAllTimeMap.get(20) != null) {c.Days_to_20th_Case_All_Time__c = innerAllTimeMap.get(1).daysBetween(innerAllTimeMap.get(20));}
			if(innerAllTimeMap.get(30) != null) {c.Days_to_30th_Case_All_Time__c = innerAllTimeMap.get(1).daysBetween(innerAllTimeMap.get(30));}
			if(innerAllTimeMap.get(50) != null) {c.Days_to_50th_Case_All_Time__c = innerAllTimeMap.get(1).daysBetween(innerAllTimeMap.get(50));}
			if(innerAllTimeMap.get(5) != null) {c.Days_to_5th_Case_All_Time__c = innerAllTimeMap.get(5).daysBetween(innerAllTimeMap.get(5));}
							
			if(innerAllTimeMap.size() > 1){
				List<Integer> allTimeList = new List<Integer>();
				allTimeList.addAll(innerAllTimeMap.keySet());
				allTimeList.sort();
				Integer maxInt = allTimeList[allTimeList.size()-1];
				c.Days_to_Max_Cases_All_Time__c = innerAllTimeMap.get(1).daysBetween(innerAllTimeMap.get(maxInt));
			}
			
			c.Days_to_Max_Cases_Post_Cert__c = null;

		// PROCEDURES AS ROLE METRICS

			//TCAR
			c.Procedures_as_Additional_Post_Cert__c = contId_To_AdditionalPostTCAR.get(c.Id);
			c.Procedures_as_Cutdown_Only_Post_Cert__c = contId_To_CutdownOnlyPostTCAR.get(c.Id);
			c.Procedures_as_Primary_Operator_Post_Cert__c = contId_To_CutdownPostTCAR.get(c.Id);
			c.Procedures_as_Stenter_Cutdown_Post_Cert__c = contId_To_StentorAndCutdownPostTCAR.get(c.Id);
			c.Procedures_as_Stenter_Only_Post_Cert__c = contId_To_StentorOnlyPostTCAR.get(c.Id);

			//ALL TIME	
			c.Procedures_as_Additional_All_Time__c = contId_To_AdditionalAllTime.get(c.Id);
			c.Procedures_as_Cutdown_Only_All_Time__c = contId_To_CutdownOnlyAllTime.get(c.Id);
			c.Procedures_as_Primary_Operator_All_Time__c = contId_To_PrimaryAllTIme.get(c.Id);
			c.Procedures_as_Stenter_Cutdown_All_Time__c = contId_To_StentorAndCutdownAllTime.get(c.Id);
			c.Procedures_as_Stenter_Only_All_Time__c = contId_To_StentorOnlyAllTime.get(c.Id);
		
			c.Accounts_Where_Stenter_Cutdown_Primary__c = contId_To_AccountCount.get(c.Id);
		} // END OF THIRD CONTACT LOOP
		
		// UPDATE CONTACT LIST
		GlobalTriggerSwitch.runContactTrigger = false;
		update contactList;
		GlobalTriggerSwitch.runContactTrigger = true;							
	
	}	
	
	







	public static Map<Id, String> eventRtMap(){
        List<RecordType> rtList = [SELECT ID, Name, SObjectType FROM RecordType WHERE SObjectType = 'Event'];
        Map<Id, String> eventRtMap = new Map<Id, String>();
        for(RecordType rt : rtList){
            eventRtMap.put(rt.Id, rt.Name);
        }
        return eventRtMap;
    }
	
	
	
	
	
	
	
	
	
	
	public static void cancelRelatedEvents(List<Procedure_Form__c> inputProcedureFormList){

		Set<Id> procedureFormIdSet = new Set<Id>();

		Map<Id, Set<Id>> pfAttendeesMapSet = new Map<Id, Set<Id>>();
		Set<Id> attendeeIdSet = new Set<Id>();

		for(Procedure_Form__c pf : inputProcedureFormList){
			procedureFormIdSet.add(pf.Id);
			Set<Id> sendTo = new Set<Id>();
			if(pf.Secondary_TDS_Present__c != null ){
				sendTo.add(pf.Secondary_TDS_Present__c);
				attendeeIdSet.add(pf.Secondary_TDS_Present__c);
			}
			if(pf.AM_Present__c != null ){
				sendTo.add(pf.AM_Present__c );
				attendeeIdSet.add(pf.AM_Present__c );
			}
			if(pf.AD_Present__c != null ){
				sendTo.add(pf.AD_Present__c);
				attendeeIdSet.add(pf.AD_Present__c);
			}
			if(pf.TDS_Present__c != null ){
				sendTo.add(pf.TDS_Present__c);
				attendeeIdSet.add(pf.TDS_Present__c);
			}
			if(pf.Other_Qualified_SRM_Present__c != null ){
				sendTo.add(pf.Other_Qualified_SRM_Present__c);
				attendeeIdSet.add(pf.Other_Qualified_SRM_Present__c);
			}
			pfAttendeesMapSet.put(pf.Id, sendTo);
		}

		List<User> uList = [SELECT Id, Email FROM User WHERE Id IN : attendeeIdSet];
		Map<Id, String> userEmailMap = new Map<Id, String>();
		for(User u : uList){
			userEmailMap.put(u.Id, u.Email);
		}

		Map<Id, Set<String>> pfAttendeesEmailMapSet = new Map<Id, Set<String>>();

		for(Id iid : pfAttendeesMapSet.keySet()){
			Set<Id> innerIdSet = pfAttendeesMapSet.get(iid);
			Set<String> innerEmailSet = new Set<String>();
			for(Id userId : innerIdSet ){
				if(userEmailMap.get(UserId) != null){
					innerEmailSet.add(userEmailMap.get(UserId));
				}
			}
			pfAttendeesEmailMapSet.put(iid, innerEmailSet);
		}


		List<Event> eList = [SELECT AccountId,
									ActivityDate,
									ActivityDateTime,
									CreatedById,
									DurationInMinutes,
									EndDateTime,
									EventSubtype,
									Event_Type__c,
									Id,
									Local_Schedule__c,
									Local_Start_Time__c,
									Local_End_Time__c,
									Local_Time_Zone__c,
									Location,
									Location_Info__c,
									Other_Information__c,
									OwnerId,
									ProcedureFormId__c,
									ProcedureFormId__r.Procedure_Date__c,
									RecordTypeId,
									Sequence__c,
									ShowAs,
									SRM_Attendees__c,
									StartDateTime,
									Subject,
									Type,
									WhatId,
									WhoId
							FROM    Event 
							WHERE 	ProcedureFormId__c IN : procedureFormIdSet];

		sendInviteToOutlook(eList, pfAttendeesEmailMapSet, 'DELETE');

		GlobalTriggerSwitch.runEventTrigger = false;
		delete eList;
	}










	public static void sendInviteToOutlook(List<Event> inputEventList, Map<Id,Set<String>> pfAttendeesEmailMapSet, String dmlAction){

            // Identify the primary Event being modified
            Event primaryEvent = inputEventList[0];
            Id primaryEventId = primaryEvent.Id;
            
            // GET THE RECORD TYPES FOR EVENTS FOR DIFFERENT EVENT TYPES       
            Map<Id, String> eventRtMap = eventRtMap();
            Id pId;
            Id npId;

            for(Id iid : eventRtMap.KeySet()){
                if(eventRtMap.get(iid) == 'Procedure'){
                    pId = iid;
                }
                if(eventRtMap.get(iid) == 'Non Procedure'){
                    npId = iid;
                }
            }

            // PULL PUBLIC CALENDARS TO MAKE A LIST OF ELEGIBLE CALENDARS
            Set<Id> calendarIdSet = new Set<Id>();
            List<Territory__c> terrList = [SELECT Calendar__c FROM Territory__c WHERE Calendar__c <> null];
            for(Territory__c t : terrList){
                calendarIdSet.add(t.Calendar__c);
            }

            String userId = UserInfo.getUserId();
                String organizerEmail = [SELECT Email FROM User WHERE Id = : userId LIMIT 1].Email;

            
// H A N D L E     P R O C E D U R E     E V E N T S  
            if(primaryEvent.RecordTypeId == pId && primaryEvent.ProcedureFormId__c != null && dmlAction == 'DELETE'){
                
                // Build a set of event Id's relating to public calendars and Procedure Record Type
                Set<Id> eventIdSet = new Set<Id> ();
                List<Event> qualEventList = new List<Event>();
                for(Event e : inputEventList){
                    if(e.RecordTypeId == pId && calendarIdSet.contains(e.OwnerId) && dmlAction == 'DELETE'){
                        eventIdSet.add(e.Id);
                        qualEventList.add(e);
                    }
                }
                eventIdSet.add(primaryEventId);

                for(Event e : qualEventList){
                    Set<String> sendTo = pfAttendeesEmailMapSet.get(e.ProcedureFormId__c);
                    for(String s : sendTo){
					}

                    buildAndSendInvite1(e,
                                        sendTo, 
                                        e.Subject,
                                        e.Location_Info__c,
                                        e.Other_Information__c,
                                        e.StartDateTime,
                                        e.EndDateTime,
                                        e.Id,
                                        organizerEmail,
                                        dmlAction);
                }
            }
      }










	    public static void buildAndSendInvite1(Event e,
                                            Set<String> sendTo, 
                                            String subject,
                                            String locInformation,
                                            String otherInformation,
                                            DateTime startDateTime,
                                            DateTime endDateTime,
                                            String eventId,
                                            String sentFrom,
                                            String dmlAction
                                            ){
            
        SendEmail1 se = new SendEmail1();
        se.sendTo = sendTo;
        se.Subject = subject;

        String currentIcsTimeString = convertDateTimeToIcsString(SYSTEM.now());
        String StartIcsTimeString = convertDateTimeToIcsString(startDateTime);
        String EndIcsTimeString = convertDateTimeToIcsString(endDateTime);

            se.sendInvite(
                e,
                startIcsTimeString,
                endIcsTimeString,
                currentIcsTimeString,
                sentFrom,
                sendTo,
                eventId,
                subject,
                locInformation,
                otherInformation,
                dmlAction);
    }








    public class SendEmail1 {
        Map<Id, String> eventRtMap = eventRtMap();
        public Set<String> sendTo { get; set; }
        public String Subject { get; set; }
        public Event objEvent{get;set;}
        public SendEmail1() {}
        public PageReference sendInvite(Event e,
                                        String startIcsTimeString,
                                        String endIcsTimeString,
                                        String currentIcsTimeString,
                                        String organizerEmail,
                                        Set<String> inviteeEmail,
                                        String sfdcEventId, 
                                        String subject,
                                        String location,
                                        String otherInformation,
                                        String dmlAction) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> toAddresses = new List<String>(sendTo);
            //toAddresses = sendTo;
            mail.setToAddresses(toAddresses);
            mail.setSubject(Subject);

            String domain = String.valueOf(System.Url.getSalesforceBaseUrl().toExternalForm());
            domain = domain.replace('.', ',');
            domain = domain.split(',')[0];
            
            String emailBody;

                
            String procedureDateString;
            if(e.ProcedureFormId__r.Procedure_Date__c != null && eventRtMap.get(e.RecordTypeId) == 'Procedure' && dmlAction == 'DELETE'){
                procedureDateString = String.valueOf(e.ProcedureFormId__r.Procedure_Date__c);
                emailBody = '* * * C A N C E L L E D    P R O C E D U R E * * *  \n Original Schedule:  \n';
                
                emailBody += '  Procedure Date: ' + procedureDateString + '\n';
                emailBody += '  Start Time: ' + startIcsTimeString + '\n';
                emailBody += '  End Time:   ' + endIcsTimeString + '\n';
                emailBody += '\n';  
                emailBody += 'LOCATION: \n' + e.Location_Info__c + '\n';
                emailBody += '\n\n';
                emailBody += 'LINK TO SALESFORCE EVENT: \n' + domain + '.lightning.force.com/lightning/r/Procedure_Form__c/' + sfdcEventId + '/view' ;
                emailBody += '\n\n';
                emailBody += 'OTHER INFORMATION: \n' +  e.Other_Information__c ;
            }
            else{
            
                emailBody += 'NON PROCEDURE GROUP EVENT \n';
                
                emailBody += '* * * C A N C E L L E D    N O N - P R O C E D U R E     E V E N T * * *  \n Original Schedule:  \n';
                
                emailBody += '  Procedure Date: ' + procedureDateString + '\n';
                emailBody += '  Start Time: ' + startIcsTimeString + '\n';
                emailBody += '  End Time:   ' + endIcsTimeString + '\n';
                emailBody += '\n';  
                emailBody += 'LOCATION: \n' + location + '\n';
                emailBody += '\n\n';
                emailBody += 'OTHER INFORMATION: \n' +  otherInformation ;

            }
            mail.setPlainTextBody(emailBody);
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.filename = 'meeting.ics';
            attach.ContentType ='text/calendar; charset=utf-8; method=REQUEST';
            attach.inline = true;
            attach.body = invite(e,
                                startIcsTimeString,
                                endIcsTimeString,
                                currentIcsTimeString,
                                organizerEmail,
                                toAddresses,
                                sfdcEventId, 
                                subject,
                                location,
                                otherInformation,
                                dmlAction);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach});
            Messaging.SendEmailResult[] er = Messaging.sendEmail(new Messaging.Email[] {mail});
            return null;
        }
        private Blob invite(    Event e,
                                String startIcsTimeString,
                                String endIcsTimeString,
                                String currentIcsTimeString,
                                String organizerEmail,
                                String[] toAddresses,
                                String sfdcEventId, 
                                String subject,
                                string location,
                                String otherInformation,
                                String dmlAction) {

            /*
            // * * * * EVENT FIELDS AVAILABLE * * * *
            AccountId
            ActivityDate
            ActivityDateTime
            CreatedById
            CreatedDate
            DB_Activity_Type__c
            Description
            DurationInMinutes
            EndDate
            EndDateTime
            EventSubtype
            Event_Type__c
            GroupEventType
            Id
            IsAllDayEvent
            IsArchived
            IsChild
            IsDeleted
            IsGroupEvent
            IsPrivate
            IsRecurrence
            IsRecurrence2
            IsRecurrence2Exception
            IsRecurrence2Exclusion
            IsReminderSet
            LastModifiedById
            LastModifiedDate
            Local_Schedule__c
            Local_Time_Zone__c
            Location
            Location_Info__c
            Other_Information__c
            OwnerId
            ProcedureFormId__c
            RecordTypeId
            Recurrence2PatternStartDate
            Recurrence2PatternText
            Recurrence2PatternTimeZone
            Recurrence2PatternVersion
            RecurrenceActivityId
            RecurrenceDayOfMonth
            RecurrenceDayOfWeekMask
            RecurrenceEndDateOnly
            RecurrenceInstance
            RecurrenceInterval
            RecurrenceMonthOfYear
            RecurrenceStartDateTime
            RecurrenceTimeZoneSidKey
            RecurrenceType
            ReminderDateTime
            Sequence__c
            ShowAs
            ShowpadForSF__Showpad_Activity__c
            SRM_Attendees__c
            StartDateTime
            Subject
            SystemModstamp
            Type
            Vendor_Credential_Company__c
            WhatCount
            WhatId
            WhoCount
            WhoId
            */                        

            String txtInvite = '';
    
            txtInvite += 'BEGIN:VCALENDAR\n';
            txtInvite += 'PRODID:-//Google Inc//Google Calendar 70.9054//EN\n';
            txtInvite += 'VERSION:2.0\n';
            txtInvite += 'CALSCALE:GREGORIAN\n';
            txtInvite += 'METHOD:REQUEST\n';
            txtInvite += 'TZ:+00\n'; 
            txtInvite += 'BEGIN:VEVENT\n';
            txtInvite += 'DTSTART:' + startIcsTimeString + '\n';
            
            txtInvite += 'DTEND:' + endIcsTimeString + '\n';
            txtInvite += 'DTSTAMP:' + currentIcsTimeString + '\n';
            txtInvite += 'ORGANIZER;CN=' + organizerEmail + ':mailto:' + organizerEmail + '\n';

            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            
            txtInvite += 'UID:' + baseURL + '/' + sfdcEventId + '\n';

            Integer i =  toAddresses.size();

            for(String s : toAddresses){
                if(s == organizerEmail){
                    txtInvite += 'ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=FALSE;CN=\"' + s + '\";X-NUM-GUESTS=' + i + ':mailto:' + s + '\n';
                }
                else{
                    txtInvite += 'ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;CN=\"' + s + '\";X-NUM-GUESTS=' + i + ':mailto:' + s + '\n';
                }
            }

            txtInvite += 'COMMENT;LANGUAGE=en-US:www.cnn.com\n'; 
            txtInvite += 'X-MICROSOFT-CDO-OWNERAPPTID:-2136020037\n';
            txtInvite += 'CREATED:' + currentIcsTimeString + '\n';
            txtInvite += 'DESCRIPTION:www.cnn.com\n\n-::~:~::~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~::~:~::-\nPlease do not edit this section of the description.\n\nView your event at https://www.google.com/calendar/event?action=VIEW&eid=NGk2bDVnbHFrbmd0YWJ0cG11YzFyamtkZXIgZ3BldHJpZUBzaWxrcm9h ZG1lZC5jb20&tok=MjUjZ29yZG9uLm0ucGV0cmllQGdtYWlsLmNvbTQ0ZWRmNzNkZjU2NGJjYmM zNTQ5ZTg4NGM4NWVhNzM0ZThiYTBjOTc&ctz=America%2FLos_Angeles&hl=en&es=1.\n-::~:~::~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~::~:~::-\n';
            txtInvite += 'LAST-MODIFIED:' + currentIcsTimeString + '\n';
 
            if(dmlAction == 'DELETE'){
                Integer z = 0;
                if(e.Sequence__c == null){
                    z = 0;
                }
                else{
                    z = Integer.valueOf(e.Sequence__c + 1);
                }
                txtInvite += 'SEQUENCE:' + z + '\n';
            }
            else{
                txtInvite += 'SEQUENCE:' + e.Sequence__c + '\n';
            }

            if(dmlAction == 'DELETE'){
                txtInvite += 'STATUS:CANCELLED' +  '\n';
            }
            txtInvite += 'SUMMARY:TEST INVITE FROM GOOGLE\n';
            txtInvite += 'TRANSP:OPAQUE\n';
            txtInvite += 'END:VEVENT\n';
            txtInvite += 'END:VCALENDAR\n';

            return Blob.valueOf(txtInvite);
        }
	}
	




  



	public static String convertDateTimeToIcsString(dateTime inputDateTime){
        String returnTimeString;
        String yr = String.valueOf(inputDateTime.YearGMT());
        String mo;
        if(inputDateTime.MonthGMT() < 10){mo = '0' + String.ValueOf(inputDateTime.MonthGMT());} else {mo = String.ValueOf(inputDateTime.MonthGMT());}
        String dy;
        if(inputDateTime.DayGMT() < 10){dy = '0' + String.ValueOf(inputDateTime.DayGMT());} else {dy = String.ValueOf(inputDateTime.DayGMT());}
        String hr;
        if(inputDateTime.HourGMT() < 10){hr = '0' + String.ValueOf(inputDateTime.HourGMT());} else {hr = String.ValueOf(inputDateTime.HourGMT());}
        String mn;
        if(inputDateTime.MinuteGMT() < 10){mn = '0' + String.ValueOf(inputDateTime.MinuteGMT());} else {mn = String.ValueOf(inputDateTime.MinuteGMT());}
        String sc;
        if(inputDateTime.SecondGMT() < 10){sc = '0' + String.ValueOf(inputDateTime.SecondGMT());} else {sc = String.ValueOf(inputDateTime.SecondGMT());}
        returnTimeString = yr + mo  + dy + 'T' + hr + mn + sc + 'Z';
        return returnTimeString;

	}
	



	/************************************************************************************************************************************************************
	*************************************************************************************************************************************************************
	***  This Procedure Sorts Procedure Forms Based on if they have schedules before or after, and if the procedure Event has changed.  Maps of Old and New  ****
	***  Procedure Forms are then sent to the CalendarAndEvent_Utilities Class to manage the related Event Updates                                           ****
	*************************************************************************************************************************************************************
	*************************************************************************************************************************************************************/
	public static void updateProcedureEvent(Map<Id, Procedure_Form__c> oldPfMap, Map<Id, Procedure_Form__c> newPfMap){

		SYSTEM.DEBUG('ENTERING PROCEDURE FORM TRIGGER TRIGGER HELPER UPDATE NEW PROCEDURE FORM');   

		Map<Id, Procedure_Form__c> old_s2sMap = new Map<Id, Procedure_Form__c>();
		Map<Id, Procedure_Form__c> new_s2sMap = new Map<Id, Procedure_Form__c>();

		List<Procedure_Form__c> procedureFormsWithNeweSchedule = new List<Procedure_Form__c>();

		Map<Id, Procedure_Form__c> old_s2nMap = new Map<Id, Procedure_Form__c>();
		Map<Id, Procedure_Form__c> new_s2nMap = new Map<Id, Procedure_Form__c>();


		// Filter out only changes in schedule
		for(Id iid : newPfMap.keyset()){
			Procedure_Form__c oldPf = oldPfMap.get(iid);
			Procedure_Form__c newPf = newPfMap.get(iid);
			
			// CASE 1:  OLD PROCEDURE FORM AND NEW PROCEDURE FORM BOTH ARE SCHEDULED			
			if(oldPf.Procedure_Completion__c == 'Scheduled' && newPf.Procedure_Completion__c == 'Scheduled' &&
				// Check to see if anything about the related events has changed
				(oldPf.Event_ActivityDate__c != newPf.Event_ActivityDate__c ||
					oldPf.Event_StartDateTime__c != newPf.Event_StartDateTime__c ||
					oldPf.Event_EndDateTime__c != newPf.Event_EndDateTime__c ||
					oldPf.Event_Location_Info__c != newPf.Event_Location_Info__c ||
					oldPf.Event_Other_Information__c != newPf.Event_Other_Information__c ||
					oldPf.AM_Present__c != oldPf.AM_Present__c ||
					oldPf.TDS_Present__c != oldPf.TDS_Present__c ||
					oldPf.Secondary_TDS_Present__c != oldPf.Secondary_TDS_Present__c ||
					oldPf.AD_Present__c != oldPf.AD_Present__c ||
					oldPf.Other_Qualified_SRM_Present__c != oldPf.Other_Qualified_SRM_Present__c)){

					old_s2sMap.put(oldPf.Id, oldPf);
					new_s2sMap.put(newPf.Id, newPf);
			}

			// CASE 2:  OLD PROCEDURE FORM NOT SCHEDULED AND NEW PROCEDURE FORM IS SCHEDULED
			else if(oldPf.Procedure_Completion__c != 'Scheduled' && newPf.Procedure_Completion__c == 'Scheduled'){
				procedureFormsWithNeweSchedule.add(newPf);
			}

			// CASE 2:  OLD PROCEDURE FORM AND NEW PROCEDURE FORM NOT SCHEDULED AND NEW PROCEDURE FORM IS SCHEDULED
			else if(oldPf.Procedure_Completion__c == 'Scheduled' && newPf.Procedure_Completion__c != 'Scheduled'){
							old_s2nMap.put(oldPf.Id, oldPf);
							new_s2nMap.put(newPf.Id, newPf);		
			}			
		}

		CalendarAndEvent_Utilities.updateExistingProcedureEvent(old_s2sMap, new_s2sMap);

		CalendarAndEvent_Utilities.cancelExistingProcedureEvent(old_s2nMap, new_s2nMap);

		// Process Case 2
		CalendarAndEvent_Utilities.createNewProcedureEvent(procedureFormsWithNeweSchedule);


	}








	/*
	public static void updateProcedureCountOnPhysicianContact(Set<Id> involvedPhysicianIdSet){	

		List<Contact> contactList = [SELECT 	ID,
												Test_Drive__c,
												Internal_Proctored__c,
												External_Proctored__c,
												Sent_Training_Date__c,
												TCAR_Certification_Date__c,
												TCAR_Certification_Notes__c,
												TCAR_Certification_Status__c,
												TCAR_Certification_Type__c
												Accounts_Where_Stentor_Cutdown_Primary__c,
												Base_TCAR_Cert_Date__c,
												Days_to_100th_Case_All_Time__c,
												Days_to_100th_Case_Post_TCAR__c,
												Days_to_10th_Case_All_Time__c,
												Days_to_10th_Case_Post_TCAR__c,
												Days_to_1st_Case_Post_TCAR__c,
												Days_to_20th_Case_All_Time__c,
												Days_to_20th_Case_Post_TCAR__c,
												Days_to_30th_Case_All_Time__c,
												Days_to_30th_Case_Post_TCAR__c,
												Days_to_50th_Case_All_Time__c,
												Days_to_50th_Case_Post_TCAR__c,
												Days_to_5th_Case_All_Time__c,
												Days_to_5th_Case_Post_TCAR__c,
												Days_to_Max_Cases_All_Time__c,
												Days_to_Max_Cases_Post_TCAR__c,
												Procedures_as_Additional_All_Time__c,
												Procedures_as_Additional_Post_TCAR__c,
												Procedures_as_Cutdown_Only_All_Time__c,
												Procedures_as_Cutdown_Only_Post_TCAR__c,
												Procedures_as_Primary_Operator_All_Time__c,
												Procedures_as_Primary_Operator_Post_TCAR__c,
												Procedures_as_Stentor_Cutdown_Post_TCAR__c,
												Procedures_as_Stentor_Only_All_Time__c,
												Procedures_as_Stentor_Only_Post_TCAR__c,
												Procedures_as_Stentor_Cutdown_All_Time__c,
												Procedures_Total_All_Time__c,
												Procedures_Total_Post_TCAR__c
		                             FROM 		Contact
		                             WHERE		Id IN : involvedPhysicianIdSet];
     	Map<Id, Contact> contactMap = new Map<Id, Contact>();
     	for(Contact c : contactList){
     		contactMap.put(c.Id, c);
     	}

     	list<Procedure_Form__c> pfList = [SELECT 	Id,
													Account__c,     												 
     												Physician_Primary_Operator__c,
     												Stenter__c,
     												Cutdown_Physician__c,
     												Additional_Physician_1__c,
     												Additional_Physician_2__c,
     												Procedure_Date__c,
     												Procedure_Completion__c,
     												Enroute__c
											FROM 	Procedure_Form__c
											WHERE   Procedure_Completion__c <> null
													AND Procedure_Completion__c <> 'Scheduled'
													AND Procedure_Type__c <> '- T E S T -'
													AND (Procedure_Completion__c <> 'Converted to CEA' 
														OR (Procedure_Completion__c = 'Converted to CEA' AND Enroute__c = 'NPS placed and reverse flow established') 
														OR (Procedure_Completion__c = 'Converted to CEA' AND  Enroute__c = 'NPS placed, reverse flow not established, and TCAR procedure aborted')
													)
													AND (Procedure_Completion__c <> 'Aborted' 
														OR (Procedure_Completion__c = 'Aborted' AND Enroute__c = 'NPS placed and reverse flow established')
													)
													AND (
													    	Physician_Primary_Operator__c IN : involvedPhysicianIdSet
															OR Stenter__c IN : involvedPhysicianIdSet
															OR Cutdown_Physician__c  IN : involvedPhysicianIdSet
															OR Additional_Physician_1__c  IN : involvedPhysicianIdSet
															OR Additional_Physician_2__c  IN : involvedPhysicianIdSet
														)
											ORDER BY 	Procedure_Date__c ASC			
	 												];									

		Map<Id, Date> contId_To_TCARCertDate = new Map<Id, Date>();
		Map<Id, Integer> contId_To_PrimaryPostTCAR = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_StentorPostTCAR = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_CutdownPostTCAR = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_StentorAndCutdownPostTCAR = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_AdditionalPostTCAR = new Map<Id, Integer>();

		Map<Id, Integer> contId_To_AccountCount = new Map<Id, Integer>();

		Map<Id, Integer> contId_To_PrimaryAllTime = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_StentorAllTime = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_CutdownAllTime = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_StentorAndCutdownAllTime = new Map<Id, Integer>();
		Map<Id, Integer> contId_To_AdditionalAllTime = new Map<Id, Integer>();

		Map<Id, Map<Integer, Date>> contId_To_CaseNoToDatePostTCAR = new Map<Id, Map<Integer, Date>>();
		Map<Id, Map<Integer, Date>> contId_To_CaseNoToDateAllTime = new Map<Id, Map<Integer, Date>>();

		for(Contact c : contactList){
			Date tcarCertDate = c.Base_TCAR_Cert_Date__c;

			contId_To_TCARCertDate.put(c.Id, tcarCertDate);

			Integer primaryPostTCAR;
			if(contId_To_PrimaryPostTCAR.get(c.Id) == null){ primaryPostTCAR = 0; } else { primaryPostTCAR = contId_To_PrimaryPostTCAR.get(c.Id); }
			
			Integer stentorPostTCAR; 
			if(contId_To_StentorPostTCAR.get(c.Id) == null){ stentorPostTCAR = 0; } else { stentorPostTCAR = contId_To_StentorPostTCAR.get(c.Id); }

			Integer cutdownPostTCAR;
			if(contId_To_CutdownPostTCAR.get(c.Id) == null){ cutdownPostTCAR = 0; } else { cutdownPostTCAR = contId_To_CutdownPostTCAR.get(c.Id); }
			
			Integer stentorAndCutdownPostTCAR;
			if(contId_To_StentorAndCutdownPostTCAR.get(c.Id) == null){ stentorAndCutdownPostTCAR = 0; } else { stentorAndCutdownPostTCAR = contId_To_StentorAndCutdownPostTCAR.get(c.Id); }

			Integer additionalPostTCAR;
			if(contId_To_AdditionalPostTCAR.get(c.Id) == null){ additionalPostTCAR = 0; } else { additionalPostTCAR = contId_To_AdditionalPostTCAR.get(c.Id); }
            


            Integer primaryAllTime;
			if(contId_To_PrimaryAllTime.get(c.Id) == null){ primaryAllTime = 0; } else { primaryAllTime = contId_To_PrimaryAllTime.get(c.Id); }
			
			Integer stentorAllTime; 
			if(contId_To_StentorAllTime.get(c.Id) == null){ stentorAllTime = 0; } else { stentorAllTime = contId_To_StentorAllTime.get(c.Id); }

			Integer cutdownAllTime;
			if(contId_To_CutdownAllTime.get(c.Id) == null){ cutdownAllTime = 0; } else { cutdownAllTime = contId_To_CutdownAllTime.get(c.Id); }
			
			Integer stentorAndCutdownAllTime;
			if(contId_To_StentorAndCutdownAllTime.get(c.Id) == null){ stentorAndCutdownAllTime = 0; } else { stentorAndCutdownAllTime = contId_To_StentorAndCutdownAllTime.get(c.Id); }

			Integer additionalAllTime;
			if(contId_To_AdditionalAllTime.get(c.Id) == null){ additionalAllTime = 0; } else { additionalAllTime = contId_To_AdditionalAllTime.get(c.Id); }




			Integer maxPostTCARInnerMap;
			Map<Integer, Date> postTCARInnerMap;
			if(contId_To_CaseNoToDatePostTCAR.get(c.Id) == null){
				postTCARInnerMap = new Map<Integer, Date>();
				maxPostTCARInnerMap = 0;
			}
			else{
				postTCARInnerMap = contId_To_CaseNoToDatePostTCAR.get(c.Id);
				List<Integer> postTCARInnerList = new List<Integer>();
				postTCARInnerList.addAll(postTCARInnerMap.keyset());
				postTCARInnerList.sort();
				maxPostTCARInnerMap = postTCARInnerList[postTCARInnerMap.size()-1];
			}
			



			Integer maxAllTimeInnerMap;
			Map<Integer, Date> allTimeInnerMap;
			if(contId_To_CaseNoToDateAllTime.get(c.Id) == null){
				allTimeInnerMap = new Map<Integer, Date>();
				maxAllTimeInnerMap = 0;
			}
			else{
				allTimeInnerMap = contId_To_CaseNoToDateAllTime.get(c.Id);
				List<Integer> allTimeInnerList = new List<Integer>();
				allTimeInnerList.addAll(allTimeInnerMap.keyset());
				allTimeInnerList.sort();
				maxAllTimeInnerMap = allTimeInnerList[allTimeInnerList.size()-1];
			}

			Set<Id> acctIdSet = new Set<Id>();

			for(Procedure_Form__c pf : pfList){

				if(pf.Stenter__c == c.Id || pf.Cutdown_Physician__c == c.Id){
					maxAllTimeInnerMap++;
					allTimeInnerMap.put(maxAllTimeInnerMap, pf.Procedure_Date__c);
					contId_To_CaseNoToDateAllTime.put(c.Id,allTimeInnerMap);

					if(tcarCertDate == null){ tcarCertDate = allTimeInnerMap.get(1); contId_To_TCARCertDate.put(c.Id, tcarCertDate); }

					if(tcarCertDate != null && tcarCertDate <= pf.Procedure_Date__c){
						maxPostTCARInnerMap++;
						postTCARInnerMap.put(maxPostTCARInnerMap, pf.Procedure_Date__c);
						contId_To_CaseNoToDatePostTCAR.put(c.Id, postTCARInnerMap);
					}
				}

				//AS PRIMARY OPERATOR
				if(c.Id == pf.Physician_Primary_Operator__c){
					primaryAllTime++;
					contId_To_PrimaryAllTime.put(c.Id, primaryAllTime);
					if(tcarCertDate != null && pf.Procedure_Date__c > tcarCertDate){
						primaryPostTCAR++;
						contId_To_PrimaryPostTCAR.put(c.Id, primaryPostTCAR);
					}

				}
				//AS STENTOR ONLY
				if(c.Id != pf.Physician_Primary_Operator__c && c.Id == pf.Stenter__c && c.Id != pf.Cutdown_Physician__c && c.Id != pf.Additional_Physician_1__c && c.Id != pf.Additional_Physician_2__c){
					stentorAllTime++;
					contId_To_StentorAllTime.put(c.Id, stentorAllTime);
					if(tcarCertDate != null && pf.Procedure_Date__c > tcarCertDate){
						stentorPostTCAR++;
						contId_To_StentorPostTCAR.put(c.Id, stentorPostTCAR);
					}
				}
				//AS CUTDOWN ONLY
				if(c.Id != pf.Physician_Primary_Operator__c && c.Id != pf.Stenter__c && c.Id == pf.Cutdown_Physician__c && c.Id != pf.Additional_Physician_1__c && c.Id != pf.Additional_Physician_2__c){
					cutdownAllTime++;
					contId_To_CutdownAllTime.put(c.Id, cutdownAllTime);
					if(tcarCertDate != null && pf.Procedure_Date__c > tcarCertDate){
						cutdownPostTCAR++;
						contId_To_CutdownPostTCAR.put(c.Id, cutdownPostTCAR);
					}
				}
				//AS STENTOR AND CUTDOWN
				if(c.Id == pf.Stenter__c && c.Id == pf.Cutdown_Physician__c){
					stentorAndCutdownAllTime++;
					contId_To_StentorAndCutdownAllTime.put(c.Id, stentorAndCutdownAllTime);
					if(tcarCertDate != null && pf.Procedure_Date__c > tcarCertDate){
						stentorAndCutdownPostTCAR++;
						contId_To_StentorAndCutdownPostTCAR.put(c.Id, stentorAndCutdownPostTCAR);
					}
				}
				//AS ADDITIONAL
				if(c.Id == pf.Additional_Physician_1__c || c.Id == pf.Additional_Physician_2__c){
					additionalAllTime++;
					contId_To_AdditionalAllTime.put(c.Id, additionalAllTime);
					if(tcarCertDate != null && pf.Procedure_Date__c > tcarCertDate){
						additionalPostTCAR++;
						contId_To_AdditionalPostTCAR.put(c.Id, additionalPostTCAR);
					}

				}

				if(c.Id == pf.Cutdown_Physician__c || c.Id == pf.Stenter__c || c.Id == pf.Physician_Primary_Operator__c){
					acctIdSet.add(pf.Account__c);
				}

			} // END PROCEDURE FOR LOOP

			contId_To_AccountCount.put(c.Id, acctIdSet.size());

		}// END CONTACT FOR LOOP

		for(Contact c : contactList){

			Date tCarCertDate = contId_To_TCARCertDate.get(c.Id);

			Map<Integer, Date> postTCARInnerMap;
			if(contId_To_CaseNoToDatePostTCAR.get(c.Id) == null){
			}
			else{
				postTCARInnerMap = contId_To_CaseNoToDatePostTCAR.get(c.Id);
				if(tCarCertDate != null){
					if(postTCARInnerMap.get(1) != null){
						c.Days_to_1st_Case_Post_TCAR__c = tcarCertDate.Daysbetween(postTCARInnerMap.get(1));
					}
					if(postTCARInnerMap.get(5) != null){
							c.Days_to_5th_Case_Post_TCAR__c = tcarCertDate.Daysbetween(postTCARInnerMap.get(5));
					}
					if(postTCARInnerMap.get(10) != null){		
							c.Days_to_10th_Case_Post_TCAR__c = tcarCertDate.Daysbetween(postTCARInnerMap.get(10));
					}		
					if(postTCARInnerMap.get(20) != null){		
							c.Days_to_20th_Case_Post_TCAR__c = tcarCertDate.Daysbetween(postTCARInnerMap.get(20));
					}		
					if(postTCARInnerMap.get(30) != null){		
							c.Days_to_30th_Case_Post_TCAR__c = tcarCertDate.Daysbetween(postTCARInnerMap.get(30));
					}		
					if(postTCARInnerMap.get(40) != null){		
							c.Days_to_50th_Case_Post_TCAR__c = tcarCertDate.Daysbetween(postTCARInnerMap.get(40));
					}		
					if(postTCARInnerMap.get(100) != null){		
							c.Days_to_100th_Case_Post_TCAR__c = tcarCertDate.Daysbetween(postTCARInnerMap.get(100));
					}		
					List<Date> dateList = postTCARInnerMap.values();
					dateList.sort();
					Date maxDate = dateList[dateList.size()-1];
					c.Days_to_Max_Cases_Post_TCAR__c = tcarCertDate.Daysbetween(maxDate);
				}

			}


			Date firstCaseDate;

			Map<Integer, Date> allTimeInnerMap;
			if(contId_To_CaseNoToDateAllTime.get(c.Id) == null){
			}
			else{
				allTimeInnerMap = contId_To_CaseNoToDateAllTime.get(c.Id);
				if(allTimeInnerMap.get(1) != null){
					firstCaseDate = allTimeInnerMap.get(1);
					if(allTimeInnerMap.get(5) != null){
						c.Days_to_5th_Case_All_Time__c = firstCaseDate.Daysbetween(allTimeInnerMap.get(5));
					}	
					if(allTimeInnerMap.get(10) != null){
						c.Days_to_10th_Case_All_Time__c = firstCaseDate.Daysbetween(allTimeInnerMap.get(10));
					}	
					if(allTimeInnerMap.get(20) != null){
						c.Days_to_20th_Case_All_Time__c = firstCaseDate.Daysbetween(allTimeInnerMap.get(20));
					}	
					if(allTimeInnerMap.get(30) != null){
						c.Days_to_30th_Case_All_Time__c  = firstCaseDate.Daysbetween(allTimeInnerMap.get(30));
					}
					if(allTimeInnerMap.get(50) != null){
						c.Days_to_50th_Case_All_Time__c = firstCaseDate.Daysbetween(allTimeInnerMap.get(50));
					}	
					if(allTimeInnerMap.get(100) != null){
						c.Days_to_100th_Case_All_Time__c = firstCaseDate.Daysbetween(allTimeInnerMap.get(100));
					}	
					List<Date> dateList = allTimeInnerMap.values();
					dateList.sort();
					Date maxDate = dateList[dateList.size()-1];
					c.Days_to_Max_Cases_All_Time__c = firstCaseDate.Daysbetween(maxDate);	
				}
			}

			



			Integer primaryPostTCAR;
			if(contId_To_PrimaryPostTCAR.get(c.Id) == null){ primaryPostTCAR = 0; } else { primaryPostTCAR = contId_To_PrimaryPostTCAR.get(c.Id); }
			c.Procedures_as_Primary_Operator_Post_TCAR__c = primaryPostTCAR;
			
			Integer stentorPostTCAR; 
			if(contId_To_StentorPostTCAR.get(c.Id) == null){ stentorPostTCAR = 0; } else { stentorPostTCAR = contId_To_StentorPostTCAR.get(c.Id); }
			c.Procedures_as_Stentor_Only_Post_TCAR__c = stentorPostTCAR;

			Integer cutdownPostTCAR;
			if(contId_To_CutdownPostTCAR.get(c.Id) == null){ cutdownPostTCAR = 0; } else { cutdownPostTCAR = contId_To_CutdownPostTCAR.get(c.Id); }
			c.Procedures_as_Cutdown_Only_Post_TCAR__c = cutdownPostTCAR;
			
			Integer stentorAndCutdownPostTCAR;
			if(contId_To_StentorAndCutdownPostTCAR.get(c.Id) == null){ stentorAndCutdownPostTCAR = 0; } else { stentorAndCutdownPostTCAR = contId_To_StentorAndCutdownPostTCAR.get(c.Id); }
			c.Procedures_as_Stentor_Cutdown_Post_TCAR__c = stentorAndCutdownPostTCAR;

			Integer additionalPostTCAR;
			if(contId_To_AdditionalPostTCAR.get(c.Id) == null){ additionalPostTCAR = 0; } else { additionalPostTCAR = contId_To_AdditionalPostTCAR.get(c.Id); }
			c.Procedures_as_Additional_Post_TCAR__c = additionalPostTCAR;
            


            Integer primaryAllTime;
			if(contId_To_PrimaryAllTime.get(c.Id) == null){ primaryAllTime = 0; } else { primaryAllTime = contId_To_PrimaryAllTime.get(c.Id); }
			c.Procedures_as_Primary_Operator_All_Time__c = primaryAllTime;
			
			Integer stentorAllTime; 
			if(contId_To_StentorAllTime.get(c.Id) == null){ stentorAllTime = 0; } else { stentorAllTime = contId_To_StentorAllTime.get(c.Id); }
			c.Procedures_as_Stentor_Only_All_Time__c = stentorAllTime;

			Integer cutdownAllTime;
			if(contId_To_CutdownAllTime.get(c.Id) == null){ cutdownAllTime = 0; } else { cutdownAllTime = contId_To_CutdownAllTime.get(c.Id); }
			c.Procedures_as_Cutdown_Only_All_Time__c = cutdownAllTime;
			
			Integer stentorAndCutdownAllTime;
			if(contId_To_StentorAndCutdownAllTime.get(c.Id) == null){ stentorAndCutdownAllTime = 0; } else { stentorAndCutdownAllTime = contId_To_StentorAndCutdownAllTime.get(c.Id); }
			c.Procedures_as_Stentor_Cutdown_All_Time__c = stentorAndCutdownAllTime;

			Integer additionalAllTime;
			if(contId_To_AdditionalAllTime.get(c.Id) == null){ additionalAllTime = 0; } else { additionalAllTime = contId_To_AdditionalAllTime.get(c.Id); }
			c.Procedures_as_Additional_All_Time__c = additionalAllTime;

			Integer numberOfAccts;
			if(contId_To_AccountCount.get(c.Id) == null){ numberOfAccts = 0; } else { numberOfAccts = contId_To_AccountCount.get(c.Id); }
			c.Accounts_Where_Stentor_Cutdown_Primary__c = numberOfAccts;
		
		}// END CONT LIST LOOP

		GlobalTriggerSwitch.runContactTrigger = false;
		update contactList;
		GlobalTriggerSwitch.runContactTrigger = true;							
	
	}	
	*/	
}