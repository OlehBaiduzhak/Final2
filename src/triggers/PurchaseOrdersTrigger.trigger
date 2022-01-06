/**
 * Created by olegb on 05.01.2022.
 */

trigger PurchaseOrdersTrigger on Purchase_Orders__c (
        before insert,
        before update,
        before delete,
        after insert,
        after update,
        after delete,
        after undelete) {
        PurchaseOrdersTriggerHandler.Handle(Trigger.old, Trigger.new, Trigger.operationType);
}