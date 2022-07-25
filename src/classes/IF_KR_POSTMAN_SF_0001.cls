// Apex REST의 기본 endPoint는 https://domain.my.salesforce.com/services/apexrest/
@RestResource(urlMapping='/IF_KR_POSTMAN_SF_0001/*') // External interface id
global with sharing class IF_KR_POSTMAN_SF_0001 extends IF_Base {
    public static final String IFID = 'IF_KR_POSTMAN_SF_0001'; // External interface id

    /**
     * JSON 데이터 매핑 변수 입력
     */
    public class INPUT_T_DATA {
        public String customerName;	            // Mapping column : customName__c
        public String customerType;             // Mapping column : customType__c
        public String phone;                    // Mapping column : phone__c
    }

    /**
     * 수정 불필요 (그대로 사용)
     */
    public class InputBody {
        public String ifAggregation;            // 분할전송시 전체 데이터 Set을 식별하기위한 Unique Key
        public String ifTotCnt;                 // 전송 대상 전체 데이터 건수(분할 전송시에는 분할 전 전체 데이터 건수)
        public String ifSplitCnt;               // 분할 전송 총 횟수
        public String ifSplitSeq;               // 현재 전송되는 분할의 일련번호 (1 부터 1씩 증가)
        public String ifDateTime;               // Date Format (yyyyMMddHHmmss)

        public List<INPUT_T_DATA> t_data;
        public InputBody() {
            t_data = new List<INPUT_T_DATA>();
        }
    }

    /**
     * 수정 불필요 (그대로 사용)
     */
    public class OutputBody {
        public String ifAggregation;            // 분할전송시 전체 데이터 Set을 식별하기위한 Unique Key
        public String ifSplitCnt;               // 분할 전송 총 횟수
        public String ifRcvCnt;                 // 인터페이스 트랜잭션 단위 실제 수신한 데이터 건수
    }

    /**
     * 수정 불필요 (그대로 사용)
     */
    global class Input extends Headers{
        public InputBody payload;
        public Input(){
            payload = new InputBody();
        }
    }

    /**
     * 수정 불필요 (그대로 사용)
     */
    global class Output extends Headers{
        public OutputBody payload;
        public Output(){
            payload = new OutputBody();
        }
    }

    /**
     * 수정 불필요 (그대로 사용)
     */
    global class InputDIH {
        public Input request;
        public InputDIH(){
            request = new Input();
        }
    }

    /**
     * 수정 불필요 (그대로 사용)
     */
    global class OutputDIH {
        public Output response;
        public OutputDIH(){
            response = new Output();
        }
    }

    /**
     * doPost
     * interface 데이터 수신 후 BIZ APEX로 데이터 전송
     */
    @HttpPost
    global static OutputDIH doPost() {
        // JSON 데이터 변수에 담음
        RestRequest restReq = RestContext.request;
        String req = restReq.requestBody.toString();
        SYSTEM.debug('JSON DATA : ' + req);
        String res = null;

        InputDIH  inputObj  = new InputDIH() ;
        OutputDIH outputObj = new OutputDIH();

        Input  inputReq  = null              ;
        Output outputRes = outputObj.Response;

        try {
            // 로그 timeTemp, Request_to_DIH_Time 세팅
            IF_Base.logInit('RCV');

            // JSON 데이터 APEX에서 인식가능하도록 변경
            inputObj = (InputDIH)JSON.deserialize(req, InputDIH.class);

            inputReq  = inputObj.Request  ;

            // 로그 MSGGID, IFID, IFDATE 세팅
            IF_Base.logStart(inputReq.Header);
            // 로그 input, Request_Processing_Time 세팅
            IF_Base.logProcess('STEP1', req);

            outputRes.Header = new IF_Base.InputHeader(IFID)   ;

            // header value setup
            outputRes.Header = IF_Base.setOutputHeader(outputRes.Header, inputReq.Header);

            if (!IFID.equals(inputReq.header.ifid)) {
                throw new IFException('IFID is empty or incorrect.');
            }

            if(Test.isRunningTest() && IF_Base.crashTest) {  // Purposely crash test.
                throw new DmlException('Dml Exception');
            }

            inputReq.payload.ifDateTime = IF_Comm.convertEmpty(inputReq.header.ifDateTime);

            IF_KR_POSTMAN_SF_0001_BIZ bizInstance = IF_KR_POSTMAN_SF_0001_BIZ.getInstance();

            /* 업무 개발자에 의해 변경되어야 하는 부분 시작(선행)
                IF_KR_POSTMAN_SF_0001_BIZ 에서 data dml 수행 전 데이터 가공 등 사전 작업 시 사용
            * */
            inputReq.Payload = bizInstance.pre(inputReq.Payload, outputRes.Payload);
            /* 업무 개발자에 의해 변경되어야 하는 부분 끝(선행) */

            /* 업무 개발자에 의해 변경되어야 하는 부분 시작(후행)
            *   dummy object dml 수행
            * */
            outputRes.Payload = bizInstance.post(inputReq.Payload, outputRes.Payload);
            /* 업무 개발자에 의해 변경되어야 하는 부분 끝(후행) */

            outputRes.Header.ifResult       = 'S';
            outputRes.Header.ifFailMsg      = '';
            outputRes.Header.ifFailCode     = '';

        } catch (Exception e) {
            // 에러내용 debug 출력
            IF_Comm.errorDebug(e);

            inputReq  = inputObj.Request;

            // 내부오류의 경우 ResultCode 'E'로
            outputRes.Header = new IF_Base.InputHeader(inputReq.Header.ifTrackingId, IFID, inputReq.Header.ifDateTime);

            // error header value setup
            outputRes.Header = IF_Base.setOutputHeader(outputRes.Header, inputReq.Header, e);
        }
        res = JSON.serialize(outputObj);

        // 로그 Response_Processing_Time, Respone_from_DIH_Time 세팅
        IF_Base.logProcess('STEP2', res);
        // 로그 파일 및 row insert
        // IF_Base.logEnd(outputRes.Header);
        IF_Base.logEnd(outputRes.Header, inputReq.payload.ifAggregation, inputReq.payload.ifTotCnt, inputReq.payload.ifSplitCnt, inputReq.payload.ifSplitSeq, outputRes.payload.ifRcvCnt);

        return outputObj;
    } 
}
