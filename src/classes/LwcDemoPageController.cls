/**
 * Created by lkj on 2022-06-27.
 */

public with sharing class LwcDemoPageController {

    public class InitData extends I2ComClass.InitData {
        @AuraEnabled public List<Lead> recordList {get;private set;}
    }

    @AuraEnabled(cacheable=true)
    public static InitData getRecord(String searchKey) {
        InitData initData = new InitData();
        String key = '%' + searchKey + '%';
        initData.recordList = [
                SELECT Id,
                        Name,
                        Title,
                        Company,
                        Phone,
                        MobilePhone,
                        Email,
                        Status
                FROM Lead
                WHERE Name LIKE :key
                LIMIT 20
        ];
        return initData;
    }

    @AuraEnabled
    public static void deleteRecord(List<Lead> delLead){
        delete delLead;
    }
}