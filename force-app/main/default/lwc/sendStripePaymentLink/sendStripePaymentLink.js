import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import LightningToast from "lightning/toast";


import EMAIL_FIELD from "@salesforce/schema/Contact.Email";
const FIELDS = [EMAIL_FIELD];

export default class SendStripePaymentLink extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: "$recordId", fields: FIELDS})
    contact;

    showButton = true;
    showSpinner = false;

    get email() {
        return getFieldValue(this.contact.data, EMAIL_FIELD);
    }

    handleClick() {
        if (this.email == undefined) {
            this.showMissingEmailToast();
        } else {
            console.log('Do the thing');
            this.showButton = false;
            // this.showSpinner = true;
            
        }
    }

    async showMissingEmailToast() {
        await LightningToast.show(
        {
            label: "Missing Email",
            message: "Email is required to send a Payment Link to the Contact",
            mode: "sticky",
            variant: "error",
        },
        this,
        );
    }


}