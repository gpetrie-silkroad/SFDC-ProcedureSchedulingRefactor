trigger AccountTrigger on Account (before insert, before update, after insert, after update) {
  
	if(GlobalTriggerSwitch.runAccountTrigger){
		if(Trigger.isBefore){
			AccountTrigger_Helper.qad_beforeAccountUpsert(Trigger.new);
		}

		if(Trigger.isAfter){

			//AccountTrigger_Helper.qad_afterAccountUpsert(Trigger.new);
			if(Trigger.isUpdate){
				AccountTrigger_Helper.qad_setAccountTeamAfterUpsert(Trigger.oldMap, Trigger.newMap, true);
			}
			else if(Trigger.isInsert){
				AccountTrigger_Helper.qad_setAccountTeamAfterUpsert(Trigger.oldMap, Trigger.newMap, false);
			}
			AccountTrigger_Helper.syncAccountContactOwners(Trigger.new);
			AccountTrigger_Helper.syncAccountOpportunityOwners(Trigger.new);
		}
	}
	

}