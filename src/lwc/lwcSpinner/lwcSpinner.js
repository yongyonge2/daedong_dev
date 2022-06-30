/**
 * Created by lkj on 2022-06-24.
 */


import LwcComBase from "c/lwcComBase";

export default class LwcSpinner extends LwcComBase {
    handleSpinner(){
        this.gfn_ShowSpinner();
        setTimeout(() => {
            this.gfn_HideSpinner();
        }, 1000);
    }
}