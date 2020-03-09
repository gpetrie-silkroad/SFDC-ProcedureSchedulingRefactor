@isTest(SeeAllData=true)
private class SRM_ITF_TSR_Controller_UnitTest 
{
    @isTest
    static void TestMehod1() 
    {
        String TSRID = String.valueOf([SELECT id FROM Inventory_Transfer_Form__c where Total_Transacted_Items__c > 0 LIMIT 1].id);
        SRM_ITF_TSR_Controller TSRController = new SRM_ITF_TSR_Controller();
        Inventory_Transfer_Form__c ITFTest = TSRController.v;
        String stringTest = TSRController.fromLocation;
        List<Inventory_Transfer_Form_Transaction__c> ITFTTest = TSRController.iTFTransactions;
        TSRController.iTFID = TSRID;
        ITFTest = TSRController.v;
        stringTest = TSRController.fromLocation;
        ITFTTest = TSRController.iTFTransactions;        
    }
}