/**
 * Created by ms on 2022-07-06.
 */

import {wire} from 'lwc';
import LwcComBase from "c/lwcComBase";
import searchLeads from '@salesforce/apex/LeadController.searchLeads';

const DELAY = 300;
const COLS = [
    {label : 'Name', fieldName : 'Name'},
    {label : 'Title', fieldName : 'Title'},
    {label : 'Company', fieldName : 'Company'},
    {label : 'Phone', fieldName : 'Phone'},
    {label : 'Mobile', fieldName : 'MobilePhone'},
    {label : 'Email', fieldName : 'Email'},
    {label : 'Lead Status', fieldName : 'Status'}
]

export default class LwcSampleDataTableWire extends LwcComBase {
    columns = COLS;
    searchKey = '';
    leads;

    @wire(searchLeads, { searchKey: '$searchKey' })
    search(response){
        if(response.data){
            this.leads = response.data.resData.leads;
        }else if(response.error){
            this.gfn_ApexErrorHandle(response.error);
        }
    };


    handleKeyChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;

        this.delayTimeout = setTimeout(() => {
            this.searchKey = searchKey;
        }, DELAY);
    }
}