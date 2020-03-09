@isTest
private class SendOrderConfirmationEmailsUnitTest 
{
	@isTest(SeeAllData=true) 
	static void test_method_one() 
	{
		Boolean sandbox = true;
		List<QAD_Summary__c> QADSummary = new List<QAD_Summary__c>();

		//Set up list of orders need to send email
		QAD_Summary__c orderList = new QAD_Summary__c();
		orderList.Name = 'Orders - ready to send order confirmation emails';
		orderList.Title__c = 'Orders - ready to send order confirmation emails';

		//Update current orders to make sure orders meet testing requirement
		List<Order> testingOrders = [Select Id, AccountId From Order Where Total_Line_Items__c > 0 LIMIT 2];
		if(testingOrders.size() > 3)
		{
			testingOrders[0].QAD_so_channel__c = 'EDI';
			testingOrders[0].IQMS_ORDER_NO__c = 'S987478';
			testingOrders[0].Sent_Order_Confirmation_Email__c = false;
			orderList.Reviewed_Records__c = testingOrders[0].Id;

			testingOrders[1].IQMS_ORDER_NO__c = 'B123456';
			testingOrders[1].Sent_Order_Confirmation_Email__c = false;
			orderList.Reviewed_Records__c += ';' + testingOrders[1].Id;

			// testingOrders[2].IQMS_ORDER_NO__c = 'S9876543';
			// testingOrders[2].Sent_Order_Confirmation_Email__c = false;
			// testingOrders[2].Remark__c = 'Test@silkroadmed.com.invalid';
			// testingOrders[2].AccountId = testingOrders[0].AccountId;
			// orderList.Reviewed_Records__c += ';' + testingOrders[2].Id;

			// testingOrders[3].IQMS_ORDER_NO__c = 'S9875365';
			// testingOrders[3].Sent_Order_Confirmation_Email__c = false;
			// testingOrders[3].QAD_so_channel__c = 'STANDARD';
			// testingOrders[3].Remark__c = '';
			// testingOrders[3].AccountId = testingOrders[0].AccountId;
			// orderList.Reviewed_Records__c += ';' + testingOrders[3].Id;
		}
		update testingOrders;

		Contact testcontact = new contact();
		testcontact.FirstName = 'Test';
		testcontact.LastName = 'SRMTestMode';
		testcontact.Email = 'Test@email.com';
		testcontact.AccountId = testingOrders[0].AccountId;
		testcontact.Send_Order_Confirmations__c = true;
		insert testcontact;

		//Set up list of error orders need to send email
		QAD_Summary__c errororderList = new QAD_Summary__c();
		errororderList.Name = 'Orders - mismatch between QAD and SFDC - not send order confirmation emails';
		errororderList.Title__c = 'Orders - mismatch between QAD and SFDC - not send order confirmation emails';
		errororderList.Ref_No__c = 1;
		errororderList.Total_Number__c = 2;
		errororderList.Reviewed_Records__c = 'N/A - apex test class';
		insert errororderList;

		//Set up email template
		list<EmailTemplate> emailTemplateList =[SELECT
													Id, Subject, HtmlValue
												FROM 
													EmailTemplate 
												WHERE 
													DeveloperName = 'Order_Order_Confirmations'];

        if(emailTemplateList.size() == 0)
        {
        	EmailTemplate testtemplate = new EmailTemplate();
	        testtemplate.DeveloperName = 'Order_Order_Confirmations';
	        testtemplate.Name = 'testtemplate';
	        testtemplate.Subject = 'N/A';
	        testtemplate.HtmlValue = 'N/A';
	        insert testtemplate;
	        emailTemplateList.add(testtemplate);
        }

		//1-1st test: call apex and pass an empty records
		QADSummary = SendOrderConfirmationEmails.SendOrderConfirmationEmailController(QADSummary);

		//1-2nd test: call apex and pass a normal records
		QADSummary.add(orderList);
		QADSummary.add(errororderList);
		QADSummary = SendOrderConfirmationEmails.SendOrderConfirmationEmailController(QADSummary);

		//1-3rd test: test send error missing email template method
		SendOrderConfirmationEmails.SendErrorMissingEmailTemplate('Missing Email Template', 'test@noemail.com', 'Tester');	

		//1-4th test: list order is empty
		QADSummary[1].Reviewed_Records__c = '';
		QADSummary = SendOrderConfirmationEmails.SendOrderConfirmationEmailController(QADSummary);	
	}

	@isTest(SeeAllData=true) 
	static void test_method_two()
	{
		//Set up list of orders need to send email
		QAD_Summary__c orderList = new QAD_Summary__c();
		orderList.Name = 'Orders - ready to send order confirmation emails';
		orderList.Title__c = 'Orders - ready to send order confirmation emails';

		//Set up email template
		list<EmailTemplate> emailTemplateList =[	SELECT
                                                        Id, Subject, HtmlValue
                                                    FROM 
                                                       EmailTemplate 
                                                    WHERE 
                                                        DeveloperName = 'Order_Order_Confirmations'];

        if(emailTemplateList.size() == 0)
        {
        	EmailTemplate testtemplate = new EmailTemplate();
	        testtemplate.DeveloperName = 'Order_Order_Confirmations';
	        testtemplate.Name = 'testtemplate';
	        testtemplate.Subject = 'N/A';
	        testtemplate.HtmlValue = 'N/A';
	        insert testtemplate;
	        emailTemplateList.add(testtemplate);
        }

		//2-1st test: test send order confirmations email - production environment
		Boolean sandbox = false;
		List<Order> testingOrders = [Select Id, AccountId From Order Where Total_Line_Items__c > 0 LIMIT 2];
		if(testingOrders.size() > 3)
		{
			testingOrders[0].QAD_so_channel__c = 'EDI';
			testingOrders[0].IQMS_ORDER_NO__c = 'S987478';
			testingOrders[0].Sent_Order_Confirmation_Email__c = false;
			orderList.Reviewed_Records__c = testingOrders[0].Id;

			testingOrders[1].IQMS_ORDER_NO__c = 'B123456';
			testingOrders[1].Sent_Order_Confirmation_Email__c = false;
			orderList.Reviewed_Records__c += ';' + testingOrders[1].Id;

			// testingOrders[2].IQMS_ORDER_NO__c = 'S9876543';
			// testingOrders[2].Sent_Order_Confirmation_Email__c = false;
			// testingOrders[2].Remark__c = 'Test@silkroadmed.com.invalid';
			// testingOrders[2].AccountId = testingOrders[0].AccountId;
			// orderList.Reviewed_Records__c += ';' + testingOrders[2].Id;

			// testingOrders[3].IQMS_ORDER_NO__c = 'S9875365';
			// testingOrders[3].Sent_Order_Confirmation_Email__c = false;
			// testingOrders[3].QAD_so_channel__c = 'STANDARD';
			// testingOrders[3].Remark__c = '';
			// testingOrders[3].AccountId = testingOrders[0].AccountId;
			// orderList.Reviewed_Records__c += ';' + testingOrders[3].Id;
		}
		update testingOrders;
		SendOrderConfirmationEmails.SendingOrderConfirmationEmails(orderList, sandbox, 'Test@test.com.invalid', 'Test', emailTemplateList[0]);
	}

	@isTest(SeeAllData=true) 
	static void test_method_three()
	{
		//Set up list of orders need to send email
		QAD_Summary__c orderList = new QAD_Summary__c();
		orderList.Name = 'Orders - ready to send order confirmation emails';
		orderList.Title__c = 'Orders - ready to send order confirmation emails';

		//Set up email template
		list<EmailTemplate> emailTemplateList =[	SELECT
                                                        Id, Subject, HtmlValue
                                                    FROM 
                                                       EmailTemplate 
                                                    WHERE 
                                                        DeveloperName = 'Order_Order_Confirmations'];

        if(emailTemplateList.size() == 0)
        {
        	EmailTemplate testtemplate = new EmailTemplate();
	        testtemplate.DeveloperName = 'Order_Order_Confirmations';
	        testtemplate.Name = 'testtemplate';
	        testtemplate.Subject = 'N/A';
	        testtemplate.HtmlValue = 'N/A';
	        insert testtemplate;
	        emailTemplateList.add(testtemplate);
        }

		//3-1st test: test send order confirmations email - sandbox environment
		Boolean sandbox = true;
		List<Order> testingOrders = [Select Id, AccountId From Order Where Total_Line_Items__c > 0 LIMIT 2];
		if(testingOrders.size() > 3)
		{
			orderList.Reviewed_Records__c = '';
			testingOrders[0].QAD_so_channel__c = 'EDI';
			testingOrders[0].IQMS_ORDER_NO__c = 'S987478123';
			testingOrders[0].Sent_Order_Confirmation_Email__c = false;
			orderList.Reviewed_Records__c = testingOrders[0].Id;

			testingOrders[1].IQMS_ORDER_NO__c = 'B1234561258';
			testingOrders[1].Sent_Order_Confirmation_Email__c = false;
			orderList.Reviewed_Records__c += ';' + testingOrders[1].Id;

			// testingOrders[2].IQMS_ORDER_NO__c = 'S9876543985';
			// testingOrders[2].Sent_Order_Confirmation_Email__c = false;
			// testingOrders[2].Remark__c = 'Test@silkroadmed.com.invalid';
			// testingOrders[2].AccountId = testingOrders[0].AccountId;
			// orderList.Reviewed_Records__c += ';' + testingOrders[2].Id;

			// testingOrders[3].IQMS_ORDER_NO__c = 'S98753654562';
			// testingOrders[3].Sent_Order_Confirmation_Email__c = false;
			// testingOrders[3].QAD_so_channel__c = 'STANDARD';
			// testingOrders[3].Remark__c = '';
			// testingOrders[3].AccountId = testingOrders[0].AccountId;
			// orderList.Reviewed_Records__c += ';' + testingOrders[3].Id;
		}
		update testingOrders;
		SendOrderConfirmationEmails.SendingOrderConfirmationEmails(orderList, sandbox, 'Test@test.com.invalid', 'Test', emailTemplateList[0]);
	}

	@isTest(SeeAllData=true) 
	static void test_method_four()
	//Test Order Confirmation PDFCopy
	{
		List<OrderItem> OrderList =[SELECT
										OrderId
									FROM
										OrderItem
									Where
										Order.Sent_Order_Confirmation_Email__c = true
									LIMIT 1];

		Test.startTest();
		PageReference pageRef = Page.OrderConfirmationPDFCopy;
		pageRef.getParameters().put('OrderID', String.valueOf(OrderList[0].OrderId));
		Test.setCurrentPage(pageRef);
        OrderConfirmationPDFCopy_Controller controller = new OrderConfirmationPDFCopy_Controller();        
		Test.StopTest();		
	} 
}