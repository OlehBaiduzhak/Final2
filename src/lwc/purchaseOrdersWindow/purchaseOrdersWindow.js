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

    inputOrderName= '';

    inputQuantity= '';
    inputLineName= '';
    inputUnitPrice= '';
    inputProductName= '';

    isError = false;
    validProductName = false;

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

    save(){

        this.isError = false;
        this.validProductName = false;

        if(this.inputOrderName == '') {
            this.isError = true;
        }
        if(this.inputLineName == '') {
            this.isError = true;
        }

        for(let x in this.names.data){
            if(this.names.data[x] === this.inputProductName) this.validProductName = true;
        }
        if(!this.validProductName){
            this.isError = true;
            const wrongProductName = new ShowToastEvent({
                title: "Error",
                message: "Product with than name was not found "+this.validProductName,
                variant: "error"
            });
            this.dispatchEvent(wrongProductName);
        }
        if(this.inputQuantity == '' || +this.inputQuantity <= 0) {
            this.isError = true;
        }
        if(this.inputUnitPrice == '' || +this.inputUnitPrice <= 0) {
            this.isError = true;
        }

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
        else {

            createNew({accountId: this.recordId, orderName: this.inputOrderName,
                lineName: this.inputLineName, productName:this.inputProductName,
                quantity: this.inputQuantity, unitPrice: this.inputUnitPrice})
                .then(() =>{

            }).catch(() =>{

            }).finally(()=>{
                this.dispatchEvent(new CloseActionScreenEvent());
            })

        }
    }

    cancel(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}