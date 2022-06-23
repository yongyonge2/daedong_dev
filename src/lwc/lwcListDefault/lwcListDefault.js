/**
 * Created by lkj on 2022-06-27.
 */

import LwcComBase from "c/lwcComBase";
import getLeads from '@salesforce/apex/LeadController.getLeads';

export default class LwcListDefault extends LwcComBase {
    leads;

    handleLoad(){
        getLeads()
            .then(data => {
                this.leads = data;
            })
            .catch(error => {
                this.doApexErrorHandle(error);
            });
    }
}