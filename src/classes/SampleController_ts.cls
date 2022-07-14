/**
 * Created by ms on 2022-07-13.
 */

@isTest
public with sharing Class SampleController_ts {
    @isTest
    static void getLeads(){
        I2ComUtil.createLead();

        Test.startTest();
        I2ComClass response = SampleController.getLeads(I2ComUtil.Lead_Last_Name);
        Integer cnt = response.getDataSize('leads');
        Test.stopTest();

        System.assertNotEquals(cnt, 0);
    }

    @isTest
    static void searchLeads(){
        I2ComUtil.createLead(5);

        Test.startTest();
        I2ComClass response = SampleController.searchLeads(I2ComUtil.Lead_Last_Name);
        Integer cnt = response.getDataSize('leads');
        Test.stopTest();

        System.assertEquals(cnt, 5);
    }

    @isTest
    static void deleteLead(){
        Lead lead = I2ComUtil.createLead();

        Test.startTest();
        String recordId = lead.Id;
        SampleController.deleteLead(recordId);

        String query = '';
        query += '  SELECT COUNT() ';
        query += '  FROM Lead ';
        query += '  WHERE Id = ' + '\'' + recordId + '\'';

        Integer count = Database.countQuery(query);
        Test.stopTest();

        System.assertEquals(count, 0);
    }

    @isTest
    static void getCampaignMembers(){
        Campaign campaign = I2ComUtil.createCampaign();
        Contact contact = I2ComUtil.createContact();
        Lead lead = I2ComUtil.createLead();

        I2ComUtil.createCampaignMember(campaign, contact, lead);

        Test.startTest();
        I2ComClass response = SampleController.getCampaignMembers(lead.Id);
        Integer cnt = response.getDataSize('campaignMembers');
        Test.stopTest();

        System.assertEquals(cnt, 1);

    }
}