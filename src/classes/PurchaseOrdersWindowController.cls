/**
 * Created by olegb on 06.01.2022.
 */

public with sharing class PurchaseOrdersWindowController {
    @AuraEnabled(Cacheable=true)
    public static List<String> productNames(){
        Set<String> names = new Set<String>();
        List<Product2> products = [SELECT Id, Name FROM Product2];
        for(Product2 pr : products){names.add(pr.Name);}

        return new List<String>(names);
    }

    @AuraEnabled
    public static void createNew(Id accountId, String orderName,
            String lineName, String productName, Double unitPrice, Integer quantity){
            // створити нове замовлення
            Purchase_Orders__c order = new Purchase_Orders__c(Account__c = accountId, Name = orderName, Status__c = 'Draft');
            insert order;

            // підтягнути з бази відповідний продукт
            Product2 prod = [SELECT Id, Name FROM Product2 WHERE Name =: productName].get(0);

            // створити інформацію для замовлення
            Purchase_Orders_Line__c line = new Purchase_Orders_Line__c(
                    Purchase_Orders__c = order.Id, Product__c = prod.Id, Name = lineName,
                    Unit_Price__c = unitPrice, Quantity__c = quantity);
            insert line;
    }
}