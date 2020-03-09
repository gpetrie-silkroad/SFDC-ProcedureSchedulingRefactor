public with sharing class CheckPotentialErrorRecordsOnQADAndSFDC {
	@InvocableMethod(label='Check Duplicate PO# & Send notified Email' description='Check input PO# of sale order which have been entered in 2 days. Send email to CS if it found an duplicate PO#')
	public static List<QAD_Summary__c> checkDuplicatePO(List<QAD_Summary__c> QADSummary)
	{
		Id recordID = QADSummary[0].Id;

		list<Order> OrderswithduplicatePO = new list<Order>();
		list<Order> OrdersWithoutDuplicatePO = new list<Order>();

		List<QAD_Summary__c> QADExpectedError =[SELECT 
													Description__c, Id, Name, Note__c, Ref_No__c,
													Reviewed_Records__c, Title__c, Total_Number__c
												FROM 
													QAD_Summary__c 
												WHERE 
													Name LIKE '%potential%'];

		List<QAD_Summary__c> QADErrorNewLIst = new List<QAD_Summary__c>();
		for(QAD_Summary__c element : QADExpectedError)
		{
			if(element.Ref_No__c < element.Total_Number__c)
			{
				QADErrorNewLIst.add(element);
			}
			element.Ref_No__c = element.Total_Number__c;
		}
		update QADExpectedError;

//========================================================Checking Duplicate PO#===============================================================
		//Datetime dt = System.now();
		//dt = dt.addMinutes(-10);
		list<Order> newOrders =[SELECT 
									Id, IQMS_ORDER_NO__c, POForCheckingDuplicate__c, PO_Number__c, Possible_Duplicate__c
								FROM
									Order
								WHERE
									IsValidPO__c = false
									and
									(
										(
											CreatedDate >= LAST_N_DAYS:2
											and IQMS_ORDER_NO__c LIKE 'S%'
										)or
										(
											CreatedDate >= LAST_N_DAYS:60
											and (NOT POForCheckingDuplicate__c LIKE '%EVAL%')
											and (NOT POForCheckingDuplicate__c LIKE '%PEND%')
											and IQMS_ORDER_NO__c LIKE 'B%'									
										)or
										(
											Possible_Duplicate__c = true
											and CreatedDate >= LAST_N_DAYS:60
											and POForCheckingDuplicate__c LIKE '%PEND%'
											and IQMS_ORDER_NO__c LIKE 'B%'								
										)
									)
								ORDER BY 
									IQMS_ORDER_NO__c DESC NULLS FIRST
								LIMIT 500];

		if(newOrders.size() > 0)
		{
			List<String> checkingPONUmber = new List<String>();
			list<Integer> TotalPOrepeattimes = new list<Integer>();

			for(Order element : newOrders)
			{
				checkingPONUmber.add(element.POForCheckingDuplicate__c);
				TotalPOrepeattimes.add(0);
			}

			//Can't use group query for a formula field
			List<Order> OrdersWithSamePOs =[SELECT 
												Id, IQMS_ORDER_NO__c, POForCheckingDuplicate__c
											FROM
												Order
											Where
												POForCheckingDuplicate__c In :checkingPONUmber
												and (Not IQMS_ORDER_NO__c LIKE 'R%')
												and 
												(
													(Not IQMS_ORDER_NO__c LIKE 'B%')
													or
													(
														IQMS_ORDER_NO__c LIKE 'B%'
														and (Not POForCheckingDuplicate__c LIKE '%PEND%')
													)
												)
											LIMIT 1000];

			//Count repeat PO
			Integer index = 0;
			for(Order element1 : OrdersWithSamePOs)
			{
				for(index = 0; index < newOrders.size(); index++)
				{
					if(newOrders[index].POForCheckingDuplicate__c == element1.POForCheckingDuplicate__c)
					{
						TotalPOrepeattimes[index]++;
					}
				}
			}

			//Mark order have duplicate PO + add a list to sent email
			for(index = 0; index < newOrders.size(); index++)
			{
				if( (TotalPOrepeattimes[index] > 1) && newOrders[index].Possible_Duplicate__c == false)
				{
					newOrders[index].Possible_Duplicate__c = true;
					OrderswithduplicatePO.add(newOrders[index]);
				}else if( (TotalPOrepeattimes[index] < 2) && (newOrders[index].Possible_Duplicate__c == true))
				{
					newOrders[index].Possible_Duplicate__c = false;
					OrdersWithoutDuplicatePO.add(newOrders[index]);
				}
			}
		}
//=============================End of Checking Duplicate PO#===============================================================

//====================================Sending Email====================================================
		if(OrderswithduplicatePO.size() > 0 || QADErrorNewLIst.size() > 0)
		{
			//Get email adddress from Note field of the trigger records
			LiSt<String> PossibleAddresses = QADSummary[0].Note__c.split(';');
			LiSt<String> sendToAddresses = new list<String>();
			for(String element : PossibleAddresses)
			{
				element = element.trim();
				if(element.contains('@'))
					sendToAddresses.add(element);
			}
			sendAlertEmailTOCS(OrderswithduplicatePO, QADErrorNewLIst, sendToAddresses, QADSummary[0].Description__c);

			//Update the order
			update OrderswithduplicatePO;
		}

		if(OrdersWithoutDuplicatePO.size() > 0)
			update OrdersWithoutDuplicatePO;
//===============================End of Sending Email==================================================

		return QADSummary;
	}

	public static void sendAlertEmailTOCS (List<Order> orders, List<QAD_Summary__c> QADErrorNewLIst, LiSt<String> sendToAddresses, String DuplicateReportID)
	{
		Id curUserId = UserInfo.getUserId();
		User currentUser = [SELECT 
								Id, FirstName, LastName, Field_Responsibility__c,
								Profile.Name, SenderEmail, Email, MobilePhone,
								Title, Manager.email, ManagerId
							FROM
								User 
							WHERE
								Id = :curUserId];

		String inputDate = datetime.now().format();
		String subject = 'Potential Error Records on QAD/SFDC - ' + inputDate;
		Integer tableNumber = 0;

		String emailbody = '<center> =====This is an automatic email which is generated by SRM-SFDC assistant.===== </center><br/>';
		emailbody += '<div style = "text-align: left; width: 100%">';
		emailbody += 'Dear Customer Success Team,<br/><br/>';
		emailbody += 'I found (a) new potential error QAD record(s). Please review the record(s) when you have time.<br/><br/>';	

		if(orders.size() > 0)
		{
			tableNumber++;
			emailbody += '<b>Table 1: The list of orders which maybe have duplicate POs</b><br/>';
			emailbody += '<table style = "border-collapse:collapse;"><tr>';
			emailbody += '<th style = "border: 1px solid black; padding: 5px"> Original PO# </th>';
			emailbody += '<th style = "border: 1px solid black; padding: 5px"> Checking PO# </th>';
			emailbody += '<th style = "border: 1px solid black; padding: 5px"> SO#</th>';
			emailbody += '<th style = "border: 1px solid black; padding: 5px"> SFDC Link </th></tr>';
			for(Order element : orders)
			{
				emailbody += '<tr><td style = "border: 1px solid black; vertical-align:top; padding: 5px"> ' + element.PO_Number__c + ' </td>';
				emailbody += '<td style = "border: 1px solid black; vertical-align:top; padding: 5px"> ' + element.POForCheckingDuplicate__c + ' </td>';
				emailbody += '<td style = "border: 1px solid black; vertical-align:top; padding: 5px"> ' + element.IQMS_ORDER_NO__c + ' </td>';
				emailbody += '<td style = "border: 1px solid black; vertical-align:top; padding: 5px"> ';
				emailbody += '<a href="https://silkroadmed.lightning.force.com/' + element.Id + '"> SFDC Link for ' + element.IQMS_ORDER_NO__c + '</a> </td></tr>';
			}
			emailbody += '</table>';
			emailbody += 'If these orders are not duplicate, please mark the orders are valid on SFDC to exclude them on the duplicate PO report<br/>';         
        	emailbody += '<a href="https://silkroadmed.lightning.force.com/lightning/r/Report/'+DuplicateReportID+'/view?queryScope=userFolders"> SFDC Potential Duplicate PO Orders Report</a><br/><br/>';
		}

		if(QADErrorNewLIst.size() > 0)
		{
			tableNumber++;
			emailbody += '<b>Table ' + String.valueOf(tableNumber) + ': The list of QAD Records which have potential errors.</b><br/>';
			emailbody += '<table style = "border-collapse:collapse;"><tr><th style = "border: 1px solid black; padding: 5px; size: 20%">Description</th>';
			emailbody += '<th style = "border: 1px solid black; padding: 5px; size:  10%"> Total # </th>';
			emailbody += '<th style = "border: 1px solid black; padding: 5px; size:  20%"> Records list </th>';
			emailbody += '<th style = "border: 1px solid black; padding: 5px; size:  50%"> Note </th></tr>';
			for(QAD_Summary__c element : QADErrorNewLIst)
			{
				emailbody += '<tr><td style = "border: 1px solid black; vertical-align:top; padding: 5px; size:  20%"> ' + element.Name + ' </td>';
				emailbody += '<td style = "border: 1px solid black; vertical-align:top; padding: 5px; size:  10%"> ' + String.valueOf(element.Total_Number__c) + ' </td>';
				emailbody += '<td style = "border: 1px solid black; vertical-align:top; padding: 5px; size:  20%"> ' + element.Reviewed_Records__c + ' </td>';
				emailbody += '<td style = "border: 1px solid black; vertical-align:top; padding: 5px; size:  50%"> ' + element.Note__c + ' </td></tr>';
			}
			emailbody += '</table><br/><br/>';
		}


        emailbody += 'Thanks.<br/><br/>';
        emailbody += 'SRM-SFDC assistant </div>';

    	// Step 1: Create a new Email
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();  

    	// Step 2: Set list of people who should get the email
       	mail.setToAddresses(sendToAddresses);	

    	// Step 3: Set who the email is sent from
       	mail.setReplyTo(currentUser.SenderEmail);
       	mail.setSenderDisplayName('Salesforce Administrator');

    	// Step 4. Set email contents - you can use variables!
      	mail.setSubject(subject);
      	mail.setHtmlBody(emailbody); 	

      	// Step 5. Add your email to the master list
  		mails.add(mail);

		// Step 6: Send all emails in the master list
 		Messaging.sendEmail(mails);       									
	}
}
//System.Debug('Apex Debug:' + listResult[0]);