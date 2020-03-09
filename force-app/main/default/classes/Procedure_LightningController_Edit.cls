public without sharing class Procedure_LightningController_Edit {
    
 
    public static Id physicianContactId(){
        Id rtId = [SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND Name = 'Physician' LIMIT 1].Id;
        return rtId;
    }
       
    @AuraEnabled
    public static Procedure_Form__c getProcedureForm(Id inputId) {
        Procedure_Form__c procForm = [SELECT Account__c,
                                                                Account__r.Name,
                                                                Account__r.IQMS_Customer_Number__c,
                                                                Account__r.Vendor_Credential_Company__c,
                                                                AD_Present__c,
                                                                Additional_Physician_1__c,
                                                                Additional_Physician_s__c,
                                                                Additional_Physician_2__c,
                                                                Additional_Physician_Fellow__c,
                                                                Additional_Physician_2_Fellow__c,
                                                                AM_Present__c,
                                                                Anesthesia__c,
                                                                Arterial_Sheath_Access__c,
                                                                Arterial_Sheath_Placement_Wire__c,
                                                                Atropene__c,
                                                                Atropine_Glyuco__c,
                                                                Case_Type__c,
                                                                Comments__c,
                                                                Contrast_Used__c,
                                                                Converted_to_GA__c,
                                                                CreatedById,
                                                                Cutdown_Physician__c,
                                                                Debris_in_Filter__c,
                                                                Dissection_Step__c,
                                                                Dissection_Type__c,
                                                                Enroute__c,
                                                                ENROUTE_Delivery_System_Removal__c,
                                                                ENROUTE_Stint_Deployment__c,
                                                                Filter_Photo_Taken__c,
                                                                Fluoro_Time_mGy__c,
                                                                Fluoro_Time_minutes__c,
                                                                Glyccopyrrolate__c,
                                                                Guidewire_Manufacturer__c,
                                                                HRC_ANA_BILA__c,
                                                                HRC_ANA_CAD__c,
                                                                HRC_ANA_CEA__c,
                                                                HRC_ANA_CONT__c,
                                                                HRC_ANA_HIGH__c,
                                                                HRC_ANA_HOST__c,
                                                                HRC_ANA_LARYN__c,
                                                                HRC_ANA_NONE__c,
                                                                HRC_ANA_SPIN__c,
                                                                HRC_ANA_TAND__c,
                                                                HRC_CLIN_NONE__c,
                                                                HRC_CLN_AGE__c,
                                                                HRC_CLN_ANG__c,
                                                                HRC_CLN_CCS__c,
                                                                HRC_CLN_CHF__c,
                                                                HRC_CLN_CNI__c,
                                                                HRC_CLN_COPD__c,
                                                                HRC_CLN_DIAB__c,
                                                                HRC_CLN_HEART__c,
                                                                HRC_CLN_LVEF__c,
                                                                HRC_CLN_MI__c,
                                                                HRC_CLN_RENA__c,
                                                                HRC_CLN_STRESS__c,
                                                                HRC_CLN_SURG__c,
                                                                Id,
                                                                LastModifiedById,
                                                                Local_Complications__c,
                                                                MPK_Dialator__c,
                                                                MPK_Manufacturer__c,
                                                                MPK_Size__c,
                                                                Name,
                                                                Needle_Length__c,
                                                                No_SRM_Personnel_Present__c,
                                                                NPS_Lot_No__c,
                                                                NPS_Version__c,
                                                                Number_of_Stents_Used__c,
                                                                Other_Arterial_Sheath_Placement_Wire__c,
                                                                Other_Local_Complications__c,
                                                                Other_MPK_Manufacturer__c,
                                                                Other_Pre_Dil_Balloon_Size__c,
                                                                Other_Post_Dil_Balloon_Size__c,
                                                                Other_Qualified_SRM_Present__c,
                                                                Other_Stent_1_Type__c,
                                                                Other_Stent_2_Type__c,
                                                                OwnerId,
                                                                Patient_Age__c,
                                                                Patient_Gender__c,
                                                                Patient_Id__c,
                                                                Physician_Primary_Operator__c,
                                                                Post_Dialation_Balloon_Size__c,
                                                                Pre_Case_Id__c,
                                                                No_Pre_Case_Id__c,
                                                                Pre_Dilation_Balloon_Size__c,
                                                                Procedure_Completion__c,
                                                                Procedure_Date__c,
                                                                Procedure_Type__c,
                                                                Reason_Aborted__c,
                                                                Reason_for_Turning_Procedure_Down__c,
                                                                Reverse_Flow_Time__c,
                                                                Secondary_TDS_Present__c,
                                                                Skin_to_Skin_Time__c,
                                                                SRM_Proctor__c,
                                                                Stent_1_Size__c,
                                                                Stent_No_1_Type__c,
                                                                Stent_No_2_Type__c,
                                                                Stenter__c,
                                                                Stint_1_Lot_Number__c,
                                                                Stint_2_Lot_Number__c,
                                                                Stint_2_Size__c,
                                                                Symptomatic__c,
                                                                Target_Vessel__c,
                                                                TDS_Present__c,
                                                                Toleration_of_Reverse_Flow__c,
                                                                Use_of_Interventional_Tools__c,
                                                                Vendor_Credential_Company__c,
                                                                Wire_Technique__c 
                                                        FROM    Procedure_Form__c
                                                        WHERE ID = : inputId];                                          
        return procForm;
        
    }


    @AuraEnabled
    public static List<Account> getAccountList(Id inputId){

        Account nullAccount = [SELECT Name, IQMS_Customer_Number__c, Id FROM Account 
                                                            WHERE   id = : inputId
                                                            AND     RecordType.SObjectType = 'Account'
                                                            AND     RecordType.Name = 'Customer' ORDER BY IQMS_Customer_Number__c];
        List<Account> accountList;

        User currUser = getCurrentUser();
        Id currUserId = currUser.Id;
            
                accountList = [SELECT Name, IQMS_Customer_Number__c, Id FROM Account 
                                                            WHERE RecordType.SObjectType = 'Account'
                                                            AND   RecordType.Name = 'Customer' ORDER BY IQMS_Customer_Number__c];

                              

            List<Account> accountList1 = new List<Account>();
            accountList1.add(nullAccount);
            accountList1.addAll(accountList);
            return accountList1;
    }


    @AuraEnabled
    public static Procedure_Form__c saveProcedureForm(Procedure_Form__c simpleRecord){
        SYSTEM.DEBUG('GOT THIS FAR');
        update simpleRecord;
        return simpleRecord;
    }



    @AuraEnabled
    public static String getIqmsCustomerNumber(Id acctId){
        Account acct = [SELECT Id, Name, IQMS_Customer_Number__c FROM Account WHERE ID = : acctId LIMIT 1];
        return acct.IQMS_Customer_Number__c;
    }





    @AuraEnabled
    public static String getSiteName(Id acctId){
        Account a = [SELECT Id, Name FROM Account WHERE Id = : acctId LIMIT 1];
        String returnString;
        returnString = a.Name;
        return returnString;
    }


    @AuraEnabled
    public static User getCurrentUser(){
        Id curUserId = UserInfo.getUserId();
        User currentUser = [SELECT Id, FirstName, LastName, Profile.Name, Field_Responsibility__c FROM User WHERE Id = : curUserId];
        return currentUser;
    }




    @AuraEnabled 
    public static List<User> getTDSUsers(Id tdsPresValue){
        User nullUser = new User(FirstName = '- None ', LastName = 'Selected -');
        user currUser = getCurrentUser();

        Boolean fieldRespMatch = false;
        if(currUser.Field_Responsibility__c == 'Therapy Development Specialist'){
            fieldRespMatch = true;
        }

        List<User> userList = new List<User>();

        List<User> tdUserList = [SELECT Id, FirstName, LastName FROM User
                                                                WHERE isActive = true
                                                                AND   Field_Responsibility__c = 'Therapy Development Specialist'
                                                                AND   UserName <> 'gmarien@silkroadmed.com' AND UserName <> 'jlindsay@silkroadmed.com'
                                                                AND   Id <> : tdsPresValue
                                                                ORDER BY LastName ASC];

        if(tdsPresValue == null && fieldRespMatch){
            userList.add(currUser);
            userList.add(nullUser);
            userList.addAll(tdUserList);
        }
        else if(tdsPresValue == null){
            userList.add(nullUser);
            userList.addAll(tdUserList);
        }
        else{
            User userFromInputId = [SELECT FirstName, LastName, Id FROM USER WHERE Id = : tdsPresValue];
            userList.add(userFromInputId);
            userList.add(nullUser);
            userList.addAll(tdUserList);
        }

        return userList;
    }




    @AuraEnabled 
    public static List<User> getSecondaryTDUsers(String tds2PresValue, String tdsPresValue){
        User nullUser = new User(FirstName = '- None ', LastName = 'Selected -');
        User userFromInputId;

        if(tds2PresValue != null && tds2PresValue != 'none' && tds2PresValue != ''){
            userFromInputId = [SELECT FirstName, LastName, Id FROM USER WHERE Id = : tds2PresValue];
        }

        User currUser = getCurrentUser();

        List<User> userList = new List<User>();

        List<User> tdUserList = [SELECT Id, FirstName, LastName FROM User
                                                                WHERE isActive = true
                                                                AND   Id <> : tds2PresValue
                                                                AND   Id <> : tdsPresValue
                                                                AND   Id <> : currUser.Id
                                                                AND   Field_Responsibility__c = 'Therapy Development Specialist'
                                                                AND   UserName <> 'gmarien@silkroadmed.com' AND UserName <> 'jlindsay@silkroadmed.com' ORDER BY LastName ASC];


        if(tds2PresValue == null || tds2PresValue == '' || tds2PresValue == 'none'){
            userList.add(nullUser);
            userList.addAll(tdUserList);
        }
        else{
            userList.add(userFromInputId);
            userList.add(nullUser);
            userList.addAll(tdUserList);
        }

        return userList;
    }





    @AuraEnabled 
    public static List<User> getAMUsers(Id amPresValue){
        User nullUser = new User(Id = null, FirstName = '- None ', LastName = 'Selected -');
        user currUser = getCurrentUser();
        
        Boolean fieldRespMatch = false;
        if(currUser.Field_Responsibility__c == 'Area Manager'){
            fieldRespMatch = true;
        }

        List<User> userList = new List<User>();

        List<User> amUserList = [SELECT Id, FirstName, LastName FROM User
                                                                WHERE isActive = true
                                                                AND   Field_Responsibility__c = 'Area Manager'
                                                                AND   Id <> : currUser.Id
                                                                AND   Id <> : amPresValue
                                                                ORDER BY LastName ASC];

        if(amPresValue == null && fieldRespMatch){
            userList.add(currUser);
            userList.add(nullUser);
            userList.addAll(amUserList);
        }
        else if(amPresValue == null){
            userList.add(nullUser);
            userList.addAll(amUserList);
        }
        else{
            User userFromInputId = [SELECT FirstName, LastName, Id FROM USER WHERE Id = : amPresValue];
            userList.add(userFromInputId);
            userList.add(nullUser);
            userList.addAll(amUserList);
        }       
        return userList;
    }




    @AuraEnabled 
    public static List<User> getADUsers(Id adPresValue){
        User nullUser = new User(Id = null, FirstName = '- None ', LastName = 'Selected -');
        user currUser = getCurrentUser();

        Boolean fieldRespMatch = false;
        if(currUser.Field_Responsibility__c == 'Area Director'){
            fieldRespMatch = true;
        }

        List<User> userList = new List<User>();

        List<User> adUserList = [SELECT Id, FirstName, LastName FROM User
                                                                WHERE isActive = true
                                                                AND   Field_Responsibility__c = 'Area Director'
                                                                AND   UserName <> 'gmarien@silkroadmed.com' AND UserName <> 'jlindsay@silkroadmed.com'
                                                                AND   UserName <> 'gmarien@silkroadmed.com.srdevpc' AND UserName <> 'jlindsay@silkroadmed.com.srdevpc'
                                                                //AND   Id <> : currUser.Id
                                                                AND   Id <> : adPresValue
                                                                ORDER BY LastName ASC];

        if(adPresValue == null && fieldRespMatch){
            userList.add(currUser);
            userList.add(nullUser);
            userList.addAll(adUserList);
        }
        else if(adPresValue == null){
            userList.add(nullUser);
            userList.addAll(adUserList);
        }
        else{
            User userFromInputId = [SELECT FirstName, LastName, Id FROM USER WHERE Id = : adPresValue];
            userList.add(userFromInputId);
            userList.add(nullUser);
            userList.addAll(adUserList);
        }

            return userList;
    }



    @AuraEnabled 
    public static List<User> getDisUsers(){
        User nullUser = new User(FirstName = '- DISABLED -');
        List<User> userList = new List<User>();
        userList.add(nullUser);
        return userList;
    }


    @AuraEnabled 
    public static List<User> getSMQualUsers(Id qualPresValue){
        User nullUser = new User(Id = null, FirstName = '- None ', LastName = 'Selected -');
        user currUser = getCurrentUser();

        List<User> userList = new List<User>();

        List<User> adUserList = [SELECT Id, FirstName, LastName FROM User
                                                                WHERE isActive = true
                                                                AND   Id <> : qualPresValue
                                                                AND   (Qualified_to_Proctor_Procedures__c = true
                                                                OR      (UserName = 'gmarien@silkroadmed.com' OR UserName = 'jlindsay@silkroadmed.com'
                                                                         OR UserName = 'gmarien@silkroadmed.com.srdevpc' OR UserName = 'jlindsay@silkroadmed.com.srdevpc'))
                                                                ORDER BY LastName ASC];

        if(qualPresValue == null){
            userList.add(nullUser);
            userList.addAll(adUserList);
        }
        else{
            User userFromInputId = [SELECT FirstName, LastName, Id FROM USER WHERE Id = : qualPresValue];
            userList.add(userFromInputId);
            userList.add(nullUser);
            userList.addAll(adUserList);
        }

        return userList;
    }




    @AuraEnabled
    public static List<Contact> getProctors(Id inputId, Id accountId){
        Id physicianRecordTypeId = physicianContactId();
        Contact nullContact = new Contact(FirstName = '- None ', LastName = 'Selected');

        Contact selectedContact;

        List<Contact> contList = new List<Contact>();

        List<Hospital_Affiliation__c> haList = [SELECT Id, Physician__c, Hospital__c FROM Hospital_Affiliation__c WHERE Hospital__c = : accountId];
        
        Set<Id> physicianIdSet = new Set<Id>();
        
        for(Hospital_Affiliation__c ha : haList){
            physicianIdSet.add(ha.Physician__c);
        }

        List<Contact> adContList = [SELECT Id, FirstName,
                                                MiddleName, 
                                                LastName, 
                                                Name, 
                                                Account.Name, 
                                                AccountId 
                                    FROM        Contact 
                                    WHERE       ((RecordTypeId =: physicianRecordTypeId
                                    AND             is_External_Proctor__c = true)
                                    OR          (RecordTypeId =: physicianRecordTypeId
                                    AND             is_Internal_Proctor__c = true
                                    AND             AccountId IN : physicianIDSet))
                                    AND         Id <> : inputId
                                    ORDER BY    LastName Asc];


        if(inputId == null){
            contList.add(nullContact);
            contList.addAll(adContList);
            
        }
        else{
            selectedContact = [SELECT FirstName, MiddleName, LastName, Account.Name, Id FROM Contact WHERE Id = : inputId];

            contList.add(selectedContact);
            contList.add(nullContact);
            contList.addAll(adContList);
        }

        return contList;
    }





    @AuraEnabled
    public static List<Contact> getPhysPrimOpList(Id inputId, Id accountId){
        Id physicianRecordTypeId = physicianContactId();
        Contact nullContact = new Contact(FirstName = '- None ', LastName = 'Selected');

        Contact selectedContact;

        List<Contact> contList = new List<Contact>();

        List<Hospital_Affiliation__c> haList = [SELECT Id, Physician__c, Hospital__c FROM Hospital_Affiliation__c WHERE Hospital__c = : accountId];
        Set<Id> physicianIdSet = new Set<Id>();

        for(Hospital_Affiliation__c ha : haList){
            physicianIdSet.add(ha.Physician__c);
        }

        List<Contact> adContList = [SELECT Id, FirstName, 
                                                LastName,
                                                MiddleName, 
                                                Name, 
                                                Account.Name, 
                                                AccountId 
                                    FROM        Contact 
                                    WHERE       RecordTypeId =: physicianRecordTypeId 
                                    AND         ((Test_Drive__c <> null OR (Sent_Training_Date__c <> null AND (Internal_Proctored__c <> null OR External_Proctored__c <> null)))
                                    OR          Legacy_TCAR_Trained_during_Round_1__c = true
                                                )
                                    AND         Id IN : physicianIdSet
                                    AND         Id <> : inputId
                                    ORDER BY    LastName Asc];

        if(inputId == null){
            contList.add(nullContact);
            contList.addAll(adContList);
        }
        else{
            selectedContact = [SELECT FirstName, MiddleName, LastName, Account.Name, Id FROM Contact WHERE Id = : inputId];

            contList.add(selectedContact);
            contList.add(nullContact);
            contList.addAll(adContList);
        }

        return contList;

    }






    @AuraEnabled
    public static List<Contact> getStenters(Id inputId, Id accountId){

        Id physicianRecordTypeId = physicianContactId();
        Contact nullContact = new Contact(FirstName = '- None ', LastName = 'Selected');

        Contact selectedContact;

        List<Contact> contList = new List<Contact>();

        List<Hospital_Affiliation__c> haList = [SELECT Id, Physician__c, Hospital__c FROM Hospital_Affiliation__c WHERE Hospital__c = : accountId];
        Set<Id> physicianIdSet = new Set<Id>();
        for(Hospital_Affiliation__c ha : haList){
            physicianIdSet.add(ha.Physician__c);
        }

        List<Contact> adContList = [SELECT Id, FirstName, 
                                                LastName,
                                                MiddleName, 
                                                Name, 
                                                Account.Name, 
                                                AccountId 
                                    FROM        Contact 
                                    WHERE       RecordTypeId =: physicianRecordTypeId 
                                    AND         Id <> : inputId
                                    AND         Id IN : physicianIdSet
                                    AND         (Sent_Training_Date__c <> null
                                    OR          Legacy_TCAR_Trained_during_Round_1__c = true
                                                )
                                    ORDER BY    LastName Asc];

        if(inputId == null){
            contList.add(nullContact);
            contList.addAll(adContList);
        }
        else{
            selectedContact = [SELECT FirstName, MiddleName, LastName, Account.Name, Id FROM Contact WHERE Id = : inputId];

            contList.add(selectedContact);
            contList.add(nullcontact);
            contList.addAll(adContList);
        }

        return contList;

    }




   
    @AuraEnabled
    public static List<Contact> getCutdown(Id inputId, Id accountId){
        
        Id physicianRecordTypeId = physicianContactId();
        Contact nullContact = new Contact(FirstName = '- None ', LastName = 'Selected');

        Contact selectedContact;

        List<Contact> contList = new List<Contact>();

        List<Hospital_Affiliation__c> haList = [SELECT Id, Physician__c, Hospital__c FROM Hospital_Affiliation__c WHERE Hospital__c = : accountId];
        Set<Id> physicianIdSet = new Set<Id>();
        for(Hospital_Affiliation__c ha : haList){
            physicianIdSet.add(ha.Physician__c);
        }

        List<Contact> adContList = [SELECT Id, FirstName, 
                                                LastName,
                                                MiddleName, 
                                                Name, 
                                                Account.Name, 
                                                AccountId 
                                    FROM        Contact 
                                    WHERE       RecordTypeId =: physicianRecordTypeId 
                                    AND         Id <> : inputId
                                    AND         ((Test_Drive__c <> null OR (Sent_Training_Date__c <> null AND (Internal_Proctored__c <> null OR External_Proctored__c <> null)))
                                    OR          Legacy_TCAR_Trained_during_Round_1__c = true
                                    OR          Is_TCAR_Certified__c = True)
                                    AND         Id IN : physicianIdSet
                                    ORDER BY    LastName Asc];


        if(inputId == null){
            contList.add(nullContact);
            contList.addAll(adContList);
        }
        else{
            selectedContact = [SELECT FirstName, MiddleName, LastName, Account.Name, Id FROM Contact WHERE Id = : inputId];

            contList.add(selectedContact);
            contList.add(nullContact);
            contList.addAll(adContList);
        }

        return contList;

    }








    @AuraEnabled
    public static List<Contact> getAddl1(Id recordId, Id accountId){
        
        Id physicianRecordTypeId = physicianContactId();
        Contact nullContact = new Contact(FirstName = '- None ', LastName = 'Selected');

        Contact selectedContact;

        List<Contact> contList = new List<Contact>();

        List<Hospital_Affiliation__c> haList = [SELECT Id, Physician__c, Hospital__c FROM Hospital_Affiliation__c WHERE Hospital__c = : accountId];
        Set<Id> physicianIdSet = new Set<Id>();
        for(Hospital_Affiliation__c ha : haList){
            physicianIdSet.add(ha.Physician__c);
        }

        List<Contact> adContList = [SELECT Id, FirstName, 
                                                LastName,
                                                MiddleName, 
                                                Name, 
                                                Account.Name, 
                                                AccountId 
                                    FROM        Contact 
                                    WHERE       RecordTypeId =: physicianRecordTypeId
                                    AND         Id <> : recordId
                                    AND         Id IN : physicianIdSet
                                    ORDER BY    LastName Asc];

        if(recordId == null){
            contList.add(nullContact);
            contList.addAll(adContList);    
        }
        else{
            selectedContact = [SELECT FirstName, MiddleName, LastName, Account.Name,  Id FROM Contact WHERE Id = : recordId];

            contList.add(selectedContact);
            contList.add(nullContact);
            contList.addAll(adContList);
        }

        return contList;
    }





    @AuraEnabled
    public static String getUIThemeDescription(){
        String theme = UserInfo.getUiThemeDisplayed();
        return theme;
    }





    @AuraEnabled
    public static List<Contact> getPhysician(Id recordId, Id accountId){
        
        Id physicianRecordTypeId = physicianContactId();
        Contact nullContact = new Contact(FirstName = '- None ', LastName = 'Selected');

        Contact selectedContact;

        List<Contact> contList = new List<Contact>();

        List<Hospital_Affiliation__c> haList = [SELECT Id, Physician__c, Hospital__c FROM Hospital_Affiliation__c WHERE Hospital__c = : accountId];
        Set<Id> physicianIdSet = new Set<Id>();
        for(Hospital_Affiliation__c ha : haList){
            physicianIdSet.add(ha.Physician__c);
        }

        List<Contact> adContList = [SELECT Id, FirstName, 
                                                LastName,
                                                MiddleName, 
                                                Name, 
                                                Account.Name, 
                                                AccountId 
                                    FROM        Contact 
                                    WHERE       RecordTypeId =: physicianRecordTypeId 
                                    AND         Id <> : recordId
                                    AND         Id IN : physicianIdSet
                                    ORDER BY    LastName Asc];

        if(recordId == null){
            contList.add(nullContact);
            contList.addAll(adContList);
        }
        else{
            selectedContact = [SELECT FirstName, MiddleName, LastName, Account.Name, Id FROM Contact WHERE Id = : recordId];

            contList.add(selectedContact);
            contList.add(nullContact);
            contList.addAll(adContList);
        }

        return contList;

    }








    @AuraEnabled
    public static Contact getPhysicianRecord(Id physId){
        if(physId != null){
            Contact c = [SELECT Id, Name, FirstName, MiddleName, LastName, Fellow__c FROM Contact WHERE Id = : physId LIMIT 1];
            return c;
        }
        else{
            return null;
        }

    }










        @AuraEnabled
    public static void createNewContact(Contact regForm1,
                                    Id accountId
                                    ){
        
     
        if(regForm1.LastName != null && accountId != null){
            Id currUserId = UserInfo.getUserId();
            Id physRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Contact' AND Name = 'Physician' LIMIT 1].Id;

            regForm1.OwnerId = currUserId;
            regForm1.RecordTypeId = physRecordTypeId;
            regForm1.AccountId = accountId;

            insert regForm1;

         } 
    }





    @AuraEnabled
    public static String getCurrentTime(){
        DateTime nowTime = System.Now();
        String yr = String.valueOf(nowTime.Year());
        String mo;
        if(nowTime.Month() < 10){mo = '0' + String.ValueOf(nowTime.Month());} else {mo = String.ValueOf(nowTime.Month());}
        String dy;
        if(nowTime.Day() < 10){dy = '0' + String.ValueOf(nowTime.Day());} else {dy = String.ValueOf(nowTime.Day());}
        String hr;
        if(nowTime.Hour() < 10){hr = '0' + String.ValueOf(nowTime.Hour());} else {hr = String.ValueOf(nowTime.Hour());}
        String mn;
        if(nowTime.Minute() < 10){mn = '0' + String.ValueOf(nowTime.Minute());} else {mn = String.ValueOf(nowTime.Minute());}
        String sc;
        if(nowTime.Second() < 10){sc = '0' + String.ValueOf(nowTime.Second());} else {sc = String.ValueOf(nowTime.Second());}
        String nowTimeStr = yr + '-' + mo + '-' + dy + 'T' + hr + ':' + mn + ':' + sc;
        return nowTimeStr;
    }



 
    @AuraEnabled
    public static List<TimeConversionList__c> getTimeList(){
        List<TimeConversionList__c> timeList = [SELECT SortOrder__c, Time24__c, Name FROM TimeConversionList__c ORDER BY SortOrder__c ASC];
        return timeList;
    }
       
  



     @AuraEnabled
     public static List<Event> getExistingSchedule(String recordId){

         List<Event> eventList = [SELECT Id, 
                                            OwnerId,
                                            Owner.Name,
                                            ProcedureFormId__c,
                                            ShowAs,
                                            StartDateTime,
                                            endDateTime,
                                            Location,
                                            Local_Time_Zone__c,
                                            Location_Info__c,
                                            Description,
                                            Other_Information__c,
                                            Subject,
                                            Vendor_Credential_Company__c,
                                            WhatCount,
                                            WhatId,
                                            WhoCount,
                                            WhoId 
                                    FROM    Event
                                    WHERE   ProcedureFormId__c = : recordId];
    

            for(Event e : eventList){

                String localTimeZone;
                if(e.Local_Time_Zone__c == 'Eastern'){ localTimeZone = 'America/New_York'; }
                  else if(e.Local_Time_Zone__c == 'Central'){ localTimeZone = 'America/Chicago'; }
                  else if(e.Local_Time_Zone__c == 'Mountain'){ localTimeZone = 'America/Denver'; }
                  else if(e.Local_Time_Zone__c == 'Pacific'){ localTimeZone = 'America/Los_Angeles'; }
                  else if(e.Local_Time_Zone__c == 'Arizona'){ localTimeZone = 'America/Phoenix'; }
                  else if(e.Local_Time_Zone__c == 'Alaska'){ localTimeZone = 'America/Anchorage'; }
                  else if(e.Local_Time_Zone__c == 'Hawaii'){ localTimeZone = 'Pacific/Honolulu'; }

                  Timezone tz = Timezone.getTimeZone(localTimeZone);
                  Integer localOffset = tz.getOffset(e.StartDateTime)/3600000;

                SYSTEM.DEBUG('* * * * Start time = [' + e.StartDateTime + '] Local TIme Zone = [' + e.Local_Time_Zone__c + '] = Translated Time Zone = [' + localTimeZone + '] Offset = [' + localOffset + ']');

                e.startDateTime = e.StartDateTime.addHours(localOffset);
                e.endDateTime = e.EndDateTime.addHours(localOffset);
            }                               

        return eventList;                           
     }






    @AuraEnabled
    public static Account getAccount(Id acctId){
        Account acct = [SELECT ID, IQMS_Customer_Number__c, Name, BillingStreet, BillingCity, BillingState, Vendor_Credential_Company__c, Time_Zone__c FROM Account WHERE Id = : acctId];
        return acct;
    }








    @AuraEnabled
    public static void deleteRelatedEvent(String procedureFormRecordId,
                                                            String eventId,
                                                            String procedureDate,
                                                            String timeZoneString,
                                                            String startTime,
                                                            String endTime,
                                                            String localStartTime,
                                                            String localEndTime,
                                                            String localTimeZone,
                                                            String accountId,
                                                            String locInformation,
                                                            String primaryAmId,
                                                            String primaryTdsId,
                                                            String secondaryTdsId,
                                                            String otherQualifiedSrmId,
                                                            String adId,
                                                            String primaryOpPhysicianId,
                                                            String otherInformation,
                                                            String vendorCredentailCompany,
                                                            String dmlAction){

        SYSTEM.DEBUG('* * * * * * * * DELETE EVENT STARTED * * * * * * * *');                                                   
                                                                
        updateProcedureAppointment(procedureFormRecordId,
                                    eventId,
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
                                    dmlAction);

        List<Event> eventList = [SELECT Id FROM Event WHERE Id = : eventId OR ProcedureFormId__c = : procedureFormRecordId];
        delete eventList;

        SYSTEM.DEBUG(' * * * * * * * * DELETE EVENT ENDED * * * * * * * * ');
    }









    @AuraEnabled
    public static String createProcedureAppointment(Procedure_Form__c procedureForm,
                                                            String eventId,
                                                            String procedureDate,
                                                            String timeZoneString,
                                                            String startTime,
                                                            String endTime,
                                                            String localStartTime,
                                                            String localEndTime,
                                                            String localTimeZone,
                                                            String accountId,
                                                            String locInformation,
                                                            String primaryAmId,
                                                            String primaryTdsId,
                                                            String secondaryTdsId,
                                                            String otherQualifiedSrmId,
                                                            String adId,
                                                            String primaryOpPhysicianId,
                                                            String otherInformation,
                                                            String vendorCredentailCompany,
                                                            String dmlAction
                                                            ){

     /*   String appointmentId = CalendarAndEvent_Utilities.createNewProcedureEvent(procedureForm,
                                                                                    eventId,
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
                                                                                    dmlAction
                                                                                    ); 
    */

        if(otherInformation == 'null'){otherInformation = '';}

        string appointmentId;
        
        return appointmentId;
    }    











    @AuraEnabled
    public static String updateProcedureAppointment(String procedureFormRecordId,
                                                            String eventId,
                                                            String procedureDate,
                                                            String timeZoneString,
                                                            String startTime,
                                                            String endTime,
                                                            String localStartTime,
                                                            String localEndTime,
                                                            String localTimeZone,
                                                            String accountId,
                                                            String locInformation,
                                                            String primaryAmId,
                                                            String primaryTdsId,
                                                            String secondaryTdsId,
                                                            String otherQualifiedSrmId,
                                                            String adId,
                                                            String primaryOpPhysicianId,
                                                            String otherInformation,
                                                            String vendorCredentailCompany,
                                                            String dmlAction
                                                            ){

        String returnString = CalendarAndEvent_Utilities.updatePrimaryProcedureAppointment(procedureFormRecordId, 
                                                                                            eventId, 
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
                                                                                            dmlAction);
                                                                                                                                                        
        return returnString;
                                                           
    }






    public static void buildAndSendInvite(Set<String> sendTo, 
                                        String subject,
                                        String locInformation,
                                        String otherInformation,
                                        String localStartTime,
                                        String localEndTime,
                                        String localTimeZone,
                                        DateTime startDateTime,
                                        DateTime endDateTime,
                                        String eventId,
                                        String proFormId,
                                        String sentFrom,
                                        String srmAttendees,
                                        Integer sequence,
                                        String dmlAction
                                        ){
        SendEmail se = new SendEmail();
        se.sendTo = sendTo;
        se.Subject = subject;

        String currentIcsTimeString = convertDateTimeToIcsString(SYSTEM.now());
        String StartIcsTimeString = convertDateTimeToIcsString(startDateTime);
        String EndIcsTimeString = convertDateTimeToIcsString(endDateTime);

        se.sendInvite(  localStartTime,
                        localEndTime,   
                        localTimeZone,
                        startIcsTimeString,
                        endIcsTimeString,
                        currentIcsTimeString,
                        sentFrom,
                        sendTo,
                        eventId,
                        proFormId, 
                        subject,
                        locInformation,
                        srmAttendees,
                        sequence,
                        dmlAction,
                        otherInformation);
    }



    public class SendEmail {
        public Set<String> sendTo { get; set; }
        public String Subject { get; set; }
        public Event objEvent{get;set;}
        public SendEmail() {}
        public PageReference sendInvite(String localStartTime,
                                        String localEndTime,
                                        String LocalTimeZone,
                                        String startIcsTimeString,
                                        String endIcsTimeString,
                                        String currentIcsTime,
                                        String organizerEmail,
                                        Set<String> inviteeEmail,
                                        String sfdcEventId,
                                        String sfdcProcId, 
                                        String subject,
                                        String location,
                                        String srmAttendees,
                                        Integer sequence,
                                        String dmlAction,
                                        String otherInformation) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> toAddresses = new List<String>(sendTo);
            //toAddresses = sendTo;
            mail.setToAddresses(toAddresses);
            mail.setSubject(Subject);

            String domain = String.valueOf(System.Url.getSalesforceBaseUrl().toExternalForm());
            domain = domain.replace('.', ',');
            domain = domain.split(',')[0];

            Date procedureDate = [SELECT Id, Procedure_Date__c FROM Procedure_Form__c WHERE ID = :sfdcProcId LIMIT 1].Procedure_Date__c;
            String procedureDateString = String.valueOf(procedureDate);
            String emailBody;

            if(dmlAction != 'CANCELLED'){
                emailBody = 'HOSPITAL LOCAL SCHEDULE: \n';
            }
            else{
                emailBody = '* * * C A N C E L L E D    P R O C E D U R E * * *  \n Original Schedule:  \n';
            
            }
            emailBody += '  Procedure Date: ' + procedureDateString + '\n';
            emailBody += '  Start Time: ' + localStartTime + ' ' + localTimeZone + '\n';
            emailBody += '  End Time:   ' + localEndTime  + ' ' + localTimeZone + '\n';
            emailBody += '\n';  
            emailBody += 'LOCATION: \n' + location + '\n';
            emailBody += '\n';
            emailBody += 'SRM PERSONNEL \n' + srmAttendees;
            emailBody += '\n\n';
            emailBody += 'LINK TO PROCEDURE FORM: \n' + domain + '.lightning.force.com/lightning/r/Procedure_Form__c/' + sfdcProcId + '/view' ;
            
            if(dmlAction != 'CANCELLED'){
                emailBody += '\n\n';
                emailBody += 'LINK TO PROCEDURE SFDC EVENT: \n' + domain + '.lightning.force.com/lightning/r/Event/' + sfdcEventId + '/view' ;
            } 

            emailBody += '\n\n';
            emailBody += 'OTHER INFORMATION: \n' +  otherInformation ;


            mail.setPlainTextBody(emailBody);
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.filename = 'meeting.ics';
            attach.ContentType ='text/calendar; charset=utf-8; method=REQUEST';
            attach.inline = true;
            attach.body = invite(startIcsTimeString,
                                endIcsTimeString,
                                currentIcsTime,
                                organizerEmail,
                                toAddresses,
                                sequence,
                                dmlAction,
                                sfdcEventId, 
                                subject,
                                location);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach});
            Messaging.SendEmailResult[] er = Messaging.sendEmail(new Messaging.Email[] {mail});
            return null;
        }
        private Blob invite(String startIcsTimeString,
                                String endIcsTimeString,
                                String currentIcsTimeString,
                                String organizerEmail,
                                String[] inviteeEmail,
                                Integer sequence,
                                String dmlAction,
                                String sfdcEventId, 
                                String subject,
                                string location) {

            String txtInvite = '';
    
            txtInvite += 'BEGIN:VCALENDAR\n';
            txtInvite += 'PRODID:-//Google Inc//Google Calendar 70.9054//EN\n';
            txtInvite += 'VERSION:2.0\n';
            txtInvite += 'CALSCALE:GREGORIAN\n';
            txtInvite += 'METHOD:REQUEST\n';
            txtInvite += 'TZ:+00\n'; 
            txtInvite += 'BEGIN:VEVENT\n';
            txtInvite += 'DTSTART:' + startIcsTimeString + '\n';
            
            txtInvite += 'DTEND:' + endIcsTimeString + '\n';
            txtInvite += 'DTSTAMP:' + currentIcsTimeString + '\n';
            txtInvite += 'ORGANIZER;CN=' + organizerEmail + ':mailto:' + organizerEmail + '\n';

            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            
            txtInvite += 'UID:' + baseURL + '/' + sfdcEventId + '\n';

            Integer i =  inviteeEmail.size();

            for(String s : inviteeEmail){
                if(s == organizerEmail){
                    txtInvite += 'ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=FALSE;CN=\"' + s + '\";X-NUM-GUESTS=' + i + ':mailto:' + s + '\n';
                }
                else{
                    txtInvite += 'ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;CN=\"' + s + '\";X-NUM-GUESTS=' + i + ':mailto:' + s + '\n';
                }
            }

            txtInvite += 'COMMENT;LANGUAGE=en-US:www.cnn.com\n'; 
            txtInvite += 'X-MICROSOFT-CDO-OWNERAPPTID:-2136020037\n';
            txtInvite += 'CREATED:' + currentIcsTimeString + '\n';
            txtInvite += 'DESCRIPTION:www.cnn.com\n\n-::~:~::~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~::~:~::-\nPlease do not edit this section of the description.\n\nView your event at https://www.google.com/calendar/event?action=VIEW&eid=NGk2bDVnbHFrbmd0YWJ0cG11YzFyamtkZXIgZ3BldHJpZUBzaWxrcm9h ZG1lZC5jb20&tok=MjUjZ29yZG9uLm0ucGV0cmllQGdtYWlsLmNvbTQ0ZWRmNzNkZjU2NGJjYmM zNTQ5ZTg4NGM4NWVhNzM0ZThiYTBjOTc&ctz=America%2FLos_Angeles&hl=en&es=1.\n-::~:~::~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~::~:~::-\n';
            txtInvite += 'LAST-MODIFIED:' + currentIcsTimeString + '\n';
 
            txtInvite += 'SEQUENCE:' + sequence + '\n';
            if(dmlAction == 'CANCELLED'){
                txtInvite += 'STATUS:CANCELLED' +  '\n';
            }
            txtInvite += 'SUMMARY:TEST INVITE FROM GOOGLE\n';
            txtInvite += 'TRANSP:OPAQUE\n';
            txtInvite += 'END:VEVENT\n';
            txtInvite += 'END:VCALENDAR\n';

            return Blob.valueOf(txtInvite);
        }
    }






    public static Integer calculateOffset(String timeZoneString, DateTime inputDT){
        Timezone tz = Timezone.getTimeZone(timeZoneString);   
        Integer i = Integer.valueOf(tz.getOffset(inputDt)/3600000);
        return i;  
    }




    public static integer calculateDuation(DateTime time1, DateTime time2){
        Integer time1ms = Integer.valueOf(time1.getTime());
        Integer time2ms = Integer.valueOf(time2.getTime());

        Integer difms = math.abs(time1ms - time2ms);
        Integer difsc = difms/1000;
        Integer difmn = difsc/60;

        return difmn;
    }






    public static Date stringToDateConverter(String inputString){
        String[] dateStringList = inputString.split('-');
        Integer yrInt = Integer.valueOf(dateStringList[0]);
        Integer moInt = Integer.valueOf(dateStringList[1]);
        Integer dyInt = Integer.valueOf(dateStringList[2]);

        Date resultDate = Date.newInstance(yrInt, moInt, dyInt);
        
        return resultDate;
    
    }






    public static DateTime stringToDateTimeConverter(String inputDateString, String InputTimeString){

           // TimeZone tz_ny = TimeZone.getTimeZone('America/New_York');

            // SPLIT DATE STRING INTO YEAR, MONTH AND DAY:
            String[] dateStringList = inputDateString.split('-');
            Integer yrInt = Integer.valueOf(dateStringList[0]);
            Integer moInt = Integer.valueOf(dateStringList[1]);
            Integer dyInt = Integer.valueOf(dateStringList[2]);

            // SPLIT TIME STRING INTO HOURS AND MINUTES
            String[] timeStringList = inputTimeString.split(':');
            Integer hrInt = Integer.valueOf(timeStringList[0]);
            Integer mnInt = Integer.valueOf(timeStringList[1]);

            DateTime resultDateTime = Datetime.newInstanceGMT(yrInt, moInt, dyInt, hrInt, mnInt, 0);
            SYSTEM.DEBUG(' * * * * * * * * * * Resulting DateTime = [' + resultDateTime + '] * * * * * * * * * * ');

            return resultDateTime;

    }





    public static String convertDateTimeToIcsString(dateTime inputDateTime){
        String returnTimeString;
        String yr = String.valueOf(inputDateTime.YearGMT());
        String mo;
        if(inputDateTime.MonthGMT() < 10){mo = '0' + String.ValueOf(inputDateTime.MonthGMT());} else {mo = String.ValueOf(inputDateTime.MonthGMT());}
        String dy;
        if(inputDateTime.DayGMT() < 10){dy = '0' + String.ValueOf(inputDateTime.DayGMT());} else {dy = String.ValueOf(inputDateTime.DayGMT());}
        String hr;
        if(inputDateTime.HourGMT() < 10){hr = '0' + String.ValueOf(inputDateTime.HourGMT());} else {hr = String.ValueOf(inputDateTime.HourGMT());}
        String mn;
        if(inputDateTime.MinuteGMT() < 10){mn = '0' + String.ValueOf(inputDateTime.MinuteGMT());} else {mn = String.ValueOf(inputDateTime.MinuteGMT());}
        String sc;
        if(inputDateTime.SecondGMT() < 10){sc = '0' + String.ValueOf(inputDateTime.SecondGMT());} else {sc = String.ValueOf(inputDateTime.SecondGMT());}
        returnTimeString = yr + mo  + dy + 'T' + hr + mn + sc + 'Z';
        return returnTimeString;

    }




    public static DateTime dateTimeGMT(DateTime inputDateTime, Integer offset){

        SYSTEM.DEBUG(' * * * * * DATE TIME GMT * * * InputDateTime =[' + inputDateTime + '] Offset = [' + offset + ']');
        DateTime timeGMT = inputDateTime.addHours(-offset);
        SYSTEM.DEBUG(' * * * * * DATE TIME GMT RESULTING * * * Output Date Time = [' + timeGMT + ']');
        return timeGMT;
    }

}