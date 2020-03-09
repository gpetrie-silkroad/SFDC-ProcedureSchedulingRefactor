public without sharing class OrderTrigger_Helper {
   public static void totalValueToGoal() {
    List<AggregateResult> arList = [SELECT Period__c pd, TerritoryId__c terr, Sum(TotalAmount) sumTotal FROM Order WHERE Period__c <> null AND TerritoryId__c <> null GROUP BY Period__c, TerritoryId__c];
    Map<String, Double> orderTotalSumMap = new Map<String, Double>();
    for(AggregateResult ar : arList){
         String territoryS = String.valueOf(ar.get('terr'));
         String periodS = String.ValueOf(ar.get('pd'));
         String keyString = territoryS + periodS;
         Double amt = Double.ValueOf(ar.get('sumTotal'));
         orderTotalSumMap.put(keyString, amt);

    }

    List<Goal__c> goalList = [SELECT TimePeriod__c, Territory__c, Actual_Order_Value__c, Id FROM Goal__c];
    for(Goal__c g : goalList){
        String territoryS = String.valueOf(g.Territory__c);
        String periodS = String.ValueOf(g.TimePeriod__c);
        String keyString = territoryS + periodS;
        g.Actual_Order_Value__c = orderTotalSumMap.get(keyString);
    }
    update goalList;
  }

  public static void incrementalValueUpdateOrDeleteToGoal(List<Order> inputOrderList){
    Set<String> keySetSet = new Set<String>();
    for(Order o : inputOrderList){
      keySetSet.add(o.KeyString__c);
    }
    
    List<AggregateResult> arList = [SELECT TerritoryId__c terr, Period__c tp, Sum(TotalAmount) sumTotal 
                    FROM Order WHERE Period__c <> null AND TerritoryId__c <> null AND KeyString__c IN: keySetSet GROUP BY TerritoryId__c, Period__c];
    Map<String, Double> orderTotalSumMap = new Map<String, Double>();
    for(AggregateResult ar : arList){
       String territoryString = String.valueOf(ar.get('terr'));
       String timePeriodString = String.valueOf(ar.get('tp'));
         String keyString = territoryString + timePeriodString;
         Double amt = Double.ValueOf(ar.get('sumTotal'));
         SYSTEM.DEBUG('KEY BUILD Key = [' + keyString + ']');
         orderTotalSumMap.put(keyString, amt);
    }

    List<Goal__c> goalList = [SELECT TimePeriod__c, Territory__c, Actual_Order_Value__c, KeyString__c, Id FROM Goal__c WHERE KeyString__c IN : keySetSet ];
    for(Goal__c g : goalList){
      String territoryString = String.valueOf(g.Territory__c);
      String timePeriodString = String.valueOf(g.TimePeriod__c);
        String keyString = territoryString + timePeriodString;
      SYSTEM.DEBUG('KEY GET KEY = [' + keyString + ']');
        if(orderTotalSumMap.get(keyString) != null){
          g.Actual_Order_Value__c = orderTotalSumMap.get(keyString);
        }
    }
    update goalList;
  }

 

  public static void setOrderPricebookFieldRepsTerritoriesTimePeriods(List<Order> oList, String operation){
    Set<Id> acctIdSet = new Set<Id>();
    Set<String> qadSlspsnSet = new Set<String>();
    Set<String> qadTimePeriodList = new Set<String>();
    for(Order o : oList){
      if(o.AccountId != null){
        acctIdSet.add(o.AccountId);
      }
      if(o.EffectiveDate != null){
        String tp = String.valueOf(o.EffectiveDate.year()) + '-';
        String mo;
        if(o.EffectiveDate.month() < 10){
          mo = '0' + String.valueOf(o.EffectiveDate.month());
        }
        else{
          mo = String.valueOf(o.EffectiveDate.month());
        }
        tp = tp + mo;
        SYSTEM.DEBUG('TIME PERIOD = [' + tp + ']');
        qadTimePeriodList.add(tp);
      }
      if(o.QAD_so_slspsn__c != null && o.QAD_so_slspsn__c!= ''){
          List<String> stringList = o.QAD_so_slspsn__c.split('-');
          qadSlspsnSet.addAll(stringList);
      }
    }

    //***************************************************************************************
    //**       GET RELEVANT PRICEBOOK INFORMATION                                          **
    //***************************************************************************************
    Id stdPriceBookId;
    if(Test.isRunningTest()){
      stdPricebookId = Test.getStandardPricebookId();
    }
    else{
      stdPriceBookId = [SELECT Id FROM Pricebook2 WHERE Name = 'Standard Price Book'][0].Id;
    }

    SYSTEM.DEBUG('STANDARD PRICEBOOK ID = [' + stdPriceBookId + ']');

    Map<Id, Id> acctToPriceList2Map = new Map<Id, Id>();
    List<Account> acctList = [SELECT Id, Price_Book__c FROM Account WHERE Id IN : acctIdSet];
    for(Account a : acctList){
      acctToPriceList2Map.put(a.Id, a.Price_Book__c);
    }

    //***************************************************************************************
    //**       GET RELEVANT TIMEPERIOD INFORMATION                                         **
    //***************************************************************************************
    Map<String, Id> tpMap = new Map<String, Id>();
    List<TimePeriods__c> tpList = [SELECT Id, Name FROM TimePeriods__c WHERE Name In : qadTimePeriodList];
    for(TimePeriods__c tp : tpList){
      tpMap.put(tp.Name, tp.Id);
    }

    // **********************************************************************
    // **   GET RELEVANT SALES REP INFORMATION FROM USER                   **
    // **********************************************************************
    //Build a map from QAD Id to SFDC.User.Ids
    Map<String, String> qad_to_sfdcUserName = new Map<String, String>();
    Map<String, String> qad_to_sfdcUserId = new Map<String, String>();

    List<User> uList = [SELECT Id, FirstName, LastName, QAD_Territory_Id__c FROM User WHERE QAD_Territory_Id__c IN : qadSlspsnSet ];
    for(User u : uList){
      qad_to_sfdcUserName.put(u.QAD_Territory_Id__c, u.FirstName + ' ' + u.LastName );
      qad_to_sfdcUserId.put(u.QAD_Territory_Id__c, u.Id);
    }


    // **********************************************************************
    // **   GET RELEVANT TERRITORY INFORMATION FROM USER                   **
    // **********************************************************************
    //Builf s map from QAD Id to Territory
    Map<String, String> qad_to_sfdcTerritoryName = new Map<String, String>();
    Map<String, Id> qad_to_sfdcTerritoryId = new Map<String, Id>();


    List<Territory__c> tList = [SELECT Id, QAD_AM_Id__c, Name FROM Territory__c WHERE QAD_AM_Id__c IN : qadSlspsnSet AND IsActive__c = TRUE];
    for(Territory__c t : tList){
      qad_to_sfdcTerritoryId.put(t.QAD_AM_Id__c, t.Id);
      qad_to_sfdcTerritoryName.put(t.QAD_AM_Id__c, t.Name);

    }

    for(Order o : oList){
      if(Operation == 'Insert' && o.Pricebook2Id == null && acctToPriceList2Map.get(o.AccountId) != null){
        o.Pricebook2Id = acctToPriceList2Map.get(o.AccountId);
      }
      else if(Operation == 'Insert' && o.Pricebook2Id == null){
        o.Pricebook2Id = stdPriceBookId;
      }
      if(o.EffectiveDate != null){
        String tp = String.valueOf(o.EffectiveDate.year()) + '-';
        String mo;
        if(o.EffectiveDate.month() < 10){
          mo = '0' + String.valueOf(o.EffectiveDate.month());
        }
        else{
          mo = String.valueOf(o.EffectiveDate.month());
        }
        tp = tp + mo;
        
        o.Period__c = tpMap.get(tp); 
      }
      List<String> sList = new List<String>();

      if(o.QAD_so_slspsn__c != null){
        //Loop through field personnel to assign to the Order Item AND assign Territory and Goal
        sList = o.QAD_so_slspsn__c.split('-');
      }

      
      Integer i = 0;
      for(String s : sList){
        i++;

        //Separate the values to determine if 'AD', 'AM', or 'TDS'
        String ad;
        String am;
        String td;

        if(s.Left(2) == 'AD' && qad_to_sfdcUserId.get(s) != null){
          ad = s;

          //o.Area_Director_Id__c = qad_to_sfdcUserId.get(ad);

        }
        else if(s.Left(2) == 'AM' && qad_to_sfdcUserId.get(s) != null){
          am = s;
          //o.Area_Manager__c = qad_to_sfdcUserId.get(am); 
          o.TerritoryId__c = qad_to_sfdcTerritoryId.get(am);
        }
        else if(s.Left(2) == 'TD' && qad_to_sfdcUserId.get(s) != null){
          td = s;    
        }
      }  
    }
  }





  public static void qad_setAccountAndAddresses(List<Order> inputOrderList){
    Set<String> acctNoSet = new Set<String>();
    Set<String> addrNoSet = new Set<String>();
    for(Order o : inputOrderList){
      if(o.QAD_so_cust_c__c != null){
        acctNoSet.add(o.QAD_so_cust_c__c);
      }
      if(o.QAD_so_bill_c__c!= null){
        addrNoSet.add(o.QAD_so_bill_c__c);
      }
      if(o.QAD_so_ship__c != null){
        addrNoSet.add(o.QAD_so_ship__c);
      }
    }
    
    Map<String, Account> accountMap = new Map<String, Account>();
    List<Account> aList = [SELECT Id, QAD_cm_addr__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, 
                    ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry
                    FROM Account WHERE QAD_cm_addr__c IN : acctNoSet];
    for(Account a : aList){
      accountMap.put(a.QAD_cm_addr__c, a);
    }

    Map<String, Account_Address__c> aaMap = new Map<String, Account_Address__c>();
    List<Account_Address__c> aaList = [SELECT Account__c, Address_Type__c, ATTN__c, City__c, Contact_Name__c, Country__c, Email__c, Ext__c, Fax__c, Id,
                          IQMS_Customer_Id__c, IQMS_Ext_Id__c, IQMS_System_Id__c, Name, Phone__c, Postal_Code__c, QAD_ad_address_id__c, QAD_ad_addr__c,
                          QAD_ad_bus_relation__c, QAD_ad_ctry__c, QAD_ad_date__c, QAD_ad_domain__c, QAD_ad_format__c, QAD_ad_lang__c, QAD_ad_mod_date__c,
                          QAD_ad_ref__c, QAD_ad_userid__c, QAD_ad__c, QAD_sourced__c, Secondary_ATTN__c, Secondary_Email__c, Secondary_Ext__c,
                          Secondary_Fax__c, Secondary_Phone__c, State_Province__c, Street_Address__c, Tax_Id__c FROM Account_Address__c WHERE QAD_ad_addr__c IN : addrNoSet AND City__c <> null];
    

    for(Account_Address__c aa : aaList){
      aaMap.put(aa.QAD_ad_addr__c, aa);

    }

    for(Order o : inputOrderList){

      Account linkedAccount = new Account();
      
      if(o.QAD_so_cust_c__c != null && accountMap.get(o.QAD_so_cust_c__c) != null){
        linkedAccount = accountMap.get(o.QAD_so_cust_c__c);
      }  
      if(o.QAD_so_cust_c__c != null && linkedAccount != null){
        o.AccountId = linkedAccount.Id;
      }
      if(o.QAD_so_bill_c__c != null && aaMap.get(o.QAD_so_bill_c__c) != null){
        Account_Address__c billAddress = aaMap.get(o.QAD_so_bill_c__c);
        o.BillingStreet = billAddress.Street_Address__c;
        o.BillingCity = billAddress.City__c;
        o.BillingState = billAddress.State_Province__c;
        o.BillingPostalCode = billAddress.Postal_Code__c;
        o.BillingCountry = billAddress.Country__c;
      }
      else if(linkedAccount != null){
        o.BillingStreet = linkedAccount.BillingStreet;
        o.BillingCity = linkedAccount.BillingCity;
        o.BillingState = linkedAccount.BillingState;
        o.BillingPostalCode = linkedAccount.BillingPostalCode;
        o.BillingCountry = linkedAccount.BillingCountry;
      }

      if(o.QAD_so_ship__c != null && aaMap.get(o.QAD_so_ship__c) != null){
        Account_Address__c shipAddress = aaMap.get(o.QAD_so_ship__c);
        o.ShippingStreet = shipAddress.Street_Address__c;
        o.ShippingCity = shipAddress.City__c;
        o.ShippingState = shipAddress.State_Province__c;
        o.ShippingPostalCode = shipAddress.Postal_Code__c;
        o.ShippingCountry = shipAddress.Country__c;
      }
      else if(linkedAccount != null){
        o.ShippingStreet = linkedAccount.ShippingStreet;
        o.ShippingCity = linkedAccount.ShippingCity;
        o.ShippingState = linkedAccount.ShippingState;
        o.ShippingPostalCode = linkedAccount.ShippingPostalCode;
        o.ShippingCountry = linkedAccount.ShippingCountry;
      }
    }
  }




  public static void handleNonPickedOrders(List<Order> inputOrderList){
    Map<Id, Date> headerShipDateMap = new Map<Id, Date>();
    for(Order o : inputOrderList){
      if(o.QAD_so_ship_date__c != null){
        headerShipDateMap.put(o.Id, o.QAD_so_ship_date__c);
      }
    }

    List<OrderItem> oiList = [SELECT OrderId, Id, Ship_Date__c FROM OrderItem WHERE OrderId IN : headerShipDateMap.keyset() AND Ship_Date__c = null];
    for(OrderItem oi : oiList){
      oi.Ship_Date__c = headerShipDateMap.get(oi.OrderId);
    }

    update oiList;
  }




  public static void qad_processBorders(List<Order> inputOrderList){
    
    Set<String> orderNumSet = new Set<String>();
    for(Order o : inputOrderList){
      if(o.IQMS_ORDER_NO__c != null && o.IQMS_ORDER_NO__c.left(1).toUpperCase() == 'B' && o.QAD_so_ship_date__c != null){
        orderNumSet.add(o.IQMS_ORDER_NO__c);
      }
    }

    List<OrderItem> oiList = [SELECT Id, Ship_Date__c, OrderNumLine__c, OrderId, Order.QAD_so_ship_date__c FROM OrderItem WHERE Order.IQMS_ORDER_NO__c IN : orderNumSet];
    for(OrderItem oi : oiList ){
      if(oi.OrderNumLine__c .left(1) != 'R'){
        oi.Ship_Date__c = oi.Order.QAD_so_ship_date__c;
      }
    }
    update oiList;
  }  
  
}