public class getGeoLocationCodesContact {
    @future (callout=true)
    public static void getLocation(id contactId){
        
        Contact cnt=[SELECT MailingCity,MailingState,MailingStreet,MailingCountry, MailingPostalCode,
                       MailingLatitude,MailingLongitude,Location__c FROM Contact where id =: contactId];
        
        //create an address string
        string contactAddress='';
        
        if(cnt.MailingStreet != null)
            contactAddress+=cnt.MailingStreet + ',';
        if(cnt.MailingCity != null)
            contactAddress+=cnt.MailingCity +',';
        if(cnt.MailingState !=null)
            contactAddress+=cnt.MailingState +',';
        if(cnt.MailingPostalCode !=null)
            contactAddress+=cnt.MailingPostalCode +',';
        if(cnt.MailingCountry !=null)
            contactAddress+=cnt.MailingCountry +',';
        
        contactAddress=EncodingUtil.urlEncode(contactAddress,'UTF-8');
        
        //Build the callout
        
        Http httpInstance= new Http();
        HttpRequest request= new HttpRequest();
        request.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+contactAddress+'&sensor=true');
        request.setMethod('GET');
        request.setTimeout(60000);
        
        try{
            //perform the callout
            
            HttpResponse getResponse= httpInstance.send(request);
            
            //Parse JSON response to get Lat and long values
            
            JSONParser parseResponse= JSON.createParser(getResponse.getBody());
            double latitude=null;
            double longitude=null;
            
            while(parseResponse.nextToken()!=null){
                
                if((parseResponse.getCurrentToken()==JSONToken.FIELD_NAME)&&
                   (parseResponse.getText()== 'location')){
                       
                       parseResponse.nextToken();
                       
                       while(parseResponse.nextToken() != JSONToken.END_OBJECT){
                           
                           string txt=parseResponse.getText();
                           parseResponse.nextToken();
                           
                           if( txt=='lat')
                               latitude=parseResponse.getDoubleValue();
                           else if (txt== 'lng')
                               longitude=parseResponse.getDoubleValue();
                           
                       }
                   }
            }
           
            // update the account coordinates
            
            if(latitude != null && longitude !=null){
                
                cnt.MailingLatitude=latitude;
                cnt.MailingLongitude=longitude;
                cnt.Location__Latitude__s=latitude;
                cnt.Location__Longitude__s=longitude;
                
                Database.update(cnt);
            }
        } catch (exception ex){
            system.debug('An exception occured');
        }
       
    }

}