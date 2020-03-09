public without sharing class Territory_Trigger_Helper {

	public static void defineTerritoryOwnership(List<Territory__c> inputTerritory) {

		Map<Id, Id> territoryId_to_userId_Map = new Map<Id, Id>();
		Map<Id, User> userMap = new Map<id, User>([SELECT Id, UserRoleId, UserRole.ParentRoleId, isActive FROM User]);


		for(Territory__c t : inputTerritory){
			if(userMap.get(t.Area_Manager__c).isActive == true){
				t.OwnerId = userMap.get(t.Area_Manager__c).Id;
			}
			else if(usermap.get(t.Area_Director__c).isActive == true){
				t.OwnerId = usermap.get(t.Area_Director__c).Id;
			}
		}
			
	}


}