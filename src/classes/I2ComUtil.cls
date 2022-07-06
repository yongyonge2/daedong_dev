/**
 * Created by ms on 2022-07-01.
 */

public with sharing class I2ComUtil {
    /**
         * @description 데이터 조회
         * @param query {String} Dynamic Query
         * @return {List<SObject>} 조회결과
         */
    public static List<SObject> query(String query){
        return Database.query(query);
    }

    public static Integer getCount(String query){
        return Database.countQuery(query);
    }

}