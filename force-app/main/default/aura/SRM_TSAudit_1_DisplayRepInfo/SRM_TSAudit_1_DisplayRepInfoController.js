({
	updatedSelectedfromParent: function(component, event, helper)
	{
		var index = component.get("v.index");
		var selectedList = component.get("v.selectedList");

		component.set("v.selected", selectedList[index]);
	},

	updatedSelectedList: function(component, event, helper)
	{
		var index = component.get("v.index");
		var selectedList = component.get("v.selectedList");
		var selected = component.get("v.selected");

		selectedList[index] = selected;

		component.set("v.selectedList", selectedList);
	},
})