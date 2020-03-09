@isTest(SeeallData = false)
private class PricingQADInput_Test {
    
    @isTest static void test_method_one() {
        UnitTestDataFactory.createTestUsers();
        UnitTestDataFactory.createTestTerritories();
        UnitTestDataFactory.qad_createQadSourcedAccounts();
        UnitTestDataFactory.qad_createQadSourceAddresses();
        UnitTestDataFactory.qad_createQadSourceParts();
        UnitTestDataFactory.qad_createQadSourcedPricebooks();
        UnitTestDataFactory.qad_createQadSourcedPricebookEntries();
        UnitTestDataFactory.createPricingQADInput();

        List<PricingQADInput__c> pqiDeleteList = [SELECT id FROM PricingQADInput__c LIMIT 10];
        delete pqiDeleteList;

    }
    

    
}