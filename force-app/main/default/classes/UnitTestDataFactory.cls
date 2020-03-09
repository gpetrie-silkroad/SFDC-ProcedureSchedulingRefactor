global without sharing class UnitTestDataFactory {
  
    global static void createTestUsers(){
        ID profileId = [SELECT ID FROM Profile WHERE Name = 'System Administrator'][0].Id;
        List<User> userInsertList = new List<User>();
        User u1 = new User(ProfileId = profileId, FirstName = 'Ashley', LastName = 'Tester', alias = 'atest', email = 'atester@yopmail.com', userName = 'atester@yopmail.com',
                            CommunityNickName = 'atester',  IsActive = true,
                            QAD_Territory_Id__c = 'AD00001',
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');

        User u2 = new User(ProfileId = profileId, FirstName = 'Barney', LastName = 'Tester', alias = 'btest', email = 'btester@yopmail.com', userName = 'btester@yopmail.com',
                            Field_Responsibility__c = 'Area Manager',
                            CommunityNickName = 'btester',  IsActive = true,
                            QAD_Territory_Id__c =  'AD00002',
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');

        User u3 = new User(ProfileId = profileId, FirstName = 'Charlie', LastName = 'Tester', alias = 'ctest', email = 'ctester@yopmail.com', userName = 'ctester@yopmail.com',
                            Field_Responsibility__c = 'Therapy Development Specialist',
                            CommunityNickName = 'ctester',  IsActive = true, 
                            QAD_Territory_Id__c = 'AM00001',
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');
        
        User u4 = new User(ProfileId = profileId, FirstName = 'Inactive', LastName = 'Tester', alias = 'itest', email = 'itester@yopmail.com', userName = 'itester@yopmail.com',
                            Field_Responsibility__c = 'Area Director',
                            CommunityNickName = 'itester',  IsActive =false, 
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');

         User u5 = new User(ProfileId = profileId, FirstName = 'David', LastName = 'Tester', alias = 'dtest', email = 'dtester@yopmail.com', userName = 'dtester@yopmail.com',
                            Field_Responsibility__c = 'Area Manager',
                            QAD_Territory_Id__c = 'AM00002',
                            CommunityNickName = 'dtester',  IsActive =true, 
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');

         User u6 = new User(ProfileId = profileId, FirstName = 'Ed', LastName = 'Tester', alias = 'etest', email = 'etester@yopmail.com', userName = 'etester@yopmail.com',
                            Field_Responsibility__c = 'Area Manager',
                            QAD_Territory_Id__c = 'AM00003',
                            CommunityNickName = 'etester',  IsActive =true, 
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');

          User u7 = new User(ProfileId = profileId, FirstName = 'Francis', LastName = 'Tester', alias = 'ftest', email = 'ftester@yopmail.com', userName = 'ftester@yopmail.com',
                            Field_Responsibility__c = 'Therapy Development Specialist',
                            QAD_Territory_Id__c = 'TDS0001',
                            CommunityNickName = 'ftester',  IsActive =true, 
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');


          User u8 = new User(ProfileId = profileId, FirstName = 'Gordon', LastName = 'Tester', alias = 'gtest', email = 'gtester@yopmail.com', userName = 'gtester@yopmail.com',
                            Field_Responsibility__c = 'Area Director',
                            QAD_Territory_Id__c = 'AD00003',
                            CommunityNickName = 'gtester',  IsActive =true, 
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');


          User u9 = new User(ProfileId = profileId, FirstName = 'Howard', LastName = 'Tester', alias = 'htest', email = 'htester@yopmail.com', userName = 'htester@yopmail.com',
                            Field_Responsibility__c = 'Area Manager',
                            QAD_Territory_Id__c = 'AM00004',
                            CommunityNickName = 'htester',  IsActive =true, 
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');


          User u10 = new User(ProfileId = profileId, FirstName = 'Jackie', LastName = 'Tester', alias = 'jtest', email = 'jtester@yopmail.com', userName = 'jtester@yopmail.com',
                            Field_Responsibility__c = 'Therapy Development Specialist',
                            QAD_Territory_Id__c = 'TDS0002',
                            CommunityNickName = 'jtester',  IsActive =true, 
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');
 
        userInsertList.add(u1);
        userInsertList.add(u2);
        userInsertList.add(u3);
        userInsertList.add(u4);
        userInsertList.add(u5);
        userInsertList.add(u6);
        userInsertList.add(u7);
        userInsertList.add(u8);
        userInsertList.add(u9);
        userInsertList.add(u10);
        
        Insert userInsertList;
    }




  global static void createTestInactiveUsers(){
        ID profileId = [SELECT ID FROM Profile WHERE Name = 'System Administrator'][0].Id;
        List<User> userInsertList = new List<User>();
        User u1 = new User(ProfileId = profileId, FirstName = 'Ashley', LastName = 'Tester', alias = 'atest', email = 'atester@yopmail.com', userName = 'atester@yopmail.com',
                            CommunityNickName = 'atester',  IsActive = true,
                            QAD_Territory_Id__c = 'AD00001',
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');

        User u2 = new User(ProfileId = profileId, FirstName = 'Barney', LastName = 'Tester', alias = 'btest', email = 'btester@yopmail.com', userName = 'btester@yopmail.com',
                            Field_Responsibility__c = 'Area Director',
                            CommunityNickName = 'btester',  IsActive = true,
                            QAD_Territory_Id__c =  'AD00002',
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');

        User u3 = new User(ProfileId = profileId, FirstName = 'Charlie', LastName = 'Tester', alias = 'ctest', email = 'ctester@yopmail.com', userName = 'ctester@yopmail.com',
                            Field_Responsibility__c = 'Area Manager',
                            CommunityNickName = 'ctester',  IsActive = false, 
                            QAD_Territory_Id__c = 'AM00001',
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');
        
        User u4 = new User(ProfileId = profileId, FirstName = 'Inactive', LastName = 'Tester', alias = 'itest', email = 'itester@yopmail.com', userName = 'itester@yopmail.com',
                            Field_Responsibility__c = 'Area Director',
                            CommunityNickName = 'itester',  IsActive =false, 
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');

         User u5 = new User(ProfileId = profileId, FirstName = 'David', LastName = 'Tester', alias = 'dtest', email = 'dtester@yopmail.com', userName = 'dtester@yopmail.com',
                            Field_Responsibility__c = 'Area Manager',
                            QAD_Territory_Id__c = 'AM00002',
                            CommunityNickName = 'dtester',  IsActive =false, 
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');

         User u6 = new User(ProfileId = profileId, FirstName = 'Ed', LastName = 'Tester', alias = 'etest', email = 'etester@yopmail.com', userName = 'etester@yopmail.com',
                            Field_Responsibility__c = 'Area Manager',
                            QAD_Territory_Id__c = 'AM00003',
                            CommunityNickName = 'etester',  IsActive =false, 
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');

          User u7 = new User(ProfileId = profileId, FirstName = 'Francis', LastName = 'Tester', alias = 'ftest', email = 'ftester@yopmail.com', userName = 'ftester@yopmail.com',
                            Field_Responsibility__c = 'Therapy Development Specialist',
                            QAD_Territory_Id__c = 'TDS0001',
                            CommunityNickName = 'ftester',  
                            IsActive =false, 
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');


          User u8 = new User(ProfileId = profileId, FirstName = 'Gordon', LastName = 'Tester', alias = 'gtest', email = 'gtester@yopmail.com', userName = 'gtester@yopmail.com',
                            Field_Responsibility__c = 'Area Director',
                            QAD_Territory_Id__c = 'AD00003',
                            CommunityNickName = 'gtester',  IsActive =true, 
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');


          User u9 = new User(ProfileId = profileId, FirstName = 'Howard', LastName = 'Tester', alias = 'htest', email = 'htester@yopmail.com', userName = 'htester@yopmail.com',
                            Field_Responsibility__c = 'Area Manager',
                            QAD_Territory_Id__c = 'AM00004',
                            CommunityNickName = 'htester',  IsActive =false, 
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');


          User u10 = new User(ProfileId = profileId, FirstName = 'Jackie', LastName = 'Tester', alias = 'jtest', email = 'jtester@yopmail.com', userName = 'jtester@yopmail.com',
                            Field_Responsibility__c = 'Therapy Development Specialist',
                            QAD_Territory_Id__c = 'TDS0002',
                            CommunityNickName = 'jtester',  IsActive =false, 
                            TimeZoneSidKey = 'America/Los_Angeles', 
                            LocaleSidKey =  'en_US', 
                            EmailEncodingKey = 'ISO-8859-1', 
                            LanguageLocaleKey = 'en_US');
 
        userInsertList.add(u1);
        userInsertList.add(u2);
        userInsertList.add(u3);
        userInsertList.add(u4);
        userInsertList.add(u5);
        userInsertList.add(u6);
        userInsertList.add(u7);
        userInsertList.add(u8);
        userInsertList.add(u9);
        userInsertList.add(u10);
        
        Insert userInsertList;
    }






    global static void createTestIqmsArcustos(){

    }

    global static void createTestIqmsBillTos(){
    }

    global static void createTestIqmsShipTos(){
    }

    public static void createTestContacts(){
    }
 

    public static void createTestPhysicians(){
        Id rtId = [SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND Name = 'Physician' LIMIT 1].Id;
        Id iqId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Customer' LIMIT 1].Id;
        Account testAccount = new Account(Name = 'TestHospital_101', recordTypeId = iqId);
        Insert testAccount;
        
        List<Contact> contInsertList = new List<Contact>();
        Contact newPhysician = new Contact(FirstName = 'Test', LastName = 'Doctor', AccountId = testAccount.Id, RecordTypeId = rtId);
        contInsertList.add(newPhysician);
        Contact newPhysician1 = new Contact(FirstName = 'Test1', LastName = 'Doctor1', AccountId = testAccount.Id, RecordTypeId = rtId, is_External_Proctor__c = true);
        contInsertList.add(newPhysician1);
        insert contInsertList;
    }

    public static void createTestOrdersAndHistOrders(){
    }


    public static void createInventoryReleases(){

    }



    public static void createOrdDetail(){
    }






    public static void createTestTimePeriods(){
        TimePeriods__c t01 = new TimePeriods__c(Name = '2017-01', Year__c = '2017', Month__c = '01', Quarter__c = '2017-Q1', Start_Date__c = Date.newInstance(2017,1,1), End_Date__c = Date.newInstance(2017,1,31) );
        TimePeriods__c t02 = new TimePeriods__c(Name = '2017-02', Year__c = '2017', Month__c = '02', Quarter__c = '2017-Q1', Start_Date__c = Date.newInstance(2017,2,1), End_Date__c = Date.newInstance(2017,2,28) );
        TimePeriods__c t03 = new TimePeriods__c(Name = '2017-03', Year__c = '2017', Month__c = '03', Quarter__c = '2017-Q1', Start_Date__c = Date.newInstance(2017,3,1), End_Date__c = Date.newInstance(2017,3,31) );
        TimePeriods__c t04 = new TimePeriods__c(Name = '2017-04', Year__c = '2017', Month__c = '04', Quarter__c = '2017-Q2', Start_Date__c = Date.newInstance(2017,4,1), End_Date__c = Date.newInstance(2017,4,30) );
        TimePeriods__c t05 = new TimePeriods__c(Name = '2017-05', Year__c = '2017', Month__c = '05', Quarter__c = '2017-Q2', Start_Date__c = Date.newInstance(2017,5,1), End_Date__c = Date.newInstance(2017,5,31) );
        TimePeriods__c t06 = new TimePeriods__c(Name = '2017-06', Year__c = '2017', Month__c = '06', Quarter__c = '2017-Q2', Start_Date__c = Date.newInstance(2017,6,1), End_Date__c = Date.newInstance(2017,6,30) );
        TimePeriods__c t07 = new TimePeriods__c(Name = '2017-07', Year__c = '2017', Month__c = '07', Quarter__c = '2017-Q3', Start_Date__c = Date.newInstance(2017,7,1), End_Date__c = Date.newInstance(2017,7,31) );
        TimePeriods__c t08 = new TimePeriods__c(Name = '2017-08', Year__c = '2017', Month__c = '08', Quarter__c = '2017-Q3', Start_Date__c = Date.newInstance(2017,8,1), End_Date__c = Date.newInstance(2017,8,31) );
        TimePeriods__c t09 = new TimePeriods__c(Name = '2017-09', Year__c = '2017', Month__c = '09', Quarter__c = '2017-Q3', Start_Date__c = Date.newInstance(2017,9,1), End_Date__c = Date.newInstance(2017,9,30) );
        TimePeriods__c t10 = new TimePeriods__c(Name = '2017-10', Year__c = '2017', Month__c = '10', Quarter__c = '2017-Q4', Start_Date__c = Date.newInstance(2017,10,1), End_Date__c = Date.newInstance(2017,10,31) );
        TimePeriods__c t11 = new TimePeriods__c(Name = '2017-11', Year__c = '2017', Month__c = '11', Quarter__c = '2017-Q4', Start_Date__c = Date.newInstance(2017,11,1), End_Date__c = Date.newInstance(2017,11,30) );
        TimePeriods__c t12 = new TimePeriods__c(Name = '2017-12', Year__c = '2017', Month__c = '12', Quarter__c = '2017-Q4', Start_Date__c = Date.newInstance(2017,12,1), End_Date__c = Date.newInstance(2017,12,31) );

        TimePeriods__c t101 = new TimePeriods__c(Name = '2018-01', Year__c = '2018', Month__c = '01', Quarter__c = '2018-Q1', Start_Date__c = Date.newInstance(2018,1,1), End_Date__c = Date.newInstance(2018,1,31) );
        TimePeriods__c t102 = new TimePeriods__c(Name = '2018-02', Year__c = '2018', Month__c = '02', Quarter__c = '2018-Q1', Start_Date__c = Date.newInstance(2018,2,1), End_Date__c = Date.newInstance(2018,2,28) );
        TimePeriods__c t103 = new TimePeriods__c(Name = '2018-03', Year__c = '2018', Month__c = '03', Quarter__c = '2018-Q1', Start_Date__c = Date.newInstance(2018,3,1), End_Date__c = Date.newInstance(2018,3,31) );
        TimePeriods__c t104 = new TimePeriods__c(Name = '2018-04', Year__c = '2018', Month__c = '04', Quarter__c = '2018-Q2', Start_Date__c = Date.newInstance(2018,4,1), End_Date__c = Date.newInstance(2018,4,30) );
        TimePeriods__c t105 = new TimePeriods__c(Name = '2018-05', Year__c = '2018', Month__c = '05', Quarter__c = '2018-Q2', Start_Date__c = Date.newInstance(2018,5,1), End_Date__c = Date.newInstance(2018,5,31) );
        TimePeriods__c t106 = new TimePeriods__c(Name = '2018-06', Year__c = '2018', Month__c = '06', Quarter__c = '2018-Q2', Start_Date__c = Date.newInstance(2018,6,1), End_Date__c = Date.newInstance(2018,6,30) );
        TimePeriods__c t107 = new TimePeriods__c(Name = '2018-07', Year__c = '2018', Month__c = '07', Quarter__c = '2018-Q3', Start_Date__c = Date.newInstance(2018,7,1), End_Date__c = Date.newInstance(2018,7,31) );
        TimePeriods__c t108 = new TimePeriods__c(Name = '2018-08', Year__c = '2018', Month__c = '08', Quarter__c = '2018-Q3', Start_Date__c = Date.newInstance(2018,8,1), End_Date__c = Date.newInstance(2018,8,31) );
        TimePeriods__c t109 = new TimePeriods__c(Name = '2018-09', Year__c = '2018', Month__c = '09', Quarter__c = '2018-Q3', Start_Date__c = Date.newInstance(2018,9,1), End_Date__c = Date.newInstance(2018,9,30) );
        TimePeriods__c t110 = new TimePeriods__c(Name = '2018-10', Year__c = '2018', Month__c = '10', Quarter__c = '2018-Q4', Start_Date__c = Date.newInstance(2018,10,1), End_Date__c = Date.newInstance(2018,10,31) );
        TimePeriods__c t111 = new TimePeriods__c(Name = '2018-11', Year__c = '2018', Month__c = '11', Quarter__c = '2018-Q4', Start_Date__c = Date.newInstance(2018,11,1), End_Date__c = Date.newInstance(2018,11,30) );
        TimePeriods__c t112 = new TimePeriods__c(Name = '2018-12', Year__c = '2018', Month__c = '12', Quarter__c = '2018-Q4', Start_Date__c = Date.newInstance(2018,12,1), End_Date__c = Date.newInstance(2018,12,31) );

        List<TimePeriods__c> tpList = new List<TimePeriods__c>();
        tpList.add(t01);
        tpList.add(t02);
        tpList.add(t03);
        tpList.add(t04);
        tpList.add(t05);
        tpList.add(t06);
        tpList.add(t07);
        tpList.add(t08);
        tpList.add(t09);
        tpList.add(t10);
        tpList.add(t11);
        tpList.add(t12);

        tpList.add(t101);
        tpList.add(t102);
        tpList.add(t103);
        tpList.add(t104);
        tpList.add(t105);
        tpList.add(t106);
        tpList.add(t107);
        tpList.add(t108);
        tpList.add(t109);
        tpList.add(t110);
        tpList.add(t111);
        tpList.add(t112);

        Insert tpList;

    }





    public static void createTestTerritories(){

        List<User> userList = [SELECT ID, QAD_Territory_Id__c FROM User WHERE Profile.Name = 'System Administrator' AND isActive = TRUE AND QAD_Territory_Id__c LIKE 'AM%'];

        Territory__c t01 = new Territory__c (Name = 'Upper Midwest', IQMS_ID__c = '31', Region__c = 'West', Area_Director__c = userList[0].Id, Area_Manager__c = userList[0].Id, QAD_AM_Id__c = userList[0].QAD_Territory_Id__c, IsActive__c = TRUE);
        Territory__c t02 = new Territory__c (Name = 'Pacific Northwest', IQMS_ID__c = '29', Region__c = 'West', Area_Director__c = userList[0].Id, Area_Manager__c = userList[1].Id, QAD_AM_Id__c = userList[1].QAD_Territory_Id__c, IsActive__c = TRUE);
        Territory__c t03 = new Territory__c (Name = 'Gulf-Coast', IQMS_ID__c = '26', Region__c = 'West', Area_Director__c = userList[0].Id, Area_Manager__c = userList[2].Id, QAD_AM_Id__c = userList[2].QAD_Territory_Id__c, IsActive__c = TRUE);
        Territory__c t04 = new Territory__c (Name = 'Mid-Atlantic', IQMS_ID__c = '22', Region__c = 'East', Area_Director__c = userList[3].Id, Area_Manager__c = userList[3].Id);


        List<Territory__c> tList = new List<Territory__c>();
        tList.add(t01);
        tList.add(t02);
        tList.add(t03);

        
        Insert tList;
        
    }


    public static void createTestIncompleteTerritories(){

        List<User> userList = [SELECT ID, QAD_Territory_Id__c FROM User WHERE Profile.Name = 'System Administrator' AND isActive = TRUE AND QAD_Territory_Id__c LIKE 'AD%'];
        List<User> userList1 = [SELECT ID, QAD_Territory_Id__c FROM User WHERE Profile.Name = 'System Administrator' AND isActive = False AND QAD_Territory_Id__c LIKE 'AM%'];

        Territory__c t01 = new Territory__c (Name = 'Upper Midwest', IQMS_ID__c = '31', Region__c = 'West', Area_Director__c = userList[0].Id,  Area_Manager__c = userList1[0].Id, QAD_AM_Id__c = userList1[0].QAD_Territory_Id__c);
        Territory__c t02 = new Territory__c (Name = 'Pacific Northwest', IQMS_ID__c = '29', Region__c = 'West', Area_Director__c = userList[0].Id, Area_Manager__c = userList1[0].Id, QAD_AM_Id__c = userList1[0].QAD_Territory_Id__c);
        Territory__c t03 = new Territory__c (Name = 'Gulf-Coast', IQMS_ID__c = '26', Region__c = 'West', Area_Director__c = userList[0].Id, Area_Manager__c = userList1[0].Id, QAD_AM_Id__c = userList1[0].QAD_Territory_Id__c);
        Territory__c t04 = new Territory__c (Name = 'Mid-Atlantic', IQMS_ID__c = '22', Region__c = 'East', Area_Director__c = userList[0].Id, Area_Manager__c = userList1[0].Id, QAD_AM_Id__c = userList1[0].QAD_Territory_Id__c);


        List<Territory__c> tList = new List<Territory__c>();
        tList.add(t01);
        tList.add(t02);
        tList.add(t03);

        
        Insert tList;
        
    }




    public static void createTestGoals(){
            
        List<Goal__c> goalInsertList = new List<Goal__c>(); 

        List<TimePeriods__c> tpList = [SELECT Id, Name FROM TimePeriods__c];

        List<Territory__c> terrList = [SELECT id, Name FROM Territory__c];

        for(Territory__c t : terrList){
            for(TimePeriods__c tp : tpList){
                Goal__c newGoal = new Goal__c(CaseGoal__c = 12, RevenueGoal__c = 100, Territory__c = t.Id, TimePeriod__c = tp.Id );
                goalInsertList.add(newGoal);
            }
        }
        insert goalInsertList;
    }



    public static void createProdcedure_Forms(){
        createTestUsers();
        List<User> userList = [SELECT ID FROM User];

        Calendar c = [SELECT ID FROM Calendar LIMIT 1];
		
		SYSTEM.DEBUG('CALENDAR ID = [' + c.Id + ']');

        List<Territory__c> terrList = new List<Territory__c>();
        Territory__c t01 = new Territory__c (Name = 'East', IQMS_ID__c = '31', Region__c = 'East', Area_Director__c = userList[0].Id, Area_Manager__c = userList[3].Id, Calendar__c = c.Id);
        Territory__c t02 = new Territory__c (Name = 'West', IQMS_ID__c = '32', Region__c = 'West', Area_Director__c = userList[0].Id, Area_Manager__c = userList[3].Id, Calendar__c = c.Id);
        Territory__c t03 = new Territory__c (Name = 'Midwest', IQMS_ID__c = '33', Region__c = 'West', Area_Director__c = userList[0].Id, Area_Manager__c = userList[3].Id, Calendar__c = c.Id);
        terrList.add(t01);
        terrList.add(t02);
        terrList.add(t03);
        Insert terrList;

        Id iqId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Customer' LIMIT 1].Id;
        List<Account> accountList = new List<Account>();
        Account testAccount_1 = new Account(Name = 'TestHospital_1', recordTypeId = iqId, TerritoryId__c = '31', SFDCTerritoryId__c = terrList[0].Id, IQMS_Customer_Number__c = '9999', QAD_cm_addr__c = '9999');
        Account testAccount_2 = new Account(Name = 'TestHospital_2', recordTypeId = iqId, TerritoryId__c = '32', SFDCTerritoryId__c = terrList[1].Id, IQMS_Customer_Number__c = '9997', QAD_cm_addr__c = '9997');
        Account testAccount_3 = new Account(Name = 'TestHospital_3', recordTypeId = iqId, TerritoryId__c = '33', SFDCTerritoryId__c = terrList[2].Id, IQMS_Customer_Number__c = '9996', QAD_cm_addr__c = '9996');
        Account testAccount1 = new Account(Name = 'TestHospital_4', recordTypeId = iqId, TerritoryId__c = '31', SFDCTerritoryId__c = t01.Id, IQMS_Customer_Number__c = '9998', QAD_cm_addr__c = '9998');
        accountList.add(testAccount_1);
        accountList.add(testAccount_2);
        accountList.add(testAccount_3);
        accountList.add(testAccount1);
        insert accountList;

        Id physicianRecordTypeId = [SELECT ID FROM RecordType WHERE Name = 'Physician' AND SObjectType = 'Contact' LIMIT 1].Id;

        List<Contact> contInsertList = new List<Contact>();
        Contact stentorContact01 = new Contact(NPI_Number__c = '509996', FirstName = 'FirstName', LastName = 'LastName', AccountId = testAccount_1.Id, RecordTypeId = physicianRecordTypeId, Test_Drive__c = Date.NewInstance(2018,1,1));
        Contact stentorContact02 = new Contact(NPI_Number__c = '509997', FirstName = 'FirstName', LastName = 'LastName', AccountId = testAccount_1.Id, RecordTypeId = physicianRecordTypeId, External_Proctored__c = Date.NewInstance(2018,1,1));
        Contact stentorContact03 = new Contact(NPI_Number__c = '509998', FirstName = 'FirstName', LastName = 'LastName', AccountId = testAccount_1.Id, RecordTypeId = physicianRecordTypeId, Internal_Proctored__c = Date.NewInstance(2018,1,1));
        Contact stentorContact04 = new Contact(NPI_Number__c = '509999', FirstName = 'FirstName', LastName = 'LastName', AccountId = testAccount_1.Id, RecordTypeId = physicianRecordTypeId, Sent_Training_Date__c = Date.NewInstance(2018,1,1));
        contInsertList.add(stentorContact01);
        contInsertList.add(stentorContact02);
        contInsertList.add(stentorContact03);
        contInsertList.add(stentorContact04);

        insert contInsertList;

        List<TimePeriods__c> tPList = new List<TimePeriods__c>();
        TimePeriods__c tp01 = new TimePeriods__c(Name = '2018-01', End_Date__c = Date.newInstance(2018,1,31), Start_Date__c = Date.newInstance(2018,1,1), Month__c = '01', Quarter__c = '2018-Q1', Year__c = '2018');
        TimePeriods__c tp02 = new TimePeriods__c(Name = '2018-02', End_Date__c = Date.newInstance(2018,2,28), Start_Date__c = Date.newInstance(2018,2,1), Month__c = '02', Quarter__c = '2018-Q1', Year__c = '2018');
        TimePeriods__c tp03 = new TimePeriods__c(Name = '2018-03', End_Date__c = Date.newInstance(2018,3,31), Start_Date__c = Date.newInstance(2018,3,1), Month__c = '03', Quarter__c = '2018-Q1', Year__c = '2018');
        TimePeriods__c tp04 = new TimePeriods__c(Name = '2018-04', End_Date__c = Date.newInstance(2018,4,30), Start_Date__c = Date.newInstance(2018,4,1), Month__c = '04', Quarter__c = '2018-Q2', Year__c = '2018');
        TimePeriods__c tp05 = new TimePeriods__c(Name = '2018-05', End_Date__c = Date.newInstance(2018,5,31), Start_Date__c = Date.newInstance(2018,5,1), Month__c = '05', Quarter__c = '2018-Q2', Year__c = '2018');
        TimePeriods__c tp06 = new TimePeriods__c(Name = '2018-06', End_Date__c = Date.newInstance(2018,6,30), Start_Date__c = Date.newInstance(2018,6,1), Month__c = '06', Quarter__c = '2018-Q2', Year__c = '2018');
        TimePeriods__c tp07 = new TimePeriods__c(Name = '2018-07', End_Date__c = Date.newInstance(2018,7,31), Start_Date__c = Date.newInstance(2018,7,1), Month__c = '07', Quarter__c = '2018-Q3', Year__c = '2018');
        TimePeriods__c tp08 = new TimePeriods__c(Name = '2018-08', End_Date__c = Date.newInstance(2018,8,31), Start_Date__c = Date.newInstance(2018,8,1), Month__c = '08', Quarter__c = '2018-Q3', Year__c = '2018');
        TimePeriods__c tp09 = new TimePeriods__c(Name = '2018-09', End_Date__c = Date.newInstance(2018,9,30), Start_Date__c = Date.newInstance(2018,9,1), Month__c = '09', Quarter__c = '2018-Q3', Year__c = '2018');
        TimePeriods__c tp10 = new TimePeriods__c(Name = '2018-10', End_Date__c = Date.newInstance(2018,10,31), Start_Date__c = Date.newInstance(2018,10,1), Month__c = '10', Quarter__c = '2018-Q4', Year__c = '2018');
        TimePeriods__c tp11 = new TimePeriods__c(Name = '2018-11', End_Date__c = Date.newInstance(2018,11,30), Start_Date__c = Date.newInstance(2018,11,1), Month__c = '11', Quarter__c = '2018-Q4', Year__c = '2018');
        TimePeriods__c tp12 = new TimePeriods__c(Name = '2018-12', End_Date__c = Date.newInstance(2018,12,31), Start_Date__c = Date.newInstance(2018,12,1), Month__c = '12', Quarter__c = '2018-Q4', Year__c = '2018');
        tPList.add(tp01);
        tPList.add(tp02);
        tPList.add(tp03);
        tPList.add(tp04);
        tPList.add(tp05);
        tPList.add(tp06);
        tPList.add(tp07);
        tPList.add(tp08);
        tPList.add(tp09);
        tPList.add(tp10);
        tPList.add(tp11);
        tPList.add(tp12);
        insert tPList;


        Id pricebookId = Test.getStandardPricebookId();

        SYSTEM.DEBUG('PRICEBOOK ID = [' + pricebookId + ']');

        List<Order> orderList = new List<Order>();
        Order testOrder1_01 = new Order(AccountId = accountList[0].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,1,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9999');
        Order testOrder1_02 = new Order(AccountId = accountList[0].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,2,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9999');
        Order testOrder1_03 = new Order(AccountId = accountList[0].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,3,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9999');
        Order testOrder1_04 = new Order(AccountId = accountList[0].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,4,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9999');
        Order testOrder1_05 = new Order(AccountId = accountList[0].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,5,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9999');
        Order testOrder1_06 = new Order(AccountId = accountList[0].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,6,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9999');
        Order testOrder1_07 = new Order(AccountId = accountList[0].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,7,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9999');
        Order testOrder1_08 = new Order(AccountId = accountList[0].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,8,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9999');
        Order testOrder1_09 = new Order(AccountId = accountList[0].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,9,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9999');
        Order testOrder1_10 = new Order(AccountId = accountList[0].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,10,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9999');
        Order testOrder1_11 = new Order(AccountId = accountList[0].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,11,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9999');
        Order testOrder1_12 = new Order(AccountId = accountList[0].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,12,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9999');

        Order testOrder2_01 = new Order(AccountId = accountList[1].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,1,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9997');
        Order testOrder2_02 = new Order(AccountId = accountList[1].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,2,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9997');
        Order testOrder2_03 = new Order(AccountId = accountList[1].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,3,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9997');
        Order testOrder2_04 = new Order(AccountId = accountList[1].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,4,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9997');
        Order testOrder2_05 = new Order(AccountId = accountList[1].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,5,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9997');
        Order testOrder2_06 = new Order(AccountId = accountList[1].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,6,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9997');
        Order testOrder2_07 = new Order(AccountId = accountList[1].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,7,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9997');
        Order testOrder2_08 = new Order(AccountId = accountList[1].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,8,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9997');
        Order testOrder2_09 = new Order(AccountId = accountList[1].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,9,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9997');
        Order testOrder2_10 = new Order(AccountId = accountList[1].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,10,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9997');
        Order testOrder2_11 = new Order(AccountId = accountList[1].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,11,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9997');
        Order testOrder2_12 = new Order(AccountId = accountList[1].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,12,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9997');

        Order testOrder3_01 = new Order(AccountId = accountList[2].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,1,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9996');
        Order testOrder3_02 = new Order(AccountId = accountList[2].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,2,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9996');
        Order testOrder3_03 = new Order(AccountId = accountList[2].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,3,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9996');
        Order testOrder3_04 = new Order(AccountId = accountList[2].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,4,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9996');
        Order testOrder3_05 = new Order(AccountId = accountList[2].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,5,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9996');
        Order testOrder3_06 = new Order(AccountId = accountList[2].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,6,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9996');
        Order testOrder3_07 = new Order(AccountId = accountList[2].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,7,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9996');
        Order testOrder3_08 = new Order(AccountId = accountList[2].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,8,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9996');
        Order testOrder3_09 = new Order(AccountId = accountList[2].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,9,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9996');
        Order testOrder3_10 = new Order(AccountId = accountList[2].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,10,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9996');
        Order testOrder3_11 = new Order(AccountId = accountList[2].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,11,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9996');
        Order testOrder3_12 = new Order(AccountId = accountList[2].Id, Status = 'Draft', EffectiveDate = Date.NewInstance(2018,12,1), Pricebook2Id = pricebookId, QAD_so_cust_c__c = '9996');

        orderList.add(testOrder1_01);
        orderList.add(testOrder1_02);
        orderList.add(testOrder1_03);
        orderList.add(testOrder1_04);
        orderList.add(testOrder1_05);
        orderList.add(testOrder1_06);
        orderList.add(testOrder1_07);
        orderList.add(testOrder1_08);
        orderList.add(testOrder1_09);
        orderList.add(testOrder1_10);
        orderList.add(testOrder1_11);
        orderList.add(testOrder1_12);

        orderList.add(testOrder2_01);
        orderList.add(testOrder2_02);
        orderList.add(testOrder2_03);
        orderList.add(testOrder2_04);
        orderList.add(testOrder2_05);
        orderList.add(testOrder2_06);
        orderList.add(testOrder2_07);
        orderList.add(testOrder2_08);
        orderList.add(testOrder2_09);
        orderList.add(testOrder2_10);
        orderList.add(testOrder2_11);
        orderList.add(testOrder2_12);

        orderList.add(testOrder3_01);
        orderList.add(testOrder3_02);
        orderList.add(testOrder3_03);
        orderList.add(testOrder3_04);
        orderList.add(testOrder3_05);
        orderList.add(testOrder3_06);
        orderList.add(testOrder3_07);
        orderList.add(testOrder3_08);
        orderList.add(testOrder3_09);
        orderList.add(testOrder3_10);
        orderList.add(testOrder3_11);
        orderList.add(testOrder3_12);

        insert orderList;



        system.assert(pricebookId != null);

        Product2 testProduct = new Product2(Name = 'Test Product', ProductCode = 'TP');
        insert testProduct;
 
        Id stdPricebookId = Test.getStandardPricebookId();

        PricebookEntry  pbe = [SELECT isActive, UnitPrice, PriceBook2Id, Product2Id FROM PricebookEntry WHERE Product2Id = : testProduct.Id AND Pricebook2Id = : stdPricebookId LIMIT 1];
        //insert pbe; 

        List<OrderItem> oiList = new List<OrderItem>();
        OrderItem oiToInsert1_01 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[0].Id, TimePeriodID__c = tPList[0].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[0].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,1,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert1_02 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[0].Id, TimePeriodID__c = tPList[1].Id,  IQMS_ORDER_ID__c = '1234', OrderId = orderList[1].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,2,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert1_03 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[0].Id, TimePeriodID__c = tPList[2].Id,  IQMS_ORDER_ID__c = '1234', OrderId = orderList[2].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,3,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert1_04 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[0].Id, TimePeriodID__c = tPList[3].Id,  IQMS_ORDER_ID__c = '1234', OrderId = orderList[3].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,4,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert1_05 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[0].Id, TimePeriodID__c = tPList[4].Id,  IQMS_ORDER_ID__c = '1234', OrderId = orderList[4].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,5,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert1_06 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[0].Id, TimePeriodID__c = tPList[5].Id,  IQMS_ORDER_ID__c = '1234', OrderId = orderList[5].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,6,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert1_07 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[0].Id, TimePeriodID__c = tPList[6].Id,  IQMS_ORDER_ID__c = '1234', OrderId = orderList[6].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,7,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert1_08 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[0].Id, TimePeriodID__c = tPList[7].Id,  IQMS_ORDER_ID__c = '1234', OrderId = orderList[7].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,8,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert1_09 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[0].Id, TimePeriodID__c = tPList[8].Id,  IQMS_ORDER_ID__c = '1234', OrderId = orderList[8].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,9,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert1_10 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[0].Id, TimePeriodID__c = tPList[9].Id,  IQMS_ORDER_ID__c = '1234', OrderId = orderList[9].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,10,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert1_11 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[0].Id, TimePeriodID__c = tPList[10].Id,  IQMS_ORDER_ID__c = '1234', OrderId = orderList[10].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,11,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert1_12 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[0].Id, TimePeriodID__c = tPList[11].Id,  IQMS_ORDER_ID__c = '1234', OrderId = orderList[11].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,12,2), QAD_sod_part__c = 'TP');

        OrderItem oiToInsert2_01 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[1].Id, TimePeriodID__c = tPList[0].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[12].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,1,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert2_02 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[1].Id, TimePeriodID__c = tPList[1].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[13].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,2,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert2_03 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[1].Id, TimePeriodID__c = tPList[2].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[14].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,3,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert2_04 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[1].Id, TimePeriodID__c = tPList[3].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[15].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,4,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert2_05 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[1].Id, TimePeriodID__c = tPList[4].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[16].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,5,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert2_06 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[1].Id, TimePeriodID__c = tPList[5].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[17].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,6,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert2_07 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[1].Id, TimePeriodID__c = tPList[6].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[18].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,7,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert2_08 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[1].Id, TimePeriodID__c = tPList[7].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[19].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,8,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert2_09 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[1].Id, TimePeriodID__c = tPList[8].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[20].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,9,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert2_10 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[1].Id, TimePeriodID__c = tPList[9].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[21].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,10,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert2_11 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[1].Id, TimePeriodID__c = tPList[10].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[22].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,11,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert2_12 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[1].Id, TimePeriodID__c = tPList[11].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[23].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,12,2), QAD_sod_part__c = 'TP');

        OrderItem oiToInsert3_01 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[2].Id, TimePeriodID__c = tPList[0].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[24].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,1,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert3_02 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[2].Id, TimePeriodID__c = tPList[1].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[25].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,2,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert3_03 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[2].Id, TimePeriodID__c = tPList[2].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[26].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,3,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert3_04 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[2].Id, TimePeriodID__c = tPList[3].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[27].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,4,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert3_05 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[2].Id, TimePeriodID__c = tPList[4].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[28].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,5,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert3_06 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[2].Id, TimePeriodID__c = tPList[5].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[29].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,6,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert3_07 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[2].Id, TimePeriodID__c = tPList[6].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[30].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,7,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert3_08 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[2].Id, TimePeriodID__c = tPList[7].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[31].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,8,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert3_09 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[2].Id, TimePeriodID__c = tPList[8].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[32].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,9,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert3_10 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[2].Id, TimePeriodID__c = tPList[9].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[33].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,10,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert3_11 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[2].Id, TimePeriodID__c = tPList[10].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[34].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,11,2), QAD_sod_part__c = 'TP');
        OrderItem oiToInsert3_12 = new OrderItem(Description = 'Test Desc', Territory__c = terrList[2].Id, TimePeriodID__c = tPList[11].Id, IQMS_ORDER_ID__c = '1234', OrderId = orderList[35].Id, PricebookEntryId = pbe.Id, Unit_of_Measure__c = 'EA', Quantity = 2, UnitPrice = 2.00, Ship_Date__c = Date.NewInstance(2018,12,2), QAD_sod_part__c = 'TP');

        oiList.add(oiToInsert1_01);
        oiList.add(oiToInsert1_02);
        oiList.add(oiToInsert1_03);
        oiList.add(oiToInsert1_04);
        oiList.add(oiToInsert1_05);
        oiList.add(oiToInsert1_06);
        oiList.add(oiToInsert1_07);
        oiList.add(oiToInsert1_08);
        oiList.add(oiToInsert1_09);
        oiList.add(oiToInsert1_10);
        oiList.add(oiToInsert1_11);
        oiList.add(oiToInsert1_12);

        oiList.add(oiToInsert2_01);
        oiList.add(oiToInsert2_02);
        oiList.add(oiToInsert2_03);
        oiList.add(oiToInsert2_04);
        oiList.add(oiToInsert2_05);
        oiList.add(oiToInsert2_06);
        oiList.add(oiToInsert2_07);
        oiList.add(oiToInsert2_08);
        oiList.add(oiToInsert2_09);
        oiList.add(oiToInsert2_10);
        oiList.add(oiToInsert2_11);
        oiList.add(oiToInsert2_12);

        oiList.add(oiToInsert3_01);
        oiList.add(oiToInsert3_02);
        oiList.add(oiToInsert3_03);
        oiList.add(oiToInsert3_04);
        oiList.add(oiToInsert3_05);
        oiList.add(oiToInsert3_06);
        oiList.add(oiToInsert3_07);
        oiList.add(oiToInsert3_08);
        oiList.add(oiToInsert3_09);
        oiList.add(oiToInsert3_10);
        oiList.add(oiToInsert3_11);
        oiList.add(oiToInsert3_12);

        insert oiList;

        List<Goal__c> glist = new List<Goal__c>();
        Goal__c g01 = new Goal__c(TimePeriod__c = tpList[0].Id, Territory__c = terrList[0].Id);
        Goal__c g02 = new Goal__c(TimePeriod__c = tpList[1].Id, Territory__c = terrList[0].Id);
        Goal__c g03 = new Goal__c(TimePeriod__c = tpList[2].Id, Territory__c = terrList[0].Id);
        Goal__c g04 = new Goal__c(TimePeriod__c = tpList[3].Id, Territory__c = terrList[0].Id);
        Goal__c g05 = new Goal__c(TimePeriod__c = tpList[4].Id, Territory__c = terrList[0].Id);
        Goal__c g06 = new Goal__c(TimePeriod__c = tpList[5].Id, Territory__c = terrList[0].Id);
        Goal__c g07 = new Goal__c(TimePeriod__c = tpList[6].Id, Territory__c = terrList[0].Id);
        Goal__c g08 = new Goal__c(TimePeriod__c = tpList[7].Id, Territory__c = terrList[0].Id);
        Goal__c g09 = new Goal__c(TimePeriod__c = tpList[8].Id, Territory__c = terrList[0].Id);
        Goal__c g10 = new Goal__c(TimePeriod__c = tpList[9].Id, Territory__c = terrList[0].Id);
        Goal__c g11 = new Goal__c(TimePeriod__c = tpList[10].Id, Territory__c = terrList[0].Id);
        Goal__c g12 = new Goal__c(TimePeriod__c = tpList[11].Id, Territory__c = terrList[0].Id);
        glist.add(g01);
        glist.add(g02);
        glist.add(g03);
        glist.add(g04);
        glist.add(g05);
        glist.add(g06);
        glist.add(g07);
        glist.add(g08);
        glist.add(g09);
        glist.add(g10);
        glist.add(g11);
        glist.add(g12);
        insert gList;

        
        List<Procedure_Form__c> procedureFormInsertList = new List<Procedure_Form__c>();
        Procedure_Form__c procForm01 = new Procedure_Form__c(Account__c = accountList[0].Id, TimePeriod__c = tpList[0].Id,  Territory__c = t01.Id, Procedure_Date__c = Date.newInstance(2018,1,15), Case_Type__c = 'Commercial', Procedure_Completion__c = 'Scheduled'  );
        Procedure_Form__c procForm02 = new Procedure_Form__c(Account__c = accountList[0].Id, Territory__c = t01.Id, Procedure_Date__c = Date.newInstance(2018,1,1), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm03 = new Procedure_Form__c(Account__c = accountList[0].Id, Territory__c = t01.Id , Procedure_Date__c = null, Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Aborted'  );
        
        Procedure_Form__c procForm04_01 = new Procedure_Form__c(Account__c = accountList[0].Id, Territory__c = terrList[0].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[0].Id, Procedure_Date__c = Date.newInstance(2018,1,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm04_02 = new Procedure_Form__c(Account__c = accountList[0].Id, Territory__c = terrList[0].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[1].Id, Procedure_Date__c = Date.newInstance(2018,2,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm04_03 = new Procedure_Form__c(Account__c = accountList[0].Id, Territory__c = terrList[0].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[2].Id, Procedure_Date__c = Date.newInstance(2018,3,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm04_04 = new Procedure_Form__c(Account__c = accountList[0].Id, Territory__c = terrList[0].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[3].Id, Procedure_Date__c = Date.newInstance(2018,4,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm04_05 = new Procedure_Form__c(Account__c = accountList[0].Id, Territory__c = terrList[0].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[4].Id, Procedure_Date__c = Date.newInstance(2018,5,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm04_06 = new Procedure_Form__c(Account__c = accountList[0].Id, Territory__c = terrList[0].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[5].Id, Procedure_Date__c = Date.newInstance(2018,6,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm04_07 = new Procedure_Form__c(Account__c = accountList[0].Id, Territory__c = terrList[0].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[6].Id, Procedure_Date__c = Date.newInstance(2018,7,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm04_08 = new Procedure_Form__c(Account__c = accountList[0].Id, Territory__c = terrList[0].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[7].Id, Procedure_Date__c = Date.newInstance(2018,8,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm04_09 = new Procedure_Form__c(Account__c = accountList[0].Id, Territory__c = terrList[0].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[8].Id, Procedure_Date__c = Date.newInstance(2018,9,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm04_10 = new Procedure_Form__c(Account__c = accountList[0].Id, Territory__c = terrList[0].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[9].Id, Procedure_Date__c = Date.newInstance(2018,10,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm04_11 = new Procedure_Form__c(Account__c = accountList[0].Id, Territory__c = terrList[0].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[10].Id, Procedure_Date__c = Date.newInstance(2018,11,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm04_12 = new Procedure_Form__c(Account__c = accountList[0].Id, Territory__c = terrList[0].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[11].Id, Procedure_Date__c = Date.newInstance(2018,12,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );

        Procedure_Form__c procForm05_01 = new Procedure_Form__c(Account__c = accountList[1].Id, Territory__c = terrList[1].Id, Stenter__c = stentorContact01.Id, Physician_Primary_Operator__c = stentorContact02.Id, Cutdown_Physician__c = stentorContact03.Id, Additional_Physician_1__c = stentorContact04.Id, TimePeriod__c = tPList[0].Id, Procedure_Date__c = Date.newInstance(2018,1,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm05_02 = new Procedure_Form__c(Account__c = accountList[1].Id, Territory__c = terrList[1].Id, Stenter__c = stentorContact01.Id,  Physician_Primary_Operator__c = stentorContact02.Id, Cutdown_Physician__c = stentorContact02.Id, Additional_Physician_1__c = stentorContact04.Id, TimePeriod__c = tPList[1].Id, Procedure_Date__c = Date.newInstance(2018,2,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm05_03 = new Procedure_Form__c(Account__c = accountList[1].Id, Territory__c = terrList[1].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[2].Id, Procedure_Date__c = Date.newInstance(2018,3,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm05_04 = new Procedure_Form__c(Account__c = accountList[1].Id, Territory__c = terrList[1].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[3].Id, Procedure_Date__c = Date.newInstance(2018,4,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm05_05 = new Procedure_Form__c(Account__c = accountList[1].Id, Territory__c = terrList[1].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[4].Id, Procedure_Date__c = Date.newInstance(2018,5,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm05_06 = new Procedure_Form__c(Account__c = accountList[1].Id, Territory__c = terrList[1].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[5].Id, Procedure_Date__c = Date.newInstance(2018,6,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm05_07 = new Procedure_Form__c(Account__c = accountList[1].Id, Territory__c = terrList[1].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[6].Id, Procedure_Date__c = Date.newInstance(2018,7,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm05_08 = new Procedure_Form__c(Account__c = accountList[1].Id, Territory__c = terrList[1].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[7].Id, Procedure_Date__c = Date.newInstance(2018,8,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm05_09 = new Procedure_Form__c(Account__c = accountList[1].Id, Territory__c = terrList[1].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[8].Id, Procedure_Date__c = Date.newInstance(2018,9,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm05_10 = new Procedure_Form__c(Account__c = accountList[1].Id, Territory__c = terrList[1].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[9].Id, Procedure_Date__c = Date.newInstance(2018,10,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm05_11 = new Procedure_Form__c(Account__c = accountList[1].Id, Territory__c = terrList[1].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[10].Id, Procedure_Date__c = Date.newInstance(2018,11,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm05_12 = new Procedure_Form__c(Account__c = accountList[1].Id, Territory__c = terrList[1].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[11].Id, Procedure_Date__c = Date.newInstance(2018,12,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );

        Procedure_Form__c procForm06_01 = new Procedure_Form__c(Account__c = accountList[2].Id, Territory__c = terrList[2].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[0].Id, Procedure_Date__c = Date.newInstance(2018,1,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm06_02 = new Procedure_Form__c(Account__c = accountList[2].Id, Territory__c = terrList[2].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[1].Id, Procedure_Date__c = Date.newInstance(2018,2,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm06_03 = new Procedure_Form__c(Account__c = accountList[2].Id, Territory__c = terrList[2].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[2].Id, Procedure_Date__c = Date.newInstance(2018,3,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm06_04 = new Procedure_Form__c(Account__c = accountList[2].Id, Territory__c = terrList[2].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[3].Id, Procedure_Date__c = Date.newInstance(2018,4,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm06_05 = new Procedure_Form__c(Account__c = accountList[2].Id, Territory__c = terrList[2].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[4].Id, Procedure_Date__c = Date.newInstance(2018,5,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm06_06 = new Procedure_Form__c(Account__c = accountList[2].Id, Territory__c = terrList[2].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[5].Id, Procedure_Date__c = Date.newInstance(2018,6,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm06_07 = new Procedure_Form__c(Account__c = accountList[2].Id, Territory__c = terrList[2].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[6].Id, Procedure_Date__c = Date.newInstance(2018,7,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm06_08 = new Procedure_Form__c(Account__c = accountList[2].Id, Territory__c = terrList[2].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[7].Id, Procedure_Date__c = Date.newInstance(2018,8,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm06_09 = new Procedure_Form__c(Account__c = accountList[2].Id, Territory__c = terrList[2].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[8].Id, Procedure_Date__c = Date.newInstance(2018,9,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm06_10 = new Procedure_Form__c(Account__c = accountList[2].Id, Territory__c = terrList[2].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[9].Id, Procedure_Date__c = Date.newInstance(2018,10,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm06_11 = new Procedure_Form__c(Account__c = accountList[2].Id, Territory__c = terrList[2].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[10].Id, Procedure_Date__c = Date.newInstance(2018,11,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );
        Procedure_Form__c procForm06_12 = new Procedure_Form__c(Account__c = accountList[2].Id, Territory__c = terrList[2].Id, Stenter__c = stentorContact01.Id, TimePeriod__c = tPList[11].Id, Procedure_Date__c = Date.newInstance(2018,12,10), Case_Type__c  = 'Commercial', Procedure_Completion__c = 'Completed'  );

        procedureFormInsertList.add(procForm01);
        procedureFormInsertList.add(procForm02);
        procedureFormInsertList.add(procForm03);

        procedureFormInsertList.add(procForm04_01);
        procedureFormInsertList.add(procForm04_02);
        procedureFormInsertList.add(procForm04_03);
        procedureFormInsertList.add(procForm04_04);
        procedureFormInsertList.add(procForm04_05);
        procedureFormInsertList.add(procForm04_06);
        procedureFormInsertList.add(procForm04_07);
        procedureFormInsertList.add(procForm04_08);
        procedureFormInsertList.add(procForm04_09);
        procedureFormInsertList.add(procForm04_10);
        procedureFormInsertList.add(procForm04_11);
        procedureFormInsertList.add(procForm04_12);

        procedureFormInsertList.add(procForm05_01);
        procedureFormInsertList.add(procForm05_02);
        procedureFormInsertList.add(procForm05_03);
        procedureFormInsertList.add(procForm05_04);
        procedureFormInsertList.add(procForm05_05);
        procedureFormInsertList.add(procForm05_06);
        procedureFormInsertList.add(procForm05_07);
        procedureFormInsertList.add(procForm05_08);
        procedureFormInsertList.add(procForm05_09);
        procedureFormInsertList.add(procForm05_10);
        procedureFormInsertList.add(procForm05_11);
        procedureFormInsertList.add(procForm05_12);

        procedureFormInsertList.add(procForm06_01);
        procedureFormInsertList.add(procForm06_02);
        procedureFormInsertList.add(procForm06_03);
        procedureFormInsertList.add(procForm06_04);
        procedureFormInsertList.add(procForm06_05);
        procedureFormInsertList.add(procForm06_06);
        procedureFormInsertList.add(procForm06_07);
        procedureFormInsertList.add(procForm06_08);
        procedureFormInsertList.add(procForm06_09);
        procedureFormInsertList.add(procForm06_10);
        procedureFormInsertList.add(procForm06_11);
        procedureFormInsertList.add(procForm06_12);

        insert procedureFormInsertList;
    }


    public static void createIQMS_LOCATIONS(){

    }


    public static void createIQMS_LOTDOCS(){

    }


    public static void createIQMS_ARARINVT_LOT_DOCS(){

    }




    public static void createLegacyInvoiceData(){

    }





    public static void createTerritoryZipCodeMaps(){

        Id userId = [SELECT ID FROM User LIMIT 1][0].Id;
        List<Territory_Zip_Codes__c> tzcInsertList = new List<Territory_Zip_Codes__c>();
        Territory_Zip_Codes__c tzc01 = new Territory_Zip_Codes__c(Area_DirectorId__c = userId, Area_Manager_Id__c = userId, Area_Name__c = 'Test Area 01', Area_Number__c = 'T01', City__c = 'San Mateo',
                                                            State__c = 'CA', Territory_Name__c = 'Test Territory', Territory_Number__c = 'TE01',
                                                            Name = '94002');
        Territory_Zip_Codes__c tzc02 = new Territory_Zip_Codes__c(Area_DirectorId__c = userId, Area_Manager_Id__c = userId, Area_Name__c = 'Test Area 01', Area_Number__c = 'T02', City__c = 'Santa Clara',
                                                            State__c = 'CA', Territory_Name__c = 'Test Territory', Territory_Number__c = 'TE02',
                                                            Name = '95116');

    }




    public static void createSellingDaysRecords(){

        List<Selling_Days__c> sellingDaysInsertList = new List<Selling_Days__c>();
        
        List<TimePeriods__c> timePeriodList = [SELECT Name, Id FROM TimePeriods__c ORDER BY Name ASC];
        Map<String, Id> tpMap = new Map<String, Id>();
        for(TimePeriods__c tp : timePeriodList){
            tpMap.put(tp.Name, tp.Id);    
        }

        Date startDate = Date.newInstance(2017, 1, 1);
        Integer yrDayCounter = 1;
        Integer dayOfWeekCounter = 2;

        while(yrDayCounter <= 365){
            Selling_Days__c sd = new Selling_Days__c();
            sd.Date__c = startDate;

            String dayOfWeekString;
            if(dayOfWeekCounter == 1){
                dayOfWeekString = 'Su';
                sd.Is_Selling_Day__c = false;
            }
            else if(dayOfWeekCounter == 2){
                dayOfWeekString = 'Mo';
                sd.Is_Selling_Day__c = true;
            }
            else if(dayOfWeekCounter == 3){
                dayOfWeekString = 'Tu';
                sd.Is_Selling_Day__c = true;
            }
            else if(dayOfWeekCounter == 4){
                dayOfWeekString = 'We';
                sd.Is_Selling_Day__c = true;
            }
            else if(dayOfWeekCounter == 5){
                dayOfWeekString = 'Th';
                sd.Is_Selling_Day__c = true;
            }
            else if(dayOfWeekCounter == 6){
                dayOfWeekString = 'Fr';
                sd.Is_Selling_Day__c = true;
            }
            else if(dayOfWeekCounter == 7){
                dayOfWeekString = 'Sa';
                sd.Is_Selling_Day__c = false;
                dayOfWeekCounter = 0;
            }

            String yrString = String.valueOf(startDate.year());
            String moString;
            if(startDate.month() < 10){
                moString = '-0' + String.valueOf(startDate.month());
            }
            else{
                moString = '-' + String.valueOf(startDate.month());
            }

            String timePeriodString = yrString + moString;

            sd.TimePeriod__c = tpMap.get(timePeriodString);

            sellingDaysInsertList.add(sd);

            startDate = startDate.addDays(1);
            yrDayCounter++;
            dayOfWeekCounter++;

        }

        insert sellingDaysInsertList;   
    }






    public static void qad_createQadSourcedAccounts(){
        List<Account> testAccountList = new List<Account>();
        Account acct1 = new Account (Active__c = 'Yes', Credit_Hold__c = FALSE, Credit_Limit__c = 0,    Credit_Terms__c = 'N30',    Fixed_Price__c = TRUE, BillingStreet = '1 Test Ave',                               Language__c = 'us', Name = 'QAD Test Account 1', PO_Reqired__c = TRUE,  QAD_cm_addr__c = '500002',                              QAD_cm_curr__c = 'USD', QAD_cm_daybookset__c = 'AR',    QAD_cm_domain__c = 'USD10', QAD_cm_slspsn__c = 'AD00001-AM00002',         QAD_cm_user1__c = '1061',     QAD_cm_userId__c = 'sig',       QAD_sourced__c = TRUE,  RecordTypeId = '012410000012yglAAA',    Ship_Via__c = 'FDX2Day',    Start_Date__c = Date.newInstance(2018,09,17),   VQI_Status__c = 'None');    
        Account acct2 = new Account (Active__c = 'Yes', Credit_Hold__c = FALSE, Credit_Limit__c = 0,    Credit_Terms__c = 'N30',    Fixed_Price__c = TRUE, BillingStreet = '2 Test Ave',  Freight_Terms__c = 'ADD',    Language__c = 'us', Name = 'QAD Test Account 2', PO_Reqired__c = TRUE,  QAD_cm_addr__c = '500000',                              QAD_cm_curr__c = 'USD', QAD_cm_daybookset__c = 'AR',    QAD_cm_domain__c = 'USD10', QAD_cm_slspsn__c = 'AD00002-AM00003',         QAD_cm_user1__c = '1487',     QAD_cm_userId__c = 'TSTIRRAT',  QAD_sourced__c = TRUE,  RecordTypeId = '012410000012yglAAA',    Ship_Via__c = 'FDX2Day',    Start_Date__c = Date.newInstance(2018,09,17),   VQI_Status__c = 'None');
        Account acct3 = new Account (Active__c = 'Yes', Credit_Hold__c = FALSE, Credit_Limit__c = 0,    Credit_Terms__c = 'N30',    Fixed_Price__c = TRUE, BillingStreet = '3 Test Ave',                               Language__c = 'us', Name = 'QAD Test Account 3', PO_Reqired__c = TRUE,  QAD_cm_addr__c = '500004',                              QAD_cm_curr__c = 'USD', QAD_cm_daybookset__c = 'AR',    QAD_cm_domain__c = 'USD10', QAD_cm_slspsn__c = null,                                                    QAD_cm_userId__c = 'sig',       QAD_sourced__c = TRUE,  RecordTypeId = '012410000012yglAAA',                                Start_Date__c = Date.newInstance(2018,09,17),   VQI_Status__c = 'None');    
        Account acct4 = new Account (Active__c = 'Yes', Credit_Hold__c = FALSE, Credit_Limit__c = 0,    Credit_Terms__c = 'N30',    Fixed_Price__c = TRUE, BillingStreet = '4 Test Ave',                               Language__c = 'us', Name = 'QAD Test Account 4', PO_Reqired__c = TRUE,  QAD_cm_addr__c = '500019',                              QAD_cm_curr__c = 'USD', QAD_cm_daybookset__c = 'AR',    QAD_cm_domain__c = 'USD10', QAD_cm_slspsn__c = 'AD00002',                                               QAD_cm_userId__c = 'SNGUYEN',   QAD_sourced__c = TRUE,  RecordTypeId = '012410000012yglAAA',                                Start_Date__c = Date.newInstance(2018,09,17),   VQI_Status__c = 'None');    
        Account acct5 = new Account (Active__c = 'Yes', Credit_Hold__c = FALSE, Credit_Limit__c = 0,    Credit_Terms__c = 'N45',    Fixed_Price__c = TRUE, BillingStreet = '5 Test Ave',                               Language__c = 'us', Name = 'QAD Test Account 5', PO_Reqired__c = FALSE, QAD_cm_addr__c = '501711',                              QAD_cm_curr__c = 'USD',                                 QAD_cm_domain__c = 'USD10', QAD_cm_slspsn__c = null,                                                    QAD_cm_userId__c = 'SNGUYEN',   QAD_sourced__c = TRUE,  RecordTypeId = '012410000012yglAAA',                                Start_Date__c = Date.newInstance(2018,09,17),   VQI_Status__c = 'None');    
        Account acct6 = new Account (Active__c = 'Yes', Credit_Hold__c = FALSE, Credit_Limit__c = 0,    Credit_Terms__c = 'N45',    Fixed_Price__c = TRUE, BillingStreet = '6 Test Ave',                               Language__c = 'us', Name = 'QAD Test Account 6', PO_Reqired__c = FALSE, QAD_cm_addr__c = '501711B',                             QAD_cm_curr__c = 'USD',                                 QAD_cm_domain__c = 'USD10', QAD_cm_slspsn__c = null,                                                    QAD_cm_userId__c = 'SNGUYEN',   QAD_sourced__c = TRUE,  RecordTypeId = '012410000012yglAAA',                                Start_Date__c = Date.newInstance(2018,09,17),   VQI_Status__c = 'None');    
        Account acct7 = new Account (Active__c = 'Yes', Credit_Hold__c = FALSE, Credit_Limit__c = 0,    Credit_Terms__c = 'N30',    Fixed_Price__c = TRUE, BillingStreet = '7 Test Ave',                               Language__c = 'us', Name = 'QAD Test Account 7', PO_Reqired__c = TRUE,  QAD_cm_addr__c = '500022',  QAD_cm_bill__c = '500019',  QAD_cm_curr__c = 'USD', QAD_cm_daybookset__c = 'AR',    QAD_cm_domain__c = 'USD10', QAD_cm_slspsn__c = 'AD00002-AM00003-TDS0001',  QAD_cm_user1__c = '1908',    QAD_cm_userId__c = 'SNGUYEN',   QAD_sourced__c = TRUE,  RecordTypeId = '012410000012yglAAA',    Ship_Via__c = 'FDX2Day',    Start_Date__c = Date.newInstance(2018,09,17),   VQI_Status__c = 'None');    
        Account acct8 = new Account (Active__c = 'Yes', Credit_Hold__c = FALSE, Credit_Limit__c = 0,    Credit_Terms__c = 'COD',    Fixed_Price__c = TRUE, BillingStreet = '8 Test Ave',                               Language__c = 'us', Name = 'QAD Test Account 8', PO_Reqired__c = FALSE, QAD_cm_addr__c = '500014S1',                            QAD_cm_curr__c = 'USD', QAD_cm_daybookset__c = 'AR',    QAD_cm_domain__c = 'USD10', QAD_cm_slspsn__c = null,                                                    QAD_cm_userId__c = 'sig',       QAD_sourced__c = TRUE,  RecordTypeId = '012410000012yglAAA',                                Start_Date__c = Date.newInstance(2018,09,17),   VQI_Status__c = 'None');    
        Account acct9 = new Account (Active__c = 'Yes', Credit_Hold__c = FALSE, Credit_Limit__c = 0,    Credit_Terms__c = 'N30',    Fixed_Price__c = TRUE, BillingStreet = '9 Test Ave',                               Language__c = 'us', Name = 'QAD Test Account 9', PO_Reqired__c = TRUE,  QAD_cm_addr__c = '500014',                              QAD_cm_curr__c = 'USD', QAD_cm_daybookset__c = 'AR',    QAD_cm_domain__c = 'USD10', QAD_cm_slspsn__c = null,                                                    QAD_cm_userId__c = 'sig',       QAD_sourced__c = TRUE,  RecordTypeId = '012410000012yglAAA',                                Start_Date__c = Date.newInstance(2018,09,17),   VQI_Status__c = 'None');    



        testAccountList.add(acct1);
        testAccountList.add(acct2);
        testAccountList.add(acct3);
        testAccountList.add(acct4);
        testAccountList.add(acct5);
        testAccountList.add(acct6);
        testAccountList.add(acct7);
        testAccountList.add(acct8);
        testAccountList.add(acct9);

        insert testAccountList;
    }





    public static void qad_createQadSourceAddresses(){
        List<Account> qadAccountList = [SELECT Id FROM Account WHERE QAD_sourced__c = true];
        List<Account_Address__c> testAccountAddressList = new List<Account_Address__c>();
        Account_Address__c addr1 = new Account_Address__c (Account__c = qadAccountList[0].Id, Address_Type__c = 'Ship-To',                              City__c = 'Warrendale', Contact_Name__c = 'UPMC HAMOT',                     Country__c = 'United States',                                       Name = 'QAD Test Address 1',                                Postal_Code__c = '15086',   QAD_ad_address_id__c = '159855',    QAD_ad_addr__c = '500025',      QAD_ad_bus_relation__c = '500022',  QAD_ad_ctry__c = 'US',  QAD_ad_date__c =  Date.newInstance(2018,09,17), QAD_ad_domain__c = 'USD10', QAD_ad_format__c = '0', QAD_ad_lang__c = 'us',  QAD_ad_mod_date__c =  Date.newInstance(2018,09,17), QAD_ad_ref__c = '500022',   QAD_ad_userid__c = 'HGROSU',    QAD_sourced__c = TRUE,  State_Province__c = 'PA',   Street_Address__c = '405 Keystone Dr UPMC Consolidated Service Center Receiving Dock');
        Account_Address__c addr2 = new Account_Address__c (Account__c = qadAccountList[0].Id, Address_Type__c = 'Bill-To', ATTN__c = 'Barb Fournier',   City__c = 'Portland',   Contact_Name__c = 'Maine Medical Center',           Country__c = 'United States',   Email__c = 'test@test.com',         Name = 'QAD Test Address 2',    Phone__c = '207-661-7378',  Postal_Code__c = '4102',    QAD_ad_address_id__c = '156370',    QAD_ad_addr__c = '500000',      QAD_ad_bus_relation__c = '500000',  QAD_ad_ctry__c = 'US',  QAD_ad_date__c =  Date.newInstance(2018,09,17), QAD_ad_domain__c = 'USD10', QAD_ad_format__c = '0', QAD_ad_lang__c = 'us',  QAD_ad_mod_date__c =  Date.newInstance(2018,09,17),                             QAD_ad_userid__c = 'TSTIRRAT',  QAD_sourced__c = TRUE,  State_Province__c = 'ME',   Street_Address__c = '22 Bramhall St');
        Account_Address__c addr3 = new Account_Address__c (Account__c = qadAccountList[1].Id, Address_Type__c = 'Bill-To',                              City__c = 'Dallas',     Contact_Name__c = 'Baylor Heart and Vascular Ho',   Country__c = 'United States',                                       Name = 'QAD Test Address 3',                                Postal_Code__c = '75226',   QAD_ad_address_id__c = '156524',    QAD_ad_addr__c = '500002',      QAD_ad_bus_relation__c = '500002',  QAD_ad_ctry__c = 'US',  QAD_ad_date__c =  Date.newInstance(2018,09,17), QAD_ad_domain__c = 'USD10', QAD_ad_format__c = '0', QAD_ad_lang__c = 'us',  QAD_ad_mod_date__c =  Date.newInstance(2018,09,17),                             QAD_ad_userid__c = 'sig',       QAD_sourced__c = TRUE,  State_Province__c = 'TX',   Street_Address__c = '621 N Hall St');
        Account_Address__c addr4 = new Account_Address__c (Account__c = qadAccountList[2].Id, Address_Type__c = 'Bill-To',                              City__c = 'N. Brabant', Contact_Name__c = 'SRM p.a. Healthlink Europe S',   Country__c = 'Netherlands',                                         Name = 'QAD Test Address 4',                                                            QAD_ad_address_id__c = '156780',    QAD_ad_addr__c = '500004',      QAD_ad_bus_relation__c = '500004',  QAD_ad_ctry__c = 'NL',  QAD_ad_date__c =  Date.newInstance(2018,09,17), QAD_ad_domain__c = 'USD10', QAD_ad_format__c = '0', QAD_ad_lang__c = 'us',  QAD_ad_mod_date__c =  Date.newInstance(2018,09,17),                             QAD_ad_userid__c = 'sig',       QAD_sourced__c = TRUE,                              Street_Address__c = '0031 73 3030500 Burgemeester Burgerslaan 40A 5245 NH Rosmalen');
        Account_Address__c addr5 = new Account_Address__c (Account__c = qadAccountList[3].Id, Address_Type__c = 'Bill-To',                              City__c = 'Portland',   Contact_Name__c = 'White Plains Hospital',          Country__c = 'United States',   Email__c = 'invoices@upmc.edu',     Name = 'QAD Test Address 5',                                Postal_Code__c = '97208',   QAD_ad_address_id__c = '158502',    QAD_ad_addr__c = '500014',      QAD_ad_bus_relation__c = '500014',  QAD_ad_ctry__c = 'US',  QAD_ad_date__c =  Date.newInstance(2018,09,17), QAD_ad_domain__c = 'USD10', QAD_ad_format__c = '0', QAD_ad_lang__c = 'us',  QAD_ad_mod_date__c =  Date.newInstance(2018,09,17),                             QAD_ad_userid__c = 'sig',       QAD_sourced__c = TRUE,  State_Province__c = 'OR',   Street_Address__c = '4909 Forest Ave');
        Account_Address__c addr6 = new Account_Address__c (Account__c = qadAccountList[4].Id, Address_Type__c = 'Bill-To', ATTN__c = 'Jim Houp',        City__c = 'Portland',   Contact_Name__c = 'UPMC HAMOT',                     Country__c = 'United States',   Email__c = 'test@UPMC.Com',         Name = 'QAD Test Address 6',    Phone__c = '123-233-3321',  Postal_Code__c = '97208',   QAD_ad_address_id__c = '159841',    QAD_ad_addr__c = '500019',      QAD_ad_bus_relation__c = '500019',  QAD_ad_ctry__c = 'US',  QAD_ad_date__c =  Date.newInstance(2018,09,17), QAD_ad_domain__c = 'USD10', QAD_ad_format__c = '0', QAD_ad_lang__c = 'us',  QAD_ad_mod_date__c =  Date.newInstance(2018,09,17),                             QAD_ad_userid__c = 'SNGUYEN',   QAD_sourced__c = TRUE,  State_Province__c = 'OR',   Street_Address__c = 'PO Box 4909');
        Account_Address__c addr7 = new Account_Address__c (Account__c = qadAccountList[5].Id, Address_Type__c = 'Bill-To',                              City__c = 'Erie',       Contact_Name__c = 'UPMC HAMOT',                     Country__c = 'United States',                                       Name = 'QAD Test Address 7',                                Postal_Code__c = '16550',   QAD_ad_address_id__c = '159848',    QAD_ad_addr__c = '500022',      QAD_ad_bus_relation__c = '500022',  QAD_ad_ctry__c = 'US',  QAD_ad_date__c =  Date.newInstance(2018,09,17), QAD_ad_domain__c = 'USD10', QAD_ad_format__c = '0', QAD_ad_lang__c = 'us',  QAD_ad_mod_date__c =  Date.newInstance(2018,09,17),                             QAD_ad_userid__c = 'SNGUYEN',   QAD_sourced__c = TRUE,  State_Province__c = 'PA',   Street_Address__c = '201 State St 2nd Floor Special Procedures Lab');
        Account_Address__c addr8 = new Account_Address__c (Account__c = qadAccountList[6].Id, Address_Type__c = 'Bill-To',                              City__c = 'Portland',   Contact_Name__c = 'White Plains Hospital',          Country__c = 'United States',   Email__c = 'invoices@upmc.edu',     Name = 'QAD Test Address 8',                                Postal_Code__c = '97208',   QAD_ad_address_id__c = '158502',    QAD_ad_addr__c = '500014S1',    QAD_ad_bus_relation__c = '500014',  QAD_ad_ctry__c = 'US',  QAD_ad_date__c =  Date.newInstance(2018,09,17), QAD_ad_domain__c = 'USD10', QAD_ad_format__c = '0', QAD_ad_lang__c = 'us',  QAD_ad_mod_date__c =  Date.newInstance(2018,09,17),                             QAD_ad_userid__c = 'sig',       QAD_sourced__c = TRUE,  State_Province__c = 'OR',   Street_Address__c = '4910 Forest Ave');
        Account_Address__c addr9 = new Account_Address__c (Account__c = qadAccountList[7].Id, Address_Type__c = 'Bill-To',                              City__c = 'Erie',       Contact_Name__c = 'UPMC HAMOT',                     Country__c = 'United States',                                       Name = 'QAD Test Address 9',                                Postal_Code__c = '16550',   QAD_ad_address_id__c = '160937',    QAD_ad_addr__c = '501711',      QAD_ad_bus_relation__c = '501711',  QAD_ad_ctry__c = 'US',  QAD_ad_date__c =  Date.newInstance(2018,09,17), QAD_ad_domain__c = 'USD10', QAD_ad_format__c = '0', QAD_ad_lang__c = 'us',  QAD_ad_mod_date__c =  Date.newInstance(2018,09,17),                             QAD_ad_userid__c = 'SNGUYEN',   QAD_sourced__c = TRUE,  State_Province__c = 'PA',   Street_Address__c = '201 State St 2nd Floor Special Procedures Lab');
        Account_Address__c addr0 = new Account_Address__c (Account__c = qadAccountList[8].Id, Address_Type__c = 'Bill-To',                              City__c = 'Portland',   Contact_Name__c = 'UPMC HAMOT',                     Country__c = 'United States',                                       Name = 'QAD Test Address 10',                               Postal_Code__c = '97208',   QAD_ad_address_id__c = '160940',    QAD_ad_addr__c = '501711B',     QAD_ad_bus_relation__c = '501711B', QAD_ad_ctry__c = 'US',  QAD_ad_date__c =  Date.newInstance(2018,09,17), QAD_ad_domain__c = 'USD10', QAD_ad_format__c = '0', QAD_ad_lang__c = 'us',  QAD_ad_mod_date__c =  Date.newInstance(2018,09,17),                             QAD_ad_userid__c = 'SNGUYEN',   QAD_sourced__c = TRUE,                              Street_Address__c = 'PO Box 4909 Attn: Invoice Audit'); 
    

        testAccountAddressList.add(addr1);
        testAccountAddressList.add(addr2);
        testAccountAddressList.add(addr3);
        testAccountAddressList.add(addr4);
        testAccountAddressList.add(addr5);
        testAccountAddressList.add(addr6);
        testAccountAddressList.add(addr7);
        testAccountAddressList.add(addr8);
        testAccountAddressList.add(addr9);
        testAccountAddressList.add(addr0);
     
        insert testAccountAddressList;
    }


    public static void qad_createQadSourceParts(){
        List<Product2> p2List = new List<Product2>();
        Product2 p201 = new Product2(Description = 'Test Prouduct 01', Family = 'Test', IsActive = True, Name = 'P2-01 [EA]', ProductCode = 'P2-01', QAD_pd_mod_date__c = Date.NewInstance(2017,01,01), QAD_pt_part__c = 'P2-01 [EA]', QAD_sourced__c = true, QuantityUnitOfMeasure = 'EA' );
        Product2 p202 = new Product2(Description = 'Test Prouduct 02', Family = 'Test', IsActive = True, Name = 'P2-02 [EA]', ProductCode = 'P2-02', QAD_pd_mod_date__c = Date.NewInstance(2017,01,01), QAD_pt_part__c = 'P2-02 [EA]', QAD_sourced__c = true, QuantityUnitOfMeasure = 'EA' );
        Product2 p203 = new Product2(Description = 'Test Prouduct 03', Family = 'Test', IsActive = True, Name = 'P2-03 [EA]', ProductCode = 'P2-03', QAD_pd_mod_date__c = Date.NewInstance(2017,01,01), QAD_pt_part__c = 'P2-03 [EA]', QAD_sourced__c = true, QuantityUnitOfMeasure = 'EA' );
        Product2 p204 = new Product2(Description = 'Test Prouduct 04', Family = 'Test', IsActive = True, Name = 'P2-04 [EA]', ProductCode = 'P2-04', QAD_pd_mod_date__c = Date.NewInstance(2017,01,01), QAD_pt_part__c = 'P2-04 [EA]', QAD_sourced__c = true, QuantityUnitOfMeasure = 'EA' );
        Product2 p205 = new Product2(Description = 'Test Prouduct 05', Family = 'Test', IsActive = True, Name = 'P2-05 [EA]', ProductCode = 'P2-05', QAD_pd_mod_date__c = Date.NewInstance(2017,01,01), QAD_pt_part__c = 'P2-05 [EA]', QAD_sourced__c = true, QuantityUnitOfMeasure = 'EA' );
        Product2 p206 = new Product2(Description = 'Test Prouduct 06', Family = 'Test', IsActive = True, Name = 'P2-06 [EA]', ProductCode = 'P2-06', QAD_pd_mod_date__c = Date.NewInstance(2017,01,01), QAD_pt_part__c = 'P2-06 [EA]', QAD_sourced__c = true, QuantityUnitOfMeasure = 'EA' );

        p2List.add(p201);
        p2List.add(p202);
        p2List.add(p203);
        p2List.add(p204);
        p2List.add(p205);
        p2List.add(p206);

        insert p2List;

        SYSTEM.DEBUG('PRODUCT LIST SIZE = [' + p2List.size() + ']' );
        for(Product2 p2 : p2List){
            SYSTEM.DEBUG('PRODUCT CODE = [' + p2.ProductCode + '] Id = [' + p2.Id + ']');
        }

    }
  


    public static void createPricebookEntryStagingTable(){
        List<PricebookEntry_Staging_Table__c> pbestInsertList = new List<PricebookEntry_Staging_Table__c>();
        PricebookEntry_Staging_Table__c pbest01 = new PricebookEntry_Staging_Table__c(QAD_pi_cs_code__c = '500002', QAD_pi_list__c = null, QAD_pi_list_id__c = '12345', QAD_pi_part_code__c = 'P2-01', QAD_pi_um__c = 'EA');
        PricebookEntry_Staging_Table__c pbest02 = new PricebookEntry_Staging_Table__c(QAD_pi_cs_code__c = '500002', QAD_pi_list__c = null, QAD_pi_list_id__c = '12346', QAD_pi_part_code__c = 'P2-02', QAD_pi_um__c = 'EA');
        pbestInsertList.add(pbest01);
        pbestInsertList.add(pbest02);
        insert pbestInsertList;
    }

    public static void qad_createQadSourcedPricebooks(){
        List<Pricebook2> pb2List = new List<Pricebook2>();
        Pricebook2 pb201 = new Pricebook2(IsActive = true, Name = 'QAD Test Account 1 - [500002]', QAD_pi_cs_code__c = '500002', QAD_sourced__c = true);
        Pricebook2 pb202 = new Pricebook2(IsActive = true, Name = 'QAD Test Account 2 - [500000]', QAD_pi_cs_code__c = '500000', QAD_sourced__c = true);
        Pricebook2 pb203 = new Pricebook2(IsActive = true, Name = 'QAD Test Account 4 - [500004]', QAD_pi_cs_code__c = '500004', QAD_sourced__c = true);

        pb2List.add(pb201);
        pb2List.add(pb202);
        pb2List.add(pb203);

        insert pb2List;
    }

    public static void qad_createQadSourcedPricebookEntries(){
        List<Pricebook2> pb2List = [SELECT Name, QAD_pi_cs_code__c, QAD_Sourced__c FROM Pricebook2];
        Map<String, Id> pb2Map = New Map<String, Id>();
        for(Pricebook2 pb2 : pb2List){
            if(pb2.QAD_pi_cs_code__c != null && pb2.QAD_pi_cs_code__c <> ''){
                pb2Map.put(pb2.QAD_pi_cs_code__c, pb2.Id);
            }
        }

        pb2Map.put('Standard Price Book', Test.getStandardPricebookid());


        List<Product2> p2List = [SELECT Id, QAD_pt_part__c FROM Product2];

        Map<String, Id> p2Map = new Map<String, Id>();
        for(Product2 p2 : p2List){
            p2Map.put(p2.QAD_pt_part__c, p2.Id);
        }

        List<PricebookEntry> pbeList = new List<PricebookEntry>();

        List<PricebookEntry> pbeListStd = new List<PricebookEntry>();

        PricebookEntry pbe01 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('500002'), CsCode_Product_Key__c = '500002-P2-01 [EA]', Product2Id = p2Map.get('P2-01 [EA]'), QAD_sourced__c = true, UnitPrice = 110 );
        PricebookEntry pbe02 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('500002'), CsCode_Product_Key__c = '500002-P2-02 [EA]', Product2Id = p2Map.get('P2-02 [EA]'), QAD_sourced__c = true, UnitPrice = 120 );
        PricebookEntry pbe03 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('500002'), CsCode_Product_Key__c = '500002-P2-03 [EA]', Product2Id = p2Map.get('P2-03 [EA]'), QAD_sourced__c = true, UnitPrice = 130 );
        PricebookEntry pbe04 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('500002'), CsCode_Product_Key__c = '500002-P2-04 [EA]', Product2Id = p2Map.get('P2-04 [EA]'), QAD_sourced__c = true, UnitPrice = 140 );
        PricebookEntry pbe05 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('500002'), CsCode_Product_Key__c = '500002-P2-05 [EA]', Product2Id = p2Map.get('P2-05 [EA]'), QAD_sourced__c = true, UnitPrice = 150 );

        PricebookEntry pbe11 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('500000'), CsCode_Product_Key__c = '500000-P2-01 [EA]', Product2Id = p2Map.get('P2-01 [EA]'), QAD_sourced__c = true, UnitPrice = 210 );
        PricebookEntry pbe12 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('500000'), CsCode_Product_Key__c = '500000-P2-02 [EA]', Product2Id = p2Map.get('P2-02 [EA]'), QAD_sourced__c = true, UnitPrice = 220 );
        PricebookEntry pbe13 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('500000'), CsCode_Product_Key__c = '500000-P2-03 [EA]', Product2Id = p2Map.get('P2-03 [EA]'), QAD_sourced__c = true, UnitPrice = 230 );
        PricebookEntry pbe14 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('500000'), CsCode_Product_Key__c = '500000-P2-04 [EA]', Product2Id = p2Map.get('P2-04 [EA]'), QAD_sourced__c = true, UnitPrice = 240 );
        PricebookEntry pbe15 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('500000'), CsCode_Product_Key__c = '500000-P2-05 [EA]', Product2Id = p2Map.get('P2-05 [EA]'), QAD_sourced__c = true, UnitPrice = 250 );

        PricebookEntry pbe21 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('500004'), CsCode_Product_Key__c = '500004-P2-01 [EA]', Product2Id = p2Map.get('P2-01 [EA]'), QAD_sourced__c = true, UnitPrice = 320 );
        PricebookEntry pbe22 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('500004'), CsCode_Product_Key__c = '500004-P2-02 [EA]', Product2Id = p2Map.get('P2-02 [EA]'), QAD_sourced__c = true, UnitPrice = 320 );
        PricebookEntry pbe23 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('500004'), CsCode_Product_Key__c = '500004-P2-03 [EA]', Product2Id = p2Map.get('P2-03 [EA]'), QAD_sourced__c = true, UnitPrice = 330 );
        PricebookEntry pbe24 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('500004'), CsCode_Product_Key__c = '500004-P2-04 [EA]', Product2Id = p2Map.get('P2-04 [EA]'), QAD_sourced__c = true, UnitPrice = 340 );
        PricebookEntry pbe25 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('500004'), CsCode_Product_Key__c = '500004-P2-05 [EA]', Product2Id = p2Map.get('P2-05 [EA]'), QAD_sourced__c = true, UnitPrice = 350 );

        PricebookEntry pbe31 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('Standard Price Book'), Product2Id = p2Map.get('P2-01 [EA]'), QAD_sourced__c = true, UnitPrice = 410 );
        PricebookEntry pbe32 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('Standard Price Book'), Product2Id = p2Map.get('P2-02 [EA]'), QAD_sourced__c = true, UnitPrice = 420 );
        PricebookEntry pbe33 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('Standard Price Book'), Product2Id = p2Map.get('P2-03 [EA]'), QAD_sourced__c = true, UnitPrice = 430 );
        PricebookEntry pbe34 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('Standard Price Book'), Product2Id = p2Map.get('P2-04 [EA]'), QAD_sourced__c = true, UnitPrice = 440 );
        PricebookEntry pbe35 = new PricebookEntry(Duplicate__c = false, IsActive = True, Pricebook2Id = pb2Map.get('Standard Price Book'), Product2Id = p2Map.get('P2-05 [EA]'), QAD_sourced__c = true, UnitPrice = 450 );

        pbeList.add(pbe01);
        pbeList.add(pbe02);
        pbeList.add(pbe03);
        pbeList.add(pbe04);
        pbeList.add(pbe05);

        pbeList.add(pbe11);
        pbeList.add(pbe12);
        pbeList.add(pbe13);
        pbeList.add(pbe14);
        pbeList.add(pbe15);

        pbeList.add(pbe21);
        pbeList.add(pbe22);
        pbeList.add(pbe23);
        pbeList.add(pbe24);
        pbeList.add(pbe25);

        pbeListStd.add(pbe31);
        pbeListStd.add(pbe32);
        pbeListStd.add(pbe33);
        pbeListStd.add(pbe34);
        pbeListStd.add(pbe35);

        List<PricebookEntry> pbeExtList = [SELECT ID, Product2Id, Pricebook2Id FROM PricebookEntry];
        Set<String> pbeDefSet = new Set<String>();
        for(PricebookEntry pbe : pbeExtList){
            pbeDefSet.add(pbe.Pricebook2Id + '-' + pbe.Product2Id);
        }
        List<PricebookEntry> pbeListStd2 = new List<PricebookEntry>();
        for(PricebookEntry pbe : pbeListStd){
            if(!pbeDefSet.contains(pbe.PriceBook2Id + '-' + pbe.Product2Id)){
                pbeListStd2.add(pbe);
            }
        }


        insert pbeListStd2;

        insert pbeList;

    }

    public static void qad_createQadSourcedOrders(){
        List<Order> oList = new List<Order>();

        Date tDay = Date.newInstance(2018,1,5);
        Date mDay = Date.newInstance(2018,1,4);
        Date pDay = Date.newInstance(2018,1,6);

        Date tDay10 = Date.newInstance(2018,10,15);
        Date mDay10 = Date.newInstance(2018,10,14);
        Date pDay10 = Date.newInstance(2018,10,16);

        List<Account> aList = [SELECT Id, Name FROM Account];
        Map<String, ID> aMap = new Map<String, Id>();
        for(Account a : aList){
            aMap.put(a.Name, a.Id);
        }

        List<Account_Address__c> aaList = [SELECT ID, QAD_ad_addr__c FROM Account_Address__c];
        Map<String, ID> aaMap = new Map<String, String>();
        for(Account_Address__c aa : aaList){
            aaMap.put(aa.QAD_ad_addr__c, aa.Id);
        }
        
        Order o01 = new Order(AccountId = aMap.get('QAD Test Account 1'), BillingCity = 'Portland', BillingCountry = 'United States' , BillingPostalCode = '04102' ,BillingState = 'ME' ,BillingStreet = '101 Test Street', BILL_TO_ID__c = null , Complete_Date__c = pDay ,Credit_Terms__c = 'N30' , EffectiveDate = tDay, EndDate = tDay ,FOB__c = 'ORIGIN' , Invoice_Date__c = pDay ,IQMS_ORDER_NO__c = 'S100001', Is_Complete__c = true, PoNumber = 'TESTPO1', PO_Number__c = 'TESTPO1', QAD_sourced__c = true, QAD_so_bill_c__c = '500000' ,QAD_so_channel__c = 'STANDARD', QAD_so_curr__c = 'USD', QAD_so_cust_c__c = '500000', QAD_so_cust_po__c = 'TESTPO1', QAD_so_daybookset__c = 'AR', QAD_so_domain__c = 'USD10', QAD_so_due_date__c = pDay, QAD_so_ex_rate__c = 1.0, QAD_so_lang__c = 'us', QAD_so_priced_dt__c = pDay, QAD_so_pricing_dt__c = pDay, QAD_so_req_date__c = pDay, QAD_so_ship_date__c = pDay, QAD_so_ship_po__c = 'TESTPO1', QAD_so_ship__c = '500000', QAD_so_slspsn__c = 'AD00001-AM00001-TDS0001', QAD_so_tax_env__c = 'US-US', QAD_so_trl1_amt__c = 0,QAD_so_trl1_cd__c = '10', QAD_so_trl2_amt__c = 0,QAD_so_trl3_amt__c = 0,QAD_so_userId__c = 'tUser001', ShippingCity = 'Portland', ShippingCountry = 'United States', ShippingPostalCode = '04102', ShippingState = 'ME', ShippingStreet = '101 Test Street', Ship_To_Address__c = aaMap.get('500000'), Ship_Via__c = 'FDX2Day', Status = 'DRAFT');
        Order o02 = new Order(AccountId = aMap.get('QAD Test Account 2'), BillingCity = 'Portland', BillingCountry = 'United States' , BillingPostalCode = '04102' ,BillingState = 'ME' ,BillingStreet = '101 Test Street', BILL_TO_ID__c = null , Complete_Date__c = pDay ,Credit_Terms__c = 'N30' , EffectiveDate = tDay, EndDate = tDay ,FOB__c = 'ORIGIN' , Invoice_Date__c = pDay ,IQMS_ORDER_NO__c = 'S100002', Is_Complete__c = true, PoNumber = 'TESTPO1', PO_Number__c = 'TESTPO1', QAD_sourced__c = true, QAD_so_bill_c__c = '500002' ,QAD_so_channel__c = 'STANDARD', QAD_so_curr__c = 'USD', QAD_so_cust_c__c = '500002', QAD_so_cust_po__c = 'TESTPO1', QAD_so_daybookset__c = 'AR', QAD_so_domain__c = 'USD10', QAD_so_due_date__c = pDay, QAD_so_ex_rate__c = 1.0, QAD_so_lang__c = 'us', QAD_so_priced_dt__c = pDay, QAD_so_pricing_dt__c = pDay, QAD_so_req_date__c = pDay, QAD_so_ship_date__c = pDay, QAD_so_ship_po__c = 'TESTPO1', QAD_so_ship__c = '500002', QAD_so_slspsn__c = 'AD00001-AM00001-TDS0001', QAD_so_tax_env__c = 'US-US', QAD_so_trl1_amt__c = 0,QAD_so_trl1_cd__c = '10', QAD_so_trl2_amt__c = 0,QAD_so_trl3_amt__c = 0,QAD_so_userId__c = 'tUser001', ShippingCity = 'Portland', ShippingCountry = 'United States', ShippingPostalCode = '04102', ShippingState = 'ME', ShippingStreet = '101 Test Street', Ship_To_Address__c = aaMap.get('500002'), Ship_Via__c = 'FDX2Day', Status = 'DRAFT');
        Order o03 = new Order(AccountId = aMap.get('QAD Test Account 3'), BillingCity = 'Portland', BillingCountry = 'United States' , BillingPostalCode = '04102' ,BillingState = 'ME' ,BillingStreet = '101 Test Street', BILL_TO_ID__c = null , Complete_Date__c = pDay ,Credit_Terms__c = 'N30' , EffectiveDate = tDay, EndDate = tDay ,FOB__c = 'ORIGIN' , Invoice_Date__c = pDay ,IQMS_ORDER_NO__c = 'S100003', Is_Complete__c = true, PoNumber = 'TESTPO1', PO_Number__c = 'TESTPO1', QAD_sourced__c = true, QAD_so_bill_c__c = '500014' ,QAD_so_channel__c = 'STANDARD', QAD_so_curr__c = 'USD', QAD_so_cust_c__c = '500014', QAD_so_cust_po__c = 'TESTPO1', QAD_so_daybookset__c = 'AR', QAD_so_domain__c = 'USD10', QAD_so_due_date__c = pDay, QAD_so_ex_rate__c = 1.0, QAD_so_lang__c = 'us', QAD_so_priced_dt__c = pDay, QAD_so_pricing_dt__c = pDay, QAD_so_req_date__c = pDay, QAD_so_ship_date__c = pDay, QAD_so_ship_po__c = 'TESTPO1', QAD_so_ship__c = '500014S1', QAD_so_slspsn__c = 'AD00001-AM00001-TDS0001', QAD_so_tax_env__c = 'US-US', QAD_so_trl1_amt__c = 0,QAD_so_trl1_cd__c = '10', QAD_so_trl2_amt__c = 0,QAD_so_trl3_amt__c = 0,QAD_so_userId__c = 'tUser001', ShippingCity = 'Portland', ShippingCountry = 'United States', ShippingPostalCode = '04102', ShippingState = 'ME', ShippingStreet = '101 Test Street', Ship_To_Address__c = aaMap.get('500000'), Ship_Via__c = 'FDX2Day', Status = 'DRAFT');
        Order o04 = new Order(AccountId = aMap.get('QAD Test Account 3'), BillingCity = 'Portland', BillingCountry = 'United States' , BillingPostalCode = '04102' ,BillingState = 'ME' ,BillingStreet = '101 Test Street', BILL_TO_ID__c = null , Complete_Date__c = pDay ,Credit_Terms__c = 'N30' , EffectiveDate = tDay, EndDate = tDay ,FOB__c = 'ORIGIN' , Invoice_Date__c = pDay ,IQMS_ORDER_NO__c = 'R100001', Is_Complete__c = true, PoNumber = 'TESTPO1', PO_Number__c = 'TESTPO1', QAD_sourced__c = true, QAD_so_bill_c__c = '500014' ,QAD_so_channel__c = 'STANDARD', QAD_so_curr__c = 'USD', QAD_so_cust_c__c = '500014', QAD_so_cust_po__c = 'TESTPO1', QAD_so_daybookset__c = 'AR', QAD_so_domain__c = 'USD10', QAD_so_due_date__c = pDay, QAD_so_ex_rate__c = 1.0, QAD_so_lang__c = 'us', QAD_so_priced_dt__c = pDay, QAD_so_pricing_dt__c = pDay, QAD_so_req_date__c = pDay, QAD_so_ship_date__c = pDay, QAD_so_ship_po__c = 'TESTPO1', QAD_so_ship__c = '500014S1', QAD_so_slspsn__c = 'AD00001-AM00001-TDS0001', QAD_so_tax_env__c = 'US-US', QAD_so_trl1_amt__c = 0,QAD_so_trl1_cd__c = '10', QAD_so_trl2_amt__c = 0,QAD_so_trl3_amt__c = 0,QAD_so_userId__c = 'tUser001', ShippingCity = 'Portland', ShippingCountry = 'United States', ShippingPostalCode = '04102', ShippingState = 'ME', ShippingStreet = '101 Test Street', Ship_To_Address__c = aaMap.get('500000'), Ship_Via__c = 'FDX2Day', Status = 'DRAFT');


        oList.add(o01);
        oList.add(o02);
        oList.add(o03);
        oList.add(o04);

        insert oList;


        List<OrderItem> oiList = new List<OrderItem>();
        OrderItem oi01_01 = new OrderItem(Discount_Pct__c = 0, IQMS_ORDER_ID__c = 'S100001', Line_Item_Complete__c = FALSE, OrderId = o01.Id, OrderNumLine__c = 'S100001-001', Promise_Date__c = tDay, QAD_sod_compl_date__c = pDay, QAD_sod_contr_id__c = 'Baton123', QAD_sod_domain__c = 'USD10', QAD_sod_due_date__c = pDay, QAD_sod_fixed_price__c = 2750, QAD_sod_fix_pr__c = TRUE, QAD_sod_line__c = '1', QAD_sod_lot_c__c = '12345' , QAD_sod_mod_date__c = pDay, QAD_sod_mod_userid__c = 'MFARIAS', QAD_sod_part__c = 'P2-01', QAD_sod_per_date__c = pDay, QAD_sod_pricing_dt__c = mDay, QAD_sod_prodline__c = 'STEN', QAD_sod_pr_list__c = 'AR', QAD_sod_req_date__c = pDay, QAD_sod_slspsn__c = 'AD00001-AM00002-TDS0001', QAD_sod_std_cost__c = 576.75, QAD_sod_taxable__c = FALSE, QAD_sod_tax_env__c = 'US-US', QAD_sod_um_conv__c = 1, QAD_sourced__c = TRUE, Quantity = 1, Quantity_Invoiced__c = 1, Quantity_Shipped__c = 1, Shipped_Quantity__c = 1, Ship_Date__c = pDay, UnitPrice = 2750, Unit_of_Measure__c = 'ea' );
        OrderItem oi01_02 = new OrderItem(Discount_Pct__c = 0, IQMS_ORDER_ID__c = 'S100001', Line_Item_Complete__c = FALSE, OrderId = o01.Id, OrderNumLine__c = 'S100001-002', Promise_Date__c = tDay10, QAD_sod_compl_date__c = pDay10, QAD_sod_contr_id__c = 'Baton123', QAD_sod_domain__c = 'USD10', QAD_sod_due_date__c = pDay10, QAD_sod_fixed_price__c = 2750, QAD_sod_fix_pr__c = TRUE, QAD_sod_line__c = '3', QAD_sod_lot_c__c = '12345' , QAD_sod_mod_date__c = pDay10, QAD_sod_mod_userid__c = 'MFARIAS', QAD_sod_part__c = 'P2-06', QAD_sod_per_date__c = pDay10, QAD_sod_pricing_dt__c = mDay10, QAD_sod_prodline__c = 'STEN', QAD_sod_pr_list__c = 'AR', QAD_sod_req_date__c = pDay10, QAD_sod_slspsn__c = 'AD00001-AM00002-TDS0001', QAD_sod_std_cost__c = 576.75, QAD_sod_taxable__c = FALSE, QAD_sod_tax_env__c = 'US-US', QAD_sod_um_conv__c = 1, QAD_sourced__c = TRUE, Quantity = 2, Quantity_Invoiced__c = 1, Quantity_Shipped__c = 1, Shipped_Quantity__c = 1, Ship_Date__c = pDay10, UnitPrice = 2750, Unit_of_Measure__c = 'ea' );
        OrderItem oi01_03 = new OrderItem(Discount_Pct__c = 0, IQMS_ORDER_ID__c = 'R100001', Line_Item_Complete__c = FALSE, OrderId = o01.Id, OrderNumLine__c = 'R100001-002', Promise_Date__c = tDay10, QAD_sod_compl_date__c = pDay10, QAD_sod_contr_id__c = 'Baton123', QAD_sod_domain__c = 'USD10', QAD_sod_due_date__c = pDay10, QAD_sod_fixed_price__c = -2750, QAD_sod_fix_pr__c = TRUE, QAD_sod_line__c = '3', QAD_sod_lot_c__c = '12345' , QAD_sod_mod_date__c = pDay10, QAD_sod_mod_userid__c = 'MFARIAS', QAD_sod_part__c = 'P2-06', QAD_sod_per_date__c = pDay10, QAD_sod_pricing_dt__c = mDay10, QAD_sod_prodline__c = 'STEN', QAD_sod_pr_list__c = 'AR', QAD_sod_req_date__c = pDay10, QAD_sod_slspsn__c = 'AD00001-AM00002-TDS0001', QAD_sod_std_cost__c = -576.75, QAD_sod_taxable__c = FALSE, QAD_sod_tax_env__c = 'US-US', QAD_sod_um_conv__c = 1, QAD_sourced__c = TRUE, Quantity = 2, Quantity_Invoiced__c = 1, Quantity_Shipped__c = 1, Shipped_Quantity__c = 1, Ship_Date__c = pDay10, UnitPrice = -2750, Unit_of_Measure__c = 'ea' );


        oiList.add(oi01_01);
        oiList.add(oi01_02);
        oiList.add(oi01_03);
        insert oiList;
    }




    public static void qad_createQadTestShipment(){

        List<Shipment__c> shipmentList = New List<Shipment__c>();

        Shipment__c sh01 = new Shipment__c(QAD_abs_qad01__c = 'FDX2Day ORIGIN SH1000001 469729411776', Shipper_Ext_Id__c = 'sSH1000001', Name = 'sSH1000001', QAD_abs_inv_nbr__c = 'INV00001', QAD_abs_shp_date__c = Date.newInstance(2018,10,16));
        Shipment__c sh02 = new Shipment__c(QAD_abs_qad01__c = 'UPS2Day ORIGIN SH1000010 1Z2X98V90249568298', Shipper_Ext_Id__c = 'sSH1000002',  Name = 'sSH1000001', QAD_abs_inv_nbr__c = 'INV00001', QAD_abs_shp_date__c = Date.newInstance(2018,10,16));

        shipmentList.add(sh01);
        shipmentList.add(sh02);
        insert shipmentList;

    }

    public static void qad_createQadSourcedOrderItemDetail(){
        List<OrderItem> oiList = [SELECT Product2Id, Quantity, Id, Order.EffectiveDate FROM OrderItem];
        List<OrderItemDetail__c> oidList = new List<OrderItemDetail__c>();
        for(OrderItem oi : oiList){
            SYSTEM.DEBUG('ORDER ITEM PROCESSED = [' + oi.Id + ']');
            if(oi.Quantity == 2){
                OrderItemDetail__c oid1 = new OrderItemDetail__c(Order_Item__c = oi.Id, Qty_Shipped__c = 1, Qty_to_Ship__c = 2, Product__c = oi.Product2Id, Lot_Number__c = '12345', Ship_Date__c = Date.newInstance(2018,10,20), OrderNumLine__c = 'S100001-002', Shipper_Number__c = 'sSH1000001');
                OrderItemDetail__c oid2 = new OrderItemDetail__c(                       Qty_Shipped__c = 1, Qty_to_Ship__c = 2, Product__c = oi.Product2Id, Lot_Number__c = '12348', Ship_Date__c = Date.newInstance(2018,10,22), OrderNumLine__c = 'S100001-002'); 
                oidList.add(oid1);
                oidList.add(oid2);            
            }
            else{
                OrderItemDetail__c oid3 = new OrderItemDetail__c(Order_Item__c = oi.Id, Qty_Shipped__c = 1, Qty_to_Ship__c = 1, Product__c = oi.Product2Id, Lot_Number__c = '12345', Ship_Date__c = Date.newInstance(2018,1,20));
                oidList.add(oid3);
            }

        }
        insert oidList;
    }

    public static void qad_createQadSourcedInvoice(){
        OrderItem oi = [SELECT OrderId, Order.AccountId, Product2Id, Quantity, Id, Order.EffectiveDate, PricebookEntryId, PricebookEntry.Pricebook2Id, Ship_Date__c FROM OrderItem LIMIT 1];

        Invoice__c i = new Invoice__c(Account__c = oi.Order.AccountId, FOB__c = 'ORIGIN', Invoice_Number__c = 'INV00001', Invoice_or_Credit_Memo__c = 'Invoice', Name= 'INV00001', Order__c = oi.OrderId, Outstanding_Balance__c = 0, Payment_Terms__c = 'N30', Price_Book__c = oi.PricebookEntry.Pricebook2Id, QAD_ih_mod_date__c = oi.Ship_Date__c,  QAD_ih_slspsn__c = 'AD00001-AM00002-TDS0001', QAD_ih_cust__c = '500000',   Sales_Order_Number__c = 'S100001', QAD_sourced__c = true, Invoice_Date__c = Date.newInstance(2018,10,16), QAD_ih_bill__c = '500000');
   
        Invoice__c r = new Invoice__c(Account__c = oi.Order.AccountId, FOB__c = 'ORIGIN', Invoice_Number__c = 'INV00002', Invoice_or_Credit_Memo__c = 'Invoice', Name= 'INV00001', Order__c = oi.OrderId, Outstanding_Balance__c = 0, Payment_Terms__c = 'N30', Price_Book__c = oi.PricebookEntry.Pricebook2Id, QAD_ih_mod_date__c = oi.Ship_Date__c,  QAD_ih_slspsn__c = 'AD00001-AM00002-TDS0001', QAD_ih_cust__c = '500000',  Sales_Order_Number__c = 'R100001', QAD_sourced__c = true, Invoice_Date__c = Date.newInstance(2018,10,16), QAD_ih_bill__c = '500000');

        insert i;
        insert r;

        Invoice_Item__c ii01 = new Invoice_Item__c(
                                                    Invoice_Line_Number__c = 'INV00001-001',
                                                     Invoice__c = i.Id,
                                                     Item_Number__c = 'P2-01', 
                                                     List_Price__c = 2.00, 
                                                     Lot_Number__c = '12345', 
                                                     Name = 'INV00001-001', 
                                                     OrderItem__c = oi.Id, 
                                                     Product__c = oi.Product2Id, 
                                                     QAD_idh_slspsn__c = 'AD00001-AM00002-TDS0001', 
                                                     Sales_Order_Number__c = 'S100001', 
                                                     Ship_Date__c = i.Invoice_Date__c, 
                                                     Unit_of_Measure__c = 'EA', 
                                                     Unit_Price__c = 2.00,
                                                     QAD_sourced__c = true);

         Invoice_Item__c ii02 = new Invoice_Item__c(
                                                    Invoice_Line_Number__c = 'INV00001-002',
                                                     Invoice__c = i.Id, 
                                                     Item_Number__c = 'P2-01', 
                                                     List_Price__c = 2.00, 
                                                     Lot_Number__c = '12345', 
                                                     Name = 'INV00001-002', 
                                                     OrderItem__c = oi.Id, 
                                                     Product__c = oi.Product2Id, 
                                                     QAD_idh_slspsn__c = 'AD00001-AM00002-TDS0001', 
                                                     Sales_Order_Number__c = 'S100001', 
                                                     Ship_Date__c = Date.newInstance(2018,10,10), 
                                                     Unit_of_Measure__c = 'EA', 
                                                     Unit_Price__c = 2.00,
                                                     QAD_sourced__c = false);

         Invoice_Item__c ii03 = new Invoice_Item__c(
                                                    Invoice_Line_Number__c = 'INV00002-003',
                                                     Invoice__c = i.Id, 
                                                     Item_Number__c = 'P2-01', 
                                                     List_Price__c = 2.00, 
                                                     Lot_Number__c = '12345', 
                                                     Name = 'INV00001-003', 
                                                     OrderItem__c = oi.Id, 
                                                     Product__c = oi.Product2Id, 
                                                     QAD_idh_slspsn__c = 'AD00001-AM00002-TDS0001', 
                                                     Sales_Order_Number__c = 'R100001', 
                                                     Ship_Date__c = Date.newInstance(2018,10,10), 
                                                     Unit_of_Measure__c = 'EA', 
                                                     Unit_Price__c = 2.00,
                                                     QAD_sourced__c = false);

         List<Invoice_Item__c> iiList = new List<Invoice_Item__c>();
         iiList.add(ii02);
         iiList.add(ii01);
         iiList.add(ii03);
         insert iiList;
    }

    public static void qad_createQadSourcedInvoiceItems(){}

    public static void qad_createQadSourcedOrderItem(){}


    public static void createPricingQADInput(){
        List<PricingQADInput__c> pqiList = new List<PricingQADInput__c>();

        PricingQADInput__c pqi01 = new PricingQADInput__c(CustomerNumber__c = '500002', ItemNumber__c = 'P2-01 [EA]' , Name = '500002-P2-01-[EA]', Price_Amount__c = 1 , QADPriceBookID__c = '500002-P2-01-[EA]', Expired_Date__c = null, Start_Date__c = null, UOM__c = 'EA');
        PricingQADInput__c pqi02 = new PricingQADInput__c(CustomerNumber__c = '500002', ItemNumber__c = 'P2-02 [EA]' , Name = '500002-P2-02-[EA]', Price_Amount__c = 1 , QADPriceBookID__c = '500002-P2-02-[EA]', Expired_Date__c = null, Start_Date__c = null, UOM__c = 'EA');
        PricingQADInput__c pqi03 = new PricingQADInput__c(CustomerNumber__c = '500002', ItemNumber__c = 'P3-02 [BX]' , Name = '500002-P3-02-[BX]', Price_Amount__c = 1 , QADPriceBookID__c = '500002-P3-02-[BX]', Expired_Date__c = null, Start_Date__c = null, UOM__c = 'BX');

        PricingQADInput__c pqi04 = new PricingQADInput__c(CustomerNumber__c = '500000', ItemNumber__c = 'P2-01 [EA]' , Name = '500000-P2-01-[EA]', Price_Amount__c = 1 , QADPriceBookID__c = '500000-P2-01-[EA]', Expired_Date__c = Date.newInstance(2017,12,15), Start_Date__c = null, UOM__c = 'EA');
        PricingQADInput__c pqi05 = new PricingQADInput__c(CustomerNumber__c = '500000', ItemNumber__c = 'P2-02 [EA]' , Name = '500000-P2-02-[EA]', Price_Amount__c = 1 , QADPriceBookID__c = '500000-P2-02-[EA]', Expired_Date__c = null, Start_Date__c = Date.newInstance(2018,2,15), UOM__c = 'EA');
        PricingQADInput__c pqi06 = new PricingQADInput__c(CustomerNumber__c = '500000', ItemNumber__c = 'P3-02 [BX]' , Name = '500000-P3-02-[BX]', Price_Amount__c = 1 , QADPriceBookID__c = '500000-P3-02-[BX]', Expired_Date__c = Date.newInstance(2018,12,31), Start_Date__c = Date.newInstance(2018,1,11), UOM__c = 'BX');

        PricingQADInput__c pqi07 = new PricingQADInput__c(CustomerNumber__c = '599999', ItemNumber__c = 'P3-01 [EA]' , Name = '599999-P2-01-[EA]', Price_Amount__c = 1 , QADPriceBookID__c = '599999-P2-01-[EA]', Expired_Date__c = null, Start_Date__c = null, UOM__c = 'EA');
        PricingQADInput__c pqi08 = new PricingQADInput__c(CustomerNumber__c = '599999', ItemNumber__c = 'P3-02 [EA]' , Name = '599999-P2-02-[EA]', Price_Amount__c = 1 , QADPriceBookID__c = '599999-P2-02-[EA]', Expired_Date__c = null, Start_Date__c = null, UOM__c = 'EA');
        PricingQADInput__c pqi09 = new PricingQADInput__c(CustomerNumber__c = '599999', ItemNumber__c = 'P3-02 [BX]' , Name = '599999-P3-02-[BX]', Price_Amount__c = 1 , QADPriceBookID__c = '599999-P3-02-[BX]', Expired_Date__c = null, Start_Date__c = null, UOM__c = 'BX');


        pqiList.add(pqi01);
        pqiList.add(pqi02);
        pqiList.add(pqi03);
        pqiList.add(pqi04);
        pqiList.add(pqi05);
        pqiList.add(pqi06);
        pqiList.add(pqi07);
        pqiList.add(pqi08);
        pqiList.add(pqi09);

        insert pqiList;
        update pqiList;

        Product2 p2 = new Product2(Description = 'Test Prouduct 067', Family = 'Test', IsActive = True, Name = 'P4-06 [EA]', ProductCode = 'P4-06', QAD_pd_mod_date__c = Date.NewInstance(2017,01,01), QAD_pt_part__c = 'P4-06 [EA]', QAD_sourced__c = true, QuantityUnitOfMeasure = 'EA' );
        GlobalTriggerSwitch.runProduct2Trigger = false;
        insert p2;

        PricingQADInput__c pqi10 = new PricingQADInput__c(CustomerNumber__c = '599999', ItemNumber__c = 'P4-06 [BX]' , Name = '599999-P4-06-[BX]', Price_Amount__c = 1 , QADPriceBookID__c = '599999-P4-06-[BX]', Expired_Date__c = null, Start_Date__c = null, UOM__c = 'BX');
        insert pqi10;

    }









    public static void createDRGFacilityRecords(){
        List<DRG_Facility__c> drgFaList = new List<DRG_Facility__c>();
        DRG_Facility__c drgFa01 = new DRG_Facility__c(Beds__c = 41,   Census_Region__c = 'West',       City__c = 'Tuscon',           Country__c = 'United States',   County__c = 'Pima',             Discharges__c = 2215,   Medicare_Provider_ID__c = '999001', Name = 'Test Hospital Facility 999001', Parent_Network_Name__c = 'MedStar Health',      Patient_Days__c = 11844,    Postal_Code__c = '85641',   Revenue__c = 119072764,     Rural_or_Urban__c = 'Urban',    State_Provence__c = 'AZ',   Street_Address__c = '1 Test Avenue');
        DRG_Facility__c drgFa02 = new DRG_Facility__c(Beds__c = 185,  Census_Region__c = 'West',        City__c = 'Tuscon',           Country__c = 'United States',   County__c = 'Pima',             Discharges__c = 26141,  Medicare_Provider_ID__c = '999002', Name = 'Test Hospital Facility 999002', Parent_Network_Name__c = 'MedStar Health',      Patient_Days__c = 146915,   Postal_Code__c = '85641',   Revenue__c = 1307653780,    Rural_or_Urban__c = 'Urban',    State_Provence__c = 'AZ',   Street_Address__c = '2 Test Avenue');
        DRG_Facility__c drgFa03 = new DRG_Facility__c(Beds__c = 283,  Census_Region__c = 'West',        City__c = 'Tuscon',           Country__c = 'United States',   County__c = 'Pima',             Discharges__c = 17426,  Medicare_Provider_ID__c = '999003', Name = 'Test Hospital Facility 999003', Parent_Network_Name__c = 'Tri State Health',    Patient_Days__c = 93146,    Postal_Code__c = '85641',   Revenue__c = 460154476,     Rural_or_Urban__c = 'Urban',    State_Provence__c = 'AZ',   Street_Address__c = '3 Test Avenue');
        DRG_Facility__c drgFa04 = new DRG_Facility__c(Beds__c = 415,  Census_Region__c = 'South',       City__c = 'Little Rock',      Country__c = 'United States',   County__c = 'Pulaski',          Discharges__c = 19582,  Medicare_Provider_ID__c = '999004', Name = 'Test Hospital Facility 999004', Parent_Network_Name__c = 'Tri State Health',    Patient_Days__c = 110613,   Postal_Code__c = '72002',   Revenue__c = 926335000,     Rural_or_Urban__c = 'Urban',    State_Provence__c = 'AR',   Street_Address__c = '4 Test Avenue');
        DRG_Facility__c drgFa05 = new DRG_Facility__c(Beds__c = 311,  Census_Region__c = 'West',        City__c = 'San Francisco',    Country__c = 'United States',   County__c = 'San Francisco',    Discharges__c = 13889,  Medicare_Provider_ID__c = '999005', Name = 'Test Hospital Facility 999005', Parent_Network_Name__c = 'Mega Health ',        Patient_Days__c = 76927,    Postal_Code__c = '94016',   Revenue__c = 527861556,     Rural_or_Urban__c = 'Urban',    State_Provence__c = 'CA',   Street_Address__c = '5 Test Avenue');
        DRG_Facility__c drgFa06 = new DRG_Facility__c(Beds__c = 319,  Census_Region__c = 'North East',  City__c = 'Hartford',         Country__c = 'United States',   County__c = 'Hartford',         Discharges__c = 9835,   Medicare_Provider_ID__c = '999006', Name = 'Test Hospital Facility 999006', Parent_Network_Name__c = 'Mega Health ',        Patient_Days__c = 71972,    Postal_Code__c = '06103',   Revenue__c = 475268563,     Rural_or_Urban__c = 'Urban',    State_Provence__c = 'CT',   Street_Address__c = '6 Test Avenue');
        DRG_Facility__c drgFa07 = new DRG_Facility__c(Beds__c = 79,   Census_Region__c = 'North East',  City__c = 'Wilmington',       Country__c = 'United States',   County__c = 'Wilmington',       Discharges__c = 2864,   Medicare_Provider_ID__c = '999007', Name = 'Test Hospital Facility 999007', Parent_Network_Name__c = 'University Health',   Patient_Days__c = 16862,    Postal_Code__c = '19807',   Revenue__c = 162230028,     Rural_or_Urban__c = 'Urban',    State_Provence__c = 'DE',   Street_Address__c = '7 Test Avenue');
        DRG_Facility__c drgFa08 = new DRG_Facility__c(Beds__c = 31,   Census_Region__c = 'South',       City__c = 'Orlando',          Country__c = 'United States',   County__c = 'New Castle',       Discharges__c = 1598,   Medicare_Provider_ID__c = '999008', Name = 'Test Hospital Facility 999008', Parent_Network_Name__c = 'University Health',   Patient_Days__c = 32789,    Postal_Code__c = '11082',   Revenue__c = 58054654,      Rural_or_Urban__c = 'Urban',    State_Provence__c = 'FL',   Street_Address__c = '8 Test Avenue');
        DRG_Facility__c drgFa09 = new DRG_Facility__c(Beds__c = 205,  Census_Region__c = 'South',       City__c = 'Atlanta',          Country__c = 'United States',   County__c = 'Fulton',           Discharges__c = 14647,  Medicare_Provider_ID__c = '999009', Name = 'Test Hospital Facility 999009', Parent_Network_Name__c = 'St Johns Health',     Patient_Days__c = 30301,    Postal_Code__c = '12302',   Revenue__c = 375484689,     Rural_or_Urban__c = 'Urban',    State_Provence__c = 'GA',   Street_Address__c = '9 Test Avenue');
        DRG_Facility__c drgFa10 = new DRG_Facility__c(Beds__c = 41,   Census_Region__c = 'West',        City__c = 'Honolulu',         Country__c = 'United States',   County__c = 'Honolulu',         Discharges__c = 1027,   Medicare_Provider_ID__c = '999010', Name = 'Test Hospital Facility 999010', Parent_Network_Name__c = 'St Johns Health',     Patient_Days__c = 96795,    Postal_Code__c = '11510',   Revenue__c = 65371107,      Rural_or_Urban__c = 'Urban',    State_Provence__c = 'HI',   Street_Address__c = '10 Test Avenue');

        drgFaList.add(drgFa01);
        drgFaList.add(drgFa02);
        drgFaList.add(drgFa03);
        drgFaList.add(drgFa04);
        drgFaList.add(drgFa05);
        drgFaList.add(drgFa06);
        drgFaList.add(drgFa07);
        drgFaList.add(drgFa08);
        drgFaList.add(drgFa09);
        drgFaList.add(drgFa10);

        insert drgFaList;

    }

    public static void createDRGPhysicianRecords(){
        List<DRG_Physician__c> drgPhList = new List<DRG_Physician__c>();
        DRG_Physician__c drgPh01 =  new DRG_Physician__c(Name = 'OLE',                   NPI_Number__c = '9999999001',   Postal_Code__c = '35649',   Primary_Specialty__c = 'Vascular Surgeon',  State_Provence__c = 'AZ'); 
        DRG_Physician__c drgPh02 =  new DRG_Physician__c(Name = 'BARBARA LEELA',         NPI_Number__c = '9999999002',   Postal_Code__c = '99501',   Primary_Specialty__c = 'Cardiologist',      State_Provence__c = 'AZ'); 
        DRG_Physician__c drgPh03 =  new DRG_Physician__c(Name = 'INGE CHARLEY',          NPI_Number__c = '9999999003',   Postal_Code__c = '85641',   Primary_Specialty__c = 'Radiologist',       State_Provence__c = 'AZ'); 
        DRG_Physician__c drgPh04 =  new DRG_Physician__c(Name = 'JENNIE GUS',            NPI_Number__c = '9999999004',   Postal_Code__c = '72002',   Primary_Specialty__c = 'Neruosurgeon',      State_Provence__c = 'AR'); 
        DRG_Physician__c drgPh05 =  new DRG_Physician__c(Name = 'KLAUS SURESH',          NPI_Number__c = '9999999005',   Postal_Code__c = '94016',   Primary_Specialty__c = 'Vascular Surgeon',  State_Provence__c = 'CA'); 
        DRG_Physician__c drgPh06 =  new DRG_Physician__c(Name = 'ERIC A HAZMA',          NPI_Number__c = '9999999006',   Postal_Code__c = '06103',   Primary_Specialty__c = 'Cardiologist',      State_Provence__c = 'CT'); 
        DRG_Physician__c drgPh07 =  new DRG_Physician__c(Name = 'LAURA MEGHAN SANDER',   NPI_Number__c = '9999999007',   Postal_Code__c = '19807',   Primary_Specialty__c = 'Radiologist',       State_Provence__c = 'DE'); 
        DRG_Physician__c drgPh08 =  new DRG_Physician__c(Name = 'FRANCINE S PATTIE',     NPI_Number__c = '9999999008',   Postal_Code__c = '11082',   Primary_Specialty__c = 'Neruosurgeon',      State_Provence__c = 'FL'); 
        DRG_Physician__c drgPh09 =  new DRG_Physician__c(Name = 'ZEKE W ALBERT WARNER',         NPI_Number__c = '9999999009',   Postal_Code__c = '12302',   Primary_Specialty__c = 'Vascular Surgeon',  State_Provence__c = 'GA'); 
        DRG_Physician__c drgPh10 =  new DRG_Physician__c(Name = 'HONG LEE',              NPI_Number__c = '9999999010',   Postal_Code__c = '11510',   Primary_Specialty__c = 'Cardiologist',      State_Provence__c = 'HI');

        drgPhList.add(drgPh01);
        drgPhList.add(drgPh02);
        drgPhList.add(drgPh03);
        drgPhList.add(drgPh04);
        drgPhList.add(drgPh05);
        drgPhList.add(drgPh06);
        drgPhList.add(drgPh07);
        drgPhList.add(drgPh08);
        drgPhList.add(drgPh09);
        drgPhList.add(drgPh10);

        insert drgPhList;

    }


    public static void createDRGProcedureRecords(){
        List<DRG_Procedure__c> drgPrList = new List<DRG_Procedure__c>();
        DRG_Procedure__c drgPr01 = new DRG_Procedure__c(    Medicare__c = '999001',     Physician_NPI__c = '9999999001',    Name = '999001-9999999001-2015',    Period__c = '2015',     CAS__c = 5,     CEA__c = 9); 
        DRG_Procedure__c drgPr02 = new DRG_Procedure__c(    Medicare__c = '999001',     Physician_NPI__c = '9999999001',    Name = '999001-9999999001-2016',    Period__c = '2016',     CAS__c = 7,     CEA__c = 8); 
        DRG_Procedure__c drgPr03 = new DRG_Procedure__c(    Medicare__c = '999001',     Physician_NPI__c = '9999999001',    Name = '999001-9999999001-2017',    Period__c = '2017',     CAS__c = 2,     CEA__c = 9); 
        DRG_Procedure__c drgPr04 = new DRG_Procedure__c(    Medicare__c = '999001',     Physician_NPI__c = '9999999001',    Name = '999001-9999999001-2018',    Period__c = '2018',     CAS__c = 7,     CEA__c = 4); 
        DRG_Procedure__c drgPr05 = new DRG_Procedure__c(    Medicare__c = '999002',     Physician_NPI__c = '9999999002',    Name = '999002-9999999002-2015',    Period__c = '2015',     CAS__c = 2,     CEA__c = 0); 
        DRG_Procedure__c drgPr06 = new DRG_Procedure__c(    Medicare__c = '999002',     Physician_NPI__c = '9999999002',    Name = '999002-9999999002-2016',    Period__c = '2016',     CAS__c = 9,     CEA__c = 9); 
        DRG_Procedure__c drgPr07 = new DRG_Procedure__c(    Medicare__c = '999002',     Physician_NPI__c = '9999999002',    Name = '999002-9999999002-2017',    Period__c = '2017',     CAS__c = 7,     CEA__c = 4); 
        DRG_Procedure__c drgPr08 = new DRG_Procedure__c(    Medicare__c = '999002',     Physician_NPI__c = '9999999002',    Name = '999002-9999999002-2018',    Period__c = '2018',     CAS__c = 4,     CEA__c = 7); 
        DRG_Procedure__c drgPr09 = new DRG_Procedure__c(    Medicare__c = '999003',     Physician_NPI__c = '9999999003',    Name = '999003-9999999003-2015',    Period__c = '2015',     CAS__c = 8,     CEA__c = 5); 
        DRG_Procedure__c drgPr10 = new DRG_Procedure__c(    Medicare__c = '999003',     Physician_NPI__c = '9999999003',    Name = '999003-9999999003-2016',    Period__c = '2016',     CAS__c = 6,     CEA__c = 7); 
        DRG_Procedure__c drgPr11 = new DRG_Procedure__c(    Medicare__c = '999003',     Physician_NPI__c = '9999999003',    Name = '999003-9999999003-2017',    Period__c = '2017',     CAS__c = 10,    CEA__c = 4); 
        DRG_Procedure__c drgPr12 = new DRG_Procedure__c(    Medicare__c = '999003',     Physician_NPI__c = '9999999003',    Name = '999003-9999999003-2018',    Period__c = '2018',     CAS__c = 7,     CEA__c = 4); 
        DRG_Procedure__c drgPr13 = new DRG_Procedure__c(    Medicare__c = '999004',     Physician_NPI__c = '9999999004',    Name = '999004-9999999004-2015',    Period__c = '2015',     CAS__c = 4,     CEA__c = 7); 
        DRG_Procedure__c drgPr14 = new DRG_Procedure__c(    Medicare__c = '999004',     Physician_NPI__c = '9999999004',    Name = '999004-9999999004-2016',    Period__c = '2016',     CAS__c = 3,     CEA__c = 6); 
        DRG_Procedure__c drgPr15 = new DRG_Procedure__c(    Medicare__c = '999004',     Physician_NPI__c = '9999999004',    Name = '999004-9999999004-2017',    Period__c = '2017',     CAS__c = 6,     CEA__c = 8); 
        DRG_Procedure__c drgPr16 = new DRG_Procedure__c(    Medicare__c = '999004',     Physician_NPI__c = '9999999004',    Name = '999004-9999999004-2018',    Period__c = '2018',     CAS__c = 0,     CEA__c = 7); 
        DRG_Procedure__c drgPr17 = new DRG_Procedure__c(    Medicare__c = '999005',     Physician_NPI__c = '9999999005',    Name = '999005-9999999005-2015',    Period__c = '2015',     CAS__c = 5,     CEA__c = 6); 
        DRG_Procedure__c drgPr18 = new DRG_Procedure__c(    Medicare__c = '999005',     Physician_NPI__c = '9999999005',    Name = '999005-9999999005-2016',    Period__c = '2016',     CAS__c = 9,     CEA__c = 8); 
        DRG_Procedure__c drgPr19 = new DRG_Procedure__c(    Medicare__c = '999005',     Physician_NPI__c = '9999999005',    Name = '999005-9999999005-2017',    Period__c = '2017',     CAS__c = 9,     CEA__c = 6); 
        DRG_Procedure__c drgPr20 = new DRG_Procedure__c(    Medicare__c = '999005',     Physician_NPI__c = '9999999005',    Name = '999005-9999999005-2018',    Period__c = '2018',     CAS__c = 7,     CEA__c = 0); 
        DRG_Procedure__c drgPr21 = new DRG_Procedure__c(    Medicare__c = '999005',     Physician_NPI__c = '9999999005',    Name = '999005-9999999005-2017',    Period__c = '2017',     CAS__c = 3,     CEA__c = 4); 
        DRG_Procedure__c drgPr22 = new DRG_Procedure__c(    Medicare__c = '999005',     Physician_NPI__c = '9999999005',    Name = '999005-9999999005-2018',    Period__c = '2018',     CAS__c = 4,     CEA__c = 7); 
        DRG_Procedure__c drgPr23 = new DRG_Procedure__c(    Medicare__c = '999006',     Physician_NPI__c = '9999999006',    Name = '999006-9999999006-2015',    Period__c = '2015',     CAS__c = 9,     CEA__c = 7); 
        DRG_Procedure__c drgPr24 = new DRG_Procedure__c(    Medicare__c = '999006',     Physician_NPI__c = '9999999006',    Name = '999006-9999999006-2016',    Period__c = '2016',     CAS__c = 1,     CEA__c = 6); 
        DRG_Procedure__c drgPr25 = new DRG_Procedure__c(    Medicare__c = '999006',     Physician_NPI__c = '9999999006',    Name = '999006-9999999006-2017',    Period__c = '2017',     CAS__c = 0,     CEA__c = 7); 
        DRG_Procedure__c drgPr26 = new DRG_Procedure__c(    Medicare__c = '999006',     Physician_NPI__c = '9999999006',    Name = '999006-9999999006-2018',    Period__c = '2018',     CAS__c = 7,     CEA__c = 3); 
        DRG_Procedure__c drgPr27 = new DRG_Procedure__c(    Medicare__c = '999007',     Physician_NPI__c = '9999999007',    Name = '999007-9999999007-2015',    Period__c = '2015',     CAS__c = 2,     CEA__c = 5); 
        DRG_Procedure__c drgPr28 = new DRG_Procedure__c(    Medicare__c = '999007',     Physician_NPI__c = '9999999007',    Name = '999007-9999999007-2016',    Period__c = '2016',     CAS__c = 2,     CEA__c = 1); 
        DRG_Procedure__c drgPr29 = new DRG_Procedure__c(    Medicare__c = '999007',     Physician_NPI__c = '9999999007',    Name = '999007-9999999007-2017',    Period__c = '2017',     CAS__c = 4,     CEA__c = 4); 
        DRG_Procedure__c drgPr30 = new DRG_Procedure__c(    Medicare__c = '999007',     Physician_NPI__c = '9999999007',    Name = '999007-9999999007-2018',    Period__c = '2018',     CAS__c = 2,     CEA__c = 8); 
        DRG_Procedure__c drgPr31 = new DRG_Procedure__c(    Medicare__c = '999008',     Physician_NPI__c = '9999999008',    Name = '999008-9999999008-2016',    Period__c = '2016',     CAS__c = 3,     CEA__c = 6); 
        DRG_Procedure__c drgPr32 = new DRG_Procedure__c(    Medicare__c = '999008',     Physician_NPI__c = '9999999008',    Name = '999008-9999999008-2017',    Period__c = '2017',     CAS__c = 1,     CEA__c = 5); 
        DRG_Procedure__c drgPr33 = new DRG_Procedure__c(    Medicare__c = '999008',     Physician_NPI__c = '9999999008',    Name = '999008-9999999008-2018',    Period__c = '2018',     CAS__c = 1,     CEA__c = 6); 
        DRG_Procedure__c drgPr34 = new DRG_Procedure__c(    Medicare__c = '999009',     Physician_NPI__c = '9999999009',    Name = '999009-9999999009-2017',    Period__c = '2017',     CAS__c = 3,     CEA__c = 5); 
        DRG_Procedure__c drgPr35 = new DRG_Procedure__c(    Medicare__c = '999009',     Physician_NPI__c = '9999999009',    Name = '999009-9999999009-2018',    Period__c = '2018',     CAS__c = 6,     CEA__c = 7); 
        DRG_Procedure__c drgPr36 = new DRG_Procedure__c(    Medicare__c = '999010',     Physician_NPI__c = '9999999010',    Name = '999010-9999999010-2018',    Period__c = '2018',     CAS__c = 2,     CEA__c = 6); 
   

        drgPrList.add(drgPr01);
        drgPrList.add(drgPr02);
        drgPrList.add(drgPr03);
        drgPrList.add(drgPr04);
        drgPrList.add(drgPr05);
        drgPrList.add(drgPr06);
        drgPrList.add(drgPr07);
        drgPrList.add(drgPr08);
        drgPrList.add(drgPr09);
        drgPrList.add(drgPr10);
        drgPrList.add(drgPr11);
        drgPrList.add(drgPr12);
        drgPrList.add(drgPr13);
        drgPrList.add(drgPr14);
        drgPrList.add(drgPr15);
        drgPrList.add(drgPr16);
        drgPrList.add(drgPr17);
        drgPrList.add(drgPr18);
        drgPrList.add(drgPr19);
        drgPrList.add(drgPr20);
        drgPrList.add(drgPr21);
        drgPrList.add(drgPr22);
        drgPrList.add(drgPr23);
        drgPrList.add(drgPr24);
        drgPrList.add(drgPr25);
        drgPrList.add(drgPr26);
        drgPrList.add(drgPr27);
        drgPrList.add(drgPr28);
        drgPrList.add(drgPr29);
        drgPrList.add(drgPr30);
        drgPrList.add(drgPr31);
        drgPrList.add(drgPr32);
        drgPrList.add(drgPr33);
        drgPrList.add(drgPr34);
        drgPrList.add(drgPr35);
        drgPrList.add(drgPr36); 

        insert drgPrList;        
    }




    public static void createDRGLinkedAccountsAndContacts(){
        List<Account> acctList = new List<Account>();
        List<Contact> contList = new List<Contact>();
        Id acctRtId = [SELECT ID FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Customer' LIMIT 1].Id;
        Id contRtId = [SELECT ID FROM RecordType WHERE SObjectType = 'Contact' AND Name = 'Physician' LIMIT 1].Id;

        Account acct01 = new Account(Name = 'Test Hospital Facility 999001', Medicare_Provider_ID__c = '999001', QAD_cm_addr__c = '599901', RecordTypeId = acctRtId, Is_Converted_Customer__c = True );
        Account acct02 = new Account(Name = 'Test Hospital Facility 999002', Medicare_Provider_ID__c = '999002', QAD_cm_addr__c = '599902', RecordTypeId = acctRtId, Is_Converted_Customer__c = True );
        Account acct03 = new Account(Name = 'Test Hospital Facility 999003', Medicare_Provider_ID__c = '999003', QAD_cm_addr__c = '599903', RecordTypeId = acctRtId, Is_Converted_Customer__c = True );

        acctList.add(acct01);
        acctList.add(acct02);
        acctList.add(acct03);

        insert acctList;

        Contact cont01 = new Contact(FirstName = 'OLE',     LastName = 'OLE',   NPI_Number__c = '9999999001',   RecordTypeId = contRtId, AccountId = acct01.Id); 
        Contact cont02 = new Contact(FirstName = 'BARBARA', LastName = 'LEELA', NPI_Number__c = '9999999002',   RecordTypeId = contRtId, AccountId = acct02.Id);

        contList.add(cont01);
        contList.add(cont02);

        insert contList; 
    }    
    

}