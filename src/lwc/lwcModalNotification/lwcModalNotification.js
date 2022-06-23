/**
 * Created by lkj on 2022-06-27.
 */

import {LightningElement} from 'lwc';
import LightningAlert from 'lightning/alert';
import LightningConfirm from 'lightning/confirm';
import LightningPrompt from 'lightning/prompt';

export default class LwcModalNotification extends LightningElement {
    confirmStatus;
    promptValue;

    async handleAlertClick() {
        await LightningAlert.open({
            message: 'Alert Message',
            theme: 'info',
            label: 'Alert Header'
        });
    }

    async handleConfirmClick() {
        const result = await LightningConfirm.open({
            message: 'Confirm Message',
            variant: 'headerless',
            label: 'Confirm Header'
        });

        if (result) {
            this.confirmStatus = 'Ok 클릭';
        } else {
            this.confirmStatus = 'Cancel 클릭';
        }
    }

    handlePromptClick() {
        LightningPrompt.open({
            message: 'Prompt Message',
            label: 'Prompt Header',
            defaultValue: 'Response Value.',
            theme: 'shade'
        }).then((result) => {
            //result is input text if OK clicked and null if cancel was clicked
            this.promptValue = result;
        });
    }
}