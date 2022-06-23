/**
 * Created by lkj on 2022-06-24.
 */

public with sharing class LeadController {
    @AuraEnabled(cacheable=true)
    public static List<Lead> getLeads() {
        return [
                SELECT
                        Id,
                        Name,
                        Title,
                        Company,
                        Phone,
                        MobilePhone,
                        Email,
                        Status
                FROM Lead
                LIMIT 10
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Lead> searchLeads(String searchKey) {
        String key = '%' + searchKey + '%';
        return [
                SELECT Id,
                        Name,
                        Title,
                        Company,
                        Phone,
                        MobilePhone,
                        Email,
                        Status
                FROM Lead
                WHERE Name LIKE :key
                LIMIT 10
        ];
    }
}