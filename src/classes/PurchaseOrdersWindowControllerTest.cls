
@IsTest
private class PurchaseOrdersWindowControllerTest {
    @TestSetup static void setup(){

        Account account = new Account(Name = 'Test Account');
        insert account;

        Product2 product2 = new Product2(Name = 'Test Product', In_The_Stock__c = 10);
        insert product2;
    }
    @IsTest
    static void testProductNames() {
        Test.startTest();
        List<String> names = PurchaseOrdersWindowController.productNames();
        Test.stopTest();

        System.assert((names.size() == 1) && (names.get(0) == 'Test Product'));
    }
    @IsTest
    static void testCreateNew(){
        Id accId = [SELECT Id FROM Account].get(0).Id;

        Test.startTest();
        PurchaseOrdersWindowController.createNew(
                accId, 'Test Order', 'Test Line', 'Test Product', 5, 10);
        Test.stopTest();

        Purchase_Orders__c order = [
                SELECT Id, Status__c, (
                        SELECT Id, Quantity__c, Product__c
                        FROM Purchase_Orders_Lines__r)
                FROM Purchase_Orders__c WHERE Name =: 'Test Order'].get(0);

        Purchase_Orders_Line__c line = [
                SELECT Id, Name, Product__c, Quantity__c FROM Purchase_Orders_Line__c
                WHERE Name =: 'Test Line'].get(0);

        List<Product2> products = [SELECT Id, In_The_Stock__c FROM Product2
                WHERE Id =: line.Product__c];

        System.assert(order.Status__c == 'Draft');
        System.assert(line.Quantity__c == 10);
        System.assert(products.size() == 1);

    }
}