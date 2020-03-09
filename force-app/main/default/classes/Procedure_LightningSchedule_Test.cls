@isTest(seeAllData=true)
public with sharing class Procedure_LightningSchedule_Test {

    @isTest static void lightningControllerTestScheduler() {

            ID profileId = [SELECT ID FROM Profile WHERE Name = 'System Administrator'][0].Id;
            
            User u = new User(ProfileId = profileId, FirstName = 'Charlie', LastName = 'Tester', alias = 'ctest', email = 'ctester@yopmail.com', userName = 'ctester@yopmail.com',
                            Field_Responsibility__c = 'Therapy Development Specialist',
                            CommunityNickName = 'ctester',  IsActive = true, 
                            QAD_Territory_Id__c = 'AM00001',
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');
            insert u;                

            Calendar calendar = [SELECT ID FROM Calendar LIMIT 1];

            Territory__c t = new Territory__c (Name = 'East', IQMS_ID__c = '31', Region__c = 'East', Area_Director__c = u.Id, Area_Manager__c = u.Id, Calendar__c = calendar.Id, QAD_AM_Id__c = 'AM00001');

            insert t;

            Id artId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Customer' LIMIT 1].Id;

            Account a = new Account(Area_Director_Id__c =   u.id,
                                                        Area_Manager_User__c    =   u.Id,
                                                        BillingCity =   'Phoenix',
                                                        BillingCountry  =   'United States',
                                                        BillingPostalCode   =   '85001',
                                                        BillingState    =   'AZ',
                                                        BillingStreet   =   '12345 Test Street',
                                                        Medicare_Provider_Id__c =   '123456',
                                                        Name    =   '* TEST * Test Account',
                                                        OwnerId =   u.id,
                                                        RecordTypeId    =   artId,
                                                        Region__c   =   'West',
                                                        SFDCTerritoryId__c  =   t.Id,
                                                        ShippingCity    =   'Phoenix',
                                                        ShippingCountry =   'United States',
                                                        ShippingPostalCode  =   '85001',
                                                        ShippingState   =   'AZ',
                                                        ShippingStreet  =   '12345 Test Street',
                                                        Therapy_Development_Specialist_User__c  =   u.Id,
                                                        Time_Zone__c    =   'America/Phoenix',
                                                        Vendor_Credential_Company__c    =   'Green Security'
                                                        );
                                                        
            insert a;                                         


            Id prtId = [SELECT ID FROM RecordType WHERE Name = 'Physician' AND SObjectType = 'Contact' LIMIT 1].Id;


            Contact c = new Contact(AccountId   =   a.Id,
                                    Email   =   'jhyde@yopmail.com',
                                    FirstName   =   'Jeckyl',
                                    //Is_TCAR_Certified__c  =   TRUE,
                                    LastName    =   '* TEST * Hyde',
                                    MiddleName  =   'M',
                                    NPI_Number__c   =   '123456789',
                                    OwnerId =   u.id,
                                    //Physician__c  =   'Jeckyl M Hyde',
                                    RecordTypeId    =   prtId,
                                    Salutation  =   'Dr.',
                                    Sent_Training_Date__c   =   Date.newInstance(2019,12,15),
                                    Specialty__c    =   'Vascular Surgeon',
                                    TCAR_Certification_Date__c  =   Date.newInstance(2019,12,15),
                                    TCAR_Certification_Hold__c  =   FALSE,
                                    TCAR_Certified_Trainer__c   =   u.Id,
                                    Test_Drive__c   =   Date.newInstance(2019,12,15)
                                    );
            Insert c;                    


            Procedure_Form__c pf = new Procedure_Form__c(Account__c =   a.Id,
                                                            AD_Present__c   =   u.Id,   
                                                            AM_Present__c   =   u.Id,
                                                            Arterial_Sheath_Placement_Wire__c   =   'Next Gen J Tip',
                                                            Case_Type__c    =   'Commercial',
                                                            
                                                            Guidewire_Manufacturer__c   =   'SRM',
                                                            MPK_Dialator__c =   'Non-Stiffened',
                                                            MPK_Size__c =   '4Fr',
                                                            
                                                            No_Pre_Case_Id__c   =   TRUE,
                                                            No_SRM_Personnel_Present__c =   FALSE,
                                                            NPS_Version__c  =   'Next Gen',
                                                            OwnerId =   u.Id,
                                                            
                                                            Physician_Primary_Operator__c   =   c.Id,
                                                            Pre_Case_Id__c  =   'SRM-',
                                                            Procedure_Completion__c =   'Scheduled',
                                                            Procedure_Date__c   =   System.Today(),
                                                            Procedure_Type__c   =   'Commercial',
                                                            Territory__c    =   t.Id
                                                           
                                                                        );
            insert pf;
            
            Procedure_LightningController.getTimeList();

            List<Event> eList = [SELECT Id FROM Event WHERE ProcedureFormId__c <> null AND RecordType.SObjectType = 'Event' AND RecordType.Name = 'Procedure' AND IsChild = False];
            Set<Id> eventIdSet = new Set<Id>();
            for(Event e : eList){
                eventIdSet.add(e.Id);
            }

            Procedure_Form__c newProcedureForm = [SELECT ID, EventIds__c, Account__c FROM Procedure_Form__c WHERE EventIds__c IN : eventIdSet LIMIT 1];
            String procedureDate = '2020-12-05';
            String timeZoneString = 'Arizona';
            String startTime = '08:15:00';
            String endTime = '09:30:00';
            String localStartTime = '07:15:00';
            String localEndTime = '08:30:00';
            String localTimeZone = 'Pacific';
            String accountId = newProcedureForm.Account__c;
            String locInformation = 'Test Location';
            String primaryAmId = u.Id;
            String primaryTdsId = u.Id;
            String secondaryTdsId = u.Id;
            String otherQualifiedSrmId = u.Id;
            String adId = u.Id;

            String primaryOpPhysicianId = c.Id;
            String otherInformation = 'Test Other Id';
            String vendorCredentailCompany = 'Green Security';

            System.runAs(u){



                
                Procedure_LightningController.createProcedureAppointment(newProcedureForm,
                                                                    procedureDate,
                                                                    timeZoneString,
                                                                    startTime,
                                                                    endTime,
                                                                    localStartTime,
                                                                    localEndTime,
                                                                    localTimeZone,
                                                                    accountId,
                                                                    locInformation,
                                                                    primaryAmId,
                                                                    primaryTdsId,

                                                                    secondaryTdsId,
                                                                    otherQualifiedSrmId,
                                                                    adId,

                                                                    primaryOpPhysicianId,
                                                                    otherInformation,
                                                                    vendorCredentailCompany
                                                                    );


                Procedure_LightningController_Edit.getCurrentTime();
                Procedure_LightningController_Edit.getTimeList();

                Event e = [SELECT Id FROM Event WHERE Sequence__c <> null LIMIT 1];

                Procedure_LightningController_Edit.getExistingSchedule(e.Id);

                Procedure_LightningController_Edit.getUserOffset();
                Procedure_LightningController_Edit.getAccount(newProcedureForm.Account__c);
                /*Procedure_LightningController_Edit.updateProcedureAppointment(newProcedureForm.Id,
                                                                                e.Id,
                                                                                procedureDate,
                                                                                timeZoneString,
                                                                                startTime,
                                                                                endTime,
                                                                                localStartTime,
                                                                                localEndTime,
                                                                                localTimeZone,
                                                                                accountId,
                                                                                locInformation,
                                                                                primaryAmId,
                                                                                primaryTdsId,
                                                                                secondaryTdsId,
                                                                                otherQualifiedSrmId,
                                                                                adId,
                                                                                primaryOpPhysicianId,
                                                                                otherInformation,
                                                                                vendorCredentailCompany,
                                                                                'UPDATE'
                                                                                );
                */

                Procedure_LightningController_Edit.updateProcedureAppointment(newProcedureForm.Id,
                                                                                e.Id,
                                                                                procedureDate,
                                                                                timeZoneString,
                                                                                startTime,
                                                                                endTime,
                                                                                localStartTime,
                                                                                localEndTime,
                                                                                localTimeZone,
                                                                                accountId,
                                                                                locInformation,
                                                                                primaryAmId,
                                                                                primaryTdsId,
                                                                                secondaryTdsId,
                                                                                otherQualifiedSrmId,
                                                                                adId,
                                                                                primaryOpPhysicianId,
                                                                                otherInformation,
                                                                                vendorCredentailCompany,
                                                                                'CREATE'
                                                                                );

                Test.startTest();

             /*   Procedure_LightningController_Edit.deleteRelatedEvent(newProcedureForm.Id,
                                                                        e.Id,
                                                                        procedureDate,
                                                                        timeZoneString,
                                                                        startTime,
                                                                        endTime,
                                                                        localStartTime,
                                                                        localEndTime,
                                                                        localTimeZone,
                                                                        accountId,
                                                                        locInformation,
                                                                        primaryAmId,
                                                                        primaryTdsId,
                                                                        secondaryTdsId,
                                                                        otherQualifiedSrmId,
                                                                        adId,
                                                                        primaryOpPhysicianId,
                                                                        otherInformation,
                                                                        vendorCredentailCompany,
                                                                        'CANCELLED');
                */

                Procedure_LightningController_Edit.getUIThemeDescription();

                Test.stopTest();

        }



    }
}