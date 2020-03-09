public without sharing class OrderConfirmationPDFCopy_Controller {
    // public String OrderID{get; set;}
    public Order Order{get; set;}
    public String LogoLink{get; set;}
    public list<OrderItem> OrderItemList {get; set;}
    public String Today{get; set;}
    public String ordertype{get; set;}

    public OrderConfirmationPDFCopy_Controller() 
    {
        Boolean sandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        if(sandbox)
        {
            LogoLink = 'https://silkroadmed--srdevpc1--c.cs47.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682a000000jitN&operationContext=DELIVERY&contentId=05T2a000002CAL6&page=0&d=/a/2a0000008ZeK/3lUT_66UFCXvFvuHkprQsI4wP6rRa8F9B73sG_t5FXA&oid=00D2a00000094eB&dpt=null&viewId=';
        }else
        {
            LogoLink = 'https://silkroadmed--c.na77.content.force.com/servlet/servlet.ImageServer?id=0151M00000SN575&oid=00D41000002ilbW';
        } 

        Today = system.today().format();

        String OrderID = apexpages.currentpage().getparameters().get('OrderID');
        // String OrderID = '8011M000000wysGQAQ';
		Order =[SELECT
                    Id,	AccountId, Account.Name, Account.AccountNumber, Order_Date__c, QAD_so_channel__c, Remark__c,
                    BillingStreet, BillingState, BillingPostalCode,	BillingCity, BillingCountry, Account.Area_Manager_User__r.Name,
                    ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity,
                    Credit_Terms__c, FOB__c, IQMS_ORDER_NO__c, PO_Number__c, Ship_Via__c, TotalAmount
                FROM
                    Order						
                Where
                    Id = :OrderID
                ORDER BY 
                    IQMS_ORDER_NO__c ASC
                LIMIT 1];

		OrderItemList =[SELECT
                            Id, Product2.Item_Number__c, Product2.Description, QAD_sod_line__c, OrderId,
                            Promise_Date__c, Unit_of_Measure__c, UnitPrice, TotalPrice, Quantity
                        FROM
                            OrderItem
                        Where
                            OrderId = :OrderID
                        ORDER BY 
                            OrderId ASC,
                            QAD_sod_line__c ASC];

        ordertype = '';     
        if(Order.IQMS_ORDER_NO__c.contains('B'))
        {
        	ordertype = 'Bill-Only ';
        }else if(Order.QAD_so_channel__c == 'EDI')
        {
        	ordertype = 'GHX ';
        }

        for(OrderItem element: OrderItemList)
        {
            element.Unit_of_Measure__c = element.Unit_of_Measure__c.touppercase();
            element.Product2.Description = element.Product2.Description.replace('[BOX]','');
        }
    }
}
// System.Debug('Apex Debug: return userList' + Today);