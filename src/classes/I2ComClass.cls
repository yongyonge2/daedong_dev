/**
 * Created by ms on 2022-07-01.
 */

public virtual class I2ComClass {
    @AuraEnabled public Map<String,Object> resData {get;set;}

    public I2ComClass(){
        this.resData = new Map<String,Object>();
    }

    public I2ComClass setData(String key,Object value){
        this.resData.put(key,value);
        return this;
    }
    public I2ComClass setData(Map<String,Object> keyValues){
        this.resData.putAll(keyValues);
        return this;
    }
    public Object getData(String key){
        return this.resData.get(key);
    }
}