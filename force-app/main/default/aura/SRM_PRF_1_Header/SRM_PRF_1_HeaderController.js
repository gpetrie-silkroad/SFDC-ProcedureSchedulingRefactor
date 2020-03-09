({
	doInit : function(component, event, helper) {
		//check user's device type - to customize display on screen
		var device = $A.get("$Browser.formFactor");
		if(device == 'DESKTOP' || device == 'TABLET')
			component.set('v.isDesktop','True');
		else
			component.set('v.isDesktop','False');
	},
})