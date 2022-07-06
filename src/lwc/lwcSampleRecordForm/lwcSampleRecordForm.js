/**
 * Created by ms on 2022-07-06.
 */
import LwcComBase from "c/lwcComBase";

export default class LwcSampleRecordForm extends LwcComBase {
    handleSuccess(event){
        this.gfn_ToastNotification('Success', event.detail.apiName + ' 생성 완료.', 'success');
    }
}