({
    doInit: function(component, event, helper)
    {
        helper.getCurrentUserInfo(component);
    	helper.gettingTSCCInfo(component); //Assume recordId is TSCCReport ID
    },

    updateStatus: function(component, event, helper)
    {
    	var status = component.get("v.status");
    	if(status == 2)
    	{
    		helper.gettingTSCCItems(component);
    	}
    },

    updateUser: function(component, event, helper)
    {
        var User = component.get("v.currentUser");

        if(User.Profile.Name == 'System Administrator' || User.Profile.Name == 'SRM Customer Success Team')
        {
            component.set("v.IsAdministration", true);
            component.set("v.viewType", 1);
        }else
        {
            component.set("v.IsAdministration", false);
            component.set("v.viewType", 0);
        }       
    },


    closeWaitingPopUp: function(component, event, helper) {
        component.set("v.WaitingWindow", false);
    },

    afterRender : function(component , helper){
        this.superAfterRender();
        var appDom = component.find("containerDiv").getElement();
        
        appDom.addEventListener("touchmove", function(e){
            //cancel touch move event of main Container in Salesforce1
            e.stopPropagation();
        },false)
    }
})