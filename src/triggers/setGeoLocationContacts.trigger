trigger setGeoLocationContacts on Contact (after insert, after update) {

    if(Trigger.isInsert){

        for(Contact cnts: Trigger.New){
            if(cnts.MailingLatitude== null || cnts.MailingLongitude==null)
                getGeoLocationCodesContact.getLocation(cnts.Id);
    
        }
     }
     
     if(Trigger.isUpdate){
     
         for(Contact cnts: Trigger.New){
             Contact addressChanged=Trigger.OldMap.get(cnts.Id);
             system.debug('Trigger.new address in update *****' +cnts.MailingCity);
             system.debug('Trigger.old address in update >>>>>' + addressChanged.MailingCity);
             if((addressChanged.MailingStreet != cnts.MailingStreet) ||(addressChanged.MailingCity != cnts.MailingCity) || (addressChanged.MailingState != cnts.MailingState) ||
                 (addressChanged.MailingPostalcode != cnts.MailingPostalCode) || (addressChanged.MailingCountry != cnts.MailingCountry) ||
                  (cnts.MailingLatitude==null || cnts.MailingLongitude==null)){
                 getGeoLocationCodesContact.getLocation(cnts.Id);
                 
             }
         }
     }

}