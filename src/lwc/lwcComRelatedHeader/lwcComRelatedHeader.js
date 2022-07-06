/**
 * Created by ms on 2022-07-06.
 */

import {api, LightningElement} from 'lwc';

export default class LwcComRelatedHeader extends LightningElement {
    @api title;
    @api iconName = 'standard:event';
    @api url = '#';
}