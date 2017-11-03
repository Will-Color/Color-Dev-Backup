public class TeamWorkAPI_Test {
    
    public list<JsonParser.time_entries> twTaskEntries {get;set;}
    public String jsonResult {get; set;}
    public Map<Integer,JsonParser.time_entries> twData {get;set;}
    public TeamWorkAPI_Test(){
        twData = new Map<Integer,JsonParser.time_entries>();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://colorconsultancy.teamwork.com/projects/262794/time_entries.json');
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
        //jsonResult = '['+jsonResult+']';
        system.debug('jsonResult'+jsonResult);
        Set<Integer> projectId = new Set<Integer>();
        Set<Integer> taskListId = new Set<Integer>();
        JsonParser mainJSONWrapper = (JsonParser) JSON.deserialize(jsonResult,JsonParser.class);
        List<JsonParser.time_entries> objectsLst = mainJSONWrapper.time_entries;
        system.debug('objectsLst'+objectsLst);
        for(JsonParser.time_entries obj:objectsLst) {
            System.debug('Name:'+obj.project_id);
            projectId.add(Integer.valueOf(obj.project_id));
            taskListId.add(Integer.valueOf(obj.todo_list_id));
            System.debug('metadata:'+obj.hours);
        }
        
        for(JsonParser.time_entries obj : objectsLst) {
            for(Integer project : projectId){
                for(Integer taskLi : taskListId){
                    if(Integer.valueOf(obj.project_id) == project && Integer.valueOf(obj.todo_list_id) == taskLi){
                        Integer taskId = Integer.valueOf(obj.todo_item_id); 
                        system.debug('taskId'+taskId);
                        if(twData.containsKey(taskId)){
                            JsonParser.time_entries thisTaskInfo = new JsonParser.time_entries();
                            thisTaskInfo = twData.get(taskId);
                            thisTaskInfo.hours = Integer.valueOf(thisTaskInfo.hours) + Integer.valueOf(obj.hours); 
                            thisTaskInfo.minutes = Integer.valueOf(thisTaskInfo.minutes) + Integer.valueOf(obj.minutes);
                            //twData.put(taskId, thisTaskInfo);
                        }
                        else{
                            JsonParser.time_entries jsp = new JsonParser.time_entries();
                            jsp.project_name = obj.project_name;
                            jsp.project_id = obj.project_id;
                            jsp.todo_list_name = obj.todo_list_name;
                            jsp.todo_list_id = obj.todo_list_id;
                            jsp.todo_item_name = obj.todo_item_name;
                            jsp.todo_item_id = obj.todo_item_id;
                            jsp.hours = obj.hours;
                            jsp.minutes = obj.minutes;
                            twData.put(taskId, jsp);
                        }
                    }
                }
            }
        }
        //insertTask();
    }   
    public void insertTask(){
        List<Task> myTasks = new List<Task>();
        Opportunity myOpp = [Select Id from Opportunity where Id='0060Y00000BrA7m'];
        String userId = UserInfo.getUserId();
        for(Integer t: twData.keySet()){
            JsonParser.time_entries thisTaskInfo = new JsonParser.time_entries();
            thisTaskInfo = twData.get(t);
            Task myTask = new task();
            myTask.OwnerId = userId;
            myTask.Subject = thisTaskInfo.todo_item_name;
            myTask.Status = 'Open';
            myTask.Priority = 'Normal';
            myTask.WhatId = myOpp.Id;
            myTask.Project_Id__c = thisTaskInfo.project_id;
            myTask.Project_Name__c = thisTaskInfo.project_name;
            myTask.Task_List_Id__c = thisTaskInfo.todo_list_id;
            myTask.Task_List__c = thisTaskInfo.todo_list_name;
            myTask.Task_Id__c = thisTaskInfo.todo_item_id;
            myTask.Task_Name__c = thisTaskInfo.todo_item_name;
            myTask.Hours__c = thisTaskInfo.hours;
            myTask.Minute__c = thisTaskInfo.minutes;
            myTasks.add(myTask);
        }
        insert myTasks;
    }
}