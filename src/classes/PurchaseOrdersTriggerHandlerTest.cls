
@IsTest
private class PurchaseOrdersTriggerHandlerTest {
    @TestSetup static void setup(){
        Account account = new Account(Name = 'Test Account');
        insert account;

        Product2 product2 = new Product2(Name = 'Test Product',In_The_Stock__c = 10);
        insert product2;

        Purchase_Orders__c purchaseOrders = new Purchase_Orders__c(
                Account__c = account.Id, Name = 'Test PO', Status__c = 'Draft');
        insert purchaseOrders;

        Purchase_Orders_Line__c purchaseOrdersLine = new Purchase_Orders_Line__c(
                Purchase_Orders__c = purchaseOrders.Id, Product__c = product2.Id,
                Name = 'Test POL', Unit_Price__c = 5, Quantity__c = 10
        );
        insert purchaseOrdersLine;

    }
    @IsTest
    static void testUpdatePositive() {
        Purchase_Orders__c order = [SELECT Id,Status__c FROM Purchase_Orders__c].get(0);
        order.Status__c = 'Completed';

        Test.startTest();
        update order;
        Test.stopTest();

        Purchase_Orders__c checkOrder = [
                SELECT Id, Status__c, (
                        SELECT Id, Quantity__c, Product__c
                        FROM Purchase_Orders_Lines__r)
        FROM Purchase_Orders__c].get(0);

        Id changedProduct2Id = checkOrder.Purchase_Orders_Lines__r.get(0).Product__c;

        Product2 changedProduct2 = [SELECT Id, In_The_Stock__c FROM Product2 WHERE Id =: changedProduct2Id];

        System.assert(changedProduct2.In_The_Stock__c == 20);

    }
    @IsTest
    static void testUpdateNoStatusChange() {
        Purchase_Orders__c order = [SELECT Id,Status__c FROM Purchase_Orders__c].get(0);
        order.Name = 'Test PO Changed';

        Test.startTest();
        update order;
        Test.stopTest();

        Purchase_Orders__c checkOrder = [
                SELECT Id, Status__c, (
                        SELECT Id, Quantity__c, Product__c
                        FROM Purchase_Orders_Lines__r)
                FROM Purchase_Orders__c].get(0);

        Id changedProduct2Id = checkOrder.Purchase_Orders_Lines__r.get(0).Product__c;

        Product2 changedProduct2 = [SELECT Id, In_The_Stock__c FROM Product2 WHERE Id =: changedProduct2Id];

        System.assert(changedProduct2.In_The_Stock__c == 10);

    }
}