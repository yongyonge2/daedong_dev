/**
 * Created by ms on 2022-07-13.
 */

import LwcComBase from "c/lwcComBase";

export default class SampleSpinner extends LwcComBase {
    handleSpinner(){
        this.gfn_ShowSpinner();
        setTimeout(() => {
            this.gfn_HideSpinner();
        }, 1000);
    }
}