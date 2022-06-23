import { LightningElement, api } from 'lwc';

export default class ViewSource extends LightningElement {
    baseURL =
        'https://github.com/Lee-Kijung/CommonLwc/tree/master/src/';

    @api source;

    get sourceURL() {
        return this.baseURL + this.source;
    }
}