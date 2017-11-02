public class TWTimeTrack {

	public class Time_entries {
		public String project_id;
		public String isbillable;
		public String todo_list_name;
		public String todo_item_name;
		public String isbilled;
		public String updated_date;
		public String todo_list_id;
		public List<Tags> tags;
		public Boolean canEdit;
		public String taskEstimatedTime;
		public String company_name;
		public String id;
		public String invoiceNo;
		public String person_last_name;
		public String parentTaskName;
		public String dateUserPerspective;
		public String minutes;
		public String person_first_name;
		public String description;
		public String ticket_id;
		public String createdAt;
		public String taskIsPrivate;
		public String parentTaskId;
		public String company_id;
		public String project_status;
		public String person_id;
		public String project_name;
		public List<Tags> task_tags;
		public String taskIsSubTask;
		public String todo_item_id;
		public String taskdate;
		public String has_start_time;
		public String hours;
	}
	public class Tags {
	}

	public class TWTimeTrackerWrapper {
		public List<Time_entries> time_entries;
		public String STATUS;
	}


}