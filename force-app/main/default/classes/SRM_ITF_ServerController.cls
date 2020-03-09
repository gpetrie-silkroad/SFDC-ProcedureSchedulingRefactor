public without sharing class SRM_ITF_ServerController {
	@AuraEnabled
	public static ID createNewITF(Inventory_Transfer_Form__c newITForm){
		if(!String.isEmpty(newITForm.customer_to__c))
		{
			if(!String.isEmpty(newITForm.srm_am__c))
			{
				newITForm.AccountOwner__c = newITForm.srm_am__c;
			}else
			{
				Account acc = [ SELECT OwnerId
								FROM Account
								WHERE Id = :newITForm.customer_to__c
								LIMIT 1];
				newITForm.AccountOwner__c = acc.OwnerId;
			}
		}

		if(!String.isEmpty(newITForm.to_rep_tds__c))
		{
			List<User> SRMEmployee = [SELECT Id 
								FROM User
								WHERE Name = :newITForm.to_rep_tds__c
								LIMIT 1];

			if(SRMEmployee.size() > 0)
				newITForm.To_Rep_TDS_ID__c = SRMEmployee[0].Id;
		}
		insert newITForm;
		ID newITFormID = newITForm.ID;
		return newITFormID;
	}

	@AuraEnabled
	public static Inventory_Transfer_Form__c getITF (ID iTFID){
		Inventory_Transfer_Form__c currentITF = [SELECT id,  name,  itf_type__c,  status__c, Tracking_Number__c, Ship_Date__c, TrackingNumberPictureID__c,
														transfer_date__c,  srm_am__c, srm_am__r.FirstName, srm_am__r.LastName, To_Rep_TDS_ID__c,
														srm_tds__c, srm_tds__r.FirstName, srm_tds__r.LastName, CountTransactedLines__c,
														other_qualified_srm_employee__r.FirstName, Total_Transacted_Items__c, MTFCopyID__c,
														other_qualified_srm_employee__c, other_qualified_srm_employee__r.LastName, from_rep_tds__c,
														customer_to__r.IQMS_Customer_Number__c, customer_to__r.Name ,customer_from__r.IQMS_Customer_Number__c , customer_from__r.Name,
														itf_id__c,  to_rep_tds__c,  customer_to__c, summary_Used_Item__c, Owner.Name,
														bill_only_po__c,  no_charge_po__c,  customer_from__c, pDFIDCurrentITForm__c, Owner.Email,
														primary_bill_only_number__c,  total_price__c, editableByRepTDS__c, AutoSaveCopy__c,
														recipient_name__c, 	recipient_title__c, signAttachID__c, pDFID__c,ITF_CS_Process__c,
														CustomerSignViaDocumentID__c
												 FROM Inventory_Transfer_Form__c 
												 WHERE Id = : iTFID];
		return currentITF;
	}	

	@AuraEnabled
	public static Inventory_Transfer_Form__c updateITF(Inventory_Transfer_Form__c iTForm){
		//remove empty ID field (empty field don't pass from client to server)
		Id newID;
		if(iTForm.SRM_AM__c == NULL)
			iTForm.SRM_AM__c = newID;
		if(iTForm.SRM_TDS__c == NULL)
			iTForm.SRM_TDS__c = newID;
		if(iTForm.Other_Qualified_SRM_Employee__c == NULL)
			iTForm.Other_Qualified_SRM_Employee__c = newID;

		update iTForm;
		iTForm = getITF(iTForm.Id);

		return iTForm;
	}

	@AuraEnabled
	public static User getCurrentUser(){
		Id curUserId = UserInfo.getUserId();
		User currentUser = [SELECT
								Id, FirstName, LastName, Field_Responsibility__c,
								Profile.Name, SenderEmail, Email, MobilePhone, 
								Title, Employee_ID__c, Name, City, State,
								PostalCode, Street
							FROM 
								User 
							WHERE
								Id = : curUserId];
		return currentUser;
	}

	@AuraEnabled 
	public static List<User> getAMUsers(Integer isCurrentUser){
		User currentUser = getCurrentUser();
		User nullUser;
		if(currentUser.Field_Responsibility__c == 'Area Manager' & isCurrentUser==1){
			nullUser = currentUser;
		}
		else{
			 nullUser = new User(FirstName = '- N /', LastName = 'A -');
		}

		List<User> amUserList = [SELECT Id, FirstName, LastName, Employee_ID__c, Name
								 FROM User
								 WHERE isActive = true
								 AND Field_Responsibility__c = 'Area Manager'
								 ORDER BY FirstName];
		List<User> userList = new List<User>();
		userList.add(nullUser);
		userList.addAll(amUserList);

		return userList;
	}

	@AuraEnabled 
	public static List<User> getTDSUsers(Integer isCurrentUser){
		User currentUser = getCurrentUser();
		User nullUser;
		if(currentUser.Field_Responsibility__c == 'Therapy Development Specialist' & isCurrentUser==1){
			nullUser = currentUser;
		}
		else{
			 nullUser = new User(FirstName = '- N /', LastName = 'A -');
		}
		List<User> tdUserList = [SELECT Id, FirstName, LastName, Employee_ID__c, Name
								 FROM User
								 WHERE (isActive = true)
								 AND   (Field_Responsibility__c = 'Therapy Development Specialist')
								 ORDER BY FirstName];
		List<User> userList = new List<User>();
		userList.add(nullUser);
		userList.addAll(tdUserList);

		return userList;
	}

	@AuraEnabled 
	public static List<User> getOtherUsers(Integer isCurrentUser){
		User currentUser = getCurrentUser();
		User nullUser;
		List<User> userList = new List<User>();
		nullUser = new User(FirstName = '- N /', LastName = 'A -');
		userList.add(nullUser);
		if(currentUser.Field_Responsibility__c != 'Area Manager' & currentUser.Field_Responsibility__c != 'Therapy Development Specialist'){
			userList.add(currentUser);
		}
		
		List<User> adUserList = [SELECT Id, FirstName, LastName, Employee_ID__c, Name
								 FROM User
								 WHERE isActive = true
								 AND   (Field_Responsibility__c = 'Area Director'
									   OR UserName Like 'mchang@silkroadmed.com%'																	
								       OR UserName Like 'skume@silkroadmed.com%'
								       OR UserName like 'mpage@silkroadmed.com%')	
								 ORDER BY FirstName];
																
		userList.addAll(adUserList);

		return userList;
	}

	@AuraEnabled 
	public static List<User> getCSUsers(){
		List<User> userList = [SELECT Id, FirstName, LastName 	FROM User
																WHERE 
																	Title LIKE '%Customer Success%'
																	AND LastName != 'Success Team'
																	AND isActive = true
																ORDER BY FirstName];

		return userList;
	}

	@AuraEnabled 
	public static List<Account> getAccounts(){
		User currentUser = getCurrentUser();
		Account nullAccount = new Account (IQMS_Customer_Number__c = 'Customer #', Name = 'Name', ShippingCity = 'City');
		List<Account> accountList = new List<Account>();
		List<Account> tempAccountList = new List<Account>();
		accountList.add(nullAccount);

		if(currentUser.Field_Responsibility__c == 'Area Manager'){
			tempAccountList = [	SELECT Name, IQMS_Customer_Number__c, Id
								FROM Account
								WHERE OwnerId =: currentUser.Id
									  and IQMS_Customer_Number__c != null
									  and IQMS_Customer_Number__c != ''
								ORDER BY Name, IQMS_Customer_Number__c];
		}
		else{
			tempAccountList = [	SELECT Name, IQMS_Customer_Number__c, Id
								FROM Account
								WHERE Name != 'Holding Account'
									  and IQMS_Customer_Number__c != null
									  and IQMS_Customer_Number__c != ''
								ORDER BY Name, IQMS_Customer_Number__c];
		}

		accountList.addAll(tempAccountList);

		return accountList;
	}

	@AuraEnabled 
	public static Boolean isValidAccountForITF(ID accountID){
		Account	accountInfo = [	SELECT Name, IQMS_Customer_Number__c, Id
								FROM Account
								WHERE Id =: accountID];

		if(accountInfo.IQMS_Customer_Number__c == '' || accountInfo.IQMS_Customer_Number__c == null)	
			return false;
		else
			return true;
	}

	@AuraEnabled 
	public static List<Inventory_Transfer_Form_Transaction__c> getITFTransactionsList(ID ITFID){
		List<Inventory_Transfer_Form_Transaction__c> ITFList = [SELECT id, name, 
																	   TSR_Received_By__c, TSR_Received_Date__c, TSR_Received_Qty__c, 
																	   TSR_Transaction_ID__c,TSR_Transaction_ID__r.QADTranasctionID__c,
																	   inventory_transfer_form__c,
																	   inventory_owner__c,  
																	   lot_number__c,  price__c,  
																	   quantity__c,  uom__c, 
																	   extended_price__c,  
																	   replenish__c,  
																	   bill_only_number__c,  
																	   transacted_by__c,  
																	   product_number__c,  
																	   note__c,
																	   transfer_Date_System__c,
																	   IsTransactionComplete__c,
																	   OwnerID__c,
																	   Product__c

																FROM Inventory_Transfer_Form_Transaction__c
																WHERE inventory_transfer_form__c =: ITFID
																ORDER BY product_number__c];

		return ITFList;
	}

	@AuraEnabled
	public static Inventory_Transfer_Form_Transaction__c addNewITFTransaction (Inventory_Transfer_Form_Transaction__c newITFTransaction){
		List<Product2> productInfo = [SELECT Description FROM Product2 WHERE ProductCode =: newITFTransaction.Product_Number__c LIMIT 1];
		for(Product2 element: productInfo)
			newITFTransaction.Product__c = element.Description;
		upsert newITFTransaction;
		return newITFTransaction;
	}

	@AuraEnabled
	public static void updateITFTransaction (Inventory_Transfer_Form_Transaction__c newITFTransaction){
		List<Product2> productInfo = [SELECT Description FROM Product2 WHERE ProductCode =: newITFTransaction.Product_Number__c LIMIT 1];
		for(Product2 element: productInfo)
			newITFTransaction.Product__c = element.Description;
		update newITFTransaction;
	}

	@AuraEnabled
	public static List<Inventory_Transfer_Form_Transaction__c> updateITFTransactions(ID ITFID, String username, String ordernumber, String transferdate){

		Date dateformat = Date.valueOf(transferdate);
		List<Inventory_Transfer_Form_Transaction__c> ITFList = [SELECT id,  
																	   name, TSR_Received_By__c, TSR_Received_Date__c, TSR_Received_Qty__c, 
																	   TSR_Transaction_ID__c, TSR_Transaction_ID__r.QADTranasctionID__c, 
																	   inventory_transfer_form__c,
																	   inventory_owner__c,  
																	   lot_number__c,  price__c,  
																	   quantity__c,  uom__c, 
																	   extended_price__c,  
																	   replenish__c,  
																	   bill_only_number__c,  
																	   transacted_by__c,  
																	   product_number__c,  
																	   note__c,
																	   transfer_Date_System__c,
																	   IsTransactionComplete__c,
																	   Product__c

																FROM Inventory_Transfer_Form_Transaction__c
																WHERE inventory_transfer_form__c =: ITFID
																ORDER BY product_number__c];
		
		for(Inventory_Transfer_Form_Transaction__c temptransaction : ITFList){
			temptransaction.Transfer_Date_System__c = dateformat;
			temptransaction.Bill_only_number__c = ordernumber;
			temptransaction.Transacted_by__c = username;
			update temptransaction;
		}
		return ITFList;
	}
	
	@AuraEnabled
	public static Inventory_Transfer_Form_Transaction__c deleteITFTransaction (Inventory_Transfer_Form_Transaction__c iTFTransaction){
		delete iTFTransaction;
		return iTFTransaction;
	}

	@AuraEnabled
    public static Id saveSignature(String signatureBody, String parentId, String name, String recipientNameValue, String recipientTitleValue){
       	Attachment a = new Attachment();
        a.ParentId = parentId; // record id of object.
        a.Body = EncodingUtil.base64Decode(signatureBody);
        a.ContentType = 'image/jpg';
        a.Name = name +'.jpg';
        insert a;
        Inventory_Transfer_Form__c tempITF = getITF(parentId);
        tempITF.signAttachID__c = a.id;

        if(recipientNameValue != null & recipientNameValue != '')
        	tempITF.Recipient_Name__c = recipientNameValue;
        if(recipientTitleValue != null & recipientTitleValue != '')
        	tempITF.Recipient_Title__c = recipientTitleValue;

        update tempITF;
        return a.id;
    }

    @AuraEnabled
	public static Id createPDFCopy (ID iTFID, String name, String pDFID){
		Inventory_Transfer_Form__c tempITF = getITF(iTFID);
		PageReference pdfPage = new PageReference('/apex/SRM_ITF_PDFCustomerCopy');
		pdfPage.getParameters().put('Id', iTFID);
        blob pdfContent;
        try{
            pdfContent = pdfPage.getContentAsPDF();
        }
        catch(Exception e){
       		if(Test.isRunningTest())
            	pdfContent = blob.valueOf('Unit.Test');
        }

		Attachment attach1= new Attachment();
		attach1.ParentId = iTFID;
        attach1.Body = pdfContent;
        attach1.contentType = 'application/pdf';
        attach1.Name = name + '.pdf';
        if(pDFID != null & pDFID !=''){
        	try
        	{
	        	attach1.Id = pDFID;
	        	update attach1;
			}catch(exception e)
			{
				attach1.Id = null;
				insert attach1;
				tempITF.pDFIDCurrentITForm__c = attach1.Id;
				update tempITF;
			}
        }else{
        	insert attach1;
        }
        
		return attach1.Id;
	}

    @AuraEnabled
	public static Id creatingMTF (ID iTFID, String name, String pDFID){
		Inventory_Transfer_Form__c tempITF = getITF(iTFID);
		PageReference pdfPage = new PageReference('/apex/SRM_ITF_MTF');
		pdfPage.getParameters().put('Id', iTFID);
		pdfPage.getParameters().put('iTFPDFType', 'MTFLogistic');
        blob pdfContent;
        try{
System.Debug('Transaction receive:123');
            pdfContent = pdfPage.getContentAsPDF();
        }
        catch(Exception e){
       		if(Test.isRunningTest())
            	pdfContent = blob.valueOf('Unit.Test');
System.Debug('Transaction receive:1235');
        }
System.Debug('Transaction receive:1234');
		Attachment attach1= new Attachment();
		attach1.ParentId = iTFID;
        attach1.Body = pdfContent;
        attach1.contentType = 'application/pdf';
        attach1.Name = name + '.pdf';
        if(pDFID != null & pDFID !=''){
        	try
        	{
	        	attach1.Id = pDFID;
	        	update attach1;
			}catch(exception e)
			{
				attach1.Id = null;
				insert attach1;
				tempITF.MTFCopyID__c = attach1.Id;
				update tempITF;
			}
        }else{
        	insert attach1;
        }
        
		return attach1.Id;
	}

	@AuraEnabled
	public static Id createPDFDetailCopy (ID iTFID, String name, String pDFID){
		Inventory_Transfer_Form__c tempITF = getITF(iTFID);
		PageReference pdfPage = new PageReference('/apex/SRM_ITF_PDFDetailCopy');

		pdfPage.getParameters().put('Id', iTFID);
        blob pdfContent;
        try{
            pdfContent = pdfPage.getContentAsPDF();
        }
        catch(Exception e){
       		if(Test.isRunningTest())
            	pdfContent = blob.valueOf('Unit.Test');
        }

		Attachment attach1= new Attachment();
		attach1.ParentId = iTFID;
        attach1.Body = pdfContent;
        attach1.contentType = 'application/pdf';
        attach1.Name = name + '.pdf';
        if(pDFID != null & pDFID !=''){
        	try
        	{
	        	attach1.Id = pDFID;
	        	update attach1;
			}catch(exception e)
			{
				attach1.Id = null;
				insert attach1;
				tempITF.pDFIDCurrentITForm__c = attach1.Id;
				update tempITF;
			}
        }else{
        	insert attach1;
        }
        
		return attach1.Id;
	}

	@AuraEnabled
	//public static void sendAnEmail (String receiverEmail, String PDFID){
	public static void sendAnEmail (List<String> sendToAddresses, List<String> bCCAddresses, String subject, String emailBody, String ITFID, boolean IsSendITFCopy, String ContactIDSaveEmail, String MTFID)
	{
		User currentUser = getCurrentUser();
		String userName = currentUser.FirstName + ' ' + currentUser.LastName;

    	List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
  
    	// Step 1: Create a new Email
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
    	// Step 2: Set list of people who should get the email
       	mail.setToAddresses(sendToAddresses);

       	//List<String> sendBcc = new List<String>();
       	if(bCCAddresses.size() > 0)
		{
			if(bCCAddresses[0] !='')
				mail.setCcAddresses(bCCAddresses);
		}       		
    
    	// Step 3: Set who the email is sent from
       	mail.setReplyTo(currentUser.SenderEmail);
       	mail.setSenderDisplayName(userName); 

    
    	// Step 4. Set email contents - you can use variables!
      	mail.setSubject(subject);
      	if(emailBody.contains('<br/>') || emailBody.contains('<br>'))
      		mail.setHtmlBody(emailBody);
      	else
      		mail.setPlainTextBody(emailBody);

		//Step 4.1: attachment
		if(IsSendITFCopy)
		{
			if(ITFID != null & ITFID !='')
			{
				List<Inventory_Transfer_Form__c> currentITF = [	SELECT id,  name, pDFID__c
																FROM Inventory_Transfer_Form__c 
																WHERE Id = : ITFID];

				if(currentITF.size() > 0 && (MTFID == null || MTFID ==''))
				{
					MTFID = createPDFCopy (currentITF[0].id, currentITF[0].name + ' - customer copy', currentITF[0].pDFID__c);
					if(currentITF[0].pDFID__c == null || currentITF[0].pDFID__c == '')
					{
						currentITF[0].pDFID__c = MTFID;
						update currentITF;
					}
				}				
			}

			if(MTFID != null & MTFID !='')
			{
				List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
				for (Attachment a : [select Name, Body, BodyLength from Attachment where Id = :MTFID])
				{
	   				Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
	  				efa.setFileName(a.Name);
	  				efa.setBody(a.Body);
	  				fileAttachments.add(efa);
	  				mail.setFileAttachments(fileAttachments);
				}
			}
		}

		//Step 4.2: save a copy of the email on SFDC contact
		if(ContactIDSaveEmail != null & ContactIDSaveEmail !='')
		{
			mail.setTargetObjectId(ContactIDSaveEmail);
		  	mail.setSaveAsActivity(true);		
		}
    
    	// Step 5. Add your email to the master list
      	mails.add(mail);
    
  		// Step 6: Send all emails in the master list
     	Messaging.sendEmail(mails);
	}

	@AuraEnabled
	public static List<String> getSoldItemNumber(){
		List<AggregateResult> productCodeList = [	SELECT
														ProductCode 
										  			FROM 
										  				Product2
										  			WHERE
										  				ProductCode LIKE '%SR-%'
										  				and (Not ProductCode LIKE '%[%]%')
										  			GROUP BY 
										  				ProductCode
										  			ORDER BY
										  				 ProductCode DESC 
										  			LIMIT 100];
		List<String> itemNumberList = new List<String>();
		for(AggregateResult productCode : productCodeList){
			itemNumberList.add(String.valueOf(productCode.get('ProductCode')));
		}
		return itemNumberList;
	}


	//Get Inventory based on last name and firstname
	@AuraEnabled
	public static List<Lot_Inventory__c> getLotInventory(String	owner){
		//=======================update query for work on both QAD and IQMS===================================
		List<Lot_Inventory__c> lotInventory =  [select item_number__c, Lot_Expiration_Date__c,Lot_Number__c,
													  On_Hand_Qty__c, Name
												from Lot_Inventory__c
												where On_Hand_Qty__c > 0
													  AND Owner.name LIKE :owner
													  AND Name LIKE '%9000%'
												ORDER BY item_number__c DESC, Lot_Number__c DESC NULLS LAST];	
		//====================================================================================================	

		return  lotInventory;
	}	

	//Get Contact Info based on Account
	@AuraEnabled
	public static List<Contact> getContactAccount(ID idAccount){
		List<Contact> contactList =  [SELECT Id, Name, AccountId, FirstName, LastName, Email 
									  FROM Contact 
									  WHERE AccountId =: idAccount 
									  		and Email != null
									  		and EmailBouncedReason = null
									  ORDER BY FirstName ASC NULLS LAST];

		return  contactList;
	}		

	@AuraEnabled
	public static Inventory_Transfer_Form__c deleteITForm (Inventory_Transfer_Form__c iTF){
		delete iTF;
		return iTF;
	}

	@AuraEnabled
	public static List<PricebookEntry> getAccountPriceBook (Id accountID){
		List<PricebookEntry> accountPriceBook = new List<PricebookEntry>();
		if(!String.isBlank(accountID))
		{
			Account accDetail = [ 	SELECT Price_Book__c
									FROM Account
									WHERE Id = :accountID
									LIMIT 1];		
			if(!String.isBlank(accDetail.Price_Book__c))
			{
				accountPriceBook = [	SELECT Name, ProductCode, UnitPrice
										FROM PricebookEntry
										WHERE Pricebook2id = :accDetail.Price_Book__c
											and ProductCode like 'SR-%'
										order by ProductCode];
			}
		}
		return accountPriceBook;
	}

	//Check an incomplete Inventory Transfer Form
	@AuraEnabled
    public static String getIncompleteITF (String customerID, String iTFType){
       	User currentUser = getCurrentUser();
       	String iTFID = '';
       	list<Inventory_Transfer_Form__c> incompleteITF = new list<Inventory_Transfer_Form__c>();
       	datetime dt = System.now()-1;
       	if(iTFType == 'Transfer to Customer')
       	{
       		incompleteITF =[select id
							from Inventory_Transfer_Form__c
							where OwnerId =: currentUser.id
						  		  AND Status__c = 'ITF Draft'
						  		  AND Customer_To__c =: customerID
						  		  AND createdDate > :dt
							LIMIT 1];	
       	}else
       	{
       		incompleteITF =[select id
							from Inventory_Transfer_Form__c
							where OwnerId =: currentUser.id
						  		  AND Status__c = 'ITF Draft'
						  		  AND ITF_Type__c = 'Internal Transfer (AM/TDS to AM/TDS)'
						  		  AND createdDate > :dt
							LIMIT 1];
       	}

       	if(incompleteITF.size() > 0)
       		iTFID = incompleteITF[0].id;
       	return iTFID;
    }

    //Insert ITF and transaction at the same time
	@AuraEnabled
    public static Id upsertCompleteITF (Inventory_Transfer_Form__c ITF, List<Inventory_Transfer_Form_Transaction__c> ITFTransactions)
    {
    	upsert ITF ITF_ID__c;

    	list<String> Productlist = new list<String>();
		for(Inventory_Transfer_Form_Transaction__c element : ITFTransactions)
			Productlist.add(element.Product_Number__c);

		List<Product2> productInfo = [	SELECT Description, ProductCode
										FROM Product2 
										WHERE ProductCode IN :Productlist
										LIMIT 500];

		for(Inventory_Transfer_Form_Transaction__c element1 : ITFTransactions)
		{
			element1.inventory_transfer_form__c = ITF.Id;
			for(Product2 element2 : productInfo)
			{
				if(element2.ProductCode == element1.Product_Number__c)
				{
					element1.Product__c = element2.Description;
					break;
				}
			}							
		}

		upsert ITFTransactions ITF_Transaction_ID__c;

       	return ITF.Id;
    }

	@AuraEnabled
    public static Id createMTFPDFcopy (Inventory_Transfer_Form__c ITF)
    {
    	String name = ITF.Name + '-MTFPDFcopy';

		ITF.MTFCopyID__c = creatingMTF(ITF.Id, name, ITF.MTFCopyID__c);

    	update ITF;

       	return ITF.Id;
    }

    @AuraEnabled
    public static Id checkPendingTrunkStockReturn ()
    {
    	Id pendingTrunkStockReturnID;
    	Id curUserId = UserInfo.getUserId();

    	List<Inventory_Transfer_Form__c> TrunkStockReturnList =[select id
																from Inventory_Transfer_Form__c
																where 
																	OwnerId =: curUserId
															  		AND Status__c = 'Shipment Information'
															  		AND ITF_Type__c = 'Internal Transfer (AM/TDS to AM/TDS)'
															  		And To_Rep_TDS__c = 'FG (Trunk Stock Return)'
																LIMIT 1];

    	if(TrunkStockReturnList.size() > 0)
    	{
    		pendingTrunkStockReturnID = TrunkStockReturnList[0].Id;
    	}

       	return pendingTrunkStockReturnID;
    }

    @AuraEnabled
    public static EmailTemplate GetEmailTemplate (String EmailName, String ITFID)
    {
    	EmailTemplate workingEmail = new EmailTemplate();

		List<EmailTemplate> emails = [	SELECT Id, Body, Name, Subject, HtmlValue
										FROM EmailTemplate 
										Where DeveloperName = :EmailName
										Limit 1];

		if(emails.size() > 0)
		{
			Inventory_Transfer_Form__c currentITF = getITF(ITFID);
			User currentUser = getCurrentUser();

			String dateFormatString = 'MM/dd/yyyy';
			Date d = currentITF.Transfer_Date__c;
			Datetime dt = Datetime.newInstance(d.year(), d.month(),d.day());
			String TransferDate = dt.format(dateFormatString);

			//Update subject string with values of ref field
			emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!Inventory_Transfer_Form__c.Name\\}', currentITF.Name);
			emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!Inventory_Transfer_Form__c.Status__c\\}', currentITF.Status__c);
			emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!Inventory_Transfer_Form__c.OwnerFullName\\}', currentITF.Owner.Name);
			emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!Inventory_Transfer_Form__c.Link\\}', 'https://silkroadmed.lightning.force.com/' + currentITF.Id);
			emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!Inventory_Transfer_Form__c.Transfer_Date__c\\}', TransferDate);
			emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.Name\\}', currentUser.Name);

            If(currentUser.Title != null)
			    emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.Title\\}', currentUser.Title);
            else
                emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.Title\\}', '');

            If(currentUser.Street != null)
                emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.Street\\}', currentUser.Street);
            else
			    emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.Street\\}', '');

            If(currentUser.City != null)
			    emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.City\\}', currentUser.City);
            else
                emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.City\\}', '');

            If(currentUser.State != null)
			    emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.State\\}', currentUser.State);
            else
                emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.State\\}', '');

            If(currentUser.PostalCode != null)
			    emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.StateCode\\}', currentUser.PostalCode);
            else
                emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.StateCode\\}', '');

            If(currentUser.MobilePhone != null)
			    emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.MobilePhone\\}', currentUser.MobilePhone);
            else
                emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.MobilePhone\\}', '');

			//Update body string with values of ref field
			emails[0].Subject = emails[0].Subject.replaceAll('\\{!Inventory_Transfer_Form__c.Name\\}', currentITF.Name);
			emails[0].Subject = emails[0].Subject.replaceAll('\\{!Inventory_Transfer_Form__c.Status__c\\}', currentITF.Status__c);
			emails[0].Subject = emails[0].Subject.replaceAll('\\{!Inventory_Transfer_Form__c.OwnerFullName\\}', currentITF.Owner.Name);
			emails[0].Subject = emails[0].Subject.replaceAll('\\{!Inventory_Transfer_Form__c.Link\\}', 'https://silkroadmed.lightning.force.com/' + currentITF.Id);
			emails[0].Subject = emails[0].Subject.replaceAll('\\{!Inventory_Transfer_Form__c.Transfer_Date__c\\}', TransferDate);
			emails[0].Subject = emails[0].Subject.replaceAll('\\{!User.Name\\}', currentUser.Name);

            If(currentUser.Title != null)
			    emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.Title\\}', currentUser.Title);
            else
                emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.Title\\}', '');

            If(currentUser.Street != null)
                emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.Street\\}', currentUser.Street);
            else
			    emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.Street\\}', '');

            If(currentUser.City != null)
			    emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.City\\}', currentUser.City);
            else
                emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.City\\}', '');

            If(currentUser.State != null)
			    emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.State\\}', currentUser.State);
            else
                emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.State\\}', '');

            If(currentUser.PostalCode != null)
			    emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.StateCode\\}', currentUser.PostalCode);
            else
                emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.StateCode\\}', '');

            If(currentUser.MobilePhone != null)
			    emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.MobilePhone\\}', currentUser.MobilePhone);
            else
                emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!User.MobilePhone\\}', '');

			workingEmail = emails[0];
		}else
		{
			workingEmail.HtmlValue = 'N/A';
			workingEmail.Subject = 'N/A';
		}

       	return workingEmail;
    }

    @InvocableMethod(label='Send Instruction Email for trunk stock return' description='Send email with attach PDF file for rep/tds return their trunk stock to FG')
    public static List<Inventory_Transfer_Form__c> ITFProcessController (List<Inventory_Transfer_Form__c> ITFList)
    {
    	String EmailTemplateName = 'ITF_TSReturn_Request_Shipping_Label';
    	List<String> sendToAddresses = new  List<String>();
    	List<String> bCCAddresses = new List<String>();
    	String subject = '';
    	String emailBody = '';
    	Boolean sentEmailtoRep = false;
    	Inventory_Transfer_Form__c ITFdetail = new Inventory_Transfer_Form__c();
		List<EmailTemplate> emails = new List<EmailTemplate>();
//=========send instruction trunk stock return email to submitter==================
		// emails =[SELECT Id, Body, Name, Subject, HtmlValue
		// 							FROM EmailTemplate 
		// 							Where DeveloperName = :EmailTemplateName
		// 							Limit 1];

		// if(emails.size() > 0)
		// {
		// 	ITFdetail = getITF(ITFList[0].Id);

		// 	//Update subject string with values of ref field
		// 	emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!Inventory_Transfer_Form__c.Name\\}', ITFdetail.Name);
		// 	emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!Inventory_Transfer_Form__c.Status__c\\}', ITFdetail.Status__c);
		// 	emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!Inventory_Transfer_Form__c.OwnerFullName\\}', ITFdetail.Owner.Name);
		// 	emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!Inventory_Transfer_Form__c.Primary_Bill_Only_Number__c\\}', ITFdetail.Primary_Bill_Only_Number__c);
		// 	emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!Inventory_Transfer_Form__c.Link\\}', 'https://silkroadmed.lightning.force.com/' + ITFdetail.Id);

		// 	//Update body string with values of ref field
		// 	emails[0].Subject = emails[0].Subject.replaceAll('\\{!Inventory_Transfer_Form__c.Name\\}', ITFdetail.Name);
		// 	emails[0].Subject = emails[0].Subject.replaceAll('\\{!Inventory_Transfer_Form__c.Status__c\\}', ITFdetail.Status__c);
		// 	emails[0].Subject = emails[0].Subject.replaceAll('\\{!Inventory_Transfer_Form__c.OwnerFullName\\}', ITFdetail.Owner.Name);
		// 	emails[0].Subject = emails[0].Subject.replaceAll('\\{!Inventory_Transfer_Form__c.Primary_Bill_Only_Number__c\\}', ITFdetail.Primary_Bill_Only_Number__c);
		// 	emails[0].Subject = emails[0].Subject.replaceAll('\\{!Inventory_Transfer_Form__c.Link\\}', 'https://silkroadmed.lightning.force.com/' + ITFdetail.Id);

		// 	sendToAddresses.add(ITFdetail.Owner.Email);
		// 	//bCCAddresses.add('salesforce@silkroadmed.com');
		// 	bCCAddresses.add('ngocsang59@gmail.com');
		// 	subject = emails[0].Subject;
		// 	emailBody = emails[0].HtmlValue;
		// 	sentEmailtoRep = true;
		// }else
		// {
		// 	bCCAddresses.add('salesforce@silkroadmed.com');
		// 	sendToAddresses.add('salesforce@silkroadmed.com');
		// 	subject = 'Error - Apex Class: SRM_ITF_ServerController - Method: ITFProcessController';
		// 	emailBody += 'Missing developer name:"' + EmailTemplateName + '" template name<br/>';
		// 	emailBody += 'SFDC record ID:' + ITFList[0].Id + ' fired this error.';
		// }

		// sendAnEmail (sendToAddresses, bCCAddresses, subject, emailBody, '', false, '', '');
//=========End of send instruction trunk stock return email to submitter==================

//=========send a request to create shipping label to Logistic Team==================
		EmailTemplateName = 'ITF_TSReturn_Request_Shipping_Label';
		String MTFID = '';
		sendToAddresses.clear();
		emails = [	SELECT Id, Body, Name, Subject, HtmlValue
					FROM EmailTemplate 
					Where DeveloperName = :EmailTemplateName
					Limit 1];
		if(emails.size() > 0)
		{
			// if(sentEmailtoRep)
			// {
				ITFdetail = getITF(ITFList[0].Id);

				//Update subject string with values of ref field
				emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!Inventory_Transfer_Form__c.Name\\}', ITFdetail.Name);
				emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!Inventory_Transfer_Form__c.Status__c\\}', ITFdetail.Status__c);
				emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!Inventory_Transfer_Form__c.OwnerFullName\\}', ITFdetail.Owner.Name);
				emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!Inventory_Transfer_Form__c.Primary_Bill_Only_Number__c\\}', ITFdetail.Primary_Bill_Only_Number__c);
				emails[0].HtmlValue = emails[0].HtmlValue.replaceAll('\\{!Inventory_Transfer_Form__c.Link\\}', 'https://silkroadmed.lightning.force.com/' + ITFdetail.Id);

				//Update body string with values of ref field
				emails[0].Subject = emails[0].Subject.replaceAll('\\{!Inventory_Transfer_Form__c.Name\\}', ITFdetail.Name);
				emails[0].Subject = emails[0].Subject.replaceAll('\\{!Inventory_Transfer_Form__c.Status__c\\}', ITFdetail.Status__c);
				emails[0].Subject = emails[0].Subject.replaceAll('\\{!Inventory_Transfer_Form__c.OwnerFullName\\}', ITFdetail.Owner.Name);
				emails[0].Subject = emails[0].Subject.replaceAll('\\{!Inventory_Transfer_Form__c.Primary_Bill_Only_Number__c\\}', ITFdetail.Primary_Bill_Only_Number__c);
				emails[0].Subject = emails[0].Subject.replaceAll('\\{!Inventory_Transfer_Form__c.Link\\}', 'https://silkroadmed.lightning.force.com/' + ITFdetail.Id);

				sendToAddresses.add('snguyen@silkroadmed.com');
				bCCAddresses.add('salesforce@silkroadmed.com');
				subject = emails[0].Subject;
				emailBody = emails[0].HtmlValue;
				if(!String.isBlank(ITFdetail.MTFCopyID__c))
					MTFID = ITFdetail.MTFCopyID__c;
			// }
		}else
		{
			bCCAddresses.add('salesforce@silkroadmed.com');
			sendToAddresses.add('salesforce@silkroadmed.com');
			subject = 'Error - Apex Class: SRM_ITF_ServerController - Method: ITFProcessController';
			emailBody += 'Missing developer name:"' + EmailTemplateName + '" template name<br/>';
			emailBody += 'SFDC record ID:' + ITFList[0].Id + 'fired this error.';
		}
// bCCAddresses.add('salesforce@silkroadmed.com');
System.Debug('Transaction receive:' + bCCAddresses.size());
System.Debug('Transaction receive:' + bCCAddresses[0]);

		sendAnEmail (sendToAddresses, bCCAddresses, subject, emailBody, '', true, '', MTFID);
//=========End of send a request to create shipping label to Logistic Team==================

    	return ITFList;
    }
}

//System.Debug('Transaction receive:' + newITFTransaction.Inventory_Transfer_Form__c);