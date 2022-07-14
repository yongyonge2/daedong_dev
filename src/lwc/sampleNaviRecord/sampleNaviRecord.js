/**
 * Created by ms on 2022-07-13.
 */

import {wire} from 'lwc';
import LwcComBase from "c/lwcComBase";
import getRecordId from '@salesforce/apex/I2ComUtil.getRecordId';

export default class SampleNaviRecord extends LwcComBase {
    recordId;
    actionName = "view";

    @wire(getRecordId, {objName : 'Lead'})
    wireRecordId(response){
        if(response.data){
            this.recordId = response.data;
        }else if(response.error){
            this.gfn_ApexErrorHandle(response.error);
        }
    }

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