import { LightningElement, api } from 'lwc';

export default class ViewSource extends LightningElement {
    baseURL =
        'https://github.com/i2maxjieun/daedong_dev/tree/master/src/';

    @api source;

    get sourceURL() {
        return this.baseURL + this.source;
    }
}