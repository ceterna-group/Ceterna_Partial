({
  doInit : function(component, event, helper) {
    var id = component.get("v.recordId");
    var urlString = "/apex/RIDBuilder?id=" + id;
    var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": urlString
    });
    urlEvent.fire();
  }
})