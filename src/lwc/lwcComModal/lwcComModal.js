/**
 * Created by ms on 2022-07-11.
 */

import {api} from 'lwc';
import LwcComBase from "c/lwcComBase";

export default class LwcComModal extends LwcComBase {
    @api header;

    hasHeader = this.header !== '';

    handleSlotFooterChange() {
        const footerEl = this.template.querySelector('footer');
        footerEl.classList.remove('modal-hidden');
    }

    handleClose(){
        this.dispatchEvent(new CustomEvent('close'));
    }
}