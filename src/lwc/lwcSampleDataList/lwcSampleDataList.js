/**
 * Created by ms on 2022-07-06.
 */

import LwcComBase from "c/lwcComBase";
import getLeads from '@salesforce/apex/LeadController.getLeads';

export default class LwcSampleDataList extends LwcComBase {
    leads;

    handleLoad(){
        getLeads()
            .then(response => {
                this.leads = response.resData.leads;
            })
            .catch(error => {
                this.gfn_ApexErrorHandle(error);
            });
    }
}