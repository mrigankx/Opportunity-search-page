({
  clickUpdate: function (component, event, helper) {
    var acc = component.get("v.account");
    var updateAcc = component.getEvent("updateAccount");
    updateAcc.setParams({ account: acc });
    updateAcc.fire();
  }
});
