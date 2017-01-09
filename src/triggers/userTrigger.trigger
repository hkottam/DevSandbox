trigger userTrigger on User (before insert, before update) {
    
    //create a list 
    
    list<User> userRecs= new list<User>();
    
    
    if(Trigger.isBefore){
        
        if(Trigger.isInsert){
            
            //check if territory id's are not null for records in context
            
            for(User uRec: Trigger.New){
                if(uRec.Territory_Id__c !=null){
                    userRecs.add(uRec);
                }
            }
            
            //call and pass users records to class
            
            userTriggerClass.getPhotoId(userRecs);
            
        } //end isInsert
        
        if(Trigger.isUpdate){
            
            for(user uRec: Trigger.new){
                
                //check if territory Ids are not null and terriotry ids have not changed for records in context
                
                User oldRecs=Trigger.oldMap.get(uRec.Id);
                
                if(((uRec.Territory_Id__c !=Null) && (uRec.Territory_Id__c!= oldRecs.Territory_Id__c))|| ((uRec.Territory_Id__c !=Null) && (uRec.Photo_URL__c==null) )){
                    userRecs.add(uRec);
                    
                }
            }
            
            userTriggerClass.getphotoId(userRecs);
            
        } //end isUpdate
        
        
    } //end isBefore
    
    

}