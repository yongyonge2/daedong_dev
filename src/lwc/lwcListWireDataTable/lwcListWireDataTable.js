/**
 * Created by lkj on 2022-06-27.
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

export default class LwcListWireDataTable extends LwcComBase {
    columns = COLS;
    searchKey = '';
    leads;

    @wire(searchLeads, { searchKey: '$searchKey' })
    search({error, data}){
        if(data){
            this.leads = data;
        }else if(error){
            this.doApexErrorHandle(error);
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