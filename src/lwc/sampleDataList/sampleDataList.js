/**
 * Created by ms on 2022-07-13.
 */

import LwcComBase from "c/lwcComBase";
import getRecords from '@salesforce/apex/SampleController.getLeads';

export default class SampleDataList extends LwcComBase {
    leads;

    handleLoad(){
        getRecords({ searchKey: '' })
            .then(data => {
                this.leads = data.resData.leads;
            })
            .catch(error => {
                this.gfn_ApexErrorHandle(error);
            });
    }
}