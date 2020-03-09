public without sharing class SRM_TSAudit_ServerController {
	@AuraEnabled
	public static Trunk_Stock_Cycle_Count_Report__c getPendingTSCC(String TSCCReportId){
		Id userID = UserInfo.getUserId();

		Trunk_Stock_Cycle_Count_Report__c TSCCReport = new Trunk_Stock_Cycle_Count_Report__c();

		if(TSCCReportId == 'N/A')
		{
			Date todayDate = system.today();
			try
			{
				TSCCReport = [	SELECT 
									OwnerId, Count_Date__c, Id, Name, Name__c, Note__c, Reviewer__c, Review_Date__c, Owner_Manager_ID__c, Trunk_Stock_Cycle_Count__c,
									Status__c, Total_Inventory_Units__c, Trunk_Stock_Cycle_Count__r.End_Date__c, Completed_Percentage__c, Sent_reconciled_email__c,
									Trunk_Stock_Cycle_Count__r.Due_Date__c, Submitted__c, Total_Unit_Discrepancies__c, Total_Lot_Discrepancies__c, Location__c
								FROM 
									Trunk_Stock_Cycle_Count_Report__c 
								Where 
									OwnerID = :userID
									and Trunk_Stock_Cycle_Count__r.IsActive__c = true
								ORDER BY 
									CreatedDate DESC NULLS FIRST
								LIMIT 1];			
			}
			catch (Exception ex)
			{
				System.Debug('Apex Debug: Do not have any pending TSAudit Report');
			}			
		}else
		{
			try
			{
				if(UserInfo.getProfileId() == '00e41000001fLTqAAM' || UserInfo.getProfileId() == '00e1M000000cNBbQAM')//00e1M000000cNBbQAM: SRM Customer Success; 00e41000001fLTqAAM: System Administration
				{
					TSCCReport = [	SELECT 
										OwnerId, Count_Date__c, Id, Name, Name__c, Note__c, Reviewer__c, Review_Date__c, Completed_Percentage__c, Trunk_Stock_Cycle_Count__c,
										Status__c, Total_Inventory_Units__c, Trunk_Stock_Cycle_Count__r.End_Date__c, Total_Unit_Discrepancies__c, Sent_reconciled_email__c,
										Trunk_Stock_Cycle_Count__r.Due_Date__c, Submitted__c, Total_Lot_Discrepancies__c, Owner_Manager_ID__c, Location__c
									FROM 
										Trunk_Stock_Cycle_Count_Report__c 
									Where 
										Id = :TSCCReportId
									ORDER BY 
										CreatedDate DESC NULLS FIRST
									LIMIT 1];					
				}
				else
				{
					TSCCReport = [	SELECT 
										OwnerId, Count_Date__c, Id, Name, Name__c, Note__c, Reviewer__c, Review_Date__c, Completed_Percentage__c, Trunk_Stock_Cycle_Count__c,
										Status__c, Total_Inventory_Units__c, Trunk_Stock_Cycle_Count__r.End_Date__c, Total_Unit_Discrepancies__c, Sent_reconciled_email__c,
										Trunk_Stock_Cycle_Count__r.Due_Date__c, Submitted__c, Total_Lot_Discrepancies__c, Owner_Manager_ID__c, Location__c
									FROM 
										Trunk_Stock_Cycle_Count_Report__c 
									Where 
										OwnerID = :userID 
										and Id = :TSCCReportId
									ORDER BY
										 CreatedDate DESC NULLS FIRST
									LIMIT 1];			
				}
			}
			catch (Exception ex)
			{
				System.Debug('Apex Debug: Do not have the TSCCReport the ID - '+ TSCCReportId);
			}				
		}

		return TSCCReport;
	}

	@AuraEnabled
	public static list<Lot_Inventory__c> getLotInven(){
		Id userID = UserInfo.getUserId();

		List<Lot_Inventory__c>	lotInventory =  [select item_number__c, Lot_Expiration_Date__c,Lot_Number__c,
												    	On_Hand_Qty__c, Name, Expiring_Status__c
												 from Lot_Inventory__c
												 where On_Hand_Qty__c > 0
													  AND OwnerId = :userID
												 ORDER BY item_number__c DESC, Lot_Number__c DESC NULLS LAST];			

		return lotInventory;
	}
		
	@AuraEnabled
	public static ID createNewTSCCount(Trunk_Stock_Cycle_Count__c TSCCount)
	{
		List<Trunk_Stock_Cycle_Count__c> ActiveTSCC = [ select Id, IsActive__c
														from Trunk_Stock_Cycle_Count__c
														where IsActive__c = true
														LIMIT 50];
		for(Trunk_Stock_Cycle_Count__c element : ActiveTSCC)
		{
			element.IsActive__c = false;
			update element; 
		}
		insert TSCCount;
		return TSCCount.ID;
	}

	@AuraEnabled
	public static Trunk_Stock_Cycle_Count__c getTSCCountAudit ()
	{
		Date todayDate = system.today();
		Trunk_Stock_Cycle_Count__c TSCCount = new Trunk_Stock_Cycle_Count__c();

		TSCCount = [	SELECT 	Due_Date__c, End_Date__c, Id, Name, OwnerId, Start_Date__c, Completed_Percentage__c,
								Total_Trunk_Stock_Reports__c, Trunk_Stock_Cycle_Count_ID__c, Total_Submited_TS_Report__c
						FROM Trunk_Stock_Cycle_Count__c
						WHERE IsActive__c = true
						LIMIT 1];

		return TSCCount;
	}

	@AuraEnabled
	public static Trunk_Stock_Cycle_Count__c getTSCCountInfo (ID recordId)
	{
		Trunk_Stock_Cycle_Count__c TSCCount = [SELECT Due_Date__c, End_Date__c, Id, Name, OwnerId, Start_Date__c, Completed_Percentage__c,
													  Total_Trunk_Stock_Reports__c, Trunk_Stock_Cycle_Count_ID__c, Total_Submited_TS_Report__c
												 FROM Trunk_Stock_Cycle_Count__c
												 WHERE Id = :recordId];
		return TSCCount;
	}

	@AuraEnabled
	public static list<Trunk_Stock_Cycle_Count_Report__c> getTSCCReportInfo (ID recordId)
	{
		list<Trunk_Stock_Cycle_Count_Report__c> element = [	SELECT 	
																OwnerId, Count_Date__c, Id, Name, Name__c, Note__c, Reviewer__c, Review_Date__c, Owner_Manager_ID__c, Trunk_Stock_Cycle_Count__c,
																Status__c, Total_Inventory_Units__c, Trunk_Stock_Cycle_Count__r.End_Date__c, Completed_Percentage__c, Sent_reconciled_email__c,
																Trunk_Stock_Cycle_Count__r.Due_Date__c, Submitted__c, Total_Unit_Discrepancies__c, Total_Lot_Discrepancies__c, Location__c
												 			FROM 
															 	Trunk_Stock_Cycle_Count_Report__c
												 			WHERE 
												 				Trunk_Stock_Cycle_Count__c = :recordId
												 				and 
																(
																	Submitted__c = true
												 					or 
																	(
																		Submitted__c = false 
																		and Total_Inventory_Units__c != 0
																	)
																)
												 			Order By 
															 	Name__c ];
		return element;
	}

	@AuraEnabled
	public static list<Trunk_Stock_Cycle_Count_Report__c> getTSCCReportInfoOptional (ID recordId)
	{
		list<Trunk_Stock_Cycle_Count_Report__c> element = [	SELECT 	
																OwnerId, Count_Date__c, Id, Name, Name__c, Note__c, Reviewer__c, Review_Date__c, Owner_Manager_ID__c, Trunk_Stock_Cycle_Count__c,
																Status__c, Total_Inventory_Units__c, Trunk_Stock_Cycle_Count__r.End_Date__c, Completed_Percentage__c, Sent_reconciled_email__c,
																Trunk_Stock_Cycle_Count__r.Due_Date__c, Submitted__c, Total_Unit_Discrepancies__c, Total_Lot_Discrepancies__c, Location__c
												 			FROM 
															 	Trunk_Stock_Cycle_Count_Report__c
												 			WHERE 
												 				Trunk_Stock_Cycle_Count__c = :recordId
												 				and Total_Inventory_Units__c = 0
												 				and Submitted__c = false
												 			Order By
															 	Name__c ];
		return element;
	}

	@AuraEnabled
	public static void updateTSCCReport (Trunk_Stock_Cycle_Count_Report__c TSCCReport)
	{
		update TSCCReport;
		return;
	}

	@AuraEnabled
	public static list<Trunk_Stock_Cycle_Count_Item__c> getTSCCReportItemInfo (ID recordId)
	{
		list<Trunk_Stock_Cycle_Count_Item__c> element = [	SELECT 	
																Counted_Qty__c, Expired_Date__c, Expiring_Status__c, Id, period_discrepancy__c,
																Isvalid__c, Lot_Number__c, Name, Note__c, Product_No__c, Product__c,
																Qty_on_system__c, Unit__c, difference__c, Different_Type__c, Trunk_Stock_report__c
															FROM
																Trunk_Stock_Cycle_Count_Item__c
												 			WHERE
															 	Trunk_Stock_report__c = :recordId
												 			Order By 
															 	Product_No__c DESC,
																Lot_Number__c DESC NULLS LAST];
		return element;
	}

	@AuraEnabled
	public static void submitTSCCount(Trunk_Stock_Cycle_Count_Report__c TSCCReport, list<Trunk_Stock_Cycle_Count_Item__c> TSCCRItem){
		//Update discrepancy period time by checking previous submitted trunk stock audit
		if(TSCCReport.Total_Lot_Discrepancies__c > 0)
		{
			TSCCRItem = SRM_TSAudit_ServerController.updateDiscepancyPeriods(TSCCReport.OwnerId, TSCCRItem);
		}

		update TSCCReport;

		upsert TSCCRItem TSCCItem_ID__c;

		//Update the expiring unit list
		updateListsToHeader(TSCCReport.Id);

		//Update overall trunk stock report
		SRM_TSAudit_ServerController.updateTrunkStockAudit(TSCCReport.Trunk_Stock_Cycle_Count__c);
	}

	@AuraEnabled
	public static void updateTSCCReportItems(list<Trunk_Stock_Cycle_Count_Item__c> TSCCItems)
	{
		update TSCCItems;

		if(!TSCCItems.isEmpty())
			if(!(TSCCItems[0].Trunk_Stock_report__c == null))
			{
				updateListsToHeader(TSCCItems[0].Trunk_Stock_report__c);
			}

		return;
	}

	@AuraEnabled
	public static void updateListsToHeader (Id TSCCId)
	{
		list<Trunk_Stock_Cycle_Count_Item__c> ListExpireLines =[SELECT 	
																	Counted_Qty__c, Expired_Date__c, Expiring_Status__c, Id, period_discrepancy__c,
																	Isvalid__c, Lot_Number__c, Name, Note__c, Product_No__c, Product__c,
																	Qty_on_system__c, Unit__c, difference__c, Different_Type__c, Trunk_Stock_report__c
																FROM
																	Trunk_Stock_Cycle_Count_Item__c
																WHERE
																	Trunk_Stock_report__c = :TSCCId
																	and Expiring_Status__c LIKE '%Exp%'
																	and Counted_Qty__c != 0
																Order By 
																	Product_No__c DESC,
																	Lot_Number__c DESC NULLS LAST];	

		list<Trunk_Stock_Cycle_Count_Item__c> ListDiscrepancyLines=[SELECT 	
																		Counted_Qty__c, Expired_Date__c, Expiring_Status__c, Id, period_discrepancy__c,
																		Isvalid__c, Lot_Number__c, Name, Note__c, Product_No__c, Product__c,
																		Qty_on_system__c, Unit__c, difference__c, Different_Type__c, Trunk_Stock_report__c
																	FROM
																		Trunk_Stock_Cycle_Count_Item__c
																	WHERE
																		Trunk_Stock_report__c = :TSCCId
																		and difference__c != 0
																	Order By 
																		Product_No__c DESC,
																		Lot_Number__c DESC NULLS LAST];	
		
		Integer totalExpiredUnits = 0;
		String ExpiredList = '';
		String discrepancyList = '';
		Integer totalTable = 0;

		if(!ListDiscrepancyLines.isempty())
		{
			totalTable++;
			discrepancyList = discrepancyList + '<b>Table ' + String.valueOf(totalTable) + ': The list of discrepant lots</b><br/>';
			discrepancyList = discrepancyList + '<table border="1" style="border-collapse:collapse;"><tr><th style = "border: 1px solid black; padding: 1px">Item#</th>';
			discrepancyList = discrepancyList + '<th style="border: 1px solid black; padding: 1px">Lot#</th>';
			discrepancyList = discrepancyList + '<th style="border: 1px solid black; padding: 1px">Reported Qty</th>';
			discrepancyList = discrepancyList + '<th style="border: 1px solid black; padding: 1px">System Qty</th>';
			discrepancyList = discrepancyList + '<th style="border: 1px solid black; padding: 1px">Discrepancy Period</th>';
			discrepancyList = discrepancyList + '<th style="border: 1px solid black; padding: 1px; text-align: left;">Note</th></tr>';			
			for(Trunk_Stock_Cycle_Count_Item__c element2: ListDiscrepancyLines)
			{
				discrepancyList = discrepancyList + '<tr><td style = "border: 1px solid black; padding: 1px">' + element2.Product_No__c + '</td>';
				discrepancyList = discrepancyList + '<td style = "border: 1px solid black; padding: 1px">' + element2.Lot_Number__c + '</td>';
				discrepancyList = discrepancyList + '<td style = "text-align: left;">' + element2.Counted_Qty__c + '</td>';
				discrepancyList = discrepancyList + '<td style = "border: 1px solid black; padding: 1px">' + element2.Qty_on_system__c + '</td>';
				discrepancyList = discrepancyList + '<td style = "border: 1px solid black; padding: 1px">' + element2.period_discrepancy__c + '</td>';
				if(element2.Note__c == null)
					element2.Note__c = '';
				discrepancyList = discrepancyList + '<td style = "border: 1px solid black; padding: 1px">' + element2.Note__c + '</td></tr>';
				if(discrepancyList.length() > 123000)
				{
					discrepancyList = discrepancyList + '</tr>run out of space</tr>';
					break;
				}
			}
			discrepancyList = discrepancyList + '</table><br/><br/>';
		}
		
		if(!ListExpireLines.isempty())
		{
			totalTable++;
			totalExpiredUnits = ListExpireLines.size();
			ExpiredList = ExpiredList + '<b>Table ' + String.valueOf(totalTable) + ': The list of expiring/expired lots</b><br/>';
			ExpiredList = ExpiredList + '<table border="1" style = "border-collapse:collapse;"><tr><th style = "border: 1px solid black; padding: 1px">Item#</th>';
			ExpiredList = ExpiredList + '<th style = "border: 1px solid black; padding: 1px">Lot#</th>';
			ExpiredList = ExpiredList + '<th style = "border: 1px solid black; padding: 1px">Reported Qty</th>';
			ExpiredList = ExpiredList + '<th style = "border: 1px solid black; padding: 1px">Expire Date</th>';
			ExpiredList = ExpiredList + '<th style = "border: 1px solid black; padding: 1px">Expiring Status</th>';
			ExpiredList = ExpiredList + '<th style = "border: 1px solid black; padding: 1px; text-align: left;">Note</th></tr>';			
			for(Trunk_Stock_Cycle_Count_Item__c element1: ListExpireLines)
			{
				ExpiredList = ExpiredList + '<tr><td style = "border: 1px solid black; padding: 1px">' + element1.Product_No__c + '</td>';
				ExpiredList = ExpiredList + '<td style = "border: 1px solid black; padding: 1px">' + element1.Lot_Number__c + '</td>';
				ExpiredList = ExpiredList + '<td style = "text-align: left;">' + element1.Counted_Qty__c + '</td>';
				String ExpiredDateString = '';
				if(element1.Expired_Date__c != null)
				{
					ExpiredDateString = element1.Expired_Date__c.format();
				}else
				{
					ExpiredDateString = 'N/A';
				}
				ExpiredList = ExpiredList + '<td style = "border: 1px solid black; padding: 1px">' + ExpiredDateString + '</td>';
				ExpiredList = ExpiredList + '<td style = "border: 1px solid black; padding: 1px">' + element1.Expiring_Status__c + '</td>';
				if(element1.Note__c == null)
					element1.Note__c = '';
				ExpiredList = ExpiredList + '<td style = "border: 1px solid black; padding: 1px">' + element1.Note__c + '</td></tr>';

				if(ExpiredList.length() > 123000)
				{
					ExpiredList = ExpiredList + '</tr>run out of space</tr>';
					break;
				}
			}
			ExpiredList = ExpiredList + '</table><br/><br/>';
		}

		if(discrepancyList != '' || ExpiredList != '')
		{
			Trunk_Stock_Cycle_Count_Report__c updateTSCCR = new Trunk_Stock_Cycle_Count_Report__c();
			updateTSCCR.Id = TSCCId;
			updateTSCCR.Total_Expiring_Units__c = totalExpiredUnits;
			updateTSCCR.List_Discrepancy_Lots__c = discrepancyList;
			updateTSCCR.List_Expiring_Units__c = ExpiredList;

			update updateTSCCR;
		}

		return;
	}

	@AuraEnabled
	public static void updateTSCCItemToSFDC (Trunk_Stock_Cycle_Count_Item__c SelectedTSCCItem)
	{
		update SelectedTSCCItem;
		if(SelectedTSCCItem.Qty_on_system__c == SelectedTSCCItem.Counted_Qty__c)
		{
			Trunk_Stock_Cycle_Count_Report__c TSCCReport = [SELECT 	Trunk_Stock_Cycle_Count__c
												 			FROM Trunk_Stock_Cycle_Count_Report__c
												 			WHERE Id = :SelectedTSCCItem.Trunk_Stock_report__c
												 			LIMIT 1];
			SRM_TSAudit_ServerController.updateTrunkStockAudit(TSCCReport.Trunk_Stock_Cycle_Count__c);
		}
		return;
	}

	@AuraEnabled
	public static list<Trunk_Stock_Cycle_Count_Report__c> getListSumLotInv ()
	{
		List<AggregateResult> listResult = [SELECT 
												Lot_Inventory__c.QADLocationDescription__c, Location__r.OwnerID, sum(On_Hand_Qty__c)
											FROM
												Lot_Inventory__c
											Where
												Location__r.Location_ID__c like 'SRM%'
											Group By 
												Location__r.OwnerID, Lot_Inventory__c.QADLocationDescription__c
											Order by 
												Lot_Inventory__c.QADLocationDescription__c];

		//Borrow Trunk_Stock_Cycle_Count_Report__c object to store result and send back to client
		List<Trunk_Stock_Cycle_Count_Report__c> TSCCRlist = new List<Trunk_Stock_Cycle_Count_Report__c>();

		for(AggregateResult element : listResult)
		{
			TSCCRlist.add( new Trunk_Stock_Cycle_Count_Report__c
							(	Name__c = String.valueof(element.get('QADLocationDescription__c')),
								Note__c = String.valueof(element.get('OwnerID')),
								Total_Inventory_Units__c = Integer.valueOf(element.get('expr0'))
							));
		}

		return TSCCRlist;
	}	

	@AuraEnabled
	public static list<Trunk_Stock_Cycle_Count_Report__c> getListAdminTrunk ()
	{
		List<AggregateResult> listResult = [SELECT 
												QADLocationDescription__c, Owner.Name, sum(On_Hand_Qty__c)
											FROM
												Lot_Inventory__c
											where
												(
													Owner.Name LIKE 'Sang Nguyen'
												   	OR Owner.Name LIKE 'Administrator'
												)
												AND Name LIKE 'SRM%'		
											Group By 
												Owner.Name, QADLocationDescription__c
											Order by 
												QADLocationDescription__c];

		//Borrow Trunk_Stock_Cycle_Count_Report__c object to store result and send back to client
		List<Trunk_Stock_Cycle_Count_Report__c> TSCCRlist = new List<Trunk_Stock_Cycle_Count_Report__c>();

		for(AggregateResult element : listResult)
		{
			TSCCRlist.add( new Trunk_Stock_Cycle_Count_Report__c
							(	Name__c = String.valueof(element.get('QADLocationDescription__c')),
								Note__c = 'rep/tds does not have a SFDC account.' ,
								Total_Inventory_Units__c = Integer.valueOf(element.get('expr0'))
							));
		}

		return TSCCRlist;
	}

	@AuraEnabled
	public static List<User> getListUserCycleCount ()
	{
		List<User> finalList = new List<User>();

		List<User> userlist1 =[	SELECT 
									Email,Id,Name,ProfileId,Title, UserType, IsActive, ManagerId
								FROM
									User
								WHERE
									IsActive = true
									and UserType != 'CsnOnly'
									and
									(
										Email LIKE 'mchang%silkroadmed.com%'
										OR Email LIKE 'mpage%silkroadmed.com%'
										OR Email LIKE 'skume%silkroadmed.com%'
										OR Email LIKE 'andrew.davis%silkroadmed.com%'									
									)
								Order By
									Name];
		finalList.addAll(userlist1);
		

		List<User> userlist2 =[	SELECT Email,Id,Name,ProfileId,Title, UserType, IsActive, ManagerId
								FROM User
								WHERE
									IsActive = true
									and 
									(
										ProfileId = '00e41000001mELhAAM' //Therapy Development Specialist
										or ProfileId = '00e1M000001IwlSQAS' //SRM New Area Manager
										or ProfileId = '00e41000001m9UlAAI' //SRM Sales
										or ProfileId = '00e41000001mEsRAAU' //SRM Sales Power Users
									)
									and UserType != 'CsnOnly'
									and Title LIKE '%Area Director%'
								Order By Name];
		finalList.addAll(userlist2);				

		List<User> userList3 =[	SELECT Email,Id,Name,ProfileId,Title, UserType, IsActive, ManagerId
								FROM User
								WHERE
									IsActive = true
									and UserType != 'CsnOnly'
									and
									(
										ProfileId = '00e41000001mELhAAM' //Therapy Development Specialist
										or ProfileId = '00e1M000001IwlSQAS' //SRM New Area Manager
										or ProfileId = '00e41000001m9UlAAI' //SRM Sales
										or ProfileId = '00e41000001mEsRAAU' //SRM Sales Power Users
									)
								 	and 
							 		(
										Title LIKE '%Area Manager%'
										OR Title LIKE '%Therapy Development%'
										OR Title LIKE '%Senior Clinical Field Manager%'
									)
								Order By Name];
		finalList.addAll(userlist3);

		return finalList;
	}

	@AuraEnabled
	public static EmailTemplate getTSCCEmailTemplate ()
	{
		EmailTemplate email = [	SELECT Id, Body, Name, Subject, HtmlValue
								FROM EmailTemplate 
								Where Name = 'Trunk Stock Cycle Count Email Template'
								Limit 1];

		return email;
	}

	@AuraEnabled
	public static EmailTemplate getTSCCEmailTemplate2 ()
	{
		EmailTemplate email = [	SELECT Id, Body, Name, Subject, HtmlValue
								FROM EmailTemplate 
								Where Name = 'Trunk Stock Cycle Count - Sent to Submitter after CS review'
								Limit 1];

		return email;
	}

	@AuraEnabled
	public static EmailTemplate getTSAuditReminderEmailTemplate ()
	{
		EmailTemplate email = [	SELECT Id, Body, Name, Subject, HtmlValue
								FROM EmailTemplate 
								Where Name = 'Trunk Stock Cycle Count - Reminder Email Template'
								Limit 1];

		return email;
	}

	@AuraEnabled
	public static void saveTSCCEmailTemplate (EmailTemplate email)
	{
		try
		{
			update email;
		}
		catch (Exception ex)
		{
			System.Debug('Apex Debug: cannot update email Template');
		}
	}

	@AuraEnabled
	public static list<Trunk_Stock_Cycle_Count_Report__c> createNewTSCCReport (list<Trunk_Stock_Cycle_Count_Report__c> TSCCReportCreatedList)
	{
		list<Id> TSCCReportOwnerIDList = new list<Id>();

		for(Trunk_Stock_Cycle_Count_Report__c element : TSCCReportCreatedList)
		{
			TSCCReportOwnerIDList.add(element.OwnerId);
		}

		list<User> UserInfos = [SELECT ManagerId, Id
								FROM User 
								WHERE 
									Id In :TSCCReportOwnerIDList
									and IsActive = true];

		for(Trunk_Stock_Cycle_Count_Report__c element : TSCCReportCreatedList)
		{
			for(User element1 : UserInfos)
			{
				if(element1.Id == element.OwnerId)
				{
					element.Owner_Manager_ID__c = element1.ManagerId;
					break;
				}
			}
		}

		list<Location__c> UserLocationInfos = [	SELECT Id, OwnerId
												FROM Location__c
												WHERE OwnerId In :TSCCReportOwnerIDList
												ORDER BY LastModifiedDate DESC];

		for(Trunk_Stock_Cycle_Count_Report__c element : TSCCReportCreatedList)
		{
			for(Location__c element1 : UserLocationInfos)
			{
				if(element1.OwnerId == element.OwnerId)
				{
					element.Location__c = element1.Id;
					//add a feed message into rep trunk location
					//String message = 'A ' + element.Name + ' has been created.';
					//ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, element1.Id, ConnectApi.FeedElementType.FeedItem, message);					
					break;
				}
			}
		}

		insert TSCCReportCreatedList;

		return TSCCReportCreatedList;
	}

	@AuraEnabled
	public static User getCurrentUser(){
		Id curUserId = UserInfo.getUserId();
		User currentUser = [SELECT Id, FirstName, LastName, Field_Responsibility__c, ProfileId, Profile.Name, SenderEmail, Email, MobilePhone, Title, Manager.email, ManagerId
							FROM User 
							WHERE Id = :curUserId];
		return currentUser;
	}

	@AuraEnabled
	public static User getrepTDSInformation(ID reptdsID){
		User currentUser = [SELECT Id, FirstName, LastName, Field_Responsibility__c, Profile.Name, SenderEmail, Email, Employee_ID__c, Name, Manager.email, ManagerId
							FROM User 
							WHERE Id = :reptdsID];
		return currentUser;
	}


	@AuraEnabled
	public static list<Lot_Information__c> getLotInfomation(){
		list<Lot_Information__c> result =  [	SELECT Expired_Date__c,IsActive__c,Item_No__c,Lot_Number__c, Expiring_Status__c
												FROM Lot_Information__c
												WHERE IsActive__c = true 
												ORDER BY Item_No__c DESC NULLS LAST, Lot_Number__c DESC NULLS LAST];
		return result;
	}

	@AuraEnabled
	public static list<Trunk_Stock_Cycle_Count_Item__c> updateDiscepancyPeriods (Id ownerId, list<Trunk_Stock_Cycle_Count_Item__c> TSCCRItem)
	{
		//Find previous submitted trunk stock audit report
		List<Trunk_Stock_Cycle_Count_Report__c> TSCCReports = [	SELECT Id 
																FROM Trunk_Stock_Cycle_Count_Report__c
																WHERE OwnerId = :ownerId 
																	  AND Submitted__c = true
																ORDER BY CreatedDate DESC NULLS LAST];

		//Get detail of items of the found TSCCReport
		list<Trunk_Stock_Cycle_Count_Item__c> previousTSCCRItems = new list<Trunk_Stock_Cycle_Count_Item__c>();
		if(!TSCCReports.isEmpty())
		{
			 previousTSCCRItems = [	SELECT difference__c,Different_Type__c,Lot_Number__c,Note__c,period_discrepancy__c 
									FROM Trunk_Stock_Cycle_Count_Item__c 
									WHERE Trunk_Stock_report__c =:TSCCReports[0].Id
										  AND difference__c > 0];
		}

		//Matching lot discrepancy
		Integer i = 0;
		Decimal elementDifference = 0;
		if(!previousTSCCRItems.isEmpty())
		{
			for(Trunk_Stock_Cycle_Count_Item__c element : TSCCRItem)
			{
				if( element.Counted_Qty__c != element.Qty_on_system__c)
				{
					for(i=0; i<previousTSCCRItems.size(); i++)
					{
						if(previousTSCCRItems[i].Lot_Number__c == element.Lot_Number__c)
						{
							elementDifference = math.abs(element.Counted_Qty__c - element.Qty_on_system__c);
							if(previousTSCCRItems[i].difference__c == elementDifference)
							{
								element.period_discrepancy__c = previousTSCCRItems[i].period_discrepancy__c;
							}
							else
							{
								element.period_discrepancy__c = element.period_discrepancy__c + ', '+ previousTSCCRItems[i].period_discrepancy__c;
								if(element.period_discrepancy__c.length() > 19)
								{
									element.period_discrepancy__c = element.period_discrepancy__c.left(16)+'...';
								}
							}

							if(previousTSCCRItems[i].Note__c != null && previousTSCCRItems[i].Note__c != '' && previousTSCCRItems[i].Note__c != ' ')
							{
								element.Note__c = 'Note from previous TSAudit: "' + previousTSCCRItems[i].Note__c + '."';
								if(element.Note__c.length() > 254)
								{
									element.Note__c = element.Note__c.left(250)+'..."';
								}								
							}
							break;
						}
					}
				}
			}
		}

		return TSCCRItem;
	}

	@AuraEnabled
	public static void updateTrunkStockAudit (Id TSSCCId)
	{
		list<Trunk_Stock_Cycle_Count_Report__c> TSCCReports = [	SELECT 	OwnerId, Count_Date__c, Id, Name, Name__c, Note__c, Reviewer__c, Review_Date__c, Owner_Manager_ID__c, Location__c,
																   Status__c, Total_Inventory_Units__c, Trunk_Stock_Cycle_Count__r.End_Date__c, Completed_Percentage__c, Sent_reconciled_email__c,
																   Trunk_Stock_Cycle_Count__r.Due_Date__c, Submitted__c, Total_Unit_Discrepancies__c, Total_Lot_Discrepancies__c, Trunk_Stock_Cycle_Count__c
													 			FROM Trunk_Stock_Cycle_Count_Report__c
													 			WHERE 
													 				Trunk_Stock_Cycle_Count__c = :TSSCCId
													 				and 
													 					(Total_Inventory_Units__c != 0
													 					or 
													 						(Total_Inventory_Units__c = 0 
													 						and Submitted__c = true))];

		Trunk_Stock_Cycle_Count__c TSCCount = SRM_TSAudit_ServerController.getTSCCountInfo(TSSCCId);
		Integer totalSubmittedReport = 0;
		Integer totalReport = 0;
		Decimal CompletedPercent = 0;

		for(Trunk_Stock_Cycle_Count_Report__c element : TSCCReports)
		{
			totalReport++;
			CompletedPercent = CompletedPercent + element.Completed_Percentage__c;
			if(element.Submitted__c)
			{
				totalSubmittedReport++;
			}
		}

		if(totalReport == 0)
			CompletedPercent = 100;
		else
			CompletedPercent = CompletedPercent/totalReport;
		TSCCount.Total_Submited_TS_Report__c = totalSubmittedReport;
		TSCCount.Total_Trunk_Stock_Reports__c = totalReport;
		TSCCount.Completed_Percentage__c = CompletedPercent;

		update TSCCount;
	}

	@AuraEnabled
	public static void sendAnEmail (List<String> sendToAddresses, List<String> bCCAddresses, String subject, String emailBody)
	{
		Organization org = [SELECT IsSandbox FROM Organization LIMIT 1];

		User currentUser = getCurrentUser();
		String userName = currentUser.FirstName + ' ' + currentUser.LastName;

    	List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
  
    	// Step 1: Create a new Email
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
    	// Step 2: Set list of people who should get the email
		if(org.IsSandbox)
		{
			List<String> adminAddress = new List<String>();
			adminAddress.add('salesforce@silkroadmed.com');
			mail.setToAddresses(adminAddress);
		}else
       		mail.setToAddresses(sendToAddresses);

       	//List<String> sendBcc = new List<String>();
       	if(bCCAddresses.size() > 0 &&  bCCAddresses[0] !='' && !org.IsSandbox)
       		mail.setCcAddresses(bCCAddresses);
    
    	// Step 3: Set who the email is sent from
		if(currentUser.ProfileId == '00e1M000000cNBbQAM')
		{
			list<OrgWideEmailAddress> OrgCus = [select Id from OrgWideEmailAddress where Address LIKE '%customerservice@silkroadmed.com%'];
			if ( OrgCus.size() > 0 )
			{
    			mail.setOrgWideEmailAddressId(OrgCus.get(0).Id);
			}else
			{
				mail.setReplyTo(currentUser.SenderEmail);
				mail.setSenderDisplayName(userName);
			}
		}else
		{
			mail.setReplyTo(currentUser.SenderEmail);
			mail.setSenderDisplayName(userName);
		}
    
    	// Step 4. Set email contents - you can use variables!
      	mail.setSubject(subject);
      	mail.setHtmlBody(emailBody);   	
    
    	// Step 5. Add your email to the master list
      	mails.add(mail);
    
  		// Step 6: Send all emails in the master list
     	Messaging.sendEmail(mails);
	}

	@AuraEnabled 
	public static List<User> getCSUsers(){
		List<User> userList = [SELECT Id, FirstName, LastName 	FROM User
																WHERE Title LIKE '%Customer Success%'
																	  AND LastName != 'Success Team'
																ORDER BY FirstName];

		return userList;
	}

	@AuraEnabled 
	public static Id removeTSCCReportitems(Trunk_Stock_Cycle_Count_Report__c TSCCReport)
	{
		list<Trunk_Stock_Cycle_Count_Item__c> elements = [	SELECT Id
															FROM Trunk_Stock_Cycle_Count_Item__c
												 			WHERE Trunk_Stock_report__c = :TSCCReport.Id];
		delete elements;

		update TSCCReport;

		//Recalculate the completed percent for this trunk stock audit
		SRM_TSAudit_ServerController.updateTrunkStockAudit(TSCCReport.Trunk_Stock_Cycle_Count__c);

		return TSCCReport.Id;
	}

	@AuraEnabled 
	public static Id deleteTSCCR(Trunk_Stock_Cycle_Count_Report__c TSCCReport)
	{
		delete TSCCReport;

		//Recalculate the completed percent for this trunk stock audit
		SRM_TSAudit_ServerController.updateTrunkStockAudit(TSCCReport.Trunk_Stock_Cycle_Count__c);

		return TSCCReport.Id;
	}

	@AuraEnabled 
	public static List<Trunk_Stock_Cycle_Count_Item__c> getPreviousTSCCitem(Id currentTSCCItemId){
		Trunk_Stock_Cycle_Count_Item__c currentTSCCItem = [	SELECT 	Id, Lot_Number__c, Trunk_Stock_report__r.ownerID
															FROM Trunk_Stock_Cycle_Count_Item__c
												 			WHERE Id = :currentTSCCItemId
												 			LIMIT 1];

		list<Trunk_Stock_Cycle_Count_Item__c> element = [	SELECT 	Counted_Qty__c, Expired_Date__c, Expiring_Status__c, Id, period_discrepancy__c,
																	Isvalid__c, Lot_Number__c, Name, Note__c, Product_No__c, Product__c, Trunk_Stock_report__r.Count_Date__c,
																	Qty_on_system__c, Unit__c, difference__c, Different_Type__c, Trunk_Stock_report__c
															FROM Trunk_Stock_Cycle_Count_Item__c
												 			WHERE 	Lot_Number__c = :currentTSCCItem.Lot_Number__c
												 					and Trunk_Stock_report__r.ownerID = : currentTSCCItem.Trunk_Stock_report__r.ownerID
												 					and Id !=: currentTSCCItem.Id												 					
												 			Order By Product_No__c DESC, Lot_Number__c DESC NULLS LAST
												 			LIMIT 5];												 			
		return element;
	}
	
	@AuraEnabled
	public static String NewTSA_CCUSers_List ()
	{
		String emails = '';
		list<User> listUserEmail = [Select
										Email
									FROM 
										User
									Where
										IsActive = true
										and 
										(
											Title LIKE '%Area Director%'
											or Email LIKE '%customerservice@silkroadmed%'
										)];
		
		for(User element : listUserEmail)
		{
			if(emails == '')
			{
				emails = element.Email;
			}else
			{
				emails += '; '+ element.Email;
			}
		}

		String CCEmail = getCCUSersForEmail();
		if(CCEmail !='')
		{
			if(emails !='')
				emails = emails + ';' + CCEmail;
			else
				emails = CCEmail;
		}
		
		return emails;
	}

	@AuraEnabled 
	public static String getCCUSersForEmail ()
	{
		String emails = '';
		list<PermissionSetAssignment> listUserEmail = [ Select
															Assignee.Email
														FROM 
															PermissionSetAssignment 
														Where
															PermissionSet.Name = 'TSA_Users_included_in_the_CC_of_emails'
														];
		
		for(PermissionSetAssignment element : listUserEmail)
		{
			if(emails == '')
			{
				emails = element.Assignee.Email;
			}else
			{
				emails += '; '+ element.Assignee.Email;
			}
		}

		return emails;
	}
}
//System.Debug('Apex Debug:' + listResult[0]);