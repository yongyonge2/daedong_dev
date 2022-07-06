/**
 * Created by ms on 2022-07-04.
 */

import {api, wire} from 'lwc';
import getCampaignRecord from '@salesforce/apex/LwcDemoController.getCampaignMemberList';
import LwcComBase from "c/lwcComBase";

const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' },
];

const COLS = [
    { label:'Campaign Name', fieldName:'URL',
        type:'url',
        typeAttributes: {
            label: {
                fieldName:'Name'
            }
        },
        target:'_blank',
        hideDefaultActions: true
    },
    {label : 'Start Date', fieldName : 'StartDate', type: 'date', hideDefaultActions: true},
    {label : 'Type', fieldName : 'Type', hideDefaultActions: true},
    {label : 'Status', fieldName : 'Status', hideDefaultActions: true},
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    }
]


export default class LwcDemoRelatedList extends LwcComBase {
    @api recordId;
    campaignMembers;
    columns = COLS;
    title;
    url;

    connectedCallback() {
        this.doInit();
    }

    doInit(){
        this.url = '/lightning/r/Lead/'+ this.recordId +'/related/CampaignMembers/view'
    }

    @wire(getCampaignRecord,{recordId: '$recordId'})
    wiredCampaigns({ error, data }) {
        if (data) {
            let baseURL = location.origin+'/';
            let fixedData = [];
            console.log(data.resData.campaignMembers);
            this.title = 'Campaign History ('+data.resData.count+')';
            data.resData.campaignMembers.forEach(campaignMember => {
                let dataLine = {};
                dataLine.Id = campaignMember.Id;
                dataLine.Name = campaignMember.Campaign.Name;
                dataLine.StartDate = campaignMember.Campaign.StartDate;
                dataLine.Type = campaignMember.Campaign.Type;
                dataLine.Status = campaignMember.Status;
                dataLine.URL = baseURL + campaignMember.Id;
                fixedData.push(dataLine);
            });
            console.log(fixedData);
            this.campaignMembers = fixedData;

        } else if (error) {
            this.gfn_ApexErrorHandle(error);
        }
    }

    handleShowModal(){

    }

    handleRowAction(event) {

    }
}