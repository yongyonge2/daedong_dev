/**
 * Created by lkj on 2022-06-28.
 */

import {api} from 'lwc';

import LwcComBase from "c/lwcComBase";

export default class LwcDemoPageQa extends LwcComBase {
    @api showModal = false;

    @api parentTarget = [];

    @api show() {
        this.showModal = true;
    }

    @api hide() {
        this.showModal = false;
    }

    handleSubmit(event){
        event.preventDefault();       // stop the form from submitting
        const fields = event.detail.fields;
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess(event){
        this.gfn_ToastNotification('Success', event.detail.apiName + ' 생성 완료.', 'success');
        this.hide();
    }

    handleCloseModal() {
        this.hide();
    }
}