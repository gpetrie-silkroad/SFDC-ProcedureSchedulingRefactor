public with sharing class Z_DoNotDeploy {
    public static void changeTerritories(){

        Date startDate = Date.newInstance(2019,01,01);
        Date endDate = Date.newInstance(2019,09,30);

        List<Goal__c> oldGoalList = [SELECT Id, Territory__c, TimePeriod__c, TimePeriod__r.Name, Territory__r.QAD_AM_Id__c, Territory__r.Name, 	CaseGoal__c, RevenueGoal__c FROM Goal__c 
        WHERE Territory__r.QAD_AM_Id__c = 'AM000042' AND TimePeriod__r.Name IN('2019-01',
                                                                                '2019-02',
                                                                                '2019-03',
                                                                                '2019-04',
                                                                                '2019-05',
                                                                                '2019-06',
                                                                                '2019-07',
                                                                                '2019-08',
                                                                                '2019-09')
        ORDER BY TimePeriod__r.Name];

        for(Goal__c g : oldGoalList){
            SYSTEM.DEBUG('Territory Name = [' + g.Territory__r.Name + '] Time Period [' + g.TimePeriod__r.Name + '] QAD AM Number = [' + g.Territory__r.QAD_AM_ID__c + '] Case Goal = [' + g.CaseGoal__c + '] Revenue Goal = [' + g.RevenueGoal__c +']');
        }


    }
}