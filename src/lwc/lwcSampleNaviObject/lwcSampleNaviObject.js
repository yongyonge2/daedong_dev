/**
 * Created by ms on 2022-07-06.
 */

import LwcComBase from "c/lwcComBase";

export default class LwcSampleNaviObject extends LwcComBase {
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