/**
 * Created by lkj on 2022-06-27.
 */

import {LightningElement} from 'lwc';
import LwcComBase from "c/lwcComBase";
import getLeads from '@salesforce/apex/LeadController.getLeads';

const COLS = [
    {label : 'Name', fieldName : 'Name'},
    {label : 'Title', fieldName : 'Title'},
    {label : 'Company', fieldName : 'Company'},
    {label : 'Phone', fieldName : 'Phone'},
    {label : 'Mobile', fieldName : 'MobilePhone'},
    {label : 'Email', fieldName : 'Email'},
    {label : 'Lead Status', fieldName : 'Status'}
]

export default class LwcListDataTable extends LwcComBase {
    columns = COLS;
    leads;

    connectedCallback() {
        this.init();
    }

    init(){
        getLeads()
            .then(data => {
                this.leads = data;
            })
            .catch(error => {
                this.doApexErrorHandle(error);
            });
    }
}