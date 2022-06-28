/**
 * Created by lkj on 2022-06-27.
 */

import {wire} from 'lwc';
import LwcComBase from "c/lwcComBase";
import getLeadRecord from '@salesforce/apex/LwcDemoPageController.getRecord';
import deleteLeadRecord from '@salesforce/apex/LwcDemoPageController.deleteRecord';
import {refreshApex} from "@salesforce/apex";

const COLS = [
    {label : 'Name', fieldName : 'Name'},
    {label : 'Title', fieldName : 'Title'},
    {label : 'Company', fieldName : 'Company'},
    {label : 'Phone', fieldName : 'Phone'},
    {label : 'Mobile', fieldName : 'MobilePhone'},
    {label : 'Email', fieldName : 'Email'},
    {label : 'Lead Status', fieldName : 'Status'},
    {label : '보기', type: "button", initialWidth: 100, typeAttributes: {
            label: 'View',
            name: 'view',
            title: 'view',
            disabled: false,
            value: 'view',
            iconPosition: 'center'
    }}
]

export default class LwcDemoPage extends LwcComBase {
    columns = COLS;
    searchKey = '';
    inputKey = '';
    selectedRows = [];
    selectedRecords = [];
    refreshTable;

    connectedCallback() {
        this.doInit();
    }

    doInit(){

    }

    @wire(getLeadRecord,{searchKey : '$searchKey'})
    wireGetRecord(result){
        this.gfn_ShowSpinner();
        if(result.data){
            this.refreshTable = result;
            this.recordList = result.data.recordList;
        }else if(result.error){
            this.gfn_ApexErrorHandle(result.error);
        }
        setTimeout(() => {
            this.gfn_HideSpinner();
        }, 300);
    }

    handleKeyChange(event) {
        this.inputKey = event.target.value;
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        this.gfn_NaviService({
            type: 'standard__recordPage',
            attributes: {
                recordId: row.Id,
                objectApiName: 'Lead', // objectApiName is optional
                actionName: actionName
            }
        })

    }

    doSearchRecord(){
        this.searchKey = this.inputKey;
    }

    doDeleteRecord(event){
        event.preventDefault();
        this.selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows();
        if(this.selectedRecords.length > 0 ){
            this.gfn_Confirm('삭제 확인','선택된 문서를 삭제하시겠습니까?','headerless')
                .then(result => {
                    if(result){
                        this.gfn_ShowSpinner();
                        deleteLeadRecord({delLead: this.selectedRecords})
                            .then(data=>{
                                this.selectedRows = [];
                                this.gfn_ToastNotification("Success", "삭제 완료", "success");
                                refreshApex(this.refreshTable);
                            })
                            .catch(error=>{
                                this.gfn_ApexErrorHandle(error);
                            })
                        setTimeout(() => {
                            this.gfn_HideSpinner();
                        }, 300);
                    }
                });
        }else{
            this.gfn_Alert('경고','선택된 문서가 없습니다', 'warning');
        }
    }

    doShowModal() {
        this.gfn_ShowModal('demoQa');
    }
}