/**
 * Created by lkj on 2022-06-21.
 */

import {LightningElement, api} from 'lwc';

export default class LwcComHeader extends LightningElement {

    @api title = '내 모든 고객';
    @api iconName = 'standard:event';
    @api isDetailCard = false;
    @api isDeskTopOrTablet;
    @api className = 'slds-page-header slds-m-bottom_x-small';

    @api type = '고객';
}