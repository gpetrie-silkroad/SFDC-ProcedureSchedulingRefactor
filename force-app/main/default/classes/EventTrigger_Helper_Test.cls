@isTest(seeAllData=false)
public with sharing class EventTrigger_Helper_Test {
    @isTest static void insertNonProcedureTest() {
        User runAsUser = [Select Id, Email FROM User WHERE Name = 'System Administrator' LIMIT 1];
        //Contact randomContact = [SELECT ID from Contact LIMIT 1];
        System.runAs(runAsUser){
            Id nonProcedureRtId = [SELECT ID FROM RecordType WHERE SObjectType = 'Event' AND Name = 'Non Procedure' LIMIT 1].Id;
            Event newNonProcedureEvent = new Event();
            newNonProcedureEvent.OwnerId = runAsUser.Id;       
            newNonProcedureEvent.RecordTypeId = nonProcedureRtId ;  
            newNonProcedureEvent.ActivityDate = Date.newInstance(2020,4,1);
            newNonProcedureEvent.Description =  'Test';
            newNonProcedureEvent.Other_Information__c = 'Test';
            newNonProcedureEvent.DurationInMinutes =  60;
            newNonProcedureEvent.EndDateTime =  DateTime.newInstance(2020,4,1,12,0,0).addMinutes(60);
            newNonProcedureEvent.Location =  'Test';
            newNonProcedureEvent.Location_Info__c = 'Test' ;
            //newNonProcedureEvent.WhoId =  randomContact.Id; 
            newNonProcedureEvent.ProcedureFormId__c =  null;
            newNonProcedureEvent.ShowAs =  'Busy';
            newNonProcedureEvent.StartDateTime = DateTime.newInstance(2020,4,1,12,0,0);
            newNonProcedureEvent.Subject = 'Test';
            newNonProcedureEvent.Type =  null;
            newNonProcedureEvent.Event_Type__c =  'Physician Lunch';
            newNonProcedureEvent.ActivityDateTime =  DateTime.newInstance(2020,4,1,12,0,0);
            newNonProcedureEvent.Vendor_Credential_Company__c = null;
            newNonProcedureEvent.Local_Schedule__c =  null;
            newNonProcedureEvent.Local_Time_Zone__c = null ;
            newNonProcedureEvent.Sequence__c = 0;
            newNonProcedureEvent.SRM_Attendees__c = runAsUser.Id ;
            insert newNonProcedureEvent;
        
            
            Set<String> sendTo = new Set<String>();
            sendTo.add('1@yopmail.com');
            sendTo.add('2@yopmail.com');
            EventTrigger_Helper.buildAndSendInvite(newNonProcedureEvent,
                    sendTo, 
                    'Test',
                    'Test',
                    'Test',
                    DateTime.newInstance(2020,4,1,12,0,0),
                    DateTime.newInstance(2020,4,1,12,0,0).addMinutes(60),
                    newNonProcedureEvent.Id,
                    RunAsUser.Email,
                    'CREATE'
                    );

            EventTrigger_Helper.buildAndSendInvite(newNonProcedureEvent,
                    sendTo, 
                    'Test',
                    'Test',
                    'Test',
                    DateTime.newInstance(2020,4,1,12,0,0),
                    DateTime.newInstance(2020,4,1,12,0,0).addMinutes(60),
                    newNonProcedureEvent.Id,
                    RunAsUser.Email,
                    'UPDATE'
                    );

            update newNonProcedureEvent;
            delete newNonProcedureEvent;
        
        }


    }







        @isTest static void insertUpdateProcedureTest() {
                UnitTestDataFactory.createProdcedure_Forms();
                
                User runAsUser = [Select Id, Email FROM User WHERE Name = 'System Administrator' LIMIT 1];
                List<User> randUserList = [Select Id, Email FROM User WHERE IsActive = TRUE AND UserRoleId <> null AND UserRole.Name NOT IN ('SRM Senior Executive', 'OUS Europe', 'OUS Clinical Team') LIMIT 3];

                Procedure_Form__c pf = [SELECT Id FROM Procedure_Form__c LIMIT 1];

                //Contact randomContact = [SELECT ID from Contact LIMIT 1];
                System.runAs(runAsUser){
                    Id procedureRtId = [SELECT ID FROM RecordType WHERE SObjectType = 'Event' AND Name = 'Procedure' LIMIT 1].Id;
                    List<Event> eventInsertList = new List<Event>();
                    for(User u: randUserList){
                        Event newProcedureEvent = new Event();
                        newProcedureEvent.OwnerId = u.Id;       
                        newProcedureEvent.RecordTypeId = procedureRtId ;  
                        newProcedureEvent.ActivityDate = Date.newInstance(2020,4,1);
                        newProcedureEvent.Description =  'Test';
                        newProcedureEvent.Other_Information__c = 'Test';
                        newProcedureEvent.DurationInMinutes =  60;
                        newProcedureEvent.EndDateTime =  DateTime.newInstance(2020,4,1,12,0,0).addMinutes(60);
                        newProcedureEvent.Location =  'Test';
                        newProcedureEvent.Location_Info__c = 'Test' ;
                        //newProcedureEvent.WhoId =  randomContact.Id; 
                        newProcedureEvent.ProcedureFormId__c =  pf.Id;
                        newProcedureEvent.ShowAs =  'Busy';
                        newProcedureEvent.StartDateTime = DateTime.newInstance(2020,4,1,12,0,0);
                        newProcedureEvent.Subject = 'Test';
                        newProcedureEvent.Type =  null;
                        newProcedureEvent.Event_Type__c =  'Procedure';
                        newProcedureEvent.ActivityDateTime =  DateTime.newInstance(2020,4,1,12,0,0);
                        newProcedureEvent.Vendor_Credential_Company__c = null;
                        newProcedureEvent.Local_Schedule__c =  null;
                        newProcedureEvent.Local_Time_Zone__c = null ;
                        newProcedureEvent.Sequence__c = null;
                        newProcedureEvent.SRM_Attendees__c = runAsUser.Id ;

                        eventInsertList.add(newProcedureEvent);
                    
                    }
                    insert eventInsertList;

                    Event modEvent = eventInsertList[0];

                    DateTime newStartDateTime = modEvent.StartDateTime.addMinutes(60);
                    DateTime newEndDateTime = modEvent.EndDateTime.addMinutes(60);
                    modEvent.ActivityDateTime = newStartDateTime;
                    modEvent.StartDateTime = newStartDateTime;
                    modEvent.EndDateTime = newEndDateTime;
                    
                    Test.startTest();
                    update modEvent;
                    Test.stopTest();
            }
    
    } 
    










    @isTest static void insertDeleteProcedureTest() {
        UnitTestDataFactory.createProdcedure_Forms();
        
        User runAsUser = [Select Id, Email FROM User WHERE Name = 'System Administrator' LIMIT 1];
        List<User> randUserList = [Select Id, Email FROM User WHERE IsActive = TRUE AND UserRoleId <> null AND UserRole.Name NOT IN ('SRM Senior Executive', 'OUS Europe', 'OUS Clinical Team') LIMIT 3];

        Procedure_Form__c pf = [SELECT Id FROM Procedure_Form__c LIMIT 1];

        //Contact randomContact = [SELECT ID from Contact LIMIT 1];
        System.runAs(runAsUser){
            Id procedureRtId = [SELECT ID FROM RecordType WHERE SObjectType = 'Event' AND Name = 'Procedure' LIMIT 1].Id;
            List<Event> eventInsertList = new List<Event>();
            for(User u: randUserList){
                Event newProcedureEvent = new Event();
                newProcedureEvent.OwnerId = u.Id;       
                newProcedureEvent.RecordTypeId = procedureRtId ;  
                newProcedureEvent.ActivityDate = Date.newInstance(2020,4,1);
                newProcedureEvent.Description =  'Test';
                newProcedureEvent.Other_Information__c = 'Test';
                newProcedureEvent.DurationInMinutes =  60;
                newProcedureEvent.EndDateTime =  DateTime.newInstance(2020,4,1,12,0,0).addMinutes(60);
                newProcedureEvent.Location =  'Test';
                newProcedureEvent.Location_Info__c = 'Test' ;
                //newProcedureEvent.WhoId =  randomContact.Id; 
                newProcedureEvent.ProcedureFormId__c =  pf.Id;
                newProcedureEvent.ShowAs =  'Busy';
                newProcedureEvent.StartDateTime = DateTime.newInstance(2020,4,1,12,0,0);
                newProcedureEvent.Subject = 'Test';
                newProcedureEvent.Type =  null;
                newProcedureEvent.Event_Type__c =  'Procedure';
                newProcedureEvent.ActivityDateTime =  DateTime.newInstance(2020,4,1,12,0,0);
                newProcedureEvent.Vendor_Credential_Company__c = null;
                newProcedureEvent.Local_Schedule__c =  null;
                newProcedureEvent.Local_Time_Zone__c = null ;
                newProcedureEvent.Sequence__c = null;
                newProcedureEvent.SRM_Attendees__c = runAsUser.Id ;

                eventInsertList.add(newProcedureEvent);
            
            }
            insert eventInsertList;

        
            Test.startTest();
            delete eventInsertList;
            Test.stopTest();
        }
    }
}