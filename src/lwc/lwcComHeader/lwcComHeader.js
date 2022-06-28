/**
 * Created by lkj on 2022-06-21.
 */

import {LightningElement, api} from 'lwc';

export default class LwcComHeader extends LightningElement {

    @api title = 'TITLE';
    @api iconName = 'standard:event';
    @api isDetailCard = false;
    @api isDeskTopOrTablet;
    @api className = 'slds-page-header header flexipageHeader';

    @api type = 'TYPE';
}