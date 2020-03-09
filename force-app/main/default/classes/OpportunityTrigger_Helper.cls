public without sharing class OpportunityTrigger_Helper {
	
	public static void updateOpportunityWithAMandAD(List<Opportunity> inputOppList){
		Set<Id> idSet = new Set<Id>();
		for(Opportunity o : inputOppList){
			idSet.add(o.Id);
		}

		List<Opportunity> oppList = [SELECT Id, Account.Area_Manager_User__c, Account.Area_Director_Id__c, Area_Director_Id__c, Area_Manager_Id__c FROM Opportunity WHERE ID IN : idSet];

		for(Opportunity o : oppList){
			if(o.Area_Manager_Id__c == null && o.Account.Area_Manager_User__c != null){
				o.Area_Manager_Id__c = o.Account.Area_Manager_User__c;
			}
			if(o.Area_Director_Id__c == null && o.Account.Area_Manager_User__c != null){
				o.Area_Director_Id__c = o.Account.Area_Director_Id__c;
			}
		}

		GlobalTriggerSwitch.runOpportunityTrigger = false;
		update oppList;
		GlobalTriggerSwitch.runOpportunityTrigger = true;
	}

}