/**
* ------------------------------------------------------------------------------------------------------------------------
* Apex Methods for anticipated Visualforce functionality for Opportunity Product addition.
*
* This methods anticipates the functionality for Opportunity Products Picking and addition.
* The Selected Products from the Opportunity Line Item Product Picker page will be displayed to add the Line Items corresponding to
* each of the Products. The Selected Products with entered Quanitity and Unit Price will be added as the OLIs to the Opportunity.
* ------------------------------------------------------------------------------------------------------------------------
* @title 		  CLS_CustomProductAddition	
* @author         Suyati Inc
* @created        25/09/2017
* @version		  1.0
* ------------------------------------------------------------------------------------------------------------------------
**/

public class CLS_CustomProductAddition {
    
    private Opportunity opp;
    public String opp_currency { get; set; }
    public CLS_CustomProductAddition(ApexPages.StandardController controller){
        
        opp = [Select ID, PriceBook2.Name, 
               (Select ID, PriceBookEntry.Product2ID, ProductCode 
                From OpportunityLineItems
               )
               From Opportunity
               Where ID = :controller.getId()];
    }
    
    public PageReference priceBookCheck() {
        if (pbName == null) {
            PageReference pr = New Pagereference('/oppitm/choosepricebook.jsp');
            pr.getParameters().put('id', opp.id);
            pr.getParameters().put('retURL', '/' + opp.id);
            pr.getParameters().put('saveURL', '/apex/p/opp/pickProducts?id=' + opp.id + '&retURL=' + EncodingUtil.urlEncode('/apex/p/opp/pickProducts?id=' + opp.id + '&retURL=/' + opp.id, 'UTF-8'));
            
            pr.setRedirect(true);
            return pr;
        } else{
            return null;
        }
    }
    
    public String pbName {
        get {
            return opp.PriceBook2 == null ? null : opp.PriceBook2.Name;
        }
        private set;
    }
    
    public PageReference gotoCustomMultiLine() {
        System.debug(opp.Pricebook2.Name);
        PageReference pr = Page.VF_CustomOLIEdit;
        pr.getParameters().put('id', opp.id);
        pr.setRedirect(false);
        return pr;
        
    }
    
    public class productSelection{
        public boolean isSelected {get;set;}
        public PriceBookEntry pbe {get;set;}
        
        public productSelection(PricebookEntry pbe){
            this.pbe = pbe;
            isSelected = false;
        }
    }
    public productSelection[] prods {
        get {
            if(prods == null) {
                prods = New productSelection[]{};
                    
                    for(PriceBookEntry pbe : [
                        Select UnitPrice, Product2.Name, ProductCode, Product2.Description//, Product2.RecordType.Name
                        From PriceBookEntry
                        Where PriceBook2ID = :opp.PriceBook2ID
                        AND isActive = true
                    ]){
                        prods.add(
                            New productSelection(pbe)
                        );
                    }
            }
            
            if (prods.isEmpty()) {
                apexPages.addMessage(New ApexPages.Message(ApexPages.Severity.FATAL, 'Unable to find active products'));
            }
            
            return prods;
        }
        set;
    }
    
    
    public OpportunityLineItem[] OLIs {
        get {
            if (OLIs == null) {
                OLIs = New OpportunityLineItem[]{};
                    
                    for (productSelection ps : prods) {
                        if(ps.isSelected) {
                            OLIs.add(
                                New OpportunityLineItem(
                                    OpportunityID = opp.id,
                                    UnitPrice = ps.pbe.UnitPrice,
                                    PriceBookEntryID = ps.pbe.id
                                )
                            );
                            //Add names to Id map to display on page
                            prodNames.put(ps.pbe.id, ps.pbe.Product2.Name);
                        }
                    }
                
            }
            system.debug('OLIs'+OLIs);
            return OLIs;
        }
        set;
    }
    
    public pageReference saveOLIs() {
        try {
            update opp;
        } catch (DMLException e) {
            apexPages.addMessage(New ApexPages.Message(ApexPages.Severity.FATAL, 'Error Updating Opportunity: ' + e.getDMLMessage(0)));
            return null;
            
        }
        
        for (OpportunityLineItem oli : OLIs) {
            if (oli.ServiceDate == null)
                oli.ServiceDate = date.today();
        }
        
        try {
            insert OLIs;
        } catch (DMLException e) {
            return null;
        }
        
        return gotoOpp();
    }
    
    public pageReference gotoOpp() {
        PageReference pr = New PageReference('/' + opp.id);
        return pr;
    }
    
    public Map<ID, String> prodNames {
        get {
            
            if (prodNames == null) {
                prodNames = New Map<ID, String>();
            }
            
            return prodNames;
            
        }
        private set;
    }
}