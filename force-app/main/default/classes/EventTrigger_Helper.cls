public without sharing class EventTrigger_Helper {

    public static Map<Id, String> eventRtMap(){
        List<RecordType> rtList = [SELECT ID, Name, SObjectType FROM RecordType WHERE SObjectType = 'Event'];
        Map<Id, String> eventRtMap = new Map<Id, String>();
        for(RecordType rt : rtList){
            eventRtMap.put(rt.Id, rt.Name);
        }
        return eventRtMap;
    }



  










    public static void updateRelatedProcedures(List<Event> inputEventList){

        Map<String, Id> eventRecordTypeMap = CalendarAndEvent_Utilities.makeEventRecordTypeMap();
        Id procedureEventRecordTypeId = eventRecordTypeMap.get('Procedure');

        Map<Id, Id> publicTerritoryCalendarMap = CalendarAndEvent_Utilities.publicTerritoryCalendarMap();
        List<Id> publicTerritoryCalendarIdList = publicTerritoryCalendarMap.values();
        Set<Id> publicCalendarIdSet = new Set<Id>();
        for(Id iid : publicTerritoryCalendarIdList){
            publicCalendarIdSet.add(iid);
        }

        List<Event> procedureEventList = new List<Event>();
        for(Event e : inputEventList){
            if(e.RecordTypeId == procedureEventRecordTypeId && publicCalendarIdSet.contains(e.OwnerId)){
                procedureEventList.add(e);
            }
        }

        Map<Id, Id> pfId_to_eId = new Map<Id, Id>();
        for(Event e : procedureEventList){
            pfId_to_eId.put(e.ProcedureFormId__c, e.Id);
        }

        List<Procedure_Form__c> pfList = [SELECT Id, EventIds__c FROM Procedure_Form__c WHERE Id IN : pfId_to_eId.keyset() ];

        for(Procedure_Form__c pf : pfList){
            pf.EventIds__c = pfId_to_eId.get(pf.Id);
        }
        GlobalTriggerSwitch.runProcedureFormTrigger = false;
        update pfList;
        GlobalTriggerSwitch.runProcedureFormTrigger = true;
    }






    public static void sendInviteToOutlook(List<Event> inputEventList, String dmlAction){
  
        SYSTEM.DEBUG('ENTERING EVENT TRIGGER HELPER SEND INVITE TO OUTLOOK');

            // Identify the primary Event being modified
            Event primaryEvent = inputEventList[0];
            Id primaryEventId = primaryEvent.Id;
            
            // GET THE RECORD TYPES FOR EVENTS FOR DIFFERENT EVENT TYPES       
            Map<Id, String> eventRtMap = eventRtMap();
            Id pId;
            Id npId;

            for(Id iid : eventRtMap.KeySet()){
                if(eventRtMap.get(iid) == 'Procedure'){
                    pId = iid;
                }
                if(eventRtMap.get(iid) == 'Non Procedure'){
                    npId = iid;
                }
            }
            SYSTEM.DEBUG('pId = [' + pId + '] npId = [' + npId + '] primaryEvent RT ID = [' + primaryEvent.RecordTypeId + '] primaryEvent.PF ID = [' + primaryEvent.ProcedureFormId__c + ']');


            // PULL PUBLIC CALENDARS TO MAKE A LIST OF ELEGIBLE CALENDARS
            Set<Id> calendarIdSet = new Set<Id>();
            List<Territory__c> terrList = [SELECT Calendar__c FROM Territory__c WHERE Calendar__c <> null];
            for(Territory__c t : terrList){
                calendarIdSet.add(t.Calendar__c);
                SYSTEM.DEBUG('CALENDAR ID SET ADD = [' + t.Calendar__c + ']');
            }

            String userId = UserInfo.getUserId();
                String organizerEmail = [SELECT Email FROM User WHERE Id = : userId LIMIT 1].Email;

// H A N D L E      N O N - P R O C E D U R E     E V E N T S 
            if(primaryEvent.RecordTypeId == npId){

                //Get a set of Master Event Id's
                Set<Id> eventIdSet = new Set<Id> ();
                List<Event> qualEventList = new List<Event>();
                for(Event e : inputEventList){
                    if(e.RecordTypeId == npId && calendarIdSet.contains(e.OwnerId) ){
                        eventIdSet.add(e.Id);
                        qualEventList.add(e);
                    }
                }
            
                eventIdSet.add(primaryEventId);
    
                //Query Event Relation to get a list of Internal Attendees
                List<EventRelation> erList = [SELECT EventId, RelationId, Relation.Email FROM EventRelation WHERE EventId IN : eventIdSet ORDER BY EventId, RelationId ASC];
    
                //Build a Map of Master Events to Attendee Lists
                Map<Id, Set<Id>> eventAttendeeOuterMap = new Map<Id, Set<Id>>();
                Set<Id> eventAttendeeInnerSet = new Set<Id>();
                Set<Id> allAttendeeSet = new Set<Id>();
                Id newEventId;
                Id oldEventId;
        
                for(EventRelation er : erList){   
                    Id idToProcess = er.RelationId;
                    Schema.sObjectType entityType = idToProcess.getSObjectType();
        
                    if(String.valueOf(entityType) == 'User'){
                        newEventId = er.EventId;
                        if(oldEventId == null || newEventId != oldEventId){
                            eventAttendeeInnerSet = new Set<Id>();
                        }
                        eventAttendeeInnerSet.add(er.RelationId);
                        eventAttendeeOuterMap.put(er.EventId, eventAttendeeInnerSet);
                        allAttendeeSet.add(er.RelationId);
                        oldEventId = newEventId;
                    }
                }
        
                //Query User Records to get Map of UserId to Email Address
                List<User> userList = [SELECT Id, Email FROM User WHERE (Id IN : allAttendeeSet AND IsActive = True) or Id = : userId];
                Map<Id, String> emailMap = new Map<Id,String>();
                for(User u : userList){
                    emailMap.put(u.Id, u.Email);
                }
        
                Set<String> sendTo = new Set<String>();
                for(Event e : qualEventList){
                    Set<Id> attendeeIdSet = eventAttendeeOuterMap.get(e.Id);
                    attendeeIdSet.add(userId);
                    for(Id i : attendeeIdSet){
                        String em = emailMap.get(i);
                        sendTo.add(em);
                        SYSTEM.DEBUG('EMAIL ADDED TO DISTI LIST = [' + em + ']');
                    }
                    
                    
                    
                    buildAndSendInvite(e,
                                        sendTo, 
                                        e.Subject,
                                        e.Location_Info__c,
                                        e.Other_Information__c,
                                        e.StartDateTime,
                                        e.EndDateTime,
                                        e.Id,
                                        organizerEmail,
                                        dmlAction);
                }
            }
            

            
            SYSTEM.DEBUG('EXITING EVENT TRIGGER HELPER SEND INVITE TO OUTLOOK');
      }










    public static void buildAndSendInvite(Event e,
                                            Set<String> sendTo, 
                                            String subject,
                                            String locInformation,
                                            String otherInformation,
                                            DateTime startDateTime,
                                            DateTime endDateTime,
                                            String eventId,
                                            String sentFrom,
                                            String dmlAction
                                            ){
            
        SendEmail se = new SendEmail();
        se.sendTo = sendTo;
        se.Subject = subject;

        String currentIcsTimeString = convertDateTimeToIcsString(SYSTEM.now());
        String StartIcsTimeString = convertDateTimeToIcsString(startDateTime);
        String EndIcsTimeString = convertDateTimeToIcsString(endDateTime);

            se.sendInvite(
                e,
                startIcsTimeString,
                endIcsTimeString,
                currentIcsTimeString,
                sentFrom,
                sendTo,
                eventId,
                subject,
                locInformation,
                otherInformation,
                dmlAction);
    }








    public class SendEmail {
        Map<Id, String> eventRtMap = eventRtMap();
        public Set<String> sendTo { get; set; }
        public String Subject { get; set; }
        public Event objEvent{get;set;}
        public SendEmail() {}
        public PageReference sendInvite(Event e,
                                        String startIcsTimeString,
                                        String endIcsTimeString,
                                        String currentIcsTimeString,
                                        String organizerEmail,
                                        Set<String> inviteeEmail,
                                        String sfdcEventId, 
                                        String subject,
                                        String location,
                                        String otherInformation,
                                        String dmlAction) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> toAddresses = new List<String>(sendTo);
            //toAddresses = sendTo;
            mail.setToAddresses(toAddresses);
            mail.setSubject(Subject);

            String domain = String.valueOf(System.Url.getSalesforceBaseUrl().toExternalForm());
            domain = domain.replace('.', ',');
            domain = domain.split(',')[0];
            
            String emailBody;

                
            String activityDateString = String.valueOf(e.ActivityDate);
            
            if(eventRtMap.get(e.RecordTypeId) == 'Non Procedure'){
            
                emailBody = 'NON PROCEDURE GROUP EVENT \n';
                
                if(dmlAction == 'DELETE'){
                    emailBody += '* * * C A N C E L L E D    N O N - P R O C E D U R E     E V E N T * * *  \n Original Schedule:  \n';
                }
                emailBody += '  Event Date: ' + activityDateString + '\n';
                emailBody += '  Start Time: ' + startIcsTimeString + '\n';
                emailBody += '  End Time:   ' + endIcsTimeString + '\n';
                emailBody += '\n';  
                emailBody += 'LOCATION: \n' + location + '\n';
                if(dmlAction != 'Delete'){
                    emailBody += '\n\n';
                    emailBody += 'LINK TO SALESFORCE EVENT: \n' + domain + '.lightning.force.com/lightning/r/Procedure_Form__c/' + sfdcEventId+ '/view' ;
                }
                emailBody += '\n\n';
                emailBody += 'OTHER INFORMATION: \n' +  otherInformation ;

            }
            mail.setPlainTextBody(emailBody);
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.filename = 'meeting.ics';
            attach.ContentType ='text/calendar; charset=utf-8; method=REQUEST';
            attach.inline = true;
            attach.body = invite(e,
                                startIcsTimeString,
                                endIcsTimeString,
                                currentIcsTimeString,
                                organizerEmail,
                                toAddresses,
                                sfdcEventId, 
                                subject,
                                location,
                                otherInformation,
                                dmlAction);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach});
            Messaging.SendEmailResult[] er = Messaging.sendEmail(new Messaging.Email[] {mail});
            return null;
        }
        private Blob invite(    Event e,
                                String startIcsTimeString,
                                String endIcsTimeString,
                                String currentIcsTimeString,
                                String organizerEmail,
                                String[] toAddresses,
                                String sfdcEventId, 
                                String subject,
                                string location,
                                String otherInformation,
                                String dmlAction) {                   

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

            Integer i =  toAddresses.size();

            for(String s : toAddresses){
                if(s == organizerEmail && dmlAction != 'DELETE'){
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
 
            if(dmlAction == 'DELETE'){
                Integer z = 0;
                if(e.Sequence__c == null){
                    z = 0;
                }
                else{
                    z = Integer.valueOf(e.Sequence__c + 1);
                }
                txtInvite += 'SEQUENCE:' + z + '\n';
            }
            else{
                txtInvite += 'SEQUENCE:' + e.Sequence__c + '\n';
            }

            if(dmlAction == 'DELETE'){
                txtInvite += 'STATUS:CANCELLED' +  '\n';
            }
            txtInvite += 'SUMMARY:TEST INVITE FROM GOOGLE\n';
            txtInvite += 'TRANSP:OPAQUE\n';
            txtInvite += 'END:VEVENT\n';
            txtInvite += 'END:VCALENDAR\n';

            return Blob.valueOf(txtInvite);
        }
    }










    public static void setSequence(List<Event> inputEventList){
        for(Event e : inputEventList){
            if(e.Sequence__c == null){
                e.Sequence__c = 0;
            }
            else{
                e.Sequence__c++;
            }
        }
    }

    








    
    public static void deleteRelatedProcedureEvents(List<Event> inputEventList){

        //Separate RecordType = Procedure Events from Non-Procedure
        List<Event> procedureInputEventList = new List<Event>();
        Set<Id> sourceEventIdSet = new Set<Id>();
        Id rtId = [SELECT Id FROM RecordType WHERE SObjectType = 'Event' AND Name = 'Procedure' LIMIT 1].Id;
        for(Event e : inputEventList){
            if(e.RecordTypeId == rtId){
                procedureInputEventList.add(e);
                sourceEventIdSet.add(e.Id);
            }
        }

        Set<Id> procedureIdSet = new Set<Id>();
        Map<Id, Event> sourceEventMap = new Map<Id, Event>();
        for(Event e : procedureInputEventList){
             procedureIdSet.add(e.ProcedureFormId__c);
        }

        List<Event> deleteEventList = [SELECT Id, ProcedureFormId__c FROM Event WHERE ProcedureFormId__c IN : procedureIdSet AND Id NOT IN :sourceEventIdSet];
        //delete deleteEventList;
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

}