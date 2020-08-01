public with sharing class resetIntegrationStatus {
     public static list<Opportunity> resetData(){
        List<Opportunity> sendData = new List<Opportunity>();
        for(Opportunity opp: [select id,name,Integration_Status__c,Integration_Comments__c,Account.name,account.id,stagename,type,amount from Opportunity])
        {
            opp.Integration_Status__c = '';
            opp.Integration_Comments__c = ''; 
            sendData.add(opp);
            
        }
        update sendData;
        return sendData;   
     }  
}