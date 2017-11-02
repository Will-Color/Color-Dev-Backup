public class TeamWorkAPI_Test {
    
    public List<TeamworkTime> twTaskTime {get;set;}
    
    public TeamWorkAPI_Test(){
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://colorconsultancy.teamwork.com/time_entries.json');
        req.setMethod('GET');
        req.setHeader('Content-Type','application/text'); 
        String username = 'twp_29HZ8Vx16K83EO3LQBR0RCBuFxbM';
        String password = 'X';
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        String jsonResult = res.getBody();
        List <sObject> distributions = new List <sObject> ();
        
        // Deserialize the JSON to a map of key => value
        Map <String, Object> root = (Map <String, Object>) JSON.deserializeUntyped(jsonResult);
        
        // Get the List of objects from VALUE1
        List <Object> value1 = (List<Object>) root.get('time-entries');
        
        // Go through each of the objects
        for (Object obj : value1)
        {
            system.debug('obj'+obj);
            // Cast the object to a map of key => value
            Map <String, Object> objectMap = (Map <String, Object>) obj;
            
            for (String key : objectMap.keySet())
            {
                // Assuming all the keys from the JSON match the API field names by appending __c
                // Copy the values from the JSON object into the sObject
                // Missing fields will be set to NULL
                //distribution.put(key + '__c', objectMap.get(key));
                //system.debug(objectMap.get(key));
                // add the sObject to the list
                //distributions.add(distribution);
            }
        }
        
       /* JSONParser parser = JSON.createParser(res.getBody());
        
        System.JSONToken token;
        string text;
        while((token = parser.nextToken()) != null) {
            if ((token = parser.getCurrentToken()) != JSONToken.END_OBJECT) {
                if (token == JSONToken.FIELD_Name){
                    text = parser.getText();
                    text = text.replace('-','');
                    //system.debug('text'+text);
                }
            }
        }    */    
        //String jsonResult = String.valueOf(res.getBody()).replace('-','');
         system.debug('jsonResult'+res.getBody());
        //String jsonResult = '['+res.getBody().replace('-'',''')+']';
		//twTaskTime = (List<TeamworkTime>) System.JSON.deserialize(jsonResult, List<TeamworkTime>.class);
		//system.debug('twTaskTime'+parser);        
        
    }   
    
    public class TeamworkTime
    {
        public Id twId {get;set;}
        public Id projectid {get;set;}
        public Integer taskhours {get;set;}
        public String projectname {get;set;}
    }
}