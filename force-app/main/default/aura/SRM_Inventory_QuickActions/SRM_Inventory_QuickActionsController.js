({
	RepToRepClick : function(component, event, helper) 
	{		
	    var pageReference = {
					            type: 'standard__component',
					            attributes:
					            {
					                "componentName": "c__SRM_ITF_0_Top_regular"  
					            }
					        };

		var navService = component.find("navService");
		navService.navigate(pageReference);	    	
	},

	DemoClick : function(component, event, helper) 
	{		
	    var pageReference = {
					            type: 'standard__component',
					            attributes:
					            {
					                "componentName": "c__SRM_ITF_0_Top_NewInternal"  
					            },
					            state: { 
        							c__ITFType: "Demo" 
    							}
					        };

		var navService = component.find("navService");
		navService.navigate(pageReference);		
	},

	ReturnClick : function(component, event, helper) 
	{		
	    var pageReference = {
					            type: 'standard__component',
					            attributes:
					            {
					                "componentName": "c__SRM_ITF_0_Top_NewInternal"  
					            },
					            state: { 
        							c__ITFType: "ReturnREPTS"
    							}
					        };

		var navService = component.find("navService");
		navService.navigate(pageReference);		
	},
	
	TSAClick : function(component, event, helper) 
	{		
	    var pageReference = {
					            type: 'standard__component',
					            attributes:
					            {
					                "componentName": "c__SRM_TSAudit_3_RepTDSCycleCount"  
					            }
					        };

		var navService = component.find("navService");
		navService.navigate(pageReference);		
	},
})
// console.log("javascript debug: " + JSON.stringify(pageReference));