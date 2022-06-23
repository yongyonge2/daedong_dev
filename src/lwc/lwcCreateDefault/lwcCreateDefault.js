/**
 * Created by lkj on 2022-06-27.
 */

import LwcComBase from "c/lwcComBase";

export default class LwcCreateDefault extends LwcComBase {
    helpText = "";


    handleSuccess(event){
        this.doToastNotification('Success', event.detail.apiName + ' 생성 완료.', 'success');
    }
}