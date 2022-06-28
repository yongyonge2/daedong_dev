/**
 * Created by lkj on 2022-06-27.
 */

import LwcComBase from "c/lwcComBase";

export default class LwcNavigationObject extends LwcComBase {
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