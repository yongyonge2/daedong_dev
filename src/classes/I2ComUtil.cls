/**
 * Created by ms on 2022-07-13.
 */

public with sharing class I2ComUtil {

    public static String Lead_Last_Name = 'LeadLastName';
    public static String Lead_Company = 'I2max';

    public static String Contact_Last_Name = 'ContactLastName';

    public static String Campaign_Name = 'CampaignName';


    public static Lead createLead() {
        Lead lead = new Lead(
                LastName = Lead_Last_Name,
                Company = Lead_Company
        );
        insert lead;
        return lead;
    }
    public static List<Lead> createLead(Integer amount){
        List<Lead> leads = new List<Lead>();

        for(Integer i = 0; i < amount; i++){
            leads.add(new Lead(
                    LastName = Lead_Last_Name + ' ' + i,
                    Company = Lead_Company
            ));
        }
        insert leads;
        return leads;
    }

    /*public static Account createAccount() {
        Account account = new Account();

        insert account;
        return account;
    }

    public static List<Account> createAccount(Integer amount){
        List<Account> accounts = new List<Account>();

        for(Integer i = 0; i < amount; i++){

        }
        insert accounts;
        return accounts;
    }*/

    public static Contact createContact() {
        Contact contact = new Contact(
                LastName = Contact_Last_Name
        );

        insert contact;
        return contact;
    }

    /*public static List<Contact> createContact(Integer amount){
        List<Contact> contacts = new List<Contact>();

        for(Integer i = 0; i < amount; i++){
            contacts.add(new Contact(
                    LastName = Contact_Last_Name + ' ' + i
            ));
        }
        insert contacts;
        return contacts;
    }*/

    public static Campaign createCampaign() {
        Campaign campaign = new Campaign(
                Name = Campaign_Name
        );

        insert campaign;
        return campaign;
    }

    /*public static List<Campaign> createCampaign(Integer amount) {
        List<Campaign> campaigns = new List<Campaign>();

        for(Integer i = 0; i < amount; i++){
            new Campaign(
                    Name = Campaign_Name
            );
        }
        insert campaigns;
        return campaigns;
    }*/

    public static CampaignMember createCampaignMember(Campaign campaign, Contact contact, Lead lead) {
        CampaignMember campaignMember = new CampaignMember(
                CampaignId = campaign.Id,
                ContactId = contact.Id,
                LeadId = lead.Id
        );

        insert campaignMember;
        return campaignMember;
    }

    /*public static List<CampaignMember> createCampaignMember(List<Campaign> campaigns, List<Contact> contacts, List<Lead> leads, Integer amount) {
        List<CampaignMember> campaignMembers = new List<CampaignMember>();

        for(Integer i = 0; i < amount; i++){
            campaignMembers.add(new CampaignMember(
                    CampaignId = campaigns.get(i).Id,
                    ContactId = contacts.get(i).Id,
                    LeadId = leads.get(i).Id
            ));
        }
        insert campaignMembers;
        return campaignMembers;
    }*/
    @AuraEnabled(cacheable=true)
    public static String getRecordId(String objName){
        List<sObject> obj = new List<sObject>();
        String recordId = '';

        String query = 'SELECT Id';
        query += '  FROM ' + objName;
        query += '  LIMIT 1';

        obj = Database.query(query);
        if(obj.size() > 0){
            recordId = obj.get(0).Id;
        }

        return recordId;
    }
}