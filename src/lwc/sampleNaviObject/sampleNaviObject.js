/**
 * Created by ms on 2022-07-13.
 */

import LwcComBase from "c/lwcComBase";

export default class SampleNaviObject extends LwcComBase {
    navigationObjectNew() {
        this.gfn_NaviService({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Lead',
                actionName: 'new'
            }
        });
    }

    navigationObjectList(){
        this.gfn_NaviService({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Lead',
                actionName: 'list'
            },
            state: {
                filterName: 'Recent'
            }
        });
    }
}