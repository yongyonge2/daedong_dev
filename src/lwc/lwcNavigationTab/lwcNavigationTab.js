/**
 * Created by lkj on 2022-06-27.
 */

import LwcComBase from "c/lwcComBase";

export default class LwcNavigationTab extends LwcComBase {
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