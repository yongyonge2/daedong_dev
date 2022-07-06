/**
 * Created by lkj on 2022-06-24.
 */

public with sharing class LeadController {
    @AuraEnabled(cacheable=true)
    public static I2ComClass getLeads() {
        I2ComClass response = new I2ComClass();

        String query = '';
        query += '  SELECT Id, Name, Title, Company, Phone, MobilePhone, Email, Status';
        query += '  FROM Lead ';
        query += '  LIMIT 10';

        List<Lead> leads = I2ComUtil.query(query);

        response.setData('leads',leads);

        return response;
    }

    @AuraEnabled(cacheable=true)
    public static I2ComClass searchLeads(String searchKey) {
        I2ComClass response = new I2ComClass();

        String key =    '\'%' + searchKey + '%\'' ;

        String query = '';
        query += '  SELECT Id, Name, Title, Company, Phone, MobilePhone, Email, Status';
        query += '  FROM Lead ';
        query += '  WHERE Name LIKE ' + key;
        query += '  LIMIT 10';

        List<Lead> leads = I2ComUtil.query(query);

        response.setData('leads',leads);

        return response;
    }
}