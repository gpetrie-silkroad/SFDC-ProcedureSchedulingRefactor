trigger Procedure_FormTrigger on Procedure_Form__c (
    before insert, 
    before update, 
    after insert, 
    after update, 
    after delete,
    before delete, 
    after undelete) {
     

    SYSTEM.DEBUG('ENTERING PROCEDURE FORM TRIGGER');    
        if (Trigger.isBefore && GlobalTriggerSwitch.runProcedureFormTrigger) {
            if(!Trigger.isDelete){
                Procedure_FormTrigger_Helper.setNameBeforSave(Trigger.New);
                Procedure_FormTrigger_Helper.setProcedureEventParams(Trigger.New);
            }
            if(Trigger.isDelete){
                Procedure_FormTrigger_Helper.cancelRelatedEvents(Trigger.Old);
            }
         
        } 
        if(Trigger.isAfter && GlobalTriggerSwitch.runProcedureFormTrigger){
            if (!Trigger.isDelete){
                Procedure_FormTrigger_Helper.procedureFormFieldUpdates(Trigger.new); 
                Procedure_FormTrigger_Helper.incrementalUpdateProcedureFormTotals(Trigger.new);
                Procedure_FormTrigger_Helper.updatePhysicianProcedureCount(Trigger.new);
                Procedure_FormTrigger_Helper.updateContactCustomerStatus(Trigger.new);              
            }

            if(Trigger.isInsert){
                Procedure_FormTrigger_Helper.createProcedureEvent(Trigger.new);
            }
            if(Trigger.isUpdate){
                Procedure_FormTrigger_Helper.updateProcedureEvent(Trigger.oldMap, Trigger.NewMap);
            }

            else if (Trigger.isDelete){
                Procedure_FormTrigger_Helper.updatePhysicianProcedureCount(Trigger.old); 
            }   
        }  
        SYSTEM.DEBUG('EXITING PROCEDURE FORM TRIGGER');   
         
}