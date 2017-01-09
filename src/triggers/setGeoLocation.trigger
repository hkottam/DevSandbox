trigger setGeoLocation on Account (after insert, after update) {

    if(Trigger.isInsert){

        for(Account accts: Trigger.New){
            if(accts.BillingLatitude== null || accts.BillingLongitude==null)
                getGeoLocationCodesAccount.getLocation(accts.Id);
    
        }
     }
     
     if(Trigger.isUpdate){
     
         for(Account accts: Trigger.New){
             Account addressChanged=Trigger.OldMap.get(accts.Id);
             system.debug('Trigger.new address in update *****' +accts.BillingCity);
             system.debug('Trigger.old address in update >>>>>' + addressChanged.BillingCity);
             if((addressChanged.BillingStreet != accts.BillingStreet) ||(addressChanged.BillingCity != accts.BillingCity) || (addressChanged.BillingState != accts.BillingState) ||
                 (addressChanged.BillingPostalcode != accts.BillingPostalCode) || (addressChanged.BillingCountry != accts.BillingCountry) ||
                  (accts.BillingLatitude==null || accts.BillingLongitude==null)){
                 getGeoLocationCodesAccount.getLocation(accts.Id);
                 
             }
         }
     }

}