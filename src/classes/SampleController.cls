/**
 * Created by ms on 2022-07-13.
 */

public with sharing class SampleController {

    @AuraEnabled(cacheable=true)
    public static I2ComClass getLeads(String searchKey) {
        I2ComClass response = new I2ComClass();

        String key =    '\'%' + searchKey + '%\'' ;

        String query = '';
        query += '  SELECT Id, Name, Title, Company, Address, CreatedDate, Phone, MobilePhone, Email, Status';
        query += '  FROM Lead ';
        query += '  WHERE Name LIKE ' + key;

        String query2 = '';
        query2 += '  SELECT LastModifiedDate ';
        query2 += '  FROM Lead ';
        query2 += '  ORDER BY LastModifiedDate DESC';

        String query3 = '';
        query3 += '  SELECT COUNT() ';
        query3 += '  FROM Lead ';

        response.setData('leads', Database.query(query));
        response.setData('info', Database.query(query2));
        response.setData('count', Database.countQuery(query3));

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

        List<Lead> leads = Database.query(query);

        response.setData('leads',leads);

        return response;
    }

    @AuraEnabled
    public static void deleteLead(String recordId){
        String query = '';
        query += '  SELECT Id ';
        query += '  FROM Lead ';
        query += '  WHERE Id = ' + '\'' + recordId + '\'';

        List<Lead> leads = Database.query(query);
        delete leads;
    }

    @AuraEnabled(cacheable=true)
    public static I2ComClass getCampaignMembers(String recordId) {
        I2ComClass response = new I2ComClass();

        String query = '';
        query += '  SELECT Id, Campaign.Name, Campaign.StartDate, Campaign.Type, Status ';
        query += '  FROM CampaignMember ';
        query += '  WHERE LeadId = ' + '\'' + recordId + '\'';
        query += '  ORDER By CreatedDate';

        String query2 = '';
        query2 += '  SELECT COUNT() ';
        query2 += '  FROM CampaignMember ';
        query2 += '  WHERE LeadId = ' + '\'' + recordId + '\'';

        response.setData('campaignMembers', Database.query(query));
        response.setData('count', Database.countQuery(query2));

        return response;
    }
}