public class Ctrl_OppoSearch 
{
    public  String searchName{get;set;}
    public Boolean outputData{get;set;}
    public Integer noOfRecords{get; set;}
    public Integer size = 20;
    public ApexPages.StandardSetController setCon{get;set;}  
    static String errorStr = '';    
    public static String selectedId{get; set;}
    public static String sendMessage{get; set;}
    
    
    public Ctrl_OppoSearch()
    {
        
    }
    
    
    public PageReference search()
    {
        try
        {
             String query ='select Name,Account.Name,Account_Name__c,accountid,StageName,Type,Amount from Opportunity where '; 
                 if( String.isBlank(searchName))
           {
                outputData = false;
                return null;
            }
             if(String.isNotBlank(searchName) )
        {
            if(searchName.isNumeric()){
            Decimal searchstringDouble = decimal.valueOf(searchName);
              query += ' Amount = '+searchstringDouble;
      }
        else{
           query += ' Name like \'%'+searchName+'%\' or StageName like \'%'+searchName+'%\' or Type like \'%'+searchName+'%\' or Account.Name like \'%'+searchName+'%\'';
       }
        }
            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));            
            if(setCon.getResultSize() > 0)
                {
                    outputData = true;
                }else{
                    outputData = false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Records Found.'));
                }  
            }  
        catch(Exception ex)
        {
            errorStr ='Error Occured while Searching.';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'errorStr:' +ex.getMessage()));
        }  
        return null; 
    }
    
    public List<Opportunity> getOpps() 
    {
        if(setCon.getResultSize() >0)
        {
            setCon.setPageSize(size);  
            noOfRecords = setCon.getResultSize();
            return (List<Opportunity>)setCon.getRecords();
        }else
        {
            return null;
        }
    }
    public static HttpResponse sendRecord(){
        sendMessage = '';
        List<Opportunity> sendData = [select id,name,Account.name,account.id,stagename,type,amount from Opportunity where id=:selectedId];
        String payload = JSON.serialize(sendData);
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        req.setHeader('Content-Type','application/json;charset=UTF-8');
        req.setBody(payload);
        Http binding = new Http();
        HttpResponse res = binding.send(req);
        Integer responseCode = res.getStatusCode();
        System.debug(res.getBody());
        
         if(responseCode==201){
             Opportunity data=new Opportunity(id=selectedId,Integration_Status__c = 'Success',Integration_Comments__c = 'Success');
             update data;
             sendMessage = 'Data sent successfully!';
         }
         else{
             Opportunity data=new Opportunity(id=selectedId,Integration_Status__c = 'failed',Integration_Comments__c = 'failed');
             update data;
             sendMessage = 'Data sent successfully!';
            }
        return null;
    }
      
}