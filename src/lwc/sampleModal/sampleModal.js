/**
 * Created by ms on 2022-07-13.
 */

import {api} from 'lwc';
import LwcComBase from "c/lwcComBase";

export default class SampleModal extends LwcComBase {
    header = 'Header Area';
    @api showModal = false;

    @api show() {
        this.showModal = true;
        const footerEl = this.template.querySelector('footer');
        footerEl.classList.remove('modal-hidden');
    }

    @api hide() {
        this.showModal = false;
    }

    handleShowModal(){
       this.show();
    }


    handleSubmit(event){
        event.preventDefault();
        const fields = event.detail.fields;
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess(event){
        this.gfn_ToastNotification('Success', event.detail.apiName + ' Create Complete.', 'success');
        this.hide();
    }

    handleClose() {
        this.hide();
    }
}