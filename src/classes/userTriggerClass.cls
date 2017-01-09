public with sharing class userTriggerClass {
    
    public static void getPhotoId(List<user> userRecs){
        
        try{
                //create a document map
            map<String,Id> documentMap=new map<string,Id>();
            
            //query to get folderid
            Id getfolderId=[SELECT Id FROM Folder WHERE developerName='User_Photos'].Id;
            
            //populate the map with document name and Id
            for(Document docs:[SELECT Id,Name FROM document WHERE folderId=:getfolderId]){
                documentMap.put(docs.name,docs.Id);
            }
            
            for(user uRec: userRecs){
                if(documentMap.containsKey(uRec.Territory_Id__c)){
                    uRec.Photo_Record_Id__c=documentMap.get(uRec.Territory_Id__c);
                    uRec.Photo_URL__c=system.URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.ImageServer?id='+documentMap.get(uRec.Territory_Id__c)+'&oid='+UserInfo.getOrganizationId();
                
                }else{
                    uRec.Photo_URL__c='';
                }
                
                
            }
            
        } catch (exception ex){
            system.debug('An exception occured'+ex.getMessage());
          } 
        
    } //end getPhotoId

}