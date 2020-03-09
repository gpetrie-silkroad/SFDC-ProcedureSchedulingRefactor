public with sharing class SendOrderConfirmationEmails 
{
	@InvocableMethod(label='SendOrderConfirmationEmailController' description='Orders are ready to send confirmation or have an error and need to send email to CS')
	public static List<QAD_Summary__c> SendOrderConfirmationEmailController(List<QAD_Summary__c> QADSummary)
	{
		Boolean sandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;

		Id curUserId = UserInfo.getUserId();

		User currentUser = [SELECT 
								Id, FirstName, LastName, Field_Responsibility__c,
								Profile.Name, SenderEmail, Email, MobilePhone,
								Title, Manager.email, ManagerId
							FROM
								User 
							WHERE
								Id = :curUserId];

		String senderEmail = currentUser.Email;
		String senderName = currentUser.FirstName + ' ' + currentUser.LastName;

		for(QAD_Summary__c element : QADSummary)
		{
			if(element.Name == 'Orders - ready to send order confirmation emails')
			{
				String emailTemplateDeveoperName = 'Order_Order_Confirmations';
				list<EmailTemplate> emailTemplateList =[SELECT
															HtmlValue, Subject
														FROM 
															EmailTemplate 
														WHERE 
															DeveloperName = :emailTemplateDeveoperName
														LIMIT 1];

				if(emailTemplateList.size() > 0)
					SendingOrderConfirmationEmails(element, sandbox, senderEmail, senderName, emailTemplateList[0]);
				else
					SendErrorMissingEmailTemplate(emailTemplateDeveoperName, senderEmail, senderName);	
			}else
			{
				System.Debug('Apex Debug: an expecting to run???');
			}
		}

		return QADSummary;
	}

	public static void SendErrorMissingEmailTemplate (String emailTemplateDeveoperName, String senderEmail, String senderName)
	{
		LiSt<String> sendToAddresses = new list<String>();
		sendToAddresses.add('salesforce@silkroadmed.com');

		String inputDate = datetime.now().format();
		String subject = 'Missing Order Confirmation Email Template - ' + inputDate;
		String emailbody = 'Hi Administrators, <br/><br/>';
		emailbody = 'Sending order confirmations on Salesforce has an error. Missing email template: Developer email template - ' + emailTemplateDeveoperName;

    	// Step 1: Create a new Email
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();  

    	// Step 2: Set list of people who should get the email
       	mail.setToAddresses(sendToAddresses);	

    	// Step 3: Set who the email is sent from
       	mail.setReplyTo(senderEmail);
       	mail.setSenderDisplayName(senderName);

    	// Step 4. Set email contents - you can use variables!
      	mail.setSubject(subject);
      	mail.setHtmlBody(emailbody); 	

      	// Step 5. Add your email to the master list
  		mails.add(mail);

		// Step 6: Send all emails in the master list
 		Messaging.sendEmail(mails);		
	}

	public static void SendingOrderConfirmationEmails (QAD_Summary__c ListOrderID, Boolean sandbox, String senderEmail, String senderName, EmailTemplate emailOrderConfirmationTemp)
	{
		//Get all orders info (Order detail, order items list, contact, AM user, AD user)
		List<String> OrderIDs = new List<String>();
		if(ListOrderID.Reviewed_Records__c == null || ListOrderID.Reviewed_Records__c =='')
			OrderIDs.add('N/A');
		else
			OrderIDs = ListOrderID.Reviewed_Records__c.replace('<p>','').replace('</p>','').split(';');
		list<Order> orderList =[SELECT
									Id,	AccountId, Account.Name, Account.AccountNumber, Order_Date__c, QAD_so_channel__c, Remark__c, TerritoryId__r.Name,
									BillingStreet, BillingState, BillingPostalCode,	BillingCity, BillingCountry,
									ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity,
									Credit_Terms__c, FOB__c, IQMS_ORDER_NO__c, PO_Number__c, Ship_Via__c, TotalAmount
								FROM
									Order						
								Where
									Sent_Order_Confirmation_Email__c = false
									and Id in :OrderIDs
								ORDER BY 
									IQMS_ORDER_NO__c ASC
								LIMIT 63];

		list<OrderItem> OrderItemList =[SELECT
											Id, Product2.Item_Number__c, Product2.Description, QAD_sod_line__c, OrderId,
											Promise_Date__c, Unit_of_Measure__c, UnitPrice, TotalPrice, Quantity
										FROM
											OrderItem
										Where
											OrderId in :OrderIDs
										ORDER BY 
											OrderId ASC,
											QAD_sod_line__c ASC];

		List<String> AccountIDs = new list<String>();
		for(Order element : orderList)
		{
			AccountIDs.add(element.AccountId);
		}
		list<Account> accountList =[SELECT
										Id, Name, AccountNumber, Area_Director_Id__c, Area_Manager_User__c
									FROM
										Account
									Where
										Id in :AccountIDs];

		list<Contact> contactList =[SELECT
										Id, AccountId, Name, Email
									FROM
										Contact	
									Where
										Send_Order_Confirmations__c = true
										and Email != null
										and EmailBouncedReason = null
										and AccountId in :AccountIDs];

		if(sandbox)
		{
			for(Contact element : contactList)
			{
				element.Email += '.invalid';
			}
		}

		List<Id> UserIDs = new list<Id>();
		for(Account element : accountList)
		{
			UserIDs.add(element.Area_Director_Id__c);
			UserIDs.add(element.Area_Manager_User__c);
		}
		list<User> userList = [	SELECT
									Id, Email, Name
								FROM
									User
								Where
									Id in :UserIDs];


		//Get Organize wide email
		OrgWideEmailAddress cSEmailAddress = [	select
													id, Address, DisplayName 
												from 
													OrgWideEmailAddress
												where 
													Address = 'customerservice@silkroadmed.com'
												LIMIT 1];

		//Create Order Confirmation emails
		String Today = system.today().format();
		List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>(); 

		for(Order element : orderList)
		{
			Account orderAcc = new Account();
	        User orderAMUser = new User();
	        User orderADUSer = new USer();
	        list<OrderItem> orderItems = new list<OrderItem>();
	        list<Contact> contacts = new list<Contact>();

	        for(Account element1 : accountList)
	        {
	        	if(element1.Id == element.AccountId)
	        	{
	        		orderAcc = element1;
	        		break;
	        	}
	        }

	        for(User element1 : userList)
	        {
	        	if(element1.Id == orderAcc.Area_Director_Id__c)
	        	{
	        		orderADUSer = element1;
	        		break;
	        	}
	        }

	        for(User element1 : userList)
	        {
	        	if(element1.Id == orderAcc.Area_Manager_User__c)
	        	{
	        		orderAMUser = element1;
	        		break;
	        	}
	        }

	        for(OrderItem element1 : OrderItemList)
	        {
	        	if(element1.OrderId == element.Id)
	        	{
	        		orderItems.add(element1);
	        	}
	        }	        

	        for(Contact element1 : contactList)
	        {
	        	if(element1.AccountId == orderAcc.Id)
	        	{
	        		contacts.add(element1);
	        	}
	        }

	        mails.add(createOrderConfirmationEmail (element, orderAcc, orderAMUser, orderADUSer, orderItems, contacts, emailOrderConfirmationTemp, cSEmailAddress, Today, sandbox));

	        element.Sent_Order_Confirmation_Email__c = true;
		}

		//Create a pdf copy of order confirmations and attach them to related Accounts and orders
		createOrderConfirmationPDFFile(orderList);

		//Send emails and update orders
		Messaging.sendEmail(mails);
		update orderList;

	}

	public static void createOrderConfirmationPDFFile (list<Order> orderList)
	{
		//Generate the PDF copies for order confirmations
		list<ContentVersion> pdfOrderConfirmations = new list<ContentVersion>();
		String filename = '';

		//Get Time Stamp String
		String dateFormatString = 'MM-dd-yyyy HH-mm';
		String currentDateTime = system.now().format(dateFormatString);

		for(Order element: orderList)
		{
			filename = element.IQMS_ORDER_NO__c + '- ' + element.Account.AccountNumber + ' - PO#: ' + element.PO_Number__c + ' - Order Confirmation - ' + currentDateTime + '.pdf';
			if(filename.length()> 200)
			{
				filename = filename.left(190)+'.pdf';
			}
			PageReference pdfPage = new PageReference('/apex/OrderConfirmationPDFCopy');
			pdfPage.getParameters().put('OrderID', element.Id);
			blob pdfContent;
			if(Test.isRunningTest())
			{
				pdfContent = blob.valueOf('Unit.Test');
			}else
			{
				pdfContent = pdfPage.getContentAsPDF();
			}		

			ContentVersion contentVersion = new ContentVersion();
			contentVersion.ContentLocation = 'S'; // S = Stored in Salesforce
			contentVersion.Title = filename;
			contentVersion.PathOnClient = filename;
			contentVersion.VersionData = pdfContent;
			contentVersion.Description = 'Attached Order ID & Account ID-' + element.Id + '-' +	element.AccountId;

			pdfOrderConfirmations.add(contentVersion);
		}

		//Save, link PDF files
		if(pdfOrderConfirmations.size()>0)
		{
			//Save pdf file
			insert pdfOrderConfirmations;

			//Get document ID
			list<id> listId1 = new list<id>();
			for(ContentVersion element: pdfOrderConfirmations)
			{
				listId1.add(element.Id);
			}
			pdfOrderConfirmations = [SELECT Id, ContentDocumentId, Description FROM ContentVersion WHERE Id IN :listId1];

			//Create links of PDF files to Orders, Customers and 'Customer/Order Confirmation' folder (turn off creating a link to folder)
			list<ContentDocumentLink> listDocumentLinks = new list<ContentDocumentLink>();
			list<String> documentIDList = new list<String>();
			for(ContentVersion element: pdfOrderConfirmations)
			{
				//Get OrderID and AccountID from decription of file
				list<String> descriptionIds = element.Description.split('-');
				if(descriptionIds.size()> 2)
				{
					ContentDocumentLink OrderLink = new ContentDocumentLink();
					OrderLink.ContentDocumentId = element.ContentDocumentId;//Id of the file
					OrderLink.LinkedEntityId = descriptionIds[1];//Id of the record for sharing
					OrderLink.ShareType = 'V'; // Add SFDC records
					listDocumentLinks.add(OrderLink);

					ContentDocumentLink AccountLink = new ContentDocumentLink();
					AccountLink.ContentDocumentId = element.ContentDocumentId;//Id of the file
					AccountLink.LinkedEntityId = descriptionIds[2];//Id of the record for sharing
					AccountLink.ShareType = 'V'; // Add SFDC records
					listDocumentLinks.add(AccountLink);
				}
			}
			insert listDocumentLinks;
		}
	}

	public static Messaging.SingleEmailMessage createOrderConfirmationEmail(Order orderForEmail, Account orderAcc, User orderAMUser,
																			User orderADUSer, list<OrderItem> orderItems, list<Contact> contacts,
																			EmailTemplate emailOrderConfirmationTemp, OrgWideEmailAddress cSEmailAddress, String Today, Boolean sandbox)
	{
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		Boolean isSaveEmailActivity = true;

		//Initial value for null field
		if(orderForEmail.Ship_Via__c == null)
		{
			orderForEmail.Ship_Via__c = 'N/A';
		}

		if(orderForEmail.Credit_Terms__c == null)
		{
			orderForEmail.Credit_Terms__c = 'N/A';
		}

		//Set from address - wide email address/current user who trigger the apex class
		mail.setOrgWideEmailAddressId(cSEmailAddress.id);

		//Set send to / cc addresses
		List<String> sendToAddresses = new list<String>();

//Special Request: 
//CC Carolyn Mazzola email into all order confirmation emails for orders from Sacramento(Norcal) territory.
//CC Walker Kimbell email into all order confirmation emails for orders from Georgia territory.
		if(orderForEmail.TerritoryId__r.Name == 'NORCAL' || orderForEmail.TerritoryId__r.Name == 'Sacramento')
		{
			if(sandbox)
			{
				sendToAddresses.add('cmazzola@silkroadmed.com.invalid');				
			}
			else
			{
				sendToAddresses.add('cmazzola@silkroadmed.com');	
			}
		}

		if(orderForEmail.TerritoryId__r.Name == 'Georgia')
		{
			if(sandbox)
			{
				sendToAddresses.add('wkimbell@silkroadmed.com.invalid');				
			}
			else
			{
				sendToAddresses.add('wkimbell@silkroadmed.com');
			}
		}
//End of special request

		// Order confirmation for EDI order will be sent to Customer via GHX. Only send to AM and AD 
		// Order confirmation for Bill only order is only sent to AM and AD. AM will contact with customer to get the PO#
		// If an order has a valid email on the 1st part of the remark field, order confirmation will be only sent to the email address, AM and AD
		if(orderForEmail.QAD_so_channel__c != 'EDI' && ! orderForEmail.IQMS_ORDER_NO__c.contains('B'))
		{
			//Analyze remark field
			String remarkEmail = '';
			if(orderForEmail.Remark__c != null)
			{
				list<String> remarkList = orderForEmail.Remark__c.split(';');
				if(remarkList.size() > 0)
				{
					remarkList[0] = remarkList[0].replaceAll( '\\s+', '');
					if(Pattern.matches('^.*[^\\s]+.*@.*[^\\s-]+.*\\..*[^\\s-]+.*', remarkList[0]))
					{
						remarkEmail = remarkList[0];
					}
				}
			}

			if(remarkEmail != '')
			{
				isSaveEmailActivity = false;
				if(sandbox)
					remarkEmail = remarkEmail + '.invalid';
				sendToAddresses.add(remarkEmail);
			}else
			{
				for(Contact element : contacts)
				{
					sendToAddresses.add(element.Id);
				}
			}

			if(!sandbox && sendToAddresses.size() == 0)
			{
				sendToAddresses.add('customerservice@silkroadmed.com');
			}
		}

		if(orderAMUser.Email != null)
		{
			sendToAddresses.add(orderAMUser.Id);
		}

		if(sendToAddresses.size() == 0)
		{
			if(sandbox)
				sendToAddresses.add('salesforce@silkroadmed.com');
			else
				sendToAddresses.add('customerservice@silkroadmed.com');	
		}

		mail.setToAddresses(sendToAddresses);

		//Set send cc addresses keep track
		if(orderADUSer.Email != null)
		{
			List<String> ccAddresses = new list<String>();
			ccAddresses.add(orderADUSer.Id);
			if(!sandbox)
				ccAddresses.add('accountsreceivable@silkroadmed.com');
			mail.setCcAddresses(ccAddresses);
		}

		//Set send bcc address - keep track which email has been sent
		List<String> bccAddresses = new list<String>();
		bccAddresses.add('salesforce@silkroadmed.com');
		mail.setBccAddresses(bccAddresses);

		//Convert all data into String
		String dateFormatString = 'MM/dd/yyyy';
		Datetime dt = Datetime.newInstance(orderForEmail.Order_Date__c.year(), orderForEmail.Order_Date__c.month(),orderForEmail.Order_Date__c.day());
		String orderDate = dt.format(dateFormatString);

		String TotalAmount = '$ ' + String.valueOf(orderForEmail.TotalAmount.format()) + '.00';

		String SoldToAddress = '<p>';
		SoldToAddress += orderAcc.Name + '<br/>';
		SoldToAddress += orderForEmail.BillingStreet + '<br/>';
		SoldToAddress += orderForEmail.BillingCity + ', ';
		SoldToAddress += orderForEmail.BillingState + ' ';
		SoldToAddress += orderForEmail.BillingPostalCode + '<br/>';
		SoldToAddress += orderForEmail.BillingCountry + '</p>';

		String ShipToAddress = '<p>';
		ShipToAddress += orderAcc.Name + '<br/>';
		ShipToAddress += orderForEmail.ShippingStreet + '<br/>';
		ShipToAddress += orderForEmail.ShippingCity + ', ';
		ShipToAddress += orderForEmail.ShippingState + ' ';
		ShipToAddress += orderForEmail.ShippingPostalCode + '<br/>';
		ShipToAddress += orderForEmail.ShippingCountry + '</p>';

		String LineitemsTable = '';
		LineitemsTable += '<table style = "width: 100%; border: 1px solid black; border-collapse: collapse; table-layout: fixed;">';
		LineitemsTable += '<tr style = "width: 100%; border: 1px solid black; border-collapse: collapse;">';
		LineitemsTable += '<th style = "width: 2%; border: 1px solid black; border-collapse: collapse; text-align: center;">';
		LineitemsTable += 'Line </th>';
		LineitemsTable += '<th style = "width: 7%; border: 1px solid black; border-collapse: collapse; text-align: center;">';
		LineitemsTable += 'Item Number </th>';
		LineitemsTable += '<th style = "width: 14%; border: 1px solid black; border-collapse: collapse; text-align: center;">';
		LineitemsTable += 'Description </th>';
		if(orderForEmail.QAD_so_channel__c != 'EDI' && !orderForEmail.IQMS_ORDER_NO__c.contains('B'))
		{
			LineitemsTable += '<th style = "width: 5%; border: 1px solid black; border-collapse: collapse; text-align: center;">';
			LineitemsTable += 'Promise Date </th>';
		}
		LineitemsTable += '<th style = "width: 4%; border: 1px solid black; border-collapse: collapse; text-align: center;">';
		LineitemsTable += 'Qty Ordered </th>';
		LineitemsTable += '<th style = "width: 2%; border: 1px solid black; border-collapse: collapse; text-align: center;">';
		LineitemsTable += 'UOM </th>';
		LineitemsTable += '<th style = "width: 4%; border: 1px solid black; border-collapse: collapse; text-align: center;">';
		LineitemsTable += 'Price </th>';
		LineitemsTable += '<th style = "width: 4%; border: 1px solid black; border-collapse: collapse; text-align: center;">';
		LineitemsTable += 'Extended Price </th>';
		LineitemsTable += '</tr>';
		for(OrderItem element : orderItems)
        {
			LineitemsTable += '<tr style = "width: 100%; border: 1px solid black; border-collapse: collapse;">';
			LineitemsTable += '<td style = "width: 5%; border: 1px solid black; border-collapse: collapse; text-align: center;">';
			LineitemsTable += element.QAD_sod_line__c + '</td>';
			LineitemsTable += '<td style = "width: 5%; border: 1px solid black; border-collapse: collapse; text-align: center;">';
			LineitemsTable += element.Product2.Item_Number__c + '</td>';
			LineitemsTable += '<td style = "width: 5%; border: 1px solid black; border-collapse: collapse; text-align: center;">';
			LineitemsTable += element.Product2.Description.replace('[BOX]','') + '</td>';

			if(orderForEmail.QAD_so_channel__c != 'EDI' && !orderForEmail.IQMS_ORDER_NO__c.contains('B'))
			{
				LineitemsTable += '<td style = "width: 5%; border: 1px solid black; border-collapse: collapse; text-align: center;">';
				if(element.Promise_Date__c == null)
				{
					LineitemsTable += 'N/A </td>';
				}else
				{
					Datetime dt2 = Datetime.newInstance(element.Promise_Date__c.year(), element.Promise_Date__c.month(), element.Promise_Date__c.day());
					String promiseDate = dt2.format(dateFormatString);
					LineitemsTable += promiseDate + '</td>';					
				}

			}
			
			LineitemsTable += '<td style = "width: 5%; border: 1px solid black; border-collapse: collapse; text-align: center;">';
			LineitemsTable += element.Quantity + '</td>';
			LineitemsTable += '<td style = "width: 5%; border: 1px solid black; border-collapse: collapse; text-align: center;">';
			LineitemsTable += element.Unit_of_Measure__c.touppercase() + '</td>';
			LineitemsTable += '<td style = "width: 5%; border: 1px solid black; border-collapse: collapse; text-align: right; padding-right: 5px;">';
			LineitemsTable += '$ ' + String.valueOf(element.UnitPrice.format()) + '.00</td>';
			LineitemsTable += '<td style = "width: 5%; border: 1px solid black; border-collapse: collapse; text-align: right; padding-right: 5px;">';
			LineitemsTable += '$ ' + String.valueOf(element.TotalPrice.format()) + '.00</td>';
			LineitemsTable += '</tr>';
        }
        LineitemsTable += '</table>';

        String ordertype = '';
        if(orderForEmail.IQMS_ORDER_NO__c.contains('B'))
        {
        	ordertype = 'Bill-Only ';
        }else if(orderForEmail.QAD_so_channel__c == 'EDI')
        {
        	ordertype = 'GHX ';
        }

		String AMUserName = '';
		if(!String.isBlank(orderAMUser.Name))
		{
			AMUserName = orderAMUser.Name;
		}

		//Set Subject email
		String subject = emailOrderConfirmationTemp.Subject;
		subject = subject.replace('{!Order.PoNumber}', orderForEmail.PO_Number__c);
		subject = subject.replace('{!Order.IQMS_ORDER_NO__c}', orderForEmail.IQMS_ORDER_NO__c);
		subject = subject.replace('{!Order.Order_Date__c}', orderDate);
		subject = subject.replace('{!Account.AccountNumber}', orderAcc.AccountNumber);
		subject = subject.replace('{!Order.SoldToAddress}', SoldToAddress);
		subject = subject.replace('{!Order.ShipToAddress}', ShipToAddress);
		subject = subject.replace('{!AMUser.Name}', AMUserName);
		subject = subject.replace('{!Order.Ship_Via__c}', orderForEmail.Ship_Via__c);
		subject = subject.replace('{!Order.Credit_Terms__c}', orderForEmail.Credit_Terms__c);
		subject = subject.replace('{!Order.Lineitems}', LineitemsTable);
		subject = subject.replace('{!Order.TotalAmount}', TotalAmount);
		subject = subject.replace('{!Account.Name}', orderAcc.Name);
		subject = subject.replace('{!Today}', Today);
		subject = subject.replace('{!ordertype}', ordertype);

		mail.setSubject(subject);

		//Set html email body
		String emailbody = emailOrderConfirmationTemp.HtmlValue;

		emailbody = emailbody.replace('{!Order.PoNumber}', orderForEmail.PO_Number__c);
		emailbody = emailbody.replace('{!Order.IQMS_ORDER_NO__c}', orderForEmail.IQMS_ORDER_NO__c);
		emailbody = emailbody.replace('{!Order.Order_Date__c}', orderDate);
		emailbody = emailbody.replace('{!Account.AccountNumber}', orderAcc.AccountNumber);
		emailbody = emailbody.replace('{!Order.SoldToAddress}', SoldToAddress);
		emailbody = emailbody.replace('{!Order.ShipToAddress}', ShipToAddress);
		emailbody = emailbody.replace('{!AMUser.Name}', AMUserName);
		emailbody = emailbody.replace('{!Order.Ship_Via__c}',orderForEmail.Ship_Via__c);
		emailbody = emailbody.replace('{!Order.Credit_Terms__c}',orderForEmail.Credit_Terms__c);
		emailbody = emailbody.replace('{!Order.Lineitems}', LineitemsTable);
		emailbody = emailbody.replace('{!Order.TotalAmount}', TotalAmount);
		emailbody = emailbody.replace('{!Account.Name}', orderAcc.Name);
		emailbody = emailbody.replace('{!Today}', Today);
		emailbody = emailbody.replace('{!ordertype}', ordertype);

		mail.setHtmlBody(emailbody);

		//Save email into Account activites
		if(isSaveEmailActivity && contacts.size()>0 && orderForEmail.QAD_so_channel__c != 'EDI' && !orderForEmail.IQMS_ORDER_NO__c.contains('B'))
		{
	  		mail.setTargetObjectId(contacts[0].Id);
	  		mail.setSaveAsActivity(true);
		}
      	return mail;
	}
}
//System.Debug('Apex Debug: return userList' + userList.size());