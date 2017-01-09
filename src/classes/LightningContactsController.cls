public with sharing class LightningContactsController {

    
    @AuraEnabled
    public static List<Contact> findNearme(Double latitude, Double longitude) {
        double maxDistance=10.0;
        system.debug('Latitude received**'+latitude);
        system.debug('Longitude Received &&'+longitude);
        return Database.query('SELECT Id, Name,Account.Name, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry,Phone,Location__Latitude__s,Location__Longitude__s FROM contact' +
                       ' WHERE DISTANCE(helloWorldLight__Location__c, GEOLOCATION(' + latitude + ',' + longitude + '), \'mi\') < '+ maxDistance +
                       ' ORDER BY DISTANCE(helloWorldLight__Location__c, GEOLOCATION(' + latitude + ',' + longitude + '), \'mi\')');
        
    }

    @AuraEnabled
    public static List<Contact> findNearby(Double latitude, Double longitude, Double maxDistance) {
        return Database.query('SELECT Id, Name, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, Phone FROM contact' +
                       ' WHERE DISTANCE(helloWorldLight__Location__c, GEOLOCATION(' + latitude + ',' + longitude + '), \'mi\') < '+ maxDistance +
                       ' ORDER BY DISTANCE(helloWorldLight__Location__c, GEOLOCATION(' + latitude + ',' + longitude + '), \'mi\')');
        
    }

    
    @AuraEnabled
    public static List<Contact> findAll(){
        
        return [Select Id, Name, Phone,Account.Name,MailingStreet,MailingCity,MailingState,MailingCountry,Location__Latitude__s,Location__Longitude__s from Contact 
                where Location__Latitude__s != NULL AND Location__Longitude__s != NULL 
                limit 10 ];
    }
    
    @AuraEnabled
    public static List<Contact> findbyName(string searchTerm){
        string name='%'+searchTerm +'%';
        return [Select Id, Name, Phone from Contact where name like :name Limit 50];
        
    }
    
    @AuraEnabled
    public static List<Contact> findbyId(string contactId){
        
        return [select Id, Name, Phone from Contact where id=:contactId];
    }

}