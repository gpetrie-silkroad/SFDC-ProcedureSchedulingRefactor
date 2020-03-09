({
	// Load List<Procedure_Form__c>  from Salesforce
	doInit: function(component, event, helper) {

        component.set('v.hours', ('00', '02', '03', '04'));

        // Create the action; the action is the call to the apex controller
        var action = component.get("c.getProcedureForm");    
        helper.getTimeListForSelect(component);
        helper.getAccount(component);     
        helper.getPhysicianList(component);        
        helper.getCurrentUser(component);        
        helper.getCurrentTime(component);        
        helper.getAMUsers(component);         
        helper.getTDSUsers(component);         
        helper.getTDSUsers2(component);         
        helper.getADUsers(component);         
        helper.getQualUsers(component);        
         
         
        helper.getStenterList(component);          
        helper.getCutdownList(component);          
        helper.getProctorList(component);
        
           var selected =  component.find("completion").get("v.value");    
           
         if( selected == "Converted to CEA" || selected == "Converted to TF-CAS" || selected == "Aborted" ){
            component.set("v.reasonForAbort_dis", false); 
         }
         else {
            component.set("v.reasonForAbort_dis" , true);
         }
        
    
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.procedureForms", response.getReturnValue());             
                helper.updateProcedureNameOnInit(component);
            }
            else {
               
                console.log("Failed with state: " + state);
            }
        });    
        
        
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
        
        // Send action off to be executed
        $A.enqueueAction(action);
	},
    
 
    
    
    
	createProcedureForm: function(component, procedureForm) {
        alert("CREATE PROCERDURE FORM CONTROLLER STARTED");
        var action = component.get("c.saveProcedureForm");
        action.setParams({
            "procedureForm": procedureForm
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var procedureForms = component.get("v.procedureForms");
                expenses.push(response.getReturnValue());
                component.set("v.procedureForms", procedureForms);
            }
            alert("CREATE PROCERDURE FORM CONTROLLER STOPPED");
        });
        $A.enqueueAction(action);
    },

    
    clickCreate1: function(component,event, helper){
         var firstName = component.get("v.currentUser");
        // alert("ProfileName 09 = " + firstName.Profile.Name);
    },
    
    
    //********************************************************************************************************************************************************************************************************************/
    //********************************************************************************************************************************************************************************************************************/
    //**********            S A V E    W I T H     N O      S C H E D U L E                                                                                                                                     **********
    //********************************************************************************************************************************************************************************************************************/
    //********************************************************************************************************************************************************************************************************************/
    clickCreate: function(component, event, helper) {

        alert("Click Create Started");

        //********************************************************************************
        //********************************************************************************
        //**  F O R M    V A L I D A T I O N 
        //********************************************************************************
        ////********************************************************************************        
        // COLLECT PARAMETERS TO VALIDATE FORM
     
        var profileName = component.get("v.currentUser");
        
        helper.setNone(component);
        
        var applyValidationRules = true;
        if(profileName.Profile.Name == "System Administrator" || profileName.Profile.Name == "Clinical Affairs Team"){
            applyValidationRules = false;
            alert("WARNING:  Your User Profile is " + profileName.Profile.Name + ". Validation Rules Not Applied");
        }
        
        
        var procedureType = component.get("v.newProcedureForm.Procedure_Type__c");
		var procedureDate = component.get("v.newProcedureForm.Procedure_Date__c");
        var procedureStatus = component.get("v.newProcedureForm.Procedure_Completion__c");
        
        if(procedureStatus == 'Scheduled'){
            component.set("v.newProcedureForm.Event_Attached__c", true);
            component.set("v.newProcedureForm.Event_ActivityDate__c", procedureDate);
            
            var lStartTime = component.get("v.startTime");
            var lEndTime = component.get("v.endTime");
            var lTimeZone = component.get("v.hospitalTimeZone");
            var locInfo =component.get("v.locationInfo");
            var oInfo = component.get("v.OtherInformation}");


            component.set("v.newProcedureForm.Event_Local_End_TIme__c", lEndTime);
            component.set("v.newProcedureForm.Event_Local_Start_Time__c", lStartTime);
            component.set("v.newProcedureForm.Event_Local_Time_Zone__c", lTimeZone);
            component.set("v.newProcedureForm.Event_Location_Info__c", locInfo);
            component.set("v.newProcedureForm.Event_Other_Information__c", oInfo);
        }
        else{
            var nullVal;
            component.set("v.newProcedureForm.Event_Attached__c", false);
            component.set("v.newProcedureForm.Event_ActivityDate__c", nullVal);
            
            var lStartTime = component.set("v.startTime");
            var lEndTime = component.set("v.endTime");
            var lTimeZone = component.set("v.hospitalTimeZone");
            var locInfo =component.set("v.locationInfo");
            var oInfo = component.set("v.OtherInformation}");

            component.set("v.newProcedureForm.Event_Local_End_TIme__c", lEndTime);
            component.set("v.newProcedureForm.Event_Local_Start_Time__c", lStartTime);
            component.set("v.newProcedureForm.Event_Local_Time_Zone__c", lTimeZone);
            component.set("v.newProcedureForm.Event_Location_Info__c", locInfo);
            component.set("v.newProcedureForm.Event_Other_Information__c", oInfo);

        }
        var reasonForAbort = component.get("v.newProcedureForm.Reason_Aborted__c");
        
        var reasonForProcedureTurnDown = component.get("v.newProcedureForm.Reason_for_Turning_Procedure_Down__c");
        
        var noSrmPersonnelPresent = component.get("v.newProcedureForm.No_SRM_Personnel_Present__c");
        var amPresent = component.get("v.newProcedureForm.AM_Present__c");
       
        //alert("AM Present = [" + amPresent + "]");
        
        var tdsPresent = component.get("v.newProcedureForm.TDS_Present__c");
        
        //alert("TDS Present = [" + tdsPresent + "]");
        
        var otherQualSrmPresent = component.get("v.newProcedureForm.Other_Qualified_SRM_Present__c");
        var adPresent = component.get("v.newProcedureForm.AD_Present__c");
        

        
        var primaryPhysicianOperator = component.get("v.newProcedureForm.Physician_Primary_Operator__c");
        var stenter = component.get("v.newProcedureForm.Stenter__c");
        var cutdown = component.get("v.selectedCutdown");
        
        var patientId = component.get("v.newProcedureForm.Patient_Id__c");
        var patientAge = component.get("v.newProcedureForm.Patient_Age__c");
        var patientGender = component.get("v.newProcedureForm.Patient_Gender__c");
        var symptomatic = component.get("v.newProcedureForm.Symptomatic__c");
        var targetVessel = component.get("v.newProcedureForm.Target_Vessel__c");
        
        var cSurg = component.get("v.newProcedureForm.HRC_CLN_SURG__c");
		var cStress = component.get("v.newProcedureForm.HRC_CLN_STRESS__c");
		var cRena = component.get("v.newProcedureForm.HRC_CLN_RENA__c");
		var cMi = component.get("v.newProcedureForm.HRC_CLN_MI__c");
		var cLvef = component.get("v.newProcedureForm.HRC_CLN_LVEF__c");
		var cHeart = component.get("v.newProcedureForm.HRC_CLN_HEART__c");
		var cDiab = component.get("v.newProcedureForm.HRC_CLN_DIAB__c");
		var cCopd = component.get("v.newProcedureForm.HRC_CLN_COPD__c");
		var cCni = component.get("v.newProcedureForm.HRC_CLN_CNI__c");
		var cChf = component.get("v.newProcedureForm.HRC_CLN_CHF__c");
		var cCcs = component.get("v.newProcedureForm.HRC_CLN_CCS__c");
		var cAng = component.get("v.newProcedureForm.HRC_CLN_ANG__c");
		var cAge = component.get("v.newProcedureForm.HRC_CLN_AGE__c");
		var cNone = component.get("v.newProcedureForm.HRC_CLIN_NONE__c");
		var aTand = component.get("v.newProcedureForm.HRC_ANA_TAND__c");
		var aSpin = component.get("v.newProcedureForm.HRC_ANA_SPIN__c");
		var aNone = component.get("v.newProcedureForm.HRC_ANA_NONE__c");
		var aLaryn = component.get("v.newProcedureForm.HRC_ANA_LARYN__c");
		var aHost = component.get("v.newProcedureForm.HRC_ANA_HOST__c");
		var aHigh = component.get("v.newProcedureForm.HRC_ANA_HIGH__c");
		var aCont = component.get("v.newProcedureForm.HRC_ANA_CONT__c");
		var aCea = component.get("v.newProcedureForm.HRC_ANA_CEA__c");
		var aCad = component.get("v.newProcedureForm.HRC_ANA_CAD__c");
		var aBila = component.get("v.newProcedureForm.HRC_ANA_BILA__c");
        
        var preCasePlanSatisfied = false;

        var noPreCase = component.get("v.newProcedureForm.No_Pre_Case_Id__c");

        if(noPreCase){
            preCasePlanSatisfied = true;
        }

        var pcId = component.get("v.preCaseId");
        var pcIdLength = 0;
        if(pcId != null){
            pcIdLength = pcId.length;
        }
        var prefix = "XYZ-";
        var pcIdError = true;

        //alert("pcId = [" + pcId + "] pcIdLength = [" + pcIdLength + "]");

        if(pcId == "SRM-"){
            pcIdError = false;
        }
        else if(pcIdLength == 12){
            prefix = pcId.substring(0,4);
            //alert("Prefix = [" + pcId.substring(0,4) + "]");
            if(prefix == "SRM-"){
                pcIdError = false;
                component.set("v.newProcedureForm.Pre_Case_Id__c", pcId);
                preCasePlanSatisfied = true;
            }
        }
    
        
        
        var anesthesia = component.get("v.newProcedureForm.Anesthesia__c");
        var convertedToGa = component.get("v.newProcedureForm.Converted_to_GA__c");
        var atropine = component.get("v.newProcedureForm.Atropene__c");
        var glyco = component.get("v.newProcedureForm.Glyccopyrrolate__c");
        var mpkMfg = component.get("v.newProcedureForm.MPK_Manufacturer__c");
        
        //var mpkltno = component.get("v.newProcedureForm.MPK_Lot_Number__c");
        
        var othMpkMfg = component.get("v.newProcedureForm.Other_MPK_Manufacturer__c");
        var mpkSize = component.get("v.newProcedureForm.MPK_Size__c");
        var mpkDial = component.get("v.newProcedureForm.MPK_Dialator__c");
        //var needleLength = component.get("v.newProcedureForm.Needle_Length__c");
        var artSheathAccess = component.get("v.newProcedureForm.Arterial_Sheath_Access__c");
        var npsVersion = component.get("v.newProcedureForm.NPS_Version__c");
        var npsLotNo = component.get("v.newProcedureForm.NPS_Lot_No__c");
        var npsPlacement = component.get("v.newProcedureForm.Enroute__c");
        var artSheathPlaceWire = component.get("v.newProcedureForm.Arterial_Sheath_Placement_Wire__c");
        var othArtSheathPlaceWire = component.get("v.newProcedureForm.Other_Arterial_Sheath_Placement_Wire__c");
        var intertools = component.get("v.newProcedureForm.Use_of_Interventional_Tools__c");
        var wireTech = component.get("v.newProcedureForm.Wire_Technique__c");
        var noOfStents = component.get("v.newProcedureForm.Number_of_Stents_Used__c");
       
        var st1type = component.get("v.newProcedureForm.Stent_No_1_Type__c");
        var st1OType = component.get("v.newProcedureForm.Other_Stent_1_Type__c");
        var st1size = component.get("v.newProcedureForm.Stent_1_Size__c");
        var st1LotNo = component.get("v.newProcedureForm.Stint_1_Lot_Number__c");
       
        var st2type = component.get("v.newProcedureForm.Stent_No_2_Type__c");
        var st2OType = component.get("v.newProcedureForm.Other_Stent_2_Type__c");
        var st2size = component.get("v.newProcedureForm.Stint_2_Size__c");
        var st2LotNo = component.get("v.newProcedureForm.Stint_2_Lot_Number__c");
         
        var guideWireMfg = component.get("v.newProcedureForm.Guidewire_Manufacturer__c");
        
        //var gwLotNo = component.get("v.newProcedureForm.Guidewire_Lot_Number__c");
        
        var otherGuideWireMfg = component.get("v.newProcedureForm.Other_Guidewire_Manufacturer__c");
        var enrouteStentDeploy = component.get("v.newProcedureForm.ENROUTE_Stint_Deployment__c");
        var enrouteStentRemove = component.get("v.newProcedureForm.ENROUTE_Delivery_System_Removal__c");
        var preDilSize = component.get("v.newProcedureForm.Pre_Dilation_Balloon_Size__c");
        var otherPreDilSize = component.get("v.newProcedureForm.Other_Pre_Dil_Balloon_Size__c");
        var postDilSize = component.get("v.newProcedureForm.Post_Dialation_Balloon_Size__c");
        var otherPostDilSize = component.get("v.newProcedureForm.Other_Post_Dil_Balloon_Size__c");
        var skinToSkinTime = component.get("v.newProcedureForm.Skin_to_Skin_Time__c");
        var revFlowTime = component.get("v.newProcedureForm.Reverse_Flow_Time__c");
        var tolOfRevFlow = component.get("v.newProcedureForm.Toleration_of_Reverse_Flow__c");
        var localCompl = component.get("v.newProcedureForm.Local_Complications__c");
        var otherLocalCompl = component.get("v.newProcedureForm.Other_Local_Complications__c");
        var dissStep = component.get("v.newProcedureForm.Dissection_Step__c");
        var dissType = component.get("v.newProcedureForm.Dissection_Type__c");
        var debris = component.get("v.newProcedureForm.Debris_in_Filter__c");
        var comment = component.get("v.newProcedureForm.Comments__c");

        var isError1 = false;
        
// A B O R T E D         
        if(procedureStatus == "Aborted" && profileName.Profile.Name != "System Administrator" && profileName.Profile.Name != "Clinical Affairs Team"){
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
                validationErrorMessage = (validationErrorMessage + i + ". Either a valid Pre-Case Plan Id must be entered or No Pre-Case Plan Id box checked. \n  Pre-Case Plan Id Must be in the form of SRM-######## (SRM- followed by 8 numbers) \n");
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

// C A N C E L L E D     /     R E S C H E D U L E D        
        if(procedureStatus == "Cancelled/Rescheduled" && profileName.Profile.Name != "System Administrator" && profileName.Profile.Name != "Clinical Affairs Team"){
            var i = 0;
            preCasePlanSatisfied = true;
            applyValidationRules = false;
            var validationErrorMessage = ("This Procedure could not be saved for the following reasons: \n\n");
            if(procedureType == null || procedureType == ""){
                isError1 = true;
                i++;
                validationErrorMessage = (validationErrorMessage + i + ". Procedure Type must be specified \n");
            }
            if((pcId == null || pcId =='' || pcId == 'SRM-' || pcIdLength != 12) && noPreCase != true){
                i++;
                validationErrorMessage = (validationErrorMessage + i + ". Either a valid Pre-Case Plan Id must be entered or No Pre-Case Plan Id box checked. \n  Pre-Case Plan Id Must be in the form of SRM-######## (SRM- followed by 8 numbers) \n");
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

// P R O C E D U R E     T U R N E D     D O W N
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
            if(!preCasePlanSatisfied){
                validationErrorMessage = (validationErrorMessage + i + ". Either a valid Pre-Case Plan Id must be entered or No Pre-Case Plan Id box checked \n");
                isError = true;
                i++;
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


// P R O C E D U R E     S C H E D U L E D     N O      S R M     P E R S O N N E L    P R E S E N T
            if(procedureStatus != null && procedureStatus != "" && procedureStatus != "Scheduled" && noSrmPersonnelPresent == true){
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


// S C H E D U L E D     S R M    P E R S O N N E L     P R E S E N T            
            if(procedureStatus != null && procedureStatus != "" && procedureStatus != "Scheduled" && noSrmPersonnelPresent != true){
                if(!preCasePlanSatisfied){
                    validationErrorMessage = (validationErrorMessage + i + ". Either a valid Pre-Case Plan Id must be entered or No Pre-Case Plan Id box checked \n");
                    isError = true;
                    i++;
                }
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
                    validationErrorMessage = (validationErrorMessage + i + ". Skin to Skin Time is Required. Please Check Time Entry \n");
                    isError = true;
                    i++;        
                }
                if(revFlowTime == null || revFlowTime == "" || revFlowTime == 0){
                    validationErrorMessage = (validationErrorMessage + i + ". Reverse Flow Time is Required. Please Check Time Entry \n");
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
                
                var newProcedureForm = component.get("v.newProcedureForm");
 
                helper.createProcedureForm(component, newProcedureForm); 
            
                alert('Procedure Form Successfully Saved');
    
                var acctId = component.get("v.newProcedureForm.Account__c");
    
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
        else if(!isError1){
            var newProcedureForm = component.get("v.newProcedureForm");

                helper.createProcedureForm(component, newProcedureForm); 
            
                
                alert('Procedure Form Successfully Saved');
    
                var acctId = component.get("v.newProcedureForm.Account__c");
    
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                "recordId": acctId,
                "slideDevName": "detail"
                });
            
                navEvt.fire();	
        }
           
    }, 
    
    
    
    
    
    
    
    
    
    testJavaScriptFunction: function(component, event, helper){
    	helper.testHelperJavaScriptFunction(component);  
    },    
    
    
    
    
    
    
    
    //********************************************************************************************************************************************************************************************************************/
    //********************************************************************************************************************************************************************************************************************/
    //**********            S A V E    W I T H      S C H E D U L E                                                                                                                                             **********
    //********************************************************************************************************************************************************************************************************************/
    //********************************************************************************************************************************************************************************************************************/  
/*    onCreateSchedule: function(component, event, helper){
        // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
        // * * * * * * * * * * CONDUCT VALIDATION ON ENTRIES * * * * * * * * * * * * * *
        // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
                //* * * COLLECT REQUIRED COMPONENTS IF SAVED WITH SCHEDULE ONLY
        var nowDate = component.get("v.nowDate");
        var procedureType = component.get("v.newProcedureForm.Procedure_Type__c");
		var procedureDate = component.get("v.newProcedureForm.Procedure_Date__c");
        var primaryOpPhysicianId = component.get("v.newProcedureForm.Physician_Primary_Operator__c");

        var preCaseId = component.get("v.preCaseId");
        var preCaseIdLength = 0;
        if(preCaseId != null){
            preCaseIdLength = preCaseId.length;
        }
        var noPreCaseId = component.get("v.newProcedureForm.No_Pre_Case_Id__c");

        component.set("v.newProcedureForm.Pre_Case_Id__c", preCaseId);

        var amUser = component.get("v.amUser");
        var tdsUser = component.get("v.tdsUser");
        var qualUser = component.get("v.qualUser");
        var adUser = component.get("v.adUser");
        var noSrm = component.get("v.newProcedureForm.No_SRM_Personnel_Present__c"); 

        //alert("amUser = [" + amUser + "] tdsUser = [" + tdsUser + "] adUser = [" + adUser + "] qualUsr = [" + qualUser + "] noSrm = [" + noSrm + "]");
        //alert("noPreCaseId = [" + noPreCaseId + "]");

        // * * * *  SAVE PROCEDURE FORM AND RECORD EVENT ON PROCEDURE FORM * * * * * * *     
        helper.setNone(component);
        var isError = false;
        
        // VALIDATION ERROR ENUMERATOR
        var i = 1;

// G E N E R A L      E D I T     C H E C K S        
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
            // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
            // * * * * * * * * * * CREATE NEW EVENT AND GET THE EVENT ID * * * * * * * * * *
            // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
            var accountId = component.get("v.recordId");
            var procedureDate = component.get("v.newProcedureForm.Procedure_Date__c");
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
            
  
            var locInformation = component.get("v.locationInfo");
            var primaryAmId = component.get("v.newProcedureForm.AM_Present__c");
            var primaryTdsId = component.get("v.newProcedureForm.TDS_Present__c");

            var secondaryTdsId = component.get("v.newProcedureForm.Secondary_TDS_Present__c");
            var otherQualifiedSrmId = component.get("v.newProcedureForm.Other_Qualified_SRM_Present__c");
            var adId = component.get("v.newProcedureForm.AD_Present__c");
            
            var otherInformation = component.get("v.OtherInformation");
            var newProcedureForm = component.get("v.newProcedureForm");
            var vendorCredentailCompany = component.get("v.vendorCredentailCompany");
            
            var action = component.get("c.createProcedureAppointment");
            
            var eventId;

            var dmlAction = 'CREATE';
          
            var self = this;
            action.setParams({
                newProcedureForm : newProcedureForm,
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

            
                alert("Insert Schedule and Insert Procedure State = [" + state + "]");

                if(state == 'SUCCESS'){
                    alert("Procedure Form and Schedule Successfully Saved");
                }
                else{
                    alert("Procedure Form and Scheduled NOT Saved - Contact Administrator for Help");
                }
                //var x = component.get("v.eventId1");
                var x = component.get("v.newProcedureForm.Account__c");
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
    
  */  
    
    
    resetEndTime: function(component, event, helper){
        var startTime = component.get("v.startTime");
        component.set("v.newProcedureForm.Event_Local_Start_Time__c", startTime);
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

        }    
    },

    
    
    updateAccount: function(component, event, helper) {
            // Create the new expense
            var selectedAccount = component.get("v.selectedAccount");
            component.set('v.newProcedureForm.Account__c', selectedAccount); 
     
        	var procDt = component.find("proceduredate").get("v.value");
       		var patientid = component.get("v.newProcedureForm.Patient_Id__c");

        
	    	var siteName = component.get("v.selectedAccount");
        	var action = component.get("c.getSiteName");
        	var retVal;
            action.setParams({
                "acctId": component.get("v.selectedAccount")
            });
     
        	var self = this;
            action.setCallback(this, function(actionResult) {
                retVal = procDt + " : " + actionResult.getReturnValue() + " : " + patientid;
                retVal = retVal.substring(0,79);
                component.set('v.newProcedureForm.Name', retVal);
            });
            $A.enqueueAction(action);
    },
    



    onPreCaseIdEntry: function(component, event, helper){
        var preCaseId = component.get("v.preCaseId");
       
        var n = 0;
        if(preCaseId != null){
            var n = preCaseId.length;
        }
        var nullVal;

        var noPreCaseId = component.get("v.newProcedureForm.No_Pre_Case_Id__c");


        if(preCaseId != "SRM-" && preCaseId != "" && preCaseId != null){
            if(n < 12){
                component.set("v.disNoPreCaseId", false);
                component.set("v.disPreCaseId", false);
                component.set("v.newProcedureForm.Pre_Case_Id__c", nullVal);
            }
            else{
                component.set("v.disNoPreCaseId", true);
                component.set("v.disPreCaseId", false);
                component.set("v.newProcedureForm.Pre_Case_Id__c", preCaseId);
            }    
        }
        else if(noPreCaseId){
            component.set("v.preCaseId", "SRM-");
            component.set("v.noProcedureForm.Pre_Case_Id__c", nullVal);
            component.set("v.disNoPreCaseId", false);
            component.set("v.disPreCaseId", true);
        }
        else{
            component.set("v.disNoPreCaseId", false);
            component.set("v.disPreCaseId", false);
        }    
    },


    clickNoPreCaseId: function(component, event, helper){
        var selectedCk = component.get("v.newProcedureForm.No_Pre_Case_Id__c");
        var nullVal;
       
        if(selectedCk){
            component.set("v.disNoPreCaseId", false);
            component.set("v.preCaseId", "SRM-");
            component.set("v.newProcedureForm.Pre_Case_Id__c", nullVal)
            component.set("v.disPreCaseId", true);
        }
        else{
                component.set("v.disNoPreCaseId", false);
                component.set("v.disPreCaseId", false);
        }
    },




    
    updateSrmProctor: function(component, event, helper){
        var selectedSRMProctor = component.get("v.selectedSRMProctor");
        
        component.set('v.newProcedureForm.SRM_Proctor__c', selectedSRMProctor);
    },
    
    
        
    updatePrimaryPhysicianOperator: function(component, event, helper){
        var primaryPhysicianOperator = component.get("v.selectedPrimaryPhysicianOperator");
        component.set('v.newProcedureForm.Physician_Primary_Operator__c', primaryPhysicianOperator);
    },
    
    
    updateStenter: function(component, event, helper){
        var selectedStenter = component.get("v.selectedStenter");
        component.set('v.newProcedureForm.Stenter__c', selectedStenter);
    },

    
    updateCutdown: function(component, event, helper){
        var selectedCutdown = component.get("v.selectedCutdown");
        //alert("CutdownNps Physician = " + selectedCutdown);
        component.set('v.newProcedureForm.Cutdown_Physician__c', selectedCutdown);
    },
    
    
    
    
    
    updateAMUser: function(component, event, helper) {
        
		var selectedAMUser = component.get("v.amUser");
        var nullId = component.get("v.nullId");
        
        if(selectedAMUser == "none"){
            component.set('v.newProcedureForm.AM_Present__c', nullId);
        }
        else{
            component.set('v.newProcedureForm.AM_Present__c', selectedAMUser);
        }
        
        var x = component.get("v.newProcedureForm.AM_Present__c");
        
    	helper.disableNoSrm(component);
    },




    
    updateTDSUser: function(component, event, helper) {
		var selectedTDSUser = component.get("v.tdsUser");
        var nullId = component.get("v.nullId");
        
        if(selectedTDSUser == "none"){
            component.set('v.newProcedureForm.TDS_Present__c', nullId);
        }
        else{
            component.set('v.newProcedureForm.TDS_Present__c', selectedTDSUser);
        }
        
        helper.disableNoSrm(component);
      	helper.getTDSUsers2(component);
    },
    
    
    
    
    
    
    updateTDSUser2: function(component, event, helper) {
        var selectedTDSUser = component.get("v.tdsUser2");
        var nullId = component.get("v.nullId");

        if(selectedTDSUser == "none"){
            component.set('v.newProcedureForm.Secondary_TDS_Present__c', nullId);
        }
        else{
            component.set('v.newProcedureForm.Secondary_TDS_Present__c', selectedTDSUser);
        }  
    },
    
    
    
    updateADUser: function(component, event, helper) {
        var selectedADUser = component.get("v.adUser");
        var nullId = component.get("v.nullId");
        
        if(selectedADUser == "none" || selectedADUser == null){
            component.set('v.newProcedureForm.AD_Present__c', nullId);
        }
        else{
            component.set('v.newProcedureForm.AD_Present__c', selectedADUser);
        }
        	helper.disableNoSrm(component);
    },
    
    
    
    
    updateQualUser: function(component, event, helper) {
            var selectedQualUser = component.get("v.qualUser");
            var nullId = component.get("v.nullId");

            if(selectedQualUser == "none" || selectedQualUser == null){
                component.set("v.newProcedureForm.Other_Qualified_SRM_Present__c", nullId);
            }
            else{
                component.set("v.newProcedureForm.Other_Qualified_SRM_Present__c", selectedQualUser);
            }

        	helper.disableNoSrm(component);
    },
    
    
    updateProcedureName: function(component, event, helper){
        var procDt = component.find("proceduredate").get("v.value");
        var procNm = component.find("procedurename");
        
      
        var siteName = component.get("v.selectedAccountName");
        
       // alert('SelectedAcct Name (Controller) = ' + siteName);

        procNm.set("v.value", procDt + " : " + siteName);
        
        var acctId = component.get("v.selectedAccount");
      //  alert('AccountName is:' + acctId);
        
        var action = component.get("c.getSiteName");
        
        action.setParams({
            "acctId": component.get("v.selectedAccount")
        });
                
    	var self = this;
    	action.setCallback(this, function(actionResult) {
            //alert('return value = ' + actionResult.getReturnValue());
     		component.set('v.selectedAccountName', actionResult.getReturnValue());
            var procName = component.find("procedurename");
            procName.set("v.value", procName);
        });
        $A.enqueueAction(action);
    },
    
    
    
    onProcType: function(component, event) {
        
        
        var proceduretype = component.find("proceduretype").get("v.value");
        component.set("v.newProcedureForm.Procedure_Type__c", proceduretype); 
        
        
        var completion = component.get("v.newProcedureForm.Procedure_Completion__c");
        
        var renderBottom1 = component.get("v.noRenderBottom");
        
        var renderBottom;
        
    
        
        if(renderBottom1 == false){
            renderBottom = true;
        }
        else{
            renderBottom = false;
        }
        
        if(completion != "Scheduled" && completion != ""){
        
            var selected = event.getSource().get("v.value");
            
            
            if(renderBottom == true && completion != "Procedure Turned Down"){
                var anaNone = component.find("anaNone").get("v.checked");
                var clinLaryn = component.find("anaLaryn");
                var anaSpin = component.find("anaSpin");
                var clinDiab = component.find("clinDiab");
                var clinHeart = component.find("clinHeart");
                var clinSurg = component.find("clinSurg");
                var clinStress = component.find("clinStress");
            }
            
            
            
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
            if(selected == 'ROADSTER 2' && renderBottom == true){
            	component.get("v.newProcedureForm.HRC_ANA_LARYN__c").set("v.value", false);
                component.get("v.newProcedureForm.HRC_ANA_SPIN__c").set("v.value", false);
                component.get("v.newProcedureForm.HRC_CLN_DIAB__c").set("v.value", false);
                component.get("v.newProcedureForm.HRC_CLN_SURG__c").set("v.value", false);
                component.get("v.newProcedureForm.HRC_CLN_HEART__c").set("v.value", false);
                component.get("v.newProcedureForm.HRC_CLN_STRESS__c").set("v.value", false);
                
            }    
        }
      
     },





    
     onGender: function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.newProcedureForm.Patient_Gender__c", selected1);
     },
    
     onCompl: function(component, event, helper) {
        var selected =  component.get("v.newProcedureForm.Procedure_Completion__c");
       
        component.set("v.newProcedureForm.Status__c", selected);
        var nullval = null;

        if(selected == "Scheduled" ){
            component.set("v.newProcedureForm.Event_Attached__c", true);
            component.set("v.newProcedureForm.Reason_for_Procedure_Turn_Down__c", nullval);
            component.set("v.noRenderBottom", true);
            component.set("v.noRenderScheduler", false);
            component.set("v.hideReasonForTurnDown", true);
        }
        else if(selected == "Procedure Turned Down"){
            component.set("v.newProcedureForm.Event_Attached__c", false);
            component.set("v.noRenderBottom", true);
            component.set("v.noRenderScheduler", true);
            component.set("v.hideReasonForTurnDown", false);
            component.set("v.stentorAndCutdownRequired", false);   
        }
        else{
            component.set("v.newProcedureForm.Event_Attached__c", false);
            component.set("v.noRenderBottom", false); 
            component.set("v.noRenderScheduler", true);
            component.set("v.hideReasonForTurnDown", true);

            var noSRMPres = component.get("v.newProcedureForm.No_SRM_Personnel_Present__c");

           if(noSRMPres == true){
               component.set("v.amUser_dis", true);
               component.set("v.adUser_dis", true);
               component.set("v.tdsUser_dis", true);   
               component.set("v.disableTds2", true);    
               component.set("v.qualUser_dis", true);
           }
           
            var amU = component.get("v.amUser");
            var tdsU = component.get("v.tdsUser");
            var tdsU2 = component.get("v.tdsUser2"); 
            var qualU = component.get("v.qualUser");
            var adU = component.get("v.adUser");
            
            helper.getTDSUsers2(component);
            helper.disableNoSrm(component);         

           if(amU != null && amU != "" && amU != "none"){ component.set("v.newProcedureForm.AM_Present__c", amU);}
           if(tdsU != null && tdsU != "" && tdsU != "none"){ component.set("v.newProcedureForm.TDS_Present__c", tdsU);}
           if(tdsU2 != null && tdsU2 != "" && tdsU2 != "none"){ component.set("v.newProcedureForm.Secondary_TDS_Present__c", tdsU2);}
           if(qualU != null && qualU != "" && qualU != "none"){ component.set("v.newProcedureForm.Other_Qualified_SRM_Present__c", qualU);}
           if(adU != null && adU != "" && adU != "none"){ component.set("v.newProcedureForm.AD_Present__c", adU);}

        }
        
        if( selected == "Converted to CEA" || selected == "Converted to TF-CAS" || selected == "Aborted" || selected == "Cancelled/Rescheduled" ){
            component.set("v.reasonForAbort_dis", false);
            component.set("v.stentorAndCutdownRequired", true); 
        }
        else {

            var noRenderScheduler = component.get("v.noRenderScheduler");
            if(!noRenderScheduler){	
                component.set("v.newProcedureForm.Event_Attached__c", true); 
                component.set("v.reasonForAbort_dis", true);
                component.set("v.stentorAndCutdownRequired", true);
            }   
        }
    },






             
    onSympt: function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.newProcedureForm.Symptomatic__c", selected1);
     },
   
    
    onConvertToGA: function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.newProcedureForm.Converted_to_GA__c", selected1);
     },
    
     onAtropene: function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.newProcedureForm.Atropene__c", selected1);
     },
    
     onGlyccopyrrolate: function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.newProcedureForm.Glyccopyrrolate__c", selected1);
     },
    
    onAtropineGlyuco: function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.newProcedureForm.Atropine_Glyuco__c", selected1);
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
         component.set("v.newProcedureForm.MPK_Size__c", selected1);
     },
    
    onMpkDial:  function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.newProcedureForm.MPK_Dialator__c", selected1);
     },

    
    onArtSheathAccess:  function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.newProcedureForm.Arterial_Sheath_Access__c", selected1);
     },
    
    
    onWireTechnique:  function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.newProcedureForm.Wire_Technique__c", selected1);
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
         var selected = event.getSource().get("v.value");
         var postDilOtherSize = component.find("postDilOtherSize");

        if(selected == "Other Size"){
            postDilOtherSize.set("v.disabled", false); 
        }
        else{
            postDilOtherSize.set("v.value", "");
            postDilOtherSize.set("v.disabled", true);
        }
     },
    
    onInterventionalTools:  function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.newProcedureForm.Use_of_Interventional_Tools__c", selected1);
     },
    
    onNumberOfStents:  function(component, event) {
         var selected = event.getSource().get("v.value");
	 	 
         var s1type0 = component.find("s1type0");
         var s1size0 = component.find("s1size0");
        
	     // SET DEPLOYMENT AND REMOVAL PARAMS
         var edeploy0 = component.find("edeploy0");
         var eremove0 = component.find("eremove0");
         var enroutestentdeployment = component.find("enroutestentdeployment");
         var enroutestentremoval = component.find("enroutestentremoval");
        
         var selectstint1type = component.find("selectstint1type");
         var otherstint1type = component.find("otherstint1type");
         var selectstint1size = component.find("selectstint1size");
         var stint1lotno = component.find("stint1lotno");

        
         var s2type0 = component.find("s2type0");
         var s2size0 = component.find("s2size0");
        
         var selectstint2type = component.find("selectstint2type");
         var otherstint2type = component.find("otherstint2type");
         var selectstint2sz = component.find("selectstint2sz");
         var stint2lotno = component.find("stint2lotno");
         
         var disabled = "- DISABLED -";
         var noneSel = "- None Selected -";
         var defaultChoice = "SRM ENROUTE";
        
       //alert("Number of Stents Used = " + selected);
        if(selected == "1"){
            s2type0.set("v.label" , disabled);
            s2size0.set("v.label" , disabled);
                                 
            selectstint2type.set("v.disabled" , true);
            selectstint2type.set("v.value" , disabled);
            selectstint2sz.set("v.disabled" , true);
            otherstint2type.set("v.value", "");
            otherstint2type.set("v.disabled", true);
            stint2lotno.set("v.disabled", true);
            
            s1type0.set("v.label" , noneSel);
            s1size0.set("v.label" , noneSel);
            selectstint1type.set("v.disabled" , false);
            selectstint1type.set("v.value" , defaultChoice);
            selectstint1size.set("v.disabled" , false);
            otherstint1type.set("v.disabled", true);
            stint1lotno.set("v.disabled", false);
                       
            edeploy0.set("v.label", noneSel);
            eremove0.set("v.label", noneSel);
            enroutestentdeployment.set("v.disabled", false);
            enroutestentremoval.set("v.disabled", false);
        }
        else if(selected == "None"){
            s2type0.set("v.label" , disabled);
            s2size0.set("v.label" , disabled);

            selectstint2type.set("v.disabled" , true);
            selectstint2type.set("v.value" , disabled);
            selectstint2sz.set("v.disabled" , true);
            otherstint2type.set("v.value", disabled);
            otherstint2type.set("v.disabled", true);
            stint2lotno.set("v.disabled", true);
            
            s1type0.set("v.label" , disabled);
            s1size0.set("v.label" , disabled);
            selectstint1type.set("v.disabled" , true);
            selectstint1type.set("v.value" , disabled);
            selectstint1size.set("v.disabled" , true);
            otherstint1type.set("v.value", "");
            otherstint1type.set("v.disabled", true);
            stint1lotno.set("v.disabled", true);
              
            edeploy0.set("v.label", disabled);
            eremove0.set("v.label", disabled);
            enroutestentdeployment.set("v.disabled", true);
            enroutestentremoval.set("v.disabled", true);
        }
        else if(selected == "- None Selected -" || selected == ""){
            s2type0.set("v.label" , disabled);
            s2size0.set("v.label" , disabled);
            selectstint2type.set("v.disabled" , true);
            selectstint2type.set("v.value" , disabled);
            selectstint2sz.set("v.disabled" , true);
            otherstint2type.set("v.value", disabled);
            otherstint2type.set("v.disabled", true);
            stint2lotno.set("v.disabled", true);
            
            s1type0.set("v.label" , disabled);
            s1size0.set("v.label" , disabled);
            selectstint1type.set("v.disabled" , true);
            selectstint1type.set("v.value" , disabled);
            selectstint1size.set("v.disabled" , true);
            otherstint1type.set("v.value", "");
            otherstint1type.set("v.disabled", true);
            stint1lotno.set("v.disabled", true);
                                    
            edeploy0.set("v.label", noneSel);
            eremove0.set("v.label", noneSel);
            enroutestentdeployment.set("v.disabled", false);
            enroutestentremoval.set("v.disabled", false);
        }
        else if(selected == "2"){
            s1type0.set("v.label" , noneSel);
            s1size0.set("v.label" , noneSel);
            
            s2type0.set("v.label" , noneSel);
            s2size0.set("v.label" , noneSel);
            
            selectstint1type.set("v.disabled" , false);
            selectstint1type.set("v.value" , defaultChoice);
            selectstint1size.set("v.disabled" , false);
            otherstint1type.set("v.value", "");
            otherstint1type.set("v.disabled", true);
            stint1lotno.set("v.disabled", false);
            
            selectstint2type.set("v.disabled" , false);
            selectstint2type.set("v.value" , defaultChoice);
            selectstint2sz.set("v.disabled" , false);
            otherstint2type.set("v.value", "");
            otherstint2type.set("v.disabled", true);
            stint2lotno.set("v.disabled", false);
                 
            edeploy0.set("v.label", noneSel);
            eremove0.set("v.label", noneSel);
            enroutestentdeployment.set("v.disabled", false);
            enroutestentremoval.set("v.disabled", false);

            }
     },
 
    
    onguidewire: function(component, event) {
         var selected = event.getSource().get("v.label");
         
         var selected1 = selected.trim();
         component.set("v.newProcedureForm.Guidewire_Manufacturer__c", selected1);
         var v = component.get("v.newProcedureForm.Guidewire_Manufacturer__c");
        
       // alert("value v = " + v);
        
         var otherguidewire = component.find("otherguidewire");
         if(selected1 == 'Other'){
     		otherguidewire.set("v.disabled", false);
         }
         else{
             otherguidewire.set("v.disabled", true);
             otherguidewire.set("v.value", "");
         }
     },

    onStint1Type:  function(component, event) {
         var selected = event.getSource().get("v.value");
         var otherStint1 = component.find("otherstint1type")
         component.set("v.newProcedureForm.Stent_1_Type__c", selected);
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
         component.set("v.newProcedureForm.Stent_2_Type__c", selected);
        if(selected == "Other"){
            otherStint2.set("v.disabled", false); 
        }
        else{
            otherStint2.set("v.value", "");
            otherStint2.set("v.disabled", true);
        }
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
    
    onNpsVersion:  function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         component.set("v.newProcedureForm.NPS_Version__c", selected1);
     },  
    
    onstint2size:  function(component, event) {
         var selected = event.getSource().get("v.value");
         component.set("v.newProcedureForm.Stint_2_Size__c", selected);
     }, 
    
    onNpsLotNumber:  function(component, event) {
         var selected = event.getSource().get("v.value");
         component.set("v.newProcedureForm.NPS_Lot_No__c", selected);
     }, 


	onFilterPhoto:  function(component, event) {
         var selected = event.getSource().get("v.label");
         var selected1 = selected.trim();
         if(selected1 == "Yes"){
         	component.set("v.newProcedureForm.Filter_Photo_Taken__c", true);
         } 
        else {
            component.set("v.newProcedureForm.Filter_Photo_Taken__c", false);
        }
     },      
    
    disableANAOthers: function(component, event) {
        var selectedCk = event.getSource().get("v.checked");
        
        var proceduretype = component.find("proceduretype").get("v.value");
        var isROADSTER2 = false;
        if(proceduretype == "ROADSTER 2" || proceduretype == "ROADSTER 2 DW-MRI"){
            isROADSTER2 = true;
        }
        
        var anaCadCk = component.find("anaCad").get("v.checked");
        var anaBilaCk = component.find("anaBila").get("v.checked");
        var anaCeaCk = component.find("anaCea").get("v.checked");
        var anaContCk = component.find("anaCont").get("v.checked");
        var anaHighCk = component.find("anaHigh").get("v.checked");
        var anaHostCk = component.find("anaHost").get("v.checked");
        var anaLarynCk = component.find("anaLaryn").get("v.checked");
        var anaSpinCk = component.find("anaSpin").get("v.checked");
        var anaTandCk = component.find("anaTand").get("v.checked");
        
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
        
        component.set("v.newProcedureForm.HRC_ANA_CAD__c", anaCadCk);
        component.set("v.newProcedureForm.HRC_ANA_NONE__c", selectedCk);
        component.set("v.newProcedureForm.HRC_ANA_TAND__c", anaTandCk);
        component.set("v.newProcedureForm.HRC_ANA_SPIN__c", anaSpinCk);
        component.set("v.newProcedureForm.HRC_ANA_LARYN__c", anaLarynCk);
        component.set("v.newProcedureForm.HRC_ANA_HOST__c", anaHostCk);
        component.set("v.newProcedureForm.HRC_ANA_HIGH__c", anaHighCk);
        component.set("v.newProcedureForm.HRC_ANA_CONT__c", anaContCk);
        component.set("v.newProcedureForm.HRC_ANA_CEA__c", anaCeaCk);
        component.set("v.newProcedureForm.HRC_ANA_BILA__c", anaBilaCk);      
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
            
            
            anaNone.set("v.disabled", true);
        }
        else {
            anaNone.set("v.disabled", false);
        }
        component.set("v.newProcedureForm.HRC_ANA_CAD__c", anaCad);
        component.set("v.newProcedureForm.HRC_ANA_NONE__c", anaNoneCk);
        component.set("v.newProcedureForm.HRC_ANA_TAND__c", anaTand);
        component.set("v.newProcedureForm.HRC_ANA_SPIN__c", anaSpin);
        component.set("v.newProcedureForm.HRC_ANA_LARYN__c", anaLaryn);
        component.set("v.newProcedureForm.HRC_ANA_HOST__c", anaHost);
        component.set("v.newProcedureForm.HRC_ANA_HIGH__c", anaHigh);
        component.set("v.newProcedureForm.HRC_ANA_CONT__c", anaCont);
        component.set("v.newProcedureForm.HRC_ANA_CEA__c", anaCea);
        component.set("v.newProcedureForm.HRC_ANA_BILA__c", anaBila);
        
        component.set("v.newProcedureForm.HRC_CLN_AGE__c", clinAge);
       	component.set("v.newProcedureForm.HRC_CLN_ANG__c", clinAng);
        component.set("v.newProcedureForm.HRC_CLN_CCS__c", clinCcs);
        component.set("v.newProcedureForm.HRC_CLN_CHF__c", clinChf);
        component.set("v.newProcedureForm.HRC_CLN_CNI__c", clinCni);
        component.set("v.newProcedureForm.HRC_CLN_COPD__c", clinCopd);
        component.set("v.newProcedureForm.HRC_CLN_DIAB__c", clinDiab);
        component.set("v.newProcedureForm.HRC_CLN_HEART__c", clinHeart);
        component.set("v.newProcedureForm.HRC_CLN_LVEF__c", clinLvef);
        component.set("v.newProcedureForm.HRC_CLN_MI__c", clinMi);
        component.set("v.newProcedureForm.HRC_CLN_RENA__c", clinRena);
        component.set("v.newProcedureForm.HRC_CLN_STRESS__c", clinStress);
        component.set("v.newProcedureForm.HRC_CLN_SURG__c", clinSurg);
    },

    
	disableUsersPres: function(component, event, helper) {

        var selected = event.getSource().get("v.checked");
        
        var nullId = component.get("v.nullId");
        
        if(selected == true ){
            
            helper.getDisUsers(component);
            component.set("v.amUser_dis", true);
            component.set("v.tdsUser_dis", true);
            component.set("v.disableTds2", true);
            component.set("v.adUser_dis", true);
            component.set("v.qualUser_dis", true);
            
            
            component.set("v.amUser", null);
            component.set("v.tdsUser", null);
            component.set("v.tdsUser2", null);
            component.set("v.adUser", null);
            component.set("v.qualUser", null);

            component.set("v.newProcedureForm.AD_Present__c", nullId);
            component.set("v.newProcedureForm.AM_Present__c", nullId);
            component.set("v.newProcedureForm.TDS_Present__c", nullId);
            component.set("v.newProcedureForm.Secondar_TDS_Present__c", nullId);
            component.set("v.newProcedureForm.Other_Qualified_SRM_Present__c", nullId);

            component.set("v.noSRM", true);
        
        	
        }
        else {
            helper.getAMUsers(component);
        	helper.getTDSUsers(component);
            helper.getTDSUsers2(component);
        	helper.getADUsers(component);
        	helper.getQualUsers(component);
            
            component.set("v.amUser_dis", false);
            component.set("v.tdsUser_dis", false);
            component.set("v.disableTds2", false);
            component.set("v.adUser_dis", false);
            component.set("v.qualUser_dis", false);

            component.set("v.noSRM", false);
        }

        
        component.set("v.newProcedureForm.No_SRM_Personnel_Present__c", selected);
        helper.getTDSUsers2(component);
        
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
               
            	component.set("v.newProcedureForm.SkinToSkinTimeTxt__c", timeText);
            	var numberofMinutes = Number(hr) * 60 +  Number(mn) + Number(ss) / 60;
            	component.set("v.newProcedureForm.Skin_to_Skin_Time__c", numberofMinutes);
                
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
               // alert('hr = [' + hr + '] mn = [' + mn + '] ss = [' + ss + ']');
                timeText = hrT + ':' + mnT + ':' + ssT;
               
            	component.set("v.newProcedureForm.ReverseFlowTimeTxt__c", timeText);
            	var numberofMinutes = Number(hr) * 60 +  Number(mn) + Number(ss) / 60;
            	component.set("v.newProcedureForm.Reverse_Flow_Time__c", numberofMinutes);
                
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
            	component.set("v.newProcedureForm.FluoroTimeMinutesTxt__c", timeText);
            	var numberofMinutes = Number(hr) * 60 +  Number(mn) + Number(ss) / 60;
            	component.set("v.newProcedureForm.Fluoro_Time_minutes__c", numberofMinutes);
            
            }
            
        }
        var reportTime = component.get("v.ftStatedTime");
        component.set("v.ftStatedTime", timeText);   
    },











    changeAddlPhys1: function(component, event, helper) {
        var physId = component.find("addlPhys1").get("v.value");
        var accountId = component.get("v.recordId");

        if(physId != null && physId != ""){
            component.set("v.newProcedureForm.Additional_Physician_1__c", physId);

            var action = component.get("c.getPhysicianRecord");

            action.setParams({
                    physId: physId
                    
                });
            var self = this;
            action.setCallback(this, function(actionResult) {

                var phys1Name = actionResult.getReturnValue().Name;
                var phys1Fellow = actionResult.getReturnValue().Fellow__c;

                component.find('fellow1').set("v.checked", phys1Fellow);
                component.set("v.newProcedureForm.Additional_Physician_Fellow__c", phys1Fellow);

            });
            
            $A.enqueueAction(action);
        }
        else{
            component.find('fellow1').set("v.checked", false);
            component.set("v.newProcedureForm.Additional_Physician_Fellow__c", false);
        }
    },








    changeAddlPhys2: function(component, event, helper) {
        var physId = component.find("addlPhys2").get("v.value");
        var accountId = component.get("v.recordId");

        if(physId != null && physId != ""){
            component.set("v.newProcedureForm.Additional_Physician_2__c", physId);

            var action = component.get("c.getPhysicianRecord");

            action.setParams({
                    physId: physId
                    
                });
            var self = this;
            action.setCallback(this, function(actionResult) {

                var phys1Name = actionResult.getReturnValue().Name;
                var phys1Fellow = actionResult.getReturnValue().Fellow__c;

                component.find('fellow2').set("v.checked", phys1Fellow);
                component.set("v.newProcedureForm.Additional_Physician_2_Fellow__c", phys1Fellow);

            });
            
            $A.enqueueAction(action);
        }
        else{
            component.find('fellow2').set("v.checked", false);
            component.set("v.newProcedureForm.Additional_Physician_2_Fellow__c", false);
        }
    },

    





    updateFellow2: function(component, event, helper) {
        var fellow2 = component.find("fellow2").get("v.checked");
        component.set("v.newProcedureForm.Additional_Physician_2_Fellow__c", fellow2);
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

       // alert("I got this far");
        //alert("Fellow Value = [" + fellow + "]");
        
                
        var action = component.get("c.createNewContact");
        

        var accountId = component.get('v.recordId');

        
             
        
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
                    
                    //component.set("v.newOpportunityId", response.getReturnValue());
                    //var iid = component.get("v.newOpportunityId");
                    
                    
                    //$A.get('e.force:refreshView').fire();
                    
                    
                    
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