/**
 * Created by ms on 2022-07-13.
 */

import LwcComBase from "c/lwcComBase";

export default class SampleQuickAction extends LwcComBase {

    handleSubmit(event){
        this.gfn_QaSubmit(event);
    }

    handleSuccess(event){
        this.gfn_QaSuccess(event);
    }

    handleClose(){
        this.gfn_QaClose();
    }
}