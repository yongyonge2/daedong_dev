/**
 * Created by ms on 2022-07-06.
 */

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

export default class LwcSampleDataTable extends LwcComBase {
    columns = COLS;
    leads;

    connectedCallback() {
        this.init();
    }

    init(){
        getLeads()
            .then(response => {
                this.leads = response.resData.leads;
            })
            .catch(error => {
                this.gfn_ApexErrorHandle(error);
            });
    }
}