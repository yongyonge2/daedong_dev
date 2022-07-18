/**
 * Created by ms on 2022-07-13.
 */

import {api, wire} from 'lwc';
import getRecords from '@salesforce/apex/SampleController.getCampaignMembers';
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

export default class SampleComponent extends LwcComBase {
    @api recordId;
    campaignMembers;
    columns = COLS;
    title;
    url;
    iconName;

    connectedCallback() {
        this.doInit();
    }

    doInit(){
        this.url = '/lightning/r/Lead/'+ this.recordId +'/related/CampaignMembers/view'
        this.iconName = 'standard:campaign_members';
    }

    @wire(getRecords,{recordId: '$recordId'})
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

    handleShowModal(event) {
        this.gfn_ShowModal(event.target.dataset.name);
    }
}