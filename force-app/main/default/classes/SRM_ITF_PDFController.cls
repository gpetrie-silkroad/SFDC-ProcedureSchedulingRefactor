public without sharing class SRM_ITF_PDFController 
{
  public Inventory_Transfer_Form__c v{get;set;}
  public String srm_representative{get; set;}
  public String toAccountName{get; set;}
  public String fromAccountName{get; set;}
  public String fromLocation{get; set;}
  public String toLocation{get; set;}
  public String LogoLink{get; set;}
  public String iTFID{get; set;}
  public String iTFPDFType{get; set;}
  public List<Inventory_Transfer_Form_Transaction__c> iTFTransactions{get;set;}

  public SRM_ITF_PDFController()
  {
    Boolean sandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
    if(sandbox)
    {
      LogoLink = 'https://silkroadmed--srdevpc1--c.cs47.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682a000000jitN&operationContext=DELIVERY&contentId=05T2a000002CAL6&page=0&d=/a/2a0000008ZeK/3lUT_66UFCXvFvuHkprQsI4wP6rRa8F9B73sG_t5FXA&oid=00D2a00000094eB&dpt=null&viewId=';
    }else
    {
      LogoLink = 'https://silkroadmed--c.na77.content.force.com/servlet/servlet.ImageServer?id=0151M00000SN575&oid=00D41000002ilbW';
    }    

    if( iTFID == null || iTFID == '')
    {
      iTFID = apexpages.currentpage().getparameters().get('id');
    }

    if(iTFPDFType == null || iTFPDFType == '')
    {
      iTFPDFType = apexpages.currentpage().getparameters().get('iTFPDFType');
    }

    // iTFID = apexpages.currentpage().getparameters().get('id');
    // iTFPDFType = apexpages.currentpage().getparameters().get('iTFPDFType');
    // iTFID  = 'a0U2a000004y4J3EAI';
    // iTFPDFType  = 'MTFLogistic';

    //Get ITForm Info from Salesforce database
    v =   [	SELECT  
              id,  name,  itf_type__c,  status__c, 
              transfer_date__c,  srm_am__c, srm_am__r.FirstName, srm_am__r.LastName, srm_am__r.Employee_ID__c,
              srm_tds__c, srm_tds__r.FirstName, srm_tds__r.LastName, srm_tds__r.Employee_ID__c,
              other_qualified_srm_employee__r.FirstName, other_qualified_srm_employee__r.Employee_ID__c,
              other_qualified_srm_employee__c, other_qualified_srm_employee__r.LastName, from_rep_tds__c,
              customer_to__r.IQMS_Customer_Number__c, customer_to__r.Name, customer_from__r.IQMS_Customer_Number__c , customer_from__r.Name,
              itf_id__c,  to_rep_tds__c,  customer_to__c, summary_Used_Item__c,
              bill_only_po__c,  no_charge_po__c,  customer_from__c, pDFIDCurrentITForm__c,
              primary_bill_only_number__c,  total_price__c, editableByRepTDS__c, AutoSaveCopy__c,
              recipient_name__c,  recipient_title__c, signAttachID__c, pDFID__c,ITF_CS_Process__c,
              CustomerSignViaDocumentID__c, Owner.Name
            FROM 
              Inventory_Transfer_Form__c 
            WHERE
              Id = :iTFID];

    srm_representative = '';
    
    if(v.srm_am__c != null)
    {
        srm_representative = v.srm_am__r.FirstName + ' ' + v.srm_am__r.LastName;
    }

    if(v.srm_tds__c != null)
    {
      if(srm_representative == '')
        srm_representative = v.srm_tds__r.FirstName + ' ' + v.srm_tds__r.LastName;
      else
        srm_representative += ', ' + v.srm_tds__r.FirstName + ' ' + v.srm_tds__r.LastName;
    }
    if(v.other_qualified_srm_employee__c != null)
    {
      if(srm_representative == '')
        srm_representative = v.other_qualified_srm_employee__r.FirstName + ' ' + v.other_qualified_srm_employee__r.LastName;
      else
        srm_representative += ', ' + v.other_qualified_srm_employee__r.FirstName + ' ' + v.other_qualified_srm_employee__r.LastName;        
    }

    //Get Customers' names by using their ID on salesforce
    list<Account> tempAccount;
    toAccountName = '';
    fromAccountName = '';
    if(v.customer_to__c != null)
    {
      toAccountName = v.customer_to__r.IQMS_Customer_Number__c + ' - ' + v.customer_to__r.Name;
    }   

    if(v.customer_from__c != null)
    {           
      fromAccountName = v.customer_from__r.IQMS_Customer_Number__c + ' - ' + v.customer_from__r.Name;
    }

    iTFTransactions = [ SELECT id,  
                                name,  
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
                        WHERE inventory_transfer_form__c =: iTFID
                        ORDER BY product_number__c];

    if( iTFPDFType == 'MTFLogistic' || iTFPDFType == 'MTF-TSR-CS')
    {
      toLocation = 'RMA(12)-site:1000';

      if(v.srm_am__c != null)
      {
        fromLocation = v.srm_am__r.Employee_ID__c + ' - site: 9000';
      }
      if(v.srm_tds__c != null)
      {
        fromLocation = v.srm_tds__r.Employee_ID__c + ' - site: 9000';
      }
      if(v.other_qualified_srm_employee__c != null)
      {  
        fromLocation = v.other_qualified_srm_employee__r.Employee_ID__c + ' - site: 9000';    
      }
    }
  }
}
// System.Debug('Transaction receive1234:' + iTFPDFType);