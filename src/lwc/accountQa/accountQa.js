/**
 * Created by ms on 2022-07-18.
 */

import {api, wire} from 'lwc';
import LwcComBase from "c/lwcComBase";
import getRecords from '@salesforce/apex/AccountController.getContact';


const COLS = [
    {label : '이름', fieldName : 'Name'},
    {label : '타이틀', fieldName : 'Title'}
]

export default class AccountQa extends LwcComBase {
    @api recordId;
    accountId;
    columns = COLS
    contacts;

    renderedCallback() {
        if(this.recordId != null && this.recordId != undefined){
            this.accountId = this.recordId;
        }
    }

    @wire(getRecords, {accountId: '$accountId'})
    wiredGetRecords({data, error}){
        if(data){
            this.contacts = data.resData.contacts;
        }else if(error){
            this.gfn_ApexErrorHandle(response.error);
        }
    };


    handleClose(){
        this.gfn_QaClose();
    }

}