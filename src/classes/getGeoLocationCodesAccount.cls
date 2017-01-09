public class getGeoLocationCodesAccount {
    @future (callout=true)
    public static void getLocation(id accountId){
        
        Account acct=[SELECT BillingCity,BillingState,BillingStreet,BillingCountry, BillingPostalCode,
                       BillingLatitude,BillingLongitude FROM Account where id =: accountId];
        
        //create an address string
        string acctAddress='';
        
        if(acct.BillingStreet != null)
            acctAddress+=acct.BillingStreet + ',';
        if(acct.BillingCity != null)
            acctAddress+=acct.BillingCity +',';
        if(acct.BillingState !=null)
            acctAddress+=acct.BillingState +',';
        if(acct.BillingPostalCode !=null)
            acctAddress+=acct.BillingPostalCode +',';
        if(acct.BillingCountry !=null)
            acctAddress+=acct.BillingCountry +',';
        
        acctAddress=EncodingUtil.urlEncode(acctAddress,'UTF-8');
        
        //Build the callout
        
        Http httpInstance= new Http();
        HttpRequest request= new HttpRequest();
        request.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+acctAddress+'&sensor=true');
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
                
                acct.BillingLatitude=latitude;
                acct.BillingLongitude=longitude;
                
                Database.update(acct);
            }
        } catch (exception ex){
            system.debug('An exception occured');
        }
       
    }

}