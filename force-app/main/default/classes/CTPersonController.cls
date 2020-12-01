/**
 * @description       : 
 * @author            : Avik Kumar Sarkar 
 * @group             : 
 * @last modified on  : 12-01-2020
 * @last modified by  : Avik Kumar Sarkar
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   12-01-2020   Avik Kumar Sarkar    Initial Version
**/
public with sharing class CTPersonController {
    
    /**
    * @description generates tone based on a mobile number
    * @author Avik Kumar Sarkar  | 12-01-2020 
    * @param mobile 
    * @return string 
    **/
    public static string getToken(String mobile) {

        Blob passwordBlob = Blob.valueOf(mobile);
        Blob md5hashMobile = system.Crypto.generateDigest('MD5', passwordBlob);
        return EncodingUtil.convertToHex(md5hashMobile);

    }

    /**
    * @description gets the list of persons with recently updated status with limit of 100
    * @author Avik Kumar Sarkar  | 12-01-2020 
    * @return List<Person__c> 
    **/
    public static List<Person__c> getRecentHealthChanges(){
        return [SELECT Id, OwnerId, IsDeleted, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
        FROM Person__c ORDER BY Status_Update_Date__c LIMIT 100];
    } 

    /**
    * @description serch persons based on name,mobile or token
    * @author Avik Kumar Sarkar  | 12-01-2020 
    * @param searchTerm 
    * @return List<Person__c> 
    **/
    public static List<Person__c> searchPeople(string searchTerm){
        string likeTerm = '%'+searchTerm+'%';
        
        return [SELECT Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c 
                WHERE Name LIKE :likeTerm OR Mobile__c LIKE :likeTerm OR Token__c LIKE :likeTerm 
                WITH SECURITY_ENFORCED ORDER BY Status_Update_Date__c ];
        
    }

    /**
    * @description Retrieves a person account based on Id
    * @author Avik Kumar Sarkar  | 12-01-2020 
    * @param personId 
    * @return Person__c 
    **/
    public Person__c getPersonById(string personId){

        return [SELECT Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                FROM Person__c WHERE ID = :personId WITH SECURITY_ENFORCED];
    }

}
