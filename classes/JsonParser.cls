public class JsonParser{
    
		public list<time_entries> time_entries {get;set;}
		public String STATUS {get;set;}
    
	public class time_entries{
		public String person_first_name{get;set;}
		public String description{get;set;}
		public Integer minutes{get;set;}
		public String ticket_id{get;set;}
		public String dateUserPerspective{get;set;}
		public String createdAt{get;set;}
		public String parentTaskName{get;set;}
		public String taskIsPrivate{get;set;}
		public String person_last_name{get;set;}
		public String parentTaskId{get;set;}
		public String invoiceNo{get;set;}
		public String company_id{get;set;}
		public String id{get;set;}
		public String project_status{get;set;}
		public String company_name{get;set;}
		public String person_id{get;set;}
		public String taskEstimatedTime{get;set;}
		public String project_name{get;set;}
		public Boolean canEdit{get;set;}
		public list<String> task_tags{get;set;}
		public list<String> tags{get;set;}
		public String taskIsSubTask{get;set;}
		public String todo_list_id{get;set;}
		public String todo_item_id{get;set;}
		public String updated_date{get;set;}
		public String taskdate{get;set;}
		public String isbilled{get;set;}
		public String has_start_time{get;set;}
		public String todo_item_name{get;set;}
		public Integer hours{get;set;}
		public String todo_list_name{get;set;}
		public String isbillable{get;set;}
		public String project_id{get;set;}
	}
}