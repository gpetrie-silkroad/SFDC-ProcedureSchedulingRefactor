trigger EventTrigger on Event (after insert, after update, after delete, before delete) {

    if(Trigger.isBefore && GlobalTriggerSwitch.runEventTrigger){
      if(Trigger.isDelete){
          //EventTrigger_Helper.sendInviteToOutlook(Trigger.Old, 'DELETE');
          //EventTrigger_Helper.deleteRelatedProcedureEvents(Trigger.Old);
      }
      else{
        EventTrigger_Helper.setSequence(Trigger.New);
      }
    }

    if(Trigger.isAfter && GlobalTriggerSwitch.runEventTrigger){
        if(Trigger.isInsert){
            SYSTEM.DEBUG('EVENT TRIGGER AFTER INSERT STARTED');
            EventTrigger_Helper.updateRelatedProcedures(Trigger.New);
        }
        if(Trigger.isUpdate){
          //EventTrigger_Helper.sendInviteToOutlook(Trigger.New, 'UPDATE');
        }
    }
  
}