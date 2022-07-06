/**
 * Created by ms on 2022-07-05.
 */
public with sharing class LwcDemoController {

    @AuraEnabled(cacheable=true)
    public static I2ComClass getLeadList(String searchKey) {
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

        response.setData('leads', I2ComUtil.query(query));
        response.setData('info', I2ComUtil.query(query2));
        response.setData('count', I2ComUtil.getCount(query3));

        return response;
    }

    @AuraEnabled
    public static void deleteLead(String recordId){
        String query = '';
        query += '  SELECT Id ';
        query += '  FROM Lead ';
        query += '  WHERE Id = ' + '\'' + recordId + '\'';

        List<Lead> leads = I2ComUtil.query(query);
        delete leads;
    }

    @AuraEnabled(cacheable=true)
    public static I2ComClass getCampaignMemberList(String recordId) {
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


        List<CampaignMember> campaignMembers = I2ComUtil.query(query);

        response.setData('campaignMembers', I2ComUtil.query(query));
        response.setData('count', I2ComUtil.getCount(query2));

        return response;
    }
}