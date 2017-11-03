public class TeamWorkAPI_Test {
    
    public list<TWTimeTrack.TWTimeTrackerWrapper> twTaskTime {get;set;}
    public String jsonResult {get; set;}
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
        jsonResult = res.getBody();
        jsonResult = jsonResult.replace('"time-entries":', '"time_entries":');
        jsonResult = jsonResult.replace('"project-id":', '"project_id":');
        jsonResult = jsonResult.replace('"todo-list-name":', '"todo_list_name":');
        jsonResult = jsonResult.replace('"todo-item-name":', '"todo_item_name":');
        jsonResult = jsonResult.replace('"todo-list-id":', '"todo_list_id":');
        jsonResult = jsonResult.replace('"person-last-name":', '"person_last_name":');
        jsonResult = jsonResult.replace('"person-first-name":', '"person_first_name":');
        jsonResult = jsonResult.replace('"ticket-id":', '"ticket_id":');
        jsonResult = jsonResult.replace('"company-id":', '"company_id":');
        jsonResult = jsonResult.replace('"project-status":', '"project_status":');
        jsonResult = jsonResult.replace('"person-id":', '"person_id":');
        jsonResult = jsonResult.replace('"company-name":', '"company_name":');
        jsonResult = jsonResult.replace('"updated-date":', '"updated_date":');
        jsonResult = jsonResult.replace('"date":', '"taskdate":');
        jsonResult = jsonResult.replace('"project-name":', '"project_name":');
        jsonResult = jsonResult.replace('"task-tags":', '"task_tags":');
        jsonResult = jsonResult.replace('"todo-item-id":', '"todo_item_id":');
        jsonResult = jsonResult.replace('"has-start-time":', '"has_start_time":');
        jsonResult = '['+jsonResult+']';
        system.debug('jsonResult'+jsonResult);
        twTaskTime = (list<TWTimeTrack.TWTimeTrackerWrapper>)JSON.deserialize(jsonResult, list<TWTimeTrack.TWTimeTrackerWrapper>.class); 
        for(TWTimeTrack.TWTimeTrackerWrapper t: twTaskTime){
            
            system.debug('twTaskTime'+t);
        }
        
    }   
}