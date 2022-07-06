/**
 * Created by ms on 2022-07-06.
 */

import {api, LightningElement} from 'lwc';

export default class LwcComTabHeader extends LightningElement {
    @api title;
    @api type;
    @api url = '#';
    @api iconName = 'standard:event';
    @api resultInfo;
}