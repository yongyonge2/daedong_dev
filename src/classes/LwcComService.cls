/**
 * Created by lkj on 2022-06-20.
 */

public with sharing class LwcComService {

    @AuraEnabled(cacheable=true)
    public static Map<String, Map<String, String>> getSobjectData(List<String> targetObjectList) {
        System.debug('targetObjectList : ' + targetObjectList);
        Map<String, Map<String, String>> resultFieldLabelMap = new Map<String, Map<String, String>>();

        resultFieldLabelMap = I2ComService.gfnGetMultiSObjectLabel(targetObjectList);
        System.debug('resultFieldLabelMap : ' + JSON.serializePretty(resultFieldLabelMap));
        return resultFieldLabelMap;
    }
}