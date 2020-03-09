({
    handleRecordUpdated: function(component, event, helper) {
                  
        var eventParams = event.getParams(); 
		 
        if(eventParams.changeType === "LOADED") {
           // record is loaded (render other component which needs record data value)
            console.log("Record is loaded successfully.");
 
            helper.getCurrentUser(component);
            
            helper.getTimeListForSelect(component);
                      
            helper.getAccountList(component);
            
           	var tds1 = component.get("v.simpleRecord.TDS_Present__c");
           	var tds2 = component.get("v.simpleRecord.Secondary_TDS_Present__c");
            var noSRMPres = component.get("v.simpleRecord.No_SRM_Personnel_Present__c");

            var noPreCase = component.get("v.simpleRecord.No_Pre_Case_Id__c");
            
            var eventIds = component.get("v.simpleRecord.EventIds__c");

            if(noSRMPres == true){
                helper.noSRMPresOn(component);
            }
            else{
                helper.noSRMPresOff(component);
            }

            if(tds1 != null){
                component.set("v.tds2User_dis", false);
            }
            else{
                component.set("v.tds2User_dis", true);
            }
                 
            helper.getTDSUsers2(component);
            helper.getProctorList(component);
            helper.getPhysPrimOpList(component);
            helper.getStenterList(component);
            helper.getCutdownList(component);
            helper.getAddl1List(component);
            helper.getIqmsCustoNo(component);
            helper.setTimeStamps(component);
            helper.getPhysicianList(component);
            helper.setPreCaseParams(component);
         
            var selected =  component.find("completion").get("v.value");
            var resForAbort = component.find("reasonforabort");

            var eventId = component.get("v.simpleRecord.EventIds__c");
            var haveSchedule;
            var nullval;

            if(eventId != null && eventId != ''){
                haveSchedule = true;
            }
            else{
                haveSchedule = false;
            }

            if(selected == "Scheduled" ){
            
                component.set("v.simpleRecord.Reason_for_Procedure_Turn_Down__c", nullval);
                component.set("v.noRenderBottom", true);
                component.set("v.noRenderScheduler", false);
                component.set("v.hideReasonForTurnDown", true);
                component.set("v.resForAbort_disabled", true);
            
                if(haveSchedule){
                    component.set("v.delEvent", false);
                    component.set("v.noRenderSimpleSave", true);
                    component.set("v.noRenderSchedulerSave", false);
                    component.set("v.noRenderAddNewEventSave", true);
                    helper.getEventLinks(component);
                }
                else if(!haveSchedule){
                    component.set("v.delEvent", false);
                    component.set("v.noRenderSimpleSave", true);
                    component.set("v.noRenderSchedulerSave", true);
                    component.set("v.noRenderAddNewEventSave", false);
                }
             }
             else if(selected == "Procedure Turned Down"){
                var primaryPhys = component.get("v.simpleRecord.Physician_Primary_Operator__c");
                //alert("primary Phys Operatior Id = [" + primaryPhys + "]");
                component.set("v.selectedPrimaryPhysicianOperator", primaryPhys);
                component.set("v.noRenderBottom", true);
                component.set("v.noRenderScheduler", true);
                component.set("v.hideReasonForTurnDown", false);
                component.set("v.stentorAndCutdownRequired", false);
                component.set("v.resForAbort_disabled", true);  
                
                component.set("v.noRenderSimpleSave", false);
                component.set("v.noRenderSchedulerSave", true);
                component.set("v.noRenderAddNewEventSave", true);

                if(haveSchedule){
                    alert("WARNING: If you save this Procedure Form with a Status of \n \"Procedure Turned Down,\" any associated event will be cancelled");
                    component.set("v.delEvent", true);
                    helper.getEventLinks(component);
                }
            }
            else if(selected == "Cancelled/Rescheduled"){
                component.set("v.selectedPrimaryPhysicianOperator", primaryPhys);
                component.set("v.noRenderBottom", true);
                component.set("v.noRenderScheduler", true);
                component.set("v.hideReasonForTurnDown", true);
                component.set("v.stentorAndCutdownRequired", false);
                component.set("v.resForAbort_disabled", false);  
                
                component.set("v.noRenderSimpleSave", false);
                component.set("v.noRenderSchedulerSave", true);
                component.set("v.noRenderAddNewEventSave", true);

                if(haveSchedule){
                    alert("WARNING: If you save this Procedure Form with a Status of \n \"Procedure Turned Down,\" any associated event will be cancelled");
                    component.set("v.delEvent", true);
                    helper.getEventLinks(component);
                }  
            }
            else{
                component.set("v.noRenderBottom", false);
                component.set("v.noRenderScheduler", true);
                component.set("v.hideReasonForTurnDown", true);

                component.set("v.noRenderSimpleSave", false);
                component.set("v.noRenderSchedulerSave", true);
                component.set("v.noRenderAddNewEventSave", true);

                helper.fieldAccessSet(component);
                helper.getTDSUsers2
                if(haveSchedule){
                    alert("WARNING: If you save this Procedure Form with a Status of \n \"Procedure Turned Down,\" any associated event will be cancelled");
                    component.set("v.delEvent", true);
                    helper.getEventLinks(component);
                }
            }
        
            
            if( selected == "Converted to CEA" || selected == "Converted to TF-CAS" || selected == "Aborted" ){
               resForAbort.set("v.disabled", false); 
                if(haveSchedule){
                    alert("WARNING: If you save this Procedure Form with a Status of \n \"Procedure Turned Down,\" any associated event will be cancelled");
                    component.set("v.delEvent", true);
                    helper.getEventLinks(component);
                }
            }
            else {
                //resForAbort.set("v.disabled" , true);
            }
        
            var recordId = component.get("v.recordId");
            
            var action = component.get("c.getProcedureForm");
            action.setParams({
        		inputId : recordId
    		});
            action.setCallback(this, function(a) {
                if (a.getState() === "SUCCESS") {
                    component.set("v.contact", a.getReturnValue());
                } else if (a.getState() === "ERROR") {
                    $A.log("Errors", a.getError());
                }
            });

            
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    
        //Determine what ui is appropriate
        var action1 = component.get("c.getUIThemeDescription");
        action1.setCallback(this, function(b){
        	component.set("v.Name", a.getReturnValue());                    
        	if(b.getReturnValue() == 'Theme4t'){
            	component.set("v.Desc", "View is Mobile");
                component.set("v.isLEX", true);
        	}
            else{
                    component.set("v.Desc", "View is Not Mobile");
                    component.set("v.isLEX", false);
            }
    	});
        
    },
    
    
    
    
    navigateToRecordId: function(component, event){
        var idx= event.getSource().get("v.value");
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": idx,
            "slideDevName": "view"

        });
        navEvt.fire(); 
    },




    onPreCaseIdEntry: function(component, event, helper){
        var preCaseId = component.get("v.preCaseId");
       
        var n = 0;
        
        if(preCaseId != null){
           n = preCaseId.length;
        }

        var nullVal;

        var noPreCaseId = component.get("v.simpleRecord.No_Pre_Case_Id__c");


        if(preCaseId != "SRM-" && preCaseId != "" && preCaseId != null){
            if(n < 12){
                component.set("v.disNoPreCaseId", false);
                component.set("v.disPreCaseId", false);
                component.set("v.simpleRecord.Pre_Case_Id__c", nullVal);
            }
            else{
                component.set("v.disNoPreCaseId", true);
                component.set("v.disPreCaseId", false);
                component.set("v.simpleRecord.Pre_Case_Id__c", preCaseId);
            }    
        }
        else if(noPreCaseId){
            component.set("v.preCaseId", "SRM-");
            component.set("v.simpleRecord.Pre_Case_Id__c", nullVal);
            component.set("v.disNoPreCaseId", false);
            component.set("v.disPreCaseId", true);
        }
        else{
            component.set("v.disNoPreCaseId", false);
            component.set("v.disPreCaseId", false);
        }    
    },





    clickNoPreCaseId: function(component, event, helper){
        var selectedCk = event.getSource().get("v.checked");
        var nullVal;
        component.set("v.simpleRecord.No_Pre_Case_Id__c", selectedCk);
        if(selectedCk){
            component.set("v.disNoPreCaseId", false);
            component.set("v.preCaseId", "SRM-");
            component.set("v.simpleRecord.Pre_Case_Id__c", nullVal)
            component.set("v.disPreCaseId", true);
        }
        else{
                component.set("v.disNoPreCaseId", false);
                component.set("v.disPreCaseId", false);
            
        }
    },




    updateAMUser: function(component, event, helper) {
        var selectedAMUser = component.get("v.amUser_val");
        var nullId = component.get("v.nullId");
        
        if(selectedAMUser == "none"){
            component.set('v.simpleRecord.AM_Present__c', nullId);
        }
        else{
            component.set('v.simpleRecord.AM_Present__c', selectedAMUser);
        }
        helper.setNoSRM(component);
  
    },





    updateTDSUser: function(component, event, helper) {
        
        var selectedTDSUser = component.get("v.tdsUser_val");
        var nullId = component.get("v.nullId");
        
        if(selectedTDSUser == "none"){
            component.set('v.simpleRecord.TDS_Present__c', nullId); 
        }
        else{
            component.set('v.simpleRecord.TDS_Present__c', selectedTDSUser);
            var tdsId = component.get("v.simpleRecord.TDS_Present__c");
        }
        
        var x = component.get('v.simpleRecord.TDS_Present__c');
        alert("For DX purposes TDS User Selected = [" + x + "]");
        
		helper.getTDSUsers2(component);
        helper.setNoSRM(component);
        
    },
    
    
    
    
    
    updateTDSUser2: function(component, event, helper) {
        var selectedTDS2User = component.get("v.tds2User_val");
        var nullId = component.get("v.nullId");
        
        if(selectedTDS2User == "none"){
            component.set('v.simpleRecord.Secondary_TDS_Present__c', nullId); 
        }
        else{
            component.set('v.simpleRecord.Secondary_TDS_Present__c', selectedTDS2User);
        }
        
    },
    
    
    
    updateADUser: function(component, event, helper) {
        var selectedADUser = component.get("v.adUser_val");
        var nullId = component.get("v.nullId");
        
        if(selectedADUser == "none"){
            component.set('v.simpleRecord.AD_Present__c', nullId); 
        }
        else{
            component.set('v.simpleRecord.AD_Present__c', selectedADUser);
        } 
        helper.setNoSRM(component);
    },
    
    
    
    
    updateQualUser: function(component, event, helper) {
        var selectedQualUser = component.get("v.qualUser_val");
        var nullId = component.get("v.nullId");
        
        if(selectedQualUser == "none"){
            component.set('v.simpleRecord.Other_Qualified_SRM_Present__c', nullId); 
        }
        else{
            component.set('v.simpleRecord.Other_Qualified_SRM_Present__c', selectedQualUser);
        } 
        helper.setNoSRM(component);
    },    
    
    
    
    
    
    updateSrmProctor: function(component, event, helper){
        var selectedSRMProctor = component.get("v.selectedSRMProctor");
        var nullId = component.get("v.nullId");
        
        if(selectedSRMProctor == 'none'){
            component.set("v.simpleRecord.SRM_Proctor__c", nullId);
        }
        else{
        	component.set('v.simpleRecord.SRM_Proctor__c', selectedSRMProctor);
        }
           
    },
    
    
    
    

    updatePrimaryPhysicianOperator: function(component, event, helper){
        var selectedPhysicianPrimaryOperator = component.get("v.selectedPrimaryPhysicianOperator");
        component.set("v.simpleRecord.Physician_Primary_Operator__c", selectedPhysicianPrimaryOperator);
    },    
    
    
    
    
    
    updateStenter: function(component, event, helper){
        var selectedStenter = component.get("v.selectedStenter");
        var nullId = component.get("v.nullId");
        
        if(selectedStenter == 'none'){
            component.set("v.simpleRecord.Stenter__c", nullId);
        }
        else{
        	component.set('v.simpleRecord.Stenter__c', selectedStenter);
        }
    },
    
    
    
    
    
    
    updateCutdown: function(component, event, helper){
        var selectedCutdown = component.get("v.selectedCutdown");
        var nullId = component.get("v.nullId");
        
        if(selectedCutdown == 'none'){
            component.set("v.simpleRecord.Cutdown_Physician__c", nullId);
        }
        else{	
        	component.set('v.simpleRecord.Cutdown_Physician__c', selectedCutdown);
        }
    },
    
    
    
    
    //********************************************************************************************************************************************************************************************************************/
    //********************************************************************************************************************************************************************************************************************/
    //**********            S A V E    W I T H      N O     S C H E D U L E                                                                                                                                     **********
    //********************************************************************************************************************************************************************************************************************/
    //********************************************************************************************************************************************************************************************************************/      
	 handleSaveRecord: function(component, event, helper) {
        var delEvent = component.get("v.delEvent");
        var proceedWithSave = true;
        
        alert("HANDLE SAVE RECORD STARTED");

// I S S U E     W A R N I N G     I F     E V E N T     W I L L    B E    D E L E T E D     A N D     G E T     U S E R     C O N F I R M A T I O N
        if(delEvent == true){
            var confirmYes = confirm("WARNING: If you continue to save this Procedure Form with a Status of \"Procedure Turned Down\" or \"Cancelled/Rescheduled,\" Any associated event will be cancelled. \n  Click OK to continue with \"Save.\" Otherwise click \"Cancel.\"");
            if(confirmYes){
                proceedWithSave = true;
            }
            else{
                proceedWithSave = false;
            }
        }

        if(proceedWithSave){

            if(delEvent){
                helper.cancelEvent(component);
                component.set("v.simpleRecord.EventIds__c", "");
            }

            var eventIdsVarify = component.get("v.simpleRecord.EventIds__c");

            var prevUrl = window.location.href;
            var acctId = component.get("v.simpleRecord.Account__c");
            var res = prevUrl.split("/",6);
            var res1 = "https://" + res[2] + "/one/one.app#/sObject/" + acctId + "/view";

            
            //********************************************************************************
            //********************************************************************************
            //**  F O R M    V A L I D A T I O N 
            //********************************************************************************
            ////********************************************************************************        
            // COLLECT PARAMETERS TO VALIDATE FORM
            var profileName = component.get("v.currentUser");
            var applyValidationRules = true;
            if(profileName.Profile.Name == "System Administrator" || profileName.Profile.Name == "Clinical Affairs Team"){
                applyValidationRules = false;
                alert("WARNING:  Your User Profile is " + profileName.Profile.Name + ". Validation Rules Not Applied");
            } 
        
            var procedureType = component.get("v.simpleRecord.Procedure_Type__c");
            var procedureDate = component.get("v.simpleRecord.Procedure_Date__c");
            var procedureStatus = component.get("v.simpleRecord.Procedure_Completion__c");




            if(procedureStatus == 'Scheduled'){
                component.set("v.simpleRecord.Event_Attached__c", true);
                component.set("v.simpleRecord.Event_ActivityDate__c", procedureDate);
                
                var lStartTime = component.get("v.startTime");
                var lEndTime = component.get("v.endTime");
                var lTimeZone = component.get("v.hospitalTimeZone");
                var locInfo =component.get("v.locationInfo");
                var oInfo = component.get("v.OtherInformation}");
    
    
                component.set("v.simpleRecord.Event_Local_End_TIme__c", lEndTime);
                component.set("v.simpleRecord.Event_Local_Start_Time__c", lStartTime);
                component.set("v.simpleRecord.Event_Local_Time_Zone__c", lTimeZone);
                component.set("v.simpleRecord.Event_Location_Info__c", locInfo);
                component.set("v.simpleRecord.Event_Other_Information__c", oInfo);
            }
            else{
                var nullVal;
                component.set("v.simpleRecord.Event_Attached__c", false);
                component.set("v.simpleRecord.Event_ActivityDate__c", nullVal);
                
                var lStartTime = component.set("v.startTime");
                var lEndTime = component.set("v.endTime");
                var lTimeZone = component.set("v.hospitalTimeZone");
                var locInfo =component.set("v.locationInfo");
                var oInfo = component.set("v.OtherInformation}");
    
                component.set("v.simpleRecord.Event_Local_End_TIme__c", lEndTime);
                component.set("v.simpleRecord.Event_Local_Start_Time__c", lStartTime);
                component.set("v.simpleRecord.Event_Local_Time_Zone__c", lTimeZone);
                component.set("v.simpleRecord.nEvent_Location_Info__c", locInfo);
                component.set("v.simpleRecord.Event_Other_Information__c", oInfo);
    
            }





            var reasonForAbort = component.get("v.simpleRecord.Reason_Aborted__c");

            var reasonForProcedureTurnDown = component.get("v.simpleRecord.Reason_for_Turning_Procedure_Down__c");
            
            var noSrmPersonnelPresent = component.get("v.simpleRecord.No_SRM_Personnel_Present__c");
            var amPresent = component.get("v.simpleRecord.AM_Present__c");
            
            var tdsPresent = component.get("v.simpleRecord.TDS_Present__c");
            var otherQualSrmPresent = component.get("v.simpleRecord.Other_Qualified_SRM_Present__c");
            var adPresent = component.get("v.simpleRecord.AD_Present__c");
        
            var primaryPhysicianOperator = component.get("v.simpleRecord.Physician_Primary_Operator__c");
            var stenter = component.get("v.simpleRecord.Stenter__c");
            var cutdown = component.get("v.simpleRecord.Cutdown_Physician__c");
            
            var patientId = component.get("v.simpleRecord.Patient_Id__c");
            var patientAge = component.get("v.simpleRecord.Patient_Age__c");
            var patientGender = component.get("v.simpleRecord.Patient_Gender__c");
            var symptomatic = component.get("v.simpleRecord.Symptomatic__c");
            var targetVessel = component.get("v.simpleRecord.Target_Vessel__c");
            
            var cSurg = component.get("v.simpleRecord.HRC_CLN_SURG__c");
            var cStress = component.get("v.simpleRecord.HRC_CLN_STRESS__c");
            var cRena = component.get("v.simpleRecord.HRC_CLN_RENA__c");
            var cMi = component.get("v.simpleRecord.HRC_CLN_MI__c");
            var cLvef = component.get("v.simpleRecord.HRC_CLN_LVEF__c");
            var cHeart = component.get("v.simpleRecord.HRC_CLN_HEART__c");
            var cDiab = component.get("v.simpleRecord.HRC_CLN_DIAB__c");
            var cCopd = component.get("v.simpleRecord.HRC_CLN_COPD__c");
            var cCni = component.get("v.simpleRecord.HRC_CLN_CNI__c");
            var cChf = component.get("v.simpleRecord.HRC_CLN_CHF__c");
            var cCcs = component.get("v.simpleRecord.HRC_CLN_CCS__c");
            var cAng = component.get("v.simpleRecord.HRC_CLN_ANG__c");
            var cAge = component.get("v.simpleRecord.HRC_CLN_AGE__c");
            var cNone = component.get("v.simpleRecord.HRC_CLIN_NONE__c");
            var aTand = component.get("v.simpleRecord.HRC_ANA_TAND__c");
            var aSpin = component.get("v.simpleRecord.HRC_ANA_SPIN__c");
            var aNone = component.get("v.simpleRecord.HRC_ANA_NONE__c");
            var aLaryn = component.get("v.simpleRecord.HRC_ANA_LARYN__c");
            var aHost = component.get("v.simpleRecord.HRC_ANA_HOST__c");
            var aHigh = component.get("v.simpleRecord.HRC_ANA_HIGH__c");
            var aCont = component.get("v.simpleRecord.HRC_ANA_CONT__c");
            var aCea = component.get("v.simpleRecord.HRC_ANA_CEA__c");
            var aCad = component.get("v.simpleRecord.HRC_ANA_CAD__c");
            var aBila = component.get("v.simpleRecord.HRC_ANA_BILA__c");
            
            var preCasePlanSatisfied = false;

            var noPreCase = component.get("v.simpleRecord.No_Pre_Case_Id__c");

            if(noPreCase){
                preCasePlanSatisfied = true;
            }

            var pcId = component.get("v.simpleRecord.Pre_Case_Id__c");

            var pcIdLength = 0;
            if(pcId != null){
                pcIdLength = pcId.length;
            }

            var prefix = "XYZ-";
            var pcIdError = true;

            if(pcId == "SRM-"){
                pcIdError = false;
            }
            else if(pcIdLength == 0 && noPreCase == true){
                pcIdError = false;
            }
            else if(pcIdLength == 12){
                prefix = pcId.substring(0,4);
                if(prefix == "SRM-"){
                    pcIdError = false;
                    
                    preCasePlanSatisfied = true;
                }
            }
        
            var anesthesia = component.get("v.simpleRecord.Anesthesia__c");
            var convertedToGa = component.get("v.simpleRecord.Converted_to_GA__c");
            var atropine = component.get("v.simpleRecord.Atropene__c");
            var glyco = component.get("v.simpleRecord.Glyccopyrrolate__c");
            var mpkMfg = component.get("v.simpleRecord.MPK_Manufacturer__c");
            var othMpkMfg = component.get("v.simpleRecord.Other_MPK_Manufacturer__c");
            var mpkSize = component.get("v.simpleRecord.MPK_Size__c");
            var mpkDial = component.get("v.simpleRecord.MPK_Dialator__c");

            var artSheathAccess = component.get("v.simpleRecord.Arterial_Sheath_Access__c");
            var npsVersion = component.get("v.simpleRecord.NPS_Version__c");
            var npsLotNo = component.get("v.simpleRecord.NPS_Lot_No__c");
            var npsPlacement = component.get("v.simpleRecord.Enroute__c");
            var artSheathPlaceWire = component.get("v.simpleRecord.Arterial_Sheath_Placement_Wire__c");
            var othArtSheathPlaceWire = component.get("v.simpleRecord.Other_Arterial_Sheath_Placement_Wire__c");
            var intertools = component.get("v.simpleRecord.Use_of_Interventional_Tools__c");
            var wireTech = component.get("v.simpleRecord.Wire_Technique__c");
            var noOfStents = component.get("v.simpleRecord.Number_of_Stents_Used__c");
        
            var st1type = component.get("v.simpleRecord.Stent_No_1_Type__c");
            var st1OType = component.get("v.simpleRecord.Other_Stent_1_Type__c");
            var st1size = component.get("v.simpleRecord.Stent_1_Size__c");
            var st1LotNo = component.get("v.simpleRecord.Stint_1_Lot_Number__c");
        
            var st2type = component.get("v.simpleRecord.Stent_No_2_Type__c");
            var st2OType = component.get("v.simpleRecord.Other_Stent_2_Type__c");
            var st2size = component.get("v.simpleRecord.Stint_2_Size__c");
            var st2LotNo = component.get("v.simpleRecord.Stint_2_Lot_Number__c");
            
            var guideWireMfg = component.get("v.simpleRecord.Guidewire_Manufacturer__c");
            
            var otherGuideWireMfg = component.get("v.simpleRecord.Other_Guidewire_Manufacturer__c");
            var enrouteStentDeploy = component.get("v.simpleRecord.ENROUTE_Stint_Deployment__c");
            var enrouteStentRemove = component.get("v.simpleRecord.ENROUTE_Delivery_System_Removal__c");
            var preDilSize = component.get("v.simpleRecord.Pre_Dilation_Balloon_Size__c");
            var otherPreDilSize = component.get("v.simpleRecord.Other_Pre_Dil_Balloon_Size__c");
            
            var postDilSize = component.get("v.simpleRecord.Post_Dialation_Balloon_Size__c");
            var otherPostDilSize = component.get("v.simpleRecord.Other_Post_Dil_Balloon_Size__c");
            var skinToSkinTime = component.get("v.simpleRecord.Skin_to_Skin_Time__c");
            var revFlowTime = component.get("v.simpleRecord.Reverse_Flow_Time__c");
            var tolOfRevFlow = component.get("v.simpleRecord.Toleration_of_Reverse_Flow__c");
            var localCompl = component.get("v.simpleRecord.Local_Complications__c");
            var otherLocalCompl = component.get("v.simpleRecord.Other_Local_Complications__c");
            var dissStep = component.get("v.simpleRecord.Dissection_Step__c");
            var dissType = component.get("v.simpleRecord.Dissection_Type__c");
            var debris = component.get("v.simpleRecord.Debris_in_Filter__c");
            var comment = component.get("v.simpleRecord.Comments__c");

            var isError1 = false;
            
 
// A B O R T E D             
            if(procedureStatus == "Aborted"  && profileName.Profile.Name != "System Administrator" && profileName.Profile.Name != "Clinical Affairs Team"){
                var i = 0;
                var validationErrorMessage = ("This Procedure could not be saved for the following reasons: \n\n");
                applyValidationRules = false;
                if(reasonForAbort == null || reasonForAbort ==""){
                    isError1 = true;
                    i++;
                    validationErrorMessage = (validationErrorMessage + i + ". Reason for Abort / Conversion / Cancellation / Reschedule must be specified \n");
                }
                if((pcId == null || pcId =='' || pcId == 'SRM-' || pcIdLength != 12) && noPreCase != true){
                    i++;
                    validationErrorMessage = (validationErrorMessage + i + ". Either a valid Pre-Case Plan Id must be entered or No Pre-Case Plan Id box checked. \n Pre-Case Plan Id Must be in the form of SRM-######## (SRM- followed by 8 numbers) \n");
                    isError1 = true;
                }
                if(primaryPhysicianOperator == null || primaryPhysicianOperator == ""){
                    isError1 = true;
                    i++;
                    validationErrorMessage = (validationErrorMessage + i + ". A Primary Physician Operator must be selected. \n");
                }    
                if(cutdown == null || cutdown == ""){
                    isError1 = true;
                    i++;
                    validationErrorMessage = (validationErrorMessage + i + ". A cutdown physician must be selected. \n");
                }
                if(stenter == null || stenter == ""){
                    isError1 = true;
                    i++;
                    validationErrorMessage = (validationErrorMessage + i + ". A stenter physician must be selected. \n");
                }
                if(npsPlacement == null || npsPlacement == ""){
                    validationErrorMessage = (validationErrorMessage + i + ". NPS Placement is Required. \n");
                    isError = true;
                    i++;
                }
                
                if(isError1){
                    alert(validationErrorMessage);
                }   
            }

// C A N C E L E D     R E S C H E D U L E D             
            if(procedureStatus == "Cancelled/Rescheduled" && profileName.Profile.Name != "System Administrator" && profileName.Profile.Name != "Clinical Affairs Team"){
                var i = 0;
                
                preCasePlanSatisfied = true;
                applyValidationRules = false;
                var validationErrorMessage = ("This Procedure could not be saved for the following reasons: \n\n");
                if(reasonForAbort == null || reasonForAbort ==""){
                    isError1 = true;
                    i++;
                    validationErrorMessage = (validationErrorMessage + i + ". Reason for Abort / Conversion / Cancellation / Reschedule must be specified \n");
                }
                if(procedureType == null || procedureType == ""){
                    isError1 = true;
                    i++;
                    validationErrorMessage = (validationErrorMessage + i + ". Procedure Type must be specified \n");
                }
                if((pcId == null || pcId =='' || pcId == 'SRM-' || pcIdLength != 12) && noPreCase != true){
                    i++;
                    validationErrorMessage = (validationErrorMessage + i + ". Either a valid Pre-Case Plan Id must be entered or No Pre-Case Plan Id box checked. \n Pre-Case Plan Id Must be in the form of SRM-######## (SRM- followed by 8 numbers) \n");
                    isError1 = true;
                }
                if(primaryPhysicianOperator == null || primaryPhysicianOperator == ""){
                    isError1 = true
                    i++;
                    validationErrorMessage = (validationErrorMessage + i + ". A Primary Physician Operator must be selected. \n");
                }
                if(isError1){
                    alert(validationErrorMessage);
                }
            }


// P R O C E D U R E     T U R N E D    D O W N            
            if(procedureStatus == "Procedure Turned Down" && profileName.Profile.Name != "System Administrator" && profileName.Profile.Name != "Clinical Affairs Team"){
                var i = 0;
                preCasePlanSatisfied = true;
                applyValidationRules = false;
                var validationErrorMessage = ("This Procedure could not be saved for the following reasons: \n\n");
                if(procedureType == null || procedureType == ""){
                    isError1 = true;
                    i++;
                    validationErrorMessage = (validationErrorMessage + i + ". Procedure Type must be specified \n");
                }
                if(reasonForProcedureTurnDown == null || reasonForProcedureTurnDown == ""){
                    isError1 = true;
                    i++;
                    validationErrorMessage = (validationErrorMessage + i + ". Reason for Procedure Turn Down Must be Specified.\n");
                }
                if(primaryPhysicianOperator == null || primaryPhysicianOperator == ""){
                    isError1 = true
                    i++;
                    validationErrorMessage = (validationErrorMessage + i + ". A Primary Physician Operator must be selected. \n");
                }
                if(reasonForProcedureTurnDown == "Other" && (comment == null || comment == "")){
                    isError1 = true
                    i++;
                    validationErrorMessage = (validationErrorMessage + i + ". A Comment is required if Procedure Turned Down and Reason is \'Other\'. \n");
                }
                if((pcId == null || pcId =='' || pcId == 'SRM-' || pcIdLength != 12) && noPreCase != true){
                    i++;
                    validationErrorMessage = (validationErrorMessage + i + ". Either a valid Pre-Case Plan Id must be entered or No Pre-Case Plan Id box checked. \n  Pre-Case Plan Id Must be in the form of SRM-######## (SRM- followed by 8 numbers) \n");
                    isError1 = true;
                }
                if(isError1){
                    alert(validationErrorMessage);
                }
            }


// A L L    O T H E R     C A S E S             
            if(applyValidationRules == true){
                
                var isError = false;
        
                // VALIDATION ERROR ENUMERATOR
                var i = 1;
                
                // VALIDATION AND CONSTRUCTION OF VALIDATION ERROR MESSAGE
                var validationErrorMessage = ("This Procedure could not be saved for the following reasons: \n\n");
                if(procedureType == null || procedureType == ""){
                    validationErrorMessage = (validationErrorMessage + i + ". Procedure Type must be specified \n");
                    isError = true;
                    i++;
                }
                if(procedureDate == null || procedureDate == ""){
                    validationErrorMessage = (validationErrorMessage + i + ". Procedure Date must be specified \n");
                    isError = true;
                    i++;
                }
                if(procedureStatus == null || procedureStatus == ""){
                    validationErrorMessage = (validationErrorMessage + i + ". Procedure Status must be specified \n");
                    isError = true;
                    i++;
                }
                if((procedureStatus == "Converted to CEA" || procedureStatus == "Converted to TF-CAS" || procedureStatus == "Aborted" ) && (reasonForAbort == null || reasonForAbort == "")){
                    validationErrorMessage = (validationErrorMessage + i + ". Reason for Abort / Conversion / Cancellation / Reschedule must be specified \n");
                    isError = true;
                    i++;
                }
                if(!preCasePlanSatisfied){
                    validationErrorMessage = (validationErrorMessage + i + ". Either a valid Pre-Case Plan Id must be entered or No Pre-Case Plan Id box checked \n");
                    isError = true;
                    i++;
                }
                if(pcIdError){
                    validationErrorMessage = (validationErrorMessage + i + ". Pre-Case Plan Id Must be in the form of SRM-######## (SRM- followed by 8 numbers) \n");
                    isError = true;
                    i++;
                }

                if(procedureStatus != null && procedureStatus != "" && procedureStatus != "Scheduled" && procedureStatus != "Cancelled/Rescheduled" && noSrmPersonnelPresent == true){
                    if(primaryPhysicianOperator == null || primaryPhysicianOperator == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". A Primary Physician Operator must be selected. \n");
                        isError = true;
                        i++;
                    }
                    
                    if(cutdown == null || cutdown == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". A cutdown physician must be selected. \n");
                        isError = true;
                        i++;
                    }
                    if(stenter == null || stenter == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". A stenter physician must be selected. \n");
                        isError = true;
                        i++;
                    }
                    
                    if(npsPlacement == null || npsPlacement == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". NPS Placement is Required. \n");
                        isError = true;
                        i++;
                    }
                    if(npsPlacement == "NPS NOT placed and procedure aborted" && procedureStatus == "Completed"){
                        validationErrorMessage = (validationErrorMessage + i + ". Procedure cannot be complete if NPS NOT placed. \n");
                        isError = true;
                        i++;
                    }
                    if(comment == null || comment == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". Comments are Required. \n");
                        isError = true;
                        i++;
                    }
    
                }

                if(procedureStatus != null && procedureStatus != "" && procedureStatus != "Scheduled" && procedureStatus != "Cancelled/Rescheduled"  && noSrmPersonnelPresent != true){
                    if(noSrmPersonnelPresent != true && (amPresent == null || amPresent == "") && (tdsPresent == null || tdsPresent == "") && (otherQualSrmPresent == null || otherQualSrmPresent == "") && (adPresent == null || adPresent == "")){
                            
                        validationErrorMessage = (validationErrorMessage + i + ". At least one option in SRM Personnel Present at Procedure must be selected. \n");
                        isError = true;
                        i++;
                    }
                    if(primaryPhysicianOperator == null || primaryPhysicianOperator == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". A Primary Physician Operator must be selected. \n");
                        isError = true;
                        i++;
                    }                
                    if(stenter == null || stenter == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". A stenter physician must be selected. \n");
                        isError = true;
                        i++;
                    }
                    if(cutdown == null || cutdown == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". A cutdown physician must be selected. \n");
                        isError = true;
                        i++;
                    }
                    
                    if((patientId == null || patientId == null) && (procedureType == "ROADSTER 2" || procedureType == "ROADSTER 2 DW-MRI")){
                        validationErrorMessage = (validationErrorMessage + i + ". When ROADSTER 2 Patient Id is Required. \n");
                        isError = true;
                        i++;
                    }
                    if(patientAge == null || patientAge == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". Patient Age is Required. \n");
                        isError = true;
                        i++;
                    }
                    if(patientGender == null || patientGender == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". Patient Gender is Required. \n");
                        isError = true;
                        i++;
                    }
                    if(symptomatic == null || symptomatic == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". Symptomatic Status is Required. \n");
                        isError = true;
                        i++;
                    }
                    if(targetVessel == null || targetVessel == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". Target Vessel is Required. \n");
                        isError = true;
                        i++;
                    }
                    
                    if(cSurg != true && cStress != true && cRena != true && cMi != true && cLvef != true && cHeart != true && cDiab != true && cCopd != true && 	cCni != true &&
                        cChf != true && cCcs != true && cAng != true && cAge != true && cNone != true && aTand != true && aSpin != true && aNone != true && aLaryn != true && aHost != true &&
                    aHigh != true && aCont != true && aCea != true && aCad != true && aBila != true){
                        
                        validationErrorMessage = (validationErrorMessage + i + ". At least one checkbox must be selected in the High Risk Factors section. \n");
                        isError = true;
                        i++;
                    }
                    if(anesthesia == null || anesthesia == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". Anathesia Used is Required. \n");
                        isError = true;
                        i++;
                    }
                    if(convertedToGa == null || convertedToGa == "" ){
                        validationErrorMessage = (validationErrorMessage + i + ". Converted to GA is Required. \n");
                        isError = true;
                        i++; 
                    }
                    if(atropine == null || atropine == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". Atropine is Required. \n");
                        isError = true;
                        i++; 
                    }
                    if(glyco == null || glyco == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". Glycopyrrolate is Required. \n");
                        isError = true;
                        i++;
                    }
                    if(mpkMfg == null || mpkMfg == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". MPK Manufacturer is Required. \n");
                        isError = true;
                        i++;
                    }
                    if(mpkMfg == "Other" && (othMpkMfg == null || othMpkMfg == "")){
                        validationErrorMessage = (validationErrorMessage + i + ". Other MPK Manufacturer is Required. \n");
                        isError = true;
                        i++;
                    }

                    if(artSheathAccess == null || artSheathAccess == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". Arterial Sheath Access is Required. \n");
                        isError = true;
                        i++;
                    }
                    if(npsLotNo == null || npsLotNo == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". NPS Lot Number is Required. \n");
                        isError = true;
                        i++;
                    }
                    if(npsPlacement == null || npsPlacement == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". NPS Placement is Required. \n");
                        isError = true;
                        i++;
                    }
                    if(artSheathPlaceWire == null || artSheathPlaceWire == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". Arterial Sheath Placement Wire is Required. \n");
                        isError = true;
                        i++;
                    }
                    if(artSheathPlaceWire == "Other" && (othArtSheathPlaceWire == null || othArtSheathPlaceWire == "")){
                        validationErrorMessage = (validationErrorMessage + i + ". Other Arterial Sheath Placement Wire is Required. \n");
                        isError = true;
                        i++;
                    }
                    if(intertools == null || intertools == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". Use of Interventional Tools is Required. \n");
                        isError = true;
                        i++;
                    }
                    if(wireTech == null || wireTech == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". Wire Technique is Required. \n");
                        isError = true;
                        i++;
                    }
        
                    if(noOfStents == null || noOfStents == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". Number of Stents is Required. \n");
                        isError = true;
                        i++;
                    }
                    else if(noOfStents == "1"){	 
                        if(st1type == null || st1type == "" || st1type == "- DISABLED -"){
                            validationErrorMessage = (validationErrorMessage + i + ". Stent 1 Type is Required. \n");
                            isError = true;
                            i++; 
                        }
                    if(st1type == "Other" && (st1OType == null || st1OType == "")){
                            validationErrorMessage = (validationErrorMessage + i + ". Stent 1 Other Type is Required. \n");
                            isError = true;
                            i++; 
                        }
                        if(st1size == null || st1size == "" ||st1size == "- DISABLED -"){
                            validationErrorMessage = (validationErrorMessage + i + ". Stent 1 Size is Required. \n");
                            isError = true;
                            i++; 
                        }
                        if(st1LotNo == null || st1LotNo == ""){
                            validationErrorMessage = (validationErrorMessage + i + ". Stent 1 Lot Number is Required. \n");
                            isError = true;
                            i++; 
                        } 
                        
                    } // END NO OF STENTS == 1
                
                    else if(noOfStents == "2"){	
                        if(st1type == null || st1type == "" || st1type == "- DISABLED -"){
                            validationErrorMessage = (validationErrorMessage + i + ". Stent 1 Type is Required. \n");
                            isError = true;
                            i++; 
                        }
                    if(st1type == "Other" && (st1OType == null || st1OType == "")){
                            validationErrorMessage = (validationErrorMessage + i + ". Stent 1 Other Type is Required. \n");
                            isError = true;
                            i++; 
                        }
                        if(st1size == null || st1size == "" ||st1size == "- DISABLED -"){
                            validationErrorMessage = (validationErrorMessage + i + ". Stent 1 Size is Required. \n");
                            isError = true;
                            i++; 
                        }
                        if(st1LotNo == null || st1LotNo == ""){
                            validationErrorMessage = (validationErrorMessage + i + ". Stent 1 Lot Number is Required. \n");
                            isError = true;
                            i++; 
                        } 
                        
                        if(st2type == null || st2type == "" || st2type == "- DISABLED -"){
                            validationErrorMessage = (validationErrorMessage + i + ". Stent 2 Type is Required. \n");
                            isError = true;
                            i++; 
                        }
                    if(st2type == "Other" && (st2OType == null || st2OType == "")){
                            validationErrorMessage = (validationErrorMessage + i + ". Stent 2 Other Type is Required. \n");
                            isError = true;
                            i++; 
                        }
                        if(st2size == null || st2size == "" ||st2size == "- DISABLED -"){
                            validationErrorMessage = (validationErrorMessage + i + ". Stent 2 Size is Required. \n");
                            isError = true;
                            i++; 
                        }
                        if(st2LotNo == null || st2LotNo == ""){
                            validationErrorMessage = (validationErrorMessage + i + ". Stent 2 Lot Number is Required. \n");
                            isError = true;
                            i++; 
                        } 
                        
                    } // END NO OF STENTS == 2
                    
                    if(guideWireMfg == null || guideWireMfg == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". Guide Wire Manufacturer is Required. \n");
                        isError = true;
                        i++; 
                    }
                    if(guideWireMfg == "Other" && (otherGuideWireMfg == null || otherGuideWireMfg == "")){
                        validationErrorMessage = (validationErrorMessage + i + ". Other Guide Wire Manufacturer is Required. \n");
                        isError = true;
                        i++; 
                    }
                    if((enrouteStentDeploy == null || enrouteStentDeploy == "") && noOfStents != "None"){
                        validationErrorMessage = (validationErrorMessage + i + ". ENROUTE Stent Deployment is Required. \n");
                        isError = true;
                        i++;        
                    }
                    if((enrouteStentRemove == null || enrouteStentRemove == "") && noOfStents != "None"){
                        validationErrorMessage = (validationErrorMessage + i + ". ENROUTE Stent Removal is Required. \n");
                        isError = true;
                        i++;        
                    }
                    if(preDilSize == null || preDilSize == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". Pre Dilation Size is Required. \n");
                        isError = true;
                        i++;        
                    }
                    if(preDilSize == "Other Size" && (otherPreDilSize == null || otherPreDilSize == "")){
                        validationErrorMessage = (validationErrorMessage + i + ". Other Pre Dilation Size is Required. \n");
                        isError = true;
                        i++;        
                    }
                    if(postDilSize == null || postDilSize == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". Post Dilation Size is Required. \n");
                        isError = true;
                        i++;        
                    }
                    if(postDilSize == "Other Size" && (otherPostDilSize == null || otherPostDilSize == "")){
                        validationErrorMessage = (validationErrorMessage + i + ". Other Post Dilation Size is Required. \n");
                        isError = true;
                        i++;        
                    }
                    if(skinToSkinTime == null || skinToSkinTime == "" || skinToSkinTime == 0){
                        validationErrorMessage = (validationErrorMessage + i + ". Skin to Skin Time is Required.  Please check your time entry. \n");
                        isError = true;
                        i++;        
                    }
                    if(revFlowTime == null || revFlowTime == "" || revFlowTime == 0){
                        validationErrorMessage = (validationErrorMessage + i + ". Reverse Flow Time is Required.  Please check your time entry. \n");
                        isError = true;
                        i++;        
                    }
                    if(tolOfRevFlow == null || tolOfRevFlow == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". Toleration of Reverse Flow is Required. \n");
                        isError = true;
                        i++;        
                    }
                    if(localCompl == null || localCompl == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". Local Complications is Required. \n");
                        isError = true;
                        i++; 
                    }
                    if(localCompl == "Other" && (otherLocalCompl == null || otherLocalCompl == "")){
                        validationErrorMessage = (validationErrorMessage + i + ". Other Local Complications is Required. \n");
                        isError = true;
                        i++; 
                    }
                    if((dissStep == null || dissStep == "") && localCompl != null && localCompl != "" && localCompl != "None"){
                        validationErrorMessage = (validationErrorMessage + i + ". Dissection Step is Required. \n");
                        isError = true;
                        i++; 
                    }
                    if((dissType == null || dissType == "") && localCompl != null && localCompl != "" && localCompl != "None"){
                        validationErrorMessage = (validationErrorMessage + i + ". Dissection Type is Required. \n");
                        isError = true;
                        i++; 
                    }
                    if(debris == null || debris == ""){
                        validationErrorMessage = (validationErrorMessage + i + ". Debris in filter is Required. \n");
                        isError = true;
                        i++; 
                    }
        
                    
                }// END OF PROCEDURE STATUS IF
                
                // IF VALIDATION FAILS ALERT USER AND DO NOT SAVE FORM
                if(isError){
                    alert(validationErrorMessage);
                }
                //********************************************************************************
                //********************************************************************************
                //**  F O R M    S A V E
                //********************************************************************************
                //********************************************************************************
                // IF VALIDATION PASSED, SAVE THE FORM AND ALERT USER
                else{
                    
                    component.find("recordLoader").saveRecord($A.getCallback(function(saveResult) {
                        // NOTE: If you want a specific behavior(an action or UI behavior) when this action is successful
                        // then handle that in a callback (generic logic when record is changed should be handled in recordUpdated event handler)

                        var status = saveResult.state;
                        //alert("Save Status = [" + status + "]");

                        if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {

                            alert("Procedure Form Save State - SAVE PF ONLY = [" + saveResult.state + "]");
                            
                            alert("Procedure Form Successfully Updated.");   
                            
                        } else if (saveResult.state === "INCOMPLETE") {
                            alert('Procedure NOT Saved!  Please contact your Salesforce Administrator - EDIT PAGE - INCOMPLETE');
                            console.log("User is offline, device doesn't support drafts.");
                        } else if (saveResult.state === "ERROR") {
                            var errors = saveResult.getError;
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "type":"error",
                                "title": "Error!",
                                "message": errors
                            });
                            toastEvent.fire();

                            console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                            alert('Procedure NOT Saved!  Please contact your Salesforce Administrator - EDIT PAGE - ERROR');
                        } else {
                            console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                            alert('Procedure NOT Saved!  Please contact your Salesforce Administrator - EDIT PAGE - Unknown');
                        }
                    }));
                
        
                    var acctId = component.get("v.simpleRecord.Account__c");
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                    "recordId": acctId,
                    "slideDevName": "detail"
                    });
                    navEvt.fire();		
                }
            }
            else if(isError1){


            }
            else{
                
                    component.find("recordLoader").saveRecord($A.getCallback(function(saveResult) {
                        // NOTE: If you want a specific behavior(an action or UI behavior) when this action is successful
                        // then handle that in a callback (generic logic when record is changed should be handled in recordUpdated event handler)
                        if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {

                            alert("Procedure Form Save State handleSaveRecord = [" + saveResult.state + "]");
                            
                            alert("Procedure Form Successfully Updated.");   
                            
                        } else if (saveResult.state === "INCOMPLETE") {
                            alert('Procedure NOT Saved!  Refer to Debug Logs - INCOMPLETE');
                            console.log("User is offline, device doesn't support drafts.");
                        } else if (saveResult.state === "ERROR") {
                            console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                            alert('Procedure NOT Saved!  Refer to Debug Logs - ERROR');
                        } else {
                            console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                            alert('Procedure NOT Saved!  Refer to Debug Logs - Unknown');
                        }
                    }));
                
        
                    var acctId = component.get("v.simpleRecord.Account__c");
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                    "recordId": acctId,
                    "slideDevName": "detail"
                    });
                    navEvt.fire();
            }
        }
			         
    },










    //********************************************************************************************************************************************************************************************************************/
    //********************************************************************************************************************************************************************************************************************/
    //**********            S A V E    W I T H      C R E A T E     S C H E D U L E                                                                                                                                             **********
    //********************************************************************************************************************************************************************************************************************/
    //********************************************************************************************************************************************************************************************************************/  
    onCreateSchedule: function(component, event, helper){

        //alert("ON CREATE SCHEDULE STARTED");

        // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
        // * * * * * * * * * * CONDUCT VALIDATION ON ENTRIES * * * * * * * * * * * * * *
        // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
                //* * * COLLECT REQUIRED COMPONENTS IF SAVED WITH SCHEDULE ONLY
        var procedureForm = component.get("v.simpleRecord");
        var nowDate = component.get("v.nowDate");
        var procedureType = component.get("v.simpleRecord.Procedure_Type__c");
		var procedureDate = component.get("v.simpleRecord.Procedure_Date__c");
        var primaryOpPhysicianId = component.get("v.simpleRecord.Physician_Primary_Operator__c");

        var preCaseId = component.get("v.preCaseId");
        var noPreCaseId = component.get("v.simpleRecord.No_Pre_Case_Id__c");
        var preCaseIdLength = 0;
        if(preCaseId != null){
            preCaseIdLength = preCaseId.length;
        }

        component.set("v.simpleRecord.Pre_Case_Id__c", preCaseId);

        var amUser = component.get("v.simpleRecord.AM_Present__c");
        var tdsUser = component.get("v.simpleRecord.TDS_Present__c");
        var qualUser = component.get("v.simpleRecord.Other_Qualified_SRM_Present__c");
        var adUser = component.get("v.simpleRecord.AD_Present__c");
        var noSrm = component.get("v.simpleRecord.No_SRM_Personnel_Present__c"); 

        var isError = false;
        
        // VALIDATION ERROR ENUMERATOR
        var i = 1;

// G E N E R A L     E D I T    C H E C K S         
        var validationErrorMessage = ("This Procedure could not be saved for the following reasons: \n\n");
        if(procedureType == null || procedureType == ""){
            validationErrorMessage = (validationErrorMessage + i + ". Procedure Type must be specified \n");
            isError = true;
            i++;
        }
        if(procedureDate <  nowDate){
            validationErrorMessage = (validationErrorMessage + i + ". Procedure schedule date cannot be in the past \n");
            isError = true;
            i++;
        }
        if((preCaseId == null || preCaseId =='' || preCaseId == 'SRM-' || preCaseIdLength != 12) && noPreCaseId != true){
            validationErrorMessage = (validationErrorMessage + i + ". Either a valid Pre-Case Plan Id must be entered or No Pre-Case Plan Id box checked. \n  Pre-Case Plan Id Must be in the form of SRM-######## (SRM- followed by 8 numbers) \n");
            isError = true;
            i++;
        }
        if((amUser == null || amUser == '' || amUser == 'none') && (tdsUser == null || tdsUser == '' || tdsUser == 'none') && (adUser == null || adUser == '' || adUser == 'none') && (qualUser == null || qualUser == '' || qualUser == 'none') && noSrm != true ){
            validationErrorMessage = (validationErrorMessage + i + ". At least one option in SRM Personnel Present at Procedure must be selected or No SRM Present must be checked. \n");
            isError = true;
            i++;
        }
        if(primaryOpPhysicianId == null || primaryOpPhysicianId == ""){
            validationErrorMessage = (validationErrorMessage + i + ". A Primary Physician Operator must be specified add schedule \n");
            isError = true;
            i++;
        }
        // IF VALIDATION FAILS ALERT USER AND DO NOT SAVE FORM
        if(isError){
            alert(validationErrorMessage);
        }
        
        
        if(!isError){
            // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
            // * * * * * * * * * * UPDATE EXISTING PROCEDURE FORM RECORD   * * * * * * * * * * * *
            // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
            /*
            component.find("recordLoader").saveRecord($A.getCallback(function(saveResult) {
                // NOTE: If you want a specific behavior(an action or UI behavior) when this action is successful
                // then handle that in a callback (generic logic when record is changed should be handled in recordUpdated event handler)
                if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {

                    alert("Procedure Form Save State = [" + saveResult.state + "]");
                    
                    alert("Procedure Form Successfully Updated.");   
                    
                } else if (saveResult.state === "INCOMPLETE") {
                    alert('Procedure NOT Saved!  Refer to Debug Logs - INCOMPLETE');
                    console.log("User is offline, device doesn't support drafts.");
                } else if (saveResult.state === "ERROR") {
                    console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                    alert('Procedure NOT Saved!  Refer to Debug Logs - ERROR');
                } else {
                    console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                    alert('Procedure NOT Saved!  Refer to Debug Logs - Unknown');
                }
            }));
            */
            //var navEvt = $A.get("e.force:navigateToSObject");
            //navEvt.setParams({
            //"recordId" : accountId,
            //"slideDevName": "detail"
            //});
            //navEvt.fire();
            // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
            // * * * * * * * * * * CREATE NEW EVENT AND GET THE EVENT ID * * * * * * * * * *
            // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
            var accountId = component.get("v.simpleRecord.Account__c");
            var procedureDate = component.get("v.simpleRecord.Procedure_Date__c");
            var timeZoneString = component.get("v.hospitalTimeZone");
            var startTime = component.get("v.startTime");
            var endTime = component.get("v.endTime");

            var localStartTime;
            var localEndTime;
            var localTimeZone;

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
            

           // alert("localStartTime = [" + localStartTime + "] localEndTime = [" + localEndTime + "] localTimeZone = [" + localTimeZone + "]");


           var locInformation = component.get("v.locationInfo");
           var primaryAmId = component.get("v.simpleRecord.AM_Present__c");
           var primaryTdsId = component.get("v.simpleRecord.TDS_Present__c");

           var secondaryTdsId = component.get("v.simpleRecord.Secondary_TDS_Present__c");
           var otherQualifiedSrmId = component.get("v.simpleRecord.Other_Qualified_SRM_Present__c");
           var adId = component.get("v.simpleRecord.AD_Present__c");
           
           var otherInformation = component.get("v.OtherInformation");
           //var simpleRecord = component.get("v.simpleRecord");
           var vendorCredentailCompany = component.get("v.vendorCredentailCompany");
           
           var action = component.get("c.createProcedureAppointment");
           
           var self = this;
           action.setParams({
               procedureForm : procedureForm,
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
               });
           
           action.setCallback(this, function(actionResult) {
               component.set("v.eventId1", actionResult.getReturnValue());
               var state = actionResult.getState();
               alert("Schedule Save State SAVE WITH CREATE PF ONLY= [" + state + "]");

               if(state == 'SUCCESS'){
                    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
                    // * * * * * * * * * * UPDATE EXISTING PROCEDURE FORM RECORD   * * * * * * * * * * * *
                    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

                    alert("Entering Procedure Form Save");
            
                    component.find("recordLoader").saveRecord($A.getCallback(function(saveResult) {
                        // NOTE: If you want a specific behavior(an action or UI behavior) when this action is successful
                        // then handle that in a callback (generic logic when record is changed should be handled in recordUpdated event handler)
                        if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {

                            alert("Procedure Form Save State = [" + saveResult.state + "]");
                            
                            alert("Procedure Form Successfully Updated.");   
                            
                        } else if (saveResult.state === "INCOMPLETE") {
                            alert('Procedure NOT Saved!  Refer to Debug Logs - INCOMPLETE');
                            console.log("User is offline, device doesn't support drafts.");
                        } else if (saveResult.state === "ERROR") {
                            console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                            alert('Procedure NOT Saved!  Refer to Debug Logs - ERROR');
                        } else {
                            console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                            alert('Procedure NOT Saved!  Refer to Debug Logs - Unknown');
                        }
                    }));

               }
               var x = component.get("v.eventId1");
               //alert("EVENT ID = [" + x +"]");
               
               // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
               // * * * *  DETERMINE DOMAIN AND REDIRECT TO USER'S CALENDAR * * * * * * * * * *
               // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
                  var u = window.location.href;
               u = "https://" + u.split("/")[2] + "/lightning/r/Event/" + x + "/view";

                //alert("URL = [" + u + "]");

                window.open(u,'_top');    
           });
   
          $A.enqueueAction(action);
                        
        } // End if isError          
    },
    

    





    //********************************************************************************************************************************************************************************************************************/
    //********************************************************************************************************************************************************************************************************************/
    //**********            S A V E    W I T H      U P D A T E     S C H E D U L E                                                                                                                                             **********
    //********************************************************************************************************************************************************************************************************************/
    //********************************************************************************************************************************************************************************************************************/  
    onUpdateSchedule: function(component, event, helper){

        //alert("On Update Schedule Started");

        // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
        // * * * * * * * * * * CONDUCT VALIDATION ON ENTRIES * * * * * * * * * * * * * *
        // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
                //* * * COLLECT REQUIRED COMPONENTS IF SAVED WITH SCHEDULE ONLY
        var nowDate = component.get("v.nowDate");
        var procedureType = component.get("v.simpleRecord.Procedure_Type__c");
		var procedureDate = component.get("v.simpleRecord.Procedure_Date__c");
        var primaryOpPhysicianId = component.get("v.simpleRecord.Physician_Primary_Operator__c");

        var preCaseId = component.get("v.simpleRecord.Pre_Case_Id__c");
        var noPreCaseId = component.get("v.simpleRecord.No_Pre_Case_Id__c");

        var preCaseIdLength = 0;
        if(preCaseId != null){
            preCaseIdLength = preCaseId.length;
        }

        var amUser = component.get("v.simpleRecord.AM_Present__c");
        var tdsUser = component.get("v.simpleRecord.TDS_Present__c");
        var qualUser = component.get("v.simpleRecord.Other_Qualified_SRM_Present__c");
        var adUser = component.get("v.simpleRecord.AD_Present__c");

        var noSrm = component.get("v.simpleRecord.No_SRM_Personnel_Present__c"); 

        var accountId = component.get("v.simpleRecord.Account__c");

        //alert("amUser = [" + amUser + "] tdsUser = [" + tdsUser + "] adUser = [" + adUser + "] qualUsr = [" + qualUser + "] noSrm = [" + noSrm + "]");
        //alert("noPreCaseId = [" + noPreCaseId + "]");

        // * * * *  SAVE PROCEDURE FORM AND RECORD EVENT ON PROCEDURE FORM * * * * * * *
        
        //helper.setNone(component);
        var isError = false;
        
        // VALIDATION ERROR ENUMERATOR
        var i = 1;

// G E N E R A L     E D I T     C H E C K S
        var validationErrorMessage = ("This Procedure could not be saved for the following reasons: \n\n");
        if(procedureType == null || procedureType == ""){
            validationErrorMessage = (validationErrorMessage + i + ". Procedure Type must be specified \n");
            isError = true;
            i++;
        }
        if(procedureDate <  nowDate){
            validationErrorMessage = (validationErrorMessage + i + ". Procedure schedule date cannot be in the past \n");
            isError = true;
            i++;
        }
        if((preCaseId == null || preCaseId =='' || preCaseId == 'SRM-' || preCaseIdLength != 12) && noPreCaseId != true){
            validationErrorMessage = (validationErrorMessage + i + ". Either a valid Pre-Case Plan Id must be entered or No Pre-Case Plan Id box checked. \n  Pre-Case Plan Id Must be in the form of SRM-######## (SRM- followed by 8 numbers) \n");
            isError = true;
            i++;
        }
        if((amUser == null || amUser == '' || amUser == 'none') && (tdsUser == null || tdsUser == '' || tdsUser == 'none') && (adUser == null || adUser == '' || adUser == 'none') && (qualUser == null || qualUser == '' || qualUser == 'none') && noSrm != true ){
            validationErrorMessage = (validationErrorMessage + i + ". At least one option in SRM Personnel Present at Procedure must be selected or No SRM Present must be checked. \n");
            isError = true;
            i++;
        }
        if(primaryOpPhysicianId == null || primaryOpPhysicianId == ""){
            validationErrorMessage = (validationErrorMessage + i + ". A Primary Physician Operator must be specified add schedule \n");
            isError = true;
            i++;
        }
        // IF VALIDATION FAILS ALERT USER AND DO NOT SAVE FORM
        if(isError){
            alert(validationErrorMessage);
        }
        
        
        if(!isError){
            // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
            // * * * * * * * * * * UPDATE EXISTING PROCEDURE FORM RECORD   * * * * * * * * * * * *
            // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
/*
            component.find("recordLoader").saveRecord($A.getCallback(function(saveResult) {
                // NOTE: If you want a specific behavior(an action or UI behavior) when this action is successful
                // then handle that in a callback (generic logic when record is changed should be handled in recordUpdated event handler)
                if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                    
                    alert("Procedure Form Successfully Updated.");   
                    
                } else if (saveResult.state === "INCOMPLETE") {
                    alert('Procedure NOT Saved!  Refer to Debug Logs - INCOMPLETE');
                    console.log("User is offline, device doesn't support drafts.");
                } else if (saveResult.state === "ERROR") {
                    console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                    alert('Procedure NOT Saved!  Refer to Debug Logs - ERROR');
                } else {
                    console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                    alert('Procedure NOT Saved!  Refer to Debug Logs - Unknown');
                }
            }));

            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
            "recordId" : accountId,
            "slideDevName": "detail"
            });
            navEvt.fire();
*/
            // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
            // * * * * * * * * * * UPDATE EXISTING EVENT AND GET THE EVENT ID  * * * * * * * * * *
            // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
            var procedureDate = component.get("v.simpleRecord.Procedure_Date__c");
            var timeZoneString = component.get("v.hospitalTimeZone");
            var startTime = component.get("v.startTime");
            var endTime = component.get("v.endTime");

            var localStartTime;
            var localEndTime;
            var localTimeZone;

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
            

           // alert("localStartTime = [" + localStartTime + "] localEndTime = [" + localEndTime + "] localTimeZone = [" + localTimeZone + "]");


            var locInformation = component.get("v.locationInfo");
            var primaryAmId = component.get("v.simpleRecord.AM_Present__c");
            var primaryTdsId = component.get("v.simpleRecord.TDS_Present__c");

            var secondaryTdsId = component.get("v.simpleRecord.Secondary_TDS_Present__c");
            var otherQualifiedSrmId = component.get("v.simpleRecord.Other_Qualified_SRM_Present__c");
            var adId = component.get("v.simpleRecord.AD_Present__c");
            
            var otherInformation = component.get("v.OtherInformation");
            //var simpleRecord = component.get("v.simpleRecord");
            var vendorCredentailCompany = component.get("v.vendorCredentailCompany");
            
            var action = component.get("c.updateProcedureAppointment");
            
            var procedureFormRecordId = component.get("v.simpleRecord.Id");
            var eventId = component.get("v.simpleRecord.EventIds__c");

            var eventId;

            var dmlAction = 'UPDATE';
            
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
				component.set("v.eventId1", actionResult.getReturnValue());
                var state = actionResult.getState();

//*******************************************************************************************************************************************************/                
                alert("Schedule Save State UPDATE PF AND UPDATE EVENT = [" + state + "]");
                
                if(state == 'SUCCESS'){

                    alert("Entering Procedure Form Save");

                    component.find("recordLoader").saveRecord($A.getCallback(function(saveResult) {
                        // NOTE: If you want a specific behavior(an action or UI behavior) when this action is successful
                        // then handle that in a callback (generic logic when record is changed should be handled in recordUpdated event handler)
                        alert("Procedure Form Save Result = [" + saveResult.state + "]");

                        if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                            
                            var x = component.get('v.simpleRecord.TDS_Present__c');
                            alert("For DX purposes TDS User Selected = [" + x + "]");

                            alert("Procedure Form Successfully Updated.");   
                            
                        } else if (saveResult.state === "INCOMPLETE") {
                            alert('Procedure NOT Saved!  Refer to Debug Logs - INCOMPLETE');
                            console.log("User is offline, device doesn't support drafts.");
                        } else if (saveResult.state === "ERROR") {
                            console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                            alert('Procedure NOT Saved!  Refer to Debug Logs - ERROR');
                        } else {
                            console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                            alert('Procedure NOT Saved!  Refer to Debug Logs - Unknown');
                        }
                    }));
        
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                    "recordId" : accountId,
                    "slideDevName": "detail"
                    });
                    navEvt.fire();
                }
//*******************************************************************************************************************************************************/
                var x = component.get("v.eventId1");
                //alert("EVENT ID = [" + x +"]");
                
                // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
                // * * * *  DETERMINE DOMAIN AND REDIRECT TO USER'S CALENDAR * * * * * * * * * *
                // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
               	var u = window.location.href;
                u = "https://" + u.split("/")[2] + "/lightning/r/Event/" + x + "/view";
                    //https://silkroadmed--srdevpc1.lightning.force.com/lightning/r/Event/00U2a000001nXoYEAU/view
               	//u = "https://" + u.split("/")[2] + "/lightning/o/Event/home";
               	window.open(u,'_top');    
            });
    
           $A.enqueueAction(action);
                        
        } // End if isError          
    },




    resetEndTime: function(component, event, helper){
        var startTime = component.get("v.startTime");
        var endTime = component.get("v.endTime");
        
        if(endTime <= startTime){
            var stHour = startTime.substring(0,2);
            var stMin = startTime.substring(3,5);
            //alert("startTime = [" + startTime + "]stHour = [" + stHour +"] stMin = [" + stMin + "]");
            var endHour;
            var endMin = stMin;
            
            if(stHour == '00'){endHour = '01';}
            else if(stHour == '01'){endHour = "02"; }
            else if(stHour == '02'){endHour = "03"; }
            else if(stHour == '03'){endHour = "04"; }
            else if(stHour == '04'){endHour = "05"; }
            else if(stHour == '05'){endHour = "06"; }
            else if(stHour == '06'){endHour = "07"; }
            else if(stHour == '07'){endHour = "08"; }
            else if(stHour == '08'){endHour = "09"; }
            else if(stHour == '09'){endHour = "10"; }
            else if(stHour == '10'){endHour = "11"; }
            else if(stHour == '11'){endHour = "12"; }
            else if(stHour == '12'){endHour = "13"; }
            else if(stHour == '13'){endHour = "14"; }
            else if(stHour == '14'){endHour = "15"; }
            else if(stHour == '15'){endHour = "16"; }
            else if(stHour == '16'){endHour = "17"; }
            else if(stHour == '17'){endHour = "18"; }
            else if(stHour == '18'){endHour = "19"; }
            else if(stHour == '19'){endHour = "20"; }
            else if(stHour == '20'){endHour = "21"; }
            else if(stHour == '21'){endHour = "22"; }
            else if(stHour == '22'){endHour = "23"; }
            else if(stHour == '23'){ endHour = "23";
            	if(endMin = "45");
            }
            
            component.set("v.endTime", endHour + ":" + endMin + ":00");

            //var testEndTime = component.get("v.endTime");
            //alert("testEndTime = [" + testEndTime +"]");
        }    
    },





        updateAccount: function(component, event, helper) {
            // Create the new expense
            var selectedAccount = component.get("v.selectedAccount");
            component.set("v.simpleRecord.Account__c", selectedAccount); 
     
        	var procDt = component.get("v.simpleRecord.Procedure_Date__c");
       		var patientid = component.get("v.simpleRecord.Patient_Id__c");

        
	    	var siteName = component.get("v.simpleRecord.Account__c");
        	var action = component.get("c.getSiteName");
        	var retVal;
            action.setParams({
                "acctId": component.get("v.selectedAccount")
            });
     
        	var self = this;
            action.setCallback(this, function(actionResult) {
                retVal = procDt + " : " + actionResult.getReturnValue() + " : " + patientid;
                retVal = retVal.substring(0,79);
                component.set('v.simpleRecord.Name', retVal);
            });
            $A.enqueueAction(action);
    },
    
    
    
    
    onProcType: function(component, event) {
		var selected = component.get("v.simpleRecord.Procedure_Type__c");
        
        var compl = component.find("v.simpleRecord.Procedure_Completion__c");
        
        

        var renderBottom1 = component.get("v.noRenderBottom");
        var renderBottom;
        
        if(renderBottom1 == false){
            renderBottom = true;
        }
        else{
            renderBottom = false;
        }

        if(compl != "Scheduled" && compl != "" && renderBottom == true ){
            
         
            var anaNone = component.find("anaNone").get("v.checked");
            
            var clinLaryn = component.find("anaLaryn");
            var anaSpin = component.find("anaSpin");
            var clinDiab = component.find("clinDiab");
            var clinHeart = component.find("clinHeart");
            var clinSurg = component.find("clinSurg");
            var clinStress = component.find("clinStress");
            
            if(selected == 'ROADSTER 2' && renderBottom == true){
                clinLaryn.set("v.checked", false);
                anaSpin.set("v.checked", false);
                clinDiab.set("v.checked", false);
                clinSurg.set("v.checked", false);
                clinHeart.set("v.checked", false);
                clinStress.set("v.checked", false);
                if(anaNone == false){
                    clinLaryn.set("v.disabled", true);
                    anaSpin.set("v.disabled", true);
                    clinDiab.set("v.disabled", true);
                    clinSurg.set("v.disabled", true);
                    clinHeart.set("v.disabled", true);
                    clinStress.set("v.disabled", true);
                }
            }
            else {
                if(anaNone == false){
                    clinLaryn.set("v.disabled", false);
                    anaSpin.set("v.disabled", false);
                    clinDiab.set("v.disabled", false);
                    clinSurg.set("v.disabled", false);
                    clinHeart.set("v.disabled", false);
                    clinStress.set("v.disabled", false);
                }
            }
        }
        else{
            if(selected == 'ROADSTER 2'&& renderBottom == true){
            	component.get("v.simpleRecord.HRC_ANA_LARYN__c").set("v.value", false);
                component.get("v.simpleRecord.HRC_ANA_SPIN__c").set("v.value", false);
                component.get("v.simpleRecord.HRC_CLN_DIAB__c").set("v.value", false);
                component.get("v.simpleRecord.HRC_CLN_SURG__c").set("v.value", false);
                component.get("v.simpleRecord.HRC_CLN_HEART__c").set("v.value", false);
                component.get("v.simpleRecord.HRC_CLN_STRESS__c").set("v.value", false);
                
            }    
        }
     },
    
    
    
    
    
     onGender: function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.simpleRecord.Patient_Gender__c", selected1);
     },
    
    
    onOthPreDilSize: function(component, event) {
         var otherPreDilSize = component.find("preDilOtherSize").get("v.value");
         component.set("v.simpleRecord.Other_Pre_Dil_Balloon_Size__c", otherPreDilSize);
     },
    
    
    
    onSympt: function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.simpleRecord.Symptomatic__c", selected1);
     },

    
    

     
     onCompl: function(component, event, helper) {
         var selected =  component.find("completion").get("v.value");
         var eventId = component.get("v.simpleRecord.EventIds__c");
         var haveSchedule;
         var nullval = null;
            
         component.set("v.simpleRecord.Status__c", selected);
         component.set("v.simpleRecord.Procedure_Completion__c", selected);

         

        if(eventId != null && eventId != ''){
            haveSchedule = true;
        }
        else{
            haveSchedule = false;
        }

        //alert("event Id = [" + eventId + "] have Schedule = [" + haveSchedule + "]");
         
         
         if(selected == "Scheduled" ){
            
            component.set("v.simpleRecord.Reason_for_Procedure_Turn_Down__c", nullval);
            component.set("v.noRenderBottom", true);
            component.set("v.noRenderScheduler", false);
            component.set("v.hideReasonForTurnDown", true);
            component.set("v.resForAbort_disabled", true);
        
            if(haveSchedule){
                component.set("v.delEvent", false);
                component.set("v.noRenderSimpleSave", true);
                component.set("v.noRenderSchedulerSave", false);
                component.set("v.noRenderAddNewEventSave", true);
            }
            else if(!haveSchedule){
                component.set("v.delEvent", false);
                component.set("v.noRenderSimpleSave", true);
                component.set("v.noRenderSchedulerSave", true);
                component.set("v.noRenderAddNewEventSave", false);
                helper.getAccount(component);
                helper.getCurrentTime(component);
                component.set("v.simpleRecord.Reason_for_Turning_Procedure_Down__c", nullval);
                component.set("v.simpleRecord.Comments__c", "");
            }
         }
         else if(selected == "Procedure Turned Down"){
            component.set("v.noRenderBottom", true);
            component.set("v.noRenderScheduler", true);
            component.set("v.hideReasonForTurnDown", false);
            component.set("v.stentorAndCutdownRequired", false);
            component.set("v.resForAbort_disabled", true);  

            component.set("v.noRenderSimpleSave", false);
            component.set("v.noRenderSchedulerSave", true);
            component.set("v.noRenderAddNewEventSave", true);
            
            if(haveSchedule){
                alert("WARNING: If you save this Procedure Form with a Status of \"Procedure Turned Down,\" The associated event will be cancelled");
                component.set("v.delEvent", true);
            }
        }
         else{
            component.set("v.noRenderBottom", false);
            component.set("v.noRenderScheduler", true);
            component.set("v.hideReasonForTurnDown", true);
            component.set("v.resForAbort_disabled", true);
            component.set("v.delEvent", false);

            component.set("v.noRenderSimpleSave", false);
            component.set("v.noRenderSchedulerSave", true);
            component.set("v.noRenderAddNewEventSave", true);
            component.set("v.simpleRecord.Reason_for_Turning_Procedure_Down__c", nullval);

            var noSRMPres = component.get("v.simpleRecord.No_SRM_Personnel_Present__c");

            if(noSRMPres == true){
                component.set("v.amUser_dis", true);
                component.set("v.adUser_dis", true);
                component.set("v.tdsUser_dis", true);
                component.set("v.tdsUser_dis", true);
                component.set("v.qualUser_dis", true);
            }
         }
         
         if( selected == "Converted to CEA" || selected == "Converted to TF-CAS" || selected == "Aborted"){
             component.set("v.resForAbort_disabled", false);
             component.set("v.stentorAndCutdownRequired", true);
             component.set("v.delEvent", false);  
         }
         else if( selected == "Cancelled/Rescheduled" ){
            component.set("v.noRenderBottom", true);
            component.set("v.noRenderScheduler", true);
            component.set("v.hideReasonForTurnDown", true);
            component.set("v.stentorAndCutdownRequired", false);
             

            component.set("v.noRenderSimpleSave", false);
            component.set("v.noRenderSchedulerSave", true);
            component.set("v.noRenderAddNewEventSave", true);
            
            component.set("v.resForAbort_disabled", false);
            component.set("v.delEvent", false);  

            if(haveSchedule){
                alert("WARNING: If you save this Procedure Form with a Status of \"Cancelled/Rescheduled\" any associated calendar event will be cancelled");
                component.set("v.delEvent", true);
            }
         }
         else {
            var noRenderScheduler = component.get("v.noRenderScheduler");
            if(!noRenderScheduler){	 
                component.set("v.resForAbort_disabled" , true);
                component.set("v.stentorAndCutdownRequired", true);
                component.set("v.delEvent", false);
            }
         }
     },
    





     onConvertToGA: function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.simpleRecord.Converted_to_GA__c", selected1);
     },





    
    
     onAtropene: function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.simpleRecord.Atropene__c", selected1);
     },
    
    onguidewire: function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();

         component.set("v.simpleRecord.Guidewire_Manufacturer__c", selected1);
         var v = component.get("v.simpleRecord.Guidewire_Manufacturer__c");
         var otherguidewire = component.find("otherguidewire");
         if(selected1 == 'Other'){
     		otherguidewire.set("v.disabled", false);
         }
         else{
             otherguidewire.set("v.disabled", true);
             otherguidewire.set("v.value", "");
         }
        
     },
    
    
    
     onGlyccopyrrolate: function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.simpleRecord.Glyccopyrrolate__c", selected1);
     },
    
    
    
    
     onMpkMfg: function(component, event) {
         var selected = event.getSource().get("v.value");
         var otherMPK = component.find("otherMpkMfg")
        if(selected == "Other"){
            otherMPK.set("v.disabled", false); 
        }
        else{
            otherMPK.set("v.value", "");
            otherMPK.set("v.disabled", true);
        }
     },
    
    
    
    
     onMpkSize: function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.simpleRecord.MPK_Size__c", selected1);
     },
    
    
    
    
     onMpkDial:  function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.simpleRecord.MPK_Dialator__c", selected1);
     },
    
    
    
    
     onArtSheathAccess:  function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.simpleRecord.Arterial_Sheath_Access__c", selected1);
     },
    
    
    
    
     onNpsVersion:  function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.simpleRecord.NPS_Version__c", selected1);
     },
    
    
    
    
     onNpsLotNumber:  function(component, event) {
         var selected = event.getSource().get("v.value");
         component.set("v.simpleRecord.NPS_Lot_No__c", selected);
     }, 
    
    
    
    
    onArtSheathPlacementWire:  function(component, event) {
         var selected = event.getSource().get("v.value");
         var otherMPK = component.find("otherartsheathpplacementwire")
        if(selected == "Other"){
            otherMPK.set("v.disabled", false); 
        }
        else{
            otherMPK.set("v.value", "");
            otherMPK.set("v.disabled", true);
        }
     },
    
    
    
    
     onInterventionalTools:  function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.simpleRecord.Use_of_Interventional_Tools__c", selected1);
     },
    
    
    
    
     onWireTechnique:  function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.simpleRecord.Wire_Technique__c", selected1);
     },
   
    
    
    
    
     onNumberOfStents:  function(component, event) {
         var selected = event.getSource().get("v.value");
         
         // SET DEPLOYMENT AND REMOVAL PARAMS
         var edeploy0 = component.find("edeploy0");
         var eremove0 = component.find("eremove0");
         var enroutestentdeployment = component.find("enroutestentdeployment");
         var enroutestentremoval = component.find("enroutestentremoval");
	 	 
         var s1type0 = component.find("s1type1");
         var s1size0 = component.find("s1size0");
         var s2type0 = component.find("s2type1");
         var s2size0 = component.find("s2size0");
        
         var selectstint1type = component.find("selectstint1type");
         var otherstint1type = component.find("otherstint1type");
         var selectstint1size = component.find("selectstint1size");
         var stint1lotno = component.find("stint1lotno");

                
         var selectstint2type = component.find("selectstint2type");
         var otherstint2type = component.find("otherstint2type");
         var selectstint2size = component.find("selectstint2size");
         var stint2lotno = component.find("stint2lotno");
         
         var disabled = "- DISABLED -";
         var noneSel = "- None Selected -";
        
      
        
        if(selected == null || selected == "" || selected == "- None Selected -"){
            s2type0.set("v.label" , disabled);
            s2size0.set("v.label" , disabled);
            selectstint2type.set("v.value",disabled);
            selectstint2type.set("v.disabled" , true);
            selectstint2size.set("v.value" , disabled);
            selectstint2size.set("v.disabled" , true);
           
            stint2lotno.set("v.value","");
            otherstint2type.set("v.value", "");
            otherstint2type.set("v.disabled", true);
            stint2lotno.set("v.disabled", true);
            
            s1type0.set("v.label" , disabled);
            s1size0.set("v.label" , disabled);
            selectstint1type.set("v.disabled" , true);
            selectstint1size.set("v.disabled" , true);
            otherstint1type.set("v.value", "");
            otherstint1type.set("v.disabled", true);
            stint1lotno.set("v.value", "");
            stint1lotno.set("v.disabled", true);
            
            component.set("v.simpleRecord.Stent_No_1_Type__c", disabled);
            component.set("v.simpleRecord.Stent_No_2_Type__c", disabled);
            component.set("v.simpleRecord.Stent_1_Size__c", disabled);
            component.set("v.simpleRecord.Stent_2_Size__c", disabled);
            
            edeploy0.set("v.label", noneSel);
            eremove0.set("v.label", noneSel);
            enroutestentdeployment.set("v.disabled", false);
            enroutestentremoval.set("v.disabled", false);
        }
         else if(selected == "None"){
            s2type0.set("v.label" , disabled);
            s2size0.set("v.label" , disabled);
            selectstint2type.set("v.value",disabled);
            selectstint2type.set("v.disabled" , true);
            selectstint2size.set("v.value" , disabled);
            selectstint2size.set("v.disabled" , true);
           
            stint2lotno.set("v.value","");
            otherstint2type.set("v.value", "");
            otherstint2type.set("v.disabled", true);
            stint2lotno.set("v.disabled", true);
            
            s1type0.set("v.label" , disabled);
            s1size0.set("v.label" , disabled);
            selectstint1type.set("v.disabled" , true);
            selectstint1size.set("v.disabled" , true);
            otherstint1type.set("v.value", "");
            otherstint1type.set("v.disabled", true);
            stint1lotno.set("v.value", "");
            stint1lotno.set("v.disabled", true);
            
            component.set("v.simpleRecord.Stent_No_1_Type__c", disabled);
            component.set("v.simpleRecord.Stent_No_2_Type__c", disabled);
            component.set("v.simpleRecord.Stent_1_Size__c", disabled);
            component.set("v.simpleRecord.Stent_2_Size__c", disabled);
             
            edeploy0.set("v.label", disabled);
            eremove0.set("v.label", disabled);
            enroutestentdeployment.set("v.disabled", true);
            enroutestentremoval.set("v.disabled", true);
         }
        else if(selected == "1"){
            s2type0.set("v.label" , disabled);
            s2size0.set("v.label" , disabled);
            
            s1type0.set("v.label" , "SRM ENROUTE");
            component.set("v.simpleRecord.Stent_No_1_Type__c", "SRM ENROUTE");
            s1size0.set("v.label" , noneSel);
           
            selectstint2size.set("v.value" ,noneSel);
            selectstint2size.set("v.value" ,disabled);
            selectstint2type.set("v.value",disabled);
           
            selectstint2size.set("v.disabled",true);
            selectstint2type.set("v.disabled" , true);
            
            stint2lotno.set("v.value","");

            otherstint2type.set("v.value", "");
            otherstint2type.set("v.disabled", true);
            stint2lotno.set("v.disabled", true);
            component.set("v.simpleRecord.Stint_2_Size__c", disabled);
            
            selectstint1type.set("v.value" , "SRM ENROUTE");
            selectstint1type.set("v.disabled" , false);
            selectstint1size.set("v.disabled" , false);
            otherstint1type.set("v.value", "");
            otherstint1type.set("v.disabled", true);
            stint1lotno.set("v.disabled", false);
                     
            edeploy0.set("v.label", noneSel);
            eremove0.set("v.label", noneSel);
            enroutestentdeployment.set("v.disabled", false);
            enroutestentremoval.set("v.disabled", false);
            
        }
        else if(selected == "2"){
            s2type0.set("v.label" , "SRM ENROUTE");
            component.set("v.simpleRecord.Stent_No_2_Type__c", "SRM ENROUTE");
            s2size0.set("v.label" , noneSel);
            
            s1type0.set("v.label" , "SRM ENROUTE");
            component.set("v.simpleRecord.Stent_No_1_Type__c", "SRM ENROUTE");
            s1size0.set("v.label" , noneSel);

      
            
            selectstint2size.set("v.value" ,noneSel);
            selectstint2type.set("v.value","SRM ENROUTE");
           
            selectstint2size.set("v.disabled",false);
            selectstint2type.set("v.disabled" ,false);
            
            stint2lotno.set("v.value","");

            otherstint2type.set("v.value", "");
            otherstint2type.set("v.disabled", true);
            stint2lotno.set("v.disabled", false);
            component.set("v.simpleRecord.Stint_2_Size__c", noneSel);
            
            selectstint1type.set("v.disabled" , false);
            selectstint1size.set("v.disabled" , false);
            otherstint1type.set("v.disabled", true);
            stint1lotno.set("v.disabled", false);
                
            edeploy0.set("v.label", noneSel);
            eremove0.set("v.label", noneSel);
            enroutestentdeployment.set("v.disabled", false);
            enroutestentremoval.set("v.disabled", false);           	

            }
     },
    
    
    
    
    onStint1Type:  function(component, event) {
         var selected = event.getSource().get("v.value");
         var otherStint1 = component.find("otherstint1type")
         component.set("v.simpleRecord.Stent_1_Type__c", selected);
        if(selected == "Other"){
            otherStint1.set("v.disabled", false); 
        }
        else{
            otherStint1.set("v.value", "");
            otherStint1.set("v.disabled", true);
        }
     },
    
    
    
    
     onStint2Type:  function(component, event) {
         var selected = event.getSource().get("v.value");
         var otherStint2 = component.find("otherstint2type")
         component.set("v.simpleRecord.Stent_2_Type__c", selected);
        if(selected == "Other"){
            otherStint2.set("v.disabled", false); 
        }
        else{
            otherStint2.set("v.value", "");
            otherStint2.set("v.disabled", true);
        }
     }, 
    
    
    
    
    
     onpredilsize:  function(component, event) {
         var selected = event.getSource().get("v.value");
         var preDilOtherSize = component.find("preDilOtherSize");

        if(selected == "Other Size"){
            preDilOtherSize.set("v.disabled", false); 
        }
        else{
            preDilOtherSize.set("v.value", "");
            preDilOtherSize.set("v.disabled", true);
        }
     },
    
    
    
     onpostdilsize:  function(component, event) {
/*         var selected = event.getSource().get("v.value");
         var postDilOtherSize = component.find("postDilOtherSize");

        if(selected == "Other Size"){
            postDilOtherSize.set("v.disabled", false); 
        }
        else{
            postDilOtherSize.set("v.value", "");
            postDilOtherSize.set("v.disabled", true);
        }
        */
     },
    
    
    
    
    onLocalComplications:  function(component, event) {
         var selected = event.getSource().get("v.value");
         var selected1 = selected.trim();
         var otherLocComp = component.find("otherLocalComplications")
        if(selected1 == "Other"){
            otherLocComp.set("v.disabled", false); 
        }
        else{
            otherLocComp.set("v.value", "");
            otherLocComp.set("v.disabled", true);
        }
     },  
    
    
    
    
    onFilterPhoto:  function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         if(selected1 == "Yes"){
         	component.set("v.simpleRecord.Filter_Photo_Taken__c", true);
         } 
        else {
            component.set("v.simpleRecord.Filter_Photo_Taken__c", false);
        }
     }, 
    
    
    
    

    
    
    
    
    
    onNoSRM: function(component, event, helper) {
        var selected = event.getSource().get("v.checked");
        
        if(selected == true ){
            helper.noSRMPresOn(component);
        }
        else {
            helper.noSRMPresOff(component);
        }
        
    },
    
    
    
    
    disableANAOthers: function(component, event) {
        var selectedCk = event.getSource().get("v.checked");
        
        var proceduretype = component.find("proceduretype").get("v.value");
        var isROADSTER2 = false;
        if(proceduretype == "ROADSTER 2" || proceduretype == "ROADSTER 2 DW-MRI"){
            isROADSTER2 = true;
        }
       
        
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
        
        var selected = event.getSource();
        var anaCad = component.find("anaCad");
        var anaBila = component.find("anaBila");
        var anaCea = component.find("anaCea");
        var anaCont = component.find("anaCont");
        var anaHigh = component.find("anaHigh");
        var anaHost = component.find("anaHost");
        var anaLaryn = component.find("anaLaryn");
        var anaSpin = component.find("anaSpin");
        var anaTand = component.find("anaTand");
        if(selectedCk == true){
            
        	anaCad.set("v.checked", false);
            anaCad.set("v.disabled", true);
            
            anaBila.set("v.checked", false);
            anaBila.set("v.disabled", true);
            
            anaCea.set("v.checked", false);
            anaCea.set("v.disabled", true);
            
            anaCont.set("v.checked", false);
            anaCont.set("v.disabled", true);
            
            anaHigh.set("v.checked", false);
            anaHigh.set("v.disabled", true);
            
            anaHost.set("v.checked", false);
            anaHost.set("v.disabled", true);
            
            anaLaryn.set("v.checked", false);
            anaLaryn.set("v.disabled", true);
            
            anaSpin.set("v.checked", false);
            anaSpin.set("v.disabled", true);
            
			anaTand.set("v.checked", false);
            anaTand.set("v.disabled", true);  
                        
            clinAge.set("v.checked", false);
            clinAge.set("v.disabled", true);
            
            clinAng.set("v.checked", false);
            clinAng.set("v.disabled", true);
            
            clinCcs.set("v.checked", false);
            clinCcs.set("v.disabled", true);
            
            clinChf.set("v.checked", false);
            clinChf.set("v.disabled", true);
            
            clinCni.set("v.checked", false);
            clinCni.set("v.disabled", true);
            
            clinCopd.set("v.checked", false);
            clinCopd.set("v.disabled", true);
            
            clinDiab.set("v.checked", false);
            clinDiab.set("v.disabled", true);
            
			clinHeart.set("v.checked", false);
            clinHeart.set("v.disabled", true);   
            
			clinLvef.set("v.checked", false);
            clinLvef.set("v.disabled", true);
            
			clinMi.set("v.checked", false);
            clinMi.set("v.disabled", true);
            
			clinRena.set("v.checked", false);
            clinRena.set("v.disabled", true);
            
			clinStress.set("v.checked", false);
            clinStress.set("v.disabled", true);
            
            clinSurg.set("v.checked", false);
            clinSurg.set("v.disabled", true);
        }
        else{
            anaCad.set("v.disabled", false);
            
            anaBila.set("v.disabled", false);
            
            anaCea.set("v.disabled", false);
            
            anaCont.set("v.disabled", false);
            
            anaHigh.set("v.disabled", false);
            
            anaHost.set("v.disabled", false);
            
            anaLaryn.set("v.disabled", false);
            
            anaSpin.set("v.disabled", false);
            
            anaTand.set("v.disabled", false); 
            
            clinAge.set("v.disabled", false);
            
            clinAng.set("v.disabled", false);
            
            clinDiab.set("v.disabled", false);
            
            clinCcs.set("v.disabled", false);
            
            clinChf.set("v.disabled", false);
            
            clinCni.set("v.disabled", false);
            
            clinCopd.set("v.disabled", false);
            
            clinHeart.set("v.disabled", false);
            
            clinLvef.set("v.disabled", false); 
            
            clinMi.set("v.disabled", false);
             
            clinRena.set("v.disabled", false); 
             
            clinStress.set("v.disabled", false);  
            
            clinSurg.set("v.disabled", false); 
            
            if(isROADSTER2 == true){
                anaLaryn.set("v.checked", false);
                anaSpin.set("v.checked", false);
                clinDiab.set("v.checked", false);
                clinHeart.set("v.checked", false);
                clinSurg.set("v.checked", false); 
                clinStress.set("v.checked", false);
                
                anaLaryn.set("v.disabled", true);
                anaSpin.set("v.disabled", true);
                clinDiab.set("v.disabled", true);
                clinHeart.set("v.disabled", true);
                clinSurg.set("v.disabled", true); 
                clinStress.set("v.disabled", true);
            }
            
        }
       
     },
    
    
    
    
     disableANANone: function(component, event) {
        
        var anaNoneCk = component.find("anaNone").get("v.checked");
        var anaNone = component.find("anaNone");
        
        var anaCad = component.find("anaCad").get("v.checked");
        var anaBila = component.find("anaBila").get("v.checked");
        var anaCea = component.find("anaCea").get("v.checked");
        var anaCont = component.find("anaCont").get("v.checked");
        var anaHigh = component.find("anaHigh").get("v.checked");
        var anaHost = component.find("anaHost").get("v.checked");
        var anaLaryn = component.find("anaLaryn").get("v.checked");
        var anaSpin = component.find("anaSpin").get("v.checked");
        var anaTand = component.find("anaTand").get("v.checked");
        
        var clinAge = component.find("clinAge").get("v.checked");
        var clinAng = component.find("clinAng").get("v.checked");
        var clinCcs = component.find("clinCcs").get("v.checked");
        var clinChf = component.find("clinChf").get("v.checked");
        var clinCni = component.find("clinCni").get("v.checked");
        var clinCopd = component.find("clinCopd").get("v.checked");
        var clinDiab = component.find("clinDiab").get("v.checked");
        var clinHeart = component.find("clinHeart").get("v.checked");
        var clinLvef = component.find("clinLvef").get("v.checked");
        var clinMi = component.find("clinMi").get("v.checked");
        var clinRena = component.find("clinRena").get("v.checked");
        var clinStress = component.find("clinStress").get("v.checked");
        var clinSurg = component.find("clinSurg").get("v.checked");
        
        if( anaCad == true ||
            anaBila == true ||
            anaCea == true ||
            anaCont == true ||
            anaHigh == true ||
            anaHost == true ||
            anaLaryn == true ||
            anaSpin == true ||
           	anaTand == true ||
          
            clinAge == true ||
            clinAng == true ||
            clinCcs == true ||
            clinChf == true ||
            clinCni == true ||
            clinCopd == true ||
            clinDiab == true ||
            clinHeart == true ||
            clinLvef == true ||
            clinMi == true ||
            clinRena == true ||
            clinStress == true ||
            clinSurg == true
          ){
            
            anaNone.set("v.checked", false);
            anaNone.set("v.disabled", true);
        }
        else {
            anaNone.set("v.disabled", false);
        }
        component.set("v.simpleRecord.HRC_ANA_CAD__c", anaCad);
        component.set("v.simpleRecord.HRC_ANA_NONE__c", anaNoneCk);
        component.set("v.simpleRecord.HRC_ANA_TAND__c", anaTand);
        component.set("v.simpleRecord.HRC_ANA_SPIN__c", anaSpin);
        component.set("v.simpleRecord.HRC_ANA_LARYN__c", anaLaryn);
        component.set("v.simpleRecord.HRC_ANA_HOST__c", anaHost);
        component.set("v.simpleRecord.HRC_ANA_HIGH__c", anaHigh);
        component.set("v.simpleRecord.HRC_ANA_CONT__c", anaCont);
        component.set("v.simpleRecord.HRC_ANA_CEA__c", anaCea);
        component.set("v.simpleRecord.HRC_ANA_BILA__c", anaBila);
        
        component.set("v.simpleRecord.HRC_CLN_AGE__c", clinAge);
       	component.set("v.simpleRecord.HRC_CLN_ANG__c", clinAng);
        component.set("v.simpleRecord.HRC_CLN_CCS__c", clinCcs);
        component.set("v.simpleRecord.HRC_CLN_CHF__c", clinChf);
        component.set("v.simpleRecord.HRC_CLN_CNI__c", clinCni);
        component.set("v.simpleRecord.HRC_CLN_COPD__c", clinCopd);
        component.set("v.simpleRecord.HRC_CLN_DIAB__c", clinDiab);
        component.set("v.simpleRecord.HRC_CLN_HEART__c", clinHeart);
        component.set("v.simpleRecord.HRC_CLN_LVEF__c", clinLvef);
        component.set("v.simpleRecord.HRC_CLN_MI__c", clinMi);
        component.set("v.simpleRecord.HRC_CLN_RENA__c", clinRena);
        component.set("v.simpleRecord.HRC_CLN_STRESS__c", clinStress);
        component.set("v.simpleRecord.HRC_CLN_SURG__c", clinSurg);
    },
    
    
    
    
    calculateSkinToSkinTimeText: function(component, event, helper) {
    	var target = event.getSource();
		helper.checkTest(target);   
    
    	var hr = Number(component.find('s2sTimeTxtEnterHr').get('v.value'));    
        var mn = Number(component.find('s2sTimeTxtEnterMn').get('v.value'));
        var ss = Number(component.find('s2sTimeTxtEnterSs').get('v.value'));
        
        var hrT;
        var mnT;
        var ssT;
        var timeText = '00:00:00';
        
        var regex = /^[0-9]+$/;
        var regexhr = regex.test(hr);
        var regexmn = regex.test(mn);
        var regexss = regex.test(ss);
        
        if(regexhr && regexmn && regexss && !isNaN(hr)){
            if(!hr){ hr = 0;}
            if(!mn){ mn = 0;}
            if(!ss){ ss = 0;}
            
            if(hr < 10){ hrT = '0' + hr; } else { hrT = hr; }
            if(mn < 10){ mnT = '0' + mn; } else { mnT = mn; } 
            if(ss < 10){ ssT = '0' + ss; } else { ssT = ss; }
            
            if(hr >= 0 && hr <= 24 && mn >= 0 && mn < 60 && ss >= 0 && ss < 60){
        
                timeText = hrT + ':' + mnT + ':' + ssT;
               
            	component.set("v.simpleRecord.SkinToSkinTimeTxt__c", timeText);
            	var numberofMinutes = Number(hr) * 60 +  Number(mn) + Number(ss) / 60;
            	component.set("v.simpleRecord.Skin_to_Skin_Time__c", numberofMinutes);
                
            }
            
        }
        var reportTime = component.get("v.s2sStatedTime");
        component.set("v.s2sStatedTime", timeText);   
    },  
    
    
    
    
	calculateReverseFlowTimeText: function(component, event, helper) {
        
    	var target = event.getSource();
		helper.checkTest(target);   
    
        
        
    	var hr = Number(component.find('rftTimeTxtEnterHr').get('v.value')); 
        var mn = Number(component.find('rftTimeTxtEnterMn').get('v.value'));
        var ss = Number(component.find('rftTimeTxtEnterSs').get('v.value'));
        
        var hrT;
        var mnT;
        var ssT;
        var timeText = '00:00:00';
        
        var regex = /^[0-9]+$/;
        var regexhr = regex.test(hr);
        var regexmn = regex.test(mn);
        var regexss = regex.test(ss);
        
        if(regexhr && regexmn && regexss && !isNaN(hr)){
            if(!hr){ hr = 0;}
            if(!mn){ mn = 0;}
            if(!ss){ ss = 0;}
            
            if(hr < 10){ hrT = '0' + hr; } else { hrT = hr; }
            if(mn < 10){ mnT = '0' + mn; } else { mnT = mn; } 
            if(ss < 10){ ssT = '0' + ss; } else { ssT = ss; }
            
            if(hr >= 0 && hr <= 24 && mn >= 0 && mn < 60 && ss >= 0 && ss < 60){

                timeText = hrT + ':' + mnT + ':' + ssT;
               
            	component.set("v.simpleRecord.ReverseFlowTimeTxt__c", timeText);
            	var numberofMinutes = Number(hr) * 60 +  Number(mn) + Number(ss) / 60;
            	component.set("v.simpleRecord.Reverse_Flow_Time__c", numberofMinutes);
                
            }
            
        }
        var reportTime = component.get("v.rftStatedTime");
        component.set("v.rftStatedTime", timeText); 
    },
    
    
    
    
	calculateFlouroTimeText: function(component, event, helper) {
    	var target = event.getSource();
		helper.checkTest(target);   
    
    	var hr = Number(component.find('ftTimeTxtEnterHr').get('v.value'));    
        var mn = Number(component.find('ftTimeTxtEnterMn').get('v.value'));
        var ss = Number(component.find('ftTimeTxtEnterSs').get('v.value'));
        
        var hrT;
        var mnT;
        var ssT;
        var timeText = '00:00:00';
        
        var regex = /^[0-9]+$/;
        var regexhr = regex.test(hr);
        var regexmn = regex.test(mn);
        var regexss = regex.test(ss);
        
        if(regexhr && regexmn && regexss && !isNaN(hr)){
            if(!hr){ hr = 0;}
            if(!mn){ mn = 0;}
            if(!ss){ ss = 0;}
            
            if(hr < 10){ hrT = '0' + hr; } else { hrT = hr; }
            if(mn < 10){ mnT = '0' + mn; } else { mnT = mn; } 
            if(ss < 10){ ssT = '0' + ss; } else { ssT = ss; }
            
            if(hr >= 0 && hr <= 24 && mn >= 0 && mn < 60 && ss >= 0 && ss < 60){
                timeText = hrT + ':' + mnT + ':' + ssT;
               
            	component.set("v.simpleRecord.FluoroTimeMinutesTxt__c", timeText);
            	var numberofMinutes = Number(hr) * 60 +  Number(mn) + Number(ss) / 60;
            	component.set("v.simpleRecord.Fluoro_Time_minutes__c", numberofMinutes);
                
            }
            
        }
        var reportTime = component.get("v.ftStatedTime");
        component.set("v.ftStatedTime", timeText); 
    },





    updateFellow2: function(component, event, helper) {
        var fellow2 = component.find("fellow2").get("v.checked");
        component.set("v.simpleRecord.Additional_Physician_2_Fellow__c", fellow2);
    },   
 





    changeAddlPhys1: function(component, event, helper) {
        var physId = component.find("addlPhys1").get("v.value");
        var nullId = component.get("v.nullId");
        
        if(physId == 'none'){
            physId = nullId;
        }

        if(physId != null && physId != ""){
            component.set("v.simpleRecord.Additional_Physician_1__c", physId);

            var action = component.get("c.getPhysicianRecord");

            action.setParams({
                    physId: physId
                    
                });
            var self = this;
            action.setCallback(this, function(actionResult) {

                var phys1Name = actionResult.getReturnValue().Name;
                var phys1Fellow = actionResult.getReturnValue().Fellow__c;

                component.find('fellow1').set("v.checked", phys1Fellow);

            });
            
            $A.enqueueAction(action);
        }
         else{
            component.set("v.simpleRecord.Additional_Physician_1__c", nullId);
            component.find('fellow1').set("v.checked", false);
        }
    },
    








     changeAddlPhys2: function(component, event, helper) {
        var physId = component.find("addlPhys2").get("v.value");
        var nullId = component.get("v.nullId");
         
        if(physId == 'none'){
            physId = nullId;
        }

        if(physId != null && physId != ""){

            component.set("v.simpleRecord.Additional_Physician_2__c", physId);

            var action = component.get("c.getPhysicianRecord");

            action.setParams({
                    physId: physId
                    
                });
            var self = this;
            action.setCallback(this, function(actionResult) {

                var phys2Name = actionResult.getReturnValue().Name;
                var phys2Fellow = actionResult.getReturnValue().Fellow__c;

                component.find('fellow2').set("v.checked", phys2Fellow);

            });           

            $A.enqueueAction(action);
        }
         else{
            component.find('fellow2').set("v.checked", false);
            component.set("v.simpleRecord.Additional_Physician_2__c", nullId);
        }
    },      







    newPopup : function(component, event, helper){
        var cmpTarget = component.find('Modalbox1');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
    },

    
    
    
    
    saveModal : function(component, event, helper){
        var regForm = component.get("v.contForm");
        var firstName = component.get("v.contForm.FirstName");
        var lastName = component.get("v.contForm.LastName");
        var contEmail = component.get("v.contForm.Email");
        var fellow = component.get("v.contForm.Fellow__c");
        
        var action = component.get("c.createNewContact");
        
        var accountId = component.get("v.simpleRecord.Account__c");
        
        if(firstName == null || firstName == ""){
            alert("First Name is Required");
        }
        else if(lastName == null || lastName == ""){
            alert("Last Name is Required");
        }
        else if(contEmail == null || contEmail == ""){
            alert("Email is Required");
        }
        else{    
        
            action.setParams({
                regForm1  : regForm,
                accountId : accountId
                
            });
            var self = this;    
            action.setCallback(this, function(response) {
                var state = response.getState();         
                if (state === "SUCCESS") { 
                    
                    var cmpTarget = component.find('Modalbox1');
                    var cmpBack = component.find('Modalbackdrop');
                    $A.util.removeClass(cmpBack,'slds-backdrop--open');
                    $A.util.removeClass(cmpTarget, 'slds-fade-in-open');                 
                    
                    helper.getPhysicianList(component);                     

                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    alert("Error Creating Opportunity and Contact.  Please verify that the contact you adding is not a duplicate contact.  Additional Info: " + errors[0].message);
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +
                                        errors[0].message);
                        }
                    }
                    else {
                        console.log(response.getReturnValue());
                    }
                }
            });
            $A.enqueueAction(action);
        }   
    },

    

    
    
    
    closeNewModal : function(component, event, helper){
        var cmpTarget = component.find('Modalbox1');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
    },

})