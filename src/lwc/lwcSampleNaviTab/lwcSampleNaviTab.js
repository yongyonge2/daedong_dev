/**
 * Created by ms on 2022-07-06.
 */

import LwcComBase from "c/lwcComBase";

export default class LwcSampleNaviTab extends LwcComBase {
    navigationNamedPage() {
        this.gfn_NaviService({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'chatter'
            }
        });
    }

    navigationNavItemPage() {
        this.gfn_NaviService({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'Quick_Action'
            }
        });
    }
}