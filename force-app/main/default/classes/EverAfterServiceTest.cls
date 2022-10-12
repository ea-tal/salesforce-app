@isTest
public with sharing class EverAfterServiceTest {
    @isTest 
    static void getDataFromEverAfterTest() {
        // Maybe should add a couple of assert equals
        Test.setMock(HttpCalloutMock.class, new EverAfterServiceMock()); 
        Test.startTest();
            System.assertEquals(1, EverAfterService.getDataFromEverAfter(null).size(), 'Number of returned records');
        Test.stopTest();
    }
}