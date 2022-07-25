public with sharing class IF_KR_POSTMAN_SF_0001_BIZ {

    /**
     * 수정 불필요 (그대로 사용)
     */
    private static IF_KR_POSTMAN_SF_0001_BIZ sInstance = null;
    public static IF_KR_POSTMAN_SF_0001_BIZ getInstance() {
        if (sInstance == null) {
            sInstance = new IF_KR_POSTMAN_SF_0001_BIZ();
        }
        return sInstance;
    }

    /**
     * pre logic
     *
     * post 전 데이터 가공 등 사전 작업 시 사용
     * 데이터 가공 등 사전 작업 필요 없을 시 그대로 사용
     */
    public IF_KR_POSTMAN_SF_0001.InputBody pre (IF_KR_POSTMAN_SF_0001.InputBody inputBody, IF_KR_POSTMAN_SF_0001.OutputBody outputBody) {
        /* 업무 개발자에 의해 변경되어야 하는 부분 시작
        /*
            값할당 샘플
        */
        /* 업무 개발자에 의해 변경되어야 하는 부분 끝 */

        return inputBody;
    }

    /**
     * post logic
     *
     * dummy object dml 수행
     */
    public IF_KR_POSTMAN_SF_0001.OutputBody post(IF_KR_POSTMAN_SF_0001.InputBody inputBody, IF_KR_POSTMAN_SF_0001.OutputBody outputBody) {
        /* 업무 개발자에 의해 변경되어야 하는 부분 시작 */

        List<IF_KR_POSTMAN_SF_0001.INPUT_T_DATA> inputList = inputBody.t_data;

        Integer inputSize = inputList.size();

        if(inputSize > 0) {
            List<IF_KR_POSTMAN_SF_0001__c> dummyList = new List<IF_KR_POSTMAN_SF_0001__c>();

            IF_KR_POSTMAN_SF_0001__c dummyObject = null;

            for (IF_KR_POSTMAN_SF_0001.INPUT_T_DATA inputObject : inputList) {
                // dummy object 와 input 된 object 매핑
                dummyObject = new IF_KR_POSTMAN_SF_0001__c();

                dummyObject.CustomerName__c     = inputObject.customerName;
                dummyObject.CustomerType__c     = inputObject.customerType;
                dummyObject.Phone__c            = inputObject.phone;
                dummyObject.isBatchCompleted__c = false;

                dummyList.add(dummyObject);
            }

            // dummy object insert
            insert dummyList;

            outputBody.ifAggregation    = IF_Comm.convertEmpty(inputBody.ifAggregation);
            outputBody.ifSplitCnt       = IF_Comm.convertEmpty(inputBody.ifSplitCnt);
            outputBody.ifRcvCnt         = String.valueOf(inputSize);
        }

        /* 업무 개발자에 의해 변경되어야 하는 부분 끝 */

        return outputBody;
    }
}
