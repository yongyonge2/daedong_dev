/**
 * Created by ms on 2022-07-13.
 */

import LwcComBase from "c/lwcComBase";

export default class SampleToastNotification extends LwcComBase {
    titleText = 'Sample Title';
    messageText = 'Sample Message';
    variant = 'error';
    variantOptions = [
        { label: 'error', value: 'error' },
        { label: 'warning', value: 'warning' },
        { label: 'success', value: 'success' },
        { label: 'info', value: 'info' }
    ];

    titleChange(event) {
        this.titleText = event.target.value;
    }

    messageChange(event) {
        this.messageText = event.target.value;
    }

    variantChange(event) {
        this.variant = event.target.value;
    }
    showNotification(){
        this.gfn_ToastNotification(this.titleText, this.messageText, this.variant);
    }
}