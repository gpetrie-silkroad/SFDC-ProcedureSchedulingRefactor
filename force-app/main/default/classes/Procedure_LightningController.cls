public without sharing class Procedure_LightningController {

    public static Id physicianContactId(){
        Id rtId = [SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND Name = 'Physician' LIMIT 1].Id;
        return rtId;
    } 

   
    @AuraEnabled
    public static List<Procedure_Form__c> getProcedureForm(){
        List<Procedure_Form__c> procFormList = [SELECT Account__c,
                                                                AD_Present__c,
                                                                Additional_Physician_s__c,
                                                                Additional_Physician_1__c,
                                                                Additional_Physician_Fellow__c,
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
                                                                Event_ActivityDate__c,
                                                                Event_Attached__c,
                                                                Event_EndDateTime__c,
                                                                Event_Local_End_TIme__c,
                                                                Event_Local_Start_Time__c,
                                                                Event_Local_Time_Zone__c,
                                                                Event_Location_Info__c,
                                                                Event_Other_Information__c,
                                                                Event_StartDateTIme__c,
                                                                EventIds__c,
                                                                Filter_Photo_Taken__c,
                                                                Fluoro_Time_mGy__c,
                                                                Fluoro_Time_minutes__c,
                                                                Glyccopyrrolate__c,
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
                                                                LastModifiedById,
                                                                Local_Complications__c,
                                                                MPK_Dialator__c,
                                                                MPK_Manufacturer__c,
                                                                MPK_Size__c,
                                                                Name,
                                                                Needle_Length__c,
                                                                No_SRM_Personnel_Present__c,
                                                                No_Pre_Case_Id__c,
                                                                NPS_Lot_No__c,
                                                                NPS_Version__c,
                                                                Number_of_Stents_Used__c,
                                                                Other_Arterial_Sheath_Placement_Wire__c,
                                                                Other_Local_Complications__c,
                                                                Other_Qualified_SRM_Present__c,
                                                                Other_Stent_1_Type__c,
                                                                Other_Stent_2_Type__c,
                                                                OwnerId,
                                                                Patient_Age__c,
                                                                Patient_Gender__c,
                                                                Patient_Id__c,
                                                                Pre_Case_Id__c,
                                                                Post_Dialation_Balloon_Size__c,
                                                                Pre_Dilation_Balloon_Size__c,
                                                                Procedure_Completion__c,
                                                                Procedure_Date__c,
                                                                Procedure_Type__c,
                                                                Reason_Aborted__c,
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
                                                                Wire_Technique__c 
                                                        FROM    Procedure_Form__c
                                                        WHERE ID = 'a001g000001399h'];
            for(Procedure_Form__c pf: procFormList){
                pf.Pre_Case_Id__c = 'SRM-';
            }
        return procFormList;
    }




    @AuraEnabled
    public static Account getAccount(Id acctId){
        Account acct = [SELECT ID, IQMS_Customer_Number__c, Name, BillingStreet, BillingCity, BillingState, Vendor_Credential_Company__c, Time_Zone__c FROM Account WHERE Id = : acctId];
        return acct;
    }



    @AuraEnabled
    public static List<Contact> getPhysician(Id inputId, Id accountId){
        Contact nullContact;
        if(inputId == null){
            nullContact = new Contact(FirstName = '- None ', LastName = 'Selected');
        }
        else{
            nullContact = [SELECT FirstName, LastName, Id FROM Contact WHERE Id = : inputId];
        }

        //Gather List of Physicians at the hospital
        List<Hospital_Affiliation__c> haList = [SELECT Id, Physician__c, Hospital__c FROM Hospital_Affiliation__c WHERE Hospital__c = : accountId];
        Set<Id> physicianIdSet = new Set<Id>();
        for(Hospital_Affiliation__c ha : haList){
            physicianIdSet.add(ha.Physician__c);
        }


        Id physicianRecordTypeId = physicianContactId();

        List<Contact> adContList = [SELECT Id, FirstName, 
                                                LastName,
                                                MiddleName, 
                                                Name, 
                                                Account.Name, 
                                                AccountId 
                                    FROM        Contact 
                                    WHERE       RecordTypeId =: physicianRecordTypeId 
                                    AND         Id IN : physicianIdSet
                                    ORDER BY    LastName ASC];

        List<Contact> contList = new List<Contact>();
        contList.add(nullContact);
        contList.addAll(adContList);

        return contList;

    }


    @AuraEnabled
    public static List<Contact> getProctors(Id inputId, Id accountId){
        Id physicianRecordTypeId = physicianContactId();
        Contact nullContact;
        if(inputId == null){
            nullContact = new Contact(FirstName = '- None ', LastName = 'Selected ');
        }
        else{
            nullContact = [SELECT FirstName, LastName, Id FROM Contact WHERE Id = : inputId];
        }

        //Gather List of Physicians at the hospital
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
                                    WHERE       (RecordTypeId =: physicianRecordTypeId
                                    AND             is_External_Proctor__c = true)
                                    OR          (RecordTypeId =: physicianRecordTypeId
                                    AND             is_Internal_Proctor__c = true
                                    AND             AccountId IN : physicianIDSet) 
                                    ORDER BY    LastName ASC];

        List<Contact> contList = new List<Contact>();
        contList.add(nullContact);
        contList.addAll(adContList);

        return contList;
    }


    @AuraEnabled
    public static List<Contact> getStenters(Id inputId, Id accountId){
        Contact nullContact;
        if(inputId == null){
            nullContact = new Contact(FirstName = '- None ', LastName = 'Selected');
        }
        else{
            nullContact = [SELECT FirstName, LastName, Id FROM Contact WHERE Id = : inputId];
        }

        //Gather List of Physicians at the hospital
        List<Hospital_Affiliation__c> haList = [SELECT Id, Physician__c, Hospital__c FROM Hospital_Affiliation__c WHERE Hospital__c = : accountId];
        Set<Id> physicianIdSet = new Set<Id>();
        for(Hospital_Affiliation__c ha : haList){
            physicianIdSet.add(ha.Physician__c);
        }


        Id physicianRecordTypeId = physicianContactId();

        List<Contact> adContList = [SELECT Id, FirstName, 
                                                LastName,
                                                MiddleName, 
                                                Name, 
                                                Account.Name, 
                                                AccountId 
                                    FROM        Contact 
                                    WHERE       RecordTypeId =: physicianRecordTypeId 
                                    AND         Id IN : physicianIdSet
                                    AND         (Sent_Training_Date__c <> null 
                                    OR           Legacy_TCAR_Trained_during_Round_1__c = true)
                                    ORDER BY    LastName ASC];

        List<Contact> contList = new List<Contact>();
        contList.add(nullContact);
        contList.addAll(adContList);

        return contList;

    }




    @AuraEnabled
    public static List<Contact> getCutdown(Id inputId, Id accountId){
        Contact nullContact;
        if(inputId == null){
            nullContact = new Contact(FirstName = '- None ', LastName = 'Selected');
        }
        else{
            nullContact = [SELECT FirstName, LastName, Id FROM Contact WHERE Id = : inputId];
        }

        //Gather List of Physicians at the hospital
        List<Hospital_Affiliation__c> haList = [SELECT Id, Physician__c, Hospital__c FROM Hospital_Affiliation__c WHERE Hospital__c = : accountId];
        Set<Id> physicianIdSet = new Set<Id>();
        for(Hospital_Affiliation__c ha : haList){
            physicianIdSet.add(ha.Physician__c);
        }


        Id physicianRecordTypeId = physicianContactId();

        List<Contact> adContList = [SELECT Id, FirstName, 
                                                LastName,
                                                MiddleName, 
                                                Name, 
                                                Account.Name, 
                                                AccountId 
                                    FROM        Contact 
                                    WHERE       RecordTypeId =: physicianRecordTypeId 
                                    AND         Id IN : physicianIdSet
                                    AND         ((Test_Drive__c <> null OR (Sent_Training_Date__c <> null AND (Internal_Proctored__c <> null OR External_Proctored__c <> null)))
                                    OR          Legacy_TCAR_Trained_during_Round_1__c = true
                                    OR          Is_TCAR_Certified__c = True)
                                    ORDER BY    LastName ASC];

        List<Contact> contList = new List<Contact>();
        contList.add(nullContact);
        contList.addAll(adContList);

        return contList;

    }




    @AuraEnabled
    public static String getSiteName(Id acctId){
        Account a = [SELECT Id, Name FROM Account WHERE Id = : acctId LIMIT 1];
        String returnString;
        if(a.Name == null){
            returnString = 'SITE NOT SET';
        }
        else{
            returnString = a.Name;
        }
        return returnString;
    }


    @AuraEnabled
    public static Procedure_Form__c saveProcedureForm(Procedure_Form__c procedureForm){
        upsert procedureForm;
        return procedureForm;
    }






    @AuraEnabled
    public static User getCurrentUser(){
        Id curUserId = UserInfo.getUserId();
        User currentUser = [SELECT Id, FirstName, LastName, Field_Responsibility__c, Profile.Name FROM User WHERE Id = : curUserId];
        return currentUser;
    }

    @AuraEnabled 
    public static List<User> getAMUsers(){
        User nullUser = new User(Id = null, FirstName = '- None ', LastName = 'Selected -');
        user currUser = getCurrentUser();
        List<User> userList = new List<User>();

        List<User> amUserList = [SELECT Id, FirstName, LastName FROM User
                                                                WHERE isActive = true
                                                                AND Field_Responsibility__c = 'Area Manager'
                                                                AND Id <> : currUser.Id
                                                                ORDER BY LastName ASC];

        if(currUser.Field_Responsibility__c == 'Area Manager'){
            userList.add(currUser);
            userList.add(nullUser);
            userList.addAll(amUserList);
        }
        else{
            userList.add(nullUser);
            userList.addAll(amUserList);
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
    public static List<User> getSMQualUsers(){
        User nullUser = new User(FirstName = '- None ', LastName = 'Selected -');
        List<User> qualUserList = [SELECT Id, FirstName, LastName FROM User
                                                                WHERE isActive = true
                                                                AND   Qualified_to_Proctor_Procedures__c = true
                                                                ORDER BY LastName ASC];
        List<User> userList = new List<User>();
        userList.add(nullUser);
        userList.addAll(qualUserList);

        return userList;
    }


    @AuraEnabled 
    public static List<User> getTDUsers(){
        User nullUser = new User(Id = null, FirstName = '- None ', LastName = 'Selected -');
        user currUser = getCurrentUser();
        List<User> userList = new List<User>();

        List<User> tdsUserList = [SELECT Id, FirstName, LastName FROM User
                                                                WHERE (isActive = true)
                                                                AND   Id <> :currUser.Id
                                                                AND   ((Field_Responsibility__c = 'Therapy Development Specialist')
                                                                OR    (UserName = 'gmarien@silkroadmed.com' OR UserName = 'jlindsay@silkroadmed.com'
                                                                         OR UserName = 'gmarien@silkroadmed.com.srdevpc' OR UserName = 'jlindsay@silkroadmed.com.srdevpc'))
                                                                ORDER BY LastName ASC];

        if(currUser.Field_Responsibility__c == 'Therapy Development Specialist'){
            userList.add(currUser);
            userList.add(nullUser);
            userList.addAll(tdsUserList);
        }
        else{
            userList.add(nullUser);
            userList.addAll(tdsUserList);
        }

        return userList;
    }




        @AuraEnabled 
    public static List<User> getSecondaryTDUsers(Id inputId, String selectedTds2){
        //SYSTEM.DEBUG('Input Id = [' + inputId + ']');
        if(selectedTds2 == 'none'){
            selectedTds2 = null;
        }
        user selectedUser;
        User currentUser = getCurrentUser();
        User nullUser = new User(FirstName = '- None ', LastName = 'Selected -');
    
        List<User> tdUserList = [SELECT Id, FirstName, LastName FROM User
                                                                WHERE (isActive = true)
                                                                AND Id <> : currentUser.Id
                                                                AND Id <> : inputId
                                                                AND   ((Field_Responsibility__c = 'Therapy Development Specialist')
                                                                OR    (UserName = 'gmarien@silkroadmed.com' OR UserName = 'jlindsay@silkroadmed.com'
                                                                         OR UserName = 'gmarien@silkroadmed.com.srdevpc' OR UserName = 'jlindsay@silkroadmed.com.srdevpc'))
                                                                ORDER BY LastName ASC];
        List<User> userList = new List<User>();

        if(selectedTds2 != null){
            selectedUser = [SELECT Id, FirstName, LastName FROM User WHERE Id = : selectedTds2];

            userList.add(selectedUser);
            userList.add(nullUser);
            userList.addAll(tdUserList);
        }
        else{
            userList.add(nullUser);
            userList.addAll(tdUserList);
        }

        return userList;
    }





    @AuraEnabled 
    public static List<User> getADUsers(){
        User nullUser = new User(Id = null, FirstName = '- None ', LastName = 'Selected -');
        user currUser = getCurrentUser();
        List<User> userList = new List<User>();

        List<User> adUserList = [SELECT Id, FirstName, LastName FROM User
                                                                WHERE isActive = true
                                                                AND   Id <> : currUser.Id
                                                                AND   Field_Responsibility__c = 'Area Director'
                                                                AND   UserName <> 'gmarien@silkroadmed.com' AND UserName <> 'jlindsay@silkroadmed.com'
                                                                AND   UserName <> 'gmarien@silkroadmed.com.srdevpc' AND UserName <> 'jlindsay@silkroadmed.com.srdevpc'
                                                                ORDER BY LastName ASC];


        if(currUser.Field_Responsibility__c == 'Area Director'){
            userList.add(currUser);
            userList.add(nullUser);
            userList.addAll(adUserList);
        }
        else{
            userList.add(nullUser);
            userList.addAll(adUserList);
        }

        return userList;
    }

    




    @AuraEnabled
    public static String getUIThemeDescription(){
        String theme = UserInfo.getUiThemeDisplayed();
        return theme;
    }



    @AuraEnabled
    public static Contact getPhysicianRecord(Id physId){

        Contact c = [SELECT Id, Name, FirstName, MiddleName, LastName, Fellow__c FROM Contact WHERE Id = : physId LIMIT 1];
        
        return c;

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
    public static List<TimeConversionList__c> getTimeList(){
        List<TimeConversionList__c> timeList = [SELECT SortOrder__c, Time24__c, Name FROM TimeConversionList__c ORDER BY SortOrder__c ASC];
        return timeList;
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
    public static String createProcedureAppointment(Procedure_Form__c newProcedureForm,
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

    /*    String appointmentId = CalendarAndEvent_Utilities.createNewProcedureEvent(newProcedureForm,
                                                            null,
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
        String appointmentId;
        return appointmentId;
    }
        
}