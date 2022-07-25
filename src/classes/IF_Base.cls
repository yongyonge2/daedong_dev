public virtual with sharing class IF_Base {
    /**
     * 사용자 정의 설정에 등록한 name 입력
     * IfStaticValue__c API에 등록되어 있는 필드정보를 가져와서 사용 가능
     */
    public static IfStaticValue__c staticValue = IfStaticValue__c.getInstance('INTERFACE');
    private static IF_LOG__c ifLogInfo;
    private static Long timeTemp;
    private static String inputBody;
    private static String outputBody;

    public static boolean forceLogging = null;
    public static boolean crashTest = false;

    public enum EXCEPTION_TYPE { DML_EXCEPTION, IF_EXCEPTION, SECURITY_EXCEPTION}

    public static String exceptionType;

    public class IFException extends Exception {}

    public static void IfStaticValue(IfStaticValue__c ifValue) {
        staticValue = ifValue;
    }

    public class IF_BaseLogVO {
        public IF_LOG__c log;
        public Blob sndJsonBlob;
        public Blob rcvJsonBlob;

        public IF_BaseLogVO(IF_LOG__c log, String sndJsonBlob, String rcvJsonBlob){
            this.log = log;

            if(sndJsonBlob == null){
                sndJsonBlob = '';
            }
            if(rcvJsonBlob == null){
                rcvJsonBlob = '';
            }
            this.sndJsonBlob = Blob.valueof(sndJsonBlob);
            this.rcvJsonBlob = Blob.valueof(rcvJsonBlob);
        }
    }

    /**
     * JSON InputHeader of all request header
     */
    public class InputHeader{
        public String ifId              {get;set;}  // External interface id, created automatically, so need logic
        public String ifSenderGp        {get;set;}  // Source System Group
        public String ifSender          {get;set;}  // Source System Code
        public String ifReceiverGp      {get;set;}  // Target System Group
        public String ifReceiver        {get;set;}  // Target System Code
        public String ifTrackingId      {get;set;}  // This should Unique ID from client system to be used for tracking of transaction from client perspective. GUID for message
        public String ifDateTime        {get;set;}  // interface datetime
        public String ifResult          {get;set;}  // interface result status
        public String ifFailMsg         {get;set;}  // interface result error message
        public String ifFailCode        {get;set;}  // interface result error code

        public InputHeader(){
            System.debug('InputHeader Init');
        }

        public InputHeader(String TaskId){
            this.ifId           = TaskId        ;
            this.ifResult       = ''            ;
            this.ifFailMsg      = ''            ;
            this.ifFailCode     = ''            ;
            genMsg();
        }
        public InputHeader(String TaskId, Integer sender){
            if(00 == sender){
                this.ifId           = TaskId        ;
                this.ifResult       = ''            ;
                this.ifFailMsg      = ''            ;
                this.ifFailCode     = ''            ;
                genMsg();
                this.ifSenderGp     = 'KR';
                this.ifSender       = 'HME';
                this.ifReceiverGp   = 'KR';
                this.ifReceiver     = 'TARGET';
            }
        }

        public InputHeader(String TaskId, String TotCnt, String SplitCnt, String SplitSeq){
            this.ifId           = TaskId        ;
            this.ifResult       = ''            ;
            this.ifFailMsg      = ''            ;
            this.ifFailCode     = ''            ;
            genMsg();
        }
        public InputHeader(String TaskId, String IFDateTime){
            this.ifId           = TaskId        ;
            this.ifResult       = ''            ;
            this.ifFailMsg      = ''            ;
            this.ifFailCode     = ''            ;
            this.ifTrackingId   = giveGUID()    ;
            this.ifDateTime     = IFDateTime    ;
        }
        public InputHeader(String TrackingId, String TaskId, String IFDateTime){
            this.ifTrackingId   = TrackingId    ;
            this.ifId           = TaskId        ;
            this.ifDateTime     = IFDateTime    ;
        }
        public InputHeader(String TrackingId, String TaskId, String IFDateTime, String ResultCode, String ErrorMsg, String ErrorCode){
            this.ifTrackingId   = TrackingId    ;
            this.ifId           = TaskId        ;
            this.ifDateTime     = IFDateTime    ;
            this.ifResult       = ResultCode    ;
            this.ifFailMsg      = ErrorMsg      ;
            this.ifFailCode     = ErrorCode     ;
        }
        public void genMsg(){
            this.ifTrackingId   = giveGUID();
            this.ifDateTime     = datetime.now().formatGmt('YYYYMMddHHmmss');
        }
        public String giveGUID(){
            Blob   b    = Crypto.GenerateAESKey(128);
            String h    = EncodingUtil.ConvertTohex(b);
            String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.subString(20);
            return guid;
        }
    }

    public static String giveAGGR(){
        Blob   b    = Crypto.GenerateAESKey(128);
        String h    = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.subString(20);
        return guid;
    }

    public virtual class Header{
        public InputHeader Header {get;set;}
        public Header(){
            Header = new InputHeader();
        }
    }

    public virtual class Headers{
        public InputHeader header {get;set;}
        public Headers(){
            Header = new InputHeader();
        }
    }

    // Oauth Class
    public class Oauth{
        public string access_token;
        public string instance_url;
        public string id;
        public string token_type;
        public string issued_at;
        public string signature;
    }

    public static InputHeader setOutputHeader(InputHeader output, InputHeader input) {
        output.ifTrackingId     = input.ifTrackingId    ;
        output.ifSenderGp       = input.ifReceiverGp    ;
        output.ifSender         = input.ifReceiver      ;
        output.ifReceiverGp     = input.ifSenderGp      ;
        output.ifReceiver       = input.ifSender        ;

        return output;
    }

    public static InputHeader setOutputHeader(InputHeader output, InputHeader input, Exception e) {
        output.ifSenderGp       = input.ifReceiverGp    ;
        output.ifSender         = input.ifReceiver      ;
        output.ifReceiverGp     = input.ifSenderGp      ;
        output.ifReceiver       = input.ifSender        ;

        output.ifResult         = 'E'                   ;
        output.ifFailCode       = e.getTypeName()       ;
        output.ifFailMsg        = IF_Comm.errorText(e)  ;

        return output;
    }


    public static void logInit(String logType) {
        ifLogInfo = new IF_LOG__c();
        timeTemp = System.currentTimeMillis();
        ifLogInfo.Request_to_DIH_Time__c = DateTime.newInstance(timeTemp);
        ifLogInfo.LOG_TYPE__c = logType;
    }

    public static void logStart(InputHeader input) {
        ifLogInfo.MSGGUID__c    = input.ifTrackingId;
        ifLogInfo.IFID__c       = input.ifId;
        ifLogInfo.IFDATE__c     = input.ifDateTime;
    }

    public static void logProcess(String step, String body) {
        if ('STEP1'.equals(step)) {
            inputBody = body;
            ifLogInfo.Request_Processing_Time__c = System.currentTimeMillis() - timeTemp;
            timeTemp = System.currentTimeMillis();
        } else if ('STEP1-1'.equals(step)) {
            outputBody = body;
            ifLogInfo.Response_Processing_Time__c = System.currentTimeMillis() - timeTemp;
            ifLogInfo.Response_from_DIH_Time__c = DateTime.newInstance(System.currentTimeMillis());
            timeTemp = System.currentTimeMillis();
        } else if ('STEP2'.equals(step)) {
            outputBody = body;
            ifLogInfo.Response_Data_Processing_Time__c = System.currentTimeMillis() - timeTemp;
        }
    }

    public static void logEnd(InputHeader output, String ifAggregation, String ifTotCnt, String ifSplitCnt, String ifSplitSeq, String ifRcvCnt) {
        ifLogInfo.ifAggregation__c			= ifAggregation;
        ifLogInfo.ifTotCnt__c				= ifTotCnt;
        ifLogInfo.ifSplitCnt__c			    = ifSplitCnt;
        ifLogInfo.ifSplitSeq__c			    = ifSplitSeq;
        ifLogInfo.ifRcvCnt__c				= ifRcvCnt;
        ifLogInfo.OMSGGUID__c   			= output.ifTrackingId;
        ifLogInfo.OIFID__c      			= output.ifId;
        ifLogInfo.OIFDATE__c    			= output.ifDateTime;
        ifLogInfo.OMSGSTATUS__c 			= output.ifResult;
        ifLogInfo.OERRORTEXT__c 			= output.ifFailMsg;
        ifLogInfo.OERRORCODE__c 			= output.ifFailCode;
        ifLogInfo.Processing_End_Time__c 	= DateTime.newInstance(System.currentTimeMillis());

        if(forceLogging == null){
            getIfinfo(ifLogInfo.IFID__c);
        }

        // SUCCESS인 경우 로그 쌓지 않음
        if(output.ifResult != 'S' || forceLogging == true){

            IF_INFO__c ifInfo = getIfinfo(ifLogInfo.IFID__c);
            ifLogInfo.IF_INFO__c = ifInfo.id;

            IF_BaseLogVO restLog = new IF_BaseLogVO(ifLogInfo, inputBody, outputBody);
            String restLogJSON = JSON.serialize(restLog);

            Id jobId = System.enqueueJob(new webCallOutLog_qu(restLogJSON));
        }
    }

    public static void logEnd(InputHeader output) {
        ifLogInfo.OMSGGUID__c   			= output.ifTrackingId	;
        ifLogInfo.OIFID__c      			= output.ifId    		;
        ifLogInfo.OIFDATE__c    			= output.ifDateTime		;
        ifLogInfo.OMSGSTATUS__c 			= output.ifResult		;
        ifLogInfo.OERRORTEXT__c 			= output.ifFailMsg 		;
        ifLogInfo.OERRORCODE__c 			= output.ifFailCode 	;
        ifLogInfo.Processing_End_Time__c 	= DateTime.newInstance(System.currentTimeMillis());

        if(forceLogging == null){
            getIfinfo(ifLogInfo.IFID__c);
        }

        system.debug('ifResult 값 : ' + output.ifResult + 'forceLogging 값 : ' + forceLogging );

        // SUCCESS인 경우 로그 쌓지 않음
        if(output.ifResult != 'S' || forceLogging == true){

            IF_INFO__c ifInfo = getIfinfo(ifLogInfo.IFID__c);
            ifLogInfo.IF_INFO__c = ifInfo.id;

            IF_BaseLogVO restLog = new IF_BaseLogVO(ifLogInfo, inputBody, outputBody);
            String restLogJSON = JSON.serialize(restLog);

            Id jobId = System.enqueueJob(new webCallOutLog_qu(restLogJSON));
        }
    }

    /**
     * 데이터 전송 및 로그 기록
     */
    public static String webCallOut(String body, String endpoint){
        system.debug('=================================> Start Request : ' + endpoint);

        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        Http http = new Http();
        String resBody = null;

        System.debug('requestBody : '+ body);

        httpReq.setMethod('POST');
        httpReq.setBody(body);
        httpReq.setEndpoint(endpoint);
        httpReq.setTimeout(110000);
        httpReq.setHeader('Authorization', 'Bearer ' + getTargetSystemToken());
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Accept', 'application/json');
        httpRes = http.send(httpReq);

        System.debug('response Header Key : ' + httpRes.getHeaderKeys());
        System.debug('response Status Code : ' + httpRes.getStatusCode());
        System.debug('response Status : ' + httpRes.getStatus());

        resBody = httpRes.getBody();
        if (resBody.length() > 1900000) {
            System.debug('responseBody : null');
        } else {
            System.debug('responseBody : '+resBody);
        }
        logProcess('STEP1-1', resBody);

        return resBody;
    }

    // IF_ID로 IF_INFO__c개체 반환 대외 url일 경우
    public static IF_INFO__c getIfinfo(String id){
        List<IF_INFO__c> ifInfo;
        ifInfo = [SELECT IF_ID__c, URL__c, CYCLE__c, FROM__c, TO__c, TITLE__c, FORCE_LOGGING__c FROM IF_INFO__c WHERE IF_ID__c = :id LIMIT 1];
        System.debug('ifInfo'+ifInfo);

        System.debug('=========================');
        System.debug(JSON.serialize(ifInfo));
        System.debug('=========================');

        if(ifInfo.size() == 0){
            IF_INFO__c iff = new IF_INFO__c();
            return iff;
        }

        if(ifInfo[0].FORCE_LOGGING__c == true){
            forceLogging = true;
        }

        return ifInfo[0];
    }

    // 사용자 정의 설정에 등록된 정보를 바탕으로 regacy 시스템에 대한 access token 생성
    public static String getTargetSystemToken() {

        String params   = staticValue.hub_token_url__c;
        params          += '?grant_type='       + EncodingUtil.urlEncode('password','UTF-8');
        params          += '&username='         + EncodingUtil.urlEncode(staticValue.hub_auth_name__c,'UTF-8');
        params          += '&password='         + EncodingUtil.urlEncode(staticValue.hub_auth_password__c,'UTF-8');
        params          += '&client_id='        + EncodingUtil.urlEncode(staticValue.hub_oauth_client_id__c,'UTF-8');
        params          += '&client_secret='    + EncodingUtil.urlEncode(staticValue.hub_oauth_client_secret__c,'UTF-8');

        system.debug('params : '+params);

        /* ODS Auth Token 받아오는 REST API 부분 시작 */
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        Http http = new Http();
        String resBody = null;

        httpReq.setMethod('POST');
        httpReq.setEndpoint(params);
        httpReq.setTimeout(110000);
        httpReq.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        httpReq.setHeader('Accept', 'application/json');
        httpRes = http.send(httpReq);

        System.debug('response Header Key : ' + httpRes.getHeaderKeys());
        System.debug('response Status Code : ' + httpRes.getStatusCode());
        System.debug('getBody : ' + httpRes.getBody());

        Map<String,Object> resMap = (Map<String,Object>) JSON.deserializeUntyped(httpRes.getBody());

        String access_token = resMap.get('access_token').toString();

        System.debug('access_token : ' + access_token);

        return access_token;
    }

    @TestVisible private static String authEnc(){
        String algorithm  = staticValue.sfdc_aes_algorithm__c;
        String dihId      = staticValue.hub_auth_name__c     ;
        String dihpasswd  = staticValue.hub_auth_password__c      ;
        String aesKey     = staticValue.hub_aes_private_key__c       ;
        String initVector = staticValue.hub_aes_init_vector__c;

        String authorization = 'Bearer ' + IF_Comm.cryptoEncrypt(algorithm, initVector, aesKey, dihId + ':' + dihpasswd);
        System.debug('AUTHID '+authorization);
        return authorization;
    }

    /**
     *  @description 인터페이스 로그 저장 처리 함수 (future함수 webCallOutLog 대체) Queueable Class
     *               기존 프로세스 : webCallOutLog future함수를 통해 > IF_BaseLogREST API 호출 (Callout 후 로그용 Callout 다시 호출) > LOG 및 Request, Response Attachfile DML 작업
     *  @author shlee
     */
    public with sharing class webCallOutLog_qu implements Queueable {
        public String restLogJSON;

        public webCallOutLog_qu(String restLogJSON) {
            this.restLogJSON = restLogJSON;
            // System.debug('restLogJSON : ' + restLogJSON);
        }

        public void execute(QueueableContext qc){
            //insert log;
            IF_BaseLogVO restLog = (IF_BaseLogVO) JSON.deserialize(this.restLogJSON, IF_BaseLogVO.class);
            insert restLog.log;

            //insert logFile;
            Attachment attSnd = new Attachment(Name ='InputParameter'+'.json',body = restLog.sndJsonBlob, parentId = restLog.log.id);
            Attachment attRcv = new Attachment(Name ='OutputResult'+'.json',body = restLog.rcvJsonBlob, parentId = restLog.log.id);
            insert attSnd;
            insert attRcv;

            System.debug('IF_BaseLogREST log END');
        }

    }
}
