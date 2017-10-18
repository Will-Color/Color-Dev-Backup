trigger TRG_OpportunityLI on OpportunityLineItem (after insert, after update, after delete) {
    
    List<Opportunity> oppList = new List<Opportunity>();
    List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
    Map<OpportunityLineItem,Id> oppLIMap = new Map<OpportunityLineItem,Id>();
    Map<OpportunityLineItem,Id> oppLIMapToDelete = new Map<OpportunityLineItem,Id>();
    Map<OpportunityLineItem,Id> oppLIMapRevMonthChanged = new Map<OpportunityLineItem,Id>();
    List<Revenue_Schedule__c> productRevenueList = new List<Revenue_Schedule__c>();
    List<Revenue_Schedule__c> insertedRevenueList = new List<Revenue_Schedule__c>();   
    List<Id> opportunityList = new List<Id>();
    Map<Id, Opportunity> opptys;
    Boolean isUpd = false;
    
    if(trigger.isUpdate){
        isUpd = true;
    }
/*------------------------------------------------------ Insert -------------------------------------------*/
    if(trigger.isInsert){
        for(OpportunityLineItem oli : trigger.new){
            oliList.add(oli);
        }
        for(OpportunityLineItem opId: oliList){
            opportunityList.add(opId.OpportunityId);
        }
        opptys = new Map<Id, Opportunity>([SELECT Id, StageName, Probability
                                           FROM Opportunity WHERE Id in :opportunityList]);
    }
    if(oliList.size()>0 && isUpd == false){
        for(OpportunityLineItem oli1 : oliList){
            Date revStartDate = oli1.Revenue_Start_Date__c;
            Integer revMonths = integer.valueOf(oli1.Revenue_Months__c);
            
            for(integer i=0;i<revMonths;i++){
                Date revScheduleDate;
                Revenue_Schedule__c newRevSchedule  = new Revenue_Schedule__c();
                Double revenueAmt = Double.valueOf(oli1.TotalPrice) / Double.valueOf(oli1.Revenue_Months__c);
                if(i==0){
                    revScheduleDate = revStartDate;
                }
                else{
                    revScheduleDate = revStartDate.addMonths(i);
                }
                
                newRevSchedule.Revenue_Amount__c = revenueAmt;
                newRevSchedule.Revenue_Type__c = oli1.Revenue_Projection_Method__c;
                newRevSchedule.Opportunity__c = oli1.OpportunityId;
                for(Id o : opptys.keySet()){
                    if(o == oli1.OpportunityId){
                        Opportunity x = opptys.get(oli1.OpportunityId);
                        newRevSchedule.Opportunity_Stage__c = x.StageName;
                        newRevSchedule.Weighted_Revenue_Amount__c = (x.Probability * revenueAmt)/100;
                    }
                }
                newRevSchedule.Revenue_Schedule_Date__c = revScheduleDate;
                newRevSchedule.Product__c = oli1.Product2Id;
                newRevSchedule.Revenue_Schedule_Status__c = 'Pipeline';
                productRevenueList.add(newRevSchedule);
            }
        }
        if(isUpd == false && productRevenueList.size()>0){
            insert productRevenueList;
        }
    }
    
    /*------------------------------------------------------ Update -------------------------------------------*/
    
    if(trigger.isUpdate){
        for(OpportunityLineItem oli : trigger.new){
            opportunityList.add(oli.OpportunityId);
            OpportunityLineItem oldOppLi = trigger.oldMap.get(oli.id);
            if(oldOppLi.Revenue_Months__c != oli.Revenue_Months__c){
                oppLIMapRevMonthChanged.put(oli, oli.Product2Id);
            }
            else{
                oppLIMap.put(oli, oli.Product2Id);
            }
        }
        opptys = new Map<Id, Opportunity>([SELECT Id, StageName, Probability
                                           FROM Opportunity WHERE Id in :opportunityList]);
    }
    if(oppLIMap.keySet().size()>0){
        List<Revenue_Schedule__c> productRevenueListToUpdate;
        for(OpportunityLineItem oliUpdated : oppLIMap.keySet()){
            productRevenueListToUpdate = new List<Revenue_Schedule__c>();
            Date revStartDate = oliUpdated.Revenue_Start_Date__c;
            Integer revMonths = integer.valueOf(oliUpdated.Revenue_Months__c);
            for(Revenue_Schedule__c oliRSChilds : [Select Id, Revenue_Schedule_Date__c, Product__c from Revenue_Schedule__c where Product__c=:oppLIMap.get(oliUpdated)]){
                productRevenueListToUpdate.add(oliRSChilds);
            }
            if(productRevenueListToUpdate.size()>0){
                for(integer i=0;i<revMonths;i++){
                    if(i==0){
                        productRevenueListToUpdate[i].Revenue_Schedule_Date__c = revStartDate;
                    }
                    else{
                        productRevenueListToUpdate[i].Revenue_Schedule_Date__c = revStartDate.addMonths(i);
                    }
                }
            }
            if(productRevenueListToUpdate.size()>0)
                update productRevenueListToUpdate;
        }
        
    }
    if(oppLIMapRevMonthChanged.keySet().size()>0){
        List<Revenue_Schedule__c> productRevenueListToDel = new List<Revenue_Schedule__c>();
        for(OpportunityLineItem oliRevMonthUpdated : oppLIMapRevMonthChanged.keySet()){
            for(Revenue_Schedule__c oliRSChilds : [Select Id, Revenue_Schedule_Date__c, Product__c from Revenue_Schedule__c where Product__c=:oppLIMapRevMonthChanged.get(oliRevMonthUpdated)]){
                system.debug(oliRSChilds);productRevenueListToDel.add(oliRSChilds);
            }
        }
        for(OpportunityLineItem oli1 : oppLIMapRevMonthChanged.keySet()){
            Date revStartDate = oli1.Revenue_Start_Date__c;
            Integer revMonths = integer.valueOf(oli1.Revenue_Months__c);
            
            for(integer i=0;i<revMonths;i++){
                
                Date revScheduleDate;
                Revenue_Schedule__c newRevSchedule  = new Revenue_Schedule__c();
                Double revenueAmt = Double.valueOf(oli1.TotalPrice) / Double.valueOf(oli1.Revenue_Months__c);
                if(i==0){
                    revScheduleDate = revStartDate;
                }
                else{
                    revScheduleDate = revStartDate.addMonths(i);
                }
                
                newRevSchedule.Revenue_Amount__c = revenueAmt;
                newRevSchedule.Revenue_Type__c = oli1.Revenue_Projection_Method__c;
                newRevSchedule.Opportunity__c = oli1.OpportunityId;
                for(Id o : opptys.keySet()){
                    if(o == oli1.OpportunityId){
                        Opportunity x = opptys.get(oli1.OpportunityId);
                        newRevSchedule.Opportunity_Stage__c = x.StageName;
                        newRevSchedule.Weighted_Revenue_Amount__c = (x.Probability * revenueAmt)/100;
                    }
                }
                newRevSchedule.Revenue_Schedule_Date__c = revScheduleDate;
                newRevSchedule.Product__c = oli1.Product2Id;
                newRevSchedule.Revenue_Schedule_Status__c = 'Pipeline';
                productRevenueList.add(newRevSchedule);
            }
        }
        if(productRevenueList.size()>0){
            insert productRevenueList;
            if(productRevenueListToDel.size()>0)
            delete productRevenueListToDel;
        }
    }
    
    /*------------------------------------------------------ Delete -------------------------------------------*/
    
    if(trigger.isDelete){
        for(OpportunityLineItem oli : trigger.old){
            oppLIMapToDelete.put(oli, oli.Product2Id);
        }
    }
    if(oppLIMapToDelete.keySet().size()>0){
        List<Revenue_Schedule__c> productRevenueListToDelete = new List<Revenue_Schedule__c>();
        for(OpportunityLineItem oliToDelete : oppLIMapToDelete.keySet()){
            for(Revenue_Schedule__c oliRSChildsToDelete : [Select Id, Product__c from Revenue_Schedule__c where Product__c=:oppLIMapToDelete.get(oliToDelete)]){
                productRevenueListToDelete.add(oliRSChildsToDelete);
            }
        }
        if(productRevenueListToDelete.size()>0)
            delete productRevenueListToDelete;
    }
}