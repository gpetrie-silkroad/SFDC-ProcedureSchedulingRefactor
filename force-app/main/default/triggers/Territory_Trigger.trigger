trigger Territory_Trigger on Territory__c (before insert, before update, after insert, after update, after delete) {

	if(GlobalTriggerSwitch.runTerritoryTrigger){
		if (trigger.isBefore){
			Territory_Trigger_Helper.defineTerritoryOwnership(Trigger.new);
		}	
	}	
}