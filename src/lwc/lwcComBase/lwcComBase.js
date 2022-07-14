/**
 * Created by lkj on 2022-06-21.
 */

import {LightningElement, api, track, wire} from 'lwc';

import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { CloseActionScreenEvent } from "lightning/actions";

import FORM_FACTOR from '@salesforce/client/formFactor';
import Id from '@salesforce/user/Id';
import ProfileName from '@salesforce/schema/User.Profile.Name';

import LightningAlert from 'lightning/alert';
import LightningConfirm from 'lightning/confirm';
import LightningPrompt from 'lightning/prompt';

export default class LwcComBase extends NavigationMixin(LightningElement) {

    // isDeskTop 여부
    device = FORM_FACTOR;
    isDeskTopOrTablet = FORM_FACTOR == 'Large' || FORM_FACTOR == 'Medium';

    // User Profile 처리
    userId = Id;
    userProfile;

    // Spinner 처리
    @api isSpinner = false;

    // Page Type 처리
    @api isComponent = false;
    @api isTab = false;

    connectedCallback() {
        this.init();
    }

    init() {

    }

    @wire(getRecord, { recordId: Id, fields: [ProfileName] })
    userDetails({ error, data }) {
        if (error) {
            this.gfn_ApexErrorHandle(error);
        } else if (data) {
            if (data.fields.Profile.value != null) {
                this.userProfile = data.fields.Profile.value.fields.Name.value;
            }
        }
    }

    gfn_ApexErrorHandle(error) {
        let errors = Array.isArray(error) || [error];
        let errorMessages = errors.filter(error => !!error).map(function(error) {
            // UI API read errors
            if (Array.isArray(error.body)) {
                return error.body.map(function(e) { return e.message; });
            }
            // UI API DML, Apex and network errors
            else if (error.body && typeof error.body.message === 'string') {
                return error.body.message;
            }
            // JS errors
            else if (typeof error.message === 'string') { return error.message; }
            // Unknown error shape so try HTTP status text
            return error.statusText || error;
        }).filter(function(message) { return  !!message; });

        let toastErrorMessage = errorMessages.join(', ');

        //============================================================================
        // log 처리와 toast 처리
        //============================================================================
        console.error(toastErrorMessage);
        this.gfn_ToastNotification('Error', toastErrorMessage, 'e');
    }

    /**
     * Toast Message
     * @param title
     * @param msg
     * @param type
     * @param mode
     */

    gfn_ToastNotification(title, msg, type){
        const evt = new ShowToastEvent({
            title   : title,
            message : msg,
            variant : type
        });
        this.dispatchEvent(evt);
    }

    /**
     * spinner Show
     */
    gfn_ShowSpinner(){
        this.isSpinner = true;
    }

    /**
     * spinner Hide
     */
    gfn_HideSpinner(){
        this.isSpinner = false;
    }

    gfn_Alert(label, message, theme) {
        LightningAlert.open({
            message: message,
            theme: theme,
            label: label
        });
    }

    async gfn_Confirm(label, message, variant) {
        return await LightningConfirm.open({
            message: message,
            variant: variant,
            label: label
        });
    }

    async gfn_Prompt(label, message, defaultValue, theme) {
        return LightningPrompt.open({
            message: message,
            label: label,
            defaultValue: defaultValue,
            theme: theme
        });
    }

    gfn_ShowModal(target){
        const modal = this.template.querySelector('[data-id='+target+']');
        modal.show();
    }

    /**************************************************** ***********************************************************/








    /************************************************ Service *******************************************************/
    /**
     * Object list를 넘기면 해당하는 object의 label정보를 가져옴. (다국어 지원)
     *
     * @param component
     * @param event
     * @param helper
     */

    gfn_NaviService(params) {
        this[NavigationMixin.Navigate](params);
    }

    /**************************************************** ***********************************************************/

    gfn_isEmpty(value) {
        if (value === undefined || value === null || value === "") {
            return true;
        }

        if (Array.isArray(value)) {
            return value.length === 0;
        } else if (typeof value === "object" && Object.prototype.toString.call(value) === "[object Object]") {
            return Object.keys(value).length === 0;
        }

        return false;
    }

    gfn_QaSubmit(event){
        event.preventDefault();
        const fields = event.detail.fields;
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    gfn_QaSuccess(event){
        this.gfn_ToastNotification('Success', event.detail.apiName + ' 생성 완료.', 'success');
        this.gfn_QaClose();
    }

    gfn_QaClose() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

}