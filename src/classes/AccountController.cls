/**
 * Created by ms on 2022-07-18.
 */

public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static I2ComClass getContact(String accountId) {
        I2ComClass response = new I2ComClass();

        String query = '';
        query += '  SELECT Id, Name, Title ';
        query += '  FROM Contact ';
        query += '  WHERE AccountId = ' + '\'' + accountId + '\'';

        response.setData('contacts', Database.query(query));

        return response;
    }
}