@isTest
    private class testcustomeropportunityClas {
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
    
        
        String searchName='2500';
        SearchOpportunities.retriveOpps(searchName);
    }
    @isTest static void testPostCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new customTestMockCallout()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        String selectedId='0062x000003uy3EAAQ';
        String response = SearchOpportunities.sendDataRest(selectedId);
        // Verify that the response received contains fake values
        // String actualValue = response.getBody();
        // System.debug(response.getBody());
        // String expectedValue = '{"animals": ["majestic badger", "fluffy bunny", "scary bear", "chicken", "mighty moose"]}';
        // System.assertEquals(actualValue, expectedValue);
        // System.assertEquals(201, response.getStatusCode());
    } 
    }