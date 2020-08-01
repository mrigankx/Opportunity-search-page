public class customOpportunitySearchController 
{
    public static String searchName{get;set;}
    public static String searchAccount{get;set;}
    public static String searchStage{get;set;}
    public static String searchType{get;set;}
    public static String searchAmount{get;set;}
    //private Opportunity opportunity{get;set;}
    public Boolean outputData{get;set;}
    public Integer noOfRecords{get; set;}
    public Integer size = 20;
    public ApexPages.StandardSetController setCon{get;set;}  
    public static Integer responseCode{get; set;} 
    static String errorStr = '';    
    public static String selectedId{get; set;}
    public static String sendMessage{get; set;}
    public static String serial{get; set;}
    
    
    public customOpportunitySearchController()
    {
        
    }
    
    
    public PageReference search()
    {
        try
        {
            if( String.isBlank(searchName) && String.isBlank(searchAccount) && String.isBlank(searchStage) && String.isBlank(searchType) && String.isBlank(searchAmount))
           {
                outputData = false;
                return null;
            }
            if( String.isNotBlank(searchName) || String.isNotBlank(searchAccount) || String.isNotBlank(searchStage) || String.isNotBlank(searchType) || String.isNotBlank(searchAmount))
            {
            String searchquery = 'select id,Name,Account.Name,StageName,accountid,Type,Amount from Opportunity where Name != null';
            if(String.isNotBlank(searchName) )
            {
               searchquery+=' and Name like \'%'+searchName+'%\'';
            }                
            if(String.isNotBlank(searchAccount) )
            {
                searchquery+=' and Account.Name like \'%'+searchAccount+'%\'';
            }
            if(String.isNotBlank(searchStage) )
            {
                searchquery+=' and StageName like \'%'+searchStage+'%\'';
            }
            if(String.isNotBlank(searchType) )
            {
                searchquery+=' and Type like \'%'+searchType+'%\'';
            }
            if(String.isNotBlank(searchAmount))
            {
                Decimal searchAmountDouble = decimal.valueOf(searchAmount);
                searchquery+=' and Amount = '+searchAmountDouble;
            } 
            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(searchquery));            
            if(setCon.getResultSize() > 0)
                {
                    outputData = true;
                }else{
                    outputData = false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Records Found.'));
                }  
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
        List<Opportunity> sendOpp = [select id,name,Account.name,account.id,stagename,type,amount from Opportunity where id=:selectedId];
        serial = JSON.serialize(sendOpp);
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        req.setHeader('Content-Type','application/json;charset=UTF-8');
        req.setBody(serial);
        Http binding = new Http();
        HttpResponse res = binding.send(req);
        responseCode = res.getStatusCode();
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