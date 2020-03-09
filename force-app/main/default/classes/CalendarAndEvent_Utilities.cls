public without sharing class CalendarAndEvent_Utilities {

    /************************************************************************************************************************************************************************************************/
    public static Map<String, Id> makeEventRecordTypeMap(){
        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Event'];
        Map<String, Id> recordTypeMap = new Map<String, Id>();
        for(RecordType rt : rtList){
            recordTypeMap.put(rt.Name, rt.Id);
        }

        return recordTypeMap;
    }










    public static Map<Id, User> makeUserMap(){

        List<User> userList = [SELECT Id, Email, FirstName, LastName FROM User WHERE IsActive = true AND Email <> null];
        Map<Id, User> userMap = new Map<Id, User>();
        for(User u : userList){
            userMap.put(u.Id, u);
        }

        return userMap;

    }










    public static Map<Id, String> makeEmailMap(){
        Map<id, String> emailMap = new Map<id, String>();
        List<User> userList = [SELECT Id, Email, FirstName, LastName FROM User WHERE IsActive = true AND Email <> null];
        for(User u : userList){
            emailMap.put(u.Id, u.Email);
        }

        return emailMap;

    }







    public static Map<Id, Id> publicTerritoryCalendarMap(){

        List<Territory__c> territoryList = [SELECT Id, Calendar__c FROM Territory__c WHERE Calendar__c <> null];
        Map<Id, Id> publicTerritoryCalendarMap = new Map<Id, Id>();
        for(Territory__c t : territoryList){
            publicTerritoryCalendarMap.put(t.Id, t.Calendar__c);
        }

        return publicTerritoryCalendarMap;
    }










    public static void updateExistingProcedureEvent(Map<Id, Procedure_Form__c> oldPfMap, Map<Id, Procedure_Form__c> newPfMap){
        
    }









    public static void cancelExistingProcedureEvent(Map<Id, Procedure_Form__c> oldPfMap, Map<Id, Procedure_Form__c> newPfMap){

    }










    public static void createNewProcedureEvent(List<Procedure_Form__c> inputProcedureFormList){


        //COLLECT BULK QUERY INFORMATION                                                                                            
        String userId = UserInfo.getUserId();
        Map<String, Id> eventRecordTypeMap = makeEventRecordTypeMap();
        Id procedureEventRecordType = eventRecordTypeMap.get('Procedure');
        Map<Id, User> userMap = makeUserMap();

        Set<Id> accountIds = new Set<Id>();
        Set<Id> physicianIds = new Set<Id>();

        for(Procedure_Form__c pf : inputProcedureFormList){
            if(pf.Account__c != null){
                accountIds.add(pf.Account__c);      
            }
            if(pf.Physician_Primary_Operator__c != null){
                physicianIds.add(pf.Physician_Primary_Operator__c);
            }
        }

        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name, AccountNumber, SFDCTerritoryId__r.Calendar__c FROM Account WHERE Id IN : accountIds]);
        Map<Id, Contact> physicianMap = new Map<Id, Contact>([SELECT Id, FirstName, LastName FROM Contact WHERE ID IN : physicianIds]);

        //Loop through Procedure_Form Records and Create Events
        for(Procedure_Form__c pf : inputProcedureFormList){
            Account account = accountMap.get(pf.Account__c);
            Contact physician = physicianMap.get(pf.Physician_Primary_Operator__c);

            Set<String> toEmailSet = new Set<String>();
            String subjectAttendeeString = ' ';
            String attendeesInfoString = 'Primary AM: ';
            String organizerEmail;
            String accountName = account.Name;
            String physicianName = 'Dr. ' + physician.FirstName.Left(1) + ' ' + physician.LastName;
            Id publicCalendarId = account.SFDCTerritoryId__r.Calendar__c;
            Set<Id> privateCalendarIdSet = new Set<Id>();

            if(pf.AM_Present__c != null){
                User amUser = userMap.get(pf.AM_Present__c);
                subjectAttendeeString += amUser.FirstName.Left(1) + '.' + amUser.LastName + ' ';
                attendeesInfoString += amUser.FirstName + amUser.LastName;
                toEmailSet.add(amUser.Email);
                privateCalendarIdSet.add(amUser.Id);
            }
            attendeesInfoString += '\nPrimary TDS: ';
            if(pf.TDS_Present__c != null){
                User tdsUser = userMap.get(pf.TDS_Present__c);
                subjectAttendeeString += tdsUser.FirstName.Left(1) + '.' + tdsUser.LastName + ' ';
                attendeesInfoString += tdsUser.FirstName + tdsUser.LastName;
                toEmailSet.add(tdsUser.Email);
                privateCalendarIdSet.add(tdsUser.Id);
            }
            attendeesInfoString += '\nSecondary TDS: ';
            if(pf.Secondary_TDS_Present__c != null){
                User tds2User = userMap.get(pf.Secondary_TDS_Present__c);
                subjectAttendeeString += tds2User.FirstName.Left(1) + '.' + tds2User.LastName + ' ';
                attendeesInfoString += tds2User.FirstName + tds2User.LastName;
                toEmailSet.add(tds2User.Email);
                privateCalendarIdSet.add(tds2User.Id);
            }
            attendeesInfoString += '\nAD: ';
            if(pf.AD_Present__c != null){
                User adUser = userMap.get(pf.AD_Present__c);
                subjectAttendeeString += adUser.FirstName.Left(1) + '.' + adUser.LastName + ' ';
                attendeesInfoString += adUser.FirstName + adUser.LastName;
                toEmailSet.add(adUser.Email);
                privateCalendarIdSet.add(adUser.Id);
            }
            attendeesInfoString += '\nOther SRM: ';
            if(pf.Other_Qualified_SRM_Present__c != null){
                User oqUser = userMap.get(pf.Other_Qualified_SRM_Present__c);
                subjectAttendeeString += oqUser.FirstName.Left(1) + '.' + oqUser.LastName + ' ';
                attendeesInfoString += oqUser.FirstName + oqUser.LastName;
                toEmailSet.add(oqUser.Email);
                privateCalendarIdSet.add(oqUser.Id);
            }
            User logUser = userMap.get(userId);
            organizerEmail = logUser.Email;
            toEmailSet.add(organizerEmail);
            privateCalendarIdSet.add(logUser.Id);

            String localTimeZoneDeconverted = deconvertTimeZone(pf.Event_Local_Time_Zone__c);
            String localStartTimeDeconverted = deconvertTime(String.valueOf(pf.Event_Local_Start_Time__c));
            String localEndTimeDeconverted = deconvertTime(String.valueOf(pf.Event_Local_End_Time__c));

            createSfdcProcedureEventsFromProcedureFormInfo(pf,
                                                            procedureEventRecordType,
                                                            publicCalendarId,
                                                            physician.Id,

                                                            privateCalendarIdSet,
                                                            toEmailSet,

                                                            organizerEmail,
                                                            accountName,
                                                            physicianName,
                                                            subjectAttendeeString,

                                                            localTimeZoneDeconverted,
                                                            localStartTimeDeconverted,
                                                            localEndTimeDeconverted,

                                                            attendeesInfoString

                                                            );

        }
    }

    public static void createSfdcProcedureEventsFromProcedureFormInfo(Procedure_Form__c procedureForm,
                                                                            Id recordTypeId, 
                                                                            Id publicCalendarId,
                                                                            Id primaryPhysicianId,
                                                                            
                                                                            Set<Id> privateCalendarIdSet,
                                                                            Set<String> toEmailSet,

                                                                            String organizerEmail,
                                                                            String accountName,
                                                                            String primaryPhysicianName,
                                                                            String subjectAttendeeString,
                                                                            String localTimeZoneDeconverted,
                                                                            String localStartTimeDeconverted,
                                                                            String localEndTimeDeconverted,
                                                                            String srmAttendeeSummary
                                                                            ){

            Event newEvent = new Event();
            newEvent.OwnerId = publicCalendarId;

            newEvent.RecordTypeId = recordTypeId;

            newEvent.ActivityDate = procedureForm.Event_ActivityDate__c;
            newEvent.Description = procedureForm.Event_Other_Information__c;
            newEvent.Other_Information__c = procedureForm.Event_Other_Information__c;
            newEvent.DurationInMinutes = Integer.valueOf(procedureForm.Event_DurationMinutes__c);
            newEvent.EndDateTime = procedureForm.Event_EndDateTime__c;
            newEvent.Location = procedureForm.Event_Location_Info__c;
            newEvent.Location_Info__c = procedureForm.Event_Location_Info__c;
            newEvent.WhoId = primaryPhysicianId; 
            newEvent.ProcedureFormId__c = procedureForm.Id;
            newEvent.ShowAs = 'Busy';
            newEvent.StartDateTime = procedureForm.Event_StartDateTime__c;
            newEvent.Subject = 'CASE | ' + accountName+ ' | ' + primaryPhysicianName + ' | '  + subjectAttendeeString;
            newEvent.Type = 'Meeting';
            newEvent.Event_Type__c = 'Procedure';
            newEvent.ActivityDateTime = procedureForm.Event_StartDateTime__c;
            newEvent.Vendor_Credential_Company__c = procedureForm.Vendor_Credential_Company__c;
            newEvent.Local_Schedule__c = 'Time Zone: ' + localTimeZoneDeconverted + '\n Start Time: ' + localStartTimeDeconverted + '\n End Time: ' + localEndTimeDeconverted;
            newEvent.Local_Time_Zone__c = localTimeZoneDeconverted;
            newEvent.Local_Start_Time__c = localStartTimeDeconverted;
            newEvent.Local_End_Time__c = localEndTimeDeconverted;
            newEvent.SRM_Attendees__c = srmAttendeeSummary;
            Insert newEvent;

            List<Event> privateEventInsertList = new List<Event>();
            for(Id pId : privateCalendarIdSet){
                Event privateEvent = newEvent.clone(false);
                privateEvent.OwnerId = pid;
                privateEventInsertList.add(privateEvent);
            }
            insert privateEventInsertList;

    }







            /*
            Secondary_TDS_Present__c

AD_Present__c

Other_Qualified_SRM_Present__c
            */
            //'Primary AM: ' + primaryAmName + '\nPrimary TDS: ' + primaryTdsName + '\nSecondary TDS: ' + secondTdsName + '\nAD: ' + primaryAdName + '\nOther SRM: ' + otherQualifiedSrmName;


    //    }

        

        //Build a map of user records to user roles of attendees & set primary AM & TDS Peram
/*        String primaryAmRole = '';
        String primaryAmRole1 = '';
        String primaryAmName = '';
        String primaryAmEmail = '';

        String primaryTdsRole = '';
        String primaryTdsRole1 = '';
        String primaryTdsName = '';
        String primaryTdsEmail = '';

        String secondaryTdsRole1 = '';
        String secondaryTdsName = '';
        String secondaryTdsEmail = '';

        String otherQualifiedSrmRole1 = '';
        String otherQualifiedSrmName = '';
        String otherQualifiedSrmEmail = '';

        String adRole1 = '';
        String adName = '';
        String adEmail = ''; 

        Set<String> toEmailSet = new Set<String>();
        Set<Id> attendeeIdSet = new Set<Id>();
        Set<String> emailSet = new Set<String>();
        String saEmail;
        Integer i = 0;

        String organizerEmail;

        for(User u : userList){

            if(u.Name != 'System Administrator'){
                attendeeIdSet.add(u.Id);
            }

            if(u.Id == primaryAmId){
                primaryAmRole = '  AM: ';
                primaryAmRole1 = 'AM: ';
                primaryAmName = u.FirstName + ' ' + u.LastName;
                primaryAmEmail = u.Email;
                toEmailSet.add(u.Email);
                emailSet.add(u.Email); 
                i++;
            }
            else if(u.Id == primaryTdsId){
                primaryTdsRole = '  TDS: ';
                primaryTdsRole1 = 'PRIMARY TDS: ';
                primaryTdsName = u.FirstName +  ' ' + u.LastName;
                primaryTdsEmail = u.Email;
                toEmailSet.add(u.Email);
                emailSet.add(u.Email); 
                i++;
            }
            else if(u.Id == secondaryTdsId){
                secondaryTdsRole1 = ' SECONDARY TDS: ';
                secondaryTdsName = u.FirstName + ' ' + u.LastName;
                secondaryTdsEmail = u.Email;
                toEmailSet.add(u.Email);
                emailSet.add(u.Email); 
                i++; 
            }    
            else if(u.Id == otherQualifiedSrmId){
                otherQualifiedSrmRole1 = ' OTHER QUALIFIED SRM: ';
                otherQualifiedSrmName = u.FirstName + ' ' + u.LastName;
                otherQualifiedSrmEmail = u.Email;
                toEmailSet.add(u.Email);
                emailSet.add(u.Email); 
                i++; 
            }
            else if(u.Id == adId){
                adRole1 = 'AD: ';
                adName = u.FirstName + ' '+  u.LastName;
                adEmail = u.Email;
                toEmailSet.add(u.Email);
                emailSet.add(u.Email); 
                i++;
            }
            if(u.Id == userId){ 
                organizerEmail = u.Email; 
                emailSet.add(u.Email); 
                i++;
            }
        }

        Map<String, Id> recordTypeMap = recordTypeMap();
        Id procedureRtId = recordTypeMap.get('Procedure');                                                                   

        Contact primaryPhysician = [SELECT Id, FirstName, LastName FROM Contact WHERE ID = : primaryOpPhysicianId LIMIT 1];
        Account account = [SELECT cFROM Account WHERE Id = : accountId LIMIT 1];

        Map<Id, Id> publicTerritoryCalendarMap = publicTerritoryCalendarMap();
        Id calendarId = publicTerritoryCalendarMap.get(account.SFDCTerritoryId__c);
        if(calendarID == null){ 
            calendarId = primaryAmId; 
        }

        Date procedureDateConv  = stringToDateConverter(procedureDate);
        DateTime timeConv  = stringToDateTimeConverter(procedureDate, time);
        DateTime endTimeConv    = stringToDateTimeConverter(procedureDate, endTime);

        Integer offset = calculateOffset(timeZoneString, timeConv);

        DateTime timeGMTConv = dateTimeGMT(timeConv, offset);
        DateTime endTimeGMTConv = dateTimeGMT(endTimeConv, offset);

        Integer durationMinutes = calculateDuation(timeGMTConv, endTimeGMTConv); 

        Id nullId;

        Event newEvent = createSfdcProcedureEvent(calendarId,
                                                    procedureRtId, 
                                                    procedureDateConv,
                                                    account,

                                                    otherInformation, 
                                                    durationMinutes,
                                                    endTimeGMTConv,

                                                    locInformation,
                                                    primaryOpPhysicianId,
                                                    nullId,

                                                    timeGMTConv,
                                                    primaryPhysician.LastName,
                                                    primaryAmName,
                                                    
                                                    primaryTdsName,
                                                    secondaryTdsName,
                                                    adName,
                                                    
                                                    otherQualifiedSrmName, 
                                                    vendorCredentailCompany,
                                                    localTimeZone,
                                                    
                                                    localStartTime,
                                                    localEndTime);

        String appointmentId;

        SYSTEM.DEBUG('APPT ID = [' + appointmentId + ']');

        if(!Test.isRunningTest()){
            newProcedureForm.EventIds__c = newEvent.Id;
            upsert newProcedureForm;

            SYSTEM.DEBUG('NEW PROCEDURE EVENT UPDDATED');

            newEvent.ProcedureFormId__c = newProcedureForm.Id;
            upsert newEvent;

            appointmentId = newEvent.Id;
        }
        else{
            appointmentId = 'TEST';
        }

        List<Event> newPersonalEventList = new List<Event>();
        for(Id iid : attendeeIdSet){
            Event clonedPersonalEvent = newEvent.clone(false);
            clonedPersonalEvent.OwnerId = iid;
            newPersonalEventList.add(clonedPersonalEvent);
        }
        insert newPersonalEventList;

        if(i > 0){
            buildAndSendInvite(toEmailSet, 
                                newEvent.Subject,
                                locInformation,
                                otherInformation,
                                localStartTime,
                                localEndTime,
                                localTimeZone,
                                timeGMTConv,
                                endTimeGMTConv,
                                newEvent.Id,
                                newProcedureForm.Id,
                                organizerEmail,
                                newEvent.SRM_Attendees__c,
                                0,
                                'CREATE'
                                );
        }

        return appointmentId;
        
    }
*/




 




    public static void cancelProcedureEvent(Map<Id, Procedure_Form__c> procedureFormMap,
                                            Map<Id, Set<Id>> pfUidRemoveMap,  
                                            Map<Id, Set<String>> pfEmailRemoveMap, 
                                            Map<Id, Event> eventMap){
                                               
        Map<Id, Id> publicTerritoryCalendarMap = publicTerritoryCalendarMap();

        List<Id> publicCalendarIdList = publicTerritoryCalendarMap.values();
                                        
        for(Id pid : procedureFormMap.keyset()){
            Procedure_Form__c pf = procedureFormMap.get(pid);
            Set<String> removePfEmailSet = pfEmailRemoveMap.get(pid);
            Set<Id> removePfIdSet = pfUidRemoveMap.get(pid);
                                        
            List<Event> pfRelatedPersonalEventList = new List<Event>();
            Event primaryPublicEvent = new Event();
            for(Event e : eventMap.values()){
                if(e.ProcedureFormId__c == pid){
                    if(removePfIdSet.contains(e.OwnerId)){
                        pfRelatedPersonalEventList.add(e);
                    }    
                    if(publicCalendarIdList.contains(e.OwnerId)){
                        primaryPublicEvent = e;
                    }
                }
            }


            if(primaryPublicEvent != null && removePfEmailSet != null && removePfEmailSet.size() > 0){

                Map<Id, String> userEmailMap = makeEmailMap();
                Id userId = userInfo.getUserId();
                String sentFrom = userEmailMap.get(userId);
                                        
                Integer sequence = Integer.valueOf(primaryPublicEvent.Sequence__c);
                //Update related Personal SFDC Events;
                for(Event e : pfRelatedPersonalEventList){

                    // Construct and Create Outlook Email and Invite ICS File
                    buildAndSendInvite(removePfEmailSet, 
                                                primaryPublicEvent.Subject,
                                                primaryPublicEvent.Location_Info__c,
                                                primaryPublicEvent.Other_Information__c,
                                                primaryPublicEvent.Local_Start_Time__c,
                                                primaryPublicEvent.Local_End_Time__c,
                                                PrimaryPublicEvent.Local_Time_Zone__c,
                                                primaryPublicEvent.StartDateTime,
                                                primaryPublicEvent.EndDateTime,
                                                primaryPublicEvent.Id,
                                                primaryPublicEvent.ProcedureFormId__c,
                                                sentFrom,
                                                primaryPublicEvent.SRM_Attendees__c,
                                                sequence,
                                                'DELETE'
                                                );
                
                }
                delete pfRelatedPersonalEventList;
            }    
            
        }  
    }









    /*********************************************************************************************************************************************************************/
    /*********************************************************************************************************************************************************************/
    /**********          U P D A T E     O F     E X I S T I N G    P R O C E D U R E     E V E N T     M E T H O D S                                           **********/
    /*********************************************************************************************************************************************************************/
    /*********************************************************************************************************************************************************************/

    // M E T H O D     T O     U P D A T E    P U B L I C     P R O C E D U R E     E V E N T     F I R S T 
    public static String updatePrimaryProcedureAppointment(String procedureFormRecordId,
                                                                String eventId,
                                                                String procedureDate,
                                                                String timeZoneString,
                                                                String StartTime,
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

        if(otherInformation == 'null'){otherInformation = '';}                                                        

        List<User> userList = [SELECT Id, Name, FirstName, LastName, Email FROM User 
                                WHERE   Id = : primaryAmId OR 
                                        Id = : primaryTdsId OR 
                                        Id = : secondaryTdsId OR
                                        Id = : otherQualifiedSrmId OR 
                                        Id = : adId OR 
                                        Name = 'System Administrator'
                                        ];

        String primaryAmRole = '';
        String primaryAmRole1 = '';
        String primaryAmName = '';
        String primaryAmEmail = '';

        String primaryTdsRole = '';
        String primaryTdsRole1 = '';
        String primaryTdsName = '';
        String primaryTdsEmail = '';

        String secondaryTdsRole1 = '';
        String secondaryTdsName = '';
        String secondaryTdsEmail = '';

        String otherQualifiedSrmRole1 = '';
        String otherQualifiedSrmName = '';
        String otherQualifiedSrmEmail = '';

        String adRole1 = '';
        String adName = '';
        String adEmail = ''; 

        Set<String> toEmailSet = new Set<String>();
        Set<Id> attendeeIdSet = new Set<Id>();

        for(User u : userList){
            if(u.Name != 'System Administrator'){
                attendeeIdSet.add(u.Id);
            }

            if(u.Id == primaryAmId){
                primaryAmRole = ' | AM: ';
                primaryAmRole1 = 'AM: ';
                primaryAmName = u.FirstName + ' ' + u.LastName;
                primaryAmEmail = u.Email;
                toEmailSet.add(u.Email);
            }
            else if(u.Id == primaryTdsId){
                primaryTdsRole = ' | TDS: ';
                primaryTdsRole1 = 'PRIMARY TDS: ';
                primaryTdsName = u.FirstName +  ' ' + u.LastName;
                primaryTdsEmail = u.Email;
                toEmailSet.add(u.Email);
            }
            else if(u.Id == secondaryTdsId){
                secondaryTdsRole1 = 'SECONDARY TDS: ';
                secondaryTdsName = u.FirstName + ' ' + u.LastName;
                secondaryTdsEmail = u.Email;
                toEmailSet.add(u.Email);
            }    
            else if(u.Id == otherQualifiedSrmId){
                otherQualifiedSrmRole1 = 'OTHER QUALIFIED SRM: ';
                otherQualifiedSrmName = u.FirstName + ' ' + u.LastName;
                otherQualifiedSrmEmail = u.Email;
                toEmailSet.add(u.Email);
            }
            else if(u.Id == adId){
                adRole1 = 'AD: ';
                adName = u.FirstName + ' '+  u.LastName;
                adEmail = u.Email;
                toEmailSet.add(u.Email);
            }
        }                   

        String userId = UserInfo.getUserId();
        attendeeIdSet.add(userId);


        Contact primaryPhysician = [SELECT Id, FirstName, LastName FROM Contact WHERE ID = : primaryOpPhysicianId LIMIT 1];
        Account account = [SELECT Id, Name, AccountNumber, SFDCTerritoryId__r.Calendar__c  FROM Account WHERE Id = : accountId LIMIT 1];

        List<Calendar> calandarList = [SELECT Name, Id FROM Calendar WHERE Name <> null];
        Map<String, Id> calendarMap = new Map<String, Id>();
        for(Calendar cal : calandarList){
            calendarMap.put(cal.Id, cal.Id);
        }


        Id calendarId = calendarMap.get(account.SFDCTerritoryId__r.Calendar__c);
        if(calendarID == null){
            calendarId = primaryAmId; 
        }

        Date procedureDateConv  = stringToDateConverter(procedureDate);
        DateTime timeConv  = stringToDateTimeConverter(procedureDate, startTime);
        DateTime endTimeConv    = stringToDateTimeConverter(procedureDate, endTime);

        Integer offset = calculateOffset(timeZoneString, timeConv);

        DateTime timeGMTConv = dateTimeGMT(timeConv, offset);
        DateTime endTimeGMTConv = dateTimeGMT(endTimeConv, offset);

        Integer durationMinutes = calculateDuation(timeGMTConv, endTimeGMTConv); 

        

        Id procedureRtId = [SELECT Id FROM RecordType WHERE SObjectType = 'Event' AND Name = 'Procedure' LIMIT 1][0].Id;  

        Event existingEvent = [SELECT Id, 
                                        ActivityDate,
                                        Description,
                                        Other_Information__c,
                                        DurationInMinutes,
                                        EndDateTime,
                                        Location,
                                        Location_Info__c,
                                        WhoId,
                                        WhatId,
                                        ShowAs,
                                        StartDateTime,
                                        Subject,
                                        Type,
                                        RecordTypeId,
                                        Event_Type__c,
                                        ActivityDateTime,
                                        Vendor_Credential_Company__c,
                                        Local_Schedule__c,
                                        Local_Time_Zone__c,
                                        SRM_Attendees__c,
                                        Sequence__c  
                                FROM    Event 
                                WHERE   Id = : eventID
                                LIMIT   1];

        if(existingEvent.Sequence__c == null){
            existingEvent.Sequence__c = -1;
        }

        existingEvent.Sequence__c++;

        Integer sequence = Integer.valueOf(existingEvent.Sequence__c);
        existingEvent.ActivityDate = procedureDateConv;
        existingEvent.Description = otherInformation;
        existingEvent.Other_Information__c = otherInformation;
        existingEvent.DurationInMinutes = durationMinutes;
        existingEvent.EndDateTime = endTimeGMTConv;
        existingEvent.Location = locInformation;
        existingEvent.ProcedureFormId__c = procedureFormRecordId;
        existingEvent.Local_Start_Time__c = localStartTime;
        existingEvent.Local_End_Time__c = localEndTime;
        existingEvent.Location_Info__c = locInformation;
        existingEvent.WhoId = primaryOpPhysicianId; //(Contact)
        existingEvent.WhatId = accountId; //Physician or Hospital
        existingEvent.ShowAs = 'Busy';
        existingEvent.StartDateTime = timeGMTConv;
        existingEvent.Subject = 'CASE | ' + account.Name + ' | Dr. ' + primaryPhysician.LastName + ' | '  + primaryAmRole + primaryAmName + primaryTdsRole + primaryTdsName + otherQualifiedSrmRole1 + otherQualifiedSrmName;
        existingEvent.Type = 'Meeting';
        existingEvent.RecordTYpeId = procedureRtId;
        existingEvent.Event_Type__c = 'Procedure';
        existingEvent.ActivityDateTime = timeGMTConv;
        existingEvent.Vendor_Credential_Company__c = vendorCredentailCompany;
        existingEvent.Local_Schedule__c = 'Time Zone: ' + localTimeZone + '\n Start Time: ' + localStartTime + '\n End Time: ' + localEndTime;
        existingEvent.Local_Time_Zone__c = localTimeZone;
        existingEvent.SRM_Attendees__c = 'Primary AM: ' + primaryAmName + '\nPrimary TDS: ' + primaryTdsName + '\nSecondary TDS: ' + secondaryTdsName + '\nAD: ' + adName + '\nOther SRM: ' + otherQualifiedSrmName;

        update existingEvent;

        if(existingEvent.Id != null){                              
            return existingEvent.Id;
        }
        else{
            return procedureFormRecordId;
        }
    }                                                                    









    public static void synchNewEventsWithUpdatedProcedure(Procedure_Form__c inputProcedureForm){
        List<Id> publicCalendarIds = publicTerritoryCalendarMap().values();

        Event e = [SELECT Id, ProcedureFormId__c FROM Event WHERE OwnerId IN: publicCalendarIds AND ProcedureFormId__c = : inputProcedureForm.Id LIMIT 1];
    
        inputProcedureForm.EventIds__c = e.Id;
        
        GlobalTriggerSwitch.RunProcedureFormTrigger = false;
        update inputProcedureForm;
        GlobalTriggerSwitch.RunProcedureFormTrigger = true;
    }











    // M E T H O D     T O     U P D A T E    P R I V A T E      P R O C E D U R E     E V E N T S     A N D    S E N D     O U T L O O K    M E T H O D S     S E C O N D 
    public static void updateProcedureEvent(Map<Id, Procedure_Form__c> procedureFormMap,
                                            Map<Id, Set<Id>> pfUidUpdateMap, 
                                            Map<Id, Set<String>> pfEmailUpdateMap,
                                            Map<Id, Event> eventMap){

        SYSTEM.DEBUG('ENTER - CALENDAR UTILITY - UPDATE PROCEDURE EVENT'); 

        Map<Id, Id> publicTerritoryCalendarMap = publicTerritoryCalendarMap();

        List<Id> publicCalendarIdList = publicTerritoryCalendarMap.values();

        for(Id pid : procedureFormMap.keyset()){
            Procedure_Form__c pf = procedureFormMap.get(pid);
            Set<String> updatePfEmailSet = pfEmailUpdateMap.get(pid);
            Set<Id> updatePfIdSet = pfUidUpdateMap.get(pid);

            List<Event> pfRelatedPersonalEventList = new List<Event>();
            Event primaryPublicEvent = new Event();
            for(Event e : eventMap.values()){
                if(e.ProcedureFormId__c == pid){
                    if(updatePfIdSet.contains(e.OwnerId)){
                       // SYSTEM.DEBUG('UPDATE EVENT ADD PERSONAL ID = [' + e.OwnerId + ']');
                        pfRelatedPersonalEventList.add(e);
                    }    
                    if(publicCalendarIdList.contains(e.OwnerId)){
                        //SYSTEM.DEBUG(' CANCEL EVENT ADD CALENDAR ID = [' + e.OwnerId + ']');
                        primaryPublicEvent = e;
                    }
                }
            }
            if(primaryPublicEvent != null){
                update primaryPublicEvent;

                Integer sequence = Integer.valueOf(primaryPublicEvent.Sequence__c);
                //Update related Personal SFDC Events;
                for(Event e : pfRelatedPersonalEventList){
                    e.ActivityDate = primaryPublicEvent.ActivityDate;
                    e.ActivityDateTime = primaryPublicEvent.ActivityDateTime;
                    e.Description = primaryPublicEvent.Description;
                    e.DurationInMinutes = primaryPublicEvent.DurationInMinutes;
                    e.ProcedureFormId__c = primaryPublicEvent.ProcedureFormId__c;
                    e.EndDateTime = primaryPublicEvent.EndDateTime;
                    e.Event_Type__c = primaryPublicEvent.Event_Type__c;
                    e.Local_Schedule__c = primaryPublicEvent.Local_Schedule__c;
                    e.Local_Start_Time__c = primaryPublicEvent.Local_Start_Time__c;
                    e.Local_End_Time__c = primaryPublicEvent.Local_End_Time__c;
                    e.Local_Time_Zone__c = primaryPublicEvent.Local_Time_Zone__c;
                    e.Location_Info__c = primaryPublicEvent.Location_Info__c;
                    e.Location = primaryPublicEvent.Location;
                    e.Other_Information__c = primaryPublicEvent.Other_Information__c;
                    e.ProcedureFormId__c = primaryPublicEvent.ProcedureFormId__c;
                    // Sequence will be updated upon update of the Event records.
                    e.ShowAs = primaryPublicEvent.ShowAs;
                    e.SRM_Attendees__c = primaryPublicEvent.SRM_Attendees__c;
                    e.StartDateTime = primaryPublicEvent.StartDateTime;
                    e.Subject = primaryPublicEvent.Subject;
                    e.Type = primaryPublicEvent.Type;
                    e.Vendor_Credential_Company__c = primaryPublicEvent.Vendor_Credential_Company__c;
                    e.WhatId = primaryPublicEvent.WhatId;
                    e.WhoId = primaryPublicEvent.WhoId;
                
                    Map<Id, String> userEmailMap = makeEmailMap();
                    Id userId = userInfo.getUserId();
                    String sentFrom = userEmailMap.get(userId);

                    // Construct and Create Outlook Email and Invite ICS File
                    buildAndSendInvite(updatePfEmailSet, 
                                                primaryPublicEvent.Subject,
                                                primaryPublicEvent.Location_Info__c,
                                                primaryPublicEvent.Other_Information__c,
                                                primaryPublicEvent.Local_Start_Time__c,
                                                primaryPublicEvent.Local_End_Time__c,
                                                PrimaryPublicEvent.Local_Time_Zone__c,
                                                primaryPublicEvent.StartDateTime,
                                                primaryPublicEvent.EndDateTime,
                                                primaryPublicEvent.Id,
                                                primaryPublicEvent.ProcedureFormId__c,
                                                sentFrom,
                                                primaryPublicEvent.SRM_Attendees__c,
                                                sequence,
                                                'UPDATE'
                                                );
                
                }
            }

            SYSTEM.DEBUG('EXIT - CALENDAR UTILITY - UPDATE PROCEDURE EVENT'); 
            
            update pfRelatedPersonalEventList;
        }                                      
    }










    /*********************************************************************************************************************************************************************/
    /*********************************************************************************************************************************************************************/
    /**********          Adds Members to an Updated Procedure Event                                                                                             **********/
    /*********************************************************************************************************************************************************************/
    /*********************************************************************************************************************************************************************/
    public static void addProcedureEvent(Map<Id, Procedure_Form__c> procedureFormMap,
                                            Map<Id, Set<Id>> pfUidAddMap,  
                                            Map<Id, Set<String>>  pfEmailAddMap,
                                            Map<Id, Event> eventMap){               

        Map<Id, Id> publicTerritoryCalendarMap = publicTerritoryCalendarMap();

        List<Id> publicCalendarIdList = publicTerritoryCalendarMap.values();

        // loop through procedure forms to get related email maps and get email and Id sets//                                     
        for(Id pid : procedureFormMap.keyset()){
            Procedure_Form__c pf = procedureFormMap.get(pid);
            Set<String> addPfEmailSet = pfEmailAddMap.get(pid);
            Set<Id> addPfIdSet = pfUidAddMap.get(pid);
            List<Event> pfRelatedEventList = new List<Event>();
            Event primaryPublicEvent = new Event();
            for(Event e : eventMap.values()){
                if(e.ProcedureFormId__c == pid){
                    pfRelatedEventList.add(e);
                    if(publicCalendarIdList.contains(e.OwnerId)){
                        primaryPublicEvent = e;
                    }
                }
            }

            // Construct and create SFDC event for new members of Procedure Event
            List<Event> addSfdcEventList = new List<Event>();

            Map<Id, String> userEmailMap = makeEmailMap();
            Id userId = userInfo.getUserId();
            String sentFrom = userEmailMap.get(userId);

            if(primaryPublicEvent != null){
                for(Id uId : addPfIdSet){
                    Event addSfdcEvent = primaryPublicEvent.clone(false);
                    addSfdcEvent.OwnerId = uId;
                    addSfdcEventList.add(addSfdcEvent);
                }
                insert addSfdcEventList;

                if(addPfEmailSet.size() > 0 && addPfEmailSet != null){
                    // Construct and Create Outlook Email and Invite ICS File
                    buildAndSendInvite(addPfEmailSet, 
                                                primaryPublicEvent.Subject,
                                                primaryPublicEvent.Location_Info__c,
                                                primaryPublicEvent.Other_Information__c,
                                                primaryPublicEvent.Local_Start_Time__c,
                                                primaryPublicEvent.Local_End_Time__c,
                                                PrimaryPublicEvent.Local_Time_Zone__c,
                                                primaryPublicEvent.StartDateTime,
                                                primaryPublicEvent.EndDateTime,
                                                primaryPublicEvent.Id,
                                                primaryPublicEvent.ProcedureFormId__c,
                                                sentFrom,
                                                primaryPublicEvent.SRM_Attendees__c,
                                                Integer.valueOf(0),
                                                'CREATE'
                                                );   
                }        
            }
        }
    }


 






    public static Event createSfdcProcedureEvent(Id calendarOwnerId,
                                        Id procedureRtId, 
                                        Date procedureDateConv,
                                        Account account,
                                        String otherInformation, 
                                        Integer durationMinutes,
                                        DateTime endTimeGMTConv,
                                        String locInformation,
                                        String primaryOpPhysicianId,
                                        Id procedureFormId,
                                        DateTime timeGMTConv,
                                        String primaryPhysicianLastName,
                                        String primaryAMName,
                                        String primaryTdsName,
                                        String secondTdsName,
                                        String primaryAdName,
                                        String otherQualifiedSrmName, 
                                        String vendorCredetialCompany,
                                        String localTimeZone,
                                        String localStartTime,
                                        String localEndTime){

        SYSTEM.DEBUG('ENTER CALENDAR UTILITY - CREATE SFDC PROCEDURE EVENT');                                    
                                        
        Event newEvent = new Event();
        newEvent.OwnerId = calendarOwnerId;

        newEvent.RecordTypeId = procedureRtId;

        newEvent.ActivityDate = procedureDateConv;
        newEvent.Description = otherInformation;
        newEvent.Other_Information__c = otherInformation;
        newEvent.DurationInMinutes = durationMinutes;
        newEvent.EndDateTime = endTimeGMTConv;
        newEvent.Location = locInformation;
        newEvent.Location_Info__c = locInformation;
        newEvent.WhoId = primaryOpPhysicianId; 
        newEvent.ProcedureFormId__c = null;
        newEvent.ShowAs = 'Busy';
        newEvent.StartDateTime = timeGMTConv;
        newEvent.Subject = 'CASE | ' + account.Name + ' | Dr. ' + primaryPhysicianLastName + ' | '  + primaryAmName +  primaryTdsName + otherQualifiedSrmName;
        newEvent.Type = 'Meeting';
        newEvent.Event_Type__c = 'Procedure';
        newEvent.ActivityDateTime = timeGMTConv;
        newEvent.Vendor_Credential_Company__c = vendorCredetialCompany;
        newEvent.Local_Schedule__c = 'Time Zone: ' + localTimeZone + '\n Start Time: ' + localStartTime + '\n End Time: ' + localEndTime;
        newEvent.Local_Time_Zone__c = localTimeZone;
        newEvent.Local_Start_Time__c = localStartTime;
        newEvent.Local_End_Time__c = localEndTime;
        newEvent.SRM_Attendees__c = 'Primary AM: ' + primaryAmName + '\nPrimary TDS: ' + primaryTdsName + '\nSecondary TDS: ' + secondTdsName + '\nAD: ' + primaryAdName + '\nOther SRM: ' + otherQualifiedSrmName;
        Insert newEvent;

        SYSTEM.DEBUG('ENTER CALENDAR UTILITY - CREATE SFDC PROCEDURE EVENT - EVENT ID + [' + newEvent.Id + ']');  

        return newEvent;

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
                                                
        SYSTEM.DEBUG(' ENTERING CALENDAR UTILITY -  BUILD AND SEND INVITE');
        
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










    /************************************************************************************************************************************************************************************************/
    /************************************************************************************************************************************************************************************************/
    /***********    Core Method To Construct and Send Email With Attachment - - Uses Helper Methods Below Depending on Circumstance                                                        **********/
    /************************************************************************************************************************************************************************************************/
    /************************************************************************************************************************************************************************************************/
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

            String emailBody = constructEmailBody(localStartTime,
                                                    localEndTime,
                                                    LocalTimeZone,
                                                    startIcsTimeString,
                                                    endIcsTimeString,
                                                    currentIcsTime,
                                                    organizerEmail,
                                                    inviteeEmail,
                                                    sfdcEventId,
                                                    sfdcProcId, 
                                                    subject,
                                                    location,
                                                    srmAttendees,
                                                    sequence,
                                                    dmlAction,
                                                    otherInformation);

            //SYSTEM.DEBUG('Email Body = [' + emailBody + ']');                                        

  
            mail.setPlainTextBody(emailBody);
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.filename = 'meeting.ics';
            attach.ContentType ='text/calendar; charset=utf-8; method=REQUEST';
            attach.inline = true;
            attach.body = invite(startIcsTimeString,
                                endIcsTimeString,
                                currentIcsTime,
                                organizerEmail,
                                sendTo,
                                sequence,
                                dmlAction,
                                sfdcEventId, 
                                subject,
                                location);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach});
            //Messaging.SendEmailResult[] er = Messaging.sendEmail(new Messaging.Email[] {mail});
            return null;
        }
        private Blob invite(String startIcsTimeString,
                                String endIcsTimeString,
                                String currentIcsTimeString,
                                String organizerEmail,
                                Set<String> inviteeEmail,
                                Integer sequence,
                                String dmlAction,
                                String sfdcEventId, 
                                String subject,
                                string location) {

            return buildInvite(startIcsTimeString,
                                endIcsTimeString,
                                currentIcsTimeString,
                                organizerEmail,
                                inviteeEmail,
                                sequence,
                                dmlAction,
                                sfdcEventId, 
                                subject,
                                location);
            
                              
        }
 
    }








    /************************************************************************************************************************************************************************************************/
    /************************************************************************************************************************************************************************************************/
    /***********    Construction of the Email Body Based on Condition                                                                                                                      **********/
    /************************************************************************************************************************************************************************************************/
    /************************************************************************************************************************************************************************************************/
    public static String constructEmailBody(String localStartTime,
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
                                            String otherInformation){    
        
        //SYSTEM.DEBUG('ENTERING CONSTRUCT EMAIL BODY - DMLACTION = [' + dmlAction + ']');

        String domain = String.valueOf(System.Url.getSalesforceBaseUrl().toExternalForm());
        domain = domain.replace('.', ',');
        domain = domain.split(',')[0];

        Date procedureDate = [SELECT Id, Procedure_Date__c FROM Procedure_Form__c WHERE ID = :sfdcProcId LIMIT 1].Procedure_Date__c;
        String procedureDateString = String.valueOf(procedureDate);


        String emailBody;

        if(dmlAction == 'CREATE'){
            emailBody = 'HOSPITAL LOCAL SCHEDULE: \n';
            emailBody += '  Procedure Date: ' + procedureDateString + '\n';
            emailBody += '  Start Time: ' + localStartTime + ' ' + localTimeZone + '\n';
            emailBody += '  End Time:   ' + localEndTime  + ' ' + localTimeZone + '\n';
            emailBody += '\n';  
            emailBody += 'LOCATION: \n' + location + '\n';
            emailBody += '\n';
            emailBody += 'SRM PERSONNEL \n' + srmAttendees;
            emailBody += '\n\n';
            emailBody += 'LINK TO PROCEDURE FORM: \n' + domain + '.lightning.force.com/lightning/r/Procedure_Form__c/' + sfdcProcId + '/view' ;
            emailBody += '\n\n';
            emailBody += 'LINK TO PROCEDURE SFDC EVENT: \n' + domain + '.lightning.force.com/lightning/r/Event/' + sfdcEventId + '/view' ;
            emailBody += '\n\n';
            emailBody += 'OTHER INFORMATION: \n' +  otherInformation ;
        }
        else if(dmlAction == 'UPDATE'){

            //SYSTEM.DEBUG('ENTERING CONSTRUCT EMAIL BODY - FOR UPDATE');

            emailBody = ' * * * U P D A T E D     P R O C E D U R E    S C H E D U L E * * * \n';
            emailBody += 'NEW HOSPITAL LOCAL SCHEDULE: \n';
            emailBody += '  Procedure Date: ' + procedureDateString + '\n';
            emailBody += '  Start Time: ' + localStartTime + ' ' + localTimeZone + '\n';
            emailBody += '  End Time:   ' + localEndTime  + ' ' + localTimeZone + '\n';
            emailBody += '\n';  
            emailBody += 'LOCATION: \n' + location + '\n';
            emailBody += '\n';
            emailBody += 'SRM PERSONNEL \n' + srmAttendees;
            emailBody += '\n\n';
            emailBody += 'LINK TO PROCEDURE FORM: \n' + domain + '.lightning.force.com/lightning/r/Procedure_Form__c/' + sfdcProcId + '/view' ;
            emailBody += '\n\n';
            emailBody += 'LINK TO PROCEDURE SFDC EVENT: \n' + domain + '.lightning.force.com/lightning/r/Event/' + sfdcEventId + '/view' ;
            emailBody += '\n\n';
            emailBody += 'OTHER INFORMATION: \n' +  otherInformation ;

            //SYSTEM.DEBUG('EXIT CONSTRUCT EMAIL BODY - FOR UPDATE');
        }    
        else if(dmlAction == 'DELETE'){
            emailBody = '* * * C A N C E L L E D    P R O C E D U R E * * *  \n Original Schedule:  \n';
            emailBody += '  Procedure Date: ' + procedureDateString + '\n';
            emailBody += '  Start Time: ' + localStartTime + ' ' + localTimeZone + '\n';
            emailBody += '  End Time:   ' + localEndTime  + ' ' + localTimeZone + '\n';
            emailBody += '\n';  
            emailBody += 'LOCATION: \n' + location + '\n';
            emailBody += '\n';
            emailBody += 'SRM PERSONNEL \n' + srmAttendees;
            emailBody += '\n\n';
            emailBody += 'LINK TO PROCEDURE FORM: \n' + domain + '.lightning.force.com/lightning/r/Procedure_Form__c/' + sfdcProcId + '/view' ;
            emailBody += '\n\n';
            emailBody += 'OTHER INFORMATION: \n' +  otherInformation ;
        }

        return emailBody;
    }









    /************************************************************************************************************************************************************************************************/
    /************************************************************************************************************************************************************************************************/
    /***********    Building of the ICS Attachment as a Blob                                                                                                                               **********/
    /************************************************************************************************************************************************************************************************/
    /************************************************************************************************************************************************************************************************/
    public static Blob buildInvite(String startIcsTimeString,
                        String endIcsTimeString,
                        String currentIcsTimeString,
                        String organizerEmail,
                        Set<String> inviteeEmail,
                        Integer sequence,
                        String dmlAction,
                        String sfdcEventId, 
                        String subject,
                        string location) {

        String txtInvite = buildTxtInvite(startIcsTimeString,
                                            endIcsTimeString,
                                            currentIcsTimeString,
                                            organizerEmail,
                                            sfdcEventId,
                                            inviteeEmail,
                                            sequence,
                                            dmlAction);

        //SYSTEM.DEBUG('TXT INVITE SIZE - TXT INVITE = [' + txtInvite.length() + ']');                                    

        return Blob.valueOf(txtInvite);
    }








    /************************************************************************************************************************************************************************************************/
    /************************************************************************************************************************************************************************************************/
    /***********    Building of Text Invite                                                                                                                                                **********/
    /************************************************************************************************************************************************************************************************/
    /************************************************************************************************************************************************************************************************/
    public static string buildTxtInvite(String startIcsTimeString,
                                    String endIcsTimeString,
                                    String currentIcsTimeString,
                                    String organizerEmail,
                                    String sfdcEventId,
                                    Set<String> inviteeEmail,
                                    Integer sequence,
                                    String dmlAction){

        String txtInvite = '';

        if(dmlAction == 'CREATE'){
            txtInvite = constructInviteIcs(startIcsTimeString,
                                            endIcsTimeString,
                                            currentIcsTimeString,
                                            organizerEmail,
                                            sfdcEventId,
                                            inviteeEmail,
                                            sequence);
        }
        if(dmlAction == 'UPDATE'){
            txtInvite = constructUpdateIcs(startIcsTimeString,
                                endIcsTimeString,
                                currentIcsTimeString,
                                organizerEmail,
                                sfdcEventId,
                                inviteeEmail,
                                sequence);
        }
        if(dmlAction == 'DELETE'){
            txtInvite = constructCancelIcs(startIcsTimeString,
                                endIcsTimeString,
                                currentIcsTimeString,
                                organizerEmail,
                                sfdcEventId,
                                inviteeEmail,
                                sequence);
        }

        return txtInvite;
    }








    /************************************************************************************************************************************************************************************************/
    /************************************************************************************************************************************************************************************************/
    /***********    Building of the ICS Attachment as a Text                                                                                                                               **********/
    /************************************************************************************************************************************************************************************************/
    /************************************************************************************************************************************************************************************************/

// C R E A T E    I N V I T E    
    public static String constructInviteIcs(String startIcsTimeString,
                                            String endIcsTimeString,
                                            String currentIcsTimeString,
                                            String organizerEmail,
                                            String sfdcEventId,
                                            Set<String> inviteeEmail,
                                            Integer sequence){                                

        String txtInvite = '';

        txtInvite += 'BEGIN:VCALENDAR\n';
        txtInvite += 'PRODID:-//Google Inc//Google Calendar 70.9054//EN\n';
        txtInvite += 'PRODID:Microsoft Exchange Server 2010\n';
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
                txtInvite += 'ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=FALSE;CN=\'' + s + '\';X-NUM-GUESTS=' + i + ':mailto:' + s + '\n';
            }
            else{
                txtInvite += 'ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;CN=\'' + s + '\';X-NUM-GUESTS=' + i + ':mailto:' + s + '\n';
            }
        }

        txtInvite += 'COMMENT;LANGUAGE=en-US:www.cnn.com\n'; 
        txtInvite += 'X-MICROSOFT-CDO-OWNERAPPTID:-2136020037\n';
        txtInvite += 'CREATED:' + currentIcsTimeString + '\n';
        txtInvite += 'DESCRIPTION:www.cnn.com\n\n-::~:~::~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~::~:~::-\nPlease do not edit this section of the description.\n\nView your event at https://www.google.com/calendar/event?action=VIEW&eid=NGk2bDVnbHFrbmd0YWJ0cG11YzFyamtkZXIgZ3BldHJpZUBzaWxrcm9h ZG1lZC5jb20&tok=MjUjZ29yZG9uLm0ucGV0cmllQGdtYWlsLmNvbTQ0ZWRmNzNkZjU2NGJjYmM zNTQ5ZTg4NGM4NWVhNzM0ZThiYTBjOTc&ctz=America%2FLos_Angeles&hl=en&es=1.\n-::~:~::~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~::~:~::-\n';
        txtInvite += 'LAST-MODIFIED:' + currentIcsTimeString + '\n';

        txtInvite += 'SEQUENCE:' + sequence + '\n';
        //if(dmlAction == 'CANCELLED'){
        //    txtInvite += 'STATUS:CANCELLED' +  '\n';
        //}
        txtInvite += 'SUMMARY:TEST INVITE FROM GOOGLE\n';
        txtInvite += 'TRANSP:OPAQUE\n';
        txtInvite += 'BEGIN:VALARM\n';
        txtInvite += 'DESCRIPTION:REMINDER\n';
        txtInvite += 'TRIGGER;RELATED=START:-PT15M\n';
        txtInvite += 'ACTION:DISPLAY\n';
        txtInvite += 'END:VALARM\n';
        txtInvite += 'END:VEVENT\n';
        txtInvite += 'END:VCALENDAR\n';

        /*
        BEGIN:VCALENDAR
        METHOD:REQUEST
        PRODID:Microsoft Exchange Server 2010
        VERSION:2.0
        BEGIN:VTIMEZONE
        TZID:Pacific Standard Time
        BEGIN:STANDARD
        DTSTART:16010101T020000
        TZOFFSETFROM:-0700
        TZOFFSETTO:-0800
        RRULE:FREQ=YEARLY;INTERVAL=1;BYDAY=1SU;BYMONTH=11
        END:STANDARD
        BEGIN:DAYLIGHT
        DTSTART:16010101T020000
        TZOFFSETFROM:-0800
        TZOFFSETTO:-0700
        RRULE:FREQ=YEARLY;INTERVAL=1;BYDAY=2SU;BYMONTH=3
        END:DAYLIGHT
        END:VTIMEZONE
        BEGIN:VEVENT
        ORGANIZER;CN=Gordon Petrie:mailto:gpetrie@silkroadmed.com
        ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;CN=gordon.m.p
        etrie@gmail.com:mailto:gordon.m.petrie@gmail.com
        DESCRIPTION;LANGUAGE=en-US:This is a test from Outlook\n
        UID:040000008200E00074C5B7101A82E008000000000EEA8D3E86EED501000000000000000
        010000000473F44B3CB137147A8B228DCEB38EE2B
        SUMMARY;LANGUAGE=en-US:Test Calendar Event
        DTSTART;TZID=Pacific Standard Time:20200229T080000
        DTEND;TZID=Pacific Standard Time:20200229T083000
        CLASS:PUBLIC
        PRIORITY:5
        DTSTAMP:20200228T222722Z
        TRANSP:OPAQUE
        STATUS:CONFIRMED
        SEQUENCE:0
        LOCATION;LANGUAGE=en-US:
        X-MICROSOFT-CDO-APPT-SEQUENCE:0
        X-MICROSOFT-CDO-OWNERAPPTID:2118313742
        X-MICROSOFT-CDO-BUSYSTATUS:TENTATIVE
        X-MICROSOFT-CDO-INTENDEDSTATUS:BUSY
        X-MICROSOFT-CDO-ALLDAYEVENT:FALSE
        X-MICROSOFT-CDO-IMPORTANCE:1
        X-MICROSOFT-CDO-INSTTYPE:0
        X-MICROSOFT-DONOTFORWARDMEETING:FALSE
        X-MICROSOFT-DISALLOW-COUNTER:FALSE
        X-MICROSOFT-LOCATIONS:[]
        BEGIN:VALARM
        DESCRIPTION:REMINDER
        TRIGGER;RELATED=START:-PT15M
        ACTION:DISPLAY
        END:VALARM
        END:VEVENT
        END:VCALENDAR
        */

        return txtInvite;

        
                                    
    }








// U P D A T E    I N V I T E 
    public static String constructUpdateIcs(String startIcsTimeString,
                                            String endIcsTimeString,
                                            String currentIcsTimeString,
                                            String organizerEmail,
                                            String sfdcEventId,
                                            Set<String> inviteeEmail,
                                            Integer sequence){
        //SYSTEM.DEBUG('ENTERING CONSTRUCT UPDATE ICS');

        String txtInvite = '';

        txtInvite += 'BEGIN:VCALENDAR\n';
        txtInvite += 'PRODID:-//Google Inc//Google Calendar 70.9054//EN\n';
        txtInvite += 'PRODID:Microsoft Exchange Server 2010\n';
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
                txtInvite += 'ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=FALSE;CN=\'' + s + '\';X-NUM-GUESTS=' + i + ':mailto:' + s + '\n';
            }
            else{
                txtInvite += 'ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;CN=\'' + s + '\';X-NUM-GUESTS=' + i + ':mailto:' + s + '\n';
            }
        }

        txtInvite += 'COMMENT;LANGUAGE=en-US:www.cnn.com\n'; 
        txtInvite += 'X-MICROSOFT-CDO-OWNERAPPTID:-2136020037\n';
        txtInvite += 'CREATED:' + currentIcsTimeString + '\n';
        txtInvite += 'DESCRIPTION:www.cnn.com\n\n-::~:~::~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~::~:~::-\nPlease do not edit this section of the description.\n\nView your event at https://www.google.com/calendar/event?action=VIEW&eid=NGk2bDVnbHFrbmd0YWJ0cG11YzFyamtkZXIgZ3BldHJpZUBzaWxrcm9h ZG1lZC5jb20&tok=MjUjZ29yZG9uLm0ucGV0cmllQGdtYWlsLmNvbTQ0ZWRmNzNkZjU2NGJjYmM zNTQ5ZTg4NGM4NWVhNzM0ZThiYTBjOTc&ctz=America%2FLos_Angeles&hl=en&es=1.\n-::~:~::~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~::~:~::-\n';
        txtInvite += 'LAST-MODIFIED:' + currentIcsTimeString + '\n';

        txtInvite += 'SEQUENCE:' + sequence + '\n';
        //if(dmlAction == 'CANCELLED'){
        //    txtInvite += 'STATUS:CANCELLED' +  '\n';
        //}
        txtInvite += 'SUMMARY:TEST INVITE FROM GOOGLE\n';
        txtInvite += 'TRANSP:OPAQUE\n';
        txtInvite += 'BEGIN:VALARM\n';
        txtInvite += 'DESCRIPTION:REMINDER\n';
        txtInvite += 'TRIGGER;RELATED=START:-PT15M\n';
        txtInvite += 'ACTION:DISPLAY\n';
        txtInvite += 'END:VALARM\n';
        txtInvite += 'END:VEVENT\n';
        txtInvite += 'END:VCALENDAR\n';

        //SYSTEM.DEBUG('EXITING CONSTRUCT UPDATE ICS - TXT INVITE = [' + txtInvite + ']');

        return txtInvite;
        /*
        BEGIN:VCALENDAR
        METHOD:REQUEST
        PRODID:Microsoft Exchange Server 2010
        VERSION:2.0
        BEGIN:VTIMEZONE
        TZID:Pacific Standard Time
        BEGIN:STANDARD
        DTSTART:16010101T020000
        TZOFFSETFROM:-0700
        TZOFFSETTO:-0800
        RRULE:FREQ=YEARLY;INTERVAL=1;BYDAY=1SU;BYMONTH=11
        END:STANDARD
        BEGIN:DAYLIGHT
        DTSTART:16010101T020000
        TZOFFSETFROM:-0800
        TZOFFSETTO:-0700
        RRULE:FREQ=YEARLY;INTERVAL=1;BYDAY=2SU;BYMONTH=3
        END:DAYLIGHT
        END:VTIMEZONE
        BEGIN:VEVENT
        ORGANIZER;CN=Gordon Petrie:mailto:gpetrie@silkroadmed.com
        ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;CN=gordon.m.p
        etrie@gmail.com:mailto:gordon.m.petrie@gmail.com
        DESCRIPTION;LANGUAGE=en-US:TEST\n
        UID:040000008200E00074C5B7101A82E008000000002E8D7A06C6F0D501000000000000000
        010000000D8C3B77CCE29774C9712F2ACA4AEB289
        SUMMARY;LANGUAGE=en-US:Test Calendar Event
        DTSTART;TZID=Pacific Standard Time:20200311T090000
        DTEND;TZID=Pacific Standard Time:20200311T093000
        CLASS:PUBLIC
        PRIORITY:5
        DTSTAMP:20200302T191014Z
        TRANSP:OPAQUE
        STATUS:CONFIRMED
        SEQUENCE:1
        LOCATION;LANGUAGE=en-US:
        X-MICROSOFT-CDO-APPT-SEQUENCE:1
        X-MICROSOFT-CDO-OWNERAPPTID:2118324782
        X-MICROSOFT-CDO-BUSYSTATUS:TENTATIVE
        X-MICROSOFT-CDO-INTENDEDSTATUS:BUSY
        X-MICROSOFT-CDO-ALLDAYEVENT:FALSE
        X-MICROSOFT-CDO-IMPORTANCE:1
        X-MICROSOFT-CDO-INSTTYPE:0
        X-MICROSOFT-DONOTFORWARDMEETING:FALSE
        X-MICROSOFT-DISALLOW-COUNTER:FALSE
        X-MICROSOFT-LOCATIONS:[]
        BEGIN:VALARM
        DESCRIPTION:REMINDER
        TRIGGER;RELATED=START:-PT15M
        ACTION:DISPLAY
        END:VALARM
        END:VEVENT
        END:VCALENDAR
        */

        
    }









// C A N C E L    I N V I T E 
    public static String constructCancelIcs(String startIcsTimeString,
                                            String endIcsTimeString,
                                            String currentIcsTimeString,
                                            String organizerEmail,
                                            String sfdcEventId,
                                            Set<String> inviteeEmail,
                                            Integer sequence){
        String txtInvite = '';

        /*
            txtInvite  = 'BEGIN:VCALENDAR\n';
                txtInvite += 'METHOD:CANCEL\n';
                txtInvite += 'PRODID:Microsoft Exchange Server 2010\n';
                txtInvite += 'VERSION:2.0\n';
            
                txtInvite += 'BEGIN:VTIMEZONE\n';
                    txtInvite += 'TZID:GMT Standard Time\n';
                    txtInvite += 'BEGIN:STANDARD\n';
                        txtInvite += 'DTSTART:16010101T020000\n';
                        txtInvite += 'TZOFFSETFROM:+0100\n';
                        txtInvite += 'TZOFFSETTO:+0000\n';
                        txtInvite += 'RRULE:FREQ=YEARLY;INTERVAL=1;BYDAY=-1SU;BYMONTH=10\n';
                    txtInvite += 'END:STANDARD\n';
                        txtInvite += 'BEGIN:DAYLIGHT\n';
                        txtInvite += 'DTSTART:16010101T010000\n';
                        txtInvite += 'TZOFFSETFROM:+0000\n';
                        txtInvite += 'TZOFFSETTO:+0100\n';
                        txtInvite += 'RRULE:FREQ=YEARLY;INTERVAL=1;BYDAY=2SU;BYMONTH=3\n';
                    txtInvite += 'END:DAYLIGHT\n';
                txtInvite += 'END:VTIMEZONE\n';
            
                txtInvite += 'BEGIN:VEVENT\n';
                    txtInvite += 'ORGANIZER;CN=' + organizerEmail + ':mailto:' + organizerEmail + '\n';
                    for(String s : inviteeEmail){
                        txtInvite += 'ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;CN=\n' + s + ':mailto:' + s + '\n';
                    }    
                    txtInvite += 'DESCRIPTION;LANGUAGE=en-US:PROCEDURE EVENT CANCELLATION\n';

                    String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();

                    txtInvite += 'UID:' + baseURL + '/' + sfdcEventId + '\n';
                    //txtInvite += '010000000473F44B3CB137147A8B228DCEB38EE2B\n';
                    txtInvite += 'SUMMARY;LANGUAGE=en-US:Canceled: Procedure Calendar Event\n';
                    txtInvite += 'DTSTART;TZID=GMT Standard Time:' + startIcsTimeString + '\n';
                    txtInvite += 'DTEND;TZID=GMT Standard Time:' + endIcsTimeString + '\n';
                    txtInvite += 'CLASS:PUBLIC\n';
                    txtInvite += 'PRIORITY:1\n';
                    txtInvite += 'DTSTAMP:' + currentICSTimeString + '\n';
                    txtInvite += 'TRANSP:TRANSPARENT\n';
                    txtInvite += 'STATUS:CANCELLED\n';
                    txtInvite += 'SEQUENCE:1\n';
                    txtInvite += 'LOCATION;LANGUAGE=en-US:\n';
                    txtInvite += 'X-MICROSOFT-CDO-APPT-SEQUENCE:1\n';
                    txtInvite += 'X-MICROSOFT-CDO-OWNERAPPTID:2118313742\n';
                    txtInvite += 'X-MICROSOFT-CDO-BUSYSTATUS:FREE\n';
                    txtInvite += 'X-MICROSOFT-CDO-INTENDEDSTATUS:FREE\n';
                    txtInvite += 'X-MICROSOFT-CDO-ALLDAYEVENT:FALSE\n';
                    txtInvite += 'X-MICROSOFT-CDO-IMPORTANCE:2\n';
                    txtInvite += 'X-MICROSOFT-CDO-INSTTYPE:0\n';
                    txtInvite += 'X-MICROSOFT-DONOTFORWARDMEETING:FALSE\n';
                    txtInvite += 'X-MICROSOFT-DISALLOW-COUNTER:FALSE\n';
                txtInvite += 'END:VEVENT\n';
            txtInvite += 'END:VCALENDAR\n';
        */









            txtInvite   = 'BEGIN:VCALENDAR\n';
                txtInvite  += 'METHOD:CANCEL\n';
                txtInvite  += 'PRODID:Microsoft Exchange Server 2010\n';
                txtInvite  += 'VERSION:2.0\n';

                txtInvite  += 'BEGIN:VTIMEZONE\n';
                    txtInvite  += 'TZID:UTC\n';
                        txtInvite  += 'BEGIN:STANDARD\n';
                            txtInvite  += 'DTSTART:16010101T000000\n';
                            txtInvite  += 'TZOFFSETFROM:+0000\n';
                            txtInvite  += 'TZOFFSETTO:+0000\n';
                        txtInvite  += 'END:STANDARD\n';
                        txtInvite  += 'BEGIN:DAYLIGHT\n';
                            txtInvite  += 'DTSTART:16010101T000000\n';
                            txtInvite  += 'TZOFFSETFROM:+0000\n';
                            txtInvite  += 'TZOFFSETTO:+0000\n';
                        txtInvite  += 'END:DAYLIGHT\n';
                txtInvite  += 'END:VTIMEZONE\n';

                txtInvite  += 'BEGIN:VEVENT\n';
                    txtInvite  += 'ORGANIZER;CN=Organizer:mailto:' + organizerEmail + '\n';

                    for(String s : inviteeEmail){
                        txtInvite  += 'ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;CN=\n';
                        txtInvite  += 'Participant:mailto:' + s + '\n';
                    }
                    
                    String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();

                    txtInvite  += 'UID:' + baseURL + '/' + sfdcEventId + '\n';
                    //txtInvite  += '010000000BC8A4F4E00FD7142BC2B53E8D10A85CB\n';
                    txtInvite  += 'SUMMARY;LANGUAGE=en-US:Canceled:\n';
                    txtInvite  += 'DTSTART:' + startIcsTimeString + '\n';
                    txtInvite  += 'DTEND:' + endIcsTimeString + '\n';
                    txtInvite  += 'CLASS:PUBLIC\n';
                    txtInvite  += 'PRIORITY:1\n';
                    txtInvite  += 'DTSTAMP:' + currentIcsTimeString + '\n';
                    txtInvite  += 'TRANSP:TRANSPARENT\n';
                    txtInvite  += 'STATUS:CANCELLED\n';
                    txtInvite  += 'SEQUENCE:1\n';
                    txtInvite  += 'LOCATION;LANGUAGE=en-US:\n';
                    txtInvite  += 'X-MICROSOFT-CDO-APPT-SEQUENCE:1\n';
                    txtInvite  += 'X-MICROSOFT-CDO-OWNERAPPTID:2118330632\n';
                    txtInvite  += 'X-MICROSOFT-CDO-BUSYSTATUS:FREE\n';
                    txtInvite  += 'X-MICROSOFT-CDO-INTENDEDSTATUS:FREE\n';
                    txtInvite  += 'X-MICROSOFT-CDO-ALLDAYEVENT:FALSE\n';
                    txtInvite  += 'X-MICROSOFT-CDO-IMPORTANCE:2\n';
                    txtInvite  += 'X-MICROSOFT-CDO-INSTTYPE:0\n';
                    txtInvite  += 'X-MICROSOFT-DONOTFORWARDMEETING:FALSE\n';
                    txtInvite  += 'X-MICROSOFT-DISALLOW-COUNTER:FALSE\n';
                txtInvite  += 'END:VEVENT\n';
            txtInvite  += 'END:VCALENDAR\n';

        

        return txtInvite;
    }
    
    






    /************************************************************************************************************************************************************************************************/
    /************************************************************************************************************************************************************************************************/
    /***********    Time Converion Utilities                                                                                                                                               **********/
    /************************************************************************************************************************************************************************************************/
    /************************************************************************************************************************************************************************************************/

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








    public static Date stringToDateConverter(String inputString){
        String[] dateStringList = inputString.split('-');
        Integer yrInt = Integer.valueOf(dateStringList[0]);
        Integer moInt = Integer.valueOf(dateStringList[1]);
        Integer dyInt = Integer.valueOf(dateStringList[2]);

        Date resultDate = Date.newInstance(yrInt, moInt, dyInt);
        
        return resultDate;
    
    }









    public static Integer calculateOffset(String timeZoneString, DateTime inputDT){
        Timezone tz = Timezone.getTimeZone(timeZoneString);   
        Integer i = Integer.valueOf(tz.getOffset(inputDt)/3600000);
        return i;  
    }









    public static DateTime dateTimeGMT(DateTime inputDateTime, Integer offset){
        DateTime timeGMT = inputDateTime.addHours(-offset);
        return timeGMT;
    }











    public static Integer calculateDuation(DateTime time1, DateTime time2){
        Integer time1ms = Integer.valueOf(time1.getTime());
        Integer time2ms = Integer.valueOf(time2.getTime());

        Integer difms = math.abs(time1ms - time2ms);
        Integer difsc = difms/1000;
        Integer difmn = difsc/60;

        return difmn;
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








    public static String deconvertTimeZone(String timeZoneString){
        
        String localTimeZone;

        if(timeZoneString == 'America/New_York'){ localTimeZone = 'Eastern'; }
        else if(timeZoneString == 'America/Chicago'){ localTimeZone = 'Central'; }
        else if(timeZoneString == 'America/Denver'){ localTimeZone = 'Mountain'; }
        else if(timeZoneString == 'America/Los_Angeles'){ localTimeZone = 'Pacific'; }
        else if(timeZoneString == 'America/Phoenix'){ localTimeZone = 'Arizona'; }
        else if(timeZoneString == 'America/Anchorage'){ localTimeZone = 'Alaska'; }
        else if(timeZoneString == 'Pacific/Honolulu'){ localTimeZone = 'Hawaii'; }

        return localTimeZone;
    }    








    public static String deconvertTime(String inputTime){

            String timeHr = inputTime.substring(0,2);
            String timeMn = inputTime.substring(2,5);
            String returnTime;
            if(timeHr == '00'){ returnTime = '12' + timeMn + ' AM'; }
            else if(timeHr == '01'){ returnTime = '1' + timeMn + ' AM'; }
            else if(timeHr == '02'){ returnTime = '2' + timeMn + ' AM'; }
            else if(timeHr == '03'){ returnTime = '3' + timeMn + ' AM'; }
            else if(timeHr == '04'){ returnTime = '4' + timeMn + ' AM'; }
            else if(timeHr == '05'){ returnTime = '5' + timeMn + ' AM'; }
            else if(timeHr == '06'){ returnTime = '6' + timeMn + ' AM'; }
            else if(timeHr == '07'){ returnTime = '7' + timeMn + ' AM'; }
            else if(timeHr == '08'){ returnTime = '8' + timeMn + ' AM'; }
            else if(timeHr == '09'){ returnTime = '9' + timeMn + ' AM'; }
            else if(timeHr == '10'){ returnTime = '10' + timeMn + ' AM'; }
            else if(timeHr == '11'){ returnTime = '11' + timeMn + ' AM'; }
            else if(timeHr == '12'){ returnTime = '12' + timeMn + ' PM'; }
            else if(timeHr == '13'){ returnTime = '1' + timeMn + ' PM'; }
            else if(timeHr == '14'){ returnTime = '2' + timeMn + ' PM'; }
            else if(timeHr == '15'){ returnTime = '3' + timeMn + ' PM'; }
            else if(timeHr == '16'){ returnTime = '4' + timeMn + ' PM'; }
            else if(timeHr == '17'){ returnTime = '5' + timeMn + ' PM'; }
            else if(timeHr == '18'){ returnTime = '6' + timeMn + ' PM'; }
            else if(timeHr == '19'){ returnTime = '7' + timeMn + ' PM'; }
            else if(timeHr == '20'){ returnTime = '8' + timeMn + ' PM'; }
            else if(timeHr == '21'){ returnTime = '9' + timeMn + ' PM'; }
            else if(timeHr == '22'){ returnTime = '10' + timeMn + ' PM'; }
            else if(timeHr == '23'){ returnTime = '11' + timeMn + ' PM'; }
            return returnTime;
}






}