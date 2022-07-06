/**
 * Created by ms on 2022-07-06.
 */

import LwcComBase from "c/lwcComBase";
import {api} from 'lwc';
export default class LwcSampleModalQa extends LwcComBase {
    header = '헤더영역!';

    @api showModal = false;
    handleHeaderChange(event) {
        this.header = event.target.value;
    }

    handleShowModal() {
        this.showModal = true;
    }

    handleCloseModal() {
        this.showModal = false;
    }

    handleSubmit(event){
        event.preventDefault();       // stop the form from submitting
        const fields = event.detail.fields;
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess(event){
        this.gfn_ToastNotification('Success', event.detail.apiName + ' 생성 완료.', 'success');
        this.handleCloseModal();
    }
}