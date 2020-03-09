({
	getTransResult : function(component) {
		var locationID = component.get('v.LocationID');
		var lotno = component.get('v.LotNo');
        var TranReason = component.get('v.TranReason');

		if( (locationID !== null & locationID !== '' & locationID !== ' ') 
			|| (lotno !== null & lotno !== '' & lotno !== ' ')
            || (TranReason !== null & TranReason !=='' & TranReason !==' ')){

            component.set('v.waitingState', true);            
            var listLocationID = this.addIQMSlocationID(locationID);       
			var action = component.get('c.getTransactionsResult');
	        action.setParams({
	            "locationID": listLocationID,
	            "lotno": lotno,
                "TranReason": TranReason
	        });
	        var self = this;
	        action.setCallback(this, function(actionResult) {
	            var result = actionResult.getReturnValue();
	            component.set('v.ListTransactionResult', actionResult.getReturnValue());
                component.set('v.waitingState', false);
	        });
	        $A.enqueueAction(action);
	    }
    },

    saveTran : function(component) {
        var ListTransactionResult = component.get('v.ListTransactionResult');

        var action = component.get('c.updateTransaction');
        action.setParams({
            "transactions": ListTransactionResult,
        });

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") 
            {
                alert("All transactions have been updated successful.");
            }else
            {
                alert("Sorry fail to update transactions. Please take a screenshot of updated transactions and send it to SFDC administration.");
            }
        });
        $A.enqueueAction(action);
    },

    addIQMSlocationID : function(locationID)
    {
        var listLocationID = [locationID];

        switch(locationID)
        {
            case 'SRM00334': listLocationID.push('TS-JADAMS'); break;
            case 'SRM00215': listLocationID.push('TS-TID006-RBARR'); break;
            case 'SRM00201': listLocationID.push('TS-MCHANG'); break;
            case 'SRM00307': listLocationID.push('TS-GCHASE'); break;
            case 'SRM00260': listLocationID.push('TS-TID009-DCLARKE'); break;
            case 'SRM00281': listLocationID.push('TS-CCODA'); break;
            case 'SRM00292': listLocationID.push('TS-JCOSTON'); break;
            case 'SRM00267': listLocationID.push('TS-JCOTICCHIO'); break;
            case 'SRM00213': listLocationID.push('TS-TID008-CCUNNINGHAM'); break;
            case 'SRM00177': listLocationID.push('TS-TID014-SCURTIS'); break;
            case 'SRM00269': listLocationID.push('TS-ALEXANDRADAVIS'); break;
            case 'SRM00163': listLocationID.push('TS-VP-ADAVIS'); break;
            case 'SRM00288': listLocationID.push('TS-SDUPRE'); break;
            case 'SRM00217': listLocationID.push('TS-TDS-NELICKER'); break;
            case '60': listLocationID.push('FG-PASTORIA'); listLocationID.push('FG'); listLocationID.push('FG2'); listLocationID.push('STORES-INNSBRUCK'); break;
            case 'SRM00227': listLocationID.push('TS-JFRANK'); break;
            case 'SRM00199': listLocationID.push('TS-TDS-KGARNER'); break;
            case 'SRM00303': listLocationID.push('TS-HGEX'); break;
            case 'SRM00243': listLocationID.push('TS-GHANDY'); break;
            case 'SRM00251': listLocationID.push('TS-MGREENLOWE'); break;
            //case 'SRM00333': listLocationID.push(''); break;
            case 'SRM00212': listLocationID.push('TS-TID010-JHAYNIE'); break;
            case 'SRM00233': listLocationID.push('TS-TDS-RHILI'); listLocationID.push('TS-TDS-RGERBER'); break;
            case 'SRM00304': listLocationID.push('TS-BHOLEXA'); break;
            case 'SRM00186': listLocationID.push('TS-TDS-KHYMAN'); break;
            case 'SRM00211': listLocationID.push('TS-TID011-DJENKS'); break;
            case 'SRM00296': listLocationID.push('TS-TID007-WKIMBELL'); break;
            case 'SRM00231': listLocationID.push('TS-JKIMBER'); break;
            case 'SRM00294': listLocationID.push('TS-CKOLB'); break;
            case 'SRM00250': listLocationID.push('TS-SKRICK'); break;
            case 'SRM00228': listLocationID.push('TS-TID001-PLIBERO'); break;
            case 'SRM00311': listLocationID.push('TS-JLINDSEY'); break;
            case 'SRM00202': listLocationID.push('TS-TDS-JLOPEZ'); break;
            case 'SRM00309': listLocationID.push('TS-JMATTEO'); break;
            case 'SRM00214': listLocationID.push('TS-TID012-BMCDANIEL'); break;
            case 'SRM00283': listLocationID.push('TS-EMCINROY'); break;
            case 'SRM00301': listLocationID.push('TS-JMCKENZIE'); break;
            case 'SRM00273': listLocationID.push('TS-DMILLER'); break;
            case 'SRM00209': listLocationID.push('TS-TDS-FMOORE'); break;
            case 'SRM00249': listLocationID.push('TS-JPAGE'); break;
            case 'SRM00154': listLocationID.push('TS-VP-MPAGE'); break;
            case '40': listLocationID.push('PENDING PO'); break;
            case 'SRM00286': listLocationID.push('TS-MQUINN'); break;
            case 'SRM00216': listLocationID.push('TS-TID015-KRAMSEY'); break;
            case 'SRM00168': listLocationID.push('TS-TID004-DRUST'); break;
            case 'SRM00285': listLocationID.push('TS-MSANDERS'); break;
            case 'SRM00229': listLocationID.push('TS-TID003-PSCAMARDI'); break;
            case 'SRM00282': listLocationID.push('TS-SSISCO'); break;
            case 'SRM00224': listLocationID.push('TS-TDS-RSPRINGSTON'); break;
            case '50': listLocationID.push('STERILIZER'); listLocationID.push('POST-STERILE'); break;
            case '20': listLocationID.push('STORES'); break;
            case 'SRM00265': listLocationID.push('TS-JSTUPFEL'); break;
            case 'SRM00208': listLocationID.push('TS-TID013-RTIGGES'); break;
            case 'SRM00187': listLocationID.push('TS-AD-FVIANO'); break;
            case 'SRM00248': listLocationID.push('TS-RWESTENHAVER'); break;
            case 'SRM00310': listLocationID.push('TS-SWOODWARD'); break;
            case 'SRM00171': listLocationID.push('TS-AD-JWRIGHT'); break;
            case 'SRM00278': listLocationID.push('TS-SZIMMERMAN'); break;
            case 'SRM00284': listLocationID.push('TS-JZUKOWSKI'); break;
            case 'SRM00219': listLocationID.push('TS-TID002-PTRENTINI'); break;
            case 'SRM00302': listLocationID.push('TS-BDAHLE'); listLocationID.push('TS-BDAULE'); break;
        }

        return listLocationID;
    },


    convertArrayOfObjectsToCSV : function(component, data1, data2, keys, lotNo, locationID){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
       
        // check if "objectRecords" parameter is null, then return from function
        if (data1 == null || !data1.length) {
            return null;
         }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
 
        // in the keys valirable store fields API Names as a key
        // Create a title
        csvStringResult = '';
        csvStringResult += ('Location ID'+ columnDivider);
        csvStringResult += (locationID + columnDivider);
        csvStringResult += lineDivider;
        csvStringResult += ('Lot #'+ columnDivider);
        csvStringResult += (lotNo+ columnDivider);
        csvStringResult += lineDivider;
        // Create Header 
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
 
 		var skey ='';
        for(var i=0; i < data1.length; i++){   
            //Transfer Date          
            skey = 'TransferDate__c' ; 
            if(data1[i][skey] !== null && data1[i][skey] !== undefined){
             	//csvStringResult += '"'+ data1[i][skey].getMonth()+'-'+ data1[i][skey].getDate()+'-'+ data1[i][skey].getYear()+'"'; 
             	csvStringResult += '"'+ data1[i][skey].substring(0,10)+'"';              
            }
            csvStringResult += columnDivider;

            //Quantity
            skey = 'QADTranasctionID__c'; 
            if(data1[i][skey] > 0)
            {
                
                skey = 'TranQuan__c';
                if(data1[i][skey] > 0)
                {
                    csvStringResult += '"'+ data1[i][skey]+'"';
                    csvStringResult += columnDivider; 
                }else
                {
                    csvStringResult += columnDivider;
                    csvStringResult += '"'+ data1[i][skey]+'"';
                }
            }else
            {
                skey = 'TranInOut__c'; 
                if(data1[i][skey] == 'IN')
                {
                    skey = 'TranQuan__c';
                    csvStringResult += '"'+ data1[i][skey]+'"';
                    csvStringResult += columnDivider; 

                }else
                {
                    skey = 'TranQuan__c';
                    csvStringResult += columnDivider; 
                    csvStringResult += '"-'+ data1[i][skey]+'"';
                }                
            }
            csvStringResult += columnDivider; 

            //On hand
            csvStringResult += '"'+ data2[i]+'"';
            csvStringResult += columnDivider;

            //Ref No
            skey = 'QADTranasctionID__c'; 
            if(data1[i][skey] > 0)
            {
                skey = 'TransReason__c';
                csvStringResult += '"'+ data1[i][skey]+'"-';
            }else
            {
                skey = 'RefNo__c';
            }
            if( data1[i][skey] !== null & data1[i][skey] !== undefined)
                csvStringResult += '"'+ data1[i][skey]+'"';
            csvStringResult += columnDivider;

            //Ship To
            skey = 'DeliveryTo__c';
            if( data1[i][skey] !== null & data1[i][skey] !== undefined)
                csvStringResult += '"'+ data1[i][skey]+'"';
            csvStringResult += columnDivider;

            //Reason
            skey = 'TransReason__c';
            csvStringResult += '"'+ data1[i][skey]+'"';

            skey = 'QADTranasctionID__c'; 
            if(data1[i][skey] > 0)
            {
                skey = 'TransType__c';
                csvStringResult += '" - '+ data1[i][skey]+'"';
            }

            csvStringResult += lineDivider;
          }// outer main for loop close 
       
       // return the CSV formate String 
        return csvStringResult;        
    },
})