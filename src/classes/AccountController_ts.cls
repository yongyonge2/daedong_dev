/**
 * Created by ms on 2022-07-18.
 */

@isTest
public with sharing Class AccountController_ts {

    @isTest
    static void getContact() {
        Account account = I2ComUtil.createAccount();
        I2ComUtil.createContact(account.Id);

        Test.startTest();
        I2ComClass response = AccountController.getContact(account.Id);
        Integer count = response.getDataSize('contacts');
        Test.stopTest();

        System.assertNotEquals(count, 0);
    }
}