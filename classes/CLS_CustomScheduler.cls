public class CLS_CustomScheduler {
    
    private Opportunity opp;  
    public List<OpportunityLineItem> oliList {get;set;}
    public Map<Opportunity,Revenue_Schedule__c> oppRevenueMap {get;set;}
    public CLS_CustomScheduler(ApexPages.StandardController controller){
        
        opp = (Opportunity)controller.getRecord(); 
        
        this.oliList = [select Id, Name, Revenue_Months__c, Revenue_Projection_Method__c, Revenue_Start_Date__c
                        from OpportunityLineItem where opportunityId =: opp.id]; 
    }
    
    public PageReference save(){
        update oliList;
        PageReference prevPage = new PageReference('/' + opp.Id);
        return prevPage;
    }
    public PageReference cancel(){
        PageReference prevPage = new PageReference('/' + opp.Id);
        return prevPage;
    }
}