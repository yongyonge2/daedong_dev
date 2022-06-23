/**
 * Created by lkj on 2022-06-21.
 */

import {LightningElement, api, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import FORM_FACTOR from '@salesforce/client/formFactor';


import getSobjectData from '@salesforce/apex/LwcComService.getSobjectData';

export default class LwcComBase extends NavigationMixin(LightningElement) {

    // isDeskTop 여부
    @track device = FORM_FACTOR;
    @track isDeskTopOrTablet = FORM_FACTOR == 'Large' || FORM_FACTOR == 'Medium';
    // 커뮤니티 여부
    @track isCommunity;

    // 데이터 속성
    @track initData = {};
    @track reqData = {};
    @track resData = {};
    @track recordList = {};

    // Spinner 처리
    @api isSpinner = false;

    @track labelMap = {};

    connectedCallback() {
        this.doInit();
    }

    doInit() {
        this.isCommunity = this.doIsCommunitySite();
    }

    doIsCommunitySite() {
        return new RegExp("/s/").test(window.location.toString());
    }


    doApexErrorHandle(error) {
        let errors = Array.isArray(error) || [error];
        let errorMessages = errors.filter(error => !!error).map(function(error) {
            // UI API read errors
            if (Array.isArray(error.body)) {
                return error.body.map(function(e) { return e.message; });
            }
            // UI API DML, Apex and network errors
            else if (error.body && typeof error.body.message === 'string') {
                return error.body.message;
            }
            // JS errors
            else if (typeof error.message === 'string') { return error.message; }
            // Unknown error shape so try HTTP status text
            return error.statusText || error;
        }).filter(function(message) { return  !!message; });

        let toastErrorMessage = errorMessages.join(', ');

        //============================================================================
        // log 처리와 toast 처리
        //============================================================================
        console.error(toastErrorMessage);
        this.doToast('Error', toastErrorMessage, 'e');
    }

    /**
     * Toast Message
     * @param title
     * @param msg
     * @param type
     * @param mode
     */

    doToastNotification(title, msg, type){
        const evt = new ShowToastEvent({
            title   : title,
            message : msg,
            variant : type
        });
        this.dispatchEvent(evt);
    }

    /**
     * spinner Show
     */
    doShowSpinner(){
        this.isSpinner = true;
    }

    /**
     * spinner Hide
     */
    doHideSpinner(){
        this.isSpinner = false;
    }


    /**************************************************** ***********************************************************/








    /************************************************ Service *******************************************************/
    /**
     * Object list를 넘기면 해당하는 object의 label정보를 가져옴. (다국어 지원)
     *
     * @param component
     * @param event
     * @param helper
     */

    async doGetSobjectData(targetObjectList){
        await getSobjectData({'targetObjectList': targetObjectList})
            .then(result => {
                this.labelMap = result;
            })
            .catch(error => {
                this.doApexErrorHandle(error);
            });
    }

    doNaviService(params) {
        this[NavigationMixin.Navigate](params);
    }

    /**************************************************** ***********************************************************/


    isEmpty(value) {
        if (value === undefined || value === null || value === "") {
            return true;
        }

        if (Array.isArray(value)) {
            return value.length === 0;
        } else if (typeof value === "object" && Object.prototype.toString.call(value) === "[object Object]") {
            return Object.keys(value).length === 0;
        }

        return false;
    }
}