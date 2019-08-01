({
  runWeaver: function(component, event, helper) {
    var action = component.get("c.generateProposal");
    action.setParams({ 
      recordId : component.get("v.recordId"),
      fileType: 'PDF',
      userEmail: 'stuart@ceterna.com'
    });
    action.setCallback(this, function(response) {
      var response = response.getReturnValue();
      if (response == 'Success') {
        $A.get('e.force:refreshView').fire();
        $A.get("e.force:closeQuickAction").fire();
      } else {
        console.log(response);
        component.set('v.status', response);
      }
    });
    $A.enqueueAction(action);
  }
})