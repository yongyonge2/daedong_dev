/**
 * Created by lkj on 2022-06-27.
 */

import LwcComBase from "c/lwcComBase";

export default class LwcNavigationTab extends LwcComBase {
    navigationNamedPage() {
        this.doNaviService({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'chatter'
            }
        });
    }

    navigationNavItemPage() {
        this.doNaviService({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'FlexiPage'
            }
        });
    }
}