/**
 * Created by olegb on 05.01.2022.
 */

public with sharing class PurchaseOrdersTriggerHandler {
    public static void Handle(List<Purchase_Orders__c> oldR, List<Purchase_Orders__c> newR, TriggerOperation triggerOperation){
        switch on triggerOperation
        {
            when AFTER_UPDATE
            {
                CheckStateAndChangeInStockAU(oldR, newR);
            }
        }
    }

    private static void CheckStateAndChangeInStockAU(List<Purchase_Orders__c> oldR, List<Purchase_Orders__c> newR){
        List<Id> completed = new List<Id>();

        for(Integer i =0; i< oldR.size(); ++i){
            if((oldR.get(i).Status__c == 'Draft') && (newR.get(i).Status__c == 'Completed')){
                completed.add(newR.get(i).Id);
            }
        }

        List<Purchase_Orders__c> orders = new List<Purchase_Orders__c>(
        [SELECT Id, Status__c, (SELECT Id, Quantity__c, Product__c FROM Purchase_Orders_Lines__r)
        FROM Purchase_Orders__c WHERE Id IN :completed]);

        List<Id> prodId = new List<Id>();

        for(Purchase_Orders__c ord : orders){
            prodId.add(ord.Purchase_Orders_Lines__r.get(0).Product__c);
        }

        Map<Id,Product2> prod = new Map<Id,Product2>(
        [SELECT Id, In_The_Stock__c FROM Product2 WHERE Id IN :prodId]);

        for(Purchase_Orders__c ord : orders){
            prod.get(ord.Purchase_Orders_Lines__r.get(0).Product__c).In_The_Stock__c =
                    prod.get(ord.Purchase_Orders_Lines__r.get(0).Product__c).In_The_Stock__c
                            + ord.Purchase_Orders_Lines__r.get(0).Quantity__c;
        }

        update prod.values();

    }
}