public without sharing class SellingDaysCalculator_Helper {
		
	public static void updateAll(){
		statePrevAndFutureTimePeriods();
		stateCurrerntTimePeriod();
		stateYearNumbers();
	}

	public static void stateCurrerntTimePeriod(){
		Date currentDate;
		if(Test.isRunningTest()){
			currentDate = Date.newInstance(2017,6,15);
		}
		else{
			currentDate = System.today();
		}
		
		String yrString = String.valueOf(currentDate.year());
		String moString;
		if(currentDate.month() < 10){
			moString = '-0' + String.valueOf(currentDate.month());
		}
		else{
			moString = '-' + String.valueOf(currentDate.month());
		}
		String timePeriodName = yrString + moString;

		TimePeriods__c currentTimePeriod = [SELECT Id, Today_is_Selling_Day__c, Year__c, Quarter__c FROM TimePeriods__c WHERE Name = : timePeriodName LIMIT 1];

		String tpYear = currentTimePeriod.Year__c;
		String tpQuarter = currentTimePeriod.Quarter__c;

		AggregateResult ar = [SELECT Count(Id) dayCount FROM Selling_Days__c WHERE Date__c <= :currentDate AND TimePeriod__c = : currentTimePeriod.Id AND Is_Selling_Day__c = TRUE];

		Integer todayIsSellingDayNumber = Integer.valueOf(ar.get('dayCount'));

		currentTimePeriod.Today_is_Selling_Day__c = todayIsSellingDayNumber;

		update currentTimePeriod;

		AggregateResult arQtr = [SELECT Sum(Total_Selling_Days__c) totSellingDays, Sum(Today_is_Selling_Day__c) todayIs FROM  TimePeriods__c WHERE Quarter__c = : tpQuarter];
		Integer totalSellingDaysInQuarter = Integer.valueOf(arQtr.get('totSellingDays'));
		Integer todayIsSellingDayOfQuarter = Integer.valueOf(arQtr.get('todayIs'));

		AggregateResult arYr = [SELECT Sum(Total_Selling_Days__c) totSellingDays, Sum(Today_is_Selling_Day__c) todayIs FROM  TimePeriods__c WHERE Quarter__c = : tpYear];
		Integer totalSellingDaysInYear = Integer.valueOf(arYr.get('totSellingDays'));
		Integer todayIsSellingDayOfYear = Integer.valueOf(arYr.get('todayIs'));

		TimePeriods__c currentTimePeriodUpdate = [SELECT Id, Today_is_Selling_Day_of_Quarter__c,
																Today_is_Selling_Day_of_Year__c,
																Total_Selling_Days_in_Quarter__c,
																Total_Selling_Days_in_Year__c FROM TimePeriods__c WHERE Name = : timePeriodName LIMIT 1];

		currentTimePeriodUpdate.Today_is_Selling_Day_of_Quarter__c = todayIsSellingDayOfQuarter;
		currentTimePeriodUpdate.Total_Selling_Days_in_Quarter__c = totalSellingDaysInQuarter;
		currentTimePeriodUpdate.Today_is_Selling_Day_of_Year__c = todayIsSellingDayOfYear;
		currentTimePeriodUpdate.Total_Selling_Days_in_Year__c = totalSellingDaysInYear;

		update currentTimePeriodUpdate;
	}




	public static void statePrevAndFutureTimePeriods(){
		Date currentDate;
		if(Test.isRunningTest()){
			currentDate = Date.newInstance(2017,6,15);
		}
		else{
			currentDate = System.today();
		}

		String yrString = String.valueOf(currentDate.year());
		String moString;
		if(currentDate.month() < 10){
			moString = '-0' + String.valueOf(currentDate.month());
		}
		else{
			moString = '-' + String.valueOf(currentDate.month());
		}

		String timePeriodName = yrString + moString;

		List<TimePeriods__c> yearTpList = [SELECT Id, Today_Is_Selling_Day__c, Name, Total_Selling_Days__c FROM TimePeriods__c WHERE Year__c = : yrString ORDER BY NAME ASC];
		for(TimePeriods__c tp : yearTpList){
			if(tp.Name < timePeriodName){
				tp.Today_Is_Selling_Day__c = tp.Total_Selling_Days__c;
			}
			else if(tp.Name > timePeriodName){
				tp.Today_Is_Selling_Day__c = 0;
			}
		}
		update yearTpList;
	}





	public static void stateYearNumbers() {
		Date currentDate;
		if(Test.isRunningTest()){
			currentDate = Date.newInstance(2017,6,15);
		}
		else{
			currentDate = System.today();
		}
		
		String yrString = String.valueOf(currentDate.year());

		List<TimePeriods__c> currentYearTimePeriodList = [SELECT Id, Name, 
																Today_is_Selling_Day__c,
															 	Total_Selling_Days__c,
																Today_is_Selling_Day_of_Quarter__c,
																Today_is_Selling_Day_of_Year__c,
																Total_Selling_Days_in_Quarter__c,
																Total_Selling_Days_in_Year__c,
																Quarter__c 
														FROM 	TimePeriods__c 
														WHERE 	Year__c = : yrString 
														ORDER BY	Name ASC];

		Map<String, TimePeriods__c> tpMap = new Map<String, TimePeriods__c>();
		Integer yrTotalSellingDays = 0;
		for(TimePeriods__c tp : currentYearTimePeriodList){
			tpMap.put(tp.Name, tp);
			yrTotalSellingDays = Integer.valueOf(yrTotalSellingDays + tp.Total_Selling_Days__c);
		}

		String pd01 = yrString + '-01';
		String pd02 = yrString + '-02';
		String pd03 = yrString + '-03';

		String pd04 = yrString + '-04';
		String pd05 = yrString + '-05';
		String pd06 = yrString + '-06';

		String pd07 = yrString + '-07';
		String pd08 = yrString + '-08';
		String pd09 = yrString + '-09';

		String pd10 = yrString + '-10';
		String pd11 = yrString + '-11';
		String pd12 = yrString + '-12';

		Map<String, Integer> qtrTotalSellingDays = new Map<String, Integer>();
		Map<String, Integer> qtrTodayIsSellingDay = new Map<String, Integer>();

		Map<String, Integer> yrTodayIsSellingDay = new Map<String, Integer>();

		//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		qtrTotalSellingDays.put(pd01, Integer.valueOf(tpMap.get(pd01).Total_Selling_Days__c + tpMap.get(pd02).Total_Selling_Days__c + tpMap.get(pd03).Total_Selling_Days__c));
		qtrTotalSellingDays.put(pd02, Integer.valueOf(tpMap.get(pd01).Total_Selling_Days__c + tpMap.get(pd02).Total_Selling_Days__c + tpMap.get(pd03).Total_Selling_Days__c));
		qtrTotalSellingDays.put(pd03, Integer.valueOf(tpMap.get(pd01).Total_Selling_Days__c + tpMap.get(pd02).Total_Selling_Days__c + tpMap.get(pd03).Total_Selling_Days__c));

		qtrTotalSellingDays.put(pd04, Integer.valueOf(tpMap.get(pd04).Total_Selling_Days__c + tpMap.get(pd05).Total_Selling_Days__c + tpMap.get(pd06).Total_Selling_Days__c));
		qtrTotalSellingDays.put(pd05, Integer.valueOf(tpMap.get(pd04).Total_Selling_Days__c + tpMap.get(pd05).Total_Selling_Days__c + tpMap.get(pd06).Total_Selling_Days__c));
		qtrTotalSellingDays.put(pd06, Integer.valueOf(tpMap.get(pd04).Total_Selling_Days__c + tpMap.get(pd05).Total_Selling_Days__c + tpMap.get(pd06).Total_Selling_Days__c));

		qtrTotalSellingDays.put(pd07, Integer.valueOf(tpMap.get(pd07).Total_Selling_Days__c + tpMap.get(pd08).Total_Selling_Days__c + tpMap.get(pd09).Total_Selling_Days__c));
		qtrTotalSellingDays.put(pd08, Integer.valueOf(tpMap.get(pd07).Total_Selling_Days__c + tpMap.get(pd08).Total_Selling_Days__c + tpMap.get(pd09).Total_Selling_Days__c));
		qtrTotalSellingDays.put(pd09, Integer.valueOf(tpMap.get(pd07).Total_Selling_Days__c + tpMap.get(pd08).Total_Selling_Days__c + tpMap.get(pd09).Total_Selling_Days__c));

		qtrTotalSellingDays.put(pd10, Integer.valueOf(tpMap.get(pd10).Total_Selling_Days__c + tpMap.get(pd11).Total_Selling_Days__c + tpMap.get(pd12).Total_Selling_Days__c));
		qtrTotalSellingDays.put(pd11, Integer.valueOf(tpMap.get(pd10).Total_Selling_Days__c + tpMap.get(pd11).Total_Selling_Days__c + tpMap.get(pd12).Total_Selling_Days__c));
		qtrTotalSellingDays.put(pd12, Integer.valueOf(tpMap.get(pd10).Total_Selling_Days__c + tpMap.get(pd11).Total_Selling_Days__c + tpMap.get(pd12).Total_Selling_Days__c));

		//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		qtrTodayIsSellingDay.put(pd01, Integer.valueOf(tpMap.get(pd01).Today_is_Selling_Day__c));
		qtrTodayIsSellingDay.put(pd02, Integer.valueOf(tpMap.get(pd01).Today_is_Selling_Day__c + tpMap.get(pd02).Today_is_Selling_Day__c));
		qtrTodayIsSellingDay.put(pd03, Integer.valueOf(tpMap.get(pd01).Today_is_Selling_Day__c + tpMap.get(pd02).Today_is_Selling_Day__c + tpMap.get(pd03).Today_is_Selling_Day__c));

		qtrTodayIsSellingDay.put(pd04, Integer.valueOf(tpMap.get(pd04).Today_is_Selling_Day__c));
		qtrTodayIsSellingDay.put(pd05, Integer.valueOf(tpMap.get(pd04).Today_is_Selling_Day__c + tpMap.get(pd05).Today_is_Selling_Day__c));
		qtrTodayIsSellingDay.put(pd06, Integer.valueOf(tpMap.get(pd04).Today_is_Selling_Day__c + tpMap.get(pd05).Today_is_Selling_Day__c + tpMap.get(pd06).Today_is_Selling_Day__c));

		qtrTodayIsSellingDay.put(pd07, Integer.valueOf(tpMap.get(pd07).Today_is_Selling_Day__c));
		qtrTodayIsSellingDay.put(pd08, Integer.valueOf(tpMap.get(pd07).Today_is_Selling_Day__c + tpMap.get(pd08).Today_is_Selling_Day__c));
		qtrTodayIsSellingDay.put(pd09, Integer.valueOf(tpMap.get(pd07).Today_is_Selling_Day__c + tpMap.get(pd08).Today_is_Selling_Day__c + tpMap.get(pd09).Today_is_Selling_Day__c));

		qtrTodayIsSellingDay.put(pd10, Integer.valueOf(tpMap.get(pd10).Today_is_Selling_Day__c));
		qtrTodayIsSellingDay.put(pd11, Integer.valueOf(tpMap.get(pd10).Today_is_Selling_Day__c + tpMap.get(pd11).Today_is_Selling_Day__c));
		qtrTodayIsSellingDay.put(pd12, Integer.valueOf(tpMap.get(pd10).Today_is_Selling_Day__c + tpMap.get(pd11).Today_is_Selling_Day__c + tpMap.get(pd12).Today_is_Selling_Day__c));

		//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		yrTodayIsSellingDay.put(pd01, Integer.valueOf(tpMap.get(pd01).Today_is_Selling_Day__c));
		yrTodayIsSellingDay.put(pd02, Integer.valueOf(tpMap.get(pd01).Today_is_Selling_Day__c + tpMap.get(pd02).Today_is_Selling_Day__c));
		yrTodayIsSellingDay.put(pd03, Integer.valueOf(tpMap.get(pd01).Today_is_Selling_Day__c + tpMap.get(pd02).Today_is_Selling_Day__c + tpMap.get(pd03).Today_is_Selling_Day__c));

		yrTodayIsSellingDay.put(pd04, Integer.valueOf(tpMap.get(pd01).Today_is_Selling_Day__c + tpMap.get(pd02).Today_is_Selling_Day__c + tpMap.get(pd03).Today_is_Selling_Day__c + 
													  tpMap.get(pd04).Today_is_Selling_Day__c));
		yrTodayIsSellingDay.put(pd05, Integer.valueOf(tpMap.get(pd01).Today_is_Selling_Day__c + tpMap.get(pd02).Today_is_Selling_Day__c + tpMap.get(pd03).Today_is_Selling_Day__c + 
													  tpMap.get(pd04).Today_is_Selling_Day__c + tpMap.get(pd05).Today_is_Selling_Day__c));
		yrTodayIsSellingDay.put(pd06, Integer.valueOf(tpMap.get(pd01).Today_is_Selling_Day__c + tpMap.get(pd02).Today_is_Selling_Day__c + tpMap.get(pd03).Today_is_Selling_Day__c + 
													  tpMap.get(pd04).Today_is_Selling_Day__c + tpMap.get(pd05).Today_is_Selling_Day__c + tpMap.get(pd06).Today_is_Selling_Day__c));

		yrTodayIsSellingDay.put(pd07, Integer.valueOf(tpMap.get(pd01).Today_is_Selling_Day__c + tpMap.get(pd02).Today_is_Selling_Day__c + tpMap.get(pd03).Today_is_Selling_Day__c + 
													  tpMap.get(pd04).Today_is_Selling_Day__c + tpMap.get(pd05).Today_is_Selling_Day__c + tpMap.get(pd06).Today_is_Selling_Day__c + 
													  tpMap.get(pd07).Today_is_Selling_Day__c));
		yrTodayIsSellingDay.put(pd08, Integer.valueOf(tpMap.get(pd01).Today_is_Selling_Day__c + tpMap.get(pd02).Today_is_Selling_Day__c + tpMap.get(pd03).Today_is_Selling_Day__c + 
													  tpMap.get(pd04).Today_is_Selling_Day__c + tpMap.get(pd05).Today_is_Selling_Day__c + tpMap.get(pd06).Today_is_Selling_Day__c + 
													  tpMap.get(pd07).Today_is_Selling_Day__c + tpMap.get(pd08).Today_is_Selling_Day__c));
		yrTodayIsSellingDay.put(pd09, Integer.valueOf(tpMap.get(pd01).Today_is_Selling_Day__c + tpMap.get(pd02).Today_is_Selling_Day__c + tpMap.get(pd03).Today_is_Selling_Day__c + 
													  tpMap.get(pd04).Today_is_Selling_Day__c + tpMap.get(pd05).Today_is_Selling_Day__c + tpMap.get(pd06).Today_is_Selling_Day__c + 
													  tpMap.get(pd07).Today_is_Selling_Day__c + tpMap.get(pd08).Today_is_Selling_Day__c + tpMap.get(pd09).Today_is_Selling_Day__c));

		yrTodayIsSellingDay.put(pd10, Integer.valueOf(tpMap.get(pd01).Today_is_Selling_Day__c + tpMap.get(pd02).Today_is_Selling_Day__c + tpMap.get(pd03).Today_is_Selling_Day__c + 
													  tpMap.get(pd04).Today_is_Selling_Day__c + tpMap.get(pd05).Today_is_Selling_Day__c + tpMap.get(pd06).Today_is_Selling_Day__c + 
													  tpMap.get(pd07).Today_is_Selling_Day__c + tpMap.get(pd08).Today_is_Selling_Day__c + tpMap.get(pd09).Today_is_Selling_Day__c +
													  tpMap.get(pd10).Today_is_Selling_Day__c));
		yrTodayIsSellingDay.put(pd11, Integer.valueOf(tpMap.get(pd01).Today_is_Selling_Day__c + tpMap.get(pd02).Today_is_Selling_Day__c + tpMap.get(pd03).Today_is_Selling_Day__c + 
													  tpMap.get(pd04).Today_is_Selling_Day__c + tpMap.get(pd05).Today_is_Selling_Day__c + tpMap.get(pd06).Today_is_Selling_Day__c + 
													  tpMap.get(pd07).Today_is_Selling_Day__c + tpMap.get(pd08).Today_is_Selling_Day__c + tpMap.get(pd09).Today_is_Selling_Day__c +
													  tpMap.get(pd10).Today_is_Selling_Day__c + tpMap.get(pd11).Today_is_Selling_Day__c));
		yrTodayIsSellingDay.put(pd12, Integer.valueOf(tpMap.get(pd01).Today_is_Selling_Day__c + tpMap.get(pd02).Today_is_Selling_Day__c + tpMap.get(pd03).Today_is_Selling_Day__c + 
													  tpMap.get(pd04).Today_is_Selling_Day__c + tpMap.get(pd05).Today_is_Selling_Day__c + tpMap.get(pd06).Today_is_Selling_Day__c + 
													  tpMap.get(pd07).Today_is_Selling_Day__c + tpMap.get(pd08).Today_is_Selling_Day__c + tpMap.get(pd09).Today_is_Selling_Day__c +
													  tpMap.get(pd10).Today_is_Selling_Day__c + tpMap.get(pd11).Today_is_Selling_Day__c + tpMap.get(pd12).Today_is_Selling_Day__c));

		for(TimePeriods__c tp : currentYearTimePeriodList){
			tp.Today_is_Selling_Day_of_Quarter__c = qtrTodayIsSellingDay.get(tp.Name);
			tp.Today_is_Selling_Day_of_Year__c = yrTodayIsSellingDay.get(tp.Name);
			tp.Total_Selling_Days_in_Quarter__c = qtrTotalSellingDays.get(tp.Name);
			tp.Total_Selling_Days_in_Year__c = yrTotalSellingDays;
		}

		update currentYearTimePeriodList;

	}
}