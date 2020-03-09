({
	// Fetch the accounts from the Apex controller
  	getAccountList: function(component) {
    	var action = component.get('c.getAccountList');

    	// Set up the callback
    	var self = this;
        var recordId = component.get("v.simpleRecord.Account__c");
        action.setParams({
        		inputId : recordId
    	});
    	action.setCallback(this, function(actionResult) {
     		component.set('v.accounts', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
 





    getAccount: function(component) {
    	var action = component.get('c.getAccount');
        var acctId = component.get('v.simpleRecord.Account__c');  // FOR TESTING USING AURA REPLACD THIS LINE WITH "0014100001BvjyvAAB";
        
        action.setParams({
            "acctId": acctId
        });

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.account', actionResult.getReturnValue());
            
            var a = component.get('v.account');
            component.set("v.hospitalName", a.Name);
            component.set("v.hospitalStreet", a.BillingStreet);
            component.set("v.hospitalCity", a.BillingCity);
            component.set("v.hospitalState", a.BillingState);
            component.set("v.vendorCredentailCompany", a.Vendor_Credential_Company__c);

           // var timeZone = component.get(a.Time_Zone__c);
            
            component.set("v.hospitalTimeZone", a.Time_Zone__c);
            
            var locInfo = a.Name;
            component.set("v.locationInfo", a.Name + '\n' + a.BillingStreet + '\n' + a.BillingCity + ', ' + a.BillingState);
            
        });

        $A.enqueueAction(action);
    },





        
     
      
    setPreCaseParams: function(component) {
        var preCaseId = component.get("v.simpleRecord.Pre_Case_Id__c");
        var noPreCaseId = component.get("v.simpleRecord.No_Pre_Case_Id__c");
        
        if(noPreCaseId){
            component.set("v.disNoPreCaseId", false);
            component.set("v.disPreCaseId", true);
            component.set("v.preCaseId", "SRM-");
        }
        else{
            component.set("v.disNoPreCaseId", true);
            component.set("v.disPreCaseId", false);
            component.set("v.preCaseId", preCaseId);
        } 
    },







    cancelEvent: function(component){

        alert(" * * * * * * * * * * Cancel Event Started * * * * * * * * * * ");

        var procedureFormRecordId = component.get("v.simpleRecord.Id");
        var eventId = component.get("v.simpleRecord.EventIds__c");

        var procedureDate = component.get("v.simpleRecord.Procedure_Date__c");
        var timeZoneString = component.get("v.hospitalTimeZone");
        var startTime = component.get("v.startTime");
        var endTime = component.get("v.endTime");
        var localStartTime;
        var accountId = component.get("v.simpleRecord.Account__c");
        var localTimeZone;
        var localStartTime;
        var localEndTime;

        if(timeZoneString == "America/New_York"){ localTimeZone = "Eastern"; }
            else if(timeZoneString == "America/Chicago"){ localTimeZone = "Central"; }
            else if(timeZoneString == "America/Denver"){ localTimeZone = "Mountain"; }
            else if(timeZoneString == "America/Los_Angeles"){ localTimeZone = "Pacific"; }
            else if(timeZoneString == "America/Phoenix"){ localTimeZone = "Arizona"; }
            else if(timeZoneString == "America/Anchorage"){ localTimeZone = "Alaska"; }
            else if(timeZoneString == "Pacific/Honolulu"){ localTimeZone = "Hawaii"; }

            var startTimeHr = startTime.substring(0,2);
            var startTimeMn = startTime.substring(2,5);
            if(startTimeHr == "00"){ localStartTime = "12" + startTimeMn + " AM"; }
            else if(startTimeHr == "01"){ localStartTime = "1" + startTimeMn + " AM"; }
            else if(startTimeHr == "02"){ localStartTime = "2" + startTimeMn + " AM"; }
            else if(startTimeHr == "03"){ localStartTime = "3" + startTimeMn + " AM"; }
            else if(startTimeHr == "04"){ localStartTime = "4" + startTimeMn + " AM"; }
            else if(startTimeHr == "05"){ localStartTime = "5" + startTimeMn + " AM"; }
            else if(startTimeHr == "06"){ localStartTime = "6" + startTimeMn + " AM"; }
            else if(startTimeHr == "07"){ localStartTime = "7" + startTimeMn + " AM"; }
            else if(startTimeHr == "08"){ localStartTime = "8" + startTimeMn + " AM"; }
            else if(startTimeHr == "09"){ localStartTime = "9" + startTimeMn + " AM"; }
            else if(startTimeHr == "10"){ localStartTime = "10" + startTimeMn + " AM"; }
            else if(startTimeHr == "11"){ localStartTime = "11" + startTimeMn + " AM"; }
            else if(startTimeHr == "12"){ localStartTime = "12" + startTimeMn + " PM"; }
            else if(startTimeHr == "13"){ localStartTime = "1" + startTimeMn + " PM"; }
            else if(startTimeHr == "14"){ localStartTime = "2" + startTimeMn + " PM"; }
            else if(startTimeHr == "15"){ localStartTime = "3" + startTimeMn + " PM"; }
            else if(startTimeHr == "16"){ localStartTime = "4" + startTimeMn + " PM"; }
            else if(startTimeHr == "17"){ localStartTime = "5" + startTimeMn + " PM"; }
            else if(startTimeHr == "18"){ localStartTime = "6" + startTimeMn + " PM"; }
            else if(startTimeHr == "19"){ localStartTime = "7" + startTimeMn + " PM"; }
            else if(startTimeHr == "20"){ localStartTime = "8" + startTimeMn + " PM"; }
            else if(startTimeHr == "21"){ localStartTime = "9" + startTimeMn + " PM"; }
            else if(startTimeHr == "22"){ localStartTime = "10" + startTimeMn + " PM"; }
            else if(startTimeHr == "23"){ localStartTime = "11" + startTimeMn + " PM"; }


            var endTimeHr = endTime.substring(0,2);
            var endTimeMn = endTime.substring(2,5);
            if(endTimeHr == "00"){ localEndTime = "12" + endTimeMn + " AM"; }
            else if(endTimeHr == "01"){ localEndTime = "1" + endTimeMn + " AM"; }
            else if(endTimeHr == "02"){ localEndTime = "2" + endTimeMn + " AM"; }
            else if(endTimeHr == "03"){ localEndTime = "3" + endTimeMn + " AM"; }
            else if(endTimeHr == "04"){ localEndTime = "4" + endTimeMn + " AM"; }
            else if(endTimeHr == "05"){ localEndTime = "5" + endTimeMn + " AM"; }
            else if(endTimeHr == "06"){ localEndTime = "6" + endTimeMn + " AM"; }
            else if(endTimeHr == "07"){ localEndTime = "7" + endTimeMn + " AM"; }
            else if(endTimeHr == "08"){ localEndTime = "8" + endTimeMn + " AM"; }
            else if(endTimeHr == "09"){ localEndTime = "9" + endTimeMn + " AM"; }
            else if(endTimeHr == "10"){ localEndTime = "10" + endTimeMn + " AM"; }
            else if(endTimeHr == "11"){ localEndTime = "11" + endTimeMn + " AM"; }
            else if(endTimeHr == "12"){ localEndTime = "12" + endTimeMn + " PM"; }
            else if(endTimeHr == "13"){ localEndTime = "1" + endTimeMn + " PM"; }
            else if(endTimeHr == "14"){ localEndTime = "2" + endTimeMn + " PM"; }
            else if(endTimeHr == "15"){ localEndTime = "3" + endTimeMn + " PM"; }
            else if(endTimeHr == "16"){ localEndTime = "4" + endTimeMn + " PM"; }
            else if(endTimeHr == "17"){ localEndTime = "5" + endTimeMn + " PM"; }
            else if(endTimeHr == "18"){ localEndTime = "6" + endTimeMn + " PM"; }
            else if(endTimeHr == "19"){ localEndTime = "7" + endTimeMn + " PM"; }
            else if(endTimeHr == "20"){ localEndTime = "8" + endTimeMn + " PM"; }
            else if(endTimeHr == "21"){ localEndTime = "9" + endTimeMn + " PM"; }
            else if(endTimeHr == "22"){ localEndTime = "10" + endTimeMn + " PM"; }
            else if(endTimeHr == "23"){ localEndTime = "11" + endTimeMn + " PM"; }

    

        var locInformation = component.get("v.locationInfo");
        var primaryAmId = component.get("v.simpleRecord.AM_Present__c");
        var primaryTdsId = component.get("v.simpleRecord.TDS_Present__c");

        var secondaryTdsId = component.get("v.simpleRecord.Secondary_TDS_Present__c");
        var otherQualifiedSrmId = component.get("v.simpleRecord.Other_Qualified_SRM_Present__c");
        var adId = component.get("v.simpleRecord.AD_Present__c");

        var primaryOpPhysicianId = component.get("v.simpleRecord.Physician_Primary_Operator__c");

        var otherInformation = component.get("v.OtherInformation");
        var vendorCredentailCompany = component.get("v.vendorCredentailCompany");
        var dmlAction = "CANCELLED";

        var action = component.get("c.deleteRelatedEvent");

        var self = this;
        action.setParams({
            procedureFormRecordId : procedureFormRecordId,
            eventId : eventId,
            procedureDate : procedureDate,
            timeZoneString : timeZoneString,
            startTime : startTime,
            endTime : endTime,

            localStartTime : localStartTime,
            localEndTime : localEndTime,
            localTimeZone : localTimeZone,

            accountId : accountId,
            locInformation : locInformation,
            primaryAmId : primaryAmId,
            primaryTdsId : primaryTdsId,

            secondaryTdsId : secondaryTdsId,
            otherQualifiedSrmId : otherQualifiedSrmId,
            adId : adId,

            primaryOpPhysicianId : primaryOpPhysicianId,
            otherInformation : otherInformation,
            vendorCredentailCompany : vendorCredentailCompany,
            dmlAction : dmlAction
        });

        action.setCallback(this, function(actionResult) {
        
            //alert(" * * * * * * * * * * Cancel Event Ended * * * * * * * * * * ");

        });

        $A.enqueueAction(action);
    },


 
 
 

    getEventLinks: function(component){
        
    	var eventIdsString = component.get("v.simpleRecord.EventIds__c");
        var eventId = eventIdsString.split(",")[0];
    
        var recordId = component.get("v.simpleRecord.Id");

        var action = component.get("c.getExistingSchedule");
        var self = this;
          action.setParams({
            "recordId" : recordId
            
          });
          action.setCallback(this, function(actionResult) {
              component.set("v.relatedEvents", actionResult.getReturnValue());
              var relatedEvents = component.get("v.relatedEvents");
              var arrayLength = relatedEvents.length;

              // IF EXISTING SCHEDULED PROCEDURE SET PROCEDURE TIMES
              if(arrayLength >= 1){

                  component.set("v.noRenderDisplayEventLinks", false);
                  //Get one of the related events and set parameters of the Scheduled events on the Edit Form
                  var baseEvent = relatedEvents[0];

                  component.set("v.baseEvent", baseEvent);
                  
                  // Set the times on the Edit form (Note that the Apex called to retrieve these events converts to user's local time).
                  var startDateTime = baseEvent.StartDateTime;
                  var startTime = startDateTime.substring(11, 19);
                  component.set("v.startTime", "05:00:00");

                  var endDateTime = baseEvent.EndDateTime;
                  var endTime = endDateTime.substring(11,19);
                  component.set("v.endTime", "20:00:00");

                  // Get Other event Details details of the scheduled events
                  var eventLocation = baseEvent.Location_Info__c;
                  var eventSubject = baseEvent.Subject;
                  var eventVendorCredCompany = baseEvent.Vendor_Credential_Company__c;
                  var eventDescription = baseEvent.Other_Information__c;
                  var timeZoneString = baseEvent.Local_Time_Zone__c;
                  var localTimeZone;





                  if(timeZoneString == "Eastern"){ localTimeZone = "America/New_York"; }
                  else if(timeZoneString == "Central"){ localTimeZone = "America/Chicago"; }
                  else if(timeZoneString == "Mountain"){ localTimeZone = "America/Denver"; }
                  else if(timeZoneString == "Pacific"){ localTimeZone = "America/Los_Angeles"; }
                  else if(timeZoneString == "Arizona"){ localTimeZone = "America/Phoenix"; }
                  else if(timeZoneString == "Alaska"){ localTimeZone = "America/Anchorage"; }
                  else if(timeZoneString == "Hawaii"){ localTimeZone = "Pacific/Honolulu"; }


                  //set Other Event Details to the Component Page
                  component.set("v.locationInfo", eventLocation);
                  component.set("v.Description", eventDescription);
                  component.set("v.OtherInformation", eventDescription);
                  component.set("v.Subject", eventSubject);
                  component.set("v.hospitalTimeZone", localTimeZone);

                  component.set("v.startTime", startTime);
                  component.set("v.endTime", endTime);

                  var verifyStartTime = component.get("v.startTime");
                  var verifyEndTime = component.get("v.endTime");
              }
              else{
                    component.set("v.delEvent", false);
                    component.set("v.noRenderSimpleSave", true);
                    component.set("v.noRenderSchedulerSave", true);
                    component.set("v.noRenderAddNewEventSave", false);

                    var action2 = component.get("c.getCurrentTime");
                    
                    action2.setCallback(this, function(response) {
                        var result2  = response.getReturnValue();

                        component.set("v.nowTime", result2);         
                        var nowDateTime = component.get("v.nowTime");

                        var currentDate = nowDateTime.substring(0, 10);
                        component.set("v.nowDate", currentDate);
                        component.set('v.SimpleRecord.Procedure_Date__c', currentDate);
                        
                        var currentHour = nowDateTime.substring(11, 13);
                        var currentMin  = nowDateTime.substring(14, 16);
                        var currentMin15;
                        
                        var minute = nowDateTime.substring(14, 16);
                        
                        if(currentMin > "53"){ currentMin15 = "00";}
                        else if(currentMin > "43"){ currentMin15 = "45";}
                        else if(currentMin > "23"){ currentMin15 = "30";}
                        else if(currentMin > "13"){ currentMin15 = "15";}
                        else if(currentMin <= "12"){ currentMin15 = "00";}
                        
                        component.set("v.currentDateTime", nowDateTime);
                        component.set("v.startTime", currentHour + ":" + currentMin15 + ":00");
                        
                        var endHour;
                        if(currentHour == '00'){endHour = '01';}
                        else if(currentHour == '01'){endHour = '02';}
                        else if(currentHour == '02'){endHour = '03';}
                        else if(currentHour == '03'){endHour = '04';}
                        else if(currentHour == '04'){endHour = '05';}
                        else if(currentHour == '05'){endHour = '06';}
                        else if(currentHour == '06'){endHour = '07';}
                        else if(currentHour == '07'){endHour = '08';}
                        else if(currentHour == '08'){endHour = '09';}
                        else if(currentHour == '09'){endHour = '10';}
                        else if(currentHour == '10'){endHour = '11';}
                        else if(currentHour == '11'){endHour = '12';}
                        else if(currentHour == '12'){endHour = '13';}
                        else if(currentHour == '13'){endHour = '14';}
                        else if(currentHour == '14'){endHour = '15';}
                        else if(currentHour == '15'){endHour = '16';}
                        else if(currentHour == '16'){endHour = '17';}
                        else if(currentHour == '17'){endHour = '18';}
                        else if(currentHour == '18'){endHour = '19';}
                        else if(currentHour == '19'){endHour = '20';}
                        else if(currentHour == '20'){endHour = '21';}
                        else if(currentHour == '21'){endHour = '22';}
                        else if(currentHour == '22'){endHour = '23';}
                        else if(currentHour == '23'){endHour = '23';}
                        else {endHour = '00';}
                        
                        component.set("v.endTime", endHour + ":" + currentMin15 + ":00");
                                
                    });
                    $A.enqueueAction(action2);
              }
            
          });
          $A.enqueueAction(action);

        
    },
    









        // Fetch the currentUserRecord from the Apex controller
  	getCurrentTime: function(component) {
    	var action = component.get('c.getCurrentTime');

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set("v.nowTime", actionResult.getReturnValue());         
            var nowDateTime = component.get("v.nowTime");
            
            var currentDate = nowDateTime.substring(0, 10);
            component.set("v.nowDate", currentDate);
            component.set('v.newProcedureForm.Procedure_Date__c', currentDate);
            
            var currentHour = nowDateTime.substring(11, 13);
            var currentMin  = nowDateTime.substring(14, 16);
            var currentMin15;
            
            var minute = nowDateTime.substring(14, 16);
            
            if(currentMin > "53"){ currentMin15 = "00";}
            else if(currentMin > "43"){ currentMin15 = "45";}
            else if(currentMin > "23"){ currentMin15 = "30";}
            else if(currentMin > "13"){ currentMin15 = "15";}
            else if(currentMin <= "12"){ currentMin15 = "00";}
            
            component.set("v.currentDateTime", nowDateTime);
            component.set("v.startTime", currentHour + ":" + currentMin15 + ":00");

            //var testStartTime = component.get("v.startTime");
            //alert("Test Start Time = [" + testStartTime + "]");
            
            var endHour;
            if(currentHour == '00'){endHour = '01';}
            else if(currentHour == '01'){endHour = '02';}
            else if(currentHour == '02'){endHour = '03';}
            else if(currentHour == '03'){endHour = '04';}
            else if(currentHour == '04'){endHour = '05';}
            else if(currentHour == '05'){endHour = '06';}
            else if(currentHour == '06'){endHour = '07';}
            else if(currentHour == '07'){endHour = '08';}
            else if(currentHour == '08'){endHour = '09';}
            else if(currentHour == '09'){endHour = '10';}
            else if(currentHour == '10'){endHour = '11';}
            else if(currentHour == '11'){endHour = '12';}
            else if(currentHour == '12'){endHour = '13';}
            else if(currentHour == '13'){endHour = '14';}
            else if(currentHour == '14'){endHour = '15';}
            else if(currentHour == '15'){endHour = '16';}
            else if(currentHour == '16'){endHour = '17';}
            else if(currentHour == '17'){endHour = '18';}
            else if(currentHour == '18'){endHour = '19';}
            else if(currentHour == '19'){endHour = '20';}
            else if(currentHour == '20'){endHour = '21';}
            else if(currentHour == '21'){endHour = '22';}
            else if(currentHour == '22'){endHour = '23';}
            else if(currentHour == '23'){endHour = '23';}
            else {endHour = '00';}
            
            component.set("v.endTime", endHour + ":" + currentMin15 + ":00");

            // var testEndTime = component.get("v.endTime");
            // alert("Test End Time = [" + testEndTime + "]");
                    
        });
        $A.enqueueAction(action);
    },




    
    // Fetch the currentUserRecord from the Apex controller
	getCurrentUser: function(component) {
   	  var action = component.get('c.getCurrentUser');
      var existingAD = component.get("v.simpleRecord.AD_Present__c");
      var existingAM = component.get("v.simpleRecord.AM_Present__c");
      var existingTDS = component.get("v.simpleRecord.TDS_Present__c");
      var noSRMPresent = component.get("v.simpleRecord.No_SRM_Personnel_Present__c");
      var nullId = component.get("v.nullId");
        
        var fieldResponsibility;

    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
     		component.set('v.currentUser', actionResult.getReturnValue());
            var v = component.get("v.currentUser");
            
            fieldResponsibility = v.Field_Responsibility__c;
            
            if(noSRMPresent != true){
                if(existingAD == null && fieldResponsibility == "Area Director"){
                    component.set("v.simpleRecord.AD_Present__c", v.Id);
                }
                if(existingAM == null && fieldResponsibility == "Area Manager"){
                    component.set("v.simpleRecord.AM_Present__c", v.Id);
                }
                if(existingTDS == null && fieldResponsibility == "Therapy Development Specialist"){
                    component.set("v.simpleRecord.TDS_Present__c", v.Id);
                }
            }
            else{
              component.set("v.simpleRecord.AD_Present__c", nullId);
              component.set("v.simpleRecord.AM_Present__c", nullId);
              component.set("v.simpleRecord.TDS_Present__c", nullId);
              component.set("v.simpleRecord.Secondary_TDS_Present__c", nullId);
              component.set("v.simpleRecord.Other_Qualified_SRM_Present__c", nullId);
            }
            
            
        });
        
        $A.enqueueAction(action);
 
    },



    getTimeListForSelect: function(component){
        var action = component.get("c.getTimeList");
        action.setCallback(this, function(actionResult) {
        	component.set("v.timeList", actionResult.getReturnValue());
        });
        $A.enqueueAction(action)
    },
    
  



    clickNoPreCaseId: function(component, event, helper){
        var selectedCk = event.getSource().get("v.checked");
        component.set("v.newProcedureForm.No_Pre_Case_Id__c", selectedCk);
        if(selectedCk){
            component.set("v.disNoPreCaseId", false);
            component.set("v.preCaseId", "SRM-");
            component.set("v.disPreCaseId", true);
        }
        else{
            
                component.set("v.disNoPreCaseId", false);
                component.set("v.disPreCaseId", false);
            
        }
    },


    onPreCaseIdEntry: function(component, event, helper){
        var preCaseId = component.get("v.preCaseId");
        if(preCaseId != "SRM-" && preCaseId != ""){
            component.set("v.disNoPreCaseId", true);
            component.set("v.disPreCaseId", false);
        }
        else{
            component.set("v.disNoPreCaseId", false);
            component.set("v.disPreCaseId", false);
        }    
    },






    noSRMPresOn: function(component){
      var nullId = component.get("v.nullId");

      //alert("NoSRMPresOn");

      //SET RECORD VALUES TO NULL
      component.set("v.simpleRecord.AD_Present__c", nullId);
      component.set("v.simpleRecord.AM_Present__c", nullId);
      component.set("v.simpleRecord.TDS_Present__c", nullId);
      component.set("v.simpleRecord.Secondary_TDS_Present__c", nullId);
      component.set("v.simpleRecord.Other_Qualified_SRM_Present__c", nullId);



      //SET DISPLAYED VALUES TO DISABLED
      var action = component.get('c.getDisUsers');

      // Set up the callback
      var self = this;
        
      action.setCallback(this, function(actionResult) {
          component.set('v.qualUsers', actionResult.getReturnValue());
          component.set('v.amUsers', actionResult.getReturnValue());
          component.set('v.tdsUsers', actionResult.getReturnValue());
          component.set('v.tds2Users', actionResult.getReturnValue());
          component.set('v.adUsers', actionResult.getReturnValue());
            
        });
        $A.enqueueAction(action);

      //DISABLE THE FIELDS
      component.set("v.adUser_dis", true);
      component.set("v.amUser_dis", true);
      component.set("v.tdsUser_dis", true);
      component.set("v.tds2User_dis", true);
      component.set("v.qualUser_dis", true);

      //SET THE CHECKBOX DISPLAY VALUE
      component.set("v.noSRM_chk", true);

      //SET NO RECORD FIELD VALUE
      component.set("v.simpleRecord.No_SRM_Personnel_Present__c", true);

      //ENABLE THE CHECKBOX
      component.set("v.noSRM_dis", false);
    },





    noSRMPresOff: function(component){
      //SET RECORD VALUE
      component.set("v.simpleRecord.No_SRM_Personnel_Present__c", false);
      //alert("NoSRMPresOff");
      //UNCHECK DISPLAYED CHECKBOX
      component.set("v.noSRM_chk", false);

      //COLLECT RECORD VARIABLES
      var adPresValue   = component.get("v.simpleRecord.AD_Present__c");
      var amPresValue   = component.get("v.simpleRecord.AM_Present__c");
      var tdsPresValue  = component.get("v.simpleRecord.TDS_Present__c");
      var tds2PresValue = component.get("v.simpleRecord.Secondary_TDS_Present__c");

      var qualPresValue = component.get("v.simpleRecord.Other_Qualified_SRM_Present__c");

      //GET CURRENT USER VALUE
      var actionCurrUser = component.get('c.getCurrentUser');
      var currentUser;
      var currentUserId;
      var currentUserFieldResponsibility;
      var self = this;
      actionCurrUser.setCallback(this, function(actionResult) {
          component.set("v.currentUser", actionResult.getReturnValue());
          currentUser = component.get("v.currentUser");   
          currentUserFieldResponsibility = currentUser.Field_Responsibility__c;

          currentUserId = component.get("v.currentUser.Id");

      });
      $A.enqueueAction(actionCurrUser);
    
      



      //GET AD USERS
      var actionADUser = component.get('c.getADUsers');
      var self = this;
      actionADUser.setParams({
            adPresValue : adPresValue
      });
      actionADUser.setCallback(this, function(actionResult) {
         component.set('v.adUsers', actionResult.getReturnValue());
         component.set("v.adUser_dis", false);
         var xId = component.get("v.adUsers")[0].Id;
         component.set("v.simpleRecord.AD_Present__c", xId);
         if(xId != null){
              component.set("v.noSRM_chk", false);
              component.set("v.noSRM_dis", true);
         }
      });
      $A.enqueueAction(actionADUser);


      //GET AM USERS
      var actionAMUser = component.get('c.getAMUsers');
      var self = this;
        actionAMUser.setParams({
            amPresValue : amPresValue
      });
      actionAMUser.setCallback(this, function(actionResult) {
         component.set('v.amUsers', actionResult.getReturnValue());
         component.set("v.amUser_dis", false);
         var xId = component.get("v.amUsers")[0].Id;
         component.set("v.simpleRecord.AM_Present__c", xId);
         if(xId != null){
              component.set("v.noSRM_chk", false);
              component.set("v.noSRM_dis", true);
         }
         component.set("v.simpleRecord.AM_Present__c", xId);
      });
      $A.enqueueAction(actionAMUser);


      //GET TDS USERS
      var actionTDSUser = component.get('c.getTDSUsers');
      var self = this;
        actionTDSUser.setParams({
            tdsPresValue : tdsPresValue
      });
      actionTDSUser.setCallback(this, function(actionResult) {
         component.set('v.tdsUsers', actionResult.getReturnValue());
         component.set("v.tdsUser_dis", false);
         var xId = component.get("v.tdsUsers")[0].Id;
         component.set("v.simpleRecord.TDS_Present__c", xId);
         if(xId != null){
              component.set("v.noSRM_chk", false);
              component.set("v.noSRM_dis", true);





          var actionTds2User = component.get('c.getSecondaryTDUsers');
          var self = this;
          actionTds2User.setParams({
            "tds2PresValue" : tds2PresValue,
            "tdsPresValue" : tdsPresValue
          });
          actionTds2User.setCallback(this, function(actionResult) {
              component.set('v.tds2Users', actionResult.getReturnValue());
              component.set("v.tds2User_dis", false);
          });
          $A.enqueueAction(actionTds2User);





         }
         else{





          var actionTdsDis = component.get('c.getDisUsers');
          var self = this;
          actionTdsDis.setCallback(this, function(actionResult) {
          component.set('v.tds2Users', actionResult.getReturnValue());
            
          });
          $A.enqueueAction(actionTdsDis);
      
          component.set("v.tds2User_dis", true);









         }
         component.set("v.simpleRecord.TDS_Present__c", xId);
      });
      $A.enqueueAction(actionTDSUser);
      



      //GET QUAL USERS
      var actionQualUser = component.get('c.getSMQualUsers');
      var self = this;
        actionQualUser.setParams({
            qualPresValue : qualPresValue,
      });
      actionQualUser.setCallback(this, function(actionResult) {
         component.set('v.qualUsers', actionResult.getReturnValue());
         component.set('v.qualUser_dis', false);
         var xId = component.get("v.qualUsers")[0].Id;
         component.set("v.simpleRecord.Other_Qualified_SRM_Present__c", xId);
         if(xId != null){
              component.set("v.noSRM_chk", false);
              component.set("v.noSRM_dis", true);
         }
      });
      $A.enqueueAction(actionQualUser);

      var nAd = component.get("v.simpleRecord.AD_Present__c");
      var nAm = component.get("v.simpleRecord.AM_Present__c");
      var nTds = component.get("v.simpleRecord.TDS_Present__c");
      var nTds2 = component.get("v.simpleRecord.Secondary_TDS_Present__c");
      var nQual = component.get("v.simpleRecord.Other_Qualified_SRM_Present__c");

      if(nAd == null && nAm == null & nTds == null && nTds2 == null && nQual == null){
          component.set("v.noSRM_chk", false);
          component.set("v.noSRM_dis", false);
      }
      else{
          component.set("v.noSRM_chk", false);
          component.set("v.noSRM_dis", true);
      }   
    },






    setNoSRM: function(component){

      var nAd = component.get("v.simpleRecord.AD_Present__c");
      var nAm = component.get("v.simpleRecord.AM_Present__c");
      var nTds = component.get("v.simpleRecord.TDS_Present__c");
      var nTds2 = component.get("v.simpleRecord.Secondary_TDS_Present__c");
      var nQual = component.get("v.simpleRecord.Other_Qualified_SRM_Present__c");

      if(nAd == null && nAm == null & nTds == null && nTds2 == null && nQual == null){
          component.set("v.noSRM_chk", false);
          component.set("v.noSRM_dis", false);
      }
      else{
          component.set("v.noSRM_chk", false);
          component.set("v.noSRM_dis", true);
      } 
    },
    
    
    
   
    
    
    
    
       // Fetch the accounts from the Apex controller
  	getAMUsers: function(component) {
    	var action = component.get('c.getAMUsers');

    	// Set up the callback
    	var self = this;
        var recordId = component.get("v.simpleRecord.AM_Present__c");
        action.setParams({
        		inputId : recordId
    	});
    	action.setCallback(this, function(actionResult) {
     		component.set('v.amUsers', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },    
    
    
  	getTDSUsers2: function(component) {

        var tds2PresValue= component.get("v.simpleRecord.Secondary_TDS_Present__c");
        var tdsPresValue = component.get("v.simpleRecord.TDS_Present__c");
        
        if(tdsPresValue == null){  
            var action = component.get('c.getDisUsers');
            
            var self = this;
            action.setCallback(this, function(actionResult) {
                component.set("v.tds2Users", actionResult.getReturnValue());
            });
            $A.enqueueAction(action);
            component.set("v.tds2User_dis",true);
            component.set("v.simpleRecord.Secondary_TDS_Present__c", null);
            
        }
        else{
            var action = component.get('c.getSecondaryTDUsers');
            var tdsUser2;
            
            var self = this;
            
            action.setParams({
                "tds2PresValue" : tds2PresValue,
                "tdsPresValue" : tdsPresValue
            });
            action.setCallback(this, function(actionResult) {
                component.set("v.tds2Users", actionResult.getReturnValue());
                tdsUser2 = component.get("v.tds2Users");
            });
            $A.enqueueAction(action);
            component.set("v.tds2User_dis",false);
            component.set("v.simpleRecord.Secondary_TDS_Present__c", tdsUser2);
        }
        
    	
    }, 
    
    
    
    
    
	getTDSUsers: function(component) {
        var action = component.get('c.getTDSUsers');

    	// Set up the callback
    	var self = this;
        var recordId = component.get("v.simpleRecord.TDS_Present__c");
        
        action.setParams({
        		inputId : recordId
    	});
    	action.setCallback(this, function(actionResult) {
     		component.set('v.tdsUsers', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    }, 
    
    
    
  	getDisUsers: function(component) {
    	var action = component.get('c.getDisUsers');

    	// Set up the callback
    	var self = this;
        
    	action.setCallback(this, function(actionResult) {
          component.set('v.qualUsers', actionResult.getReturnValue());
          component.set('v.amUsers', actionResult.getReturnValue());
          component.set('v.tdsUsers', actionResult.getReturnValue());
          component.set('v.tdsUsers2', actionResult.getReturnValue());
          component.set('v.adUsers', actionResult.getReturnValue());
            
        });
        $A.enqueueAction(action);
    }, 
    

    
    
    
    

  	getQualUsers: function(component) {
    	var action = component.get('c.getSMQualUsers');

    	// Set up the callback
    	var self = this;
        var recordId = component.get("v.simpleRecord.Other_Qualified_SRM_Present__c");
        action.setParams({
        		inputId : recordId
    	});
    	action.setCallback(this, function(actionResult) {
     		component.set('v.qualUsers', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    }, 
    
    
    
    

  	getADUsers: function(component) {
    	var action = component.get('c.getADUsers');

    	// Set up the callback
    	var self = this;
        var recordId = component.get("v.simpleRecord.AD_Present__c");
        var noSRM = component.get("v.simpleRecord.No_SRM_Personnel_Present__c");
        action.setParams({
        		inputId : recordId,
            noSRM : noSRM
    	});
    	action.setCallback(this, function(actionResult) {
     		component.set('v.adUsers', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    }, 
    
    
    
    
    
    

  	getProctorList: function(component) {
    	var action = component.get('c.getProctors');
        var accountId = component.get('v.simpleRecord.Account__c');

    	// Set up the callback
    	var self = this;
        var recordId = component.get("v.simpleRecord.SRM_Proctor__c");
        action.setParams({
        		inputId : recordId,
            	accountId : accountId
    	});
    	action.setCallback(this, function(actionResult) {
     		component.set('v.proctors', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    

  	getIqmsCustoNo: function(component) {
    	var action = component.get("c.getIqmsCustomerNumber");

    	// Set up the callback
    	var self = this;
        var acctId = component.get("v.simpleRecord.Account__c");
        action.setParams({
        		acctId : acctId
    	});
    	action.setCallback(this, function(actionResult) {
     		component.set('v.iqmsCustoNo', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
 
    
    
    
    

  	getPhysPrimOpList: function(component) {
      var action = component.get('c.getPhysPrimOpList');
      var accountId = component.get('v.simpleRecord.Account__c');

    	// Set up the callback
    	var self = this;
        var recordId = component.get("v.simpleRecord.Physician_Primary_Operator__c");

        action.setParams({
        		inputId : recordId, 
            accountId : accountId
    	});

    	action.setCallback(this, function(actionResult) {
     		component.set('v.physPrimaryOperators', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    

    
    
    
  	getStenterList: function(component) {
    	var action = component.get('c.getStenters');
      	var accountId = component.get('v.simpleRecord.Account__c');

    	// Set up the callback
    	var self = this;
        var recordId = component.get("v.simpleRecord.Stenter__c");
        action.setParams({
        		inputId : recordId, 
            accountId : accountId
    	});

    	action.setCallback(this, function(actionResult) {
     		component.set('v.stenters', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    
    
    
    
  	getCutdownList: function(component) {
    	var action = component.get('c.getCutdown');
      var accountId = component.get('v.simpleRecord.Account__c');


    	// Set up the callback
    	var self = this;
        var recordId = component.get("v.simpleRecord.Cutdown_Physician__c");
        var t = component.get("v.simpleRecord.Additional_Physician_1__c");

        action.setParams({
        		inputId : recordId, 
            accountId : accountId
    	});

    	action.setCallback(this, function(actionResult) {
     		component.set('v.cutdown', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },





    getAddl1List: function(component) {
      var action = component.get('c.getAddl1');
      var accountId = component.get('v.simpleRecord.Account__c');


      // Set up the callback
      var self = this;
        var recordId = component.get("v.simpleRecord.Additional_Physician_1__c");
      
        action.setParams({
            "recordId" : recordId, 
            "accountId" : accountId
      });

      action.setCallback(this, function(actionResult) {
        component.set('v.addlPhys1s', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },





    getPhysicianList: function(component) {
        var accountId = component.get("v.simpleRecord.Account__c");
        var action = component.get('c.getPhysician');
        

        var self = this;
        var recordId = component.get("v.simpleRecord.Additional_Physician_2__c");
        action.setParams({
            "recordId" : recordId, 
            "accountId" : accountId
        });
      // Set up the callback
      
      action.setCallback(this, function(actionResult) {
        component.set('v.physicians', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },









    
    initTime: function(component, event, helper){
      var inputId = component.get("v.simpleRecord.Id");  
      var action = component.get('c.getProcedureForm');
     // var s2smnEdit = component.find("s2smnEdit");
        
        
        // Set up the callback
    	var self = this;
        action.setParams({
        		inputId  : inputId 
    	});

    	action.setCallback(this, function(actionResult) {
     		component.set("v.simpleRecord2", actionResult.getReturnValue());
            var retVal = component.get("v.simpleRecord2.SkinToSkinTimeMn__c");
            //s2smnEdit.set("v.value")
            
        });
        $A.enqueueAction(action);
              
          
    },
    
    
    
    
    
   fieldAccessSet: function(component) {
       var anaNone = component.get("v.simpleRecord.HRC_ANA_NONE__c");
       var anaNoneState = component.find("anaNone");
       
       
       
       var clinAge = component.find("clinAge");
       var clinAng = component.find("clinAng");
       var clinCcs = component.find("clinCcs");
       var clinChf = component.find("clinChf");
       var clinCni = component.find("clinCni");
       var clinCopd = component.find("clinCopd");
       var clinDiab = component.find("clinDiab");
       var clinHeart = component.find("clinHeart");
       var clinLvef = component.find("clinLvef");
       var clinMi = component.find("clinMi");
       var clinRena = component.find("clinRena");
       var clinStress = component.find("clinStress");
       var clinSurg = component.find("clinSurg");
       var anaCad = component.find("anaCad");
       var anaBila = component.find("anaBila");
       var anaCea = component.find("anaCea");
       var anaCont = component.find("anaCont");
       var anaHigh = component.find("anaHigh");
       var anaHost = component.find("anaHost");
       var anaLaryn = component.find("anaLaryn");
       var anaSpin = component.find("anaSpin");
       var anaTand = component.find("anaTand");
       

       
       if (anaNone == true){
           clinAge.set("v.disabled", true);
           clinAng.set("v.disabled", true);
           clinCcs.set("v.disabled", true);
           clinChf.set("v.disabled", true);
           clinCni.set("v.disabled", true);
           clinCopd.set("v.disabled", true);
           clinDiab.set("v.disabled", true);
           clinHeart.set("v.disabled", true);
           clinLvef.set("v.disabled", true);
           clinMi.set("v.disabled", true);
           clinRena.set("v.disabled", true);
           clinStress.set("v.disabled", true);
           clinSurg.set("v.disabled", true);
           anaCad.set("v.disabled", true);
           anaBila.set("v.disabled", true);
           anaCea.set("v.disabled", true);
           anaCont.set("v.disabled", true);
           anaHigh.set("v.disabled", true);
           anaHost.set("v.disabled", true);
           anaLaryn.set("v.disabled", true);
           anaSpin.set("v.disabled", true);
           anaTand.set("v.disabled", true);
       }
       else if (
           clinAge.get("v.checked") == true || 
           clinAng.get("v.checked") == true ||
           clinCcs.get("v.checked") == true ||
           clinChf.get("v.checked") == true ||
           clinCni.get("v.checked") == true ||
           clinCopd.get("v.checked") == true ||
           clinDiab.get("v.checked") == true ||
           clinHeart.get("v.checked") == true ||
           clinLvef.get("v.checked") == true ||
           clinMi.get("v.checked") == true ||
           clinRena.get("v.checked") == true ||
           clinStress.get("v.checked") == true ||
           clinSurg.get("v.checked") == true ||
           anaCad.get("v.checked") == true ||
           anaBila.get("v.checked") == true ||
           anaCea.get("v.checked") == true ||
           anaCont.get("v.checked") == true ||
           anaHigh.get("v.checked") == true ||
           anaHost.get("v.checked") == true ||
           anaLaryn.get("v.checked") == true ||
           anaSpin.get("v.checked") == true ||
           anaTand.get("v.checked") == true  
       ){
           
           		anaNoneState.set("v.disabled", true);
       }
       else if (clinAge.get("v.checked") == false && 
           clinAng.get("v.checked") == false &&
           clinCcs.get("v.checked") == false &&
           clinChf.get("v.checked") == false &&
           clinCni.get("v.checked") == false &&
           clinCopd.get("v.checked") == false &&
           clinDiab.get("v.checked") == false &&
           clinHeart.get("v.checked") == false &&
           clinLvef.get("v.checked") == false &&
           clinMi.get("v.checked") == false &&
           clinRena.get("v.checked") == false &&
           clinStress.get("v.checked") == false &&
           clinSurg.get("v.checked") == false &&
           anaCad.get("v.checked") == false &&
           anaBila.get("v.checked") == false &&
           anaCea.get("v.checked") == false &&
           anaCont.get("v.checked") == false &&
           anaHigh.get("v.checked") == false &&
           anaHost.get("v.checked") == false &&
           anaLaryn.get("v.checked") == false &&
           anaSpin.get("v.checked") == false &&
           anaTand.get("v.checked") == false &&
           anaNone == false){
           
           		anaNoneState.set("v.disabled", false);
           
       }
       
       //Set Stent 1 and Stent 2 Fields
       var numberofstents = component.find("numberofstents");
       var stentno = numberofstents.get("v.value");
       
       var s1type1 = component.find("s1type1");
       var s1size0 = component.find("s1size0");
       
       var selectstint1typeVal = component.get("v.simpleRecord.Stent_No_1_Type__c");
       var selectstint1type = component.find("selectstint1type");
       var otherstint1type = component.find("otherstint1type");
       var selectstint1size = component.find("selectstint1size");
       var stint1lotno = component.find("stint1lotno");
        
       var s2type1 = component.find("s2type1");
       var s2size0 = component.find("s2size0");
       
       var selectstint2typeVal = component.get("v.simpleRecord.Stent_No_2_Type__c");
       var selectstint2type = component.find("selectstint2type");
       var otherstint2type = component.find("otherstint2type");
       var selectstint2size = component.find("selectstint2size");
       var stint2lotno = component.find("stint2lotno");
         
       var disabled = "- DISABLED -";
       var noneSel = "- None Selected -";
       var defaultChoice = "SRM ENROUTE";
       
       if(stentno == null || stentno == "" || stentno == "None" || stentno == "- None Selected -"){
           
           selectstint1type.set("v.value", disabled);
           selectstint1type.set("v.disabled", true);
           otherstint1type.set("v.value", "");
           otherstint1type.set("v.disabled", true);
           selectstint1size.set("v.value", disabled);
           selectstint1size.set("v.disabled", true);
           stint1lotno.set("v.value", "");
           stint1lotno.set("v.disabled", true);
           
           selectstint2type.set("v.value", disabled);
           selectstint2type.set("v.disabled", true);
           otherstint2type.set("v.value", "");
           otherstint2type.set("v.disabled", true);
           selectstint2size.set("v.value", disabled);
           selectstint2size.set("v.disabled", true);
           stint2lotno.set("v.value", "");
           stint2lotno.set("v.disabled", true);
                      
           s1type1.set("v.label" , disabled);
           s1size0.set("v.label", disabled);
           s2type1.set("v.label", disabled);
           s2size0.set("v.label", disabled);           
       }
       else if (stentno == "1"){
         
           if(selectstint1typeVal == "Other"){
           		otherstint1type.set("v.disabled", false);
           }
           else{
               	otherstint1type.set("v.value", "");
           		otherstint1type.set("v.disabled", true);
           }
           
           selectstint2type.set("v.value", disabled);
           selectstint2type.set("v.disabled", true);
           otherstint2type.set("v.value", "");
           otherstint2type.set("v.disabled", true);
           selectstint2size.set("v.value", disabled);
           selectstint2size.set("v.disabled", true);
           stint2lotno.set("v.value", "");
           stint2lotno.set("v.disabled", true);
                     
           s2type1.set("v.label", disabled);
           s2size0.set("v.label", disabled);           
           
           
       }
       else if (stentno == "2"){
           if(selectstint1typeVal == "Other"){
           		otherstint1type.set("v.disabled", false);
           }
           else{
               	otherstint1type.set("v.value", "");
           		otherstint1type.set("v.disabled", true);
           }
           
           if(selectstint2typeVal == "Other"){
           		otherstint2type.set("v.disabled", false);
           }
           else{
               	otherstint2type.set("v.value", "");
           		otherstint2type.set("v.disabled", true);
           }
       }
      
 		//SET MPK MFG OTHER STATUS
     	var mpkMfg = component.get("v.simpleRecord.MPK_Manufacturer__c");
        var otherMpkMfg = component.find("otherMpkMfg");
        if(mpkMfg == "Other"){
            otherMpkMfg.set("v.disabled", false);   
        }
        else{
        	otherMpkMfg.set("v.value", "");
            otherMpkMfg.set("v.disabled", true);
        }
       
       //SET Art Sheath Placement Wire Other Status
       	var artsheathpplacementwire = component.get("v.simpleRecord.Arterial_Sheath_Placement_Wire__c");
        var otherartsheathpplacementwire = component.find("otherartsheathpplacementwire");
       if(artsheathpplacementwire == "Other"){
           otherartsheathpplacementwire.set("v.disabled", false);
       }
       else{
           otherartsheathpplacementwire.set("v.value", "");
           otherartsheathpplacementwire.set("v.disabled", true);
       }
       
       //SET Guidewire MFG Other Status
       	var guidewireMfg = component.get("v.simpleRecord.Guidewire_Manufacturer__c");
        var otherguidewire = component.find("otherguidewire");
       if(guidewireMfg == "Other"){
           otherguidewire.set("v.disabled", false);
       }
       else{
           otherguidewire.set("v.value", "");
           otherguidewire.set("v.disabled", true);
       }
       
        //SET PreDilSize Other Status
       	var predilsize = component.get("v.simpleRecord.Pre_Dilation_Balloon_Size__c");
        var preDilOtherSize = component.find("preDilOtherSize");
       if(predilsize == "Other Size"){
           preDilOtherSize.set("v.disabled", false);
       }
       else{
           preDilOtherSize.set("v.value", "");
           preDilOtherSize.set("v.disabled", true);
       }
       
        //SET PostDilSize Other Status
       	var postDilsize = component.get("v.simpleRecord.Post_Dialation_Balloon_Size__c");
        var postDilOtherSize = component.find("postDilOtherSize");
       if(postDilsize == "Other Size"){
           postDilOtherSize.set("v.disabled", false);
       }
       else{
           postDilOtherSize.set("v.value", "");
           postDilOtherSize.set("v.disabled", true);
       }
       
        //SET Local Complications Other Status
       	var localcomplications = component.get("v.simpleRecord.Local_Complications__c");
        var otherLocalComplications = component.find("otherLocalComplications");
       if(localcomplications == "Other"){
           otherLocalComplications.set("v.disabled", false);
       }
       else{
           otherLocalComplications.set("v.value", "");
           otherLocalComplications.set("v.disabled", true);
       }
    },
    
    
    
    

    setTimeStamps: function(component) {
       	var skinToSkinTimeTxt = component.get("v.simpleRecord.SkinToSkinTimeTxt__c");
        var reverseFlowTimeTxt = component.get("v.simpleRecord.ReverseFlowTimeTxt__c");
        var fluoroTimeTxt = component.get("v.simpleRecord.FluoroTimeMinutesTxt__c");
        
        if(!skinToSkinTimeTxt){skinToSkinTimeTxt = '00:00:00'}
        if(!reverseFlowTimeTxt){reverseFlowTimeTxt = '00:00:00'}
        if(!fluoroTimeTxt){fluoroTimeTxt = '00:00:00'}
      
        var s2sHr = skinToSkinTimeTxt.split(':')[0];
        var s2sMn = skinToSkinTimeTxt.split(':')[1];
        var s2sSs = skinToSkinTimeTxt.split(':')[2];
        
        var rftHr = reverseFlowTimeTxt.split(':')[0];
        var rftMn = reverseFlowTimeTxt.split(':')[1];
        var rftSs = reverseFlowTimeTxt.split(':')[2];
        
        var ftHr = fluoroTimeTxt.split(':')[0];
        var ftMn = fluoroTimeTxt.split(':')[1];
        var ftSs = fluoroTimeTxt.split(':')[2];
        
        component.set("v.s2sTimeTxtEnterHrA", s2sHr);
        component.set("v.s2sTimeTxtEnterMnA", s2sMn);
        component.set("v.s2sTimeTxtEnterSsA", s2sSs);
        component.set("v.s2sStatedTime", skinToSkinTimeTxt);
        
        component.set("v.rftTimeTxtEnterHrA", rftHr);
        component.set("v.rftTimeTxtEnterMnA", rftMn);
        component.set("v.rftTimeTxtEnterSsA", rftSs);
        component.set("v.rftStatedTime", reverseFlowTimeTxt);
        
        component.set("v.ftTimeTxtEnterHrA", ftHr);
        component.set("v.ftTimeTxtEnterMnA", ftMn);
        component.set("v.ftTimeTxtEnterSsA", ftSs);
        component.set("v.ftStatedTime", fluoroTimeTxt);
       
    },    
    
    
    
    
	checkTest: function(target){
        
       
        var nm = target.getLocalId();
        var unit = nm.substr(nm.length -2);
        var targetValue = target.get('v.value');
        var testedValue = Number(targetValue);
        
        if(targetValue.includes('.') || targetValue.includes(':') || targetValue.includes('-')){
            alert('Only Enter Positive Integers!');
            target.set('v.class', "redBGColor");
        }
        else if(isNaN(testedValue)){        	
                alert('Only Enter Positive Integers!');
                target.set('v.class', "redBGColor");
        }        	
        else if(unit == 'Hr' && testedValue > 24 || testedValue < 0 ){
                alert('Range must be 0-24');
                target.set('v.class', "redBGColor");
        }
        else if((unit == 'Mn' || unit == 'Ss') && testedValue > 59 || testedValue < 0 ){
                alert('Range must be 0-59');
                target.set('v.class', "redBGColor");
        }
        else{
                target.set('v.class', "whiteBGColor");
        }
       
    }
    
})