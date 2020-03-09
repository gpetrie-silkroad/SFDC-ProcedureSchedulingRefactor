public with sharing class Analytics_Controller {
	
	public static void getRevenueYtdNumbers(){
		// Build Expression for Current Period Label
		Date today = Date.Today();
		String yrStr = String.valueOf(today.year());
		String MoStr;
		if(today.Month() < 10){
			MoStr = '-0' + String.valueOf(today.month()); 
		}
		else{
			MoStr = '-' + String.valueOf(today.month());
		}
		String currentPeriodStr = yrStr + MoStr;

//		SYSTEM.DEBUG('Current Period = [' + currentPeriodStr + ']');


		// Build an Index of Time Period to Number of Territories
		List<AggregateResult> aggregateResultList = [SELECT TimePeriodID__r.Name per,
														Territory__r.Name terr,  
														SUM(TotalPrice) amt 
											FROM 		OrderItem 
											WHERE 		Ship_Date__c <> null
											AND 		Territory__r.Name <> 'Europe'
											GROUP BY  	TimePeriodID__r.Name, Territory__r.Name
											ORDER BY 	TimePeriodId__r.Name, Territory__r.Name];

		Map<String, Integer> periodToTerritoryCountMap = new Map<String, Integer>();
		Map<String, Double> periodToTotalRevenueMap = new Map<String, Double>();
		Map<String, Map<String, Double>> territoryOuterMap = new Map<String, Map<String, Double>>();
		Set<String> periodSet = new set<String>();

		// Get Revenue Per Period Maps
		for(AggregateResult ar : aggregateResultList){
			String perStr = String.valueOf(ar.get('per'));
			if(perStr != null){
				periodSet.add(perStr);
			}	
			String terrStr = String.valueOf(ar.get('terr'));
			Double sumDbl = Double.ValueOf(ar.get('amt'));

			// Calculate Total Map
			if(!periodToTerritoryCountMap.keyset().Contains(perStr)){
				periodToTerritoryCountMap.put(perStr, 1);
				periodToTotalRevenueMap.put(perStr, sumDbl);
			}
			else{
				integer i = periodToTerritoryCountMap.get(perStr) + 1;
				periodToTerritoryCountMap.put(perStr, i);
				Double j = periodToTotalRevenueMap.get(perStr) + sumDbl;
				periodToTotalRevenueMap.put(perStr, j);
			}

			// Calculate Territory Outer and Inner Maps
			if(!territoryOuterMap.keyset().contains(terrStr)){
				Map<String, Double> territoryInnerMap = new Map<String, Double>();
				territoryInnerMap.put(perStr, sumDbl);
			//	SYSTEM.DEBUG('Territory = [' + terrStr + '] Period = [' + perStr  + '] Monthly Amt = [' + sumDbl +']');
				territoryOuterMap.put(terrStr, territoryInnerMap);
			}
			else{
				Map<String, Double> territoryInnerMap = territoryOuterMap.get(terrStr);
				territoryInnerMap.put(perStr, sumDbl);
				territoryOuterMap.put(terrStr, territoryInnerMap);
			}
		}


		String tpMax;
		String tpMin;
		String oldPeriod;
		for(String s : periodSet){
			if(oldPeriod == null){
				tpMax = s;
				tpMin = s;
			}
			else{
				if(s > tpMax){ tpMax = s;}
				if(s < tpMin){ tpMin = s;}
			}
			oldPeriod = s;
		}

		List<TimePeriods__c> tpList = [SELECT Id, Name FROM TimePeriods__c WHERE Name > = : tpMin AND Name <= :tpMax ORDER BY NAME];
		Map<String, Id> tpMap = new Map<String, Id>();
		for(TimePeriods__c tp : tpList){
			tpMap.put(tp.Name, tp.Id);
		}
		periodSet.clear();
		periodSet= tpMap.keyset();

		// COUNT OF TERRITORIES
		List<AggregateResult> countOfTerritory = [SELECT Count(Id) cnt FROM Territory__c WHERE isActive__c = TRUE];
		for(AggregateResult ar : countOfTerritory){
			Integer i = Integer.valueOf(ar.get('cnt'));
			periodToTerritoryCountMap.put(currentPeriodStr, i);
		}

		Map<String, Double> newPeriodToTotalRevenueMap = new Map<String, Double>();
		for(String s : periodSet){
			if(!periodToTotalRevenueMap.keyset().contains(s)){
				newPeriodToTotalRevenueMap.put(s, 0);
			}
			else{
				newPeriodToTotalRevenueMap.put(s, periodToTotalRevenueMap.get(s));
			}
		}

		for(String s : newPeriodToTotalRevenueMap.keyset()){
//			SYSTEM.DEBUG('Period = [' + s + '] Monthly Amount = [' + newPeriodToTotalRevenueMap.get(s) + ']');
		}

		Map<String, Double> ytdRevenueMapAll = ytdCalculatorMap(newPeriodToTotalRevenueMap);

		for(String s : ytdRevenueMapAll.keyset()){
//			SYSTEM.DEBUG('Period = [' + s + '] YTD Amount = [' + ytdRevenueMapAll.get(s) + ']');
		}

		// ALL TERRITORIES
		Map<String, Double> avgTerritoryYtd = new Map<String, Double>();
		Double oldNoOfTerritories;
		for(String s : ytdRevenueMapAll.keyset()){
	//		SYSTEM.DEBUG('Territory = [ALL]' + ' Period = [' + s + '] YTD Revenue Total = [' + ytdRevenueMapAll.get(s) + ']');
			Double noOfTerritories = periodToTerritoryCountMap.get(s);
			Double avgYtdTerrAmt;
			if(noOfTerritories != 0 && noOfTerritories != null){
				avgYtdTerrAmt = ytdRevenueMapAll.get(s) / noOfTerritories;
				avgTerritoryYtd.put(s, avgYTDTerrAmt);
			}
			else{
				avgYtdTerrAmt = ytdRevenueMapAll.get(s) / OldNoOfTerritories;
				avgTerritoryYtd.put(s, avgYTDTerrAmt);
			}
			oldNoOfTerritories = noOfTerritories;
		}

		for(String territory : territoryOuterMap.keyset()){
			Map<String, Double> newTerritoryPeriodMap = new Map<String, Double>();
			Map<String, Double> territoryPeriodMap = territoryOuterMap.get(territory);
			for(String period : periodSet){
				if(!territoryPeriodMap.keyset().contains(period)){
					newTerritoryPeriodMap.put(period, 0);
				}
				else{
					newTerritoryPeriodMap.put(period, territoryPeriodMap.get(period));
				}
			}
			territoryOuterMap.put(territory, newTerritoryPeriodMap);
		}


		// YTD TERRITORY MAPS
		List<Analytics_YTD__c> aytdList = new List<Analytics_YTD__c>();
		for(String territory : territoryOuterMap.keyset()){
			Map<String, Double> territoryPeriodMap = territoryOuterMap.get(territory);
			Map<String, Double> territoryYTDMap = ytdCalculatorMap(territoryPeriodMap);

			for(String period : territoryPeriodMap.keyset()){
				Double ytdAmt = territoryYTDMap.get(period);
				Analytics_YTD__c aytd = new Analytics_YTD__c();
				aytd.Name = territory + ' [' + period + ']'; 
				aytd.As_of_Time_Period__c = tpMap.get(period);
				aytd.Avg_YTD_Revenue_Per_Territory__c  = avgTerritoryYtd.get(period);
				aytd.Territory_Name__c = territory;
	            //aytd.YTD_Procedures__c
				aytd.YTD_Revenue__c = territoryYTDMap.get(period);
		//		SYSTEM.DEBUG('Territory = [' + territory + '] Period = [' + period + '] YTD Revenue = [' + ytdAmt + ']');
				aytdList.add(aytd);
			} 
		}
		insert aytdList;

	}





	public static void getProcedureYtdNumbers(){
		// Build Expression for Current Period Label
		Date today = Date.Today();
		String yrStr = String.valueOf(today.year());
		String MoStr;
		if(today.Month() < 10){
			MoStr = '-0' + String.valueOf(today.month()); 
		}
		else{
			MoStr = '-' + String.valueOf(today.month());
		}
		String currentPeriodStr = yrStr + MoStr;

//		SYSTEM.DEBUG('Current Period = [' + currentPeriodStr + ']');


		// Build an Index of Time Period to Number of Territories
		List<AggregateResult> aggregateResultList = [SELECT TimePeriod__r.Name per,
														Territory__r.Name terr,  
														Count(Id) pdCnt
											FROM 		Procedure_Form__c 
											WHERE 		Procedure_Completion__c <> 'Scheduled'
											AND 		Territory__r.Name <> 'Europe'
											AND 		TimePeriod__c <> null
											GROUP BY  	TimePeriod__r.Name, Territory__r.Name
											ORDER BY 	TimePeriod__r.Name, Territory__r.Name];

		Map<String, Integer> periodToTerritoryCountMap = new Map<String, Integer>();
		Map<String, Double> periodToTotalProcCountMap = new Map<String, Double>();
		Map<String, Map<String, Double>> territoryOuterMap = new Map<String, Map<String, Double>>();
		Set<String> periodSet = new set<String>();

		// Get Revenue Per Period Maps
		for(AggregateResult ar : aggregateResultList){
			String perStr = String.valueOf(ar.get('per'));
			if(perStr != null){
				periodSet.add(perStr);
			}	
			String terrStr = String.valueOf(ar.get('terr'));
			Double sumCnt = Double.ValueOf(ar.get('PdCnt'));

			// Calculate Total Map
			if(!periodToTerritoryCountMap.keyset().Contains(perStr)){
				periodToTerritoryCountMap.put(perStr, 1);
				periodToTotalProcCountMap.put(perStr, sumCnt);
			}
			else{
				integer i = periodToTerritoryCountMap.get(perStr) + 1;
				periodToTerritoryCountMap.put(perStr, i);
				Double j = periodToTotalProcCountMap.get(perStr) + sumCnt;
				periodToTotalProcCountMap.put(perStr, j);
			}

			// Calculate Territory Outer and Inner Maps
			if(!territoryOuterMap.keyset().contains(terrStr)){
				Map<String, Double> territoryInnerMap = new Map<String, Double>();
				territoryInnerMap.put(perStr, sumCnt);
				SYSTEM.DEBUG('Territory = [' + terrStr + '] Period = [' + perStr  + '] Monthly Amt = [' + sumCnt +']');
				territoryOuterMap.put(terrStr, territoryInnerMap);
			}
			else{
				Map<String, Double> territoryInnerMap = territoryOuterMap.get(terrStr);
				territoryInnerMap.put(perStr, sumCnt);
				territoryOuterMap.put(terrStr, territoryInnerMap);
			}
		}


		String tpMax;
		String tpMin;
		String oldPeriod;
		for(String s : periodSet){
			if(oldPeriod == null){
				tpMax = s;
				tpMin = s;
			}
			else{
				if(s > tpMax){ tpMax = s;}
				if(s < tpMin){ tpMin = s;}
			}
			oldPeriod = s;
		}

		List<TimePeriods__c> tpList = [SELECT Id, Name FROM TimePeriods__c WHERE Name > = : tpMin AND Name <= :tpMax ORDER BY NAME];
		Map<String, Id> tpMap = new Map<String, Id>();
		for(TimePeriods__c tp : tpList){
			tpMap.put(tp.Name, tp.Id);
		}
		periodSet.clear();
		periodSet= tpMap.keyset();

		// COUNT OF TERRITORIES
		List<AggregateResult> countOfTerritory = [SELECT Count(Id) cnt FROM Territory__c WHERE isActive__c = TRUE];
		for(AggregateResult ar : countOfTerritory){
			Integer i = Integer.valueOf(ar.get('cnt'));
			periodToTerritoryCountMap.put(currentPeriodStr, i);
		}

		Map<String, Double> newPeriodToTotalProcCntMap = new Map<String, Double>();
		for(String s : periodSet){
			if(!periodToTotalProcCountMap.keyset().contains(s)){
				newPeriodToTotalProcCntMap.put(s, 0);
			}
			else{
				newPeriodToTotalProcCntMap.put(s, periodToTotalProcCountMap.get(s));
			}
		}

		for(String s : newPeriodToTotalProcCntMap.keyset()){
			SYSTEM.DEBUG('Period = [' + s + '] Monthly Amount = [' + newPeriodToTotalProcCntMap.get(s) + ']');
		}

		Map<String, Double> ytdProcCntMapAll = ytdCalculatorMap(newPeriodToTotalProcCntMap);

		for(String s : ytdProcCntMapAll.keyset()){
			SYSTEM.DEBUG('Period = [' + s + '] YTD Amount = [' + ytdProcCntMapAll.get(s) + ']');
		}

		// ALL TERRITORIES
		Map<String, Double> avgTerritoryYtd = new Map<String, Double>();
		Double oldNoOfTerritories;
		for(String s : ytdProcCntMapAll.keyset()){
	//		SYSTEM.DEBUG('Territory = [ALL]' + ' Period = [' + s + '] YTD Revenue Total = [' + ytdRevenueMapAll.get(s) + ']');
			Double noOfTerritories = periodToTerritoryCountMap.get(s);
			Double avgYtdTerrAmt;
			if(noOfTerritories != 0 && noOfTerritories != null){
				avgYtdTerrAmt = ytdProcCntMapAll.get(s) / noOfTerritories;
				avgTerritoryYtd.put(s, avgYTDTerrAmt);
			}
			else if(ytdProcCntMapAll.get(s) != null && OldNoOfTerritories != null && OldNoOfTerritories != 0) {
				avgYtdTerrAmt = ytdProcCntMapAll.get(s) / OldNoOfTerritories;
				avgTerritoryYtd.put(s, avgYTDTerrAmt);
			}
			oldNoOfTerritories = noOfTerritories;
		}

		for(String territory : territoryOuterMap.keyset()){
			Map<String, Double> newTerritoryPeriodMap = new Map<String, Double>();
			Map<String, Double> territoryPeriodMap = territoryOuterMap.get(territory);
			for(String period : periodSet){
				if(!territoryPeriodMap.keyset().contains(period)){
					newTerritoryPeriodMap.put(period, 0);
				}
				else{
					newTerritoryPeriodMap.put(period, territoryPeriodMap.get(period));
				}
			}
			territoryOuterMap.put(territory, newTerritoryPeriodMap);
		}

		List<Analytics_YTD__c> aytdExistingList = [SELECT Name, As_of_Time_Period__c, YTD_Procedures__c, Avg_YTD_Procedures_Per_Territory__c FROM Analytics_YTD__c WHERE As_of_Time_Period__r.Name >= : tpMin AND As_of_Time_Period__r.Name <= : tpMax];
		Map<String, Analytics_YTD__c> aytdExistingMap = new Map<String, Analytics_YTD__c>();
		for(Analytics_YTD__c aytd : aytdExistingList){
			aytdExistingMap.put(aytd.Name, aytd );
			SYSTEM.DEBUG('NAME PUT = [' + aytd.Name + ']');
		}

		List<Analytics_YTD__c> aytdInsertList = new List<Analytics_YTD__c>();
		for(String territory : territoryOuterMap.keyset()){
			Map<String, Double> territoryPeriodMap = territoryOuterMap.get(territory);
			Map<String, Double> territoryYTDMap = ytdCalculatorMap(territoryPeriodMap);

			for(String period : territoryPeriodMap.keyset()){
				Double ytdAmt = territoryYTDMap.get(period);
				String terrPd =  territory + ' [' + period + ']'; 
				SYSTEM.DEBUG('NAME SEARCH = [' + terrPd + ']');

				if(aytdExistingMap.get(terrPd) != null){
					Analytics_YTD__c aytd = aytdExistingMap.get(terrPd);
					aytd.Avg_YTD_Procedures_Per_Territory__c  = avgTerritoryYtd.get(period);
	            	aytd.YTD_Procedures__c = territoryYTDMap.get(period);
	            }
	            else{
	            	Analytics_YTD__c aytd = new Analytics_YTD__c();
	            	aytd.Name = territory + ' [' + period + ']'; 
					aytd.As_of_Time_Period__c = tpMap.get(period);
					aytd.Avg_YTD_Revenue_Per_Territory__c  = 0;
					aytd.Territory_Name__c = territory;
					aytd.YTD_Revenue__c = 0;
					aytd.Avg_YTD_Procedures_Per_Territory__c  = avgTerritoryYtd.get(period);
	            	aytd.YTD_Procedures__c = territoryYTDMap.get(period);
	            	aytdInsertList.add(aytd);
	            }
		//		SYSTEM.DEBUG('Territory = [' + territory + '] Period = [' + period + '] YTD Revenue = [' + ytdAmt + ']');
			} 
		}
		update aytdExistingList;
		insert aytdInsertList;

	}






	public static Map<String, Double> ytdCalculatorMap(Map<String, Double> inputMap){
		Map<String, Double> ytdOutputMap = new Map<String, Double>();
		String oldYearStr;
		Double ytdAmt;
		String oldPerStr;
		for(String s : inputMap.keyset()){
			String newPerStr = s;
			Double incrementalAmt = inputMap.get(s);
			String newYearStr = s.Left(4);
			//SYSTEM.DEBUG('Year = [' + newYearStr + ']');		
			
			//SYSTEM.DEBUG('Old Year = [' + oldYearStr + '] newYearStr = [' + newYearStr +']');
			if(oldYearStr == null || newYearStr != oldYearStr){
				ytdAmt = incrementalAmt;
				ytdOutputMap.put(s, ytdAmt);
			//	SYSTEM.DEBUG('NEW YEAR!');
			}
			else if(newYearStr == oldYearStr && (newPerStr > oldPerStr || oldPerStr == null)){
				if(ytdAmt == null){
					ytdAmt = 0;
				}
				ytdAmt = ytdAmt + incrementalAmt;
				ytdOutputMap.put(s, ytdAmt);
			//	SYSTEM.DEBUG('SAME YEAR!');
			}
		//	SYSTEM.DEBUG('Period = [' + newPerStr + '] YtdAmt = [' + ytdAmt +'] Incremental Amt = [' + incrementalAmt + ']');
			oldYearStr = newYearStr;
			oldPerStr = newPerStr;
		}
		return ytdOutputMap;
	}






	public static void deleteAytdList(){
		List<Analytics_YTD__c> aytdList = [SELECT ID FROM Analytics_YTD__c];
		delete aytdList;
	}
}