/**
 * Created by olegb on 06.01.2022.
 */

import {LightningElement, api, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createNew from '@salesforce/apex/PurchaseOrdersWindowController.createNew'
import productNames from '@salesforce/apex/PurchaseOrdersWindowController.productNames'
import {CloseActionScreenEvent} from "lightning/actions";

export default class PurchaseOrdersWindow extends LightningElement {

    @api recordId;

    inputOrderName;

    inputQuantity;
    inputLineName;
    inputUnitPrice;
    inputProductName;

    isError;

    @wire(productNames, {})
    names;

    handleInputOrderNameChange(event){
        this.inputOrderName = event.target.value;
    }

    handleInputQuantityChange(event){
        this.inputQuantity = event.target.value;
    }

    handleInputLineNameChange(event){
        this.inputLineName = event.target.value;
    }

    handleInputUnitPriceChange(event){
        this.inputUnitPrice = event.target.value;
    }

    handleInputProductNameChange(event){
        this.inputProductName = event.target.value;
    }

    check(){
        const toastEvent2 = new ShowToastEvent({
            title: "Check",
            message: this.recordId + this.inputOrderName + this.inputLineName +
                this.inputProductName + this.inputQuantity + this.inputUnitPrice+ this.names.data,
            variant: "error"
        });
        this.dispatchEvent(toastEvent2);



        if(this.isError){
            const toastEvent = new ShowToastEvent({
                title: "Error",
                message: "Something gone wrong " +
                    "Check if " +
                    "all fields are populated " +
                    "numbers are greater than 0 " +
                    "Product with that name exist ",
                variant: "error"
            });
            this.dispatchEvent(toastEvent);
        }
    }

    save(){

        createNew({accountId: this.recordId, orderName: this.inputOrderName,
            lineName: this.inputLineName, productName:this.inputProductName,
            quantity: this.inputQuantity, unitPrice: this.inputUnitPrice});

        this.dispatchEvent(new CloseActionScreenEvent());
    }

}