/**
 * Created by ms on 2022-07-06.
 */

import LwcComBase from "c/lwcComBase";

export default class LwcSampleSpinner extends LwcComBase {
    handleSpinner(){
        this.gfn_ShowSpinner();
        setTimeout(() => {
            this.gfn_HideSpinner();
        }, 1000);
    }
}