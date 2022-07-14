/**
 * Created by ms on 2022-07-13.
 */

import LwcComBase from "c/lwcComBase";
import getRecords from '@salesforce/apex/SampleController.getLeads';

const COLS = [
    {label : 'Name', fieldName : 'Name'},
    {label : 'Title', fieldName : 'Title'},
    {label : 'Company', fieldName : 'Company'},
    {label : 'Phone', fieldName : 'Phone'},
    {label : 'Mobile', fieldName : 'MobilePhone'},
    {label : 'Email', fieldName : 'Email'},
    {label : 'Lead Status', fieldName : 'Status'}
]

export default class SampleDataTable extends LwcComBase {
    columns = COLS;
    leads;

    connectedCallback() {
        this.init();
    }

    init(){
        getRecords({ searchKey: '' })
            .then(response => {
                this.leads = response.resData.leads;
            })
            .catch(error => {
                this.gfn_ApexErrorHandle(error);
            });
    }
}