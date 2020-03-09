public with sharing class InvoiceTrigger_Helper {

 

	public static void qad_setAccountId(List<Invoice__c> inputInvoiceList){
		
		Set<String> acctNoSet = new Set<String>();
		for(Invoice__c i : inputInvoiceList){
			if(i.QAD_ih_cust__c != null){
				acctNoSet.add(i.QAD_ih_cust__c);
			}
		}

		Map<String, Id> acctMap = new Map<String, Id>();
		List<Account> acctList = [SELECT Id, QAD_cm_addr__c FROM Account WHERE QAD_cm_addr__c IN : acctNoSet];
		for(Account a : acctList){
			acctMap.put(a.QAD_cm_addr__c, a.Id);
		}

		for(Invoice__c i : inputInvoiceList){
			if(i.QAD_ih_cust__c != null && acctMap.get(i.QAD_ih_cust__c) != null){
				i.Account__c = acctMap.get(i.QAD_ih_cust__c);
			}
		}

	}

	


	public static void qad_populateInvoiceFieldsBeforeUpsert(List<Invoice__c> inputInvoiceList) {
		/****************************************************************************************************	
	    *   This method runs as a before, non-delete trigger method on Invoice__c and its purpose is        *
	    *   to update the following Invoice__c Fields:                                                      *
        * 																									*      
		*		    Area_Manager_at_the_Time__c                                                             *
		*			Billing_Attn__c                                                                         *
		*			Billing_City__c                                                                         *
		*			Billing_Country__c                                                                      *
		*			Billing_Postal_Code__c                                                                  *
		*			Billing_State__c                                                                        *
		*			Billing_Street__c                                                                       *
		*			Bill_To_Address__c                                                                      *
		*			Order__c                                                                                *
		*			Account_Manager_Id__c                                                                   *
		*			Area_Director_Id__c                                                                     *
		*			Therapy_Development_Specialist_Id__c                                                    *
		*			Territory_Id__c                                                                         *
		*			Time_Period__c                                                                          *
		*			Goal_Id__c                                                                              *
 		*****************************************************************************************************/

 		//Initially loop through input Invoice List to get parameters for populating the fields
 		Set<String> billToAddrSet = new Set<String>();
 		Set<String> orderNoSet = new Set<String>();
 		Set<String> slsPrsonSet = new Set<String>();
 		Set<String> timePeriodSet = new Set<String>();
 		Set<Id> acctIdSet = new Set<Id>();

 		for(Invoice__c i : inputInvoiceList){
 			if(i.QAD_sourced__c){
 				billToAddrSet.add(i.QAD_ih_bill__c);
 				orderNoSet.add(i.Sales_Order_Number__c);
 				acctIdSet.add(i.Account__c);

 				if(i.Invoice_Date__c != null){
 					String yrMo = i.Invoice_Date__c.year() + '-' ;
 					String mo;
 					if(i.Invoice_Date__c.month() < 10){
 						mo = '0' + i.Invoice_Date__c.month();
 					}
 					else{
 						mo = String.valueOf(i.Invoice_Date__c.month());
 					}
 					yrMo = yrMo + mo;
 					timePeriodSet.add(yrMo);
 				}

 			}
 			if(i.QAD_ih_slspsn__c != null && i.QAD_ih_slspsn__c != ''){
 				List<String> sList = i.QAD_ih_slspsn__c.split('-');
 				slsPrsonSet.addall(sList);
 			}
 		}// END FOR LOOP

 		//Build Maps To Translate Values
 		Map<String, Account_Address__c> addrMap = new Map<String, Account_Address__c>();
 		Map<String, User> userMap = new Map<String, User>();
 		Map<String, Id> orderMap = new Map<String, Id>();
 		Map<String, Id> tpMap = new Map<String, Id>();
 		Map<String, Id> terrMap = new Map<String, Id>();
 		Map<Id,Id> acctOwnerMap = new Map<Id, Id>();
 		// Note that we can not get the goal map until we have populated both the Time Period and the Territory

 		List<Account_Address__c> addrList = [SELECT Id, QAD_ad_addr__c, ATTN__c, City__c, Country__c, Postal_Code__c, State_Province__c, Street_Address__c FROM Account_Address__c WHERE QAD_ad_addr__c IN : billToAddrSet];
 		for(Account_Address__c aa : addrList){
 			addrMap.put(aa.QAD_ad_addr__c, aa);
 		}

 		List<Order> oList = [SELECT Id, IQMS_ORDER_NO__c FROM Order WHERE IQMS_ORDER_NO__c IN : orderNoSet];
 		for(Order o : oList){
 			ordermap.put(o.IQMS_ORDER_NO__c, o.Id);
 		}

 		List<User> uList = [SELECT Id, QAD_Territory_Id__c, FirstName, LastName FROM User WHERE QAD_Territory_Id__c IN : slsPrsonSet];
 		for(User u : uList){
 			userMap.put(u.QAD_Territory_Id__c, u);
 		}

 		List<Territory__c> terrList = [SELECT Id, QAD_AM_Id__c FROM Territory__c WHERE QAD_AM_Id__c IN : slsPrsonSet AND isActive__c = TRUE];
 		for(Territory__c t : terrList){
 			terrMap.put(t.QAD_AM_Id__c, t.Id);
 		}

 		List<TimePeriods__c> tpList = [SELECT Id, Name FROM TimePeriods__c WHERE Name IN : timePeriodSet];
 		for(TimePeriods__c tp : tpList){
 			tpMap.put(tp.Name, tp.Id);
 		}

 		List<Account> acctList = [SELECT Id, OwnerId FROM Account WHERE Id IN : acctIdSet];
 		for(Account a : acctList){
 			acctOwnerMap.put(a.Id, a.OwnerId);
 		}

 		// Now populate Billto Address, Order No, AM, AD and TDS, Territory and Time Period
 		for(Invoice__c i : inputInvoiceList){
 			if(i.QAD_sourced__c){

 				// Populate Billing Address
	 			if(addrMap.get(i.QAD_ih_bill__c) != null){
	 				Account_Address__c aa = addrMap.get(i.QAD_ih_bill__c);
		 			i.Billing_Attn__c = aa.ATTN__c;
					i.Billing_City__c = aa.City__c;
					i.Billing_Country__c = aa.Country__c;
					i.Billing_Postal_Code__c = aa.Postal_Code__c;
					i.Billing_State__c = aa.State_Province__c;
					i.Billing_Street__c = aa.Street_Address__c;
					i.Bill_To_Address__c = aa.Id;
				}

				// Populate Field Personel and Territory
				if(i.QAD_ih_slspsn__c != null && i.QAD_ih_slspsn__c != ''){
					//Parse Sales People Indicated
					List<String> sList = i.QAD_ih_slspsn__c.split('-');
					for(String s : sList){

						//Separate the values to determine if 'AD', 'AM', or 'TDS'
						String ad;
						String am;
						String td;

						if(s.Left(2) == 'AD' && userMap.get(s) != null){
							ad = s;

							i.Area_Director_Id__c = userMap.get(ad).Id;

						}
						else if(s.Left(2) == 'AM' && userMap.get(s) != null){
							am = s;
							i.Area_Manager_Id__c = userMap.get(am).Id; 
							i.Territory_Id__c = terrMap.get(am);
							i.Area_Manager_at_the_Time__c = userMap.get(am).FirstName + ' ' + userMap.get(am).LastName ;
						}
						else if(s.Left(2) == 'TD' && userMap.get(s) != null){
							td = s;
							i.Therapy_Development_Specialist_Id__c = userMap.get(td).Id;
						}
					}// END FOR LOOP
				}

				// Populate TimePeriod
				if(i.Invoice_Date__c != null){
 					String yrMo = i.Invoice_Date__c.year() + '-' ;
 					String mo;
 					if(i.Invoice_Date__c.month() < 10){
 						mo = '0' + i.Invoice_Date__c.month();
 					}
 					else{
 						mo = String.valueOf(i.Invoice_Date__c.month());
 					}
 					yrMo = yrMo + mo;

 					if(tpMap.get(yrMo) != null){
 						i.Time_Period_Id__c = tpMap.get(yrMo);
 					}
 				}

 				// Populate Order
 				if(ordermap.get(i.Sales_Order_Number__c) != null){
 					i.Order__c = orderMap.get(i.Sales_Order_Number__c);
 				}

 				//Set Record Owner
 			//	if(acctOwnerMap.get(i.Account__c) != null){
 			//		i.OwnerId = acctOwnerMap.get(i.Account__c);
 			//	}

			}

 		}// End For Loop
 
		//Now lets assign the goal
		Set<String> keyStringSet = new Set<String>();
		for(Invoice__c i : inputInvoiceList){
			if(i.QAD_sourced__c){
				if(i.Territory_Id__c != null && i.Time_Period_Id__c != null){
					String keyString = String.valueOf(i.Territory_Id__c) + String.valueOf(i.Time_Period_Id__c);
					keyStringSet.add(keyString);
				}
			}
		} // END FOR LOOP

		// Now that we have 
		Map<String, Id> goalMap = new Map<String, Id>();
		List<Goal__c> goalList = [SELECT Id, KeyString__c FROM Goal__c WHERE KeyString__c IN : keyStringSet];
		for(Goal__c g : goalList){
			goalMap.put(g.KeyString__c, g.Id);
		} // END FOR LOOP

		for(Invoice__c i : inputInvoiceList){
			if(i.QAD_sourced__c){
				if(i.Territory_Id__c != null && i.Time_Period_Id__c != null){
					String keyString = String.valueOf(i.Territory_Id__c) + String.valueOf(i.Time_Period_Id__c);
					keyStringSet.add(keyString);
					if(goalMap.get(keyString) != null){
						i.Goal_Id__c = goalMap.get(keyString);
					}
				}
			}
		}// END FOR LOOP
	} 




	public static void afterPopulateRMAShipDates(List<Invoice__c> inputInvoiceList){
		Map<String, Date> shipDateMap = new Map<String, Date>();
		for(Invoice__c i : inputInvoiceList){
			if(i.Sales_Order_Number__c.left(1) == 'R'){
				shipDateMap.put(i.Sales_Order_Number__c, i.QAD_ih_ship_date__c);
			}
		}

		List<OrderItem> rmaOrderItemList = [SELECT id, Ship_Date__c, Order.IQMS_ORDER_NO__c, Area_Director_Id__c, Area_Manager_Id__c, Territory__c FROM OrderItem WHERE Order.IQMS_Order_NO__c IN : shipDateMap.Keyset() ];
		for(OrderItem oi : rmaOrderItemList){
			oi.Ship_Date__c = shipDateMap.get(oi.Order.IQMS_ORDER_NO__c);
		}
		
		update rmaOrderItemList;
	}






	public static void afterInsertPopulateRMATerritories(List<Invoice__c> inputInvoiceList){
		Map<String, Id> rmaInvoiceIdMap = new Map<String, Id>();
		for(Invoice__c i : inputInvoiceList){
			if(i.Sales_Order_Number__c.left(1) == 'R'){
				rmaInvoiceIdMap.put(i.Sales_Order_Number__c, i.Id);
			}
		}
		Map<String, Invoice__c> rmaInvoiceMap = new Map<String, Invoice__c>();
		List<Invoice__c> linvoiceList = [SELECT Account__r.SFDCTerritoryId__c, Account__r.Area_Director_Id__c, Account__r.Area_Manager_User__c, Sales_Order_Number__c, Id FROM Invoice__c WHERE Id IN : rmaInvoiceIdMap.values()];
		for(Invoice__c i : linvoiceList){
			rmaInvoiceMap.put(i.Sales_Order_Number__c, i);
		}

		List<OrderItem> rmaOrderItemList = [SELECT id, Ship_Date__c, Order.IQMS_ORDER_NO__c, Area_Director_Id__c, Area_Manager_Id__c, Territory__c FROM OrderItem WHERE Order.IQMS_Order_NO__c IN : rmaInvoiceIdMap.Keyset() ];

		for(OrderItem oi : rmaOrderItemList){
			if(rmaInvoiceMap.get(oi.Order.IQMS_ORDER_NO__c) != null){
				Invoice__c inv = rmaInvoiceMap.get(oi.Order.IQMS_ORDER_NO__c);
				oi.Area_Director_Id__c = inv.Account__r.Area_Director_Id__c;
				oi.Area_Manager_Id__c = inv.Account__r.Area_Manager_User__c;
				oi.Territory__c = inv.Account__r.SFDCTerritoryId__c;
			}
		}
		update rmaOrderItemList;
	}	

	
}