public class CLS_RevScheduleEdit {
    
    private Opportunity opp;  
    public List<Revenue_Schedule__c> rsList {get;set;}
    public Map<Opportunity,Revenue_Schedule__c> oppRevenueMap {get;set;}
    public CLS_RevScheduleEdit(ApexPages.StandardController controller){
        
        opp = (Opportunity)controller.getRecord(); 
        this.rsList = [Select Id, Name, Opportunity__c, Revenue_Amount__c, Revenue_Schedule_Date__c,
                       Revenue_Schedule_Status__c, Revenue_Type__c, Weighted_Revenue_Amount__c
                       from Revenue_Schedule__c where Opportunity__c =:opp.Id];
    }
    public PageReference save(){
        update rsList;
        PageReference prevPage = new PageReference('/' + opp.Id);
        return prevPage;
    }
    public PageReference cancel(){
        PageReference prevPage = new PageReference('/' + opp.Id);
        return prevPage;
    }
    
}