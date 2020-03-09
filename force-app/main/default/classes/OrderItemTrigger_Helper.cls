public without sharing class OrderItemTrigger_Helper {
 

	public static void qad_setOrderIdBefore(List<OrderItem> oiInputList){
		Set<String> orderNumberStringSet = new Set<String>();
		for(OrderItem oi : oiInputList){
			orderNumberStringSet.add(oi.IQMS_Order_Id__c);
		}
		
		Map<String, Id> orderMap = new Map<String, ID>();
		Map<Id, Date> orderHeaderShipDateMap = new Map<Id, Date>();
		List<Order> oList = [SELECT ID, Pricebook2Id, IQMS_ORDER_NO__c, QAD_so_ship_date__c FROM Order WHERE IQMS_ORDER_NO__c IN : orderNumberStringSet];
		for(Order o : oList){
			orderMap.put(o.IQMS_ORDER_NO__c, o.Id);

			if(o.QAD_so_ship_date__c != null){
				orderHeaderShipDateMap.put(o.Id, o.QAD_so_ship_date__c);
			}
		}

		for(OrderItem oi : oiInputList){
			if(oi.OrderId == null){
				oi.OrderId = orderMap.get(oi.IQMS_ORDER_ID__c);
			}

			if(oi.Ship_Date__c == null && orderHeaderShipDateMap.get(oi.OrderId) != null){
				oi.Ship_Date__c = orderHeaderShipDateMap.get(oi.OrderId);
			}
		}
	}
 
	public static void qad_setSalesRepsTerritoriesTimePeriod(List<OrderItem> oiInputList){
		Set<String> qadSlspsnSet = new Set<String>();
		Set<String> qadTimePeriodList = new Set<String>();
		for(OrderItem oi : oiInputList){
			if(oi.QAD_sourced__c){
				if(oi.QAD_sod_slspsn__c != null && oi.QAD_sod_slspsn__c != ''){
					List<String> stringList = oi.QAD_sod_slspsn__c.split('-');
					qadSlspsnSet.addAll(stringList);
				}

				if(oi.Ship_Date__c != null){
					String tp = String.valueOf(oi.Ship_Date__c.year()) + '-';
					String mo;
					if(oi.Ship_Date__c.month() < 10){
						mo = '0' + String.valueOf(oi.Ship_Date__c.month());
					}
					else{
						mo = String.valueOf(oi.Ship_Date__c.month());
					}
					tp = tp + mo;
					qadTimePeriodList.add(tp);
				}
			}
		}

		// **********************************************************************
		// **   GET RELEVANT SALES REP INFORMATION FROM USER                   **
		// **********************************************************************
		//Build a map from QAD Id to SFDC.User.Ids
		Map<String, String> qad_to_sfdcUserName = new Map<String, String>();
		Map<String, String> qad_to_sfdcUserId = new Map<String, String>();

		List<User> uList = [SELECT Id, FirstName, LastName, QAD_Territory_Id__c FROM User WHERE QAD_Territory_Id__c IN : qadSlspsnSet ];
		for(User u : uList){
			qad_to_sfdcUserName.put(u.QAD_Territory_Id__c, u.FirstName + ' ' + u.LastName );
			qad_to_sfdcUserId.put(u.QAD_Territory_Id__c, u.Id);
		}

  
		// **********************************************************************
		// **   GET RELEVANT TERRITORY INFORMATION FROM USER                   **
		// **********************************************************************
		//Builf s map from QAD Id to Territory
		Map<String, String> qad_to_sfdcTerritoryName = new Map<String, String>();
		Map<String, Id> qad_to_sfdcTerritoryId = new Map<String, Id>();


		List<Territory__c> tList = [SELECT Id, QAD_AM_Id__c, Name FROM Territory__c WHERE QAD_AM_Id__c IN : qadSlspsnSet AND IsActive__c = TRUE];
		for(Territory__c t : tList){
			qad_to_sfdcTerritoryId.put(t.QAD_AM_Id__c, t.Id);
			qad_to_sfdcTerritoryName.put(t.QAD_AM_Id__c, t.Name);

		}

		// **********************************************************************
		// **   GET RELEVANT TIME PERIOD INFORMATION                           **
		// **********************************************************************
		//Build a map from Time Period Name to Time Period Id
		Map<String, Id> tpMap = new Map<String, Id>();
		List<TimePeriods__c> tpList = [SELECT Id, Name FROM TimePeriods__c WHERE Name In : qadTimePeriodList];
		for(TimePeriods__c tp : tpList){
			tpMap.put(tp.Name, tp.Id);
		}

		// ===========================================================================================
		// ORDERITEM LIST PASS 2 - LOOP THROUGH ORDERITEM, SET TIME PERIOD, SALESPEOPLE, AND TERRITORY
		// =========================================================================================== 
		for(OrderItem oi : oiInputList){
			if(oi.QAD_sourced__c){	
				//Set the Time Period
				if(oi.Ship_Date__c != null){
					String tp = String.valueOf(oi.Ship_Date__c.year()) + '-';
					String mo;
					if(oi.Ship_Date__c.month() < 10){
						mo = '0' + String.valueOf(oi.Ship_Date__c.month());
					}
					else{
						mo = String.valueOf(oi.Ship_Date__c.month());
					}
					tp = tp + mo;
					
					oi.TimePeriodID__c = tpMap.get(tp); 
				}


				List<String> sList = new List<String>();

				if(oi.QAD_sod_slspsn__c != null){
					//Loop through field personnel to assign to the Order Item AND assign Territory and Goal
					sList = oi.QAD_sod_slspsn__c.split('-');
				}

				
				Integer i = 0;
				for(String s : sList){
					i++;

					//Separate the values to determine if 'AD', 'AM', or 'TDS'
					String ad;
					String am;
					String td;

					if(s.Left(2) == 'AD' && qad_to_sfdcUserId.get(s) != null){
						ad = s;

						oi.Area_Director_Id__c = qad_to_sfdcUserId.get(ad);

					}
					else if(s.Left(2) == 'AM' && qad_to_sfdcUserId.get(s) != null){
						am = s;
						oi.Area_Manager_Id__c = qad_to_sfdcUserId.get(am); 
						oi.Territory__c = qad_to_sfdcTerritoryId.get(am);
					}
					else if(s.Left(2) == 'TD' && qad_to_sfdcUserId.get(s) != null){
						td = s;

						oi.Therapy_Development_Specialist_Id__c = qad_to_sfdcUserId.get(td);
						
					}
				}// End For Loop
			}	
		}//End for loop
	}





	public static void setAccountCustomerStatus(List<OrderItem> oiInputList){

		Set<Id> oiIdSet = new Set<Id>();
		for(OrderItem oi : oiInputList){
			oiIdSet.add(oi.Id);
		}


		List<AggregateResult> arList = [SELECT Order.AccountId acctId FROM OrderItem WHERE Ship_Date__c <> null AND Id IN : oiIdSet GROUP BY Order.AccountId]; 

		Set<Id> custAcctIdSet = new Set<Id>();

		for(AggregateResult ar : arList){
		     Id acctId = String.valueOf(ar.get('acctId'));
		     SYSTEM.DEBUG('[' + acctId + ']');
		     custAcctIdSet.add(acctId);
		}

		List<Account> acctList = [SELECT Id, Is_Converted_Customer__c FROM Account WHERE Id IN : custAcctIdSet];
		for(Account a : acctList){
		     a.Is_Converted_Customer__c = TRUE;
		}

		update acctList;
	}





	public static void qad_connectToGoal(List<OrderItem> oiInputList){
		Set<Id> terrIdSet = new Set<Id>();
		Set<Id> tpIdSet = new Set<Id>();
		for(OrderItem oi : oiInputList){
			if(oi.Ship_Date__c != null && oi.TimePeriodId__c != null && oi.Territory__c != null){
				terrIdSet.add(oi.Territory__c);
				tpIdSet.add(oi.TimePeriodId__c);
			}
		}

		Map<String, Id> goalMap = new Map<String, Id>();
		List<Goal__c> goalList = [SELECT Id, TimePeriod__c, Territory__c FROM Goal__c WHERE TimePeriod__c IN : tpIdSet OR Territory__c IN : terrIdSet];
		for(Goal__c g : goalList){
			String keyString = g.TimePeriod__c + '-' + g.Territory__c;
			goalMap.put(keyString, g.Id);
		}

		Date today;
		if(Test.isRunningTest()){
		 	today = Date.newInstance(2018, 3, 1);
		}
		else{
			today = System.Today();
		}

		String todayYrQtr;
		String todayYr = String.valueOf(today.year());
		String todayQtr;
		if(today.month() < 4){
			todayQtr = '-Q1';
		}
		else if(today.month() < 7){ 
			todayQtr = '-Q2';
		}
		else if(today.month() < 10){
			todayQtr = '-Q3';
		}
		else{
			todayQtr = '-Q4';
		}
		todayYrQtr = todayYr + todayQtr;

		for(OrderItem oi : oiInputList){

			String shpDtMoYr;
			String shpDtYrQtr;
			
			if(oi.Ship_Date__c != null){	
				String shpDtYr = String.valueOf(oi.Ship_Date__c.year());
				String shpDtQtr;
				if(oi.Ship_Date__c.month() < 4){
					shpDtQtr = '-Q1';
				}
				else if(oi.Ship_Date__c.month() < 7){ 
					shpDtQtr = '-Q2';
				}
				else if(oi.Ship_Date__c.month() < 10){
					shpDtQtr = '-Q3';
				}
				else{
					shpDtQtr = '-Q4';
				}
				shpDtYrQtr = shpDtYr + shpDtQtr;
			}

			//if(oi.Ship_Date__c != null && todayYrQtr == shpDtYrQtr && oi.TimePeriodId__c != null && oi.Territory__c != null){
			if(oi.Ship_Date__c != null && oi.TimePeriodId__c != null && oi.Territory__c != null){
				String keyString = oi.TimePeriodId__c + '-' + oi.Territory__c;
				oi.Goal__c = goalMap.get(keyString);
			}
		}

	}

  


	public static void qad_setPricebookEntry(List<OrderItem> oiInputList){	

		SYSTEM.DEBUG('* * * * ENTERING SET PRICEBOOKENTRY * * * *');

		Set<Id> orderIdSet = new Set<Id>();
		Set<String> productString = new Set<String>();
		Map<String, String> orderNumLineToProductCode = new Map<String, String>();
		for(OrderItem oi : oiInputList){
			orderIdSet.add(oi.OrderId);
			String productCode = oi.QAD_sod_part__c.toUpperCase();
			String um;
			if(oi.Unit_of_Measure__c == null){ 
				um = 'EA';
			}
			else{
				um = oi.Unit_of_Measure__c.toUpperCase();
			}
			String productKey = productCode + ' [' + um + ']';

			SYSTEM.DEBUG(' PRODUCT KEY = [' + productKey + ']');

			orderNumLineToProductCode.put(oi.OrderNumLine__c, productKey);
		}

		Map<Id, Order> orderMap = new Map<Id, Order>();
		Set<Id> pricebooksReferenced = new Set<Id>();
		List<Order> oList = [SELECT Id, Pricebook2Id, Pricebook2.Name FROM Order WHERE ID IN : orderIdSet];
		for(Order o : oList){
			orderMap.put(o.Id, o);
			SYSTEM.DEBUG('ORDER PRICEBOOOK = [' + o.Pricebook2Id + ']');
			pricebooksReferenced.add(o.Pricebook2Id);
		}

		Map<String, Id> productIdMap = new Map<String, Id>();
		List<Product2> p2List = [SELECT Id, ProductCode FROM Product2 WHERE ProductCode IN : orderNumLineToProductCode.values()];
		for(Product2 p2 : p2List){
			productIdMap.put(p2.ProductCode, p2.Id);
			SYSTEM.DEBUG('PRODUCT ID MAP PUT [' + p2.ProductCode + '], [' + p2.Id + ']' );
		}

		// CHECK IF Product2 Exists
		List<Product2> p2ToCreateList = new List<Product2>();
		Set<String> productCodeSet = new Set<String>();
		for(OrderItem oi : oiInputList){
			String productCode = orderNumLineToProductCode.get(oi.OrderNumLine__c);
			if(productIdMap.get(productCode) == null && !productCodeSet.contains(productCode)){
				Product2 newP2 = new Product2(ProductCode = productCode, IsActive = true, QAD_sourced__c = true, Name = productCode);
				p2ToCreateList.add(newP2);
				productCodeSet.add(productCode);
			}
		}
		Insert p2ToCreateList;
		for(Product2 p2 : p2ToCreateList){
			productIdMap.put(p2.ProductCode, p2.Id);
		}

		// GATHER LIST OF PBE THAT ARE RELEVANT
		Map<String, Id> pbeKeySetToPbeId = new Map<String, Id>();
		List<PricebookEntry> pbeList = [SELECT Id, Pricebook2Id, Product2Id FROM PricebookEntry WHERE PriceBook2Id IN : pricebooksReferenced ];
		for(PricebookEntry pbe : pbeList){
			String pbeKeySet = pbe.Pricebook2Id + '-' + pbe.Product2Id;
			pbeKeySetToPbeId.put(pbeKeySet, pbe.Id);
			SYSTEM.DEBUG('PBE RELEVANT = [' + pbeKeySet + '], [' + pbe.Id + ']');
		}

		// CHECK IF PRICEBOOKENTRY EXISTS
		Map<String, Id> pbeKeySetMap = new Map<String, Id>();
		List<PricebookEntry> pbeToInsertList = new List<PricebookEntry>();
		for(OrderItem oi : oiInputList){
			if(orderNumLineToProductCode.get(oi.OrderNumLine__c) != null && orderMap.get(oi.OrderId) != null){
				String productCode = orderNumLineToProductCode.get(oi.OrderNumLine__c);
				Id pbId = orderMap.get(oi.OrderId).Pricebook2Id;
				Id prodId = productIdMap.get(productCode);
				String pbeKeySet = pbId + '-' + prodId;
				
				if(!pbeKeySetToPbeId.keyset().contains(pbeKeySet)){
					PricebookEntry newPbe = new PricebookEntry(Pricebook2Id = pbId , Product2Id = prodId , IsActive = true, QAD_sourced__c = true, Duplicate__c = false, UnitPrice = 1);
					pbeToInsertList.add(newPbe);
					pbeKeySetToPbeId.put(pbeKeySet, null);
				}
				else{
					pbeKeySetMap.put(pbeKeySet, pbeKeySetToPbeId.get(pbeKeySet));
				}
			}	
		}

		Insert pbeToInsertList;

		for(PricebookEntry pbe : pbeToInsertList){
			pbeKeySetToPbeId.put(pbe.Pricebook2Id + '-' + pbe.Product2Id, pbe.Id);
		}

		for(OrderItem oi : oiInputList){
			if(orderNumLineToProductCode.get(oi.OrderNumLine__c) != null && orderMap.get(oi.OrderId) != null){
				String productCode = orderNumLineToProductCode.get(oi.OrderNumLine__c);
				Id pbId = orderMap.get(oi.OrderId).Pricebook2Id;
				Id prodId = productIdMap.get(productCode);
				String pbeKeySet = pbId + '-' + prodId;

				SYSTEM.DEBUG('PBE KEYSSET USED FOR GET [' + pbeKeySet + '] PRICEBOOK ID FOUND');
				if(oi.PricebookEntryId == null){
					oi.PricebookEntryId = pbeKeySetToPbeId.get(pbeKeySet);
				}
			}	
		}
	}


	public static void totalValueToGoal() {
		Date fromDate;
		if(Test.isRunningTest()){
			fromDate = Date.newInstance(2017, 1, 1);
		}
		else{
			fromDate = Date.Today().addDays(-90);
		}
		List<OrderItem> oiList = [SELECT TimePeriodId__c, Territory__c, Order.Account.SFDCTerritoryId__c, Goal__c FROM OrderItem WHERE Ship_Date__c <> null AND Ship_Date__c > :fromDate AND Quantity <> null AND Quantity <> 0 AND (NOT PO_Number__c LIKE '%Pending%')];
		List<Goal__c> goalList = [SELECT Id, TimePeriod__c, Territory__c FROM Goal__c];
		Map<String,Id> goalKeyMap = new Map<String, Id>();
		for(Goal__c g : goalList){
			String keyString = String.valueOf(g.TimePeriod__c) + String.valueOf(g.Territory__c);
			goalKeyMap.put(keyString, g.Id);
		}
		for(orderItem oi : oiList){
			oi.Territory__c = oi.Order.Account.SFDCTerritoryId__c;
			String keyString = String.valueOf(oi.TimePeriodId__c) + String.valueOf(oi.Territory__c);
			if(goalKeyMap.get(keyString) != null){
				oi.Goal__c = goalKeyMap.get(keyString); 
			}
		}
		GlobalTriggerSwitch.runOrderDetailTrigger = false;
		update oiList;
		GlobalTriggerSwitch.runOrderDetailTrigger = true;

	}

	public static void incrementalValueToGoal(List<OrderItem> inputOiList) {
		Set<Id> oiIdSet = new Set<Id>();
		for(OrderItem oi : inputOiList){
			oiIdSet.add(oi.Id);
		}
		List<OrderItem> oiList = [SELECT TimePeriodId__c, 
											Ship_Date__c, 	
											Territory__c, 
											Order.Account.SFDCTerritoryId__c, 
											Goal__c 
								FROM 		OrderItem 
								WHERE 		Ship_Date__c <> null and ID IN : oiIdSet 
								AND 		QAD_sourced__c = false 
								AND 		Quantity <> null 
								AND 		Quantity <> 0 
								AND 		(NOT PO_Number__c LIKE '%Pending%')];
	
		Date maxDt = System.Today();
		Date minDt = System.Today();
		for(OrderItem oi : oiList){
			
			if(maxDt < oi.Ship_Date__c){
				maxDt = oi.Ship_Date__c;
			}
			if(minDt > oi.Ship_Date__c){
				minDt = oi.Ship_Date__c;
			}
			
		}
		maxDt = maxDt.addMonths(+2);
		minDt = minDt.addMonths(-2);

		List<TimePeriods__c> tpList = [SELECT Id, Name FROM TimePeriods__c WHERE Start_Date__c >= : minDt AND End_Date__c <= : maxDt];
		Map<String, Id> tpMap = new Map<String, Id>();
		for(TimePeriods__c tp : tpList){
			tpMap.put(tp.Name, tp.Id);
		}

		for(OrderItem oi : oiList){
			if(oi.TimePeriodId__c == null && oi.Ship_Date__c != null){
				String yrSt = String.valueOf(oi.Ship_Date__c.Year());
				String moSt;
				if(oi.Ship_Date__c.Month() < 10){
					moSt = '-0' + String.valueOf(oi.Ship_Date__c.Month());
				}
				else{
					moSt = '-' + String.valueOf(oi.Ship_Date__c.Month());
				}
				String matchString = yrSt + moSt;
				oi.TimePeriodId__c = tpMap.get(matchString);
			}
		}

		List<Goal__c> goalList = [SELECT Id, TimePeriod__c, Territory__c FROM Goal__c];
		Map<String,Id> goalKeyMap = new Map<String, Id>();
		for(Goal__c g : goalList){
			String keyString = String.valueOf(g.TimePeriod__c) + String.valueOf(g.Territory__c);
			goalKeyMap.put(keyString, g.Id);
		}
		for(orderItem oi : oiList){
			oi.Territory__c = oi.Order.Account.SFDCTerritoryId__c;
			String keyString = String.valueOf(oi.TimePeriodId__c) + String.valueOf(oi.Territory__c);
			if(goalKeyMap.get(keyString) != null){
				oi.Goal__c = goalKeyMap.get(keyString); 
			}
		}
		GlobalTriggerSwitch.runOrderDetailTrigger = false;
		update oiList;
		GlobalTriggerSwitch.runOrderDetailTrigger = true;
	}

	public static void totalUpRelatedOrders(){
		List<AggregateResult> arList = [SELECT Goal__c goalId, 
												Sum(Shipped_Amount__c) amt 
										FROM 	OrderItem 
										WHERE 	Ship_Date__c <> null 
										AND 	Quantity <> null 
										AND 	Quantity <> 0 
										AND 	(NOT PO_Number__c LIKE '%Pending%')
										GROUP BY Goal__c];

		Map<Id, Double> goalRevenueAmountMap = new Map<Id, Double>();
		for(AggregateResult ar : arList){
			Double amount = Double.valueOf((ar.get('amt')));
			String goalId = String.valueOf(ar.get('goalId'));
			goalRevenueAmountMap.put(goalId, amount);
		}
		List<Goal__c> goalList = [SELECT Id, Actual_Order_Value__c FROM Goal__c WHERE Id IN : goalRevenueAmountMap.keySet()];
		for(Goal__c g : goalList){
			if(goalRevenueAmountMap.get(g.Id) != null){
				g.Actual_Order_Value__c = goalRevenueAmountMap.get(g.Id);
			}
			else{
				g.Actual_Order_Value__c = 0;
			}
		}
		update goalList;
	}



   	/*****************************************************************************************************************************************************************
   	******************************************************************************************************************************************************************
	**********      USE THIS METHOD TO SYNCH UP REVENUE TO GOAL AND TOTAL GOAL TO REVENUE    																**********
	**********      Here is the execute anomyous code to run:																								**********
	**********  																																			**********
	**********      List<OrderItem> oiList = [SELECT Id, Goal__c FROM OrderItem WHERE Ship_Date__c > YYYY-MM-DD];											**********
	**********      OrderItemTrigger_Helper.incrementalTotalUpRelatedOrders(oiList);																		**********
	******************************************************************************************************************************************************************
	*****************************************************************************************************************************************************************/

	public static void incrementalTotalUpRelatedOrders(List<OrderItem> inputOiList){
		Set<Id> goalIdSet = new Set<Id>();
		for(OrderItem oi : inputOiList){
			goalIdSet.add(oi.Goal__c);
		}
		List<AggregateResult> arList = [SELECT 	Goal__c goalId, 
												Sum(Shipped_Amount__c) amt 
										FROM 	OrderItem 
										WHERE 	Ship_Date__c <> null 
										AND 	Goal__c IN : goalIdSet 
										AND 	Quantity <> null 
										AND 	Quantity <> 0 
										AND 	(NOT PO_Number__c LIKE '%Pending%')
										GROUP BY Goal__c];

		Map<Id, Double> goalRevenueAmountMap = new Map<Id, Double>();
		for(AggregateResult ar : arList){
			Double amount = Double.valueOf((ar.get('amt')));
			String goalId = String.valueOf(ar.get('goalId'));
			goalRevenueAmountMap.put(goalId, amount);
		}
		List<Goal__c> goalList = [SELECT Id, Actual_Order_Value__c FROM Goal__c WHERE Id IN : goalRevenueAmountMap.keySet()];
		for(Goal__c g : goalList){
			if(goalRevenueAmountMap.get(g.Id) != null){
				g.Actual_Order_Value__c = goalRevenueAmountMap.get(g.Id);
			}
			else{
				g.Actual_Order_Value__c = 0;
			}
		}
		update goalList;
	}

	public static void incrementalValueToGoal2_FromOrderChange(List<Order> inputOrderList) {
		Set<Id> oIdSet = new Set<Id>();
		for(Order oi : inputOrderList){
			oIdSet.add(oi.Id);
		}
		List<OrderItem> oiList = [SELECT TimePeriodId__c, 
											Territory__c, 
											Order.Account.SFDCTerritoryId__c, 
											Goal__c 
									FROM 	OrderItem 
									WHERE 	Ship_Date__c <> null 
									AND 	OrderId IN : oIdSet
									AND 	Quantity <> null 
									AND 	Quantity <> 0 
									AND 	(NOT PO_Number__c LIKE '%Pending%')];
	
		incrementalValueToGoal(oiList);
		incrementalTotalUpRelatedOrders(oiList);

	}


}