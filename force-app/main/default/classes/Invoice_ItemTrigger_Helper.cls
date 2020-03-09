public with sharing class Invoice_ItemTrigger_Helper {
	

	public static void qad_setSalesFields(List<Invoice_Item__c> inputInvoiceItemList) {
		Set<String> goalKeySet = new Set<String>();

		// get QAD List of Sales Reps
		Set<String> qadSlspsnSet = new Set<String>();
		Set<String> qadTimePeriodList = new Set<String>();
		Set<Id> orderItemIdSet = new Set<Id>();
		for(Invoice_Item__c ii  : inputInvoiceItemList){
			if(ii.QAD_sourced__c){
				if(ii.QAD_idh_slspsn__c!= null && ii.QAD_idh_slspsn__c != ''){
					List<String> stringList = ii.QAD_idh_slspsn__c.split('-');
					qadSlspsnSet.addAll(stringList);

					if(ii.OrderItem__c != null){
						orderItemIdSet.add(ii.OrderItem__c);
					}

					if(ii.Ship_Date__c != null){
						String tp = String.valueOf(ii.Ship_Date__c.year()) + '-';
						String mo;
						if(ii.Ship_Date__c.month() < 10){
							mo = '0' + String.valueOf(ii.Ship_Date__c.month());
						}
						else{
							mo = String.valueOf(ii.Ship_Date__c.month());
						}
						tp = tp + mo;
						qadTimePeriodList.add(tp);
					}
				}
			}	
		}// END FOR LOOP




		for(String s : qadSlspsnSet){
			SYSTEM.DEBUG('IN SLSpsnSet = [' + s + ']');
		}


		//Build a map from QAD Id to SFDC.User.Ids
		Map<String, String> qad_to_sfdcUserName = new Map<String, String>();
		Map<String, String> qad_to_sfdcUserId = new Map<String, String>();


		List<User> uList = [SELECT Id, FirstName, LastName, QAD_Territory_Id__c FROM User WHERE QAD_Territory_Id__c IN : qadSlspsnSet ];
		for(User u : uList){
			qad_to_sfdcUserName.put(u.QAD_Territory_Id__c, u.FirstName + ' ' + u.LastName );
			qad_to_sfdcUserId.put(u.QAD_Territory_Id__c, u.Id);
		}

		//Builf s map from QAD Id to Territory
		Map<String, String> qad_to_sfdcTerritoryName = new Map<String, String>();
		Map<String, Id> qad_to_sfdcTerritoryId = new Map<String, Id>();


		List<Territory__c> tList = [SELECT Id, QAD_AM_Id__c, Name FROM Territory__c WHERE QAD_AM_Id__c IN : qadSlspsnSet AND isActive__c = TRUE];
		for(Territory__c t : tList){
			SYSTEM.DEBUG('TERRITORY ID FROM TERRITORY ID = [' + t.Id + ']');
			qad_to_sfdcTerritoryId.put(t.QAD_AM_Id__c, t.Id);
			qad_to_sfdcTerritoryName.put(t.QAD_AM_Id__c, t.Name);

		}

		for(String s : qad_to_sfdcTerritoryId.Keyset()){
			SYSTEM.DEBUG('IN Key = [' + s + '] Territory = [' + qad_to_sfdcTerritoryId.get(s) + ']');
		}

		//Build a map from Time Period Name to Time Period Id
		Map<String, Id> tpMap = new Map<String, Id>();
		List<TimePeriods__c> tpList = [SELECT Id, Name FROM TimePeriods__c WHERE Name In : qadTimePeriodList];
		for(TimePeriods__c tp : tpList){
			tpMap.put(tp.Name, tp.Id);
		}

		Map<Id, OrderItem> orderItemMap = new Map<Id, OrderItem>();
		List<OrderItem> oiList = [SELECT Id, Territory__c, Area_Director_Id__c, Area_Manager_Id__c, Therapy_Development_Specialist_Id__c, TimePeriodID__c, Goal__c FROM OrderItem WHERE Id IN: orderItemIdSet];
		for(OrderItem oi : oiList){
			orderItemMap.put(oi.Id, oi);
		}



		for(Invoice_Item__c ii : inputInvoiceItemList){
			if(ii.QAD_sourced__c){	
				SYSTEM.DEBUG('ORDER-LINE = [' + ii.Invoice_Line_Number__c + ']');

				//Set the Time Period
				if(ii.Ship_Date__c != null){
					String tp = String.valueOf(ii.Ship_Date__c.year()) + '-';
					String mo;
					if(ii.Ship_Date__c.month() < 10){
						mo = '0' + String.valueOf(ii.Ship_Date__c.month());
					}
					else{
						mo = String.valueOf(ii.Ship_Date__c.month());
					}
					tp = tp + mo;
					
					ii.TimePeriodID__c = tpMap.get(tp); 

					SYSTEM.DEBUG('TimePeriod = [' + tp + '] TP ID = [' + tpMap.get(tp) + ']');
				}

				if(ii.QAD_idh_slspsn__c != null && ii.QAD_idh_slspsn__c != ''){

					//Loop through field personnel to assign to the Order Item AND assign Territory and Goal
					List<String> sList = ii.QAD_idh_slspsn__c.split('-');
					
					Integer i = 0;
					for(String s : sList){
						SYSTEM.DEBUG('POSITION [' + i + '] VALUE = [' + s + ']');
						i++;

						//Separate the values to determine if 'AD', 'AM', or 'TDS'
						String ad;
						String am;
						String td;

						if(s.Left(2) == 'AD' && qad_to_sfdcUserId.get(s) != null){
							ad = s;

							ii.Area_Director_Id__c = qad_to_sfdcUserId.get(ad);

						}
						else if(s.Left(2) == 'AM' && qad_to_sfdcUserId.get(s) != null){
							am = s;
							ii.Area_Manager__c = qad_to_sfdcUserId.get(am); 
							ii.Territory_Id__c = qad_to_sfdcTerritoryId.get(am);

							SYSTEM.DEBUG('ASSIGN TERRITORY [' + qad_to_sfdcTerritoryId.get(am) );


						}
						else if(s.Left(2) == 'TD' && qad_to_sfdcUserId.get(s) != null){
							td = s;

							ii.Therapy_Development_Specialist_Id__c = qad_to_sfdcUserId.get(td);
							
						}
					}// End For Loop
				
					if(ii.Territory_Id__c != null && ii.TimePeriodId__c != null){
						string keyString = String.valueOf(ii.Territory_Id__c).Left(15) + String.valueOf(ii.TimePeriodId__c).Left(15);

						SYSTEM.DEBUG('BUILD KEY STRING = [' + keyString + ']');
						goalKeySet.add(keyString);
					}
				}
			}
			else if(ii.OrderItem__c != null && orderItemMap.get(ii.OrderItem__c) != null){
				OrderItem oi = orderItemMap.get(ii.OrderItem__c);	
				ii.Area_Director_Id__c = oi.Area_Director_Id__c;
				ii.Area_Manager__c = oi.Area_Manager_Id__c;
				ii.Therapy_Development_Specialist_Id__c = oi.Therapy_Development_Specialist_Id__c;
				ii.Territory_Id__c = oi.Territory__c;
				ii.Goal_Id__c = oi.Goal__c;

			}		
		}//End for loop

		//Now connect Goals
		Map<String, Id> goalMap = new Map<String, Id>();
		List<Goal__c> gList = [SELECT Id, KeyString__c FROM Goal__c WHERE  KeyString__c IN : goalKeySet];

		SYSTEM.DEBUG('GLIST SIZE = [' + glist.size() + ']');

		for(Goal__c g : gList){
			goalMap.put(g.Keystring__c, g.Id);

			SYSTEM.DEBUG('PUT MAP KEYSTRING  = [' + g.keyString__c + '] VALUE = [' + g.Id + ']');

		}

		for(Invoice_Item__c ii : inputInvoiceItemList){
			if(ii.QAD_sourced__c && ii.Goal_Id__c == null){
				SYSTEM.DEBUG('TerritoryId = [' + ii.Territory_Id__c + '] Time PeriodId = [' + ii.TimePeriodId__c + ']');
				if(ii.Territory_Id__c != null && ii.TimePeriodId__c != null){	
					String keyString = String.valueOf(ii.Territory_Id__c).Left(15) + String.valueOf(ii.TimePeriodId__c).Left(15);
					if(goalMap.get(keyString) != null){

						SYSTEM.DEBUG('GET KEY STRING = [' + keyString + ']');

						ii.Goal_Id__c = goalMap.get(keyString);
					}
				}
			}		
		}
	}

	public static void qad_setInvoiceNumber(List<Invoice_Item__c> inputInvoiceItemList){
		Set<String> invoiceNoSet = new Set<String>();
		for(Invoice_Item__c ii : inputInvoiceItemList){
			if(ii.QAD_idh_inv_nbr__c != null){
				invoiceNoSet.add(ii.QAD_idh_inv_nbr__c);
			}
		}

		Map<String, Id> invMap = new Map<String, Id>();
		List<Invoice__c> invList = [SELECT Id, Invoice_Number__c FROM Invoice__c WHERE Invoice_Number__c IN : invoiceNoSet];
		for(Invoice__c i : invList){
			invMap.put(i.Invoice_Number__c, i.Id);
		}

		for(Invoice_Item__c ii : inputInvoiceItemList){
			if(ii.QAD_idh_inv_nbr__c != null && invMap.get(ii.QAD_idh_inv_nbr__c) != null){
				ii.Invoice__c = invMap.get(ii.QAD_idh_inv_nbr__c);	
			}
		}
	} 
}