public with sharing class SearchOpportunities {
    @AuraEnabled
    public static list<Opportunity> retriveOpps(String searchString) {
        String query ='select Name,Account.Name,accountid,StageName,Type,Amount from Opportunity where '; 
        if(String.isNotBlank(searchString) )

        {
            if(searchString.isNumeric()){
              query += ' Amount >= '+ decimal.valueOf(searchString);
      }
        else{
           query += ' Name like \'%'+searchString+'%\' or StageName like \'%'+searchString+'%\' or Type like \'%'+searchString+'%\' or Account.Name like \'%'+searchString+'%\'';
       }
        }                
        List<Opportunity> records = Database.query( query );
        if(records.isEmpty()) {throw new AuraHandledException('No Record Found..');}//return custom error message to component
        return records; 
}
    @AuraEnabled
    public static String sendDataRest(String selectedId){
        List<Opportunity> sendData = [select id,name,Account.name,account.id,stagename,type,amount from Opportunity where id=:selectedId];
        String payload = JSON.serialize(sendData);
        String message = '';
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        req.setHeader('Content-Type','application/json;charset=UTF-8');
        req.setBody(payload);
        Http binding = new Http();
        HttpResponse res = binding.send(req);
        Integer responseCode = res.getStatusCode();
        if(responseCode==201){
             Opportunity data=new Opportunity(id=selectedId,Integration_Status__c = 'Success',Integration_Comments__c = 'Success');
             message=  'success'; 
            update data;
         }
        else{
             Opportunity data=new Opportunity(id=selectedId,Integration_Status__c = 'failed',Integration_Comments__c = 'failed');
             message =  'failed'; 
            update data;
            }    
        return message;
    }

}