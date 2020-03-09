@isTest(seeAllData=false)
private class Procedure_LightningController_Test {
  
  @isTest static void lightningControllerTest() {
    
    GlobalTriggerSwitch.runOrderDetailTrigger= false;
     GlobalTriggerSwitch.runProcedureFormTrigger = false;

    UnitTestDataFactory.createProdcedure_Forms();

    Id testId = [SELECT Id FROM User WHERE IsActive = true LIMIT 1].Id;

    
    Procedure_LightningController.getProcedureForm();
    //Procedure_LightningController.getPhysician();
    Procedure_LightningController.getCurrentUser();
    Procedure_LightningController.getAMUsers();
    Procedure_LightningController.getCurrentUser();
    Procedure_LightningController.getAMUsers();
    Procedure_LightningController.getDisUsers();
    Procedure_LightningController.getSMQualUsers();
    Procedure_LightningController.getTDUsers();
    Procedure_LightningController.getSecondaryTDUsers(testId, null);
    Procedure_LightningController.getADUsers();
    Procedure_LightningController.getCurrentTime();

    Id acctId = [SELECT Id FROM Account LIMIT 1].Id;

    Procedure_LightningController.getSiteName(acctId);
    Procedure_LightningController.getAccount(acctId);
     
    Test.startTest();
    
    UnitTestDataFactory.createTestPhysicians();
    Id acctId1 = [SELECT Id FROM Account WHERE Name = 'TestHospital_101' LIMIT 1].Id;
    Id contID = [SELECT Id FROM Contact WHERE FirstName = 'Test' AND LastName = 'Doctor' LIMIT 1].Id;

    Procedure_LightningController.getPhysician(null, acctId1);
    Procedure_LightningController.getPhysicianRecord(contId);

    Contact c = new Contact(LastName = 'TestLast', FirstName = 'TestFirst', Primary_Specialty__c = ' Test Specialty', Email = 'test@yopmail.com', Phone = '6505551212');
    Procedure_LightningController.createNewContact(c, acctId1);


    Procedure_LightningController.getProctors(contId, acctId);
    Procedure_LightningController.getStenters(contId, acctId);
    Procedure_LightningController.getCutdown(contId, acctId);

    Procedure_Form__c procForm = new Procedure_Form__c(Name = 'Test', Account__c = acctID);
    Procedure_LightningController.saveProcedureForm(procForm);
    String testString = Procedure_LightningController.getUIThemeDescription();

    Procedure_FormTrigger_Helper.totalValueToGoal('2018');

    Procedure_FormTrigger_Helper.totalValueToGoalBatchLauncher(); 
    
    Test.stopTest();

  }




  @isTest static void lightningControllerTestNull() {
    
    GlobalTriggerSwitch.runOrderDetailTrigger= false;
     GlobalTriggerSwitch.runProcedureFormTrigger = false;

    UnitTestDataFactory.createProdcedure_Forms();

    Procedure_LightningController.getSecondaryTDUsers(null, null);


    Id acctId = [SELECT Id FROM Account LIMIT 1].Id;
    
    UnitTestDataFactory.createTestPhysicians();
    Id acctId1 = [SELECT Id FROM Account WHERE Name = 'TestHospital_101' LIMIT 1].Id;

    Procedure_LightningController.getPhysician(null, acctId1);

    Procedure_LightningController.getProctors(null, acctId);
    Procedure_LightningController.getStenters(null, acctId);
    Procedure_LightningController.getCutdown(null, acctId);
  }






  @isTest static void lightningControllerEditTest() {
    
    GlobalTriggerSwitch.runOrderDetailTrigger= false;
     GlobalTriggerSwitch.runProcedureFormTrigger = false;
     
    UnitTestDataFactory.createProdcedure_Forms();

    Id testId = [SELECT Id FROM User WHERE IsActive = true LIMIT 1].Id;
    Id testId1 = [SELECT Id FROM User WHERE IsActive = true  AND Id <> : testId LIMIT 1].Id;
  
    Procedure_LightningController_Edit.getCurrentUser();
    Procedure_LightningController_Edit.getDisUsers();
 
    Id userId = [SELECT ID FROM User LIMIT 1].Id;
    Procedure_LightningController_Edit.getAMUsers(userId);
    Procedure_LightningController_Edit.getSMQualUsers(userId);
    Procedure_LightningController_Edit.getTDSUsers(userId);
    Procedure_LightningController_Edit.getSecondaryTDUsers(testId, testId1);
    Procedure_LightningController_Edit.getADUsers(userId);


    Id acctId = [SELECT Id FROM Account LIMIT 1].Id;

    Procedure_LightningController_Edit.getPhysician(null, acctId);

    Contact c = new Contact(LastName = 'TestLast', FirstName = 'TestFirst', Primary_Specialty__c = ' Test Specialty', Email = 'test@yopmail.com', Phone = '6505551212');
    
    Procedure_LightningController_Edit.createNewContact(c, acctId);


    Test.startTest();

      Procedure_LightningController_Edit.getSiteName(acctId);
      Procedure_LightningController_Edit.getIqmsCustomerNumber(acctId);
      Procedure_LightningController_Edit.getAccountList(acctId);
      
      Procedure_Form__c procForm = new Procedure_Form__c(Name = 'Test', Account__c = acctID);
      insert procForm;
      Procedure_LightningController_Edit.getProcedureForm(procForm.Id);
      Procedure_LightningController_Edit.saveProcedureForm(procForm);

      Id contId = [SELECT Id FROM Contact LIMIT 1].Id;
      Procedure_LightningController_Edit.getPhysicianRecord(contId);
      Procedure_LightningController_Edit.getProctors(contId, acctId);
      Procedure_LightningController_Edit.getPhysPrimOpList(contId, acctId);
      Procedure_LightningController_Edit.getStenters(contId, acctId);
      Procedure_LightningController_Edit.getCutdown(contId, acctId);
      String testString = Procedure_LightningController_Edit.getUIThemeDescription();

    Test.stopTest();

  }





  @isTest static void lightningControllerEditTestnNull() {
    
    GlobalTriggerSwitch.runOrderDetailTrigger= false;
     GlobalTriggerSwitch.runProcedureFormTrigger = false;
     
    UnitTestDataFactory.createProdcedure_Forms();

    Id acctId = [SELECT Id FROM Account LIMIT 1].Id;

    Id testId = [SELECT Id FROM User WHERE IsActive = true LIMIT 1].Id;
    Id testId1 = [SELECT Id FROM User WHERE IsActive = true  AND Id <> : testId LIMIT 1].Id;
  
    Procedure_LightningController_Edit.getCurrentUser();
    Procedure_LightningController_Edit.getDisUsers();
 
    Procedure_LightningController_Edit.getAMUsers(null);
    Procedure_LightningController_Edit.getSMQualUsers(null);
    Procedure_LightningController_Edit.getTDSUsers(null);
    Procedure_LightningController_Edit.getSecondaryTDUsers(null, testId1);
    Procedure_LightningController_Edit.getSecondaryTDUsers(null, null);
    Procedure_LightningController_Edit.getADUsers(null);

    Procedure_LightningController_Edit.getPhysicianRecord(null);
    Procedure_LightningController_Edit.getProctors(null, acctId);
    Procedure_LightningController_Edit.getPhysPrimOpList(null, acctId);
    Procedure_LightningController_Edit.getStenters(null, acctId);
    Procedure_LightningController_Edit.getCutdown(null, acctId);

  }







  @isTest static void lightningControllerEditTest2() {
    GlobalTriggerSwitch.runOrderDetailTrigger= false;
      GlobalTriggerSwitch.runProcedureFormTrigger = false;
    
    UnitTestDataFactory.createProdcedure_Forms();
    Id acctId = [SELECT Id FROM Account LIMIT 1].Id;

    List<Contact> contList = Procedure_LightningController_Edit.getAddl1(null, acctId);
  }
  
}