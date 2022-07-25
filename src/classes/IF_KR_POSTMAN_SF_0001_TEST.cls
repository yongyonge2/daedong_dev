/* 테스트 클래스는 테스트 메소드에서 생성된 데이터를 커밋을 수행하지 않음 */
@isTest
public with sharing class IF_KR_POSTMAN_SF_0001_TEST {
    private static void testStaticValue() {
        IfStaticValue__c staticValue = new IfStaticValue__c();

        staticValue.sfdc_org_url__c              = 'https://salesforce.com';
        staticValue.hub_oauth_client_id__c       = 'client_id';
        staticValue.hub_oauth_client_secret__c   = 'client_secret';
        staticValue.hub_auth_name__c             = 'salesforce@salesforce.com';
        staticValue.hub_auth_password__c         = 'salesforce';
        staticValue.hub_aes_algorithm__c         = 'AES258';
        staticValue.sfdc_oauth_username__c       = 'sfdc';
        staticValue.sfdc_oauth_password__c       = 'sfdc_password';
        staticValue.sfdc_aes_private_key__c      = 'aes_key';
        staticValue.sfdc_aes_init_vector__c      = 'aes_vector';

        IF_Base.IfStaticValue(staticValue);
    }

    // 입력 객체 생성
    private static IF_KR_POSTMAN_SF_0001.InputDIH newInputParameter() {
        String req = '{"request":{"header":{"ifTrackingId":"0002e2d0-cec3-6e84-5761-ae68b3bf20a3","ifSenderGp":"TEST","ifSender":"POSTMAN","ifResult":"","ifReceiverGp":"SF","ifReceiver":"MYORG","ifId":"IF_KR_POSTMAN_SF_0001","ifFailMsg":"","ifFailCode":"","ifDateTime":"20220725000000"},"payload":{"t_data":[{"customerName" : "홍길동", "customerType" : "영업소", "phone" : "010-1234-5678"}]}}}';
        IF_KR_POSTMAN_SF_0001.InputDIH input = new IF_KR_POSTMAN_SF_0001.InputDIH();

        input = (IF_KR_POSTMAN_SF_0001.InputDIH)JSON.deserialize(req, IF_KR_POSTMAN_SF_0001.InputDIH.class);

        return input;
    }

    // HTTPResponse 객체 생성
    private static HTTPResponse newResponse(Integer statusCode) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(statusCode);
        res.setBody('{"response":{"header":{"ifTrackingId":"0002e2d0-cec3-6e84-5761-ae68b3bf20a3","ifSenderGp":"SF","ifSender":"MYORG","ifResult":"S","ifReceiverGp":"TEST","ifReceiver":"POSTMAN","ifId":"IF_KR_POSTMAN_SF_0001","ifFailMsg":"","ifFailCode":"","ifDateTime":"20220725000000"},"payload":{"ifSplitCnt":null,"ifRcvCnt":null,"ifAggregation":null}}}');
        IF_KR_POSTMAN_SF_0001.OutputDIH temp = (IF_KR_POSTMAN_SF_0001.OutputDIH)JSON.deserialize(res.getBody(), IF_KR_POSTMAN_SF_0001.OutputDIH.class);
        return res;
    }

    // StatusCode=200 Mock
    private class HttpCalloutSuccessMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = newResponse(200);
            return res;
        }
    }

    // 공통 테스트 진행
    private static Boolean testServiceExecute() {
        String jsonMsg = JSON.serialize(newInputParameter());

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/IF_KR_POSTMAN_SF_0001';  //Request URL
        req.httpMethod = 'POST';  //HTTP Request Type
        req.requestBody = Blob.valueof(jsonMsg);
        RestContext.request = req;
        RestContext.response = res;

        // 서비스 실행
        IF_KR_POSTMAN_SF_0001.OutputDIH result = IF_KR_POSTMAN_SF_0001.doPost();
        System.debug('result : '+result);

        // crashTest
        IF_Base.crashTest = true;
        result = IF_KR_POSTMAN_SF_0001.doPost();

        return true;
    }

    // 성공 테스트
    @isTest public static void testServiceSuccess() {
        Test.setMock(HttpCalloutMock.class, new HttpCalloutSuccessMock());

        System.assertEquals(testServiceExecute(), true);
    }

}
