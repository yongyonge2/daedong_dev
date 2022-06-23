/**
 * Created by lkj on 2022-06-27.
 */

import LwcComBase from "c/lwcComBase";

export default class LwcModalQuickAction extends LwcComBase {
    header = '헤더입니다.';

    handleHeaderChange(event) {
        this.header = event.target.value;
    }

    handleShowModal() {
        const modal = this.template.querySelector('c-lwc-com-quick');
        modal.show();
    }

    handleCloseModal() {
        const modal = this.template.querySelector('c-lwc-com-quick');
        modal.hide();
    }

    handleSubmit(event){
        event.preventDefault();       // stop the form from submitting
        const fields = event.detail.fields;
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess(event){
        this.doToastNotification('Success', event.detail.apiName + ' 생성 완료.', 'success');
        this.handleCloseModal();
    }
}