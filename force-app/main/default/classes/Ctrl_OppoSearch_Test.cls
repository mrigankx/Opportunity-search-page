@isTest
private class Ctrl_OppoSearch_Test {
    @isTest static void testSampleSearch()
{
	Opportunity oppor=new Opportunity ();
      //oppor.id='1234';
      oppor.name='test';
      //oppor.AccountId='123456';
      oppor.Amount=2500;
      oppor.StageName='closed won';
      oppor.Type='New Customer';
	  oppor.CloseDate=Date.newInstance(2016, 12, 9);
	insert oppor;
	
	//PageReference pageRef = Page.SampleSearch;
	//pageRef.getParameters().put('query', 'test');
	//Test.setCurrentPageReference(pageRef);

	
	Ctrl_OppoSearch myclass=new Ctrl_OppoSearch();
    Ctrl_OppoSearch.selectedId='0062x000003rmucAAA';
	myclass.noOfRecords=10;
    myclass.searchName='GenePoint Standby Generator';
    myclass.searchAccount='GenePoint';
    myclass.searchStage='Closed Won';
    myclass.searchType='New Customer';
    myclass.searchAmount='85000';
    myclass.search();
    myclass.getOpps();
}
@isTest static void testPostCallout() {
    // Set mock callout class 
    Test.setMock(HttpCalloutMock.class, new customTestMockCallout()); 
    // This causes a fake response to be sent
    // from the class that implements HttpCalloutMock. 
    HttpResponse response = Ctrl_OppoSearch.sendRecord();
    // Verify that the response received contains fake values
    String contentType = response.getHeader('Content-Type');
    System.assert(contentType == 'application/json;charset=UTF-8');
    String actualValue = response.getBody();
    System.debug(response.getBody());
    String expectedValue = '{"animals": ["majestic badger", "fluffy bunny", "scary bear", "chicken", "mighty moose"]}';
    System.assertEquals(actualValue, expectedValue);
    System.assertEquals(201, response.getStatusCode());
} 
}