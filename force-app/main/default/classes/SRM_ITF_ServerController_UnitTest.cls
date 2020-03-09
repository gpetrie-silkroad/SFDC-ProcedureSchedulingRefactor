@isTest(SeeAllData=true)
private class SRM_ITF_ServerController_UnitTest
{
    @isTest 
    static void ITFServerControllerTest1()
    {
        Inventory_Transfer_Form__c testITF = new Inventory_Transfer_Form__c();
        Inventory_Transfer_Form_Transaction__c testITFTransaction = new Inventory_Transfer_Form_Transaction__c();
        Inventory_Transfer_Form_Transaction__c addedtestITFTransaction = new Inventory_Transfer_Form_Transaction__c();    
        User testUser = [SELECT Name FROM User LIMIT 1];
        testITF.Name = 'test';
        testITF.Transfer_Date__c = Date.newInstance(2016, 12, 9);
        testITF.ITF_ID__c = 'Tester';
        Account randomAccount = [Select Id from Account LIMIT 1];
        testITF.customer_to__c = randomAccount.Id;
        testITF.to_rep_tds__c = testUser.Name;
        Id returnedITFID = SRM_ITF_ServerController.createNewITF(testITF);

        User randomUser = [Select Id from User LIMIT 1];
        testITF.srm_am__c = randomUser.Id;
        testITF.Id = null;
        testITF.ITF_ID__c = 'test 2';
        testITF.Status__c = 'ITF Draft';
        Id returnedITFID2 = SRM_ITF_ServerController.createNewITF(testITF);

        String resultIncompleteITF = SRM_ITF_ServerController.getIncompleteITF(randomAccount.Id, 'Transfer to Customer');

        testITF = SRM_ITF_ServerController.getITF(returnedITFID);

        testITF.ITF_Type__c = 'Internal Transfer (AM/TDS to AM/TDS)';
        testITF  = SRM_ITF_ServerController.updateITF(testITF);
        resultIncompleteITF = SRM_ITF_ServerController.getIncompleteITF(returnedITFID, '');

        User currentUser = SRM_ITF_ServerController.getCurrentUser();
        
        Product2 product = new Product2();
        product.ProductCode = 'SR-200-NPS';
        product.Name = 'SR-200-NPS';
        insert product;
        List<String> itemNumber = SRM_ITF_ServerController.getSoldItemNumber();

        List<Lot_Inventory__c> lotInventory = SRM_ITF_ServerController.getLotInventory('TestRepName');
        
        testITFTransaction.Inventory_Transfer_Form__c = returnedITFID;
        testITFTransaction.Inventory_Owner__c = 'Tester';
        testITFTransaction.Lot_number__c = 'TestingLot';
        testITFTransaction.Price__c = 9999;
        testITFTransaction.Quantity__c = 9;
        testITFTransaction.UOM__c = 'EA';
        testITFTransaction.Product_Number__c = 'SR-200-NPS';
        List<Inventory_Transfer_Form_Transaction__c> ITFList2 = new List<Inventory_Transfer_Form_Transaction__c>();
        ITFList2.add(testITFTransaction);
        Inventory_Transfer_Form__c testITF2 = new Inventory_Transfer_Form__c();
        testITF2 = testITF;
        testITF2.Id = null;
        ITFList2[0].ITF_Transaction_ID__c = '1234wewre';
        testITF2.Id = SRM_ITF_ServerController.upsertCompleteITF(testITF2, ITFList2 );

        addedtestITFTransaction = SRM_ITF_ServerController.addNewITFTransaction(testITFTransaction);
        SRM_ITF_ServerController.updateITFTransaction(addedtestITFTransaction);
        List<Inventory_Transfer_Form_Transaction__c> ITFList = SRM_ITF_ServerController.getITFTransactionsList(returnedITFID);
        ITFList = SRM_ITF_ServerController.updateITFTransactions(returnedITFID,'CSname','BO-6789','2018-07-05');
        addedtestITFTransaction = SRM_ITF_ServerController.deleteITFTransaction(addedtestITFTransaction);

        currentUser.Field_Responsibility__c = 'Area Manager';
        update currentUser;
        list<User> userList = SRM_ITF_ServerController.getAMUsers(1);
        userList = SRM_ITF_ServerController.getAMUsers(0);


        currentUser.Field_Responsibility__c = 'Therapy Development Specialist';
        update currentUser;
        userList = SRM_ITF_ServerController.getTDSUsers(1);
        userList = SRM_ITF_ServerController.getTDSUsers(0);

        currentUser.Field_Responsibility__c = 'Area Director';
        update currentUser;
        userList = SRM_ITF_ServerController.getOtherUsers(1);
        userList = SRM_ITF_ServerController.getOtherUsers(0);
        userList = SRM_ITF_ServerController.getCSUsers();      

        list<Account> accountList = SRM_ITF_ServerController.getAccounts();
        list<Contact> contactList = SRM_ITF_ServerController.getContactAccount(returnedITFID);
        currentUser.Field_Responsibility__c = 'Area Manager';
        update currentUser;       
        accountList = SRM_ITF_ServerController.getAccounts();        

        Id pictureID = SRM_ITF_ServerController.saveSignature('test', returnedITFID,'test2', 'TestCustomerName', 'TestCustomerTitle');

        Id pdfattachedFileID = SRM_ITF_ServerController.createPDFCopy(returnedITFID,'test','1123456');
        pdfattachedFileID = SRM_ITF_ServerController.createPDFCopy(returnedITFID,'test','');
        pdfattachedFileID = SRM_ITF_ServerController.creatingMTF(returnedITFID,'test','1123456');
        pdfattachedFileID = SRM_ITF_ServerController.creatingMTF(returnedITFID,'test','');
        pdfattachedFileID = SRM_ITF_ServerController.creatingMTF(returnedITFID,'test', pdfattachedFileID);
        pdfattachedFileID = SRM_ITF_ServerController.createPDFDetailCopy(returnedITFID,'test','');
        pdfattachedFileID = SRM_ITF_ServerController.createPDFDetailCopy(returnedITFID,'test',pdfattachedFileID);
        pdfattachedFileID = SRM_ITF_ServerController.createPDFDetailCopy(returnedITFID,'test','123456');

        returnedITFID = SRM_ITF_ServerController.createMTFPDFcopy(testITF);

        testITF.PDFID__c = pdfattachedFileID;
        update testITF;

        String emailBody = 'I am a body.<br>';
        String[] sendToAddresses = new String[]{'test@example.com', 'test1@example.com'};
        String[] bCCAddresses = new String[]{'test@example.com', 'test1@example.com'};
        String subject = 'I am a subject.';
        SRM_ITF_ServerController.sendAnEmail(sendToAddresses, bCCAddresses, subject, emailBody, testITF.Id, true, '', pdfattachedFileID);

        pdfattachedFileID = SRM_ITF_ServerController.createPDFCopy(returnedITFID,'test', pdfattachedFileID);
        testITF.PDFID__c = null;
        update testITF;
        emailBody = 'I am a body.';
        Contact testContact = [SELECT id FROM Contact Where email != null LIMIT 1];
        SRM_ITF_ServerController.sendAnEmail(sendToAddresses, bCCAddresses, subject, emailBody, testContact.Id, true, testContact.id, '');


        SRM_ITF_ServerController.deleteITForm(testITF);
    }

    @isTest 
    static void ITFServerControllerTest2()
    {
        List<PricebookEntry> pricebooks = new List<PricebookEntry>();
        list<Account> randomAccount = [Select Id from Account where Price_Book__c != null LIMIT 1];
        if(randomAccount.size()>0)
        {
            pricebooks = SRM_ITF_ServerController.getAccountPriceBook(randomAccount[0].Id);
        }
        
        randomAccount = [Select Id from Account where Price_Book__c = null LIMIT 1];
        if(randomAccount.size()>0)
        {
            pricebooks = SRM_ITF_ServerController.getAccountPriceBook(randomAccount[0].Id);
        }
        
        if(randomAccount.size()>0)
        {
            randomAccount[0].Id = null;
            pricebooks = SRM_ITF_ServerController.getAccountPriceBook(randomAccount[0].Id);
        }

        randomAccount = [Select Id from Account where IQMS_Customer_Number__c = null LIMIT 1];
        if(randomAccount.size()>0)
        {
            SRM_ITF_ServerController.isValidAccountForITF(randomAccount[0].Id);
        }        

        randomAccount = [Select Id from Account where IQMS_Customer_Number__c != null LIMIT 1];
        if(randomAccount.size()>0)
        {
            SRM_ITF_ServerController.isValidAccountForITF(randomAccount[0].Id);
        }        

        SRM_ITF_ServerController.checkPendingTrunkStockReturn();        
    }

    //Test autosendemail
    @isTest 
    static void ITFServerControllerTest3()
    {
        EmailTemplate emails = [SELECT Id, DeveloperName, FolderId, TemplateType, HtmlValue FROM EmailTemplate Where TemplateType = 'Custom' Limit 1];
        Inventory_Transfer_Form__c testITF3 = [SELECT Id FROM Inventory_Transfer_Form__c Limit 1];
        emails = SRM_ITF_ServerController.GetEmailTemplate (emails.DeveloperName, testITF3.Id);
        emails = SRM_ITF_ServerController.GetEmailTemplate ('Should not have this template name', testITF3.Id);

        EmailTemplate emails2 = [SELECT Id, DeveloperName, FolderId, TemplateType FROM EmailTemplate Limit 1];
        list<Inventory_Transfer_Form__c> listITF = [SELECT 
                                                        Id 
                                                    FROM
                                                        Inventory_Transfer_Form__c
                                                    Where
                                                        Primary_Bill_Only_Number__c != null
                                                    ORDER BY
                                                        CreatedDate ASC 
                                                    Limit 1];
        User u = [select Id from User where Id = :UserInfo.getUserId()];
        List<EmailTemplate> emailTemplate = [SELECT Id FROM EmailTemplate Where DeveloperName = 'ITF_TSReturn_Acknowledge_email_to_Submitter' Limit 1];
        EmailTemplate newEmailTemplate = new EmailTemplate();
        listITF = SRM_ITF_ServerController.ITFProcessController(listITF);
        if(emailTemplate.size()>0)
        {
            System.runAs(u) 
            {
                delete emailTemplate[0];
            }
        }else
        {
            System.runAs(u) 
            {
                newEmailTemplate.DeveloperName = 'ITF_TSReturn_Acknowledge_email_to_Submitter';
                newEmailTemplate.Subject = 'fasdfadf';
                newEmailTemplate.Body = 'dasdasd';
                newEmailTemplate.HtmlValue = 'asdasd';
                newEmailTemplate.Name = 'sdasdasd';
                newEmailTemplate.FolderId = emails2.FolderId;
                newEmailTemplate.TemplateType = emails2.TemplateType;
                insert newEmailTemplate;
            }
        }
        listITF = SRM_ITF_ServerController.ITFProcessController(listITF);

        emailTemplate = [SELECT Id FROM EmailTemplate Where DeveloperName = 'ITF_TSReturn_Request_Shipping_Label' Limit 1];
        listITF = SRM_ITF_ServerController.ITFProcessController(listITF);
        if(emailTemplate.size()>0)
        {
            System.runAs(u) 
            {
                delete emailTemplate[0];
            }
        }else
        {
            System.runAs(u)
            {
                newEmailTemplate.Id = null;
                newEmailTemplate.DeveloperName = 'ITF_TSReturn_Request_Shipping_Label';
                newEmailTemplate.Subject = 'fasdfadf';
                newEmailTemplate.Body = 'dasdasd';
                newEmailTemplate.HtmlValue = 'asdasd';
                newEmailTemplate.Name = 'sdasdasdasdasd';
                newEmailTemplate.FolderId = emails2.FolderId;
                newEmailTemplate.TemplateType = emails2.TemplateType;
                insert newEmailTemplate;
            }
        }
        listITF = SRM_ITF_ServerController.ITFProcessController(listITF);
    }
}