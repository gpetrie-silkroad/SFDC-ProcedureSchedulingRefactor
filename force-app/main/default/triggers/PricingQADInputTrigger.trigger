trigger PricingQADInputTrigger on PricingQADInput__c (
    before insert, 
    before update, 
    after insert, 
    after update,
    before delete,
    after delete
    ) {
 
        if(!Trigger.isDelete){
            if (Trigger.isBefore && GlobalTriggerSwitch.runPricingQADInputTrigger) {
                PricingQADInputTrigger_Helper.createPartIfNecessary(Trigger.new);
                PricingQADInputTrigger_Helper.createPricebookIfNecessary(Trigger.new);
                PricingQADInputTrigger_Helper.updatePricebookId(Trigger.new);

                PricingQADInputTrigger_Helper.pricingQADInputSetAccountAndProduct(Trigger.new);
                
                PricingQADInputTrigger_Helper.createUpdatePricebookEntry(Trigger.new);
            
            } else if (Trigger.isAfter && GlobalTriggerSwitch.runPricingQADInputTrigger) {
                PricingQADInputTrigger_Helper.connectPricebookEntryToPricingQADInput(Trigger.new);
            
            }
        }

        else if (Trigger.isDelete && Trigger.isBefore){
            PricingQADInputTrigger_Helper.deletePricingQADInput(Trigger.old);
        }   
}