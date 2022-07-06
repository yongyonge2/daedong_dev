/**
 * Created by ms on 2022-07-06.
 */

import LwcComBase from "c/lwcComBase";

export default class LwcSampleNaviRecord extends LwcComBase {
    recordId = '00Q5i000005CGLzEAO';
    actionName = "view";

    get options() {
        return [
            { label: 'view', value: 'view' },
            { label: 'edit', value: 'edit' }
        ];
    }
    handleActionChange(event){
        this.actionName = event.detail.value;
    }
    handleRecordIdChange(event) {
        this.recordId = event.target.value;
    }

    navigationRecordPage() {
        this.gfn_NaviService({
            type: "standard__recordPage",
            attributes: {
                recordId: this.recordId,
                objectApiName: "Lead", // objectApiName is optional
                actionName: this.actionName
            }
        });
    }
}