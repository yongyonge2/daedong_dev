/**
 * Created by ms on 2022-07-12.
 */

import {api, LightningElement} from 'lwc';

export default class LwcComComponentHeader extends LightningElement {
    @api title;
    @api iconName = 'standard:event';
    @api url;
    hasUrl = this.url !== '';
}