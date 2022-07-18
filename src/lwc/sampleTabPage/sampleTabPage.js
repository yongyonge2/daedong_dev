/**
 * Created by ms on 2022-07-13.
 */

import {wire, api} from 'lwc';
import LwcComBase from "c/lwcComBase";
import getRecords from '@salesforce/apex/SampleController.getLeads';
import deleteRecord from '@salesforce/apex/SampleController.deleteLead';
import {refreshApex} from "@salesforce/apex";

const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' },
];

const COLS = [
    { label:'Name',                  fieldName:'URL',
        type:'url',
        typeAttributes: {
            label: {
                fieldName:'Name'
            }
        },
        target:'_self'
    },
    {label : 'Title', fieldName : 'Title'},
    {label : 'Company', fieldName : 'Company'},
    {label : 'Phone', fieldName : 'Phone'},
    {label : 'Mobile', fieldName : 'MobilePhone'},
    {label : 'Email', fieldName : 'Email', type : "email"},
    {label : 'Lead Status', fieldName : 'Status'},
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    }
]

export default class SampleTabPage extends LwcComBase {
    columns = COLS;
    searchKey = '';
    inputKey = '';
    selectedRows = [];
    leads;
    resultInfo;
    refreshTable;

    @api showModal = false;

    connectedCallback() {
        this.doInit();
    }

    doInit(){

    }

    @wire(getRecords,{searchKey : '$searchKey'})
    wireGetRecord(response){
        this.gfn_ShowSpinner();
        if(response.data){
            let baseURL = location.origin+'/';
            let fixedData = [];
            this.refreshTable = response;
            this.resultInfo = {
                'lastModifiedDate' : this.gfn_isEmpty(response.data.resData.info[0].LastModifiedDate) ? new Date() : new Date(response.data.resData.info[0].LastModifiedDate),
                'count' : response.data.resData.count
            };

            response.data.resData.leads.forEach(lead => {
                let dataLine = {};
                dataLine.Id = lead.Id;
                dataLine.Name = lead.Name;
                dataLine.Title = lead.Title;
                dataLine.Company = lead.Company;
                dataLine.Phone = lead.Phone;
                dataLine.MobilePhone = lead.MobilePhone;
                dataLine.Email = lead.Email;
                dataLine.Status = lead.Status;
                dataLine.URL = baseURL + lead.Id;
                fixedData.push(dataLine);
            });
            this.leads = fixedData;
        }else if(response.error){
            this.gfn_ApexErrorHandle(response.error);
        }
        setTimeout(() => {
            this.gfn_HideSpinner();
        }, 300);
    }

    handleKeyChange(event) {
        this.inputKey = event.target.value;
    }

    handleKeyPress(event){
        if (event.keyCode == 13){
            this.searchKey = this.inputKey;
        }
    }

    handleBlur(event) {
        this.searchKey = event.target.value;
    }
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if(actionName == 'delete'){
            this.gfn_Confirm('삭제 확인','선택된 문서를 삭제하시겠습니까?','headerless')
                .then(result => {
                    if(result){
                        this.gfn_ShowSpinner();
                        console.log(row.Id);
                        deleteRecord({recordId: row.Id})
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
            this.gfn_NaviService({
                type: 'standard__recordPage',
                attributes: {
                    recordId: row.Id,
                    objectApiName: 'Lead', // objectApiName is optional
                    actionName: actionName
                }
            })
        }
    }

    handleShowModal(event) {
        this.gfn_ShowModal(event.target.dataset.name);
    }
}