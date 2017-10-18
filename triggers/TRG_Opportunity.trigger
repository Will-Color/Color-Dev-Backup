trigger TRG_Opportunity on Opportunity (after update) {
    
    
    Set<Id> opportunityIds = new Set<Id>();
    Map<Id,Integer> oppDateDiffMap = new Map<Id,Integer>();
    List<OpportunityLineItem> oppLIToUpdate = new List<OpportunityLineItem>();
    
    for(Opportunity opp : trigger.new){
        Opportunity oldopp = trigger.oldMap.get(opp.id);
        if(opp.CloseDate != oldopp.CloseDate){
            Integer numberDaysDue = oldopp.CloseDate.daysBetween(opp.CloseDate);
            system.debug('diffff'+numberDaysDue);
            opportunityIds.add(opp.Id);
            oppDateDiffMap.put(opp.Id, numberDaysDue);
        }
    }
    for(Opportunity oppToUpdate : [Select Id, CloseDate, StageName, (Select Id, Revenue_Start_Date__c from OpportunityLineItems) from Opportunity where Id IN: oppDateDiffMap.keySet()]){
        system.debug(oppToUpdate.CloseDate);
        for(OpportunityLineItem LIOfCurrentOpp : oppToUpdate.OpportunityLineItems){
            LIOfCurrentOpp.Revenue_Start_Date__c = LIOfCurrentOpp.Revenue_Start_Date__c + oppDateDiffMap.get(oppToUpdate.Id);
            oppLIToUpdate.add(LIOfCurrentOpp);
        }
    }
    update oppLIToUpdate;
}